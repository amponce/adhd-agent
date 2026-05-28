#!/usr/bin/env bash
# adhd-agent installer.
# Detects which agent runtimes are present on the host and mirrors SKILL.md
# into each. Idempotent — safe to re-run.
#
# Usage (one-liner):
#   curl -fsSL https://raw.githubusercontent.com/amponce/adhd-agent/main/install.sh | bash
#
# Usage (from a clone):
#   ./install.sh

set -euo pipefail

REPO_RAW="${ADHD_AGENT_RAW_BASE:-https://raw.githubusercontent.com/amponce/adhd-agent/main}"
SKILL_FILENAME="SKILL.md"

# Find the source SKILL.md. When run from a clone, use the local file.
# When piped via curl|bash, fetch from the raw URL.
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

SRC_TMP=""
cleanup() {
  if [ -n "$SRC_TMP" ]; then rm -f "$SRC_TMP"; fi
}
trap cleanup EXIT

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$SKILL_FILENAME" ]; then
  SRC="$SCRIPT_DIR/$SKILL_FILENAME"
  echo "→ Using local $SKILL_FILENAME"
else
  SRC_TMP="$(mktemp)"
  SRC="$SRC_TMP"
  echo "→ Fetching $SKILL_FILENAME from $REPO_RAW"
  curl -fsSL "$REPO_RAW/$SKILL_FILENAME" -o "$SRC"
fi

if [ ! -s "$SRC" ]; then
  echo "✗ source $SKILL_FILENAME is empty or missing" >&2
  exit 1
fi

installed=0
skipped=0

# Mirror to a runtime's skill dir if the runtime's home dir exists.
# $1 = label, $2 = home dir (e.g. ~/.claude), $3 = skill subpath
mirror_to() {
  local label="$1" home="$2" subpath="$3"
  if [ -d "$home" ]; then
    local dest="$home/$subpath"
    mkdir -p "$(dirname "$dest")"
    cp "$SRC" "$dest"
    echo "  ✓ $label → $dest"
    installed=$((installed + 1))
  else
    echo "  - $label not detected (no $home), skipping"
    skipped=$((skipped + 1))
  fi
}

echo ""
echo "Mirroring to detected agent runtimes:"
mirror_to "Claude Code" "$HOME/.claude" "skills/adhd-agent/SKILL.md"
mirror_to "Codex CLI"   "$HOME/.codex"  "skills/adhd-agent/SKILL.md"
mirror_to "Hermes Agent" "$HOME/.hermes" "skills/adhd-agent/SKILL.md"

# Install the Cursor per-project bootstrap helper.
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
HELPER="$LOCAL_BIN/bootstrap-adhd-agent"
cat > "$HELPER" <<'HELPER_SH'
#!/usr/bin/env bash
# Drop the canonical adhd-agent rule into the current Cursor project.
# Usage: cd <project> && bootstrap-adhd-agent
set -euo pipefail
for SRC in "$HOME/.claude/skills/adhd-agent/SKILL.md" \
           "$HOME/.codex/skills/adhd-agent/SKILL.md" \
           "$HOME/.hermes/skills/adhd-agent/SKILL.md"; do
  [ -f "$SRC" ] && break
done
[ -f "$SRC" ] || { echo "no canonical SKILL.md found; run install.sh first" >&2; exit 1; }
mkdir -p .cursor/rules
cp "$SRC" .cursor/rules/adhd-agent.mdc
echo "wrote .cursor/rules/adhd-agent.mdc"
echo "(for global Cursor coverage, paste SKILL.md into Settings → Rules → User Rules)"
HELPER_SH
chmod +x "$HELPER"
echo "  ✓ Cursor helper → $HELPER"

echo ""
echo "Done. Installed into $installed runtime(s), skipped $skipped."
case "$PATH" in
  *"$LOCAL_BIN"*) ;;
  *) echo "Note: $LOCAL_BIN is not on PATH. Add it to use bootstrap-adhd-agent from any directory." ;;
esac

#!/usr/bin/env bash
# package-plugin.sh
# Packages a Claude plugin directory into a ready-to-upload ZIP.
# Usage: ./package-plugin.sh
#   or:  ./package-plugin.sh <Org/plugin-name>
#
# The plugin directory is expected at <Org>/<plugin-name>/ relative to repo root.
# A valid config/config.yaml must exist before packaging.
# Some plugins may also require additional local config files.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Get plugin path ────────────────────────────────────────────────────────
if [[ $# -ge 1 ]]; then
  PLUGIN_PATH="$1"
else
  echo ""
  read -rp "Plugin path (e.g. Sales/rfp-pursuit-toolkit): " PLUGIN_PATH
fi

# Trim any trailing slash
PLUGIN_PATH="${PLUGIN_PATH%/}"

PLUGIN_DIR="$SCRIPT_DIR/$PLUGIN_PATH"
PLUGIN_NAME="$(basename "$PLUGIN_PATH")"

if [[ ! -d "$PLUGIN_DIR" ]]; then
  echo "ERROR: Directory not found: $PLUGIN_DIR"
  exit 1
fi

# ── 2. Check config/config.yaml exists ───────────────────────────────────────
# Not every plugin needs configuration. A plugin with no config/ directory is
# config-free by design, so skip validation entirely and go straight to staging.
CONFIG_FILE="$PLUGIN_DIR/config/config.yaml"

if [[ ! -d "$PLUGIN_DIR/config" ]]; then
  echo "No config/ directory - packaging as a config-free plugin."
  SKIP_CONFIG_CHECKS=1
else
  SKIP_CONFIG_CHECKS=0
fi

if [[ "$SKIP_CONFIG_CHECKS" -eq 0 && ! -f "$CONFIG_FILE" ]]; then
  echo ""
  echo "ERROR: config/config.yaml not found in $PLUGIN_DIR/config/"
  echo ""
  echo "To fix:"
  echo "  1. Copy config/config.template.yaml  →  config/config.yaml"
  echo "  2. Fill in all required fields"
  echo "  3. Re-run this script"
  exit 1
fi

# ── 3. Validate config.yaml has no unfilled placeholder values ────────────────
# Reads lines as pairs: if a key has no inline value AND the next non-empty
# non-comment line is at the same or lower indent level (i.e. it is a leaf),
# flag it as blank. Also flags known template placeholder strings.
ISSUES=()

if [[ "$SKIP_CONFIG_CHECKS" -eq 0 ]]; then

IFS=$'\n' read -r -d '' -a LINES < "$CONFIG_FILE" || true
TOTAL=${#LINES[@]}

for ((i = 0; i < TOTAL; i++)); do
  line="${LINES[$i]}"

  # Skip comments and blank lines
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ "$line" =~ ^[[:space:]]*$ ]] && continue

  # Check for template placeholder strings
  if [[ "$line" =~ "YYYY-MM-DD" || "$line" =~ "Your Name" || "$line" =~ "e.g." ]]; then
    ISSUES+=("  Unfilled placeholder → $(echo "$line" | xargs)")
    continue
  fi

  # Check for blank leaf key: "  key:" with no inline value
  if [[ "$line" =~ ^([[:space:]]*)([a-zA-Z_][a-zA-Z0-9_]*):[[:space:]]*$ ]]; then
    key_indent="${#BASH_REMATCH[1]}"

    # Look ahead to find the next non-empty non-comment line
    next_indent=-1
    for ((j = i + 1; j < TOTAL; j++)); do
      next="${LINES[$j]}"
      [[ "$next" =~ ^[[:space:]]*$ ]] && continue
      [[ "$next" =~ ^[[:space:]]*# ]] && continue
      # Get indent of next content line
      [[ "$next" =~ ^([[:space:]]*) ]]
      next_indent="${#BASH_REMATCH[1]}"
      break
    done

    # It's a leaf if: no next line found, or next line is at same/lower indent
    if [[ $next_indent -le $key_indent ]]; then
      ISSUES+=("  Blank value → $(echo "$line" | xargs)")
    fi
    # else: next line is a child → it's a parent key, skip
  fi
done

if [[ ${#ISSUES[@]} -gt 0 ]]; then
  echo ""
  echo "ERROR: config/config.yaml contains unfilled values:"
  echo ""
  for issue in "${ISSUES[@]}"; do
    echo "$issue"
  done
  echo ""
  echo "Please fill in all fields in: $CONFIG_FILE"
  exit 1
fi

echo "config/config.yaml looks good."

fi  # end SKIP_CONFIG_CHECKS guard

# ── 3b. Check plugin-specific required config files ───────────────────────────
if [[ "$PLUGIN_PATH" == "Sales/rfp-pursuit-toolkit" ]]; then
  PERSONAS_FILE="$PLUGIN_DIR/config/personas.yaml"

  if [[ ! -f "$PERSONAS_FILE" ]]; then
    echo ""
    echo "ERROR: config/personas.yaml not found in $PLUGIN_DIR/config/"
    echo ""
    echo "To fix:"
    echo "  1. Copy config/personas.template.yaml  →  config/personas.yaml"
    echo "  2. Fill in the required buyer persona definitions"
    echo "  3. Re-run this script"
    exit 1
  fi

  echo "config/personas.yaml looks good."
fi

# ── 4. Build staging copy ─────────────────────────────────────────────────────
STAGING_DIR="$(mktemp -d)"
STAGING_PLUGIN="$STAGING_DIR/$PLUGIN_NAME"

echo "Staging plugin..."
cp -r "$PLUGIN_DIR" "$STAGING_PLUGIN"

# Remove config templates and any gitignored company configs (not for
# distribution). Guarded because config-free plugins have no config/ directory.
if [[ -d "$STAGING_PLUGIN/config" ]]; then
  rm -f "$STAGING_PLUGIN/config/config.template.yaml"
  rm -f "$STAGING_PLUGIN/config/personas.template.yaml"
  find "$STAGING_PLUGIN/config" -name "*-config.yaml" -delete
fi

# Remove OS noise
find "$STAGING_PLUGIN" -name ".DS_Store" -delete
find "$STAGING_PLUGIN" -name "Thumbs.db" -delete

# Remove any existing ZIPs inside the plugin dir
find "$STAGING_PLUGIN" -name "*.zip" -delete

# ── 5. Create ZIP ─────────────────────────────────────────────────────────────
OUTPUT_ZIP="$SCRIPT_DIR/${PLUGIN_NAME}.zip"

# Remove old zip if present
rm -f "$OUTPUT_ZIP"

(cd "$STAGING_DIR" && zip -r "$OUTPUT_ZIP" "$PLUGIN_NAME" --quiet)

rm -rf "$STAGING_DIR"

echo ""
echo "Done! Plugin packaged at:"
echo "  $OUTPUT_ZIP"
echo ""
echo "Upload this ZIP to Claude Cowork > Customize > Browse plugins > Upload custom plugin."

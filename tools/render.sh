#!/usr/bin/env bash
# Regenerates the org banner and the avatar from tools/org-banner.html and
# assets/logo.svg using headless Chrome. ImageMagick cannot rasterize these
# (CSS gradients, webfonts, SVG gradients), so Chrome does the work.
#
#   ./tools/render.sh
set -euo pipefail
cd "$(dirname "$0")/.."
ROOT="$(pwd)"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

shoot() { # src w h out [scale]
  "$CHROME" --headless --disable-gpu --no-sandbox --hide-scrollbars \
    --force-device-scale-factor="${5:-1}" --window-size="$2,$3" \
    --virtual-time-budget=12000 --screenshot="$4" "file://$1" >/dev/null 2>&1
}

# Org banner, rendered at 2x so it stays crisp on retina.
shoot "$ROOT/tools/org-banner.html" 1280 440 "$ROOT/assets/org-banner.png" 2

# Avatar. GitHub crops org avatars to a rounded square, so the mark is rendered
# square with generous margin and no rounding of its own.
cat > "$TMP/logo.html" <<HTML
<!DOCTYPE html><meta charset="utf-8">
<style>html,body{margin:0;background:#100D17;width:512px;height:512px}
svg{display:block;width:512px;height:512px}</style>
$(cat "$ROOT/assets/logo.svg")
HTML
shoot "$TMP/logo.html" 512 512 "$ROOT/assets/logo.png" 2

for f in org-banner.png logo.png; do
  printf '%-18s %s\n' "$f" "$(sips -g pixelWidth -g pixelHeight "$ROOT/assets/$f" | tail -2 | tr -d ' \n')"
done

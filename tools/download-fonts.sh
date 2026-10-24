#!/usr/bin/env bash
# Downloads required fonts from Google Fonts for the org banner.
# These fonts are needed at build time to render org-banner.html correctly.
set -euo pipefail

FONTS_DIR="$(dirname "$0")/../assets/fonts"
mkdir -p "$FONTS_DIR"

# Define fonts to download: filename and Google Fonts URL
declare -A FONTS=(
  [cormorant-garamond-300.woff2]="https://fonts.gstatic.com/s/cormorantgaramond/v21/co3umX5slCNuHLi8bLeY9MK7whWMhyjypVO7abI26QOD_qE6GnM.woff2"
  [cormorant-garamond-300-italic.woff2]="https://fonts.gstatic.com/s/cormorantgaramond/v21/co3smX5slCNuHLi8bLeY9MK7whWMhyjYrGFEsdtdc62E6zd5rDDOjw.woff2"
  [cormorant-garamond-400.woff2]="https://fonts.gstatic.com/s/cormorantgaramond/v21/co3umX5slCNuHLi8bLeY9MK7whWMhyjypVO7abI26QOD_v86GnM.woff2"
  [cormorant-garamond-400-italic.woff2]="https://fonts.gstatic.com/s/cormorantgaramond/v21/co3smX5slCNuHLi8bLeY9MK7whWMhyjYrGFEsdtdc62E6zd58jDOjw.woff2"
  [cormorant-garamond-500.woff2]="https://fonts.gstatic.com/s/cormorantgaramond/v21/co3umX5slCNuHLi8bLeY9MK7whWMhyjypVO7abI26QOD_s06GnM.woff2"
  [cormorant-garamond-500-italic.woff2]="https://fonts.gstatic.com/s/cormorantgaramond/v21/co3smX5slCNuHLi8bLeY9MK7whWMhyjYrGFEsdtdc62E6zd5wDDOjw.woff2"
  [figtree-300.woff2]="https://fonts.gstatic.com/s/figtree/v9/_Xmz-HUzqDCFdgfMsYiV_F7wfS-Bs_chQF5e.woff2"
  [figtree-400.woff2]="https://fonts.gstatic.com/s/figtree/v9/_Xmz-HUzqDCFdgfMsYiV_F7wfS-Bs_d_QF5e.woff2"
  [figtree-500.woff2]="https://fonts.gstatic.com/s/figtree/v9/_Xmz-HUzqDCFdgfMsYiV_F7wfS-Bs_dNQF5e.woff2"
  [space-mono-400.woff2]="https://fonts.gstatic.com/s/spacemono/v17/i7dPIFZifjKcF5UAWdDRUEY.woff2"
)

echo "Downloading fonts to $FONTS_DIR"
for font in "${!FONTS[@]}"; do
  url="${FONTS[$font]}"
  dest="$FONTS_DIR/$font"

  if [ -f "$dest" ]; then
    # Check if it's a real font file or a 404 error page
    if head -c 4 "$dest" | od -An -tx1 | grep -q "0d 0a"; then
      # It's likely a text file (contains CR LF), download fresh
      echo "Removing invalid $font..."
      rm "$dest"
    else
      echo "Skipping $font (already present)"
      continue
    fi
  fi

  echo "Downloading $font..."
  curl -fsSL "$url" -o "$dest" || {
    echo "Error: Failed to download $font from $url" >&2
    exit 1
  }
done

echo "Done! Fonts are ready in $FONTS_DIR"

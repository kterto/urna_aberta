#!/bin/sh
# Regenerates every launcher icon and the web favicon from the SVG masters.
set -e
cd "$(dirname "$0")"
python3 gen_icons.py
for name in icon icon-maskable icon-foreground; do
  rsvg-convert -w 1024 -h 1024 "$name.svg" -o "$name.png"
done
cd ../..
dart run flutter_launcher_icons
# Favicon: drawn for small sizes, not downscaled from the launcher icon.
rsvg-convert -w 32 -h 32 assets/brand/favicon.svg -o web/favicon.png
cp assets/brand/favicon.svg web/favicon.svg
rsvg-convert -w 180 -h 180 assets/brand/icon.svg -o web/icons/apple-touch-icon.png
for size in 192 512; do
  rsvg-convert -w $size -h $size assets/brand/icon-maskable.svg -o web/icons/Icon-maskable-$size.png
done
# flutter_launcher_icons rewrites an unrelated Xcode build setting; undo it.
sed -i '' 's/GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = AppIcon;/GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;/' ios/Runner.xcodeproj/project.pbxproj

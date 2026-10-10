"""Writes the Urna Aberta icon SVGs.

The mark is the same glyph as _BallotMark in lib/app/shell.dart, on its
26-unit grid: a ballot with a check rising from the slot of a ballot box
whose front carries the five region legend keys (Regiao order N, NE, CO,
SE, S). Run `sh build_icons.sh` from this folder.
"""

SHELL = "#123A4C"
ON_SHELL = "#EEF3F1"
REGIONS = ["#6CC394", "#B08137", "#A23E16", "#184ED4", "#B43782"]  # AtlasPalette.light


def mark(stroke):
    keys = "".join(
        f'<rect x="{4 + i * 3.8:.2f}" y="17" width="2.8" height="4" fill="{c}"/>'
        for i, c in enumerate(REGIONS)
    )
    return f'''<g fill="none" stroke="{ON_SHELL}" stroke-width="{stroke}" stroke-linejoin="round" stroke-linecap="round">
      <path d="M8 11V3.2Q8 2 9.2 2H16.8Q18 2 18 3.2V11"/>
      <path d="M10.9 6.7L12.5 8.3L15.2 5.6"/>
      <rect x="1" y="11" width="24" height="13" rx="1.4"/>
    </g>
    <g stroke="none">{keys}</g>'''


def tile(size_units, cy, stroke, round_corners=False, background=True):
    s = size_units / 26
    tx = 512 - 13 * s
    ty = cy - 13 * s  # glyph spans y 1..24
    rx = ' rx="180"' if round_corners else ""
    bg = f'<rect width="1024" height="1024"{rx} fill="{SHELL}"/>' if background else ""
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
  {bg}
  <g transform="translate({tx:.1f} {ty:.1f}) scale({s:.3f})">
    {mark(stroke)}
  </g>
</svg>
'''


variants = {
    # Full-bleed square: iOS, macOS, Android legacy, web 192/512.
    "icon.svg": tile(640, 512, 1.9),
    # Web maskable: glyph diagonal inside the 80% safe circle.
    "icon-maskable.svg": tile(600, 512, 1.9),
    # Android adaptive foreground, transparent. flutter_launcher_icons insets
    # it 16% per side, so 720 lands inside the 66% safe circle.
    "icon-foreground.svg": tile(720, 512, 1.9, background=False),
    # Favicon: fills the tile, heavier strokes for 16-32 px.
    "favicon.svg": tile(900, 512, 2.4, round_corners=True),
}
for name, svg in variants.items():
    with open(name, "w") as f:
        f.write(svg)

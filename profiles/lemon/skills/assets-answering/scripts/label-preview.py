#!/usr/bin/env python3
"""Add an option label and asset ID to a Roblox asset thumbnail."""

import argparse
import re
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image", type=Path, help="Downloaded thumbnail")
    parser.add_argument("output", type=Path, help="New PNG file")
    parser.add_argument("--label", required=True, help="Short option label, such as A")
    parser.add_argument("--asset-id", required=True, help="Roblox asset ID")
    args = parser.parse_args()

    if not re.fullmatch(r"[A-Za-z0-9-]{1,12}", args.label):
        parser.error("label must contain 1–12 letters, numbers or hyphens")
    if not re.fullmatch(r"[0-9]{1,20}", args.asset_id) or int(args.asset_id) == 0:
        parser.error("asset ID must be a positive number of at most 20 digits")
    if args.output.suffix.lower() != ".png":
        parser.error("output must be a PNG file")

    with Image.open(args.image) as source:
        thumbnail = ImageOps.exif_transpose(source).convert("RGBA")
        thumbnail = ImageOps.contain(thumbnail, (736, 640), Image.Resampling.LANCZOS)

    canvas = Image.new("RGB", (800, 800), "white")
    position = ((800 - thumbnail.width) // 2, 130 + (640 - thumbnail.height) // 2)
    canvas.paste(thumbnail, position, thumbnail)

    draw = ImageDraw.Draw(canvas)
    draw.rectangle((0, 0, 800, 112), fill="#20242b")
    font_path = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    draw.text((32, 20), args.label, font=ImageFont.truetype(font_path, size=36), fill="white")
    draw.text((32, 70), f"ID: {args.asset_id}", font=ImageFont.truetype(font_path, size=24), fill="white")

    with args.output.open("xb") as output:
        canvas.save(output, format="PNG")


if __name__ == "__main__":
    main()

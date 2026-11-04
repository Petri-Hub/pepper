#!/usr/bin/env python3
"""Create a labeled Roblox asset gallery from downloaded thumbnails."""

import argparse
import re
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps

CARD_SIZE = 800
HEADER_HEIGHT = 112
GAP = 24
HEADER = "#7d3035"
FONT_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
FONT_LIST_WIDTH = 1280
FONT_ROW_HEIGHT = 164
FONT_ROW_GAP = 16


def fit_name(draw: ImageDraw.ImageDraw, name: str, font: ImageFont.FreeTypeFont, width: int) -> str:
    name = " ".join(name.split())
    if draw.textlength(name, font=font) <= width:
        return name
    while name and draw.textlength(name.rstrip() + "…", font=font) > width:
        name = name[:-1]
    return name.rstrip() + "…"


def font_rows(image: Image.Image) -> list[Image.Image]:
    """Split a transparent font sample at a clear gap, without stretching glyphs."""
    alpha = image.getchannel("A")
    bounds = alpha.getbbox()
    if not bounds:
        return [image]
    image = image.crop(bounds)
    alpha = image.getchannel("A")
    width, height = image.size
    gaps = []
    start = None
    for x in range(width + 1):
        blank = x < width and alpha.crop((x, 0, x + 1, height)).getbbox() is None
        if blank and start is None:
            start = x
        elif not blank and start is not None:
            if x - start >= 4 and width * 0.25 <= (start + x) / 2 <= width * 0.75:
                gaps.append((start, x))
            start = None
    if not gaps:
        return [image]
    left, right = min(gaps, key=lambda gap: abs((gap[0] + gap[1]) / 2 - width / 2))
    return [image.crop((0, 0, left, height)), image.crop((right, 0, width, height))]


def make_card(path: Path | None, name: str, label: str, favorite: bool, is_font: bool) -> Image.Image:
    image = None
    if path is not None:
        with Image.open(path) as source:
            image = ImageOps.exif_transpose(source).convert("RGBA")

    card = Image.new("RGBA", (CARD_SIZE, CARD_SIZE), "#20242b" if is_font else "white")
    if image is not None:
        rows = font_rows(image) if is_font else [image]
        available_height = CARD_SIZE - HEADER_HEIGHT
        row_height = available_height // len(rows)
        scale = min((CARD_SIZE - 64) / max(row.width for row in rows),
                    (row_height - 48) / max(row.height for row in rows))
        for index, row in enumerate(rows):
            row = row.resize((max(1, round(row.width * scale)), max(1, round(row.height * scale))),
                             Image.Resampling.LANCZOS)
            x = (CARD_SIZE - row.width) // 2
            y = HEADER_HEIGHT + index * row_height + (row_height - row.height) // 2
            card.alpha_composite(row, (x, y))
    draw = ImageDraw.Draw(card)
    if image is None:
        draw.rounded_rectangle((280, 310, 520, 490), radius=18, outline="#9ba1aa", width=10)
        draw.line((300, 465, 360, 395, 410, 445, 450, 405, 500, 465), fill="#9ba1aa", width=10)
        draw.line((295, 325, 505, 475), fill="#9ba1aa", width=12)
        missing_font = ImageFont.truetype(FONT_PATH, 28)
        draw.text((400, 535), "Prévia indisponível", font=missing_font, fill="#737b86", anchor="mm")
    draw.rectangle((0, 0, CARD_SIZE, HEADER_HEIGHT - 1), fill=HEADER)
    name_font = ImageFont.truetype(FONT_PATH, 32)
    label_font = ImageFont.truetype(FONT_PATH, 80)
    draw.text((32, HEADER_HEIGHT // 2), fit_name(draw, name, name_font, 610), font=name_font, fill="white", anchor="lm")
    draw.text((745, HEADER_HEIGHT // 2), label.upper(), font=label_font, fill="white", anchor="mm")
    if favorite:
        badge_font = ImageFont.truetype(FONT_PATH, 28)
        badge_text = "★  Favorita do Lemon"
        badge_width = int(draw.textlength(badge_text, font=badge_font)) + 48
        draw.rounded_rectangle((24, CARD_SIZE - 84, 24 + badge_width, CARD_SIZE - 24), radius=30, fill="#f3de91")
        draw.text((48, CARD_SIZE - 54), badge_text, font=badge_font, fill="#44351c", anchor="lm")
    mask = Image.new("L", (CARD_SIZE, CARD_SIZE), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, CARD_SIZE - 1, CARD_SIZE - 1), radius=30, fill=255)
    card.putalpha(mask)
    return card


def make_font_list(items: list[list[str]], favorites: set[str]) -> Image.Image:
    """Display complete font samples as a vertical list without distorting them."""
    height = len(items) * FONT_ROW_HEIGHT + (len(items) + 1) * FONT_ROW_GAP
    gallery = Image.new("RGBA", (FONT_LIST_WIDTH + 2 * FONT_ROW_GAP, height), (0, 0, 0, 0))
    name_font = ImageFont.truetype(FONT_PATH, 28)
    label_font = ImageFont.truetype(FONT_PATH, 27)
    badge_font = ImageFont.truetype(FONT_PATH, 20)
    for index, (label, name, image_path) in enumerate(items):
        row = Image.new("RGBA", (FONT_LIST_WIDTH, FONT_ROW_HEIGHT), "#20242b")
        draw = ImageDraw.Draw(row)
        draw.rectangle((0, 0, 4, FONT_ROW_HEIGHT), fill=HEADER)
        draw.ellipse((26, 14, 68, 56), fill=HEADER)
        draw.text((47, 35), label.upper(), font=label_font, fill="white", anchor="mm")
        favorite = label.upper() in favorites
        badge_text = "★  Favorita do Lemon"
        badge_width = int(draw.textlength(badge_text, font=badge_font)) + 32
        badge_left = FONT_LIST_WIDTH - 24 - badge_width
        draw.text((84, 35), fit_name(draw, name, name_font, badge_left - 100 if favorite else 1140),
                  font=name_font, fill="#ececf0", anchor="lm")
        if favorite:
            draw.rounded_rectangle((badge_left, 14, FONT_LIST_WIDTH - 24, 56), radius=21, fill="#f3de91")
            draw.text((badge_left + 16, 35), badge_text, font=badge_font, fill="#44351c", anchor="lm")
        if image_path == "-":
            draw.text((104, 105), "Prévia indisponível", font=name_font, fill="#a4a8b0", anchor="lm")
        else:
            with Image.open(image_path) as source:
                sample = ImageOps.exif_transpose(source).convert("RGBA")
                sample = ImageOps.contain(sample, (FONT_LIST_WIDTH - 124, 84), Image.Resampling.LANCZOS)
            row.alpha_composite(sample, (104, 68 + (84 - sample.height) // 2))
        gallery.alpha_composite(row, (FONT_ROW_GAP, FONT_ROW_GAP + index * (FONT_ROW_HEIGHT + FONT_ROW_GAP)))
    return gallery


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path, help="New PNG gallery")
    parser.add_argument("--item", action="append", nargs=3, metavar=("LETTER", "NAME", "IMAGE"), required=True,
                        help="Option letter, asset name and downloaded thumbnail path; repeat for each option")
    parser.add_argument("--favorite", action="append", default=[], metavar="LETTER",
                        help="Mark an option as Lemon's choice; repeat to mark more")
    parser.add_argument("--font", action="append", default=[], metavar="LETTER",
                        help="Show a font preview on a dark background; repeat for each font")
    parser.add_argument("--fonts", action="store_true", help="Display all items as a vertical list of font samples")
    args = parser.parse_args()
    if not 1 <= len(args.item) <= 8:
        parser.error("provide 1–8 items")
    if args.output.suffix.lower() != ".png":
        parser.error("output must be a PNG file")
    for label, name, _ in args.item:
        if not re.fullmatch(r"[A-Za-z]", label) or not name.strip():
            parser.error("each item needs a single letter and a non-empty name")
    labels = {item[0].upper() for item in args.item}
    if len(labels) != len(args.item):
        parser.error("each item must have a distinct letter")
    favorites = {label.upper() for label in args.favorite}
    if not favorites <= labels:
        parser.error("each favorite must match an item letter")
    fonts = {label.upper() for label in args.font}
    if not fonts <= labels:
        parser.error("each font must match an item letter")

    if args.fonts:
        gallery = make_font_list(args.item, favorites)
    else:
        count = len(args.item)
        columns = 1 if count == 1 else 2 if count <= 4 else 3 if count <= 6 else 4
        rows = (count + columns - 1) // columns
        gallery = Image.new("RGBA", (columns * CARD_SIZE + (columns + 1) * GAP,
                                     rows * CARD_SIZE + (rows + 1) * GAP), (0, 0, 0, 0))
        for index, (label, name, image_path) in enumerate(args.item):
            path = None if image_path == "-" else Path(image_path)
            card = make_card(path, name, label, label.upper() in favorites, label.upper() in fonts)
            x = GAP + (index % columns) * (CARD_SIZE + GAP)
            y = GAP + (index // columns) * (CARD_SIZE + GAP)
            gallery.alpha_composite(card, (x, y))

    with args.output.open("xb") as output:
        gallery.save(output, format="PNG")


if __name__ == "__main__":
    main()

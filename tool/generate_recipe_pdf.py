#!/usr/bin/env python3
"""NutriGuide tarif kitabı üretici.

`assets/recipes/*.json` içindeki bütün tarifleri tek bir PDF'e basar:
kapak, tarif listesi (içindekiler, sayfa numaralı) ve her tarifin tam
sayfası — malzeme miktarları, adımlar, makrolar, alerjenler.

Malzeme adları `lib/data/mock_ingredients.dart`, alerjen etiketleri
`lib/data/allergens.dart`, mutfak adları `lib/data/explore_data.dart`
dosyalarından okunur; PDF'e elle metin gömülmez.

Kullanım:
    python3 tool/generate_recipe_pdf.py [--locale tr|en] [-o cikti.pdf]
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from datetime import date
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    BaseDocTemplate,
    Frame,
    KeepTogether,
    NextPageTemplate,
    PageBreak,
    PageTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
)
from reportlab.platypus.tableofcontents import TableOfContents

ROOT = Path(__file__).resolve().parent.parent

# ── Tema ──────────────────────────────────────────────────────────────────
GREEN = colors.HexColor("#2E7D5B")
GREEN_DARK = colors.HexColor("#1B4D38")
GREEN_SOFT = colors.HexColor("#EAF3EE")
INK = colors.HexColor("#22292F")
MUTED = colors.HexColor("#6B7680")
RULE = colors.HexColor("#D8E2DB")

MEAL_ORDER = ["breakfast", "lunch", "dinner", "snack"]

LABELS = {
    "tr": {
        "title": "NutriGuide Tarif Kitabı",
        "subtitle": "Uygulamadaki bütün tarifler",
        "toc": "Tarif Listesi",
        "generated": "Oluşturulma tarihi",
        "recipe_count": "tarif",
        "meals": {
            "breakfast": "Kahvaltı",
            "lunch": "Öğle Yemeği",
            "dinner": "Akşam Yemeği",
            "snack": "Ara Öğün",
        },
        "ingredients": "Malzemeler",
        "steps": "Hazırlanışı",
        "servings": "porsiyon",
        "per_serving": "porsiyon başına",
        "allergens": "Alerjenler",
        "no_allergens": "Bildirilen alerjen yok",
        "calories": "kcal",
        "protein": "Protein",
        "carbs": "Karbonhidrat",
        "fat": "Yağ",
        "fiber": "Lif",
        "prep": "Hazırlık",
        "minutes": "dk",
        "diet": {
            "vegetarian": "Vejetaryen",
            "vegan": "Vegan",
            "glutenFree": "Glutensiz",
            "lactoseFree": "Laktozsuz",
        },
        "toc_note": "Tarifler öğün türüne göre gruplanmıştır; sayfa numarası "
        "her satırın sağındadır.",
        "cover_note": "Bu kitap uygulamanın tarif verisinden otomatik olarak "
        "üretilmiştir.",
        "units": {
            "g": "g",
            "ml": "ml",
            "L": "L",
            "piece": "adet",
            "tablespoon": "yemek kaşığı",
            "teaspoon": "çay kaşığı",
            "cup": "su bardağı",
            "bunch": "demet",
            "slice": "dilim",
            "pinch": "tutam",
            "clove": "diş",
        },
    },
    "en": {
        "title": "NutriGuide Recipe Book",
        "subtitle": "Every recipe in the app",
        "toc": "Recipe List",
        "generated": "Generated on",
        "recipe_count": "recipes",
        "meals": {
            "breakfast": "Breakfast",
            "lunch": "Lunch",
            "dinner": "Dinner",
            "snack": "Snack",
        },
        "ingredients": "Ingredients",
        "steps": "Method",
        "servings": "servings",
        "per_serving": "per serving",
        "allergens": "Allergens",
        "no_allergens": "No declared allergens",
        "calories": "kcal",
        "protein": "Protein",
        "carbs": "Carbs",
        "fat": "Fat",
        "fiber": "Fiber",
        "prep": "Prep",
        "minutes": "min",
        "diet": {
            "vegetarian": "Vegetarian",
            "vegan": "Vegan",
            "glutenFree": "Gluten free",
            "lactoseFree": "Lactose free",
        },
        "toc_note": "Recipes are grouped by meal type; the page number is on "
        "the right of each row.",
        "cover_note": "This book is generated automatically from the app's "
        "recipe data.",
        "units": {
            "g": "g",
            "ml": "ml",
            "L": "L",
            "piece": "piece",
            "tablespoon": "tbsp",
            "teaspoon": "tsp",
            "cup": "cup",
            "bunch": "bunch",
            "slice": "slice",
            "pinch": "pinch",
            "clove": "clove",
        },
    },
}


# ── Dart verisinden sözlükler ─────────────────────────────────────────────
def load_ingredient_names() -> dict[str, dict[str, str]]:
    src = (ROOT / "lib/data/mock_ingredients.dart").read_text(encoding="utf-8")
    names: dict[str, dict[str, str]] = {}
    pattern = re.compile(
        r"id:\s*'([^']+)',\s*\n\s*name:\s*\{'en':\s*'([^']*)',\s*'tr':\s*'([^']*)'\}"
    )
    for ing_id, en, tr in pattern.findall(src):
        names[ing_id] = {"en": en, "tr": tr}
    return names


def load_allergen_labels() -> dict[str, dict[str, str]]:
    src = (ROOT / "lib/data/allergens.dart").read_text(encoding="utf-8")
    labels: dict[str, dict[str, str]] = {}
    pattern = re.compile(
        r"'([a-z_]+)':\s*\{'en':\s*'([^']*)',\s*'tr':\s*'([^']*)'\}"
    )
    for tag, en, tr in pattern.findall(src):
        labels[tag] = {"en": en, "tr": tr}
    return labels


def load_cuisine_names() -> dict[str, dict[str, str]]:
    src = (ROOT / "lib/data/explore_data.dart").read_text(encoding="utf-8")
    start = src.index("worldCuisines")
    end = src.index("specialCategories")
    pattern = re.compile(
        r"id:\s*'([A-Za-z]+)',\s*\n\s*name:\s*\{'en':\s*'([^']*)',\s*'tr':\s*'([^']*)'\}"
    )
    return {
        cid: {"en": en, "tr": tr}
        for cid, en, tr in pattern.findall(src[start:end])
    }


def load_recipes() -> list[dict]:
    recipes: list[dict] = []
    for meal in MEAL_ORDER:
        path = ROOT / f"assets/recipes/{meal}.json"
        if not path.exists():
            continue
        recipes.extend(json.loads(path.read_text(encoding="utf-8")))
    return recipes


# ── Yardımcılar ───────────────────────────────────────────────────────────
def esc(text: str) -> str:
    return (
        str(text)
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
    )


def localized(field, locale: str, fallback: str = "") -> str:
    if isinstance(field, dict):
        return field.get(locale) or field.get("en") or fallback
    return field or fallback


def format_amount(amount: float) -> str:
    if amount is None:
        return ""
    if abs(amount - round(amount)) < 0.01:
        return str(int(round(amount)))
    return f"{amount:.1f}".rstrip("0").rstrip(".").replace(".", ",")


def register_fonts() -> tuple[str, str, str]:
    """DejaVu ailesini kaydeder — Türkçe ş/ğ/ı için gerekli."""
    candidates = [
        Path("/usr/share/fonts/truetype/dejavu"),
        Path("/usr/share/fonts/dejavu"),
    ]
    for base in candidates:
        regular = base / "DejaVuSans.ttf"
        bold = base / "DejaVuSans-Bold.ttf"
        oblique = base / "DejaVuSans-Oblique.ttf"
        if regular.exists() and bold.exists():
            pdfmetrics.registerFont(TTFont("Body", str(regular)))
            pdfmetrics.registerFont(TTFont("Body-Bold", str(bold)))
            if oblique.exists():
                pdfmetrics.registerFont(TTFont("Body-Italic", str(oblique)))
            else:
                pdfmetrics.registerFont(TTFont("Body-Italic", str(regular)))
            pdfmetrics.registerFontFamily(
                "Body", normal="Body", bold="Body-Bold", italic="Body-Italic"
            )
            return "Body", "Body-Bold", "Body-Italic"
    print(
        "HATA: DejaVu fontları bulunamadı; Türkçe karakterler bozulur.",
        file=sys.stderr,
    )
    sys.exit(1)


# ── Belge şablonu ─────────────────────────────────────────────────────────
class RecipeBook(BaseDocTemplate):
    """İçindekiler girdilerini ve PDF yer imlerini toplayan şablon."""

    def __init__(self, filename: str, **kw):
        super().__init__(filename, **kw)
        frame = Frame(
            self.leftMargin,
            self.bottomMargin,
            self.width,
            self.height,
            id="normal",
        )
        self.addPageTemplates(
            [
                PageTemplate(id="cover", frames=[frame]),
                PageTemplate(
                    id="content", frames=[frame], onPage=self.draw_furniture
                ),
            ]
        )
        self.book_title = ""
        self.bookmark_counter = 0

    def draw_furniture(self, canvas, doc):
        canvas.saveState()
        canvas.setFont("Body", 8)
        canvas.setFillColor(MUTED)
        canvas.drawString(doc.leftMargin, 12 * mm, self.book_title)
        canvas.drawRightString(
            A4[0] - doc.rightMargin, 12 * mm, str(canvas.getPageNumber())
        )
        canvas.setStrokeColor(RULE)
        canvas.setLineWidth(0.5)
        canvas.line(
            doc.leftMargin, 15 * mm, A4[0] - doc.rightMargin, 15 * mm
        )
        canvas.restoreState()

    def beforeDocument(self):
        # multiBuild birden çok geçiş yapar; sayaç sıfırlanmazsa yer imi
        # anahtarları her geçişte değişir ve içindekiler asla oturmaz.
        self.bookmark_counter = 0

    def afterFlowable(self, flowable):
        if not isinstance(flowable, Paragraph):
            return
        style_name = flowable.style.name
        if style_name not in ("SectionTitle", "RecipeTitle"):
            return
        level = 0 if style_name == "SectionTitle" else 1
        text = flowable.getPlainText()
        self.bookmark_counter += 1
        key = f"bm{self.bookmark_counter}"
        self.canv.bookmarkPage(key)
        self.canv.addOutlineEntry(text, key, level=level, closed=(level == 0))
        self.notify("TOCEntry", (level, text, self.page, key))


# ── Stiller ───────────────────────────────────────────────────────────────
def build_styles(regular: str, bold: str, italic: str):
    base = getSampleStyleSheet()
    s = {}
    s["CoverTitle"] = ParagraphStyle(
        "CoverTitle",
        parent=base["Title"],
        fontName=bold,
        fontSize=34,
        leading=40,
        textColor=GREEN_DARK,
        alignment=TA_CENTER,
    )
    s["CoverSub"] = ParagraphStyle(
        "CoverSub",
        parent=base["Normal"],
        fontName=regular,
        fontSize=14,
        leading=20,
        textColor=MUTED,
        alignment=TA_CENTER,
    )
    s["CoverMeta"] = ParagraphStyle(
        "CoverMeta",
        parent=base["Normal"],
        fontName=regular,
        fontSize=10,
        leading=16,
        textColor=MUTED,
        alignment=TA_CENTER,
    )
    s["PageTitle"] = ParagraphStyle(
        "PageTitle",
        parent=base["Heading1"],
        fontName=bold,
        fontSize=22,
        leading=27,
        spaceAfter=6,
        textColor=GREEN_DARK,
    )
    s["SectionTitle"] = ParagraphStyle(
        "SectionTitle",
        parent=base["Heading1"],
        fontName=bold,
        fontSize=20,
        leading=25,
        spaceBefore=0,
        spaceAfter=10,
        textColor=GREEN_DARK,
    )
    s["RecipeTitle"] = ParagraphStyle(
        "RecipeTitle",
        parent=base["Heading2"],
        fontName=bold,
        fontSize=14,
        leading=18,
        spaceBefore=0,
        spaceAfter=1,
        textColor=INK,
    )
    s["RecipeAlt"] = ParagraphStyle(
        "RecipeAlt",
        parent=base["Normal"],
        fontName=italic,
        fontSize=9,
        leading=12,
        textColor=MUTED,
        spaceAfter=4,
    )
    s["Body"] = ParagraphStyle(
        "Body",
        parent=base["Normal"],
        fontName=regular,
        fontSize=9.5,
        leading=13.5,
        textColor=INK,
        alignment=TA_LEFT,
    )
    s["Meta"] = ParagraphStyle(
        "Meta",
        parent=s["Body"],
        fontSize=8.5,
        leading=12,
        textColor=MUTED,
    )
    s["SubHead"] = ParagraphStyle(
        "SubHead",
        parent=base["Normal"],
        fontName=bold,
        fontSize=9.5,
        leading=13,
        textColor=GREEN,
        spaceBefore=4,
        spaceAfter=3,
    )
    s["Ingredient"] = ParagraphStyle(
        "Ingredient",
        parent=s["Body"],
        fontSize=9,
        leading=12.5,
    )
    s["Step"] = ParagraphStyle(
        "Step",
        parent=s["Body"],
        fontSize=9,
        leading=12.5,
        spaceAfter=2,
    )
    s["TOC0"] = ParagraphStyle(
        "TOC0",
        parent=base["Normal"],
        fontName=bold,
        fontSize=12,
        leading=20,
        spaceBefore=10,
        textColor=GREEN_DARK,
    )
    s["TOC1"] = ParagraphStyle(
        "TOC1",
        parent=base["Normal"],
        fontName=regular,
        fontSize=9.5,
        leading=14,
        leftIndent=10,
        textColor=INK,
    )
    return s


# ── Tarif bloğu ───────────────────────────────────────────────────────────
def recipe_flowables(recipe, locale, L, styles, ingredient_names,
                     allergen_labels, cuisine_names, width):
    other = "en" if locale == "tr" else "tr"
    name = localized(recipe.get("name"), locale, recipe["id"])
    alt_name = localized(recipe.get("name"), other, "")
    description = localized(recipe.get("description"), locale, "")

    flow = [Paragraph(esc(name), styles["RecipeTitle"])]
    if alt_name and alt_name != name:
        flow.append(Paragraph(esc(alt_name), styles["RecipeAlt"]))

    # Künye satırı: kod · mutfak · porsiyon · hazırlık · beslenme etiketleri
    bits = [recipe["id"].upper()]
    cuisines = [
        localized(cuisine_names.get(cid), locale, cid)
        for cid in recipe.get("cuisineIds", [])
    ]
    if cuisines:
        bits.append(" / ".join(cuisines))
    servings = recipe.get("servings")
    if servings:
        bits.append(f"{servings} {L['servings']}")
    prep = recipe.get("prepTimeMin")
    if prep:
        bits.append(f"{L['prep']}: {prep} {L['minutes']}")
    for tag in recipe.get("dietTags", []):
        bits.append(L["diet"].get(tag, tag))
    flow.append(Paragraph(esc("  ·  ".join(bits)), styles["Meta"]))

    if description:
        flow.append(Spacer(1, 3))
        flow.append(Paragraph(esc(description), styles["Body"]))

    # Makro şeridi
    macros = recipe.get("macros") or {}
    macro_cells = [
        f"<b>{macros.get('calories', 0)}</b> {L['calories']}",
        f"{L['protein']} <b>{macros.get('proteinG', 0)}</b> g",
        f"{L['carbs']} <b>{macros.get('carbsG', 0)}</b> g",
        f"{L['fat']} <b>{macros.get('fatG', 0)}</b> g",
        f"{L['fiber']} <b>{macros.get('fiberG', 0)}</b> g",
    ]
    macro_style = ParagraphStyle(
        "MacroCell", parent=styles["Body"], fontSize=9, leading=12,
        alignment=TA_CENTER, textColor=GREEN_DARK,
    )
    macro_table = Table(
        [[Paragraph(c, macro_style) for c in macro_cells]],
        colWidths=[width / 5.0] * 5,
    )
    macro_table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), GREEN_SOFT),
                ("BOX", (0, 0), (-1, -1), 0.5, RULE),
                ("INNERGRID", (0, 0), (-1, -1), 0.5, colors.white),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("TOPPADDING", (0, 0), (-1, -1), 4),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
            ]
        )
    )
    flow.append(Spacer(1, 5))
    flow.append(macro_table)
    flow.append(
        Paragraph(f"({L['per_serving']})", styles["Meta"])
    )

    # Malzemeler + adımlar yan yana
    quantities = recipe.get("quantities") or {}
    ing_rows = []
    for ing_id in recipe.get("ingredientIds", []):
        label = localized(ingredient_names.get(ing_id), locale, ing_id)
        qty = quantities.get(ing_id)
        amount = ""
        if qty:
            unit = L["units"].get(qty.get("unit", ""), qty.get("unit", ""))
            amount = f"{format_amount(qty.get('amount'))} {unit}".strip()
        ing_rows.append(
            Paragraph(
                f"• {esc(label)}"
                + (f" <font color='#6B7680'>— {esc(amount)}</font>"
                   if amount else ""),
                styles["Ingredient"],
            )
        )
    if not ing_rows:
        ing_rows = [Paragraph("—", styles["Ingredient"])]

    steps = recipe.get("steps") or {}
    step_list = steps.get(locale) or steps.get("en") or []
    step_rows = [
        Paragraph(f"<b>{i}.</b> {esc(step)}", styles["Step"])
        for i, step in enumerate(step_list, start=1)
    ]
    if not step_rows:
        step_rows = [Paragraph("—", styles["Step"])]

    left_col = [Paragraph(L["ingredients"], styles["SubHead"])] + ing_rows
    right_col = [Paragraph(L["steps"], styles["SubHead"])] + step_rows

    left_w = width * 0.36
    right_w = width - left_w - 6 * mm
    body_table = Table(
        [[left_col, right_col]],
        colWidths=[left_w, right_w + 6 * mm],
    )
    body_table.setStyle(
        TableStyle(
            [
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (0, -1), 0),
                ("RIGHTPADDING", (0, 0), (0, -1), 6),
                ("LEFTPADDING", (1, 0), (1, -1), 8),
                ("RIGHTPADDING", (1, 0), (1, -1), 0),
                ("TOPPADDING", (0, 0), (-1, -1), 2),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 2),
                ("LINEBEFORE", (1, 0), (1, -1), 0.5, RULE),
            ]
        )
    )
    flow.append(Spacer(1, 4))
    flow.append(body_table)

    allergens = recipe.get("allergenTags", [])
    if allergens:
        labels = [
            localized(allergen_labels.get(tag), locale, tag)
            for tag in allergens
        ]
        allergen_text = f"<b>{L['allergens']}:</b> " + ", ".join(labels)
    else:
        allergen_text = f"<b>{L['allergens']}:</b> {L['no_allergens']}"
    flow.append(Spacer(1, 3))
    flow.append(Paragraph(esc_keep_tags(allergen_text), styles["Meta"]))

    return flow


def esc_keep_tags(text: str) -> str:
    """Sadece <b> etiketlerini koruyarak kaçış yapar."""
    placeholder_open, placeholder_close = "\x00", "\x01"
    text = text.replace("<b>", placeholder_open).replace("</b>", placeholder_close)
    text = esc(text)
    return text.replace(placeholder_open, "<b>").replace(placeholder_close, "</b>")


# ── Ana akış ──────────────────────────────────────────────────────────────
def build(locale: str, output: Path) -> None:
    regular, bold, italic = register_fonts()
    styles = build_styles(regular, bold, italic)
    L = LABELS[locale]

    ingredient_names = load_ingredient_names()
    allergen_labels = load_allergen_labels()
    cuisine_names = load_cuisine_names()
    recipes = load_recipes()
    if not recipes:
        print("HATA: tarif bulunamadı.", file=sys.stderr)
        sys.exit(1)

    by_meal: dict[str, list[dict]] = {m: [] for m in MEAL_ORDER}
    for recipe in recipes:
        by_meal.setdefault(recipe.get("mealType", "other"), []).append(recipe)
    for meal in by_meal:
        by_meal[meal].sort(key=lambda r: r["id"])

    doc = RecipeBook(
        str(output),
        pagesize=A4,
        leftMargin=18 * mm,
        rightMargin=18 * mm,
        topMargin=18 * mm,
        bottomMargin=20 * mm,
        title=L["title"],
        author="NutriGuide",
        subject=L["subtitle"],
    )
    doc.book_title = L["title"]
    width = doc.width

    story = []

    # ── Kapak ─────────────────────────────────────────────────────────────
    story.append(Spacer(1, 55 * mm))
    story.append(Paragraph(esc(L["title"]), styles["CoverTitle"]))
    story.append(Spacer(1, 6 * mm))
    story.append(Paragraph(esc(L["subtitle"]), styles["CoverSub"]))
    story.append(Spacer(1, 12 * mm))

    counts = " · ".join(
        f"{L['meals'].get(m, m)} {len(by_meal.get(m, []))}"
        for m in MEAL_ORDER
        if by_meal.get(m)
    )
    story.append(
        Paragraph(
            f"<b>{len(recipes)}</b> {esc(L['recipe_count'])}",
            styles["CoverSub"],
        )
    )
    story.append(Spacer(1, 3 * mm))
    story.append(Paragraph(esc(counts), styles["CoverMeta"]))
    story.append(Spacer(1, 20 * mm))
    story.append(
        Paragraph(
            f"{esc(L['generated'])}: {date.today().isoformat()}",
            styles["CoverMeta"],
        )
    )
    story.append(Spacer(1, 2 * mm))
    story.append(Paragraph(esc(L["cover_note"]), styles["CoverMeta"]))

    # ── İçindekiler ───────────────────────────────────────────────────────
    story.append(NextPageTemplate("content"))
    story.append(PageBreak())
    story.append(Paragraph(esc(L["toc"]), styles["PageTitle"]))
    story.append(Paragraph(esc(L["toc_note"]), styles["Meta"]))
    story.append(Spacer(1, 4 * mm))

    toc = TableOfContents()
    toc.levelStyles = [styles["TOC0"], styles["TOC1"]]
    toc.dotsMinLevel = 1
    story.append(toc)

    # ── Tarifler ──────────────────────────────────────────────────────────
    for meal in MEAL_ORDER:
        meal_recipes = by_meal.get(meal) or []
        if not meal_recipes:
            continue
        story.append(PageBreak())
        story.append(
            Paragraph(
                f"{esc(L['meals'].get(meal, meal))} "
                f"<font size=11 color='#6B7680'>({len(meal_recipes)})</font>",
                styles["SectionTitle"],
            )
        )
        for index, recipe in enumerate(meal_recipes):
            block = recipe_flowables(
                recipe, locale, L, styles, ingredient_names,
                allergen_labels, cuisine_names, width,
            )
            if index:
                block = [
                    Spacer(1, 5 * mm),
                    HRule(width, A4[1] - doc.topMargin),
                    Spacer(1, 4 * mm),
                ] + block
            # Bir tarif mümkün olduğunca tek sayfada kalsın; sığmazsa
            # KeepTogether zaten kendiliğinden bölmeye izin verir.
            story.append(KeepTogether(block))

    doc.multiBuild(story)
    print(f"{output} yazıldı — {len(recipes)} tarif, {doc.page} sayfa.")


class HRule(Spacer):
    """Tarifler arasındaki ince ayırıcı çizgi.

    Çizgi tarif bloğunun içinde (KeepTogether ile birlikte) taşındığı için
    sayfanın en üstüne düşebilir; orada çizilirse başlıksız bir çizgi gibi
    görünür, o yüzden sayfa başındaysa çizilmez.
    """

    def __init__(self, width, frame_top, thickness=0.6):
        super().__init__(width, thickness)
        self.line_width = width
        self.frame_top = frame_top
        self.thickness = thickness

    def draw(self):
        _, abs_y = self.canv.absolutePosition(0, 0)
        if abs_y >= self.frame_top - 2 * mm:
            return
        self.canv.setStrokeColor(RULE)
        self.canv.setLineWidth(self.thickness)
        self.canv.line(0, 0, self.line_width, 0)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--locale", choices=["tr", "en"], default="tr")
    parser.add_argument("-o", "--output", default=None)
    args = parser.parse_args()

    default_name = (
        "NutriGuide-Tarif-Kitabi.pdf"
        if args.locale == "tr"
        else "NutriGuide-Recipe-Book.pdf"
    )
    output = Path(args.output) if args.output else ROOT / "docs" / default_name
    output.parent.mkdir(parents=True, exist_ok=True)
    build(args.locale, output)


if __name__ == "__main__":
    main()

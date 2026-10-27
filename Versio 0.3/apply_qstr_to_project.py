#!/usr/bin/env python3

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
PROJECT = Path.cwd()

FILES = [
    PROJECT / "qml/pages/FirstPage.qml",
    PROJECT / "qml/pages/FlagDaysPage.qml",
    PROJECT / "qml/pages/SearchPage.qml",
    PROJECT / "qml/pages/SettingsPage.qml",
    PROJECT / "qml/pages/YearHolidaysPage.qml",
    PROJECT / "qml/pages/DayDetailPage.qml",
    PROJECT / "qml/pages/AboutPage.qml",
    PROJECT / "qml/cover/CoverPage.qml",
]

PROP = re.compile(
    r'^(\s*)(text|title|placeholderText|description|summary|body)\s*:\s*"((?:[^"\\]|\\.)*)"(.*)$'
)


def convert(text):
    result = []

    for line in text.splitlines():
        m = PROP.match(line)

        if m and "qsTr(" not in line:
            indent, prop, value, tail = m.groups()

            if value and not value.startswith(
                ("http://", "https://", "../", "qrc:", "image://", "#")
            ):
                line = f'{indent}{prop}: qsTr("{value}"){tail}'

        result.append(line)

    text = "\n".join(result) + "\n"

    for word in [
        "sunnuntai",
        "maanantai",
        "tiistai",
        "keskiviikko",
        "torstai",
        "perjantai",
        "lauantai",
        "tammikuuta",
        "helmikuuta",
        "maaliskuuta",
        "huhtikuuta",
        "toukokuuta",
        "kesäkuuta",
        "heinäkuuta",
        "elokuuta",
        "syyskuuta",
        "lokakuuta",
        "marraskuuta",
        "joulukuuta",
    ]:
        text = text.replace(
            f'"{word}"',
            f'qsTr("{word}")'
        )

    return text


for path in FILES:
    if not path.exists():
        print("OHITETTU, puuttuu:", path)
        continue

    original = path.read_text(encoding="utf-8")

    backup = path.with_suffix(path.suffix + ".before_qstr")

    if not backup.exists():
        backup.write_text(original, encoding="utf-8")

    path.write_text(
        convert(original),
        encoding="utf-8"
    )

    print("PÄIVITETTY:", path)

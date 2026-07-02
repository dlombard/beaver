"""Minimal reporting tool. Renders rows with a formatted date column.

This is the existing 'reporting tool' referenced in the task. Extend it to let
users register custom date-format handlers.
"""
from datetime import datetime


def format_date(dt: datetime, fmt: str = "%Y-%m-%d") -> str:
    return dt.strftime(fmt)


def render_report(rows, date_fmt: str = "%Y-%m-%d") -> str:
    lines = []
    for row in rows:
        lines.append(f"{format_date(row['date'], date_fmt)}\t{row['label']}")
    return "\n".join(lines)


if __name__ == "__main__":
    sample = [
        {"date": datetime(2026, 1, 15), "label": "signup"},
        {"date": datetime(2026, 2, 3), "label": "purchase"},
    ]
    print(render_report(sample))

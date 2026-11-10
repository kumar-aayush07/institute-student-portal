
from pathlib import Path
import json

NOTICE_DIR = Path("assets/notices")
OUTPUT_FILE = NOTICE_DIR / "notices.json"

ALLOWED_EXTENSIONS = {
    ".pdf", ".png", ".jpg", ".jpeg",
    ".webp", ".gif"
}

notices = []

for file in NOTICE_DIR.iterdir():
    if file.is_file() and file.suffix.lower() in ALLOWED_EXTENSIONS:
        notices.append({
            "title": file.stem,
            "file": file.name
        })

# Numbered filenames first, highest number first.
def sort_key(notice):
    import re

    match = re.search(r"\d+", notice["title"])
    if match:
        return (0, -int(match.group()), notice["title"].lower())

    return (1, 0, notice["title"].lower())

notices.sort(key=sort_key)

OUTPUT_FILE.write_text(
    json.dumps(notices, indent=2),
    encoding="utf-8"
)

print(f"Generated notice list: {len(notices)} files found.")

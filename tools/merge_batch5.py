import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / "assets" / "thinkers_quotes.json"
BATCH = ROOT / "assets" / "more_public_quotes_batch5.json"


def load(path: Path):
    with path.open(encoding="utf-8") as f:
        return json.load(f)


def save(path: Path, data):
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def merge():
    base = load(TARGET)
    extra = load(BATCH)
    ids = {item.get("id") for item in base if item.get("id")}
    added = 0
    for item in extra:
        item_id = item.get("id")
        if not item_id or item_id in ids:
            continue
        base.append(item)
        ids.add(item_id)
        added += 1
    save(TARGET, base)
    print(f"Merged {added} quotes from {BATCH.name}")


if __name__ == "__main__":
    merge()

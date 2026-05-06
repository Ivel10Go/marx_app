import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / "assets" / "thinkers_quotes.json"
NEW = ROOT / "assets" / "new_thinkers_quotes.json"


def load_json(path: Path):
    with path.open(encoding="utf-8") as f:
        return json.load(f)


def save_json(path: Path, data):
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def merge_quotes():
    if not TARGET.exists():
        raise SystemExit(f"Target file not found: {TARGET}")
    if not NEW.exists():
        raise SystemExit(f"New quotes file not found: {NEW}")

    existing = load_json(TARGET)
    new = load_json(NEW)

    existing_ids = {q.get("id") for q in existing if q.get("id")}

    added = 0
    for q in new:
        qid = q.get("id")
        if not qid:
            continue
        if qid in existing_ids:
            continue
        existing.append(q)
        existing_ids.add(qid)
        added += 1

    if added:
        save_json(TARGET, existing)
    print(f"Merged {added} new quotes into {TARGET.name}")


if __name__ == "__main__":
    merge_quotes()

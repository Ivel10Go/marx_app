import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / "assets" / "thinkers_quotes.json"
MORE = ROOT / "assets" / "more_public_quotes.json"

def load(path: Path):
    with path.open(encoding='utf-8') as f:
        return json.load(f)

def save(path: Path, data):
    with path.open('w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def merge():
    if not TARGET.exists():
        raise SystemExit(f"Target missing: {TARGET}")
    if not MORE.exists():
        raise SystemExit(f"More file missing: {MORE}")

    base = load(TARGET)
    extra = load(MORE)
    ids = {q.get('id') for q in base if q.get('id')}
    added = 0
    for q in extra:
        qid = q.get('id')
        if not qid or qid in ids:
            continue
        base.append(q)
        ids.add(qid)
        added += 1

    if added:
        save(TARGET, base)
    print(f"Merged {added} quotes from {MORE.name} into {TARGET.name}")

if __name__ == '__main__':
    merge()

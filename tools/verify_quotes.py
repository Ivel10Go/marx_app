#!/usr/bin/env python3
import json
import os

paths = ["assets/quotes.json", "assets/thinkers_quotes.json"]
report = {}
unsourced_samples = []
max_samples = 50

def load_json(path):
    if not os.path.exists(path):
        return None
    # handle files with BOM (utf-8-sig) as well as plain utf-8
    with open(path, "r", encoding="utf-8-sig") as f:
        try:
            return json.load(f)
        except Exception as e:
            print(f"ERROR loading {path}: {e}")
            return None

for p in paths:
    data = load_json(p)
    if data is None:
        report[p] = {"error": "file not found or invalid JSON"}
        continue
    # Normalize to list of items
    if isinstance(data, dict):
        # guess common patterns
        if "quotes" in data and isinstance(data["quotes"], list):
            items = data["quotes"]
        elif "items" in data and isinstance(data["items"], list):
            items = data["items"]
        else:
            # if dict of id->obj
            items = list(data.values())
    elif isinstance(data, list):
        items = data
    else:
        items = []

    total = len(items)
    with_author = 0
    with_source = 0
    unsourced = []
    author_counts = {}
    for it in items:
        if not isinstance(it, dict):
            continue
        author = it.get("author") or it.get("creator") or it.get("person") or ""
        if author and str(author).strip():
            with_author += 1
            author_counts[author] = author_counts.get(author,0) + 1
        # check for explicit source/citation keys
        has_source = False
        for k in ("source","source_url","citation","reference","origin","work","book","year"):
            v = it.get(k)
            if v and str(v).strip():
                has_source = True
                break
        if has_source:
            with_source += 1
        else:
            unsourced.append({
                "id": it.get("id"),
                "text": (it.get("text") or it.get("quote") or it.get("content") or "")[:300],
                "author": author
            })
    report[p] = {
        "total": total,
        "with_author": with_author,
        "with_source": with_source,
        "unsourced_count": len(unsourced)
    }
    # add some samples
    unsourced_samples.extend([{"file":p, **s} for s in unsourced[:max_samples]])

# summarize top authors among unsourced samples
from collections import Counter
by_author = Counter([s.get("author") or "(unknown)" for s in unsourced_samples])
report_summary = {
    "files_analyzed": paths,
    "report": report,
    "unsourced_sample_count": len(unsourced_samples),
    "top_authors_in_unsourced_sample": by_author.most_common(20)
}

# write outputs
os.makedirs(os.path.join(os.getcwd(),"tools"), exist_ok=True)
with open(os.path.join(os.getcwd(),"tools","verification_report.json"),"w",encoding="utf-8") as f:
    json.dump(report_summary, f, ensure_ascii=False, indent=2)
with open(os.path.join(os.getcwd(),"tools","unsourced_samples.json"),"w",encoding="utf-8") as f:
    json.dump(unsourced_samples, f, ensure_ascii=False, indent=2)

print("Wrote tools/verification_report.json and tools/unsourced_samples.json")
print(json.dumps(report_summary, ensure_ascii=False))

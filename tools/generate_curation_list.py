#!/usr/bin/env python3
import json, os
from pathlib import Path

BASE = Path.cwd()
gen_path = BASE / 'assets' / 'generated_quotes.json'
out_path = BASE / 'tools' / 'curation_list.json'

with open(gen_path, 'r', encoding='utf-8-sig') as f:
    data = json.load(f)

scores = []
for it in data:
    score = 0.0
    if it.get('source'):
        score += 2.0
    diff = it.get('difficulty','').lower()
    if diff == 'advanced':
        score += 1.0
    elif diff == 'intermediate':
        score += 0.5
    # prefer entries with explanation
    if it.get('explanation_long'):
        score += 0.3
    # penalize pure duplicates (same text)
    text = (it.get('text_de') or it.get('text_original') or it.get('text') or '').strip()
    if not text:
        score -= 1.0
    # prefer entries with author (rare)
    author = (it.get('author') or '').strip()
    if author and author != '(unknown)':
        score += 1.0
    scores.append((score, it))

scores.sort(key=lambda x: x[0], reverse=True)
top_n = 200
chosen = [it for s,it in scores[:top_n]]

os.makedirs(BASE / 'tools', exist_ok=True)
with open(out_path, 'w', encoding='utf-8') as f:
    json.dump({'count': len(chosen), 'items': chosen}, f, ensure_ascii=False, indent=2)

print(f'wrote {out_path} with {len(chosen)} entries')

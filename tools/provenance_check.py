#!/usr/bin/env python3
import json
import os
import random
import urllib.parse
import urllib.request
import time

BASE = os.getcwd()
thinkers_path = os.path.join(BASE, 'assets', 'thinkers_quotes.json')
tools_dir = os.path.join(BASE, 'tools')

with open(thinkers_path, 'r', encoding='utf-8-sig') as f:
    thinkers = json.load(f)

# summary of author_type
from collections import Counter
atype = Counter()
for it in thinkers:
    at = it.get('author_type') or 'unknown'
    atype[at] += 1

summary = {'total': len(thinkers), 'author_type_counts': dict(atype)}

# provenance sample
N = 200
sample = random.sample(thinkers, min(N, len(thinkers)))
provenance = []

def wikiquote_search(text, lang='de'):
    q = urllib.parse.quote_plus(text[:200])
    url = f'https://{lang}.wikiquote.org/w/api.php?action=query&list=search&srsearch={q}&format=json&srlimit=3'
    try:
        with urllib.request.urlopen(url, timeout=12) as r:
            return json.load(r)
    except Exception as e:
        return {'error': str(e)}

for it in sample:
    txt = it.get('text_de') or it.get('text') or it.get('quote') or ''
    author = it.get('author')
    found = False
    match = None
    for lang in ('de','en'):
        res = wikiquote_search(txt, lang=lang)
        if not res:
            continue
        if 'error' in res:
            # network error or similar
            match = {'error': res['error']}
            continue
        hits = res.get('query',{}).get('search',[])
        if hits:
            found = True
            match = {'lang':lang, 'title': hits[0].get('title'), 'snippet': hits[0].get('snippet')}
            break
        time.sleep(0.3)
    provenance.append({'id': it.get('id'), 'author': author, 'text_snippet': txt[:200], 'found_on_wikiquote': found, 'match': match})

os.makedirs(tools_dir, exist_ok=True)
with open(os.path.join(tools_dir,'annotation_summary.json'),'w',encoding='utf-8') as f:
    json.dump(summary, f, ensure_ascii=False, indent=2)
with open(os.path.join(tools_dir,'provenance_samples.json'),'w',encoding='utf-8') as f:
    json.dump(provenance, f, ensure_ascii=False, indent=2)

print('wrote tools/annotation_summary.json and tools/provenance_samples.json')

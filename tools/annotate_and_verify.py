#!/usr/bin/env python3
import json
import os
import urllib.parse
import urllib.request
import time
import random

BASE = os.getcwd()
thinkers_path = os.path.join(BASE, 'assets', 'thinkers_quotes.json')
backup_path = thinkers_path + '.bak'

try:
    with open(thinkers_path, 'r', encoding='utf-8-sig') as f:
        thinkers = json.load(f)
except Exception as e:
    print('ERROR loading thinkers file:', e)
    raise

# build author->author_type map from backup if available
author_map = {}
if os.path.exists(backup_path):
    with open(backup_path, 'r', encoding='utf-8-sig') as f:
        bak = json.load(f)
    # bak may be list
    if isinstance(bak, list):
        for it in bak:
            a = it.get('author')
            t = it.get('author_type')
            if a and t:
                author_map.setdefault(a, t)
    elif isinstance(bak, dict):
        for it in (bak.get('quotes') or list(bak.values())):
            a = it.get('author')
            t = it.get('author_type')
            if a and t:
                author_map.setdefault(a, t)

# helpers for wikipedia API
def wiki_search(term, lang='de'):
    q = urllib.parse.quote(term)
    url = f'https://{lang}.wikipedia.org/w/api.php?action=query&list=search&srsearch={q}&format=json&srlimit=1'
    try:
        with urllib.request.urlopen(url, timeout=10) as r:
            return json.load(r)
    except Exception:
        return None

def wiki_get_categories(title, lang='de'):
    q = urllib.parse.quote(title)
    url = f'https://{lang}.wikipedia.org/w/api.php?action=query&prop=categories&titles={q}&format=json&cllimit=50'
    try:
        with urllib.request.urlopen(url, timeout=10) as r:
            return json.load(r)
    except Exception:
        return None

# annotate author types where missing
updated = 0
authors_to_query = set()
for it in thinkers:
    a = it.get('author') or ''
    if not it.get('author_type'):
        if a in author_map:
            it['author_type'] = author_map[a]
            updated += 1
        else:
            authors_to_query.add(a)

# query wikipedia for unknown authors (limit to first 400 unique authors)
authors_to_query = list(authors_to_query)[:400]
for a in authors_to_query:
    if not a:
        continue
    cls = None
    # try German then English
    for lang in ('de','en'):
        res = wiki_search(a, lang=lang)
        if not res:
            continue
        top = res.get('query', {}).get('search', [])
        if not top:
            continue
        title = top[0].get('title')
        cats = wiki_get_categories(title, lang=lang)
        if not cats:
            continue
        pages = cats.get('query', {}).get('pages', {})
        for p in pages.values():
            for c in p.get('categories', []) if p.get('categories') else []:
                cname = c.get('title','').lower()
                if 'politiker' in cname or 'politics' in cname or 'politician' in cname or 'regierungs' in cname:
                    cls = 'politician'
                    break
                if 'philosoph' in cname or 'philosophy' in cname:
                    cls = 'philosopher'
                    break
                if 'wissenschaft' in cname or 'physic' in cname or 'scientist' in cname or 'mathem' in cname:
                    cls = 'scientist'
                    break
                if 'künstler' in cname or 'artist' in cname or 'musician' in cname:
                    cls = 'artist'
                    break
            if cls:
                break
        if cls:
            break
        time.sleep(0.3)
    if cls:
        author_map[a] = cls
    else:
        # debug: record that we did not find classification
        pass

# apply map to all
applied = 0
for it in thinkers:
    a = it.get('author') or ''
    if not it.get('author_type'):
        if a in author_map:
            it['author_type'] = author_map[a]
            applied += 1
        else:
            it['author_type'] = 'person'

try:
    # write back updated thinkers file (backup already exists)
    with open(thinkers_path, 'w', encoding='utf-8') as f:
        json.dump(thinkers, f, ensure_ascii=False, indent=2)
except Exception as e:
    print('ERROR writing thinkers file:', e)
    raise

# Provenance verification: sample N quotes and search wikiquote
N = 200
sample = random.sample(thinkers, min(N, len(thinkers)))
provenance = []

def wikiquote_search(text, lang='de'):
    q = urllib.parse.quote_plus(text[:200])
    url = f'https://{lang}.wikiquote.org/w/api.php?action=query&list=search&srsearch={q}&format=json&srlimit=3'
    try:
        with urllib.request.urlopen(url, timeout=12) as r:
            return json.load(r)
    except Exception:
        return None

for it in sample:
    txt = it.get('text_de') or it.get('text') or it.get('quote') or ''
    author = it.get('author')
    found = False
    match_info = None
    for lang in ('de','en'):
        res = wikiquote_search(txt, lang=lang)
        if not res:
            continue
        hits = res.get('query',{}).get('search',[])
        if hits:
            found = True
            match_info = {'lang':lang, 'title': hits[0].get('title'), 'snippet': hits[0].get('snippet')}
            break
        time.sleep(0.4)
    provenance.append({'id': it.get('id'), 'author': author, 'text_snippet': txt[:200], 'found_on_wikiquote': found, 'match': match_info})

# write reports
with open(os.path.join(BASE,'tools','annotation_report.json'),'w',encoding='utf-8') as f:
    json.dump({'authors_mapped': len(author_map), 'applied_annotations': applied}, f, ensure_ascii=False, indent=2)
with open(os.path.join(BASE,'tools','provenance_samples.json'),'w',encoding='utf-8') as f:
    json.dump(provenance, f, ensure_ascii=False, indent=2)

print('annotation done', {'authors_mapped': len(author_map), 'applied_annotations': applied})
print('wrote tools/annotation_report.json and tools/provenance_samples.json')

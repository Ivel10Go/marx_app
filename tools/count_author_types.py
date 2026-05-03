#!/usr/bin/env python3
import json, os
p = os.path.join(os.getcwd(),'assets','thinkers_quotes.json')
with open(p,'r',encoding='utf-8-sig') as f:
    data = json.load(f)
from collections import Counter
c = Counter()
unknown_authors = set()
for it in data:
    at = it.get('author_type') or 'unknown'
    c[at] += 1
    if at in ('person','unknown'):
        if it.get('author') and it.get('author') not in ('(unknown)',''):
            unknown_authors.add(it.get('author'))
res = {'total': len(data), 'author_type_counts': dict(c), 'unknown_named_authors_sample': list(list(unknown_authors)[:20])}
with open(os.path.join('tools','author_type_counts.json'),'w',encoding='utf-8') as f:
    json.dump(res,f,ensure_ascii=False,indent=2)
print(res)

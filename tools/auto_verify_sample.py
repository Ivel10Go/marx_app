#!/usr/bin/env python3
import json, os, urllib.parse, urllib.request, time

BASE = os.getcwd()
curation_path = os.path.join(BASE,'tools','curation_list.json')
out_path = os.path.join(BASE,'tools','curation_verification_sample.json')

with open(curation_path,'r',encoding='utf-8-sig') as f:
    data = json.load(f).get('items', [])[:30]


def wikiquote_search(text, lang='de'):
    q = urllib.parse.quote_plus(text[:200])
    url = f'https://{lang}.wikiquote.org/w/api.php?action=query&list=search&srsearch={q}&format=json&srlimit=5'
    try:
        with urllib.request.urlopen(url, timeout=8) as r:
            return json.load(r)
    except Exception as e:
        return {'error': str(e)}

results = []
print('sample items:', len(data))
for it in data:
    txt = (it.get('text_de') or it.get('text_original') or it.get('text') or '').strip()
    author = (it.get('author') or '').strip()
    entry = dict(it)
    entry['verified'] = False
    entry['verification_matches'] = []
    if txt:
        res = wikiquote_search(txt, lang='de')
        if res and 'query' in res:
            hits = res.get('query',{}).get('search',[])
            for h in hits:
                title = h.get('title')
                snippet = h.get('snippet')
                url = 'https://de.wikiquote.org/wiki/' + urllib.parse.quote(title.replace(' ','_'))
                entry['verification_matches'].append({'source':'wikiquote','lang':'de','title':title,'snippet':snippet,'url':url})
            if hits:
                entry['verified'] = True
    results.append(entry)
    time.sleep(0.2)

with open(out_path,'w',encoding='utf-8') as f:
    json.dump(results,f,ensure_ascii=False,indent=2)

print('wrote', out_path)

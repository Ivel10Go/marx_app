#!/usr/bin/env python3
import json, os, urllib.parse, urllib.request, time

BASE = os.getcwd()
curation_path = os.path.join(BASE,'tools','curation_list.json')
out_path = os.path.join(BASE,'tools','curation_verification.json')

with open(curation_path,'r',encoding='utf-8-sig') as f:
    data = json.load(f).get('items', [])


def wikiquote_search(text, lang='de'):
    q = urllib.parse.quote_plus(text[:200])
    url = f'https://{lang}.wikiquote.org/w/api.php?action=query&list=search&srsearch={q}&format=json&srlimit=5'
    try:
        with urllib.request.urlopen(url, timeout=12) as r:
            return json.load(r)
    except Exception as e:
        return {'error': str(e)}


def wikipedia_search(term, lang='de'):
    q = urllib.parse.quote_plus(term)
    url = f'https://{lang}.wikipedia.org/w/api.php?action=query&list=search&srsearch={q}&format=json&srlimit=5'
    try:
        with urllib.request.urlopen(url, timeout=12) as r:
            return json.load(r)
    except Exception as e:
        return {'error': str(e)}

results = []
print('items to verify:', len(data))
for idx, it in enumerate(data):
    txt = (it.get('text_de') or it.get('text_original') or it.get('text') or '').strip()
    author = (it.get('author') or '').strip()
    entry = dict(it)
    entry['verified'] = False
    entry['verification_matches'] = []

    # First try Wikiquote by text
    if txt:
        for lang in ('de','en'):
            res = wikiquote_search(txt, lang=lang)
            if res is None:
                continue
            if 'error' in res:
                entry['verification_matches'].append({'lang': lang, 'error': res['error']})
                continue
            hits = res.get('query', {}).get('search', [])
            for h in hits:
                title = h.get('title')
                snippet = h.get('snippet')
                url = f'https://{lang}.wikiquote.org/wiki/' + urllib.parse.quote(title.replace(' ', '_'))
                entry['verification_matches'].append({'source':'wikiquote','lang':lang,'title':title,'snippet':snippet,'url':url})
            if hits:
                entry['verified'] = True
                break
            time.sleep(0.2)
    # If not found, try wikiquote search by author + short phrase
    if not entry['verified'] and author:
        probe = author + ' ' + (txt.split('.')[:1][0] if txt else '')
        for lang in ('de','en'):
            res = wikiquote_search(probe, lang=lang)
            if res is None:
                continue
            if 'error' in res:
                entry['verification_matches'].append({'lang': lang, 'error': res['error']})
                continue
            hits = res.get('query', {}).get('search', [])
            for h in hits:
                title = h.get('title')
                snippet = h.get('snippet')
                url = f'https://{lang}.wikiquote.org/wiki/' + urllib.parse.quote(title.replace(' ', '_'))
                entry['verification_matches'].append({'source':'wikiquote','lang':lang,'title':title,'snippet':snippet,'url':url})
            if hits:
                entry['verified'] = True
                break
            time.sleep(0.2)
    # If still not found, try Wikipedia author page search
    if not entry['verified'] and author:
        for lang in ('de','en'):
            res = wikipedia_search(author, lang=lang)
            if res is None:
                continue
            if 'error' in res:
                entry['verification_matches'].append({'lang': lang, 'error': res['error']})
                continue
            hits = res.get('query', {}).get('search', [])
            for h in hits:
                title = h.get('title')
                snippet = h.get('snippet')
                url = f'https://{lang}.wikipedia.org/wiki/' + urllib.parse.quote(title.replace(' ', '_'))
                entry['verification_matches'].append({'source':'wikipedia','lang':lang,'title':title,'snippet':snippet,'url':url})
            if hits:
                # don't mark verified, but provide candidate author pages
                break
            time.sleep(0.2)

    # debug: count matches
    entry['match_count'] = len(entry['verification_matches'])
    results.append(entry)
    # be polite
    time.sleep(0.1)

with open(out_path,'w',encoding='utf-8') as f:
    json.dump(results,f,ensure_ascii=False,indent=2)

print('wrote', out_path)

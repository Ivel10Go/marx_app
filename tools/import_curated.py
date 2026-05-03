#!/usr/bin/env python3
import csv, json, os, shutil
BASE = os.getcwd()
curated_csv = os.path.join(BASE,'tools','curated_approved.csv')
thinkers_path = os.path.join(BASE,'assets','thinkers_quotes.json')
backup = thinkers_path + '.pre_import.bak'

if not os.path.exists(curated_csv):
    print('No curated CSV found at', curated_csv)
    exit(1)

shutil.copyfile(thinkers_path, backup)

with open(thinkers_path,'r',encoding='utf-8-sig') as f:
    thinkers = json.load(f)

existing_ids = {it.get('id') for it in thinkers}
added = 0
updated = 0
with open(curated_csv,'r',encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        if not row.get('id') or not row.get('text_de') or not row.get('author'):
            continue
        item = {
            'id': row['id'].strip(),
            'text_de': row['text_de'].strip(),
            'author': row['author'].strip(),
            'source': row.get('source','').strip(),
            'year': int(row['year']) if row.get('year') and row['year'].isdigit() else None,
            'category': [c.strip() for c in row.get('category','').split(';') if c.strip()],
            'difficulty': row.get('difficulty','').strip(),
            'explanation_short': row.get('explanation_short','').strip(),
            'provenance': row.get('provenance','curated').strip()
        }
        if item['id'] in existing_ids:
            # replace existing
            for i, it in enumerate(thinkers):
                if it.get('id') == item['id']:
                    thinkers[i].update(item)
                    updated += 1
                    break
        else:
            thinkers.append(item)
            added += 1
            existing_ids.add(item['id'])

with open(thinkers_path,'w',encoding='utf-8') as f:
    json.dump(thinkers,f,ensure_ascii=False,indent=2)

print({'added':added,'updated':updated,'total_after':len(thinkers),'backup':backup})

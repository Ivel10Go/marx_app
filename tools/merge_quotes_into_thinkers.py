#!/usr/bin/env python3
import json
import os
import shutil

BASE = os.getcwd()
quotes_path = os.path.join(BASE, 'assets', 'quotes.json')
thinkers_path = os.path.join(BASE, 'assets', 'thinkers_quotes.json')
backup_path = thinkers_path + '.bak'

def load(path):
    with open(path, 'r', encoding='utf-8-sig') as f:
        return json.load(f)

# load
quotes = load(quotes_path)
thinkers = load(thinkers_path)

# normalize to lists
if isinstance(quotes, dict):
    if 'quotes' in quotes and isinstance(quotes['quotes'], list):
        quotes_list = quotes['quotes']
    else:
        quotes_list = list(quotes.values())
elif isinstance(quotes, list):
    quotes_list = quotes
else:
    quotes_list = []

if isinstance(thinkers, dict):
    if 'quotes' in thinkers and isinstance(thinkers['quotes'], list):
        thinkers_list = thinkers['quotes']
    else:
        thinkers_list = list(thinkers.values())
elif isinstance(thinkers, list):
    thinkers_list = thinkers
else:
    thinkers_list = []

# build id map for dedupe
id_map = {}
for item in thinkers_list:
    if not isinstance(item, dict):
        continue
    _id = item.get('id')
    if _id:
        id_map[_id] = item

added = 0
collision_renames = 0
for item in quotes_list:
    if not isinstance(item, dict):
        continue
    _id = item.get('id')
    if not _id:
        # create id
        import uuid
        _id = 'merged_' + uuid.uuid4().hex[:12]
        item['id'] = _id
    if _id in id_map:
        # rename new id to avoid clobber
        import uuid
        new_id = _id + '__merged_' + uuid.uuid4().hex[:6]
        item['id'] = new_id
        collision_renames += 1
    # ensure author exists
    if not item.get('author'):
        item['author'] = item.get('creator') or item.get('person') or '(unknown)'
    # mark source
    item['merged_from'] = 'assets/quotes.json'
    thinkers_list.append(item)
    id_map[item['id']] = item
    added += 1

# backup existing thinkers file
shutil.copyfile(thinkers_path, backup_path)

# write merged file (as list)
with open(thinkers_path, 'w', encoding='utf-8') as f:
    json.dump(thinkers_list, f, ensure_ascii=False, indent=2)

print(f'merged: added={added}, collisions_renamed={collision_renames}, total_thinkers={len(thinkers_list)}')

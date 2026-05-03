#!/usr/bin/env python3
import json, os, shutil
BASE = os.getcwd()
thinkers_path = os.path.join(BASE,'assets','thinkers_quotes.json')
backup = thinkers_path + '.pre_extract.bak'
generated_path = os.path.join(BASE,'assets','generated_quotes.json')

shutil.copyfile(thinkers_path, backup)

with open(thinkers_path,'r',encoding='utf-8-sig') as f:
    data = json.load(f)

attributed = []
unattributed = []
for it in data:
    author = (it.get('author') or '').strip()
    if author and author not in ('(unknown)',''):
        attributed.append(it)
    else:
        it['provenance'] = it.get('provenance') or 'generated'
        unattributed.append(it)

with open(thinkers_path,'w',encoding='utf-8') as f:
    json.dump(attributed,f,ensure_ascii=False,indent=2)
with open(generated_path,'w',encoding='utf-8') as f:
    json.dump(unattributed,f,ensure_ascii=False,indent=2)

print({'total_before':len(data),'kept_attributed':len(attributed),'moved_unattributed':len(unattributed),'backup':backup,'generated_file':generated_path})

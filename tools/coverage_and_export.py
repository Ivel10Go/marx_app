#!/usr/bin/env python3
import json, os, csv
from collections import Counter, defaultdict
BASE = os.getcwd()
thinkers_path = os.path.join(BASE,'assets','thinkers_quotes.json')
generated_path = os.path.join(BASE,'assets','generated_quotes.json')
tools_dir = os.path.join(BASE,'tools')

with open(thinkers_path,'r',encoding='utf-8-sig') as f:
    thinkers = json.load(f)
with open(generated_path,'r',encoding='utf-8-sig') as f:
    generated = json.load(f)

# categories
def collect_counts(items):
    catc = Counter()
    for it in items:
        cats = it.get('category') or []
        for c in cats:
            catc[c] += 1
    return catc

thinker_cats = collect_counts(thinkers)
gen_cats = collect_counts(generated)

# per-author counts (for persons)
author_counts = Counter()
for it in thinkers:
    a = (it.get('author') or '(unknown)').strip()
    author_counts[a] += 1

coverage = {
    'thinkers_total': len(thinkers),
    'generated_total': len(generated),
    'thinker_category_counts': dict(thinker_cats),
    'generated_category_counts': dict(gen_cats),
    'author_counts_sample_top20': author_counts.most_common(20)
}

os.makedirs(tools_dir, exist_ok=True)
with open(os.path.join(tools_dir,'coverage_report.json'),'w',encoding='utf-8') as f:
    json.dump(coverage,f,ensure_ascii=False,indent=2)

# mark generated entries with needs_review if not present, export CSV
csv_path = os.path.join(tools_dir,'generated_for_review.csv')
fields = ['id','text_de','author','category','difficulty','explanation_short','provenance']
with open(csv_path,'w',encoding='utf-8',newline='') as csvfile:
    writer = csv.DictWriter(csvfile,fieldnames=fields)
    writer.writeheader()
    for it in generated:
        if not it.get('provenance'):
            it['provenance'] = 'generated'
        it['needs_review'] = True
        row = {
            'id': it.get('id'),
            'text_de': it.get('text_de') or it.get('text_original') or it.get('text') or '',
            'author': it.get('author') or '',
            'category': ','.join(it.get('category') or []),
            'difficulty': it.get('difficulty') or '',
            'explanation_short': it.get('explanation_short') or '',
            'provenance': it.get('provenance') or ''
        }
        writer.writerow(row)

# write back generated file with needs_review annotated
with open(generated_path,'w',encoding='utf-8') as f:
    json.dump(generated,f,ensure_ascii=False,indent=2)

print('wrote tools/coverage_report.json and', csv_path)

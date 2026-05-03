#!/usr/bin/env python3
import json, os
p = os.path.join(os.getcwd(),'tools','provenance_samples.json')
with open(p,'r',encoding='utf-8') as f:
    data = json.load(f)
true_count = sum(1 for x in data if x.get('found_on_wikiquote'))
sample_total = len(data)
res = {'sample_total': sample_total, 'found_on_wikiquote': true_count}
with open(os.path.join('tools','provenance_summary.json'),'w',encoding='utf-8') as f:
    json.dump(res,f,ensure_ascii=False,indent=2)
print(res)

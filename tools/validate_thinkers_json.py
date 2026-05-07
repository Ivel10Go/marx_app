import json
from pathlib import Path

p = Path(__file__).resolve().parents[1] / 'assets' / 'thinkers_quotes.json'
print('Checking', p)
if not p.exists():
    print('File not found')
    raise SystemExit(1)

with p.open(encoding='utf-8') as f:
    data = json.load(f)

errors = []
for i, q in enumerate(data):
    missing = [k for k in ['id','text_de','text_original','author','source','year','chapter','category','difficulty','series','explanation_short','explanation_long','related_ids'] if k not in q]
    if missing:
        errors.append((i, missing))
    if 'year' in q and not isinstance(q['year'], (int, float)):
        errors.append((i, ['year_type_'+str(type(q.get('year')))]))

print('Count:', len(data))
if errors:
    print('Found', len(errors), 'issues:')
    for idx, miss in errors[:50]:
        print(' - index', idx, 'missing/invalid:', miss)
    raise SystemExit(2)

print('OK: no schema issues found')

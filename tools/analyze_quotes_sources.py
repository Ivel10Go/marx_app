import json
from pathlib import Path
from collections import Counter

path = Path('assets/quotes.json')
data = json.load(open(path, encoding='utf-8'))

print('entries', len(data))
print('distinct_sources', len({item['source'] for item in data}))
print('top_sources')
for src, count in Counter(item['source'] for item in data).most_common(50):
    print(f'{count}\t{src}')

import json
from pathlib import Path

path = Path('assets/thinkers_quotes.json')
data = json.load(open(path, encoding='utf-8'))
required = ['id', 'text_de', 'text_original', 'author', 'source', 'year', 'chapter', 'category', 'difficulty', 'series', 'explanation_short', 'explanation_long', 'related_ids']
print('count', len(data))
print('missing', sum(1 for q in data if not all(k in q for k in required)))
print('unknown', sum(1 for q in data if q.get('author') == '(unknown)'))

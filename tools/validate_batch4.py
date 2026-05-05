#!/usr/bin/env python3
import json
from pathlib import Path
from collections import Counter

file = Path("assets/thinkers_quotes.json")
data = json.load(open(file, encoding='utf-8'))

# Basic validation
print(f'Total quotes: {len(data)}')

# Check required fields
required = ['id', 'text_de', 'text_original', 'author', 'source', 'year', 'chapter', 'category', 'difficulty', 'series', 'explanation_short', 'explanation_long', 'related_ids']
missing = sum(1 for q in data if not all(k in q for k in required))
print(f'Missing required fields: {missing}')

# Check unknown authors
unknown = sum(1 for q in data if q.get('author') == '(unknown)')
print(f'Unknown authors: {unknown}')

# Category distribution
cats = []
for q in data:
    cat = q.get('category')
    if isinstance(cat, list):
        cats.extend(cat)
    else:
        cats.append(cat)

cat_counter = Counter(cats)
print(f'Category distribution:')
for cat, count in sorted(cat_counter.items()):
    print(f'  {cat}: {count}')

# Author count
authors = set(q.get('author') for q in data if q.get('author') != '(unknown)')
print(f'Unique authors: {len(authors)}')

# Top 10 authors
author_count = Counter(q.get('author') for q in data if q.get('author') != '(unknown)')
print(f'\nTop 10 authors:')
for author, count in author_count.most_common(10):
    print(f'  {author}: {count}')

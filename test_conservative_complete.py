import json
import random
from pathlib import Path

# Load thinkers_quotes.json
with open('assets/thinkers_quotes.json', 'r', encoding='utf-8') as f:
    quotes = json.load(f)

print(f"Total quotes: {len(quotes)}")
print()

# Test: Conservative User Quote Selection
conservative_terms = {
    'ordnung', 'tradition', 'staat', 'sicherheit', 'familie', 'werte', 
    'kontinuit', 'eigentum', 'verantwortung', 'burke', 'hayek'
}

marx_terms = {
    'marx', 'karl marx', 'engels', 'friedrich engels', 'briefe',
    'kommunistisch', 'kommunismus', 'manifest', 'das kapital', 'grundrisse'
}

liberal_terms = {
    'freiheit', 'liberty', 'rechte', 'plural', 'markt', 'individ', 
    'aufklaerung', 'verfassung', 'mill'
}

def normalize_text(text):
    return text.lower().replace('ä', 'ae').replace('ö', 'oe').replace('ü', 'ue').replace('ß', 'ss')

def is_marx_quote(quote):
    author = quote.get('author', '').lower()
    if 'marx' in author or 'engels' in author:
        return True
    
    text = ' '.join([
        quote.get('id', ''),
        quote.get('series', ''),
        quote.get('source', ''),
        quote.get('chapter', ''),
        ' '.join(quote.get('category', [])),
        quote.get('text_de', '')
    ]).lower()
    text_normalized = normalize_text(text)
    
    for term in marx_terms:
        if term in text_normalized:
            return True
    return False

def matches_conservative(quote):
    text = ' '.join([
        quote.get('id', ''),
        quote.get('series', ''),
        quote.get('source', ''),
        quote.get('chapter', ''),
        ' '.join(quote.get('category', [])),
        quote.get('text_de', '')
    ]).lower()
    text_normalized = normalize_text(text)
    
    for term in conservative_terms:
        if term in text_normalized:
            return True
    return False

def matches_liberal(quote):
    text = ' '.join([
        quote.get('id', ''),
        quote.get('series', ''),
        quote.get('source', ''),
        quote.get('chapter', ''),
        ' '.join(quote.get('category', [])),
        quote.get('text_de', '')
    ]).lower()
    text_normalized = normalize_text(text)
    
    for term in liberal_terms:
        if term in text_normalized:
            return True
    return False

# === SIMULATE _scopedQuotes for Conservative ===
print("=== STEP 1: _scopedQuotes (Conservative) ===")
non_marx = [q for q in quotes if not is_marx_quote(q)]
print(f"Non-Marx quotes: {len(non_marx)}")

conservative_tagged = [q for q in non_marx if matches_conservative(q)]
print(f"Conservative-tagged (non-Marx): {len(conservative_tagged)}")

if conservative_tagged:
    scoped = conservative_tagged
    print(f"→ Scoped quotes: {len(scoped)} (conservative-tagged)")
else:
    neutral = [q for q in non_marx if not matches_liberal(q)]
    if neutral:
        scoped = neutral
        print(f"→ Scoped quotes: {len(scoped)} (neutral, fallback)")
    elif non_marx:
        scoped = non_marx
        print(f"→ Scoped quotes: {len(scoped)} (all non-marx, fallback)")
    else:
        scoped = quotes
        print(f"→ Scoped quotes: {len(scoped)} (all, last resort)")

print()

# === SIMULATE _resolveCandidatePool ===
print("=== STEP 2: _resolveCandidatePool ===")
print(f"Candidates: {len(scoped)}")

if len(scoped) == 0:
    print("🔴 ERROR: No candidates!")
    exit(1)

print()

# === SIMULATE getWeightedQuotes with Author Diversity ===
print("=== STEP 3: getWeightedQuotes (with author diversity) ===")

# Count authors
author_counts = {}
for q in scoped:
    author = q.get('author', 'unknown').lower()
    author_counts[author] = author_counts.get(author, 0) + 1

# Sort counts
counts = sorted(author_counts.values())
median = counts[len(counts) // 2]
high_threshold = max(1, round(median * 1.5))

print(f"Author distribution:")
for author, count in sorted(author_counts.items(), key=lambda x: x[1], reverse=True)[:10]:
    print(f"  {author}: {count}")
print(f"Median: {median}, HighThreshold: {high_threshold}")
print()

# Calculate weights
weights = {}
for q in scoped:
    base = 1.0
    # Conservative keywords
    text = ' '.join([q.get('text_de', ''), q.get('source', ''), q.get('chapter', ''), ' '.join(q.get('category', []))])
    text_norm = normalize_text(text)
    if any(term in text_norm for term in ['ordnung', 'staat', 'tradition', 'sicherheit', 'familie', 'werte', 'kontinuit', 'verantwortung', 'eigentum']):
        base += 1.2
    
    # Author diversity
    author = q.get('author', 'unknown').lower()
    count = author_counts.get(author, 0)
    if count > high_threshold:
        base *= 0.7  # Over-represented
    elif count < (median // 2) and count > 0:
        base *= 1.3  # Under-represented
    
    weights[q['id']] = base

# Expand by weight
weighted = []
for q in scoped:
    score = weights[q['id']]
    multiplier = max(1, round(score * 10))
    for _ in range(multiplier):
        weighted.append(q)

print(f"Final weighted pool: {len(weighted)} (expanded from {len(scoped)})")
print()

if len(weighted) == 0:
    print("🔴 ERROR: Weighted pool is empty!")
    exit(1)

print("✅ Conservative user WILL get a quote!")
print(f"Expected first quote author: {weighted[0]['author']}")

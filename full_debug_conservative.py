import json

# Load thinkers_quotes.json
with open('assets/thinkers_quotes.json', 'r', encoding='utf-8') as f:
    quotes = json.load(f)

print(f"Total quotes in DB: {len(quotes)}")
print()

# Simulate Conservative user filtering  (from daily_content_resolver.dart)
conservative_terms = {
    'ordnung', 'tradition', 'staat', 'sicherheit', 'familie', 'werte', 
    'kontinuit', 'eigentum', 'verantwortung', 'burke', 'hayek'
}

marx_terms = {
    'marx', 'karl marx', 'engels', 'friedrich engels', 'briefe',
    'kommunistisch', 'kommunismus', 'manifest', 'das kapital', 'grundrisse'
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

# Step 1: _scopedQuotes for Conservative
print("STEP 1: _scopedQuotes()")
non_marx = [q for q in quotes if not is_marx_quote(q)]
conservative_tagged = [q for q in non_marx if matches_conservative(q)]
print(f"  Non-Marx quotes: {len(non_marx)}")
print(f"  Conservative-tagged (non-Marx): {len(conservative_tagged)}")

scoped = conservative_tagged if conservative_tagged else non_marx
print(f"  → Scoped quotes: {len(scoped)}")
print()

# Step 2: _resolveCandidatePool for Conservative
print("STEP 2: _resolveCandidatePool()")
candidates = scoped  # For conservative, if scoped has content, use it
print(f"  Candidates: {len(candidates)}")
if len(candidates) == 0:
    print("  🔴 NO CANDIDATES - User gets NO QUOTE!")
    exit(1)
print()

# Step 3: getWeightedQuotes (PersonalizationService)
print("STEP 3: getWeightedQuotes()")
# All quotes get base score 1.0, so all will be in weighted list
weighted = []
for q in candidates:
    score = 1.0
    # Conservative keywords boost
    text_normalized = normalize_text(' '.join([q.get('text_de', ''), q.get('source', ''), q.get('chapter', ''), ' '.join(q.get('category', []))]))
    if any(term in text_normalized for term in ['ordnung', 'staat', 'tradition', 'sicherheit', 'familie', 'werte', 'kontinuit']):
        score += 1.0
    
    multiplier = max(1, round(score * 10))
    for _ in range(multiplier):
        weighted.append(q)

print(f"  Candidates: {len(candidates)}")
print(f"  Weighted pool size (after expansion): {len(weighted)}")
print()

if len(weighted) == 0:
    print("❌ WEIGHTED POOL IS EMPTY!")
    exit(1)

print("✅ Conservative user WILL get a quote")
print()

# Show distribution
conservative_high = [q for q in weighted if any(term in normalize_text(' '.join([q.get('text_de', ''), q.get('source', '')])) for term in ['ordnung', 'staat', 'tradition', 'sicherheit', 'familie', 'werte', 'kontinuit'])]
print(f"Quote distribution in weighted pool:")
print(f"  - Conservative-tagged: {len(conservative_high)} / {len(weighted)} ({100*len(conservative_high)/len(weighted):.1f}%)")
print(f"  - Other: {len(weighted)-len(conservative_high)} ({100*(len(weighted)-len(conservative_high))/len(weighted):.1f}%)")

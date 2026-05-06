import json
from pathlib import Path

# Load thinkers_quotes.json
with open('assets/thinkers_quotes.json', 'r', encoding='utf-8') as f:
    quotes = json.load(f)

# Conservative keyword terms (from daily_content_resolver.dart)
conservative_terms = {
    'ordnung', 'tradition', 'staat', 'sicherheit', 'familie', 'werte', 
    'kontinuit', 'eigentum', 'verantwortung', 'burke', 'hayek'
}

# Marx marker terms
marx_terms = {
    'marx', 'karl marx', 'engels', 'friedrich engels', 'briefe',
    'kommunistisch', 'kommunismus', 'manifest der kommunistischen partei',
    'das kapital', 'grundrisse'
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
non_marx_quotes = [q for q in quotes if not is_marx_quote(q)]
conservative_matches = [q for q in non_marx_quotes if matches_conservative(q)]

print(f"Step 1: _scopedQuotes")
print(f"  Non-Marx quotes: {len(non_marx_quotes)}")
print(f"  Conservative-matched (non-Marx): {len(conservative_matches)}")
scoped_quotes = conservative_matches if conservative_matches else non_marx_quotes
print(f"  → Scoped quotes (after fallback): {len(scoped_quotes)}")
print()

# Step 2: _resolveCandidatePool for Conservative
# For conservative users with scoped quotes:
candidates = scoped_quotes if scoped_quotes else non_marx_quotes
print(f"Step 2: _resolveCandidatePool")
print(f"  Candidates for Conservative: {len(candidates)}")
print()

# Step 3: Check if weighted will be empty
# The weightScoring adds to base 1.0, so all quotes should get score >= 1.0
# This means all should be included in weighted list
print(f"Step 3: Weighted quote generation")
print(f"  - All {len(candidates)} quotes will be included (base score >= 1.0)")
print(f"  - Weighted list WILL NOT be empty")
print()

if len(candidates) > 0:
    print("✅ Conservative user SHOULD get a quote")
else:
    print("❌ Conservative user will get NO quote (Exception!)")
    
# Let's also check what happens with only 1 available quote
print()
print("--- Edge case: What if only 1 Conservative quote exists? ---")
if len(conservative_matches) == 1:
    print("⚠️  Only 1 Conservative-tagged quote in database!")
    print("    This could cause repeated daily quotes.")
elif len(conservative_matches) > 5:
    print(f"✅ {len(conservative_matches)} Conservative quotes available - good diversity")

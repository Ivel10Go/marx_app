import json
from pathlib import Path

# Load thinkers_quotes.json
with open('assets/thinkers_quotes.json', 'r', encoding='utf-8') as f:
    quotes = json.load(f)

# Conservative keyword terms
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
    # Check author
    author = quote.get('author', '').lower()
    if 'marx' in author or 'engels' in author:
        return True
    
    # Check text
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

# Analyze
total = len(quotes)
marx_quotes = sum(1 for q in quotes if is_marx_quote(q))
non_marx = total - marx_quotes
conservative_tagged = sum(1 for q in quotes if matches_conservative(q))
conservative_non_marx = sum(1 for q in quotes if not is_marx_quote(q) and matches_conservative(q))

print(f"📊 Quote Pool Analysis")
print(f"Total quotes: {total}")
print(f"Marx quotes: {marx_quotes} ({100*marx_quotes/total:.1f}%)")
print(f"Non-Marx quotes: {non_marx} ({100*non_marx/total:.1f}%)")
print()
print(f"Conservative-tagged quotes: {conservative_tagged} ({100*conservative_tagged/total:.1f}%)")
print(f"Conservative non-Marx quotes: {conservative_non_marx} ({100*conservative_non_marx/non_marx:.1f}% of non-Marx)")
print()
print(f"⚠️  Conservative User Pool Size: {conservative_non_marx} quotes available")
if conservative_non_marx < 10:
    print(f"   🔴 PROBLEM: Only {conservative_non_marx} quotes for Conservative users!")

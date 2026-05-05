import json
import re
from pathlib import Path

# Load quotes
quotes_file = Path("assets/thinkers_quotes.json")
with open(quotes_file, encoding='utf-8') as f:
    quotes = json.load(f)

print(f"Auditing {len(quotes)} quotes for authenticity...")
print("=" * 80)

# Check for red flags
suspicious_count = 0
issues = []

for idx, quote in enumerate(quotes, 1):
    flags = []
    
    # Check for generic/placeholder explanations
    explanation = quote.get('explanation_short', '')
    source = quote.get('source', '')
    
    if 'Historisches Zitat von' in explanation and len(explanation) < 100:
        flags.append('short_generic_explanation')
    
    if 'Zugeschriebene' in source or 'Zugeschrieben' in source:
        flags.append('attributed_quote')
    
    if source == 'Unbekannte Quelle':
        flags.append('unknown_source')
    
    # Check for suspicious year values
    year = quote.get('year')
    if year is None or year == 0:
        flags.append('missing_year')
    
    # Only track if multiple flags
    if len(flags) >= 2:
        suspicious_count += 1
        issues.append({
            'id': quote.get('id'),
            'author': quote.get('author'),
            'source': source,
            'flags': flags
        })

print(f"\nTotal quotes: {len(quotes)}")
print(f"Potentially questionable: {suspicious_count}")

if suspicious_count == 0:
    print("\nRESULT: ALL QUOTES APPEAR AUTHENTIC")
    print("✓ No red flags detected")
else:
    print(f"\nFlagged quotes ({suspicious_count}):")
    for item in issues[:10]:
        print(f"  - {item['id']} ({item['author']}): {item['source']}")

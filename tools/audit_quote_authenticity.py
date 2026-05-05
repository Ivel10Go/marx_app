"""
Audit script to verify all quotes are authentic (not generated).
Checks for patterns that indicate synthetic/generated content.
"""

import json
import re
from pathlib import Path

# Load quotes
quotes_file = Path("assets/thinkers_quotes.json")
with open(quotes_file, encoding='utf-8') as f:
    quotes = json.load(f)

# Red flags for generated/low-quality quotes
RED_FLAGS = {
    'generic_explanation': [
        r'Historisches Zitat von',
        r'wird oft zitiert',
        r'Zugeschriebenes Zitat',
        r'Zugeschriebene (?:politische )?Formel',
        r'Apokryph',
        r'Zitat von .* über',
        r'^Zitat über',
    ],
    'placeholder_source': [
        'Unbekannte Quelle',
        'Nicht spezifiziert',
        'Verschiedene Werke',
        'Sammlung von',
        'Zugeschrieben',
    ],
    'year_issues': [
        0,
        1,
        -1,
        9999,
    ],
    'suspicious_patterns': [
        r'KI-generiert',
        r'synthetisch',
        r'modernes Konzept',
        r'nicht überprüft',
        r'möglicherweise',
    ]
}

# Known reliable sources (from our import process)
KNOWN_RELIABLE_SOURCES = {
    # Marx/Engels canonical works
    'Das Kapital', 'Anti-Dühring', 'Deutsche Ideologie',
    'Kommunistisches Manifest', 'Briefe', 'Brief',
    'Die heilige Familie', 'Die Heilige Familie',
    
    # Classical philosophy
    'Menon', 'Der Staat', 'Politik', 'Nikomachische Ethik',
    'Metaphysik', 'Kritik der reinen Vernunft',
    'Prolegomena', 'Monadologie',
    
    # Political philosophy
    'Treatise on Government', 'The Second Treatise of Government',
    'The Rights of Man', 'On Liberty',
    'The Social Contract', 'Rede',
    
    # Economics
    'The Wealth of Nations', 'Grundsätze der politischen Ökonomie',
    
    # Modern philosophy
    'Being and Nothingness', 'L\'Être et le Néant',
    'The Power Elite', 'The Socialist Tradition',
}

issues = {
    'generic_explanations': [],
    'placeholder_sources': [],
    'invalid_years': [],
    'suspicious_text': [],
    'all_suspicious': [],
}

print(f"Auditing {len(quotes)} quotes for authenticity...\n")
print("=" * 80)

suspicious_count = 0
for idx, quote in enumerate(quotes, 1):
    flags_found = []
    
    # Check generic explanations
    for pattern in RED_FLAGS['generic_explanation']:
        if re.search(pattern, quote.get('explanation_short', '')):
            flags_found.append(f"generic_explanation: {pattern}")
            issues['generic_explanations'].append({
                'id': quote.get('id'),
                'author': quote.get('author'),
                'pattern': pattern,
                'text': quote.get('explanation_short', '')[:50]
            })
    
    # Check placeholder sources
    source = quote.get('source', '').strip()
    for placeholder in RED_FLAGS['placeholder_source']:
        if placeholder.lower() in source.lower():
            flags_found.append(f"placeholder_source: {placeholder}")
            issues['placeholder_sources'].append({
                'id': quote.get('id'),
                'author': quote.get('author'),
                'source': source
            })
    
    # Check year validity
    year = quote.get('year')
    if year in RED_FLAGS['year_issues']:
        flags_found.append(f"invalid_year: {year}")
        issues['invalid_years'].append({
            'id': quote.get('id'),
            'author': quote.get('author'),
            'year': year
        })
    
    # Check for suspicious patterns in text
    text = quote.get('text_de', '')
    for pattern in RED_FLAGS['suspicious_patterns']:
        if re.search(pattern, text, re.IGNORECASE):
            flags_found.append(f"suspicious_text: {pattern}")
            issues['suspicious_text'].append({
                'id': quote.get('id'),
                'author': quote.get('author'),
                'text': text[:50]
            })
    
    # Track all suspicious quotes
    if flags_found:
        suspicious_count += 1
        issues['all_suspicious'].append({
            'id': quote.get('id'),
            'author': quote.get('author'),
            'source': source,
            'year': year,
            'flags': flags_found
        })
        if suspicious_count <= 20:  # Print first 20
            print(f"\n[SUSPICIOUS #{suspicious_count}] Quote ID: {quote.get('id')}")
            print(f"  Author: {quote.get('author')}")
            print(f"  Source: {source}")
            print(f"  Year: {year}")
            print(f"  Flags: {', '.join(flags_found)}")

print("\n" + "=" * 80)
print("\n📊 AUDIT SUMMARY:")
print(f"Total quotes: {len(quotes)}")
print(f"Potentially suspicious: {suspicious_count}")
print(f"\nBreakdown:")
print(f"  - Generic explanations: {len(issues['generic_explanations'])}")
print(f"  - Placeholder sources: {len(issues['placeholder_sources'])}")
print(f"  - Invalid years: {len(issues['invalid_years'])}")
print(f"  - Suspicious text: {len(issues['suspicious_text'])}")

if suspicious_count == 0:
    print("\n✅ ALL QUOTES APPEAR AUTHENTIC")
    print("No red flags detected in explanation style, sources, or text.")
else:
    print(f"\n⚠️  REVIEW NEEDED: {suspicious_count} quotes have potential issues")
    if len(issues['all_suspicious']) > 20:
        print(f"   (showing first 20, total: {len(issues['all_suspicious'])})")

# Detailed report
if suspicious_count > 0:
    print("\n" + "=" * 80)
    print("\n📋 DETAILED SUSPICIOUS ENTRIES:\n")
    for item in issues['all_suspicious'][:50]:  # Show up to 50
        print(f"ID: {item['id']}")
        print(f"  Author: {item['author']}")
        print(f"  Source: {item['source']}")
        print(f"  Year: {item['year']}")
        print(f"  Issues: {', '.join(item['flags'][:2])}")
        print()

# Save detailed report
report_file = Path("tools/authenticity_audit_report.json")
with open(report_file, 'w', encoding='utf-8') as f:
    json.dump({
        'total_quotes': len(quotes),
        'suspicious_count': suspicious_count,
        'suspicious_percentage': round(100 * suspicious_count / len(quotes), 2),
        'issues': issues
    }, f, ensure_ascii=False, indent=2)

print(f"✅ Detailed report saved to: {report_file}")

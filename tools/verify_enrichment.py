#!/usr/bin/env python3
import json
from pathlib import Path

thinkers = json.load(open('assets/thinkers_quotes.json', encoding='utf-8'))
report = json.load(open('tools/enrich_explanations_report.json', encoding='utf-8'))

print('✓ Enrichment completed!')
print(f"  Modified: {report['total_modified']} quotes")
print(f"  Processed: {report['total_processed']} quotes")
print(f"  Timestamp: {report['timestamp']}")
print(f"  Method: {report['method']}")
print(f"  Backup: {Path(report['backup_path']).name}")

# Verify changes
generic_count = 0
for quote in thinkers:
    short = quote.get('explanation_short', '').strip()
    long = quote.get('explanation_long', '').strip()
    if 'Zitat von' in short or 'Historisches Zitat' in long:
        generic_count += 1

print(f"\nVerification:")
print(f"  Remaining generic: {generic_count}")
print(f"  Total quotes: {len(thinkers)}")

# Show examples
print(f"\nExamples of enriched explanations:")
for i, q in enumerate(thinkers[200:210]):
    print(f"\n{q['id']}:")
    print(f"  Text: {q['text_de'][:70]}")
    print(f"  Short: {q['explanation_short'][:100]}...")
    print(f"  Long: {q['explanation_long'][:120]}...")

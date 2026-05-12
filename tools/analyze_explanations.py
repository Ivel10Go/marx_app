#!/usr/bin/env python3
"""
Analyze current explanation quality in thinkers_quotes.json
"""

import json
from pathlib import Path
from collections import defaultdict

THINKERS_PATH = Path(__file__).parent.parent / 'assets' / 'thinkers_quotes.json'
GENERATED_PATH = Path(__file__).parent.parent / 'assets' / 'generated_quotes.json'

def analyze_file(path, name):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    print(f"\n{'='*60}")
    print(f"Analysis of {name} ({len(data)} quotes)")
    print(f"{'='*60}\n")
    
    # Kategorisiere Erklärungen
    generic_count = 0
    short_count = 0
    good_count = 0
    empty_count = 0
    generic_examples = []
    
    for quote in data:
        short = quote.get('explanation_short', '').strip()
        long = quote.get('explanation_long', '').strip()
        
        if not short or not long:
            empty_count += 1
        elif 'Zitat von' in short or 'Historisches Zitat' in long or len(long) < 60:
            generic_count += 1
            if len(generic_examples) < 3:
                generic_examples.append({
                    'id': quote.get('id'),
                    'text': quote.get('text_de', '')[:80],
                    'short': short[:80],
                    'long': long[:150]
                })
        elif len(long) < 80:
            short_count += 1
        else:
            good_count += 1
    
    total = len(data)
    print(f"Empty explanations: {empty_count} ({100*empty_count//total}%)")
    print(f"Generic/Template explanations: {generic_count} ({100*generic_count//total}%)")
    print(f"Short/Incomplete explanations: {short_count} ({100*short_count//total}%)")
    print(f"Already good explanations: {good_count} ({100*good_count//total}%)")
    
    print(f"\n--- Examples of generic explanations ---\n")
    for ex in generic_examples:
        print(f"ID: {ex['id']}")
        print(f"  Text: {ex['text']}")
        print(f"  Short: {ex['short']}")
        print(f"  Long: {ex['long']}")
        print()
    
    return {
        'total': total,
        'empty': empty_count,
        'generic': generic_count,
        'short': short_count,
        'good': good_count
    }

# Analyze both files
stats_thinkers = analyze_file(THINKERS_PATH, 'thinkers_quotes.json')
stats_generated = analyze_file(GENERATED_PATH, 'generated_quotes.json')

print(f"\n{'='*60}")
print("SUMMARY")
print(f"{'='*60}")
print(f"\nTotal quotes needing enrichment: {stats_thinkers['generic'] + stats_thinkers['short'] + stats_generated['generic'] + stats_generated['short']}")
print(f"Priority for enrichment: {stats_thinkers['generic'] + stats_generated['generic']} (generic)")

#!/usr/bin/env python3
"""
Analyze UE/AE conversion problems
Test cases and issues with current normalize_umlauts.py
"""

from pathlib import Path
import json

# Import the current normalization function
import sys
sys.path.insert(0, str(Path(__file__).parent))

# Simulate the current algorithm to test
def normalize_string_current(text: str) -> str:
    """Current normalization function (from normalize_umlauts.py)"""
    if not isinstance(text, str):
        return text
    
    result = []
    i = 0
    while i < len(text):
        # Check for 'ue' -> 'ü' (but not in 'queue' or similar English words)
        if i + 1 < len(text) and text[i:i+2].lower() == 'ue':
            # Check context - if preceded by consonant or at start, likely German
            if i == 0 or (i > 0 and text[i-1] not in 'aeiouäöü'):
                if i + 2 >= len(text) or text[i+2] not in 'aeiouäöü':
                    result.append('ü' if text[i] == 'u' else 'Ü')
                    i += 2
                    continue
        
        # Check for 'ae' -> 'ä'
        if i + 1 < len(text) and text[i:i+2].lower() == 'ae':
            if i == 0 or (i > 0 and text[i-1] not in 'aeiouäöü'):
                if i + 2 >= len(text) or text[i+2] not in 'aeiouäöü':
                    result.append('ä' if text[i] == 'a' else 'Ä')
                    i += 2
                    continue
        
        # Check for 'oe' -> 'ö'
        if i + 1 < len(text) and text[i:i+2].lower() == 'oe':
            if i == 0 or (i > 0 and text[i-1] not in 'aeiouäöü'):
                if i + 2 >= len(text) or text[i+2] not in 'aeiouäöü':
                    result.append('ö' if text[i] == 'o' else 'Ö')
                    i += 2
                    continue
        
        result.append(text[i])
        i += 1
    
    return ''.join(result)

# Test cases
test_cases = [
    # English words that should NOT be converted
    ("queue", "queue", "English: queue should NOT become qüü"),
    ("aesthetic", "aesthetic", "English: aesthetic should NOT become ästhetic"),
    ("Caesar", "Caesar", "Name: Caesar should stay (or be Cäsar, but consistent)"),
    ("Michael", "Michael", "Name: Michael should stay"),
    
    # German words that SHOULD be converted
    ("schöne", "schöne", "German: schöne (already correct)"),
    ("Schiße", "Schiße", "German: Schiße (already correct)"),
    ("ueberall", "überall", "German: ueberall -> überall"),
    ("Aedchen", "Ädchen", "German: Aedchen -> Ädchen"),
    ("oeffnen", "öffnen", "German: oeffnen -> öffnen"),
    
    # Mixed cases
    ("Die Suche nach der Wahrheit ist eine Queue", 
     "Die Suche nach der Wahrheit ist eine Queue",
     "Mixed: queue in German context should NOT change"),
    
    # Plural/Conjugation
    ("QueueSystem", "QueueSystem", "English: QueueSystem should not change"),
    ("Fuehrer", "Führer", "German: Fuehrer -> Führer"),
    
    # Edge cases
    ("" , "", "Empty string"),
    ("ABC", "ABC", "No umlaut letters"),
    ("UE", "Ü", "Uppercase UE at start -> Ü"),
]

print("╔════════════════════════════════════════════════════════════════╗")
print("║           UE/AE Conversion Problem Analysis                   ║")
print("╚════════════════════════════════════════════════════════════════╝\n")

failures = []
passes = []

for input_text, expected, description in test_cases:
    result = normalize_string_current(input_text)
    passed = result == expected
    
    status = "✓ PASS" if passed else "✗ FAIL"
    print(f"{status}: {description}")
    print(f"  Input:    {input_text}")
    print(f"  Expected: {expected}")
    print(f"  Got:      {result}")
    
    if not passed:
        failures.append((input_text, expected, result, description))
    else:
        passes.append(description)
    print()

print(f"\n{'='*70}")
print(f"Results: {len(passes)} pass, {len(failures)} fail")
print(f"{'='*70}\n")

if failures:
    print("FAILURES THAT NEED FIXING:\n")
    for inp, exp, got, desc in failures:
        print(f"• {desc}")
        print(f"  Input: '{inp}' | Expected: '{exp}' | Got: '{got}'")
        print()

# Check actual data
print("SCANNING ACTUAL DATA FOR PROBLEMS:\n")

thinkers_path = Path(__file__).parent.parent / 'assets' / 'thinkers_quotes.json'
with open(thinkers_path, 'r', encoding='utf-8') as f:
    quotes = json.load(f)

# Look for potential problems
suspicious = []
for quote in quotes:
    for field in ['text_de', 'explanation_short', 'explanation_long']:
        text = quote.get(field, '')
        if 'queue' in text.lower() or 'Qu' in text or 'qu' in text:
            suspicious.append((quote['id'], field, text[:100]))

if suspicious:
    print(f"Found {len(suspicious)} suspicious patterns (q/Q):")
    for qid, field, text in suspicious[:10]:
        print(f"  {qid} ({field}): {text}...")
else:
    print("No 'queue' patterns found in data (good!)")

# Look for actual conversion artifacts
print("\nLooking for actual encoding issues (Ã characters)...\n")

encoding_issues = []
for quote in quotes:
    for field in ['text_de', 'text_original', 'explanation_short', 'explanation_long']:
        text = quote.get(field, '')
        if 'Ã' in text or 'ã' in text:
            encoding_issues.append((quote['id'], field, text[:80]))

if encoding_issues:
    print(f"Found {len(encoding_issues)} encoding issues (Ã = broken Unicode):")
    for qid, field, text in encoding_issues[:10]:
        print(f"  {qid} ({field}): ...{text}...")
    print(f"\nTotal encoding issues to fix: {len(encoding_issues)}")
else:
    print("No encoding issues found (good!)")

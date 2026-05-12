#!/usr/bin/env python3
"""
Test the improved normalize_umlauts function
"""

import sys
from pathlib import Path

# Add tools directory to path
sys.path.insert(0, str(Path(__file__).parent))

from normalize_umlauts import normalize_string

# Test cases
test_cases = [
    # English words that should NOT be converted
    ("queue", "queue", "English: queue should NOT become qüü"),
    ("aesthetic", "aesthetic", "English: aesthetic should NOT change"),
    ("Caesar", "Caesar", "Name: Caesar should NOT change"),
    ("Michael", "Michael", "Name: Michael should NOT change"),
    
    # German words that SHOULD be converted
    ("schöne", "schöne", "German: schöne (already correct)"),
    ("ueberall", "überall", "German: ueberall -> überall"),
    ("Aedchen", "Ädchen", "German: Aedchen -> Ädchen"),
    ("oeffnen", "öffnen", "German: oeffnen -> öffnen"),
    
    # Mixed cases
    ("Die Queue ist lang", "Die Queue ist lang", "Mixed: queue in German context should NOT change"),
    ("Fuehrer", "Führer", "German: Fuehrer -> Führer"),
    
    # Edge cases
    ("", "", "Empty string"),
    ("ABC", "ABC", "No umlaut letters"),
]

print("╔════════════════════════════════════════════════════════════════╗")
print("║       Testing Improved normalize_umlauts.py                   ║")
print("╚════════════════════════════════════════════════════════════════╝\n")

failures = []
passes = 0

for input_text, expected, description in test_cases:
    result = normalize_string(input_text)
    passed = result == expected
    
    status = "✓ PASS" if passed else "✗ FAIL"
    print(f"{status}: {description}")
    print(f"  Input:    {input_text}")
    print(f"  Expected: {expected}")
    print(f"  Got:      {result}")
    
    if not passed:
        failures.append((input_text, expected, result, description))
    else:
        passes += 1
    print()

print(f"\n{'='*70}")
print(f"Results: {passes}/{len(test_cases)} passed")
print(f"{'='*70}\n")

if failures:
    print("❌ FAILURES:\n")
    for inp, exp, got, desc in failures:
        print(f"• {desc}")
        print(f"  Input: '{inp}' → Got: '{got}' (expected '{exp}')")
else:
    print("✅ ALL TESTS PASSED!")

sys.exit(0 if not failures else 1)

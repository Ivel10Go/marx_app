#!/usr/bin/env python3
"""
Fix broken UTF-8 encoding in quote database.
Converts double-encoded UTF-8 sequences back to correct Unicode.

Examples:
  "Ãœ" (Ã + œ) → "Ü" (U-umlaut)
  "Ã¤" (Ã + ¤) → "ä" (a-umlaut)
  "Ã¼" (Ã + ¼) → "ü" (u-umlaut)
  "Ã„" (Ã + „) → "Ä" (A-umlaut)
  "Ã–" (Ã + –) → "Ö" (O-umlaut)
  "Ã³" (Ã + ³) → "ó" (o-acute)
  "Ã¤" (Ã + ¤) → "ä" (a-umlaut)
  "Ã©" (Ã + ©) → "é" (e-acute)
"""

import json
import re
from pathlib import Path
from datetime import datetime

# Mapping of broken sequences to correct characters
ENCODING_FIXES = {
    'Ãœ': 'Ü',
    'ãœ': 'ü',
    'Ã„': 'Ä',
    'ã„': 'ä',
    'Ã–': 'Ö',
    'ã–': 'ö',
    'Ã¶': 'ö',
    'ÃŸ': 'ß',
    'Ã¸': 'ø',
    'Ã¤': 'ä',
    'Ã¡': 'á',
    'Ã©': 'é',
    'Ã³': 'ó',
    'Ãš': 'Ú',
    'Ã¼': 'ü',
    'Ã§': 'ç',
    'Ã½': 'ý',
    'Ã ': 'à',
    'Ã¢': 'â',
    'Ã®': 'î',
    'Ã´': 'ô',
    'Ã«': 'ë',
    'Ã¹': 'ù',
    'Â': '',  # Remove stray byte marks
}

def fix_encoding(text: str) -> str:
    """Fix double-encoded UTF-8 sequences"""
    if not isinstance(text, str):
        return text
    
    result = text

    # First try generic mojibake repairs for common broken encodings.
    if any(marker in result for marker in ('Ã', 'Â', 'ã')):
        for encoding in ('cp1252', 'latin1'):
            try:
                repaired = result.encode(encoding).decode('utf-8')
                result = repaired
                break
            except (UnicodeEncodeError, UnicodeDecodeError):
                continue

    for broken, fixed in ENCODING_FIXES.items():
        result = result.replace(broken, fixed)
    
    return result

def fix_dict_encoding(obj):
    """Recursively fix encoding in dictionary"""
    if isinstance(obj, dict):
        return {k: fix_dict_encoding(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [fix_dict_encoding(item) for item in obj]
    elif isinstance(obj, str):
        return fix_encoding(obj)
    else:
        return obj

def count_encoding_issues(data):
    """Count encoding issues in data"""
    count = 0
    markers = ('Ã', 'Â', 'ã')
    for item in data:
        for value in item.values():
            if isinstance(value, str):
                for broken in markers:
                    if broken in value:
                        count += value.count(broken)
    return count

def main():
    thinkers_path = Path(__file__).parent.parent / 'assets' / 'thinkers_quotes.json'
    backup_dir = Path(__file__).parent / 'backups'
    backup_dir.mkdir(exist_ok=True)
    
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║            UTF-8 Encoding Repair Tool                         ║")
    print("╚════════════════════════════════════════════════════════════════╝\n")
    
    # Load data
    print(f"Loading {thinkers_path.name}...")
    with open(thinkers_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Count issues before
    issues_before = count_encoding_issues(data)
    print(f"Found {issues_before} encoding issues\n")
    
    if issues_before == 0:
        print("No encoding issues found. Exiting.")
        return
    
    # Create backup
    backup_path = backup_dir / f"thinkers_quotes.json.pre_encoding_fix_{datetime.now().strftime('%Y%m%d_%H%M%S')}.bak"
    with open(thinkers_path, 'r', encoding='utf-8') as f:
        original = f.read()
    with open(backup_path, 'w', encoding='utf-8') as f:
        f.write(original)
    print(f"✓ Backup created: {backup_path.name}\n")
    
    # Fix encoding
    print("Fixing encoding issues...")
    fixed_data = fix_dict_encoding(data)
    
    # Count issues after
    issues_after = count_encoding_issues(fixed_data)
    print(f"✓ Fixed {issues_before - issues_after} issues")
    print(f"  Remaining issues: {issues_after}\n")
    
    # Save fixed data
    with open(thinkers_path, 'w', encoding='utf-8') as f:
        json.dump(fixed_data, f, ensure_ascii=False, indent=2)
    
    print(f"✓ Saved to {thinkers_path.name}")
    print(f"\nBefore: {issues_before} issues")
    print(f"After:  {issues_after} issues")
    
    # Show examples
    print(f"\n--- Examples of fixes ---\n")
    example_count = 0
    for item in fixed_data:
        if example_count >= 5:
            break
        for field, value in item.items():
            if isinstance(value, str) and any(original_item[field] != value for original_item in data):
                print(f"{item['id']} ({field}):")
                # Find the fix in original
                orig_val = [x[field] for x in data if x['id'] == item['id']][0]
                print(f"  Before: {orig_val[:80]}")
                print(f"  After:  {value[:80]}")
                print()
                example_count += 1

if __name__ == '__main__':
    main()

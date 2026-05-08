#!/usr/bin/env python3
"""
Normalize German umlauts in JSON and Dart files.
Converts ue->ü, ae->ä, oe->ö in German text.
"""

import json
import re
from pathlib import Path
from typing import Any, Dict

def should_normalize_ue(text: str, pos: int) -> bool:
    """Check if 'ue' at position should be normalized to 'ü'."""
    # Don't normalize if followed by another letter (e.g., 'uel' in 'Duel')
    if pos + 2 < len(text) and text[pos + 2].isalpha():
        # Exception: allow in certain contexts
        # For German: 'ue' at end of word or before punctuation is usually 'ü'
        return not text[pos + 2:pos + 3].isalpha() or text[pos + 2:pos + 3] in [' ', '.', ',', '!', '?', '"', "'", '(', ')', ';', ':']
    return True

def normalize_string(text: str) -> str:
    """Normalize umlauts in a string."""
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

def normalize_dict_values(obj: Any) -> Any:
    """Recursively normalize all string values in a dictionary or list."""
    if isinstance(obj, dict):
        return {k: normalize_dict_values(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [normalize_dict_values(item) for item in obj]
    elif isinstance(obj, str):
        return normalize_string(obj)
    else:
        return obj

def normalize_json_file(file_path: Path) -> None:
    """Normalize umlauts in a JSON file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        normalized = normalize_dict_values(data)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(normalized, f, ensure_ascii=False, indent=2)
        
        print(f"✓ Normalized {file_path}")
    except Exception as e:
        print(f"✗ Error processing {file_path}: {e}")

def normalize_dart_file(file_path: Path) -> None:
    """Normalize umlauts in a Dart file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Normalize strings in single and double quotes
        # This is a simple approach that handles most cases
        normalized = normalize_string(content)
        
        if normalized != content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(normalized)
            print(f"✓ Normalized {file_path}")
        else:
            print(f"  No changes needed for {file_path}")
    except Exception as e:
        print(f"✗ Error processing {file_path}: {e}")

def main():
    """Main function to normalize all JSON and Dart files."""
    project_root = Path(__file__).parent.parent
    
    # Normalize JSON files in assets/
    print("Normalizing JSON files...")
    assets_dir = project_root / 'assets'
    if assets_dir.exists():
        for json_file in assets_dir.glob('*.json'):
            normalize_json_file(json_file)
    
    # Normalize Dart files in lib/
    print("\nNormalizing Dart files...")
    lib_dir = project_root / 'lib'
    if lib_dir.exists():
        for dart_file in lib_dir.rglob('*.dart'):
            normalize_dart_file(dart_file)
    
    print("\n✓ Umlaut normalization complete!")

if __name__ == '__main__':
    main()

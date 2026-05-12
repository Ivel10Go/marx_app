#!/usr/bin/env python3
"""
Normalize German umlauts in JSON and Dart files.
Converts ue->ü, ae->ä, oe->ö in German text.
Improved with context-aware detection to avoid false positives in English words.
"""

import json
import re
from pathlib import Path
from typing import Any, Dict

# Common English words containing 'ue', 'ae', 'oe' that should NOT be converted
ENGLISH_WORDS_UE = {
    'queue', 'queues', 'queued', 'queueing', 'queued', 'queuing',
    'rogue', 'rogues',
    'vague', 'vaguely', 'vagueness',
    'league', 'leagues',
    'plague', 'plagues',
    'opaque', 'opaquely',
    'clue', 'clues', 'clued', 'cluing',
    'glue', 'glued', 'gluing',
    'blue', 'blues',
    'true', 'truer',
    'flue', 'flues',
    'sue', 'sued', 'suing',
    'cue', 'cued', 'cuing',
    'due', 'dues', 'duet',
    'fuel', 'fueled', 'fueling',
    'cruel', 'cruelly',
    'duel', 'dueled', 'dueling',
    'residue', 'residues',
    'tissue', 'tissues',
    'statue', 'statues',
    'value', 'values', 'valued',
    'continue', 'continued', 'continuing',
    'avenue', 'avenues',
    'revenue', 'revenues',
    'technique', 'techniques',
    'antique', 'antiques',
    'boutique', 'boutiques',
}

ENGLISH_WORDS_AE = {
    'aesthetic', 'aesthetics', 'aesthetically',
    'caesium', 'caesar',
    'aerate', 'aeration',
    'aerial', 'aero',
    'daemon', 'daemons',
    'aeon', 'aeons',
    'aegis',
    'maestro', 'maestros',
    'algae', 'alga',
    'larvae', 'larva',
    'formulae', 'formula',
}

ENGLISH_WORDS_OE = {
    'poem', 'poems',
    'poet', 'poets', 'poetic',
    'phoenix',
}

# Common English names (proper nouns) that might contain these patterns
ENGLISH_NAMES = {
    'Michael', 'Michaels', 'michael',
    'Caesar', 'Caesars', 'caesar',
    'Rafael', 'Rafaels', 'rafael',
    'Israel', 'Israeli', 'israel',
    'Morales', 'Rosales', 'morales', 'rosales',
    'Que', 'Ques', 'que',
    'Jose', 'Miguel', 'jose', 'miguel',
    'Daniela', 'daniela',
}

def is_likely_english(text: str, pos: int, pattern: str) -> bool:
    """
    Determine if a pattern (ue/ae/oe) at position is likely English
    by checking surrounding context.
    """
    # Extract the word containing this pattern
    word_start = pos
    while word_start > 0 and text[word_start - 1].isalpha():
        word_start -= 1
    
    word_end = pos + 2
    while word_end < len(text) and text[word_end].isalpha():
        word_end += 1
    
    word = text[word_start:word_end].lower()
    
    # Check against known English words
    if pattern == 'ue' and word in ENGLISH_WORDS_UE:
        return True
    if pattern == 'ae' and word in ENGLISH_WORDS_AE:
        return True
    if pattern == 'oe' and word in ENGLISH_WORDS_OE:
        return True
    if word in ENGLISH_NAMES:
        return True
    
    # Check if word is in English word lists (basic heuristic)
    # For longer words ending in consonant + pattern, more likely to be German
    # For shorter English-looking patterns, be conservative
    
    # If it's an English-looking word (common endings like -ue, -tion, etc), skip
    if re.match(r'^[a-z]*(que|sue|rue|ue)$', word, re.IGNORECASE):
        return True
    
    return False

def normalize_string(text: str) -> str:
    """Normalize umlauts in a string with improved context awareness."""
    if not isinstance(text, str):
        return text
    
    result = []
    i = 0
    while i < len(text):
        # Check for 'ue' -> 'ü'
        if i + 1 < len(text) and text[i:i+2].lower() == 'ue':
            if not is_likely_english(text, i, 'ue'):
                # Check context - if preceded by consonant or at start, likely German
                if i == 0 or (i > 0 and text[i-1] not in 'aeiouäöü'):
                    if i + 2 >= len(text) or text[i+2] not in 'aeiouäöü':
                        result.append('ü' if text[i] == 'u' else 'Ü')
                        i += 2
                        continue
        
        # Check for 'ae' -> 'ä'
        if i + 1 < len(text) and text[i:i+2].lower() == 'ae':
            if not is_likely_english(text, i, 'ae'):
                if i == 0 or (i > 0 and text[i-1] not in 'aeiouäöü'):
                    if i + 2 >= len(text) or text[i+2] not in 'aeiouäöü':
                        result.append('ä' if text[i] == 'a' else 'Ä')
                        i += 2
                        continue
        
        # Check for 'oe' -> 'ö'
        if i + 1 < len(text) and text[i:i+2].lower() == 'oe':
            if not is_likely_english(text, i, 'oe'):
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

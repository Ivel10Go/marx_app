#!/usr/bin/env python3
"""
Normalize German umlauts in JSON and Dart files.
Uses context-aware normalization to avoid false replacements
like "Quelle" -> "Qülle" or "aktuell" -> "aktüll".
"""

import json
from pathlib import Path
import re
from typing import TypeAlias

JsonLike: TypeAlias = (
    dict[str, "JsonLike"] | list["JsonLike"] | str | int | float | bool | None
)

# Word fragments where "ue"/"ae"/"oe" are usually not umlaut substitutions.
# We intentionally keep this list compact and conservative.
_NO_UMLAUT_PATTERNS = (
    "que",
    "uel",
    "uell",
    "euer",
    "neue",
    "treue",
)

_UE_WHITELIST = (
    "ueber",
    "fuer",
    "mueller",
    "muen",
    "muench",
    "duess",
    "gruen",
    "frueh",
)
_AE_WHITELIST = ("aeh", "aeus", "jaeh", "maed", "zaeh", "aerz")
_OE_WHITELIST = ("oek", "oel", "oef", "goet", "koel", "oest")


def _replace_with_case(pair: str, replacement: str) -> str:
    if pair[0].isupper():
        return replacement.upper()
    return replacement


def _should_replace_pair(word: str, index: int, pair: str) -> bool:
    lower = word.lower()
    tail = lower[index:]

    # Never replace after q in German/French/English "qu" words.
    if index > 0 and lower[index - 1] == "q":
        return False

    # Avoid common non-umlaut patterns.
    for fragment in _NO_UMLAUT_PATTERNS:
        if tail.startswith(fragment):
            return False

    # Conservative allow-list for replacements.
    if pair == "ue":
        return any(tail.startswith(prefix) for prefix in _UE_WHITELIST)
    if pair == "ae":
        return any(tail.startswith(prefix) for prefix in _AE_WHITELIST)
    if pair == "oe":
        return any(tail.startswith(prefix) for prefix in _OE_WHITELIST)
    return False

def normalize_string(text: str) -> str:
    """Normalize umlauts in a string with conservative context checks."""
    if not isinstance(text, str):
        return text

    def normalize_word(word: str) -> str:
        out = []
        i = 0
        while i < len(word):
            if i + 1 < len(word):
                pair = word[i:i + 2]
                pair_lower = pair.lower()
                if pair_lower in ("ue", "ae", "oe") and _should_replace_pair(
                    word,
                    i,
                    pair_lower,
                ):
                    repl = {"ue": "ü", "ae": "ä", "oe": "ö"}[pair_lower]
                    out.append(_replace_with_case(pair, repl))
                    i += 2
                    continue
            out.append(word[i])
            i += 1
        return "".join(out)

    return re.sub(r"[A-Za-zÄÖÜäöüß]+", lambda m: normalize_word(m.group(0)), text)

def normalize_dict_values(obj: JsonLike) -> JsonLike:
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

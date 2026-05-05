#!/usr/bin/env python3
import json
from datetime import datetime
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
THINKERS_PATH = BASE / 'assets' / 'thinkers_quotes.json'
EXPANDED_PATH = BASE / 'assets' / 'thinkers_quotes_expanded.json'
BACKUP_DIR = BASE / 'tools' / 'backups'
REPORT_PATH = BASE / 'tools' / 'promote_thinkers_expanded_to_thinkers_report.json'
TARGET_COUNT = 400

REQUIRED_FIELDS = [
    'id', 'text_de', 'text_original', 'author', 'source', 'year', 'chapter',
    'category', 'difficulty', 'series', 'explanation_short', 'explanation_long',
    'related_ids',
]


def load_json(path):
    with open(path, 'r', encoding='utf-8') as handle:
        data = json.load(handle)
    if not isinstance(data, list):
        raise ValueError(f'{path} must contain a JSON array')
    return data


def norm(value):
    return ' '.join(str(value or '').strip().lower().split())


def has_required_fields(item):
    return all(key in item for key in REQUIRED_FIELDS)


def make_unique_id(base_id, used_ids):
    candidate = base_id
    index = 2
    while candidate in used_ids:
        candidate = f'{base_id}__{index}'
        index += 1
    used_ids.add(candidate)
    return candidate


def main():
    thinkers = load_json(THINKERS_PATH)
    expanded = load_json(EXPANDED_PATH)

    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    BACKUP_DIR.mkdir(exist_ok=True)
    backup_path = BACKUP_DIR / f'thinkers_quotes.json.pre_promote_expanded_{timestamp}.bak'
    backup_path.write_text(THINKERS_PATH.read_text(encoding='utf-8'), encoding='utf-8')

    existing_keys = {
        (norm(item.get('author')), norm(item.get('text_de')), norm(item.get('source')))
        for item in thinkers
        if isinstance(item, dict)
    }
    used_ids = {str(item.get('id')).strip() for item in thinkers if isinstance(item, dict) and item.get('id')}

    added = []
    skipped_duplicates = 0
    skipped_missing = 0

    for item in expanded:
        if len(thinkers) + len(added) >= TARGET_COUNT:
            break
        if not isinstance(item, dict):
            continue

        candidate = dict(item)
        candidate['category'] = candidate.get('category') if isinstance(candidate.get('category'), list) else [str(candidate.get('category') or 'Gesellschaft')]
        candidate['related_ids'] = candidate.get('related_ids') if isinstance(candidate.get('related_ids'), list) else []

        if not has_required_fields(candidate):
            skipped_missing += 1
            continue

        key = (norm(candidate.get('author')), norm(candidate.get('text_de')), norm(candidate.get('source')))
        if key in existing_keys:
            skipped_duplicates += 1
            continue

        candidate['id'] = make_unique_id(str(candidate.get('id') or 'expanded_quote'), used_ids)
        added.append(candidate)
        existing_keys.add(key)

    merged = thinkers + added
    with open(THINKERS_PATH, 'w', encoding='utf-8') as handle:
        json.dump(merged, handle, ensure_ascii=False, indent=2)

    report = {
        'before_count': len(thinkers),
        'added': len(added),
        'after_count': len(merged),
        'target_count': TARGET_COUNT,
        'skipped_duplicates': skipped_duplicates,
        'skipped_missing': skipped_missing,
        'backup_path': str(backup_path),
        'authors_used': sorted({item['author'] for item in added}),
    }
    REPORT_PATH.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()

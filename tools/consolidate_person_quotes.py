#!/usr/bin/env python3
import json
import os
import re
import shutil
from datetime import datetime

BASE = os.getcwd()
ASSETS = os.path.join(BASE, 'assets')
THINKERS_PATH = os.path.join(ASSETS, 'thinkers_quotes.json')
GENERATED_PATH = os.path.join(ASSETS, 'generated_quotes.json')
QUOTES_PATH = os.path.join(ASSETS, 'quotes.json')
THINKERS_BAK_PATH = os.path.join(ASSETS, 'thinkers_quotes.json.bak')
REPORT_PATH = os.path.join(BASE, 'tools', 'person_cleanup_report.json')

UNKNOWN_AUTHORS = {
    '(unknown)', 'unknown', 'unbekannt', 'anonymous', 'anon',
    'ai', 'chatgpt', 'system', 'generated', 'n/a', 'na', '-'
}


def load_json(path):
    if not os.path.exists(path):
        return []
    with open(path, 'r', encoding='utf-8-sig') as f:
        data = json.load(f)
    if isinstance(data, list):
        return data
    if isinstance(data, dict):
        if isinstance(data.get('items'), list):
            return data['items']
        if isinstance(data.get('quotes'), list):
            return data['quotes']
    return []


def slug(value):
    s = value.lower().strip()
    s = s.replace('ä', 'ae').replace('ö', 'oe').replace('ü', 'ue').replace('ß', 'ss')
    s = re.sub(r'[^a-z0-9]+', '_', s)
    s = re.sub(r'_+', '_', s).strip('_')
    return s or 'person'


def is_valid_person_author(author):
    if not isinstance(author, str):
        return False
    a = author.strip()
    if not a:
        return False
    if a.lower() in UNKNOWN_AUTHORS:
        return False
    if len(re.findall(r'[A-Za-zÀ-ÖØ-öø-ÿ]', a)) < 2:
        return False
    if any(tok in a.lower() for tok in ('http://', 'https://', 'wiki', '.com', '.org')):
        return False
    return True


def ensure_seed_fields(item):
    out = dict(item)
    text_de = str(out.get('text_de') or '').strip()
    source = str(out.get('source') or '').strip()
    author = str(out.get('author') or '').strip()

    if not text_de or not source or not author:
        return None

    out['text_original'] = str(out.get('text_original') or text_de).strip()

    year = out.get('year')
    if not isinstance(year, int):
        if isinstance(year, float):
            year = int(year)
        elif isinstance(year, str) and year.strip().lstrip('-').isdigit():
            year = int(year.strip())
        else:
            return None
    if year < -3000 or year > 2100:
        return None
    out['year'] = year

    chapter = str(out.get('chapter') or source).strip()
    out['chapter'] = chapter if chapter else 'Allgemein'

    category = out.get('category')
    if not isinstance(category, list):
        category = []
    category = [str(x).strip() for x in category if str(x).strip()]
    if not category:
        category = ['Gesellschaft']
    out['category'] = category

    difficulty = str(out.get('difficulty') or 'intermediate').strip().lower()
    if difficulty not in ('beginner', 'intermediate', 'advanced'):
        difficulty = 'intermediate'
    out['difficulty'] = difficulty

    series = str(out.get('series') or f'person_{slug(author)}').strip()
    out['series'] = series if series else f'person_{slug(author)}'

    short = str(out.get('explanation_short') or f'Zitat von {author}: {text_de[:120]}').strip()
    long_text = str(out.get('explanation_long') or f'Historisches Zitat von {author} aus "{source}".').strip()
    out['explanation_short'] = short
    out['explanation_long'] = long_text

    related = out.get('related_ids')
    if not isinstance(related, list):
        related = []
    out['related_ids'] = [str(x).strip() for x in related if str(x).strip()]

    if not isinstance(out.get('id'), str) or not out.get('id', '').strip():
        out['id'] = f"{slug(author)}_{slug(text_de)[:40]}"

    return out


def norm_text(value):
    s = value.lower().strip()
    s = s.replace('ä', 'ae').replace('ö', 'oe').replace('ü', 'ue').replace('ß', 'ss')
    s = re.sub(r'\s+', ' ', s)
    return s


def unique_id(base_id, used_ids):
    candidate = base_id
    idx = 2
    while candidate in used_ids:
        candidate = f'{base_id}__{idx}'
        idx += 1
    used_ids.add(candidate)
    return candidate


def main():
    thinkers = load_json(THINKERS_PATH)
    generated = load_json(GENERATED_PATH)
    quotes = load_json(QUOTES_PATH)
    thinkers_bak = load_json(THINKERS_BAK_PATH)

    all_items = []
    for src, data in [
        ('thinkers_quotes.json', thinkers),
        ('generated_quotes.json', generated),
        ('quotes.json', quotes),
        ('thinkers_quotes.json.bak', thinkers_bak),
    ]:
        for it in data:
            if isinstance(it, dict):
                x = dict(it)
                x['_source_file'] = src
                all_items.append(x)

    person_candidates = []
    non_person = []
    dropped_invalid_seed_shape = 0

    for it in all_items:
        author = str(it.get('author') or '').strip()
        if not is_valid_person_author(author):
            it['provenance'] = it.get('provenance') or 'generated'
            it['needs_review'] = True
            non_person.append(it)
            continue

        normalized = ensure_seed_fields(it)
        if normalized is None:
            dropped_invalid_seed_shape += 1
            it['provenance'] = it.get('provenance') or 'generated'
            it['needs_review'] = True
            it['_drop_reason'] = 'missing_required_seed_fields'
            non_person.append(it)
            continue

        person_candidates.append(normalized)

    # dedupe by author + text + source
    seen_keys = set()
    used_ids = set()
    person_final = []
    duplicates_removed = 0

    for it in person_candidates:
        key = (
            norm_text(str(it.get('author', ''))),
            norm_text(str(it.get('text_de', ''))),
            norm_text(str(it.get('source', ''))),
        )
        if key in seen_keys:
            duplicates_removed += 1
            continue
        seen_keys.add(key)

        base_id = str(it.get('id') or '').strip() or 'person_quote'
        it['id'] = unique_id(base_id, used_ids)
        person_final.append(it)

    # Remove any person items from non_person by same key
    person_keys = {
        (
            norm_text(str(it.get('author', ''))),
            norm_text(str(it.get('text_de', ''))),
            norm_text(str(it.get('source', ''))),
        )
        for it in person_final
    }

    non_person_final = []
    for it in non_person:
        key = (
            norm_text(str(it.get('author', ''))),
            norm_text(str(it.get('text_de', ''))),
            norm_text(str(it.get('source', ''))),
        )
        if key in person_keys:
            continue
        non_person_final.append(it)

    # stable sort by author then year then source
    person_final.sort(key=lambda x: (
        norm_text(str(x.get('author', ''))),
        int(x.get('year', 99999)),
        norm_text(str(x.get('source', ''))),
        norm_text(str(x.get('id', ''))),
    ))

    os.makedirs(os.path.join(BASE, 'tools'), exist_ok=True)

    ts = datetime.now().strftime('%Y%m%d_%H%M%S')
    thinkers_backup = THINKERS_PATH + f'.pre_person_cleanup_{ts}.bak'
    generated_backup = GENERATED_PATH + f'.pre_person_cleanup_{ts}.bak'
    if os.path.exists(THINKERS_PATH):
        shutil.copyfile(THINKERS_PATH, thinkers_backup)
    if os.path.exists(GENERATED_PATH):
        shutil.copyfile(GENERATED_PATH, generated_backup)

    with open(THINKERS_PATH, 'w', encoding='utf-8') as f:
        json.dump(person_final, f, ensure_ascii=False, indent=2)

    with open(GENERATED_PATH, 'w', encoding='utf-8') as f:
        json.dump(non_person_final, f, ensure_ascii=False, indent=2)

    report = {
        'input_counts': {
            'thinkers_quotes_json': len(thinkers),
            'generated_quotes_json': len(generated),
            'quotes_json': len(quotes),
            'thinkers_quotes_json_bak': len(thinkers_bak),
            'combined': len(all_items),
        },
        'result_counts': {
            'person_candidates_after_validation': len(person_candidates),
            'person_final': len(person_final),
            'non_person_final': len(non_person_final),
            'duplicates_removed': duplicates_removed,
            'dropped_invalid_seed_shape': dropped_invalid_seed_shape,
        },
        'backups': {
            'thinkers_backup': thinkers_backup,
            'generated_backup': generated_backup,
        },
        'outputs': {
            'thinkers_quotes_json': THINKERS_PATH,
            'generated_quotes_json': GENERATED_PATH,
        },
    }

    with open(REPORT_PATH, 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()

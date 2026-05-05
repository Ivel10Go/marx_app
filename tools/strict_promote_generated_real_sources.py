#!/usr/bin/env python3
import json
import os
import shutil
from datetime import datetime

BASE = os.getcwd()
THINKERS_PATH = os.path.join(BASE, 'assets', 'thinkers_quotes.json')
GENERATED_PATH = os.path.join(BASE, 'assets', 'generated_quotes.json')
REPORT_PATH = os.path.join(BASE, 'tools', 'strict_promote_generated_real_sources_report.json')

# Only high-confidence source -> person mappings.
STRICT_SOURCE_AUTHOR_MAP = {
    'The Levin interviews - Friedrich Hayek': ('Friedrich Hayek', 'philosopher'),
    'A Vindication of the Rights of Woman': ('Mary Wollstonecraft', 'philosopher'),
    'Declaration of the Rights of Woman and of the Female Citizen': ('Olympe de Gouges', 'politician'),
    'Seneca Falls Convention Speeches': ('Elizabeth Cady Stanton', 'politician'),
    'Politik als Beruf': ('Max Weber', 'philosopher'),
    'Democracy in America': ('Alexis de Tocqueville', 'philosopher'),
    'A Theory of Justice': ('John Rawls', 'philosopher'),
    'Democracy and Education': ('John Dewey', 'philosopher'),
    'The Human Condition': ('Hannah Arendt', 'philosopher'),
    'Notes on Nursing and Public Health': ('Florence Nightingale', 'philosopher'),
    'The Souls of Black Folk and Later Essays': ('W. E. B. Du Bois', 'philosopher'),
    'The Wretched of the Earth': ('Frantz Fanon', 'philosopher'),
    'The Open Society and Its Enemies': ('Karl Popper', 'philosopher'),
    'The Constitution of Liberty': ('Friedrich Hayek', 'philosopher'),
    'Two Treatises of Government': ('John Locke', 'philosopher'),
    'The Spirit of the Laws': ('Montesquieu', 'philosopher'),
    'The Rebel': ('Albert Camus', 'philosopher'),
    'Oneself as Another': ('Paul Ricoeur', 'philosopher'),
    'Governing the Commons': ('Elinor Ostrom', 'philosopher'),
    'Development as Freedom': ('Amartya Sen', 'philosopher'),
    'The Power of the Powerless': ('Vaclav Havel', 'politician'),
    'The Wealth of Nations': ('Adam Smith', 'philosopher'),
    'Rationalism in Politics': ('Michael Oakeshott', 'philosopher'),
    'Gulag Archipelago Speeches and Essays': ('Aleksandr Solzhenitsyn', 'philosopher'),
}

REQUIRED_FIELDS = [
    'id',
    'text_de',
    'text_original',
    'source',
    'year',
    'chapter',
    'category',
    'difficulty',
    'series',
    'explanation_short',
    'explanation_long',
    'related_ids',
]


def load_list(path):
    with open(path, 'r', encoding='utf-8-sig') as f:
        data = json.load(f)
    return data if isinstance(data, list) else []


def norm(text):
    return ' '.join(str(text or '').strip().lower().split())


def unique_id(base_id, used_ids):
    candidate = base_id
    idx = 2
    while candidate in used_ids:
        candidate = f'{base_id}__{idx}'
        idx += 1
    used_ids.add(candidate)
    return candidate


def has_required_fields(item):
    for key in REQUIRED_FIELDS:
        if key not in item:
            return False
    if not isinstance(item.get('year'), int):
        return False
    if not isinstance(item.get('category'), list):
        return False
    if not isinstance(item.get('related_ids'), list):
        return False
    return True


def main():
    thinkers = load_list(THINKERS_PATH)
    generated = load_list(GENERATED_PATH)

    ts = datetime.now().strftime('%Y%m%d_%H%M%S')
    thinkers_backup = THINKERS_PATH + f'.pre_strict_promote_{ts}.bak'
    generated_backup = GENERATED_PATH + f'.pre_strict_promote_{ts}.bak'
    shutil.copyfile(THINKERS_PATH, thinkers_backup)
    shutil.copyfile(GENERATED_PATH, generated_backup)

    existing_keys = {
        (
            norm(x.get('author')),
            norm(x.get('text_de')),
            norm(x.get('source')),
        )
        for x in thinkers
        if isinstance(x, dict)
    }
    used_ids = {
        str(x.get('id')).strip()
        for x in thinkers
        if isinstance(x, dict) and x.get('id')
    }

    promoted = []
    kept_generated = []
    skipped_duplicates = 0
    skipped_missing_fields = 0
    source_hits = {source: 0 for source in STRICT_SOURCE_AUTHOR_MAP}

    for item in generated:
        if not isinstance(item, dict):
            continue

        source = str(item.get('source') or '').strip()
        mapping = STRICT_SOURCE_AUTHOR_MAP.get(source)
        if not mapping:
            kept_generated.append(item)
            continue

        source_hits[source] += 1
        candidate = dict(item)
        candidate['author'] = mapping[0]
        candidate['author_type'] = mapping[1]
        candidate['provenance'] = 'generated_strict_mapped'
        candidate['needs_review'] = True

        if not has_required_fields(candidate):
            skipped_missing_fields += 1
            kept_generated.append(item)
            continue

        key = (
            norm(candidate.get('author')),
            norm(candidate.get('text_de')),
            norm(candidate.get('source')),
        )
        if key in existing_keys:
            skipped_duplicates += 1
            kept_generated.append(item)
            continue

        base_id = str(candidate.get('id') or 'strict_promoted_quote').strip() or 'strict_promoted_quote'
        candidate['id'] = unique_id(base_id, used_ids)
        promoted.append(candidate)
        existing_keys.add(key)

    merged_thinkers = thinkers + promoted
    merged_thinkers.sort(
        key=lambda x: (
            norm(x.get('author')),
            int(x.get('year') if isinstance(x.get('year'), int) else 99999),
            norm(x.get('source')),
            norm(x.get('id')),
        )
    )

    with open(THINKERS_PATH, 'w', encoding='utf-8') as f:
        json.dump(merged_thinkers, f, ensure_ascii=False, indent=2)

    with open(GENERATED_PATH, 'w', encoding='utf-8') as f:
        json.dump(kept_generated, f, ensure_ascii=False, indent=2)

    report = {
        'before': {
            'thinkers_count': len(thinkers),
            'generated_count': len(generated),
        },
        'strict_sources': list(STRICT_SOURCE_AUTHOR_MAP.keys()),
        'source_hits_in_generated': source_hits,
        'result': {
            'promoted': len(promoted),
            'skipped_duplicates': skipped_duplicates,
            'skipped_missing_fields': skipped_missing_fields,
            'thinkers_after': len(merged_thinkers),
            'generated_after': len(kept_generated),
        },
        'backups': {
            'thinkers_backup': thinkers_backup,
            'generated_backup': generated_backup,
        },
    }

    with open(REPORT_PATH, 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()

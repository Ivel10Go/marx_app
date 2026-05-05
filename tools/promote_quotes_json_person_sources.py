#!/usr/bin/env python3
import json
from datetime import datetime
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
THINKERS_PATH = BASE / 'assets' / 'thinkers_quotes.json'
QUOTES_PATH = BASE / 'assets' / 'quotes.json'
BACKUP_DIR = BASE / 'tools' / 'backups'
REPORT_PATH = BASE / 'tools' / 'promote_quotes_json_person_sources_report.json'
TARGET_COUNT = 400

SOURCE_AUTHOR_MAP = {
    'Kommunistisches Manifest': ('Karl Marx & Friedrich Engels', 'philosopher'),
    'Manifest der Kommunistischen Partei': ('Karl Marx & Friedrich Engels', 'philosopher'),
    'Die deutsche Ideologie': ('Karl Marx & Friedrich Engels', 'philosopher'),
    'Briefe von Marx und Engels': ('Karl Marx & Friedrich Engels', 'philosopher'),
    'Briefe und Korrespondenz': ('Karl Marx & Friedrich Engels', 'philosopher'),
    'Das Kapital, Band 1': ('Karl Marx', 'philosopher'),
    'Das Kapital Band 1': ('Karl Marx', 'philosopher'),
    'Das Kapital, Band 2/3': ('Karl Marx', 'philosopher'),
    'Das Kapital Band 2': ('Karl Marx', 'philosopher'),
    'Das Kapital Band 3': ('Karl Marx', 'philosopher'),
    'Der achtzehnte Brumaire des Louis Bonaparte': ('Karl Marx', 'philosopher'),
    'Der achtzehnte Brumaire': ('Karl Marx', 'philosopher'),
    'Zur Kritik der Politischen Oekonomie': ('Karl Marx', 'philosopher'),
    'Zur Kritik der Hegelschen Rechtsphilosophie. Einleitung': ('Karl Marx', 'philosopher'),
    'Grundrisse der Kritik der Politischen Oekonomie': ('Karl Marx', 'philosopher'),
    'Grundrisse': ('Karl Marx', 'philosopher'),
    'Lohnarbeit und Kapital': ('Karl Marx', 'philosopher'),
    'Thesen ueber Feuerbach': ('Karl Marx', 'philosopher'),
    'Anti-Duhring': ('Friedrich Engels', 'philosopher'),
    'Engels: Anti-Duehring u.a.': ('Friedrich Engels', 'philosopher'),
    'Ludwig Feuerbach und der Ausgang der klassischen deutschen Philosophie': ('Friedrich Engels', 'philosopher'),
    'Der Ursprung der Familie, des Privateigentums und des Staats': ('Friedrich Engels', 'philosopher'),
    'Reflections on the Revolution in France': ('Edmund Burke', 'politician'),
    'On Liberty': ('John Stuart Mill', 'philosopher'),
    'The Levin interviews - Friedrich Hayek': ('Friedrich Hayek', 'philosopher'),
    'A Vindication of the Rights of Woman': ('Mary Wollstonecraft', 'philosopher'),
    'Declaration of the Rights of Woman and of the Female Citizen': ('Olympe de Gouges', 'politician'),
    'Seneca Falls Convention Speeches': ('Elizabeth Cady Stanton', 'politician'),
    'Politik als Beruf': ('Max Weber', 'philosopher'),
    'Democracy in America': ('Alexis de Tocqueville', 'philosopher'),
    'A Theory of Justice': ('John Rawls', 'philosopher'),
    'Democracy and Education': ('John Dewey', 'philosopher'),
    'The Human Condition': ('Hannah Arendt', 'philosopher'),
}

PRIORITY_SOURCES = [
    'Kommunistisches Manifest',
    'Das Kapital, Band 1',
    'Das Kapital Band 1',
    'Die deutsche Ideologie',
    'Das Kapital, Band 2/3',
    'Der achtzehnte Brumaire des Louis Bonaparte',
    'Zur Kritik der Politischen Oekonomie',
    'Anti-Duhring',
    'Briefe und Korrespondenz',
    'Ludwig Feuerbach und der Ausgang der klassischen deutschen Philosophie',
    'Grundrisse der Kritik der Politischen Oekonomie',
    'Das Kapital Band 2',
    'Das Kapital Band 3',
    'Lohnarbeit und Kapital',
    'Der Ursprung der Familie, des Privateigentums und des Staats',
    'Grundrisse',
    'Der achtzehnte Brumaire',
    'Thesen ueber Feuerbach',
    'Engels: Anti-Duehring u.a.',
    'Briefe von Marx und Engels',
    'Manifest der Kommunistischen Partei',
    'Reflections on the Revolution in France',
    'Zur Kritik der Hegelschen Rechtsphilosophie. Einleitung',
    'On Liberty',
    'The Levin interviews - Friedrich Hayek',
    'A Vindication of the Rights of Woman',
    'Declaration of the Rights of Woman and of the Female Citizen',
    'Seneca Falls Convention Speeches',
    'Politik als Beruf',
    'Democracy in America',
    'A Theory of Justice',
    'Democracy and Education',
    'The Human Condition',
]

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
    quotes = load_json(QUOTES_PATH)

    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    BACKUP_DIR.mkdir(exist_ok=True)
    backup_path = BACKUP_DIR / f'thinkers_quotes.json.pre_promote_quotes_{timestamp}.bak'
    backup_path.write_text(THINKERS_PATH.read_text(encoding='utf-8'), encoding='utf-8')

    existing_keys = {
        (norm(item.get('author')), norm(item.get('text_de')), norm(item.get('source')))
        for item in thinkers
        if isinstance(item, dict)
    }
    used_ids = {str(item.get('id')).strip() for item in thinkers if isinstance(item, dict) and item.get('id')}

    grouped = {}
    for item in quotes:
        if not isinstance(item, dict):
            continue
        source = str(item.get('source') or '').strip()
        if source in SOURCE_AUTHOR_MAP:
            grouped.setdefault(source, []).append(item)

    added = []
    skipped_duplicates = 0
    skipped_missing = 0

    for source in PRIORITY_SOURCES:
        author, author_type = SOURCE_AUTHOR_MAP[source]
        for item in grouped.get(source, []):
            if len(thinkers) + len(added) >= TARGET_COUNT:
                break

            candidate = dict(item)
            candidate['author'] = author
            candidate['author_type'] = author_type
            candidate['series'] = str(candidate.get('series') or source).strip()
            candidate['category'] = candidate.get('category') if isinstance(candidate.get('category'), list) else [str(candidate.get('category') or 'Gesellschaft')]
            candidate['text_de'] = str(candidate.get('text_de') or '').strip()
            candidate['text_original'] = str(candidate.get('text_original') or candidate['text_de']).strip()
            candidate['source'] = source
            candidate['chapter'] = str(candidate.get('chapter') or source).strip()
            candidate['difficulty'] = str(candidate.get('difficulty') or 'intermediate').strip()
            candidate['explanation_short'] = str(candidate.get('explanation_short') or f'Zitat von {author}: {candidate["text_de"]}').strip()
            candidate['explanation_long'] = str(candidate.get('explanation_long') or f'Historisches Zitat von {author} aus "{source}".').strip()
            candidate['related_ids'] = candidate.get('related_ids') if isinstance(candidate.get('related_ids'), list) else []

            if not has_required_fields(candidate):
                skipped_missing += 1
                continue

            key = (norm(candidate.get('author')), norm(candidate.get('text_de')), norm(candidate.get('source')))
            if key in existing_keys:
                skipped_duplicates += 1
                continue

            candidate['id'] = make_unique_id(str(candidate.get('id') or f'{source.lower().replace(" ", "_")}_quote'), used_ids)
            added.append(candidate)
            existing_keys.add(key)

        if len(thinkers) + len(added) >= TARGET_COUNT:
            break

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
        'sources_used': sorted({item['source'] for item in added}),
        'authors_used': sorted({item['author'] for item in added}),
    }
    REPORT_PATH.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()

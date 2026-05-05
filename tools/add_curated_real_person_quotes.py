#!/usr/bin/env python3
import json
import os
import shutil
from datetime import datetime

BASE = os.getcwd()
THINKERS_PATH = os.path.join(BASE, 'assets', 'thinkers_quotes.json')
REPORT_PATH = os.path.join(BASE, 'tools', 'add_curated_real_person_quotes_report.json')

CURATED_QUOTES = [
    # Demokratie / Staat / Liberalismus
    {
        'id': 'montesquieu_001',
        'author': 'Montesquieu',
        'author_type': 'philosopher',
        'text_de': 'Damit man die Macht nicht missbrauchen kann, muss durch die Anordnung der Dinge die Macht der Macht Schranken setzen.',
        'source': 'Vom Geist der Gesetze',
        'year': 1748,
        'category': ['Staat', 'Demokratie', 'Liberalismus'],
    },
    {
        'id': 'tocqueville_001',
        'author': 'Alexis de Tocqueville',
        'author_type': 'philosopher',
        'text_de': 'Die Gesundheit einer demokratischen Gesellschaft laesst sich daran messen, wie sie mit Minderheiten umgeht.',
        'source': 'Ueber die Demokratie in Amerika',
        'year': 1835,
        'category': ['Demokratie', 'Rechte', 'Gesellschaft'],
    },
    {
        'id': 'mill_001',
        'author': 'John Stuart Mill',
        'author_type': 'philosopher',
        'text_de': 'Der einzige Zweck, um derentwillen Macht rechtmaessig ueber ein Mitglied einer zivilisierten Gemeinschaft ausgeuebt werden darf, ist die Verhuetung von Schaden an anderen.',
        'source': 'On Liberty',
        'year': 1859,
        'category': ['Liberalismus', 'Rechte', 'Freiheit'],
    },
    {
        'id': 'burke_001',
        'author': 'Edmund Burke',
        'author_type': 'philosopher',
        'text_de': 'Ein Staat ohne die Mittel zu Veraenderung ist ohne die Mittel zu seiner Erhaltung.',
        'source': 'Reflections on the Revolution in France',
        'year': 1790,
        'category': ['Konservativ', 'Staat', 'Reform'],
    },
    # Frauen / Frauenrechte
    {
        'id': 'wollstonecraft_001',
        'author': 'Mary Wollstonecraft',
        'author_type': 'philosopher',
        'text_de': 'Ich wuensche nicht, dass Frauen Macht ueber Maenner haben, sondern ueber sich selbst.',
        'source': 'A Vindication of the Rights of Woman',
        'year': 1792,
        'category': ['Frauenrechte', 'Rechte', 'Emanzipation'],
    },
    {
        'id': 'gouges_001',
        'author': 'Olympe de Gouges',
        'author_type': 'politician',
        'text_de': 'Die Frau wird frei geboren und bleibt dem Manne gleich in allen Rechten.',
        'source': 'Erklaerung der Rechte der Frau und Buergerin',
        'year': 1791,
        'category': ['Frauenrechte', 'Gleichberechtigung', 'Demokratie'],
    },
    {
        'id': 'zetkin_001',
        'author': 'Clara Zetkin',
        'author_type': 'politician',
        'text_de': 'Die Befreiung der Frau ist untrennbar mit der Befreiung der Arbeit verbunden.',
        'source': 'Reden und Schriften',
        'year': 1896,
        'category': ['Frauen', 'Arbeit', 'Emanzipation'],
    },
    # Arbeit / soziale Frage / Revolution
    {
        'id': 'douglass_001',
        'author': 'Frederick Douglass',
        'author_type': 'politician',
        'text_de': 'Macht raeumt nichts ohne Forderung ein. Sie hat es nie getan und wird es nie tun.',
        'source': 'Rede in Canandaigua',
        'year': 1857,
        'category': ['Rechte', 'Klassenkampf', 'Revolution'],
    },
    {
        'id': 'lincoln_003',
        'author': 'Abraham Lincoln',
        'author_type': 'politician',
        'text_de': 'Die beste Art, die Zukunft vorauszusagen, ist, sie zu gestalten.',
        'source': 'Zugeschriebene politische Formel',
        'year': 1862,
        'category': ['Politik', 'Reform', 'Demokratie'],
    },
    {
        'id': 'luxemburg_004',
        'author': 'Rosa Luxemburg',
        'author_type': 'politician',
        'text_de': 'Freiheit ist immer Freiheit der Andersdenkenden.',
        'source': 'Zur russischen Revolution',
        'year': 1918,
        'category': ['Rechte', 'Demokratie', 'Freiheit'],
    },
    # Krieg / Frieden / Strategie
    {
        'id': 'clausewitz_001',
        'author': 'Carl von Clausewitz',
        'author_type': 'politician',
        'text_de': 'Der Krieg ist eine blosse Fortsetzung der Politik mit anderen Mitteln.',
        'source': 'Vom Kriege',
        'year': 1832,
        'category': ['Krieg', 'Politik', 'Strategie'],
    },
    {
        'id': 'sunzi_001',
        'author': 'Sunzi',
        'author_type': 'philosopher',
        'text_de': 'Der hoechste Sieg ist der, der ohne Kampf errungen wird.',
        'source': 'Die Kunst des Krieges',
        'year': -500,
        'category': ['Krieg', 'Strategie', 'Taktik'],
    },
    {
        'id': 'gandhi_001',
        'author': 'Mahatma Gandhi',
        'author_type': 'politician',
        'text_de': 'Es gibt keinen Weg zum Frieden, denn Frieden ist der Weg.',
        'source': 'Reden und Schriften',
        'year': 1938,
        'category': ['Frieden', 'Politik', 'Ethik'],
    },
    # Wissenschaft / Methode / Technik
    {
        'id': 'darwin_001',
        'author': 'Charles Darwin',
        'author_type': 'philosopher',
        'text_de': 'Nicht die staerkste Art ueberlebt, auch nicht die intelligenteste, sondern diejenige, die sich am besten an Veraenderung anpasst.',
        'source': 'Zugeschriebene Darwin-Formel',
        'year': 1860,
        'category': ['Wissenschaft', 'Natur', 'Entwicklung'],
    },
    {
        'id': 'curie_001',
        'author': 'Marie Curie',
        'author_type': 'philosopher',
        'text_de': 'Man braucht nichts im Leben zu fuerchten, man muss nur alles verstehen.',
        'source': 'Reden und Schriften',
        'year': 1933,
        'category': ['Wissenschaft', 'Forschung', 'Bildung'],
    },
    {
        'id': 'lovelace_001',
        'author': 'Ada Lovelace',
        'author_type': 'philosopher',
        'text_de': 'Die analytische Maschine hat keinen Anspruch darauf, irgendetwas selbst hervorbringen zu koennen. Sie kann nur tun, was wir ihr anzuordnen wissen.',
        'source': 'Notes on the Analytical Engine',
        'year': 1843,
        'category': ['Wissenschaft', 'Technik', 'Methode'],
    },
    {
        'id': 'humboldt_001',
        'author': 'Alexander von Humboldt',
        'author_type': 'philosopher',
        'text_de': 'Die Natur muss gefuehlt werden.',
        'source': 'Kosmos',
        'year': 1845,
        'category': ['Natur', 'Wissenschaft', 'Philosophie'],
    },
    # Kunst / Kultur / Alltag
    {
        'id': 'goethe_001',
        'author': 'Johann Wolfgang von Goethe',
        'author_type': 'philosopher',
        'text_de': 'Wer immer strebend sich bemueht, den koennen wir erloesen.',
        'source': 'Faust II',
        'year': 1832,
        'category': ['Kultur', 'Literatur', 'Menschenbild'],
    },
    {
        'id': 'schiller_001',
        'author': 'Friedrich Schiller',
        'author_type': 'philosopher',
        'text_de': 'Der Mensch ist nur da ganz Mensch, wo er spielt.',
        'source': 'Ueber die aesthetische Erziehung des Menschen',
        'year': 1795,
        'category': ['Kunst', 'Kultur', 'Philosophie'],
    },
    {
        'id': 'heine_001',
        'author': 'Heinrich Heine',
        'author_type': 'philosopher',
        'text_de': 'Dort wo man Buecher verbrennt, verbrennt man am Ende auch Menschen.',
        'source': 'Almansor',
        'year': 1821,
        'category': ['Kultur', 'Politik', 'Rechte'],
    },
    # Religion / Ethik
    {
        'id': 'spinoza_003',
        'author': 'Baruch de Spinoza',
        'author_type': 'philosopher',
        'text_de': 'Frieden ist nicht die Abwesenheit von Krieg. Frieden ist eine Tugend, eine Geisteshaltung.',
        'source': 'Tractatus Politicus',
        'year': 1677,
        'category': ['Religion', 'Ethik', 'Frieden'],
    },
    {
        'id': 'augustinus_001',
        'author': 'Augustinus',
        'author_type': 'philosopher',
        'text_de': 'Unruhig ist unser Herz, bis es ruht in dir.',
        'source': 'Bekenntnisse',
        'year': 397,
        'category': ['Religion', 'Philosophie', 'Menschenbild'],
    },
    {
        'id': 'luther_001',
        'author': 'Martin Luther',
        'author_type': 'philosopher',
        'text_de': 'Hier stehe ich, ich kann nicht anders.',
        'source': 'Reichstag zu Worms',
        'year': 1521,
        'category': ['Religion', 'Reformation', 'Rechte'],
    },
    # Kolonialismus / Empire / Recht
    {
        'id': 'lascasas_001',
        'author': 'Bartolome de las Casas',
        'author_type': 'philosopher',
        'text_de': 'Alle Völker der Welt sind Menschen und haben dieselbe Natur.',
        'source': 'Kurzgefasster Bericht von der Verwuestung der Westindischen Laender',
        'year': 1542,
        'category': ['Kolonialismus', 'Rechte', 'Menschenbild'],
    },
    {
        'id': 'cesaire_001',
        'author': 'Aime Cesaire',
        'author_type': 'politician',
        'text_de': 'Kolonisation entmenschlicht den Kolonisator ebenso wie den Kolonisierten.',
        'source': 'Diskurs ueber den Kolonialismus',
        'year': 1950,
        'category': ['Kolonialismus', 'Kritik', 'Emanzipation'],
    },
    {
        'id': 'sankara_001',
        'author': 'Thomas Sankara',
        'author_type': 'politician',
        'text_de': 'Die Schulden koennen nicht bezahlt werden, weil wir nicht verantwortlich sind fuer sie.',
        'source': 'Rede vor der OAU',
        'year': 1987,
        'category': ['Kolonialismus', 'Oekonomie', 'Emanzipation'],
    },
]


def load_list(path):
    with open(path, 'r', encoding='utf-8-sig') as f:
        data = json.load(f)
    if isinstance(data, list):
        return data
    return []


def norm(text):
    return ' '.join(str(text or '').strip().lower().split())


def unique_id(base_id, used_ids):
    candidate = base_id
    i = 2
    while candidate in used_ids:
        candidate = f'{base_id}__{i}'
        i += 1
    used_ids.add(candidate)
    return candidate


def build_full_entry(seed):
    text = seed['text_de']
    source = seed['source']
    author = seed['author']
    return {
        'id': seed['id'],
        'author': author,
        'author_type': seed.get('author_type', 'philosopher'),
        'text_de': text,
        'source': source,
        'year': int(seed['year']),
        'text_original': text,
        'chapter': source,
        'category': list(seed.get('category', ['Gesellschaft'])),
        'difficulty': 'intermediate',
        'series': f"person_{author.lower().replace(' ', '_').replace('-', '_')}",
        'explanation_short': f"Zitat von {author}: {text[:120]}",
        'explanation_long': f"Historisches Zitat von {author} aus \"{source}\".",
        'related_ids': [],
    }


def main():
    thinkers = load_list(THINKERS_PATH)

    ts = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_path = THINKERS_PATH + f'.pre_curated_add_{ts}.bak'
    shutil.copyfile(THINKERS_PATH, backup_path)

    used_ids = {str(x.get('id', '')).strip() for x in thinkers if isinstance(x, dict)}
    existing_keys = {
        (
            norm(x.get('author')),
            norm(x.get('text_de')),
            norm(x.get('source')),
        )
        for x in thinkers
        if isinstance(x, dict)
    }

    added = 0
    skipped_duplicates = 0

    for seed in CURATED_QUOTES:
        entry = build_full_entry(seed)
        key = (norm(entry['author']), norm(entry['text_de']), norm(entry['source']))
        if key in existing_keys:
            skipped_duplicates += 1
            continue

        entry['id'] = unique_id(entry['id'], used_ids)
        thinkers.append(entry)
        existing_keys.add(key)
        added += 1

    thinkers.sort(
        key=lambda x: (
            norm(x.get('author')),
            int(x.get('year') if isinstance(x.get('year'), int) else 99999),
            norm(x.get('source')),
            norm(x.get('id')),
        )
    )

    with open(THINKERS_PATH, 'w', encoding='utf-8') as f:
        json.dump(thinkers, f, ensure_ascii=False, indent=2)

    report = {
        'before_count': len(thinkers) - added,
        'after_count': len(thinkers),
        'added': added,
        'skipped_duplicates': skipped_duplicates,
        'backup_path': backup_path,
    }

    with open(REPORT_PATH, 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()

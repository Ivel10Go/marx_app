#!/usr/bin/env python3
import json
import os
import shutil
from datetime import datetime

BASE = os.getcwd()
THINKERS_PATH = os.path.join(BASE, 'assets', 'thinkers_quotes.json')
REPORT_PATH = os.path.join(BASE, 'tools', 'add_curated_real_person_quotes_batch3_report.json')

CURATED_QUOTES = [
    {
        'id': 'confucius_001',
        'author': 'Konfuzius',
        'author_type': 'philosopher',
        'text_de': 'Der Weg ist das Ziel.',
        'source': 'Analekten',
        'year': -500,
        'category': ['Philosophie', 'Ethik', 'Alltag'],
    },
    {
        'id': 'laotse_001',
        'author': 'Laotse',
        'author_type': 'philosopher',
        'text_de': 'Eine Reise von tausend Meilen beginnt mit dem ersten Schritt.',
        'source': 'Daodejing',
        'year': -400,
        'category': ['Philosophie', 'Alltag', 'Menschenbild'],
    },
    {
        'id': 'socrates_001',
        'author': 'Sokrates',
        'author_type': 'philosopher',
        'text_de': 'Ich weiss, dass ich nichts weiss.',
        'source': 'Platon, Apologie',
        'year': -399,
        'category': ['Philosophie', 'Erkenntnis', 'Ethik'],
    },
    {
        'id': 'cicero_001',
        'author': 'Cicero',
        'author_type': 'philosopher',
        'text_de': 'Der Beweis der Freiheit ist die Freiheit.',
        'source': 'De legibus',
        'year': -52,
        'category': ['Rechte', 'Staat', 'Liberalismus'],
    },
    {
        'id': 'seneca_001',
        'author': 'Seneca',
        'author_type': 'philosopher',
        'text_de': 'Nicht weil es schwer ist, wagen wir es nicht, sondern weil wir es nicht wagen, ist es schwer.',
        'source': 'Epistulae morales',
        'year': 65,
        'category': ['Ethik', 'Alltag', 'Menschenbild'],
    },
    {
        'id': 'epictetus_001',
        'author': 'Epiktet',
        'author_type': 'philosopher',
        'text_de': 'Es sind nicht die Dinge selbst, die uns beunruhigen, sondern die Vorstellungen, die wir von den Dingen haben.',
        'source': 'Handbuechlein der Moral',
        'year': 108,
        'category': ['Philosophie', 'Ethik', 'Alltag'],
    },
    {
        'id': 'pascal_001',
        'author': 'Blaise Pascal',
        'author_type': 'philosopher',
        'text_de': 'Der Mensch ist nur ein Schilfrohr, das schwaechste in der Natur; aber er ist ein denkendes Schilfrohr.',
        'source': 'Pensees',
        'year': 1670,
        'category': ['Philosophie', 'Natur', 'Menschenbild'],
    },
    {
        'id': 'voltaire_003',
        'author': 'Voltaire',
        'author_type': 'philosopher',
        'text_de': 'Arbeit haelt drei grosse Uebel fern: Langeweile, Laster und Not.',
        'source': 'Candide',
        'year': 1759,
        'category': ['Arbeit', 'Alltag', 'Gesellschaft'],
    },
    {
        'id': 'rousseau_003',
        'author': 'Jean-Jacques Rousseau',
        'author_type': 'philosopher',
        'text_de': 'Zwischen dem Starken und dem Schwachen ist es die Freiheit, die unterdrueckt, und das Gesetz, das befreit.',
        'source': 'Vom Gesellschaftsvertrag',
        'year': 1762,
        'category': ['Rechte', 'Demokratie', 'Staat'],
    },
    {
        'id': 'paine_001',
        'author': 'Thomas Paine',
        'author_type': 'politician',
        'text_de': 'Die Sache Amerikas ist in grossem Masse die Sache der ganzen Menschheit.',
        'source': 'Common Sense',
        'year': 1776,
        'category': ['Revolution', 'Demokratie', 'Rechte'],
    },
    {
        'id': 'madison_001',
        'author': 'James Madison',
        'author_type': 'politician',
        'text_de': 'Wenn Menschen Engel waeren, braeuchte man keine Regierung.',
        'source': 'Federalist No. 51',
        'year': 1788,
        'category': ['Staat', 'Demokratie', 'Liberalismus'],
    },
    {
        'id': 'jefferson_001',
        'author': 'Thomas Jefferson',
        'author_type': 'politician',
        'text_de': 'Der Baum der Freiheit muss von Zeit zu Zeit mit dem Blut von Patrioten und Tyrannen erfrischt werden.',
        'source': 'Brief an William Stephens Smith',
        'year': 1787,
        'category': ['Revolution', 'Rechte', 'Staat'],
    },
    {
        'id': 'mazzini_001',
        'author': 'Giuseppe Mazzini',
        'author_type': 'politician',
        'text_de': 'Ein Volk ist eine Gemeinschaft von Menschen, die durch eine gemeinsame Aufgabe verbunden sind.',
        'source': 'The Duties of Man',
        'year': 1860,
        'category': ['Nation', 'Demokratie', 'Gesellschaft'],
    },
    {
        'id': 'bebel_001',
        'author': 'August Bebel',
        'author_type': 'politician',
        'text_de': 'Nur wer die Jugend hat, hat die Zukunft.',
        'source': 'Parlamentarische Reden',
        'year': 1890,
        'category': ['Bildung', 'Politik', 'Gesellschaft'],
    },
    {
        'id': 'bernstein_001',
        'author': 'Eduard Bernstein',
        'author_type': 'politician',
        'text_de': 'Das Endziel ist nichts, die Bewegung ist alles.',
        'source': 'Die Voraussetzungen des Sozialismus',
        'year': 1899,
        'category': ['Reform', 'Politik', 'Gesellschaft'],
    },
    {
        'id': 'trotsky_001',
        'author': 'Leo Trotzki',
        'author_type': 'politician',
        'text_de': 'Man mag sich nicht fuer Politik interessieren, aber die Politik interessiert sich fuer einen.',
        'source': 'Zugeschriebene politische Formel',
        'year': 1930,
        'category': ['Politik', 'Gesellschaft', 'Revolution'],
    },
    {
        'id': 'gramsci_001',
        'author': 'Antonio Gramsci',
        'author_type': 'philosopher',
        'text_de': 'Pessimismus des Verstandes, Optimismus des Willens.',
        'source': 'Gefaengnishefte',
        'year': 1932,
        'category': ['Philosophie', 'Politik', 'Alltag'],
    },
    {
        'id': 'thorez_001',
        'author': 'Maurice Thorez',
        'author_type': 'politician',
        'text_de': 'Man muss wissen, wie man einen Streik beendet, sobald die Forderungen erreicht sind.',
        'source': 'Politische Reden',
        'year': 1936,
        'category': ['Arbeit', 'Organisation', 'Politik'],
    },
    {
        'id': 'churchill_002',
        'author': 'Winston Churchill',
        'author_type': 'politician',
        'text_de': 'Erfolg ist nicht endgueltig, Misserfolg ist nicht fatal: entscheidend ist der Mut weiterzumachen.',
        'source': 'Rede, Harrow School',
        'year': 1941,
        'category': ['Krieg', 'Alltag', 'Verantwortung'],
    },
    {
        'id': 'degaulle_001',
        'author': 'Charles de Gaulle',
        'author_type': 'politician',
        'text_de': 'Patriotismus bedeutet, sein Land zu lieben. Nationalismus bedeutet, die anderen zu hassen.',
        'source': 'Politische Reden',
        'year': 1962,
        'category': ['Politik', 'Krieg', 'Gesellschaft'],
    },
    {
        'id': 'nkrumah_001',
        'author': 'Kwame Nkrumah',
        'author_type': 'politician',
        'text_de': 'Suche zuerst das politische Koenigreich, und alles andere wird folgen.',
        'source': 'I Speak of Freedom',
        'year': 1961,
        'category': ['Kolonialismus', 'Politik', 'Emanzipation'],
    },
    {
        'id': 'cabral_001',
        'author': 'Amilcar Cabral',
        'author_type': 'politician',
        'text_de': 'Sagt keine Luegen. Beansprucht keine Siege, die ihr nicht errungen habt.',
        'source': 'Unity and Struggle',
        'year': 1974,
        'category': ['Kolonialismus', 'Organisation', 'Ethik'],
    },
    {
        'id': 'allende_001',
        'author': 'Salvador Allende',
        'author_type': 'politician',
        'text_de': 'Die Geschichte gehoert uns, und die Voelker machen sie.',
        'source': 'Abschiedsrede',
        'year': 1973,
        'category': ['Politik', 'Revolution', 'Geschichte'],
    },
    {
        'id': 'sandel_001',
        'author': 'Michael J. Sandel',
        'author_type': 'philosopher',
        'text_de': 'Maerkte lassen nichts unangetastet, was Geld beruehrt.',
        'source': 'What Money Can\'t Buy',
        'year': 2012,
        'category': ['Oekonomie', 'Ethik', 'Gesellschaft'],
    },
    {
        'id': 'piketty_001',
        'author': 'Thomas Piketty',
        'author_type': 'philosopher',
        'text_de': 'Wenn die Rendite des Kapitals dauerhaft hoeher ist als das Wachstum, produziert der Kapitalismus automatisch Ungleichheit.',
        'source': 'Das Kapital im 21. Jahrhundert',
        'year': 2013,
        'category': ['Oekonomie', 'Ungleichheit', 'Arbeit'],
    },
    {
        'id': 'ostrom_001',
        'author': 'Elinor Ostrom',
        'author_type': 'philosopher',
        'text_de': 'Es gibt keine Patentrezepte; gute Institutionen muessen zum konkreten sozialen und oekologischen Kontext passen.',
        'source': 'Governing the Commons',
        'year': 1990,
        'category': ['Institutionen', 'Politik', 'Wissenschaft'],
    },
]


def load_list(path):
    with open(path, 'r', encoding='utf-8-sig') as f:
        data = json.load(f)
    return data if isinstance(data, list) else []


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
    backup_path = THINKERS_PATH + f'.pre_curated_add_batch3_{ts}.bak'
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

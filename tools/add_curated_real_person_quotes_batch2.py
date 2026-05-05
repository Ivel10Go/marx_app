#!/usr/bin/env python3
import json
import os
import shutil
from datetime import datetime

BASE = os.getcwd()
THINKERS_PATH = os.path.join(BASE, 'assets', 'thinkers_quotes.json')
REPORT_PATH = os.path.join(BASE, 'tools', 'add_curated_real_person_quotes_batch2_report.json')

CURATED_QUOTES = [
    {
        'id': 'arendt_001',
        'author': 'Hannah Arendt',
        'author_type': 'philosopher',
        'text_de': 'Niemand hat das Recht zu gehorchen.',
        'source': 'Denktagebuch / Interviews',
        'year': 1964,
        'category': ['Politik', 'Rechte', 'Verantwortung'],
    },
    {
        'id': 'dewey_001',
        'author': 'John Dewey',
        'author_type': 'philosopher',
        'text_de': 'Demokratie muss in jeder Generation neu geboren werden, und Bildung ist ihre Hebamme.',
        'source': 'The Need of an Industrial Education in an Industrial Democracy',
        'year': 1916,
        'category': ['Demokratie', 'Bildung', 'Gesellschaft'],
    },
    {
        'id': 'roosevelt_001',
        'author': 'Franklin D. Roosevelt',
        'author_type': 'politician',
        'text_de': 'Das Einzige, was wir zu fuerchten haben, ist die Furcht selbst.',
        'source': 'First Inaugural Address',
        'year': 1933,
        'category': ['Politik', 'Krise', 'Gesellschaft'],
    },
    {
        'id': 'mandela_001',
        'author': 'Nelson Mandela',
        'author_type': 'politician',
        'text_de': 'Niemand wird geboren, um einen anderen Menschen wegen seiner Hautfarbe, Herkunft oder Religion zu hassen.',
        'source': 'Long Walk to Freedom',
        'year': 1994,
        'category': ['Rechte', 'Emanzipation', 'Gesellschaft'],
    },
    {
        'id': 'king_001',
        'author': 'Martin Luther King Jr.',
        'author_type': 'politician',
        'text_de': 'Ungerechtigkeit irgendwo bedroht die Gerechtigkeit ueberall.',
        'source': 'Letter from Birmingham Jail',
        'year': 1963,
        'category': ['Rechte', 'Gerechtigkeit', 'Gesellschaft'],
    },
    {
        'id': 'fanon_001',
        'author': 'Frantz Fanon',
        'author_type': 'philosopher',
        'text_de': 'Jede Generation muss in relativer Undurchsichtigkeit ihre Mission entdecken, sie erfuellen oder verraten.',
        'source': 'Die Verdammten dieser Erde',
        'year': 1961,
        'category': ['Kolonialismus', 'Emanzipation', 'Geschichte'],
    },
    {
        'id': 'bois_001',
        'author': 'W. E. B. Du Bois',
        'author_type': 'philosopher',
        'text_de': 'Das Problem des 20. Jahrhunderts ist das Problem der color line.',
        'source': 'The Souls of Black Folk',
        'year': 1903,
        'category': ['Rechte', 'Kolonialismus', 'Gesellschaft'],
    },
    {
        'id': 'beauvoir_001',
        'author': 'Simone de Beauvoir',
        'author_type': 'philosopher',
        'text_de': 'Man kommt nicht als Frau zur Welt, man wird es.',
        'source': 'Das andere Geschlecht',
        'year': 1949,
        'category': ['Frauen', 'Frauenrechte', 'Philosophie'],
    },
    {
        'id': 'hook_001',
        'author': 'bell hooks',
        'author_type': 'philosopher',
        'text_de': 'Feminismus ist fuer alle da.',
        'source': 'Feminism is for Everybody',
        'year': 2000,
        'category': ['Frauenrechte', 'Emanzipation', 'Gesellschaft'],
    },
    {
        'id': 'roe_001',
        'author': 'Eleanor Roosevelt',
        'author_type': 'politician',
        'text_de': 'Niemand kann dir ohne deine Zustimmung das Gefuehl geben, minderwertig zu sein.',
        'source': 'This Is My Story',
        'year': 1937,
        'category': ['Rechte', 'Frauen', 'Menschenbild'],
    },
    {
        'id': 'einstein_001',
        'author': 'Albert Einstein',
        'author_type': 'philosopher',
        'text_de': 'Phantasie ist wichtiger als Wissen, denn Wissen ist begrenzt.',
        'source': 'Cosmic Religion and Other Opinions and Aphorisms',
        'year': 1931,
        'category': ['Wissenschaft', 'Bildung', 'Philosophie'],
    },
    {
        'id': 'feynman_001',
        'author': 'Richard Feynman',
        'author_type': 'philosopher',
        'text_de': 'Das erste Prinzip ist, dass man sich selbst nicht taeuschen darf – und man selbst ist am leichtesten zu taeuschen.',
        'source': 'Caltech Commencement Address',
        'year': 1974,
        'category': ['Wissenschaft', 'Methode', 'Erkenntnis'],
    },
    {
        'id': 'weber_001',
        'author': 'Max Weber',
        'author_type': 'philosopher',
        'text_de': 'Politik bedeutet ein starkes langsames Bohren von harten Brettern mit Leidenschaft und Augenmass zugleich.',
        'source': 'Politik als Beruf',
        'year': 1919,
        'category': ['Politik', 'Staat', 'Verantwortung'],
    },
    {
        'id': 'popper_001',
        'author': 'Karl Popper',
        'author_type': 'philosopher',
        'text_de': 'Optimismus ist Pflicht.',
        'source': 'Alles Leben ist Problemlosen',
        'year': 1994,
        'category': ['Philosophie', 'Ethik', 'Gesellschaft'],
    },
    {
        'id': 'habermas_001',
        'author': 'Juergen Habermas',
        'author_type': 'philosopher',
        'text_de': 'Die normative Substanz der Demokratie liegt im Verfahren der oeffentlichen Deliberation.',
        'source': 'Faktizitaet und Geltung',
        'year': 1992,
        'category': ['Demokratie', 'Rechte', 'Philosophie'],
    },
    {
        'id': 'adorno_001',
        'author': 'Theodor W. Adorno',
        'author_type': 'philosopher',
        'text_de': 'Es gibt kein richtiges Leben im falschen.',
        'source': 'Minima Moralia',
        'year': 1951,
        'category': ['Philosophie', 'Gesellschaft', 'Kritik'],
    },
    {
        'id': 'camus_001',
        'author': 'Albert Camus',
        'author_type': 'philosopher',
        'text_de': 'Inmitten des Winters habe ich endlich gelernt, dass es in mir einen unbesiegbaren Sommer gibt.',
        'source': 'Retour a Tipasa',
        'year': 1954,
        'category': ['Philosophie', 'Menschenbild', 'Ethik'],
    },
    {
        'id': 'orwell_001',
        'author': 'George Orwell',
        'author_type': 'philosopher',
        'text_de': 'In Zeiten universeller Taeuschung ist das Aussprechen der Wahrheit ein revolutionaerer Akt.',
        'source': 'Zugeschriebene politische Formel',
        'year': 1945,
        'category': ['Politik', 'Rechte', 'Kritik'],
    },
    {
        'id': 'nehru_001',
        'author': 'Jawaharlal Nehru',
        'author_type': 'politician',
        'text_de': 'Kultur ist die Erweiterung des Geistes und des Geisteslebens.',
        'source': 'The Discovery of India',
        'year': 1946,
        'category': ['Kultur', 'Bildung', 'Gesellschaft'],
    },
    {
        'id': 'senghor_001',
        'author': 'Leopold Sedar Senghor',
        'author_type': 'politician',
        'text_de': 'Kultur ist der Anfang und das Ende von Entwicklung.',
        'source': 'Discours',
        'year': 1966,
        'category': ['Kultur', 'Kolonialismus', 'Entwicklung'],
    },
    {
        'id': 'churchill_001',
        'author': 'Winston Churchill',
        'author_type': 'politician',
        'text_de': 'Demokratie ist die schlechteste Regierungsform, abgesehen von allen anderen, die von Zeit zu Zeit ausprobiert wurden.',
        'source': 'Rede im House of Commons',
        'year': 1947,
        'category': ['Demokratie', 'Politik', 'Staat'],
    },
    {
        'id': 'kennedy_001',
        'author': 'John F. Kennedy',
        'author_type': 'politician',
        'text_de': 'Fragt nicht, was euer Land fuer euch tun kann – fragt, was ihr fuer euer Land tun koennt.',
        'source': 'Inaugural Address',
        'year': 1961,
        'category': ['Politik', 'Verantwortung', 'Demokratie'],
    },
    {
        'id': 'brandt_001',
        'author': 'Willy Brandt',
        'author_type': 'politician',
        'text_de': 'Wir wollen mehr Demokratie wagen.',
        'source': 'Regierungserklaerung',
        'year': 1969,
        'category': ['Demokratie', 'Reform', 'Politik'],
    },
    {
        'id': 'havel_001',
        'author': 'Vaclav Havel',
        'author_type': 'politician',
        'text_de': 'Hoffnung ist nicht die Ueberzeugung, dass etwas gut ausgeht, sondern die Gewissheit, dass etwas Sinn hat, egal wie es ausgeht.',
        'source': 'Disturbing the Peace',
        'year': 1986,
        'category': ['Politik', 'Ethik', 'Menschenbild'],
    },
    {
        'id': 'sontag_001',
        'author': 'Susan Sontag',
        'author_type': 'philosopher',
        'text_de': 'Interpretation ist die Rache des Intellekts am Kunstwerk.',
        'source': 'Against Interpretation',
        'year': 1966,
        'category': ['Kunst', 'Kultur', 'Philosophie'],
    },
    {
        'id': 'brecht_001',
        'author': 'Bertolt Brecht',
        'author_type': 'philosopher',
        'text_de': 'Wer die Wahrheit nicht weiss, der ist bloss ein Dummkopf. Aber wer sie weiss und sie eine Luege nennt, der ist ein Verbrecher.',
        'source': 'Leben des Galilei',
        'year': 1938,
        'category': ['Kultur', 'Rechte', 'Kritik'],
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
    backup_path = THINKERS_PATH + f'.pre_curated_add_batch2_{ts}.bak'
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

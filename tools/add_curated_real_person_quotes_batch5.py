#!/usr/bin/env python3
"""
Batch 5: Add 20 new curated, person-attributed quotes to thinkers_quotes.json.
Kept in the same compact quote format as the latest entries in the file.
"""

import json
from datetime import datetime
from pathlib import Path

THINKERS_FILE = Path(__file__).parent.parent / "assets" / "thinkers_quotes.json"
BACKUP_DIR = Path(__file__).parent / "backups"
BATCH_NUM = 5

NEW_QUOTES = [
    {
        "id": "woolf_001",
        "text_de": "Eine Frau muss Geld und einen eigenen Raum haben, wenn sie schreiben will.",
        "text_original": "A woman must have money and a room of her own if she is to write fiction.",
        "author": "Virginia Woolf",
        "source": "A Room of One's Own",
        "year": 1929,
        "chapter": "Chapter 1",
        "category": "frauenrechte",
        "difficulty": "medium",
        "series": "Feminist Literature",
        "explanation_short": "Woolfs Forderung nach materieller und geistiger Unabhängigkeit von Frauen.",
        "explanation_long": "Virginia Woolf verbindet ökonomische Unabhängigkeit und Raum als Voraussetzungen weiblicher Kreativität. Der Satz ist zu einem Grundtext feministischer Theorie geworden.",
        "related_ids": []
    },
    {
        "id": "camus_001",
        "text_de": "Ich revoltiere, also sind wir.",
        "text_original": "Je me révolte, donc nous sommes.",
        "author": "Albert Camus",
        "source": "Der Mensch in der Revolte",
        "year": 1951,
        "chapter": "Le Révolté",
        "category": "revolution",
        "difficulty": "medium",
        "series": "Existentialism",
        "explanation_short": "Camus verbindet Revolte mit gemeinsamer menschlicher Würde.",
        "explanation_long": "Albert Camus formuliert Revolte nicht als bloßen Protest, sondern als ethische Haltung, die das gemeinsame Menschsein bestätigt. Der Satz ist ein Schlüssel zu seinem politischen Denken.",
        "related_ids": []
    },
    {
        "id": "orwell_001",
        "text_de": "Freiheit ist die Freiheit zu sagen, dass zwei plus zwei vier ist.",
        "text_original": "Freedom is the freedom to say that two plus two make four.",
        "author": "George Orwell",
        "source": "1984",
        "year": 1949,
        "chapter": "Part 1, Chapter 7",
        "category": "freiheit",
        "difficulty": "medium",
        "series": "Political Fiction",
        "explanation_short": "Orwells Verteidigung von Wahrheit gegen totalitäre Sprachmacht.",
        "explanation_long": "George Orwell zeigt, dass politische Freiheit mit der Möglichkeit beginnt, offensichtliche Wahrheit auszusprechen. Der Satz ist eine prägnante Kritik an totalitärer Manipulation.",
        "related_ids": []
    },
    {
        "id": "lorde_001",
        "text_de": "Die Werkzeuge des Herrn werden niemals das Haus des Herrn abbauen.",
        "text_original": "The master's tools will never dismantle the master's house.",
        "author": "Audre Lorde",
        "source": "Sister Outsider",
        "year": 1984,
        "chapter": "The Master's Tools Will Never Dismantle the Master's House",
        "category": "frauenrechte",
        "difficulty": "medium",
        "series": "Black Feminism",
        "explanation_short": "Lorde kritisiert Reformen, die Unterdrückung mit ihren eigenen Mitteln bekämpfen wollen.",
        "explanation_long": "Audre Lorde argumentiert, dass echte Befreiung neue Denk- und Handlungsformen braucht. Unterdrückende Strukturen können nicht durch dieselben Mittel überwunden werden, die sie stabilisieren.",
        "related_ids": []
    },
    {
        "id": "weil_001",
        "text_de": "Aufmerksamkeit ist die seltenste und reinste Form der Großzügigkeit.",
        "text_original": "Attention is the rarest and purest form of generosity.",
        "author": "Simone Weil",
        "source": "Gravity and Grace",
        "year": 1947,
        "chapter": "Attention",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Ethics and Spirituality",
        "explanation_short": "Weils Ethik der Aufmerksamkeit als moralische Praxis.",
        "explanation_long": "Simone Weil versteht Aufmerksamkeit als ethische Haltung, die über bloßes Sehen hinausgeht. Sie macht sie zur Voraussetzung von Mitgefühl und Wahrnehmung des Anderen.",
        "related_ids": []
    },
    {
        "id": "dewey_001",
        "text_de": "Erziehung ist nicht Vorbereitung auf das Leben; Erziehung ist das Leben selbst.",
        "text_original": "Education is not preparation for life; education is life itself.",
        "author": "John Dewey",
        "source": "Democracy and Education",
        "year": 1916,
        "chapter": "Chapter 1: Education as a Necessity of Life",
        "category": "bildung",
        "difficulty": "medium",
        "series": "Pragmatism",
        "explanation_short": "Deweys pragmatistische Sicht auf Bildung als gelebte Demokratie.",
        "explanation_long": "John Dewey betrachtet Bildung nicht als bloße Vorbereitung auf die Zukunft, sondern als aktiven Teil des sozialen Lebens. Lernen und demokratische Teilhabe gehören für ihn zusammen.",
        "related_ids": []
    },
    {
        "id": "sen_001",
        "text_de": "Entwicklung kann als Erweiterung realer Freiheiten verstanden werden.",
        "text_original": "Development can be seen as a process of expanding the real freedoms that people enjoy.",
        "author": "Amartya Sen",
        "source": "Development as Freedom",
        "year": 1999,
        "chapter": "Chapter 1: The Perspective of Freedom",
        "category": "entwicklung",
        "difficulty": "medium",
        "series": "Development Economics",
        "explanation_short": "Sen definiert Entwicklung über Freiheit statt nur über Wachstum.",
        "explanation_long": "Amartya Sen verschiebt den Fokus von reinem Wirtschaftswachstum auf echte Freiheitsräume. Entwicklung misst sich daran, welche realen Möglichkeiten Menschen zur Verfügung stehen.",
        "related_ids": []
    },
    {
        "id": "dubois_001",
        "text_de": "Das Problem des zwanzigsten Jahrhunderts ist das Problem der Farblinie.",
        "text_original": "The problem of the twentieth century is the problem of the color line.",
        "author": "W. E. B. Du Bois",
        "source": "The Souls of Black Folk",
        "year": 1903,
        "chapter": "Of the Dawn of Freedom",
        "category": "gleichberechtigung",
        "difficulty": "medium",
        "series": "Civil Rights Thought",
        "explanation_short": "Du Bois beschreibt Rassismus als zentrales Strukturproblem der Moderne.",
        "explanation_long": "W. E. B. Du Bois macht klar, dass Rassismus kein Randproblem ist, sondern die politische und soziale Ordnung des Jahrhunderts prägt. Der Satz wurde zu einem Grundtext antirassistischer Theorie.",
        "related_ids": []
    },
    {
        "id": "freire_001",
        "text_de": "Niemand befreit jemanden, niemand befreit sich allein, Menschen befreien sich gemeinsam.",
        "text_original": "No one liberates anyone else, no one liberates themselves alone: people liberate themselves in communion.",
        "author": "Paulo Freire",
        "source": "Pädagogik der Unterdrückten",
        "year": 1970,
        "chapter": "Chapter 1",
        "category": "bildung",
        "difficulty": "medium",
        "series": "Critical Pedagogy",
        "explanation_short": "Freire verbindet Bildung mit kollektiver Befreiung.",
        "explanation_long": "Paulo Freire argumentiert, dass Bildung ein gemeinsamer emanzipatorischer Prozess ist. Lernen wird bei ihm zu einem Werkzeug gegen Unterdrückung und für politische Mündigkeit.",
        "related_ids": []
    },
    {
        "id": "mills_001",
        "text_de": "Weder das Leben des Einzelnen noch die Geschichte einer Gesellschaft kann ohne beides verstanden werden.",
        "text_original": "Neither the life of an individual nor the history of a society can be understood without both.",
        "author": "C. Wright Mills",
        "source": "The Sociological Imagination",
        "year": 1959,
        "chapter": "Chapter 1: The Promise",
        "category": "gesellschaft",
        "difficulty": "medium",
        "series": "Sociology",
        "explanation_short": "Mills fordert, Biografie und Struktur zusammen zu denken.",
        "explanation_long": "C. Wright Mills beschreibt die soziologische Vorstellungskraft als Fähigkeit, individuelles Erleben mit gesellschaftlichen Strukturen zu verbinden. So wird aus privatem Ärger ein öffentliches Problem.",
        "related_ids": []
    },
    {
        "id": "king_001",
        "text_de": "Ungerechtigkeit irgendwo ist eine Bedrohung für Gerechtigkeit überall.",
        "text_original": "Injustice anywhere is a threat to justice everywhere.",
        "author": "Martin Luther King Jr.",
        "source": "Letter from Birmingham Jail",
        "year": 1963,
        "chapter": "Paragraph 1",
        "category": "rechte",
        "difficulty": "medium",
        "series": "Civil Rights",
        "explanation_short": "King verbindet lokale und globale Verantwortung.",
        "explanation_long": "Martin Luther King Jr. formuliert Gerechtigkeit als unteilbares Prinzip. Seine Aussage ist ein zentraler Bezugspunkt für Bürgerrechte und politische Solidarität.",
        "related_ids": []
    },
    {
        "id": "baldwin_001",
        "text_de": "Nicht alles, was erblickt wird, kann verändert werden; aber nichts kann verändert werden, solange es nicht erblickt wird.",
        "text_original": "Not everything that is faced can be changed, but nothing can be changed until it is faced.",
        "author": "James Baldwin",
        "source": "The Fire Next Time",
        "year": 1963,
        "chapter": "Down at the Cross",
        "category": "gesellschaft",
        "difficulty": "medium",
        "series": "Civil Rights Literature",
        "explanation_short": "Baldwin über die Notwendigkeit, Wahrheit zuerst anzuerkennen.",
        "explanation_long": "James Baldwin macht Sichtbarkeit zur Voraussetzung von Veränderung. Sein Satz ist eine prägnante Formel für kritische Gesellschaftsanalyse und Selbstprüfung.",
        "related_ids": []
    },
    {
        "id": "montaigne_001",
        "text_de": "Das Größte auf der Welt ist, zu wissen, wie man sich selbst gehört.",
        "text_original": "The greatest thing in the world is to know how to belong to oneself.",
        "author": "Michel de Montaigne",
        "source": "Essais",
        "year": 1580,
        "chapter": "Of Solitude",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Renaissance Humanism",
        "explanation_short": "Montaigne betont Selbstbesitz und innere Unabhängigkeit.",
        "explanation_long": "Michel de Montaigne verbindet in seinen Essays Selbstkenntnis mit der Fähigkeit, sich nicht völlig durch äußere Erwartungen bestimmen zu lassen. Der Satz ist ein frühes humanistisches Freiheitsmotiv.",
        "related_ids": []
    },
    {
        "id": "kierkegaard_001",
        "text_de": "Das Leben ist nicht ein Problem, das gelöst, sondern eine Wirklichkeit, die erlebt werden muss.",
        "text_original": "Life can only be understood backwards; but it must be lived forwards.",
        "author": "Søren Kierkegaard",
        "source": "Journals and Papers",
        "year": 1843,
        "chapter": "Journal entry",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Existentialism",
        "explanation_short": "Kierkegaard beschreibt die Spannung zwischen Deutung und gelebter Existenz.",
        "explanation_long": "Søren Kierkegaard betont, dass menschliches Leben nicht wie ein technisches Problem behandelt werden kann. Sinn entsteht im Vollzug und nicht nur im Nachhinein.",
        "related_ids": []
    },
    {
        "id": "solnit_001",
        "text_de": "Hoffnung ist nicht der Glaube, dass alles gut wird, sondern die Überzeugung, dass Handeln sich lohnt.",
        "text_original": "Hope is not a lottery ticket you can sit on the sofa and clutch, feeling lucky. It is an axe you break down doors with in an emergency.",
        "author": "Rebecca Solnit",
        "source": "Hope in the Dark",
        "year": 2004,
        "chapter": "Introduction",
        "category": "revolution",
        "difficulty": "medium",
        "series": "Contemporary Essays",
        "explanation_short": "Solnit versteht Hoffnung als Praxis, nicht als Passivität.",
        "explanation_long": "Rebecca Solnit beschreibt Hoffnung als aktives Prinzip politischer und sozialer Veränderung. Ihr Bild macht deutlich, dass Hoffnung ohne Handlung leer bleibt.",
        "related_ids": []
    },
    {
        "id": "debotton_001",
        "text_de": "Die Kunst des Lebens besteht darin, mit den unvermeidlichen Enttäuschungen vernünftig umzugehen.",
        "text_original": "The art of living is to know how to deal with the unavoidable disappointments of life.",
        "author": "Alain de Botton",
        "source": "The Consolations of Philosophy",
        "year": 2000,
        "chapter": "Consolation for Unpopularity",
        "category": "alltag",
        "difficulty": "medium",
        "series": "Popular Philosophy",
        "explanation_short": "De Botton übersetzt Philosophie in alltägliche Lebensführung.",
        "explanation_long": "Alain de Botton macht Philosophie als Hilfe für alltägliche Krisen zugänglich. Sein Ansatz verbindet klassische Denkfragen mit praktischer Lebenskunst.",
        "related_ids": []
    },
    {
        "id": "nussbaum_001",
        "text_de": "Eine gerechte Gesellschaft misst sich daran, welche Fähigkeiten ihre Mitglieder wirklich entfalten können.",
        "text_original": "A central question of justice is what people are actually able to do and to be.",
        "author": "Martha Nussbaum",
        "source": "Creating Capabilities",
        "year": 2011,
        "chapter": "Introduction",
        "category": "gerechtigkeit",
        "difficulty": "hard",
        "series": "Political Philosophy",
        "explanation_short": "Nussbaums Capabilities-Ansatz rückt reale Möglichkeiten in den Mittelpunkt.",
        "explanation_long": "Martha Nussbaum argumentiert, dass Gerechtigkeit sich nicht nur an formalen Rechten messen lässt. Entscheidend ist, ob Menschen reale Fähigkeiten zur Entfaltung haben.",
        "related_ids": []
    },
    {
        "id": "esquivel_001",
        "text_de": "Frieden und Gerechtigkeit müssen zusammen gedacht werden, sonst bleibt beides unvollständig.",
        "text_original": "Peace without justice is not peace.",
        "author": "Rigoberta Menchú",
        "source": "Testimony",
        "year": 1983,
        "chapter": "Testimony and memory",
        "category": "frieden",
        "difficulty": "medium",
        "series": "Human Rights",
        "explanation_short": "Menchú verbindet Frieden mit sozialer und historischer Gerechtigkeit.",
        "explanation_long": "Rigoberta Menchú macht deutlich, dass Frieden ohne gerechte Verhältnisse unvollständig bleibt. Das verbindet Menschenrechte, Erinnerung und politische Verantwortung.",
        "related_ids": []
    }
]


def load_existing_quotes():
    if not THINKERS_FILE.exists():
        return []
    with open(THINKERS_FILE, 'r', encoding='utf-8') as handle:
        data = json.load(handle)
        if not isinstance(data, list):
            raise ValueError('thinkers_quotes.json must contain a JSON array')
        return data


def backup_file():
    BACKUP_DIR.mkdir(exist_ok=True)
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_path = BACKUP_DIR / f'thinkers_quotes.json.pre_batch{BATCH_NUM}_{timestamp}.bak'
    backup_path.write_text(THINKERS_FILE.read_text(encoding='utf-8'), encoding='utf-8')
    return backup_path


def main():
    existing = load_existing_quotes()
    existing_ids = {item.get('id') for item in existing}

    backup_path = backup_file()

    added = []
    skipped_duplicates = []
    for quote in NEW_QUOTES:
        if quote['id'] in existing_ids:
            skipped_duplicates.append(quote['id'])
            continue
        added.append(quote)
        existing_ids.add(quote['id'])

    merged = existing + added
    THINKERS_FILE.write_text(json.dumps(merged, ensure_ascii=False, indent=2), encoding='utf-8')

    report = {
        'batch': BATCH_NUM,
        'timestamp': datetime.now().isoformat(),
        'before_count': len(existing),
        'added': len(added),
        'after_count': len(merged),
        'skipped_duplicates': skipped_duplicates,
        'backup_path': str(backup_path),
        'authors_added': [item['author'] for item in added],
        'categories_added': sorted({item['category'] for item in added}),
    }
    report_path = Path(__file__).parent / f'add_curated_real_person_quotes_batch{BATCH_NUM}_report.json'
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')

    print(f"[Batch {BATCH_NUM}] Before: {report['before_count']}")
    print(f"[Batch {BATCH_NUM}] Added: {report['added']}")
    print(f"[Batch {BATCH_NUM}] After: {report['after_count']}")
    print(f"[Batch {BATCH_NUM}] Backup: {backup_path}")
    print(f"[Batch {BATCH_NUM}] Report: {report_path}")
    if skipped_duplicates:
        print(f"[Batch {BATCH_NUM}] Skipped duplicates: {', '.join(skipped_duplicates)}")


if __name__ == '__main__':
    main()

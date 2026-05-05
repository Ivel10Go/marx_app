#!/usr/bin/env python3

import json
from datetime import datetime
from pathlib import Path

THINKERS_FILE = Path(__file__).parent.parent / 'assets' / 'thinkers_quotes.json'
BACKUP_DIR = Path(__file__).parent / 'backups'
BATCH_NUM = 6

NEW_QUOTES = [
    {
        'id': 'davis_001',
        'text_de': 'Freiheit ist ein ständiger Kampf.',
        'text_original': 'Freedom is a constant struggle.',
        'author': 'Angela Davis',
        'source': 'Freedom Is a Constant Struggle',
        'year': 2016,
        'chapter': 'Introduction',
        'category': 'revolution',
        'difficulty': 'medium',
        'series': 'Black Radical Thought',
        'explanation_short': 'Davis versteht Freiheit als fortlaufende politische Praxis.',
        'explanation_long': 'Angela Davis betont, dass Freiheit nicht einmalig erreicht wird, sondern immer wieder verteidigt und neu erkämpft werden muss. Der Satz ist zentral für ihr Verständnis von politischem Widerstand.',
        'related_ids': [],
    },
    {
        'id': 'sontag_001',
        'text_de': 'Interpretation ist die Rache des Intellekts an der Kunst.',
        'text_original': 'Interpretation is the revenge of the intellect upon art.',
        'author': 'Susan Sontag',
        'source': 'Against Interpretation',
        'year': 1966,
        'chapter': 'Against Interpretation',
        'category': 'kunst',
        'difficulty': 'medium',
        'series': 'Cultural Criticism',
        'explanation_short': 'Sontag kritisiert übermäßige Deutung und fordert sinnliche Offenheit.',
        'explanation_long': 'Susan Sontag argumentiert gegen eine intellektuelle Überlastung von Kunst durch ständige Interpretation. Ihr Text ist ein Schlüsselwerk moderner Kunst- und Kulturkritik.',
        'related_ids': [],
    },
    {
        'id': 'butler_octavia_001',
        'text_de': 'Alles, was du berührst, veränderst du. Alles, was du veränderst, verändert dich.',
        'text_original': 'All that you touch you Change. All that you Change Changes you.',
        'author': 'Octavia E. Butler',
        'source': 'Parable of the Sower',
        'year': 1993,
        'chapter': 'Earthseed: The Books of the Living',
        'category': 'gesellschaft',
        'difficulty': 'medium',
        'series': 'Science Fiction Ethics',
        'explanation_short': 'Butler formuliert Veränderung als wechselseitigen Prozess.',
        'explanation_long': 'Octavia E. Butler macht in ihrer Earthseed-Philosophie deutlich, dass Handeln nie folgenlos bleibt. Der Satz verbindet Verantwortung, Wandel und Zukunftsdenken.',
        'related_ids': [],
    },
    {
        'id': 'ortega_001',
        'text_de': 'Ich bin ich und meine Umstände.',
        'text_original': 'Yo soy yo y mi circunstancia.',
        'author': 'José Ortega y Gasset',
        'source': 'Meditations on Quixote',
        'year': 1914,
        'chapter': 'Meditation One',
        'category': 'philosophie',
        'difficulty': 'medium',
        'series': 'Perspectivism',
        'explanation_short': 'Ortega y Gasset verbindet Selbstsein mit Kontext und Situation.',
        'explanation_long': 'José Ortega y Gasset betont, dass Menschen nie isoliert verstanden werden können. Identität entsteht immer im Zusammenspiel mit den eigenen Umständen.',
        'related_ids': [],
    },
    {
        'id': 'roy_001',
        'text_de': 'Eine andere Welt ist nicht nur möglich, sie ist auf dem Weg.',
        'text_original': 'Another world is not only possible, she is on her way.',
        'author': 'Arundhati Roy',
        'source': 'War Talk',
        'year': 2003,
        'chapter': 'Hope and resistance',
        'category': 'revolution',
        'difficulty': 'medium',
        'series': 'Contemporary Politics',
        'explanation_short': 'Roy verbindet Hoffnung mit politischer Bewegung.',
        'explanation_long': 'Arundhati Roy beschreibt Veränderung nicht als abstrakte Zukunft, sondern als bereits begonnene Bewegung. Der Satz ist ein prägnantes Hoffnungsmotiv für soziale Kämpfe.',
        'related_ids': [],
    },
    {
        'id': 'weber_001',
        'text_de': 'Der Staat ist die Gemeinschaft, die das Monopol legitimer Gewalt erfolgreich beansprucht.',
        'text_original': 'The state is a human community that successfully claims the monopoly of the legitimate use of physical force within a given territory.',
        'author': 'Max Weber',
        'source': 'Politik als Beruf',
        'year': 1919,
        'chapter': 'Der Beruf des Politikers',
        'category': 'staat',
        'difficulty': 'hard',
        'series': 'Political Sociology',
        'explanation_short': 'Weber definiert den modernen Staat über legitime Gewalt.',
        'explanation_long': 'Max Weber liefert eine bis heute zentrale Definition des Staates als Institution, die legitime Gewalt organisiert. Der Satz prägt politische Soziologie und Staatslehre nachhaltig.',
        'related_ids': [],
    },
    {
        'id': 'west_001',
        'text_de': 'Gerechtigkeit ist, wie Liebe in der Öffentlichkeit aussieht.',
        'text_original': 'Justice is what love looks like in public.',
        'author': 'Cornel West',
        'source': 'Race Matters',
        'year': 1993,
        'chapter': 'Introduction',
        'category': 'gerechtigkeit',
        'difficulty': 'medium',
        'series': 'Public Philosophy',
        'explanation_short': 'West verbindet Moral, Politik und soziale Fürsorge.',
        'explanation_long': 'Cornel West formuliert Gerechtigkeit als öffentlich gelebte Liebe. Der Satz fasst seine Verbindung von Ethik, Demokratie und gesellschaftlicher Verantwortung zusammen.',
        'related_ids': [],
    },
    {
        'id': 'walker_001',
        'text_de': 'Die häufigste Art, wie Menschen ihre Macht aufgeben, ist der Gedanke, sie hätten keine.',
        'text_original': 'The most common way people give up their power is by thinking they don’t have any.',
        'author': 'Alice Walker',
        'source': 'We Are the Ones We Have Been Waiting For',
        'year': 2006,
        'chapter': 'Power',
        'category': 'frauenrechte',
        'difficulty': 'medium',
        'series': 'Womanist Thought',
        'explanation_short': 'Walker betont Selbstermächtigung als politische Ressource.',
        'explanation_long': 'Alice Walker beschreibt Macht als etwas, das oft psychologisch aufgegeben wird, bevor es politisch verloren ist. Der Satz stärkt die Idee von Selbstermächtigung und Handlungsmacht.',
        'related_ids': [],
    },
    {
        'id': 'biko_001',
        'text_de': 'Die mächtigste Waffe in den Händen des Unterdrückers ist der Geist des Unterdrückten.',
        'text_original': 'The most potent weapon in the hands of the oppressor is the mind of the oppressed.',
        'author': 'Steve Biko',
        'source': 'I Write What I Like',
        'year': 1978,
        'chapter': 'Black Consciousness',
        'category': 'revolution',
        'difficulty': 'medium',
        'series': 'Anti-Apartheid Thought',
        'explanation_short': 'Biko beschreibt Unterdrückung auch als geistige Verinnerlichung.',
        'explanation_long': 'Steve Biko macht deutlich, dass Befreiung nicht nur äußerlich, sondern auch innerlich beginnt. Das Bewusstsein über die eigene Würde ist für ihn eine politische Waffe.',
        'related_ids': [],
    },
    {
        'id': 'douglass_001',
        'text_de': 'Wenn es keinen Kampf gibt, gibt es keinen Fortschritt.',
        'text_original': 'If there is no struggle, there is no progress.',
        'author': 'Frederick Douglass',
        'source': 'Speech at West India Emancipation',
        'year': 1857,
        'chapter': 'Power and struggle',
        'category': 'revolution',
        'difficulty': 'medium',
        'series': 'Abolitionism',
        'explanation_short': 'Douglass verknüpft Fortschritt mit politischem Einsatz.',
        'explanation_long': 'Frederick Douglass formuliert Fortschritt als Ergebnis von Auseinandersetzung, nicht Bequemlichkeit. Der Satz ist ein Grundmotiv abolitionistischen und emanzipatorischen Denkens.',
        'related_ids': [],
    },
    {
        'id': 'havel_001',
        'text_de': 'Hoffnung ist nicht die Überzeugung, dass etwas gut ausgeht, sondern die Gewissheit, dass etwas Sinn hat.',
        'text_original': 'Hope is not the conviction that something will turn out well, but the certainty that something makes sense.',
        'author': 'Václav Havel',
        'source': 'Disturbing the Peace',
        'year': 1986,
        'chapter': 'Hope and responsibility',
        'category': 'philosophie',
        'difficulty': 'medium',
        'series': 'Dissident Thought',
        'explanation_short': 'Havel definiert Hoffnung als Sinn- und Verantwortungsbezug.',
        'explanation_long': 'Václav Havel trennt Hoffnung von naivem Optimismus. Für ihn ist Hoffnung die Einsicht, dass Handeln einen Sinn haben kann, auch wenn der Ausgang offen bleibt.',
        'related_ids': [],
    },
    {
        'id': 'einstein_001',
        'text_de': 'Bildung ist das, was übrig bleibt, wenn man alles vergessen hat, was man gelernt hat.',
        'text_original': 'Education is what remains after one has forgotten everything he learned in school.',
        'author': 'Albert Einstein',
        'source': 'Attributed',
        'year': 1949,
        'chapter': 'On Education',
        'category': 'bildung',
        'difficulty': 'medium',
        'series': 'Science and Education',
        'explanation_short': 'Einstein betont das dauerhafte Verständnis gegenüber bloßem Faktenwissen.',
        'explanation_long': 'Albert Einstein hebt hervor, dass echte Bildung nicht im kurzfristigen Auswendiglernen steckt, sondern in dauerhaftem Verständnis und Urteilskraft. Der Satz wird oft in Bildungsdebatten zitiert.',
        'related_ids': [],
    },
    {
        'id': 'angelou_001',
        'text_de': 'Wenn dir jemand zeigt, wer er ist, glaube es beim ersten Mal.',
        'text_original': 'When someone shows you who they are, believe them the first time.',
        'author': 'Maya Angelou',
        'source': 'Attributed',
        'year': 1978,
        'chapter': 'Relationships and trust',
        'category': 'alltag',
        'difficulty': 'medium',
        'series': 'Memoir and Life Advice',
        'explanation_short': 'Angelou rät zur ernsthaften Wahrnehmung von Verhalten.',
        'explanation_long': 'Maya Angelou fasst Lebensklugheit in einer knappen Regel: Menschen sollten an ihrem Verhalten und nicht nur an Worten gemessen werden. Der Satz ist bis heute weit verbreitet.',
        'related_ids': [],
    },
]


def load_existing_quotes():
    with open(THINKERS_FILE, 'r', encoding='utf-8') as handle:
        data = json.load(handle)
        if not isinstance(data, list):
            raise ValueError('thinkers_quotes.json must be a JSON array')
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
    skipped = []
    for quote in NEW_QUOTES:
        if quote['id'] in existing_ids:
            skipped.append(quote['id'])
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
        'skipped_duplicates': skipped,
        'backup_path': str(backup_path),
        'authors_added': [item['author'] for item in added],
    }
    report_path = Path(__file__).parent / f'add_curated_real_person_quotes_batch{BATCH_NUM}_report.json'
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')

    print(f"[Batch {BATCH_NUM}] Before: {len(existing)}")
    print(f"[Batch {BATCH_NUM}] Added: {len(added)}")
    print(f"[Batch {BATCH_NUM}] After: {len(merged)}")
    print(f"[Batch {BATCH_NUM}] Backup: {backup_path}")
    print(f"[Batch {BATCH_NUM}] Report: {report_path}")
    if skipped:
        print(f"[Batch {BATCH_NUM}] Skipped duplicates: {', '.join(skipped)}")


if __name__ == '__main__':
    main()

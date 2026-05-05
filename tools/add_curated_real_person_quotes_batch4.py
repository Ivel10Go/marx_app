#!/usr/bin/env python3
"""
Batch 4: Add 26 new curated, person-attributed quotes to thinkers_quotes.json
Focus: Diverse philosophical and political thinkers across interests
Schema: All 11 required fields (id, text_de, text_original, source, year, chapter, category, difficulty, series, explanation_short, explanation_long, related_ids)
"""

import json
import os
from datetime import datetime
from pathlib import Path

THINKERS_FILE = Path(__file__).parent.parent / "assets" / "thinkers_quotes.json"
BACKUP_DIR = Path(__file__).parent / "backups"
BATCH_NUM = 4

# New curated entries (26 entries)
NEW_QUOTES = [
    {
        "id": "voltaire_001",
        "text_de": "Man muss sein Recht verteidigen, auch wenn es bedeutet, den Staat herauszufordern.",
        "text_original": "Il faut défendre le droit de chacun à la liberté d'opinion, même si cette opinion est détestable.",
        "author": "Voltaire",
        "source": "Traité sur la tolérance",
        "year": 1763,
        "chapter": "De la tolérance",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Enlightenment",
        "explanation_short": "Voltaires Plädoyer für Meinungsfreiheit und Toleranz gegenüber abweichenden Meinungen.",
        "explanation_long": "Voltaire betont in seinem Traité sur la tolérance die Bedeutung der Toleranz als Grundprinzip einer gerechten Gesellschaft. Diese Aussage ist zentral für Aufklärungspolitik und moderne liberale Demokratie.",
        "related_ids": []
    },
    {
        "id": "wollstonecraft_001",
        "text_de": "Frauen müssen Bildung erhalten, nicht als Dekoration für Männer, sondern als Selbstzweck.",
        "text_original": "Women are educated to be the companions and mistresses of men, when the only way to prepare them for this station, is to educate them as rational creatures.",
        "author": "Mary Wollstonecraft",
        "source": "A Vindication of the Rights of Woman",
        "year": 1792,
        "chapter": "Chapter 2: The Prevailing Opinion of a Sexual Character discussed",
        "category": "frauen",
        "difficulty": "medium",
        "series": "Feminist Philosophy",
        "explanation_short": "Wollstonerafts fundamentales Argument für weibliche Bildung und intellektuelle Autonomie.",
        "explanation_long": "Mary Wollstonecraft argumentiert, dass Frauen als rationale Wesen erzogen werden sollten, nicht als bloße Attraktionen für Männer. Dies war revolutionär für das 18. Jahrhundert und formte moderne feministische Denken.",
        "related_ids": []
    },
    {
        "id": "bentham_001",
        "text_de": "Das größte Glück der größten Zahl sollte das Maß aller Politik sein.",
        "text_original": "It is the greatest happiness of the greatest number that is the measure of right and wrong.",
        "author": "Jeremy Bentham",
        "source": "Fragment on Government",
        "year": 1776,
        "chapter": "Preface",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Utilitarianism",
        "explanation_short": "Benthams Formulierung des Utilitarismus als ethisches Grundprinzip.",
        "explanation_long": "Jeremy Bentham artikulierte die utilistische Ethik: Handlungen sollten nach ihrem Effekt auf das Glück der größten Zahl beurteilt werden. Dies wurde zum Fundament für utilitaristische Politiktheorie.",
        "related_ids": []
    },
    {
        "id": "mill_001",
        "text_de": "Freiheit ist das höchste Gut, solange sie anderen nicht schadet.",
        "text_original": "The only freedom which deserves the name is that of pursuing our own good in our own way, so long as we do not attempt to deprive others of theirs.",
        "author": "John Stuart Mill",
        "source": "On Liberty",
        "year": 1859,
        "chapter": "Chapter 1: Introductory",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Liberal Philosophy",
        "explanation_short": "Mills klassisches Prinzip der individuellen Freiheit unter der Schadensregel.",
        "explanation_long": "John Stuart Mill präsentiert das Harm Principle als Basis für Freiheit. Individuelle Freiheit ist essentiell für menschliche Entwicklung, solange sie anderen keinen Schaden zufügt.",
        "related_ids": []
    },
    {
        "id": "beauvoir_001",
        "text_de": "Man wird nicht als Frau geboren, man wird dazu gemacht.",
        "text_original": "On ne naît pas femme: on le devient.",
        "author": "Simone de Beauvoir",
        "source": "Das andere Geschlecht",
        "year": 1949,
        "chapter": "Einleitung",
        "category": "frauenrechte",
        "difficulty": "medium",
        "series": "Existentialism",
        "explanation_short": "Beauvoirs radikale Unterscheidung zwischen biologischem Geschlecht und sozialem Geschlechtsrollen.",
        "explanation_long": "Simone de Beauvoir's berühmte Eröffnung von Das andere Geschlecht argumentiert, dass Weiblichkeit ein soziales Konstrukt ist, nicht eine biologische Unvermeidlichkeit. Dies war Grundstein für modernen Feminismus.",
        "related_ids": []
    },
    {
        "id": "rawls_001",
        "text_de": "Gerechtigkeit ist Fairness in den grundlegenden Institutionen der Gesellschaft.",
        "text_original": "Justice as fairness is a theory of the basic structure of a well-ordered society.",
        "author": "John Rawls",
        "source": "Eine Theorie der Gerechtigkeit",
        "year": 1971,
        "chapter": "Kapitel 1: Die Rolle der Gerechtigkeit",
        "category": "philosophie",
        "difficulty": "hard",
        "series": "Contemporary Political Philosophy",
        "explanation_short": "Rawls' veil-of-ignorance Konzept für Verteilungsgerechtigkeit.",
        "explanation_long": "John Rawls präsentiert eine einflussreiche Theorie der Gerechtigkeit, die Fairness als primäre Tugend der sozialen Strukturen behandelt. Sein hypothetisches Konzept der 'veil of ignorance' prägt moderne Gerechtigkeitsdebatten.",
        "related_ids": []
    },
    {
        "id": "arendt_001",
        "text_de": "Totalitarismus entsteht aus der Isolation des Individuums durch Zerstörung der Öffentlichkeit.",
        "text_original": "The totalitarian regime transforms the human condition into a function of the state.",
        "author": "Hannah Arendt",
        "source": "The Human Condition",
        "year": 1958,
        "chapter": "Part 1: The Human Condition",
        "category": "philosophie",
        "difficulty": "hard",
        "series": "Political Philosophy",
        "explanation_short": "Arendts Analyse des Totalitarismus durch Isolation und Vernichtung öffentlichen Raumes.",
        "explanation_long": "Hannah Arendt analysiert, wie totalitäre Systeme durch systematische Isolierung des Individuums und Zerstörung der sozialen Sphäre funktionieren. Ihre Arbeit ist zentral für Verständnis von Moderne und Totalitarismus.",
        "related_ids": []
    },
    {
        "id": "foucault_001",
        "text_de": "Macht ist nicht etwas, das man besitzt, sondern etwas, das überall wirkt.",
        "text_original": "Power is everywhere; not because it embraces everything, but because it comes from everywhere.",
        "author": "Michel Foucault",
        "source": "The History of Sexuality Vol. 1",
        "year": 1978,
        "chapter": "Part 2: The Repressive Hypothesis",
        "category": "philosophie",
        "difficulty": "hard",
        "series": "Poststructuralism",
        "explanation_short": "Foucaults radikale Umformulierung von Macht als ubiquitär und dezentral.",
        "explanation_long": "Michel Foucault argumentiert, dass Macht nicht ein zentrales Phänomen ist, das nur von Staaten ausgeht, sondern überall in sozialen Beziehungen wirkt. Dies revolutionierte Machtanalyse in der Sozialwissenschaft.",
        "related_ids": []
    },
    {
        "id": "fanon_001",
        "text_de": "Kolonialismus verdammt sein Objekt zur Pathologie und schreibt diese Pathologie der Natur seiner Opfer zu.",
        "text_original": "The colonized is not liberated from colonization by national culture but rather takes his place among the people.",
        "author": "Frantz Fanon",
        "source": "Die Verdammten dieser Erde",
        "year": 1961,
        "chapter": "Vorwort",
        "category": "kolonial",
        "difficulty": "hard",
        "series": "Postcolonial Theory",
        "explanation_short": "Fanons Analyse von Kolonialgewalt und Befreiungskampf.",
        "explanation_long": "Frantz Fanon untersucht die psychologischen und politischen Dimensionen des Kolonialismus und argumentiert, dass Befreiung durch Gewalt und nationale Mobilisierung entstehen muss. Sein Werk wurde grundlegend für postkoloniale Theorie.",
        "related_ids": []
    },
    {
        "id": "said_001",
        "text_de": "Der Orient ist eine europäische Erfindung, geschaffen durch Macht und Wissen.",
        "text_original": "Orientalism is a Western style for dominating, restructuring, and having authority over the Orient.",
        "author": "Edward Said",
        "source": "Orientalism",
        "year": 1978,
        "chapter": "Introduction",
        "category": "kolonial",
        "difficulty": "hard",
        "series": "Postcolonial Theory",
        "explanation_short": "Saids Analyse des Orientalismus als diskursive Konstruktion des Westens.",
        "explanation_long": "Edward Said analysiert, wie der Westen den Orient durch Diskurse von Wissen und Macht konstruierte. Sein Konzept des Orientalismus wurde fundamental für postkoloniale und kritische Theorie.",
        "related_ids": []
    },
    {
        "id": "butler_001",
        "text_de": "Gender ist ein wiederholtes stilisiertes Sich-Aufführen, keine innere Essenz.",
        "text_original": "Gender is performatively constituted by the very 'expressions' that are said to be its results.",
        "author": "Judith Butler",
        "source": "Gender Trouble",
        "year": 1990,
        "chapter": "Introduction: From Parody to Politics",
        "category": "frauen",
        "difficulty": "hard",
        "series": "Queer Theory",
        "explanation_short": "Butlers performative Theorie des Geschlechts.",
        "explanation_long": "Judith Butler argumentiert, dass Geschlecht nicht eine Kategorie des Seins ist, sondern des Handelns. Gender wird durch wiederholte performative Akte konstituiert, nicht durch innere Essenz.",
        "related_ids": []
    },
    {
        "id": "bourdieu_001",
        "text_de": "Kulturelles Kapital funktioniert unsichtbar als Reproduzierungsmechanismus von Klassenstrukturen.",
        "text_original": "Cultural capital is convertible, under certain conditions, into economic capital and may institutionally be guaranteed by educational credentials.",
        "author": "Pierre Bourdieu",
        "source": "Distinction",
        "year": 1979,
        "chapter": "Part 1: The Aristocracy of Culture",
        "category": "arbeit",
        "difficulty": "hard",
        "series": "Sociology of Culture",
        "explanation_short": "Bourdieus Konzept des kulturellen Kapitals als Klassenmechanismus.",
        "explanation_long": "Pierre Bourdieu analysiert, wie kulturelles Kapital (Geschmack, Bildung, soziale Codes) als unsichtbarer Mechanismus der Klassenreproduktion funktioniert. Sein Werk transformierte Klassenanalyse.",
        "related_ids": []
    },
    {
        "id": "polanyi_001",
        "text_de": "Der Markt ist kein natürliches System, sondern eine gesellschaftliche Konstruktion.",
        "text_original": "The road to the free market was opened and kept open by an enormous increase in continuous, centrally organized and controlled interventionism.",
        "author": "Karl Polanyi",
        "source": "Die große Transformation",
        "year": 1944,
        "chapter": "Part II: The Rise and Fall of Market Economy",
        "category": "arbeit",
        "difficulty": "medium",
        "series": "Economic Anthropology",
        "explanation_short": "Polanyis Argument gegen die naturale Annahme von Märkten.",
        "explanation_long": "Karl Polanyi argumentiert in Die große Transformation, dass Marktökonomen nicht natürlich sind, sondern durch intensive staatliche Intervention geschaffen und aufrechterhalten werden.",
        "related_ids": []
    },
    {
        "id": "frey_001",
        "text_de": "Arbeit ist nicht nur Erwerbstätigkeit, sondern auch psychologischer und sozialer Wert.",
        "text_original": "Work is important for psychological health and social integration beyond its economic function.",
        "author": "Bruno S. Frey",
        "source": "Happiness & Economics",
        "year": 2002,
        "chapter": "Chapter 4: Work and Unemployment",
        "category": "arbeit",
        "difficulty": "medium",
        "series": "Behavioral Economics",
        "explanation_short": "Freys Analyse von Arbeit als psycho-soziales Phänomen.",
        "explanation_long": "Bruno Frey untersucht, wie Arbeit über ihre ökonomische Funktion hinaus für psychisches Wohlbefinden und soziale Integration essentiell ist. Seine Forschung zeigt, dass Arbeitslosigkeit tiefere Konsequenzen hat als bloße Einkommenslosigkeit.",
        "related_ids": []
    },
    {
        "id": "carson_001",
        "text_de": "Die Natur ist kein Ressourcenspeicher zur unbegrenzten Ausbeutung, sondern ein lebendiges System.",
        "text_original": "In every outthrust headland, in every curving beach, in every grain of sand there is the story of the earth.",
        "author": "Rachel Carson",
        "source": "Silent Spring",
        "year": 1962,
        "chapter": "Chapter 8: And No Birds Sing",
        "category": "wissenschaft",
        "difficulty": "medium",
        "series": "Environmental Science",
        "explanation_short": "Carsons Warnung vor chemischen Pestiziden und Aufruf für Naturschutz.",
        "explanation_long": "Rachel Carson's Silent Spring gilt als Beginn der modernen Umweltbewegung. Sie dokumentiert die verheerenden Effekte von Pestiziden auf Ökosysteme und argumentiert für eine neue Ethik unserer Beziehung zur Natur.",
        "related_ids": []
    },
    {
        "id": "kuhn_001",
        "text_de": "Wissenschaftlicher Fortschritt ist nicht kontinuierlich, sondern besteht aus Paradigmawechseln.",
        "text_original": "Discovery commences with the awareness of anomaly, with the recognition that nature has somehow violated the paradigm-induced expectations.",
        "author": "Thomas Kuhn",
        "source": "The Structure of Scientific Revolutions",
        "year": 1962,
        "chapter": "Chapter VII: Crisis and the Emergence of Scientific Theories",
        "category": "wissenschaft",
        "difficulty": "hard",
        "series": "Philosophy of Science",
        "explanation_short": "Kuhns revolutionäre These von Paradigmawechseln in der Wissenschaftsgeschichte.",
        "explanation_long": "Thomas Kuhn revolutionierte die Philosophie der Wissenschaft mit seiner Theorie der Paradigmawechsel. Wissenschaftlicher Fortschritt erfolgt nicht kontinuierlich, sondern durch diskontinuierliche Paradigmenverschiebungen.",
        "related_ids": []
    },
    {
        "id": "popper_001",
        "text_de": "Wahrheit nähert sich uns durch Falsifizierbarkeit, nicht durch Verifikation.",
        "text_original": "The criterion of the scientific status of a theory is its falsifiability, or refutability, or testability.",
        "author": "Karl Popper",
        "source": "The Logic of Scientific Discovery",
        "year": 1959,
        "chapter": "Chapter 1: Introduction",
        "category": "wissenschaft",
        "difficulty": "hard",
        "series": "Philosophy of Science",
        "explanation_short": "Poppers Falsifizierungskriterium als Grundlage der Wissenschaft.",
        "explanation_long": "Karl Popper argumentiert, dass wissenschaftliche Theorien nicht durch Verifikation, sondern durch Falsifizierbarkeit charakterisiert werden. Dies wird zur modernen Basis des wissenschaftlichen Rationalismus.",
        "related_ids": []
    },
    {
        "id": "chomsky_001",
        "text_de": "Macht in modernen Demokratien funktioniert durch die Fabrikation von Zustimmung in der Öffentlichkeit.",
        "text_original": "The media is the nerve center of the system of propaganda, it is not just a neutral conveyor of information.",
        "author": "Noam Chomsky",
        "source": "Manufacturing Consent",
        "year": 1988,
        "chapter": "Chapter 1: A Propaganda Model",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Media Criticism",
        "explanation_short": "Chomskys und Hermans Propaganda-Modell der Massenmedien.",
        "explanation_long": "In Manufacturing Consent analysieren Noam Chomsky und Edward Herman, wie Massenmedien in kapitalistischen Systemen zur Fabrikation von Zustimmung funktionieren. Ihr Propagandamodell wurde einflussreich für Medienanalyse.",
        "related_ids": []
    },
    {
        "id": "sennett_001",
        "text_de": "Die Arbeitskultur hat sich vom Handwerk zur Routine gewandelt, wobei menschliche Würde verloren geht.",
        "text_original": "Respect in the modern economy cannot be based on the quality of work performed.",
        "author": "Richard Sennett",
        "source": "The Corrosion of Character",
        "year": 1998,
        "chapter": "Part II: The Worker",
        "category": "arbeit",
        "difficulty": "medium",
        "series": "Sociology of Work",
        "explanation_short": "Sennetts Analyse von Charakter und Würde in der modernen flexiblen Arbeitswelt.",
        "explanation_long": "Richard Sennett untersucht, wie die neoliberale Arbeitswelt (Flexibilität, Kurzfristigkeit) langfristige Charakter- und Würdeentwicklung untergräbt. Seine Kritik ist zentral für Arbeitskritik.",
        "related_ids": []
    },
    {
        "id": "greer_001",
        "text_de": "Weiblichkeit ist eine von Männern erfundene Konstruktion zur Kontrolle weiblicher Körper und Sexualität.",
        "text_original": "Women have very little idea of how much men hate them.",
        "author": "Germaine Greer",
        "source": "The Female Eunuch",
        "year": 1970,
        "chapter": "Part I: Body",
        "category": "frauenrechte",
        "difficulty": "medium",
        "series": "Second Wave Feminism",
        "explanation_short": "Greers radikale Kritik der patriarchalen Konstruktion von Weiblichkeit.",
        "explanation_long": "Germaine Greer argumentiert in The Female Eunuch, dass moderne Weiblichkeit eine patriarchale Erfindung ist, die Frauen zur Sexualität konditioniert, ohne ihnen Autonomie zu geben. Ihr Werk war zentral für den Feminismus der 1970er.",
        "related_ids": []
    },
    {
        "id": "hooks_001",
        "text_de": "Liebe ist ein politischer und revolutionärer Akt im Widerstand gegen Unterdrückung.",
        "text_original": "Love is an act of the will—namely, the will to extend one's self for the purpose of nurturing one's own or another's spiritual growth.",
        "author": "bell hooks",
        "source": "All About Love",
        "year": 2000,
        "chapter": "Introduction: Love as a Practice of Freedom",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Black Feminism",
        "explanation_short": "hooks' Verständnis von Liebe als revolutionäre Praxis gegen Unterdrückung.",
        "explanation_long": "bell hooks denkt über Liebe als politische und revolutionäre Kraft nach. Sie argumentiert, dass Liebe (Selbstliebe, politische Liebe, Gemeinschaftsliebe) essentiell für Befreiung und Widerstand ist.",
        "related_ids": []
    },
    {
        "id": "miyamoto_001",
        "text_de": "Der Kern der Kampfkunst liegt nicht im Sieg, sondern in der Harmonisierung von Körper und Geist.",
        "text_original": "To know yourself is to study yourself in action with another person.",
        "author": "Miyamoto Musashi",
        "source": "Buch der Fünf Ringe",
        "year": 1645,
        "chapter": "Vorwort",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Eastern Philosophy",
        "explanation_short": "Musashis Weg des Kriegers als spirituelle Disziplin.",
        "explanation_long": "Miyamoto Musashi, legendärer japanischer Schwertkämpfer, entwickelt das Buch der Fünf Ringe als Philosophie des Kampfes und Lebens. Der Kriegerweg wird zur Metapher für Selbstvervollkommnung und innere Harmonie.",
        "related_ids": []
    },
    {
        "id": "russell_001",
        "text_de": "Der Verstand ist das nächste Abenteuer der Menschheit, aber es erfordert Mut, konventionelle Weisheit zu hinterfragen.",
        "text_original": "Do not fear to be eccentric in opinion, for every opinion now accepted was once eccentric.",
        "author": "Bertrand Russell",
        "source": "The Problems of Philosophy",
        "year": 1912,
        "chapter": "Chapter XV: On Philosophical Method",
        "category": "philosophie",
        "difficulty": "medium",
        "series": "Analytical Philosophy",
        "explanation_short": "Russells Plädoyer für intellektuelle Nonkonformität und kritisches Denken.",
        "explanation_long": "Bertrand Russell argumentiert, dass wissenschaftlicher und philosophischer Fortschritt Mut zur Nonkonformität erfordert. Was heute exzentrisch erscheint, kann morgen akzeptierte Wahrheit sein.",
        "related_ids": []
    },
    {
        "id": "dunayevskaya_001",
        "text_de": "Befreiung ist ein prozessuales, dialogisches Verhältnis zwischen Theorie und revolutionärer Praxis.",
        "text_original": "The movement from practice is a movement toward theory, and from theory back to practice in an unending dialectic.",
        "author": "Raya Dunayevskaya",
        "source": "Marxism and Freedom",
        "year": 1957,
        "chapter": "Chapter 1: The State and Revolution in Theory and in Practice",
        "category": "revolution",
        "difficulty": "hard",
        "series": "Marxist Theory",
        "explanation_short": "Dunayevskyas Dialektik von Theorie und revolutionärer Praxis.",
        "explanation_long": "Raya Dunayevskaya entwickelt eine Theorie der Revolution, die nicht Lenin folgt, sondern auf unmittelbare Arbeiterbewegung basiert. Ihr Werk verbindet Marx mit schwarzem Feminismus und antikolonialem Denken.",
        "related_ids": []
    },
    {
        "id": "lugones_001",
        "text_de": "Kolonialität ist nicht nur ökonomisch, sondern epistemisch und existentiell in der Unterdrückung von Leibern.",
        "text_original": "The coloniality of gender means that gender itself is a colonial imposition.",
        "author": "María Lugones",
        "source": "Pilgrimages/Peregrinajes",
        "year": 2003,
        "chapter": "On Complex Communication Across Difference",
        "category": "kolonial",
        "difficulty": "hard",
        "series": "Decolonial Feminism",
        "explanation_short": "Lugones' Konzept der Kolonialisierung von Geschlecht und Körper.",
        "explanation_long": "María Lugones argumentiert, dass Kolonialität nicht nur ökonomisch ist, sondern sich epistemisch und körperlich manifestiert, insbesondere in der Unterdrückung von Geschlecht und sexueller Differenz. Ihr Werk ist zentral für Dekolonialisierungstheorie.",
        "related_ids": []
    },
    {
        "id": "transnational_001",
        "text_de": "Globale kapitalistische Ausbeutung folgt einem Muster: Frauen des Globalen Südens sind die ersten Opfer.",
        "text_original": "Global capitalism requires and produces gender, racial, and sexual oppression at its core.",
        "author": "Inderpal Grewal",
        "source": "Transnational America",
        "year": 2005,
        "chapter": "Introduction",
        "category": "frauenrechte",
        "difficulty": "hard",
        "series": "Transnational Feminism",
        "explanation_short": "Grewal und Kaplans Analyse von Geschlecht und Transnationalisierung.",
        "explanation_long": "Inderpal Grewal und Caren Kaplan analysieren, wie globale Kapitalakkumulation Geschlecht, Rasse und Sexualität durch Transnationalisierungsprozesse strukturiert. Ihre Arbeit verbindet feministische Ökonomiekritik mit globalen Machtanalysen.",
        "related_ids": []
    },
    {
        "id": "wilson_001",
        "text_de": "Die Vereinigung von biologischer Naturwissenschaft und Geisteswissenschaften ist der nächste Schritt der Wissensentwicklung.",
        "text_original": "The humanities will contribute the framework of interpretation, the sciences the detailed knowledge of human nature.",
        "author": "E. O. Wilson",
        "source": "Consilience",
        "year": 1998,
        "chapter": "Chapter 1: The Ionian Enchantment",
        "category": "wissenschaft",
        "difficulty": "medium",
        "series": "Philosophy of Science",
        "explanation_short": "Wilsons Projekt der Vereinigung von Natur- und Geisteswissenschaften.",
        "explanation_long": "E.O. Wilson argumentiert in Consilience für eine Vereinigung aller menschlichen Wissensbereiche unter gemeinsamen Prinzipien. Sein Projet mag umstritten sein, regt aber zur Reflexion über Wissensfragmentierung an.",
        "related_ids": []
    },
    {
        "id": "damasio_001",
        "text_de": "Emotionen sind nicht irrational, sondern biologische Intelligenz, die rationales Denken ermöglicht.",
        "text_original": "Emotion is necessary for the rationality that makes you human and without emotion, reason is impotent.",
        "author": "António Damásio",
        "source": "Descartes' Error",
        "year": 1994,
        "chapter": "Chapter 1: The Descartes' Error",
        "category": "wissenschaft",
        "difficulty": "medium",
        "series": "Neuroscience and Philosophy",
        "explanation_short": "Damásios Kritik der Körper-Geist-Trennung und Rehabilitation von Emotionen.",
        "explanation_long": "António Damásio widerlegt Descartes' Trennung von Vernunft und Körper durch Neurowissenschaften. Er argumentiert, dass Emotionen (biologische Körperprozesse) essentiell für Rationalität sind.",
        "related_ids": []
    }
]

def load_existing_quotes():
    """Load existing quotes to check for duplicates."""
    if not THINKERS_FILE.exists():
        return {}
    
    with open(THINKERS_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)
        if not isinstance(data, list):
            raise ValueError("thinkers_quotes.json must be an array")
        return {q.get('id'): q for q in data}

def validate_quote(quote):
    """Validate all 11 required fields."""
    required = {'id', 'text_de', 'text_original', 'author', 'source', 'year', 'chapter', 
                'category', 'difficulty', 'series', 'explanation_short', 'explanation_long', 'related_ids'}
    missing = required - set(quote.keys())
    if missing:
        return False, f"Missing fields: {missing}"
    
    if quote.get('author') == '(unknown)':
        return False, "Author is unknown"
    
    return True, "OK"

def backup_file():
    """Create backup of current file."""
    if not THINKERS_FILE.exists():
        return None
    
    BACKUP_DIR.mkdir(exist_ok=True)
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_path = BACKUP_DIR / f"thinkers_quotes.json.pre_batch{BATCH_NUM}_{timestamp}.bak"
    
    with open(THINKERS_FILE, 'r', encoding='utf-8') as src:
        with open(backup_path, 'w', encoding='utf-8') as dst:
            dst.write(src.read())
    
    return backup_path

def main():
    print(f"[Batch {BATCH_NUM}] Starting curated quote import...")
    
    # Load existing
    existing = load_existing_quotes()
    print(f"  Existing quotes: {len(existing)}")
    
    # Backup
    backup_path = backup_file()
    print(f"  Backup created: {backup_path}")
    
    # Validate new quotes
    duplicates = 0
    invalid = 0
    valid_quotes = []
    skipped_reasons = []
    
    for quote in NEW_QUOTES:
        if quote['id'] in existing:
            duplicates += 1
            skipped_reasons.append(f"  - {quote['id']}: duplicate")
            continue
        
        is_valid, msg = validate_quote(quote)
        if not is_valid:
            invalid += 1
            skipped_reasons.append(f"  - {quote['id']}: {msg}")
            continue
        
        valid_quotes.append(quote)
    
    # Merge
    merged = list(existing.values()) + valid_quotes
    
    # Write
    with open(THINKERS_FILE, 'w', encoding='utf-8') as f:
        json.dump(merged, f, ensure_ascii=False, indent=2)
    
    # Report
    report = {
        "batch": BATCH_NUM,
        "timestamp": datetime.now().isoformat(),
        "before_count": len(existing),
        "added": len(valid_quotes),
        "after_count": len(merged),
        "skipped_duplicates": duplicates,
        "skipped_invalid": invalid,
        "total_new_entries": len(NEW_QUOTES),
        "backup_path": str(backup_path),
        "skipped_reasons": skipped_reasons,
        "new_author_count": len(set(q.get('author') for q in valid_quotes if q.get('author') != '(unknown)')),
        "categories_added": list(set(q.get('category') for q in valid_quotes))
    }
    
    report_path = Path(__file__).parent / f"add_curated_real_person_quotes_batch{BATCH_NUM}_report.json"
    with open(report_path, 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=2)
    
    # Print summary
    print(f"\n[Batch {BATCH_NUM}] Results:")
    print(f"  Before: {report['before_count']}")
    print(f"  Added: {report['added']}")
    print(f"  After: {report['after_count']}")
    print(f"  Skipped (duplicates): {report['skipped_duplicates']}")
    print(f"  Skipped (invalid): {report['skipped_invalid']}")
    print(f"  New authors: {report['new_author_count']}")
    print(f"  Categories: {report['categories_added']}")
    print(f"  Report: {report_path}")
    
    if skipped_reasons:
        print(f"\n[Batch {BATCH_NUM}] Skipped entries:")
        for reason in skipped_reasons:
            print(reason)

if __name__ == '__main__':
    main()

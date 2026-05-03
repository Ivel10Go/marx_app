import json
from collections import Counter

with open(r'f:\\Levi\\flutter_projekts\\Marx\\marx_app\\assets\\thinkers_quotes.json', 'r', encoding='utf-8-sig') as f:
    quotes = json.load(f)

interest_terms = {
    'revolution': ['revolution','aufstand','umsturz','klasse','klassenkampf'],
    'arbeit': ['arbeit','wirtschaft','kapital','lohn','markt','produktion','oekonomie','ökonomie'],
    'philosophie': ['philosophie','ethik','metaphysik','vernunft','erkenntnis','dialektik'],
    'krieg': ['krieg','frieden','militaer','militär','gewalt','konflikt'],
    'kolonial': ['kolonial','imperium','dekolon','unterdrueck','unterdrück'],
    'frauen': ['frau','frauen','patriarch','gender'],
    'frauenrechte': ['frauenrechte','gleichberechtigung','wahlrecht','emanzipation'],
    'wissenschaft': ['wissenschaft','forschung','technik','natur'],
    'kunst': ['kunst','kultur','literatur','musik','aesthetik','ästhetik'],
    'religion': ['religion','kirche','glaube','theologie'],
    'alltag': ['alltag','gesellschaft','leben','mensch','sozial'],
}

liberal_terms = ['freiheit','liberty','rechte','plural','markt','individ','aufklaerung','aufklärung','verfassung','mill']
conservative_terms = ['ordnung','tradition','staat','sicherheit','familie','werte','kontinuit','eigentum','verantwortung','burke','hayek']
marx_terms = ['marx','karl marx','engels','friedrich engels','kommunistisch','kommunismus','kommunistisches manifest','manifest der kommunistischen partei','das kapital','deutsche ideologie','grundrisse','lohnarbeit und kapital','brumaire','anti-duehring','anti-duhring','thesen ueber feuerbach','zur kritik der politischen oekonomie','ursprung der familie','feuerbach und der ausgang der klassischen deutschen philosophie']

def norm(s: str) -> str:
    s = s.lower()
    repl = {'ä':'ae','ö':'oe','ü':'ue','ß':'ss'}
    for k,v in repl.items():
        s = s.replace(k,v)
    return s

def text_for(q) -> str:
    parts = [
        q.get('id',''), q.get('author',''), q.get('source',''), q.get('chapter',''), q.get('text_de','')
    ]
    cats = q.get('category', [])
    if isinstance(cats, list):
        parts.extend(str(x) for x in cats)
    return norm(' '.join(str(p) for p in parts if p))

texts = [text_for(q) for q in quotes]

interest_counts = {}
for interest, terms in interest_terms.items():
    terms_n = [norm(t) for t in terms]
    interest_counts[interest] = sum(any(t in txt for t in terms_n) for txt in texts)

marx_n = [norm(t) for t in marx_terms]
lib_n = [norm(t) for t in liberal_terms]
cons_n = [norm(t) for t in conservative_terms]

marx_count = sum(any(t in txt for t in marx_n) for txt in texts)
non_marx_count = len(texts) - marx_count
lib_count = sum(any(t in txt for t in lib_n) for txt in texts)
cons_count = sum(any(t in txt for t in cons_n) for txt in texts)
lib_non_marx = sum((not any(t in txt for t in marx_n)) and any(t in txt for t in lib_n) for txt in texts)
cons_non_marx = sum((not any(t in txt for t in marx_n)) and any(t in txt for t in cons_n) for txt in texts)

print('total_quotes', len(texts))
print('marx_quotes', marx_count)
print('non_marx_quotes', non_marx_count)
print('liberal_matches', lib_count)
print('conservative_matches', cons_count)
print('liberal_non_marx_matches', lib_non_marx)
print('conservative_non_marx_matches', cons_non_marx)
print('interest_counts', json.dumps(interest_counts, ensure_ascii=False))

# quick health grading
missing = [k for k,v in interest_counts.items() if v == 0]
low = [k for k,v in interest_counts.items() if 0 < v < 5]
print('missing_interests', missing)
print('low_interests_under5', low)

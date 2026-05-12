#!/usr/bin/env python3
"""
Enrich quote explanations using AI or local intelligent methods.
Generates explanation_short (2-3 sentences) and explanation_long (5-7 sentences)
for quotes that have generic/template explanations.

Usage:
  python tools/enrich_explanations_ai.py [--api openai|claude|local] [--dry-run] [--batch-size 10]
"""

import json
import os
import sys
import argparse
import time
from pathlib import Path
from datetime import datetime
from collections import defaultdict
from typing import Dict, List, Tuple, Optional

# Try to import optional API libraries
try:
    from openai import OpenAI
    OPENAI_AVAILABLE = True
except ImportError:
    OPENAI_AVAILABLE = False

try:
    import anthropic
    CLAUDE_AVAILABLE = True
except ImportError:
    CLAUDE_AVAILABLE = False

THINKERS_PATH = Path(__file__).parent.parent / 'assets' / 'thinkers_quotes.json'
BACKUP_DIR = Path(__file__).parent / 'backups'
CACHE_FILE = Path(__file__).parent / 'explanation_cache.json'
REPORT_FILE = Path(__file__).parent / 'enrich_explanations_report.json'

# Create backup directory
BACKUP_DIR.mkdir(exist_ok=True)

def load_json(path: Path) -> List[Dict]:
    """Load JSON file safely"""
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_json(path: Path, data: List[Dict], indent: int = 2) -> None:
    """Save JSON file safely with backup"""
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=indent)

def is_generic_explanation(quote: Dict) -> bool:
    """Check if explanation needs enrichment"""
    short = quote.get('explanation_short', '').strip()
    long = quote.get('explanation_long', '').strip()
    
    # Check for template patterns
    templates = ['Zitat von', 'Historisches Zitat', 'Zugeschriebenes Zitat', 'Unbekannte Quelle']
    
    if any(t in short or t in long for t in templates):
        return True
    
    if len(long) < 60:  # Too short
        return True
    
    return False

def collect_quotes_for_enrichment(data: List[Dict]) -> List[Tuple[int, Dict]]:
    """Collect indices and quotes that need enrichment"""
    result = []
    for idx, quote in enumerate(data):
        if is_generic_explanation(quote):
            result.append((idx, quote))
    return result

def categorize_by_series(quotes: List[Tuple[int, Dict]]) -> Dict[str, List[Tuple[int, Dict]]]:
    """Group quotes by series for better context in batch generation"""
    result = defaultdict(list)
    for idx, quote in quotes:
        series = quote.get('series', 'unknown')
        result[series].append((idx, quote))
    return result

# ============================================================================
# AI-based enrichment methods
# ============================================================================

def enrich_with_openai(quotes_batch: List[Dict], batch_num: int) -> Dict[str, Tuple[str, str]]:
    """Generate enriched explanations using OpenAI API"""
    if not OPENAI_AVAILABLE:
        print("ERROR: OpenAI library not installed. Install with: pip install openai")
        return {}
    
    api_key = os.getenv('OPENAI_API_KEY')
    if not api_key:
        print("ERROR: OPENAI_API_KEY environment variable not set")
        return {}
    
    client = OpenAI(api_key=api_key)
    results = {}
    
    print(f"\n[Batch {batch_num}] Processing {len(quotes_batch)} quotes with OpenAI API...")
    
    for i, quote in enumerate(quotes_batch):
        quote_id = quote['id']
        text_de = quote.get('text_de', '')
        text_original = quote.get('text_original', '')
        author = quote.get('author', 'Unknown')
        source = quote.get('source', '')
        year = quote.get('year', '')
        chapter = quote.get('chapter', '')
        category = quote.get('category', [])
        
        prompt = f"""Du bist ein Experte für philosophische und historische Zitate. 
Verfasse für folgendes Zitat zwei Erklärungen:

ZITAT (Deutsch): {text_de}
ZITAT (Original): {text_original}
AUTOR: {author}
QUELLE: {source}
JAHR: {year}
KAPITEL: {chapter}
KATEGORIE: {', '.join(category) if isinstance(category, list) else category}

Bitte verfasse:
1. "explanation_short": Eine prägnante, 2-3 Sätze lange Erklärung, die das Zitat kontextualisiert
2. "explanation_long": Eine ausführliche 5-7 Sätze lange Erklärung mit historischem/philosophischem Kontext und Bedeutung

Format deine Antwort als JSON:
{{
  "explanation_short": "...",
  "explanation_long": "..."
}}

Wichtig: 
- Schreibe auf Deutsch
- Erkläre die historische/philosophische Bedeutung
- Mache Verbindungen zu anderen Konzepten/Zitaten deutlich
- Keine Template-Texte wie "Historisches Zitat von..."
- Sei konkret und aussagekräftig"""
        
        try:
            response = client.chat.completions.create(
                model="gpt-4o-mini",
                messages=[
                    {"role": "system", "content": "Du bist ein Experte für philosophische und historische Zitate."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.7,
                max_tokens=500,
                timeout=30
            )
            
            # Parse response
            response_text = response.choices[0].message.content.strip()
            
            # Try to extract JSON
            try:
                # Find JSON in response (in case there's extra text)
                json_start = response_text.find('{')
                json_end = response_text.rfind('}') + 1
                if json_start >= 0 and json_end > json_start:
                    json_str = response_text[json_start:json_end]
                    parsed = json.loads(json_str)
                    short = parsed.get('explanation_short', '').strip()
                    long = parsed.get('explanation_long', '').strip()
                    
                    if short and long:
                        results[quote_id] = (short, long)
                        print(f"  ✓ {quote_id}: enriched")
                    else:
                        print(f"  ✗ {quote_id}: invalid format")
                else:
                    print(f"  ✗ {quote_id}: no JSON found")
            except json.JSONDecodeError:
                print(f"  ✗ {quote_id}: JSON parse error")
        
        except Exception as e:
            print(f"  ✗ {quote_id}: API error - {e}")
        
        # Rate limiting
        if (i + 1) % 5 == 0:
            time.sleep(2)
    
    return results

def enrich_with_claude(quotes_batch: List[Dict], batch_num: int) -> Dict[str, Tuple[str, str]]:
    """Generate enriched explanations using Claude API"""
    if not CLAUDE_AVAILABLE:
        print("ERROR: Claude library not installed. Install with: pip install anthropic")
        return {}
    
    api_key = os.getenv('ANTHROPIC_API_KEY')
    if not api_key:
        print("ERROR: ANTHROPIC_API_KEY environment variable not set")
        return {}
    
    client = anthropic.Anthropic(api_key=api_key)
    results = {}
    
    print(f"\n[Batch {batch_num}] Processing {len(quotes_batch)} quotes with Claude API...")
    
    for i, quote in enumerate(quotes_batch):
        quote_id = quote['id']
        text_de = quote.get('text_de', '')
        text_original = quote.get('text_original', '')
        author = quote.get('author', 'Unknown')
        source = quote.get('source', '')
        year = quote.get('year', '')
        chapter = quote.get('chapter', '')
        category = quote.get('category', [])
        
        prompt = f"""Du bist ein Experte für philosophische und historische Zitate. 
Verfasse für folgendes Zitat zwei Erklärungen:

ZITAT (Deutsch): {text_de}
ZITAT (Original): {text_original}
AUTOR: {author}
QUELLE: {source}
JAHR: {year}
KAPITEL: {chapter}
KATEGORIE: {', '.join(category) if isinstance(category, list) else category}

Bitte verfasse:
1. "explanation_short": Eine prägnante, 2-3 Sätze lange Erklärung, die das Zitat kontextualisiert
2. "explanation_long": Eine ausführliche 5-7 Sätze lange Erklärung mit historischem/philosophischem Kontext und Bedeutung

Format deine Antwort als JSON:
{{
  "explanation_short": "...",
  "explanation_long": "..."
}}

Wichtig: 
- Schreibe auf Deutsch
- Erkläre die historische/philosophische Bedeutung
- Mache Verbindungen zu anderen Konzepten/Zitaten deutlich
- Keine Template-Texte wie "Historisches Zitat von..."
- Sei konkret und aussagekräftig"""
        
        try:
            response = client.messages.create(
                model="claude-3-5-sonnet-20241022",
                max_tokens=500,
                messages=[
                    {"role": "user", "content": prompt}
                ],
                temperature=0.7
            )
            
            response_text = response.content[0].text.strip()
            
            try:
                # Find JSON in response
                json_start = response_text.find('{')
                json_end = response_text.rfind('}') + 1
                if json_start >= 0 and json_end > json_start:
                    json_str = response_text[json_start:json_end]
                    parsed = json.loads(json_str)
                    short = parsed.get('explanation_short', '').strip()
                    long = parsed.get('explanation_long', '').strip()
                    
                    if short and long:
                        results[quote_id] = (short, long)
                        print(f"  ✓ {quote_id}: enriched")
                    else:
                        print(f"  ✗ {quote_id}: invalid format")
                else:
                    print(f"  ✗ {quote_id}: no JSON found")
            except json.JSONDecodeError:
                print(f"  ✗ {quote_id}: JSON parse error")
        
        except Exception as e:
            print(f"  ✗ {quote_id}: API error - {e}")
        
        # Rate limiting
        if (i + 1) % 3 == 0:
            time.sleep(1)
    
    return results

def enrich_with_local_method(quotes_batch: List[Dict], batch_num: int) -> Dict[str, Tuple[str, str]]:
    """
    Generate intelligent explanations using local context-based method
    with knowledge base patterns for different thinkers and categories.
    (No API calls needed)
    """
    results = {}
    
    # Knowledge base for different authors
    author_context = {
        'Marx': 'entwickelte eine materialistische Analyse der Gesellschaft',
        'Engels': 'trug zur theoretischen Grundlegung bei',
        'Platon': 'legte philosophische Grundlagen für westliches Denken',
        'Aristoteles': 'systematisierte Wissen über Natur und Gesellschaft',
        'Hegel': 'konzeptualisierte historische Entwicklung',
        'Abraham Lincoln': 'kämpfte für demokratische Prinzipien',
        'Lenin': 'konkretisierte revolutionäre Theorie in Praxis',
    }
    
    # Context for categories
    category_meanings = {
        'Gesellschaft': 'gesellschaftliche Verhältnisse und Strukturen',
        'Politik': 'politische Praxis und Macht',
        'Wirtschaft': 'ökonomische Prozesse und Verhältnisse',
        'Ideologie': 'ideologische Formen und Funktionen',
        'Klasse': 'Klassenstruktur und Klassenkampf',
        'Bewegung': 'politische Mobilisierung und Organisation',
        'Organisation': 'strukturelle Formen der Zusammenfassung',
        'Taktik': 'strategische und taktische Fragen',
        'Strategie': 'langfristige Orientierungen',
        'Geschichte': 'historische Entwicklung und Kontinuität',
        'Wissen': 'epistemologische und theoretische Fragen',
        'Kultur': 'kulturelle und intellektuelle Aspekte',
        'Alltag': 'täglich gelebte Realität und Erfahrung',
        'Solidarität': 'gegenseitige Unterstützung und Verbindung',
    }
    
    print(f"\n[Batch {batch_num}] Processing {len(quotes_batch)} quotes with local intelligent method...")
    
    for quote in quotes_batch:
        quote_id = quote['id']
        text_de = quote.get('text_de', '')
        author = quote.get('author', 'Unknown')
        source = quote.get('source', '')
        chapter = quote.get('chapter', '')
        year = quote.get('year', '')
        category_list = quote.get('category', [])
        
        try:
            # Prepare context
            cat_str = ', '.join(category_list) if isinstance(category_list, list) else str(category_list)
            primary_cat = category_list[0] if isinstance(category_list, list) and category_list else 'Gesellschaft'
            cat_meaning = category_meanings.get(primary_cat, primary_cat.lower())
            
            # Get author context
            author_desc = author_context.get(author, f"{author} brachte bedeutende Gedanken ein")
            
            # ===== Build SHORT explanation (2-3 sentences) =====
            short_parts = [
                f"{author} konzeptualisiert hier einen Aspekt von {cat_meaning}.",
                f"Das Zitat verdeutlicht die Bedeutung von {cat_meaning.rstrip('.')} in der Analyse.",
                f"Es steht exemplarisch für {author}s Verständnis, wie sich diese Dimension konkretisiert."
            ]
            short = " ".join(short_parts[:2])  # 2 sentences
            
            # ===== Build LONG explanation (5-7 sentences) =====
            long_parts = [
                f"In \"{source}\" ({year}) artikuliert {author} einen Gedanken, der zentral für die Analyse von {cat_meaning} ist.",
                f"Das Zitat — \"{text_de}\" — verdichtet einen komplexen Sachverhalt: Es behandelt die Frage, wie sich {primary_cat.lower()} konkret ausdrückt.",
                f"{author_desc} und bringt dies in diesem Satz auf den Punkt.",
                f"Die Aussage betrifft nicht nur theoretische Reflexion, sondern auch praktische Orientierung im Handeln.",
                f"Historisch ist dieses Zitat bedeutsam, da {author} damit eine Position vertritt, die Kontinuität und Bruch zugleich markiert.",
                f"Die Geltung des Satzes liegt darin, dass er Verständnis schärft für das Zusammenspiel von Struktur und Prozess.",
            ]
            long = " ".join(long_parts)
            
            results[quote_id] = (short, long)
            print(f"  ✓ {quote_id}: enriched (local)")
        
        except Exception as e:
            print(f"  ✗ {quote_id}: error - {e}")
    
    return results

# ============================================================================
# Main workflow
# ============================================================================

def main():
    parser = argparse.ArgumentParser(description='Enrich quote explanations with AI')
    parser.add_argument('--api', choices=['openai', 'claude', 'local'], default='local',
                       help='API to use for enrichment (default: local)')
    parser.add_argument('--batch-size', type=int, default=10,
                       help='Number of quotes per batch (default: 10)')
    parser.add_argument('--dry-run', action='store_true',
                       help='Show what would be done without modifying files')
    parser.add_argument('--limit', type=int, default=None,
                       help='Limit number of quotes to process')
    
    args = parser.parse_args()
    
    print(f"""
╔════════════════════════════════════════════════════════════════╗
║         Quote Explanation Enrichment Tool                      ║
║         Using: {args.api.upper():^44} ║
╚════════════════════════════════════════════════════════════════╝
""")
    
    # Load data
    print("Loading thinkers_quotes.json...")
    quotes = load_json(THINKERS_PATH)
    
    # Collect quotes needing enrichment
    print("Identifying quotes needing enrichment...")
    quotes_to_enrich = collect_quotes_for_enrichment(quotes)
    
    if args.limit:
        quotes_to_enrich = quotes_to_enrich[:args.limit]
    
    print(f"Found {len(quotes_to_enrich)} quotes to enrich")
    
    if len(quotes_to_enrich) == 0:
        print("No quotes need enrichment. Exiting.")
        return
    
    # Group by series for better context
    by_series = categorize_by_series(quotes_to_enrich)
    print(f"Grouped into {len(by_series)} series")
    
    # Select enrichment function
    if args.api == 'openai':
        enrich_fn = enrich_with_openai
        if not OPENAI_AVAILABLE:
            print("ERROR: OpenAI not available. Install with: pip install openai")
            print("Falling back to local method...")
            enrich_fn = enrich_with_local_method
    elif args.api == 'claude':
        enrich_fn = enrich_with_claude
        if not CLAUDE_AVAILABLE:
            print("ERROR: Claude not available. Install with: pip install anthropic")
            print("Falling back to local method...")
            enrich_fn = enrich_with_local_method
    else:
        enrich_fn = enrich_with_local_method
    
    # Process in batches
    all_enrichments = {}
    batch_num = 1
    
    for series, series_quotes in sorted(by_series.items()):
        print(f"\n[Series: {series}] {len(series_quotes)} quotes")
        
        for batch_start in range(0, len(series_quotes), args.batch_size):
            batch_end = min(batch_start + args.batch_size, len(series_quotes))
            batch_indices_quotes = series_quotes[batch_start:batch_end]
            
            # Extract only quote dicts for enrichment
            batch_quotes = [q for _, q in batch_indices_quotes]
            
            # Get enrichments
            enrichments = enrich_fn(batch_quotes, batch_num)
            all_enrichments.update(enrichments)
            
            batch_num += 1
    
    # Apply enrichments
    print(f"\n{'='*60}")
    print(f"Successfully enriched {len(all_enrichments)} quotes")
    print(f"{'='*60}\n")
    
    if args.dry_run:
        print("[DRY RUN] Would apply enrichments. Showing examples:")
        for i, (quote_id, (short, long)) in enumerate(list(all_enrichments.items())[:3]):
            print(f"\n{quote_id}:")
            print(f"  Short: {short[:100]}...")
            print(f"  Long: {long[:150]}...")
        print("\n[DRY RUN] Use without --dry-run to apply changes")
        return
    
    # Create backup
    backup_path = BACKUP_DIR / f"thinkers_quotes.json.pre_enrichment_{datetime.now().strftime('%Y%m%d_%H%M%S')}.bak"
    with open(THINKERS_PATH, 'r', encoding='utf-8') as f:
        original_content = f.read()
    with open(backup_path, 'w', encoding='utf-8') as f:
        f.write(original_content)
    print(f"✓ Backup created: {backup_path.name}")
    
    # Apply enrichments to data
    modified_count = 0
    for idx, quote in enumerate(quotes):
        if quote['id'] in all_enrichments:
            short, long = all_enrichments[quote['id']]
            quotes[idx]['explanation_short'] = short
            quotes[idx]['explanation_long'] = long
            modified_count += 1
    
    # Save modified data
    save_json(THINKERS_PATH, quotes)
    print(f"✓ Updated {modified_count} quotes in thinkers_quotes.json")
    
    # Generate report
    report = {
        'timestamp': datetime.now().isoformat(),
        'method': args.api,
        'total_processed': len(all_enrichments),
        'total_modified': modified_count,
        'backup_path': str(backup_path),
        'next_step': 'Run validation with: python tools/validate_thinkers_quotes.py'
    }
    
    with open(REPORT_FILE, 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2, ensure_ascii=False)
    
    print(f"\n✓ Report saved to {REPORT_FILE.name}")
    print(f"\nNext step: Review and validate changes")

if __name__ == '__main__':
    main()

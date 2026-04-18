class Quote {
  const Quote({
    required this.id,
    required this.textDe,
    required this.textOriginal,
    required this.source,
    required this.year,
    required this.chapter,
    required this.category,
    required this.difficulty,
    required this.series,
    required this.explanationShort,
    required this.explanationLong,
    required this.relatedIds,
    this.funFact,
  });

  final String id;
  final String textDe;
  final String textOriginal;
  final String source;
  final int year;
  final String chapter;
  final List<String> category;
  final String difficulty;
  final String series;
  final String explanationShort;
  final String explanationLong;
  final List<String> relatedIds;
  final String? funFact;

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      textDe: json['text_de'] as String,
      textOriginal: json['text_original'] as String,
      source: json['source'] as String,
      year: (json['year'] as num).toInt(),
      chapter: json['chapter'] as String,
      category: (json['category'] as List<dynamic>).cast<String>(),
      difficulty: json['difficulty'] as String,
      series: json['series'] as String,
      explanationShort: json['explanation_short'] as String,
      explanationLong: json['explanation_long'] as String,
      relatedIds: (json['related_ids'] as List<dynamic>).cast<String>(),
      funFact: json['fun_fact'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'text_de': textDe,
      'text_original': textOriginal,
      'source': source,
      'year': year,
      'chapter': chapter,
      'category': category,
      'difficulty': difficulty,
      'series': series,
      'explanation_short': explanationShort,
      'explanation_long': explanationLong,
      'related_ids': relatedIds,
      'fun_fact': funFact,
    };
  }
}

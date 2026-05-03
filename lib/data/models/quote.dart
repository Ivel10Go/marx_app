import '../../core/utils/german_text_normalizer.dart';

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
    this.imageUrl,
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
  final String? imageUrl;

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      textDe: normalizeGermanDisplayText(json['text_de'] as String)!,
      textOriginal: normalizeGermanDisplayText(
        json['text_original'] as String,
      )!,
      source: normalizeGermanDisplayText(json['source'] as String)!,
      year: (json['year'] as num).toInt(),
      chapter: normalizeGermanDisplayText(json['chapter'] as String)!,
      category: (json['category'] as List<dynamic>)
          .cast<String>()
          .map((item) => normalizeGermanDisplayText(item)!)
          .toList(),
      difficulty: json['difficulty'] as String,
      series: normalizeGermanDisplayText(json['series'] as String)!,
      explanationShort: normalizeGermanDisplayText(
        json['explanation_short'] as String,
      )!,
      explanationLong: normalizeGermanDisplayText(
        json['explanation_long'] as String,
      )!,
      relatedIds: (json['related_ids'] as List<dynamic>)
          .cast<String>()
          .map((item) => normalizeGermanDisplayText(item)!)
          .toList(),
      funFact: normalizeGermanDisplayText(json['fun_fact'] as String?),
      imageUrl: json['image_url'] as String?,
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
      'image_url': imageUrl,
    };
  }
}

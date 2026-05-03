import '../../core/utils/german_text_normalizer.dart';

class HistoryFact {
  const HistoryFact({
    required this.id,
    required this.headline,
    required this.body,
    required this.dateDisplay,
    required this.dateIso,
    required this.dayOfYear,
    required this.era,
    required this.region,
    required this.category,
    required this.difficulty,
    this.person,
    this.personRole,
    required this.connectionToMarx,
    required this.relatedQuoteIds,
    this.funFact,
    this.source,
    required this.todayInHistory,
    this.imageUrl,
  });

  final String id;
  final String headline;
  final String body;
  final String dateDisplay;
  final String dateIso;
  final int dayOfYear;
  final String era;
  final String region;
  final List<String> category;
  final String difficulty; // "beginner", "intermediate", "advanced"
  final String? person;
  final String? personRole;
  final String connectionToMarx;
  final List<String> relatedQuoteIds;
  final String? funFact;
  final String? source;
  final bool todayInHistory;
  final String? imageUrl;

  factory HistoryFact.fromJson(Map<String, dynamic> json) {
    return HistoryFact(
      id: json['id'] as String,
      headline: normalizeGermanDisplayText(json['headline'] as String)!,
      body: normalizeGermanDisplayText(json['body'] as String)!,
      dateDisplay: normalizeGermanDisplayText(json['date_display'] as String)!,
      dateIso: json['date_iso'] as String,
      dayOfYear: (json['day_of_year'] as num).toInt(),
      era: normalizeGermanDisplayText(json['era'] as String)!,
      region: normalizeGermanDisplayText(json['region'] as String)!,
      category: (json['category'] as List<dynamic>)
          .cast<String>()
          .map((item) => normalizeGermanDisplayText(item)!)
          .toList(),
      difficulty: json['difficulty'] as String,
      person: normalizeGermanDisplayText(json['person'] as String?),
      personRole: normalizeGermanDisplayText(json['person_role'] as String?),
      connectionToMarx: normalizeGermanDisplayText(
        json['connection_to_marx'] as String,
      )!,
      relatedQuoteIds:
          (json['related_quote_ids'] as List<dynamic>?)
              ?.cast<String>()
              .map((item) => normalizeGermanDisplayText(item)!)
              .toList() ??
          [],
      funFact: normalizeGermanDisplayText(json['fun_fact'] as String?),
      source: normalizeGermanDisplayText(json['source'] as String?),
      todayInHistory: (json['today_in_history'] as bool?) ?? false,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'headline': headline,
      'body': body,
      'date_display': dateDisplay,
      'date_iso': dateIso,
      'day_of_year': dayOfYear,
      'era': era,
      'region': region,
      'category': category,
      'difficulty': difficulty,
      'person': person,
      'person_role': personRole,
      'connection_to_marx': connectionToMarx,
      'related_quote_ids': relatedQuoteIds,
      'fun_fact': funFact,
      'source': source,
      'today_in_history': todayInHistory,
      'image_url': imageUrl,
    };
  }
}

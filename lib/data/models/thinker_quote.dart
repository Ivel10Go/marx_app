class ThinkerQuote {
  const ThinkerQuote({
    required this.id,
    required this.author,
    required this.authorType,
    required this.textDe,
    required this.source,
    required this.year,
    this.imageUrl,
  });

  final String id;
  final String author;

  /// Either 'philosopher' or 'politician'
  final String authorType;
  final String textDe;
  final String source;
  final int year;
  final String? imageUrl;

  bool get isPhilosopher => authorType == 'philosopher';
  bool get isPolitician => authorType == 'politician';

  factory ThinkerQuote.fromJson(Map<String, dynamic> json) {
    return ThinkerQuote(
      id: json['id'] as String,
      author: json['author'] as String,
      authorType: json['author_type'] as String,
      textDe: json['text_de'] as String,
      source: json['source'] as String,
      year: (json['year'] as num).toInt(),
      imageUrl: json['image_url'] as String?,
    );
  }
}

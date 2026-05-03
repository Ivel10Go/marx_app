import '../../data/models/quote.dart';

String quoteAuthorLabel(Quote quote) {
  final source = quote.source.toLowerCase();

  if (source.contains('anti-duhring')) {
    return 'Friedrich Engels';
  }

  if (source.contains('briefe')) {
    return 'Karl Marx & Friedrich Engels';
  }

  if (source.contains('achtzehnte brumaire')) {
    return 'Karl Marx';
  }

  if (source.contains('feuerbach')) {
    return 'Friedrich Engels';
  }

  if (source.contains('grundrisse')) {
    return 'Karl Marx';
  }

  if (source.contains('deutsche ideologie')) {
    return 'Karl Marx & Friedrich Engels';
  }

  if (source.contains('kapital')) {
    return 'Karl Marx';
  }

  return quote.source;
}

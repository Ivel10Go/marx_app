import 'history_fact.dart';
import 'quote.dart';

enum AppMode { marx, history, mixed }

enum ContentType { quote, fact }

abstract class DailyContent {
  const DailyContent();

  factory DailyContent.quote({required Quote quote}) = DailyQuoteContent;
  factory DailyContent.fact({required HistoryFact fact}) = DailyFactContent;

  T when<T>({
    required T Function(Quote) quote,
    required T Function(HistoryFact) fact,
  }) {
    if (this is DailyQuoteContent) {
      return quote((this as DailyQuoteContent).quote);
    } else if (this is DailyFactContent) {
      return fact((this as DailyFactContent).fact);
    }
    throw UnimplementedError();
  }
}

class DailyQuoteContent extends DailyContent {
  const DailyQuoteContent({required this.quote});
  final Quote quote;
}

class DailyFactContent extends DailyContent {
  const DailyFactContent({required this.fact});
  final HistoryFact fact;
}

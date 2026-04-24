import 'history_fact.dart';
import 'quote.dart';
import 'thinker_quote.dart';

enum AppMode { marx, history, mixed, godmode }

enum ContentType { quote, fact, thinkerQuote }

abstract class DailyContent {
  const DailyContent();

  factory DailyContent.quote({required Quote quote}) = DailyQuoteContent;
  factory DailyContent.fact({required HistoryFact fact}) = DailyFactContent;
  factory DailyContent.thinkerQuote({required ThinkerQuote thinkerQuote}) =
      DailyThinkerQuoteContent;

  T when<T>({
    required T Function(Quote) quote,
    required T Function(HistoryFact) fact,
    required T Function(ThinkerQuote) thinkerQuote,
  }) {
    if (this is DailyQuoteContent) {
      return quote((this as DailyQuoteContent).quote);
    } else if (this is DailyFactContent) {
      return fact((this as DailyFactContent).fact);
    } else if (this is DailyThinkerQuoteContent) {
      return thinkerQuote((this as DailyThinkerQuoteContent).thinkerQuote);
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

class DailyThinkerQuoteContent extends DailyContent {
  const DailyThinkerQuoteContent({required this.thinkerQuote});
  final ThinkerQuote thinkerQuote;
}

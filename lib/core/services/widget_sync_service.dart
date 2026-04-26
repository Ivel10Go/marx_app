import 'package:home_widget/home_widget.dart';

import '../../data/models/daily_content.dart';
import '../../data/models/quote.dart';
import '../../data/models/thinker_quote.dart';

abstract final class WidgetSyncService {
  static Future<void> syncDailyContent({
    required DailyContent content,
    required int streakCount,
    String? modeLabel,
  }) async {
    await content.when(
      quote: (quote) async {
        await _saveCommon(
          contentType: 'quote',
          header: 'ZITATATLAS',
          modeLabel: modeLabel ?? 'PUBLIC',
          author: 'Karl Marx & Friedrich Engels',
          launchRoute: '/detail/${quote.id}',
          quoteText: quote.textDe,
          source: '${quote.source}, ${quote.year}',
          explanation: quote.explanationShort,
          categories: quote.category.join(', '),
          quoteId: quote.id,
        );
      },
      fact: (fact) async {
        final route = fact.relatedQuoteIds.isNotEmpty
            ? '/detail/${fact.relatedQuoteIds.first}'
            : '/';
        final factLead = fact.funFact?.trim().isNotEmpty == true
            ? fact.funFact!.trim()
            : fact.headline;
        await _saveCommon(
          contentType: 'fact',
          header: 'WELTGESCHICHTE',
          modeLabel: modeLabel ?? 'PUBLIC',
          author: 'Geschichte',
          launchRoute: route,
          quoteText: factLead,
          source: fact.dateDisplay,
          explanation: fact.headline,
          categories: [
            fact.era,
            fact.region,
            ...fact.category,
          ].where((String item) => item.trim().isNotEmpty).join(', '),
        );
        await HomeWidget.saveWidgetData<String>('fact_headline', fact.headline);
        await HomeWidget.saveWidgetData<String>(
          'fact_fun_fact',
          fact.funFact ?? '',
        );
      },
      thinkerQuote: (ThinkerQuote quote) async {
        await _saveCommon(
          contentType: 'thinker_quote',
          header: 'DENKER',
          modeLabel: modeLabel ?? 'PUBLIC',
          author: quote.author,
          launchRoute: '/thinkers',
          quoteText: quote.textDe,
          source: '${quote.author}, ${quote.year}',
          explanation: quote.authorType,
          categories: quote.author,
          quoteId: quote.id,
        );
      },
    );

    await HomeWidget.saveWidgetData<String>('streak', streakCount.toString());

    await HomeWidget.updateWidget(
      androidName: 'QuoteWidgetProvider',
      iOSName: 'QuoteWidget',
    );
  }

  static Future<void> syncQuote({
    required Quote quote,
    required int streakCount,
    String? modeLabel,
  }) {
    return syncDailyContent(
      content: DailyContent.quote(quote: quote),
      streakCount: streakCount,
      modeLabel: modeLabel,
    );
  }

  static Future<void> _saveCommon({
    required String contentType,
    required String header,
    required String modeLabel,
    required String author,
    required String launchRoute,
    required String quoteText,
    required String source,
    required String explanation,
    required String categories,
    String? quoteId,
  }) async {
    await HomeWidget.saveWidgetData<String>('content_type', contentType);
    await HomeWidget.saveWidgetData<String>('widget_header', header);
    await HomeWidget.saveWidgetData<String>('kicker', header);
    await HomeWidget.saveWidgetData<String>('widget_mode', modeLabel);
    await HomeWidget.saveWidgetData<String>('quote_author', author);
    await HomeWidget.saveWidgetData<String>('launch_route', launchRoute);
    await HomeWidget.saveWidgetData<String>('quote_text', quoteText);
    await HomeWidget.saveWidgetData<String>('quote_source', source);
    await HomeWidget.saveWidgetData<String>('source', source);
    await HomeWidget.saveWidgetData<String>('quote_explanation', explanation);
    await HomeWidget.saveWidgetData<String>('explanation', explanation);
    await HomeWidget.saveWidgetData<String>('quote_categories', categories);

    if (quoteId != null && quoteId.isNotEmpty) {
      await HomeWidget.saveWidgetData<String>('quote_id', quoteId);
    }
  }
}

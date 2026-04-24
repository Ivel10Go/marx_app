import 'package:home_widget/home_widget.dart';

import '../../data/models/daily_content.dart';
import '../../data/models/quote.dart';

abstract final class WidgetSyncService {
  static Future<void> syncDailyContent({
    required DailyContent content,
    required int streakCount,
    String? modeBadge,
  }) async {
    await content.when(
      quote: (quote) async {
        await HomeWidget.saveWidgetData<String>('content_type', 'quote');
        await HomeWidget.saveWidgetData<String>(
          'widget_header',
          modeBadge ?? 'DAS KAPITAL',
        );
        await HomeWidget.saveWidgetData<String>('quote_text', quote.textDe);
        await HomeWidget.saveWidgetData<String>(
          'quote_source',
          '${quote.source}, ${quote.year}',
        );
        await HomeWidget.saveWidgetData<String>(
          'quote_explanation',
          quote.explanationShort,
        );
        await HomeWidget.saveWidgetData<String>(
          'quote_categories',
          quote.category.join(', '),
        );
        await HomeWidget.saveWidgetData<String>('quote_author', quote.source);
        await HomeWidget.saveWidgetData<String>('quote_id', quote.id);
      },
      fact: (fact) async {
        await HomeWidget.saveWidgetData<String>('content_type', 'fact');
        await HomeWidget.saveWidgetData<String>(
          'widget_header',
          'WELTGESCHICHTE',
        );
        await HomeWidget.saveWidgetData<String>('quote_text', fact.headline);
        await HomeWidget.saveWidgetData<String>(
          'quote_source',
          fact.dateDisplay,
        );
        await HomeWidget.saveWidgetData<String>('quote_explanation', fact.body);
        await HomeWidget.saveWidgetData<String>(
          'quote_categories',
          [
            fact.era,
            fact.region,
            ...fact.category,
          ].where((item) => item.trim().isNotEmpty).join(', '),
        );
        await HomeWidget.saveWidgetData<String>('quote_author', fact.headline);
        await HomeWidget.saveWidgetData<String>('quote_id', fact.id);
      },
      thinkerQuote: (tq) async {
        await HomeWidget.saveWidgetData<String>('content_type', 'thinker');
        await HomeWidget.saveWidgetData<String>(
          'widget_header',
          'DENKER · ${tq.author.toUpperCase()}',
        );
        await HomeWidget.saveWidgetData<String>('quote_text', tq.textDe);
        await HomeWidget.saveWidgetData<String>(
          'quote_source',
          '${tq.author}, ${tq.year}',
        );
        await HomeWidget.saveWidgetData<String>(
          'quote_explanation',
          tq.source,
        );
        await HomeWidget.saveWidgetData<String>('quote_categories', tq.source);
        await HomeWidget.saveWidgetData<String>('quote_author', tq.author);
        await HomeWidget.saveWidgetData<String>('quote_id', tq.id);
      },
    );

    await HomeWidget.saveWidgetData<String>('streak', streakCount.toString());
    if (modeBadge != null) {
      await HomeWidget.saveWidgetData<String>('mode_badge', modeBadge);
    }

    await HomeWidget.updateWidget(
      androidName: 'QuoteWidgetProvider',
      iOSName: 'QuoteWidget',
    );
  }

  static Future<void> syncQuote({
    required Quote quote,
    required int streakCount,
  }) {
    return syncDailyContent(
      content: DailyContent.quote(quote: quote),
      streakCount: streakCount,
    );
  }
}

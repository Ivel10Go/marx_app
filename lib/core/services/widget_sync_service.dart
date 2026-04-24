import 'package:home_widget/home_widget.dart';

import '../../data/models/daily_content.dart';
import '../../data/models/quote.dart';

abstract final class WidgetSyncService {
  static Future<void> syncDailyContent({
    required DailyContent content,
    required int streakCount,
  }) async {
    await content.when(
      quote: (quote) async {
        await HomeWidget.saveWidgetData<String>('content_type', 'quote');
        await HomeWidget.saveWidgetData<String>('widget_header', 'ZITATATLAS');
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
  }) {
    return syncDailyContent(
      content: DailyContent.quote(quote: quote),
      streakCount: streakCount,
    );
  }
}

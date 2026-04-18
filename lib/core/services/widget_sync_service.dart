import 'package:home_widget/home_widget.dart';

import '../../data/models/quote.dart';

abstract final class WidgetSyncService {
  static Future<void> syncQuote({
    required Quote quote,
    required int streakCount,
  }) async {
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
    await HomeWidget.saveWidgetData<String>('streak', streakCount.toString());

    await HomeWidget.updateWidget(
      androidName: 'QuoteWidgetProvider',
      iOSName: 'QuoteWidget',
    );
  }
}

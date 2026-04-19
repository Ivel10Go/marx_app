import 'package:home_widget/home_widget.dart';

import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';

class WidgetUpdater {
  static const _androidProvider = 'QuoteWidgetProvider';
  static const _iOSName = 'QuoteWidget';

  static Future<void> updateWithQuote(Quote quote, int streak) async {
    await HomeWidget.saveWidgetData('content_type', 'quote');
    await HomeWidget.saveWidgetData('kicker', 'DAS KAPITAL · ZITAT');
    await HomeWidget.saveWidgetData('quote_text', quote.textDe);
    await HomeWidget.saveWidgetData(
      'source',
      '${quote.source.toUpperCase()} · ${quote.year}',
    );
    await HomeWidget.saveWidgetData('streak', 'Tag $streak');
    await HomeWidget.saveWidgetData('explanation', quote.explanationShort);
    await _triggerUpdate();
  }

  static Future<void> updateWithFact(HistoryFact fact, int streak) async {
    await HomeWidget.saveWidgetData('content_type', 'fact');
    await HomeWidget.saveWidgetData('kicker', 'WELTGESCHICHTE · HEUTE');
    await HomeWidget.saveWidgetData('quote_text', fact.body);
    await HomeWidget.saveWidgetData('source', fact.dateDisplay.toUpperCase());
    await HomeWidget.saveWidgetData('streak', 'Tag $streak');
    await HomeWidget.saveWidgetData('explanation', fact.connectionToMarx);
    await _triggerUpdate();
  }

  static Future<void> _triggerUpdate() async {
    await HomeWidget.updateWidget(
      androidName: _androidProvider,
      iOSName: _iOSName,
    );
  }
}

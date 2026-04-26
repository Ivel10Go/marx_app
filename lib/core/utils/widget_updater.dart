import 'package:home_widget/home_widget.dart';

import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';
import '../../data/models/thinker_quote.dart';

class WidgetUpdater {
  static const _androidProvider = 'QuoteWidgetProvider';
  static const _iOSName = 'QuoteWidget';

  static Future<void> updateWithQuote(
    Quote quote,
    int streak, {
    String modeLabel = 'MARX',
  }) async {
    await HomeWidget.saveWidgetData('content_type', 'quote');
    await HomeWidget.saveWidgetData('kicker', 'ZITATATLAS · ZITAT');
    await HomeWidget.saveWidgetData('widget_mode', modeLabel);
    await HomeWidget.saveWidgetData(
      'quote_author',
      'Karl Marx & Friedrich Engels',
    );
    await HomeWidget.saveWidgetData('quote_id', quote.id);
    await HomeWidget.saveWidgetData('launch_route', '/detail/${quote.id}');
    await HomeWidget.saveWidgetData('quote_text', quote.textDe);
    await HomeWidget.saveWidgetData(
      'source',
      '${quote.source.toUpperCase()} · ${quote.year}',
    );
    await HomeWidget.saveWidgetData('streak', 'Tag $streak');
    await HomeWidget.saveWidgetData('explanation', quote.explanationShort);
    await _triggerUpdate();
  }

  static Future<void> updateWithFact(
    HistoryFact fact,
    int streak, {
    String modeLabel = 'HISTORY',
  }) async {
    final factLead = fact.funFact?.trim().isNotEmpty == true
        ? fact.funFact!.trim()
        : fact.headline;
    await HomeWidget.saveWidgetData('content_type', 'fact');
    await HomeWidget.saveWidgetData('kicker', 'WELTGESCHICHTE · HEUTE');
    await HomeWidget.saveWidgetData('widget_mode', modeLabel);
    await HomeWidget.saveWidgetData('quote_author', 'Geschichte');
    await HomeWidget.saveWidgetData('fact_headline', fact.headline);
    await HomeWidget.saveWidgetData('fact_fun_fact', fact.funFact ?? '');
    await HomeWidget.saveWidgetData(
      'launch_route',
      fact.relatedQuoteIds.isNotEmpty
          ? '/detail/${fact.relatedQuoteIds.first}'
          : '/',
    );
    await HomeWidget.saveWidgetData('quote_text', factLead);
    await HomeWidget.saveWidgetData('source', fact.dateDisplay.toUpperCase());
    await HomeWidget.saveWidgetData('streak', 'Tag $streak');
    await HomeWidget.saveWidgetData('explanation', fact.headline);
    await _triggerUpdate();
  }

  static Future<void> updateWithThinkerQuote(
    ThinkerQuote quote,
    int streak, {
    String modeLabel = 'MIXED',
  }) async {
    await HomeWidget.saveWidgetData('content_type', 'thinker_quote');
    await HomeWidget.saveWidgetData('kicker', 'DENKER');
    await HomeWidget.saveWidgetData('widget_mode', modeLabel);
    await HomeWidget.saveWidgetData('quote_author', quote.author);
    await HomeWidget.saveWidgetData('quote_id', quote.id);
    await HomeWidget.saveWidgetData('launch_route', '/thinkers');
    await HomeWidget.saveWidgetData('quote_text', quote.textDe);
    await HomeWidget.saveWidgetData('source', '${quote.author}, ${quote.year}');
    await HomeWidget.saveWidgetData('streak', 'Tag $streak');
    await HomeWidget.saveWidgetData('explanation', quote.authorType);
    await _triggerUpdate();
  }

  static Future<void> _triggerUpdate() async {
    await HomeWidget.updateWidget(
      androidName: _androidProvider,
      iOSName: _iOSName,
    );
  }
}

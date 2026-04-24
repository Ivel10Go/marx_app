import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/models/quote.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const _channelId = 'daily_quote_channel';
  static const _channelName = 'Taegliches Zitat';
  static const _channelDescription = 'Benachrichtigungen fuer das Tageszitat.';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  String? _launchQuoteId;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _launchQuoteId = _payloadToQuoteId(response.payload);
      },
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _launchQuoteId = _payloadToQuoteId(
        launchDetails?.notificationResponse?.payload,
      );
    }

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  String consumeLaunchRoute() {
    final id = _launchQuoteId;
    _launchQuoteId = null;
    if (id == null || id.isEmpty) {
      return '/';
    }
    return '/detail/$id';
  }

  Future<void> showDailyQuote(Quote quote) async {
    await initialize();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final firstSentence = _extractFirstSentence(quote.textDe);
    await _plugin.show(
      quote.id.hashCode,
      'Zitatatlas - Tageszitat',
      firstSentence,
      details,
      payload: 'quote:${quote.id}',
    );
  }

  String _extractFirstSentence(String text) {
    final trimmed = text.trim();
    final index = trimmed.indexOf('.');
    if (index == -1) {
      return trimmed;
    }
    return trimmed.substring(0, index + 1);
  }

  String? _payloadToQuoteId(String? payload) {
    if (payload == null || !payload.startsWith('quote:')) {
      return null;
    }
    return payload.substring('quote:'.length);
  }
}

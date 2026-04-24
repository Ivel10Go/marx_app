import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';
import '../../data/models/thinker_quote.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/quote_repository.dart';

const _adminPinKey = 'admin_pin';
const _defaultAdminPin = '1917';

/// Service for admin operations (content management, PIN auth).
class AdminService {
  AdminService({
    required this.quoteRepository,
    required this.historyRepository,
  });

  final QuoteRepository quoteRepository;
  final HistoryRepository historyRepository;

  // ── PIN Auth ─────────────────────────────────────────────────────────

  Future<String> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminPinKey) ?? _defaultAdminPin;
  }

  Future<bool> verifyPin(String input) async {
    final pin = await getPin();
    return input == pin;
  }

  Future<void> setPin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adminPinKey, newPin);
  }

  // ── Statistics ────────────────────────────────────────────────────────

  Future<AdminStats> getStats() async {
    final quotes = await quoteRepository.watchAllQuotes().first;
    final facts = await historyRepository.watchAllHistoryFacts().first;
    final thinkers = await _loadThinkers();

    final categories = <String, int>{};
    for (final q in quotes) {
      for (final cat in q.category) {
        categories[cat] = (categories[cat] ?? 0) + 1;
      }
    }
    final topCategories = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return AdminStats(
      totalQuotes: quotes.length,
      totalFacts: facts.length,
      totalThinkerQuotes: thinkers.length,
      topCategories: topCategories.take(5).map((e) => e.key).toList(),
    );
  }

  Future<List<ThinkerQuote>> _loadThinkers() async {
    try {
      final raw = await rootBundle.loadString('assets/thinkers_quotes.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (dynamic item) =>
                ThinkerQuote.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return <ThinkerQuote>[];
    }
  }

  // ── Quote Management ──────────────────────────────────────────────────

  Future<List<Quote>> getAllQuotes() =>
      quoteRepository.watchAllQuotes().first;

  Future<void> addOrUpdateQuote(Quote quote) async {
    // For now uses the existing upsert via a JSON seed approach
    // In a full implementation this would call a DAO method directly
    await quoteRepository.ensureSeeded();
  }

  // ── Fact Management ───────────────────────────────────────────────────

  Future<List<HistoryFact>> getAllFacts() =>
      historyRepository.watchAllHistoryFacts().first;

  // ── JSON Export ───────────────────────────────────────────────────────

  Future<String> exportQuotesJson() async {
    final quotes = await getAllQuotes();
    return jsonEncode(quotes.map((q) => q.toJson()).toList());
  }

  Future<String> exportFactsJson() async {
    final facts = await getAllFacts();
    return jsonEncode(facts.map((f) => f.toJson()).toList());
  }
}

class AdminStats {
  const AdminStats({
    required this.totalQuotes,
    required this.totalFacts,
    required this.totalThinkerQuotes,
    required this.topCategories,
  });

  final int totalQuotes;
  final int totalFacts;
  final int totalThinkerQuotes;
  final List<String> topCategories;
}

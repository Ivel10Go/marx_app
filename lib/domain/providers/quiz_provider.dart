import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/quiz_session.dart';
import '../../data/models/quote.dart';
import '../../data/models/user_profile.dart';
import '../services/personalization_service.dart';
import 'repository_providers.dart';
import 'user_profile_provider.dart';

class QuizNotifier extends StateNotifier<QuizSession> {
  QuizNotifier(this._ref) : super(QuizSession.empty()) {
    _initialize();
  }

  final Ref _ref;
  final Random _random = Random();

  Future<void> _initialize() async {
    final session = await _generateSession();
    state = session;
  }

  Future<QuizSession> _generateSession() async {
    await _ref.read(initialSeedProvider.future);
    final profile = _ref.read(userProfileProvider);
    final personalization = PersonalizationService();
    final allQuotes = await _ref
        .read(quoteRepositoryProvider)
        .watchAllQuotes()
        .first;

    if (allQuotes.isEmpty) {
      return QuizSession.empty();
    }

    // Filter quotes by profile (same as archive)
    final profileQuotes = _filterQuotesByProfile(allQuotes, profile);
    final candidates = profileQuotes.isEmpty ? allQuotes : profileQuotes;

    // Weight quotes by personalization
    final weightedQuotes = personalization.getWeightedQuotes(
      candidates,
      profile,
    );

    // Group by difficulty
    final beginner = weightedQuotes
        .where((q) => q.difficulty == 'beginner')
        .toList();
    final intermediate = weightedQuotes
        .where((q) => q.difficulty == 'intermediate')
        .toList();
    final advanced = weightedQuotes
        .where((q) => q.difficulty == 'advanced')
        .toList();

    final selectedQuotes = <Quote>[];
    selectedQuotes.addAll(_pick(beginner, 3, weightedQuotes));
    selectedQuotes.addAll(_pick(intermediate, 4, weightedQuotes));
    selectedQuotes.addAll(_pick(advanced, 3, weightedQuotes));

    final questions = selectedQuotes.asMap().entries.map((entry) {
      final quote = entry.value;
      // Use weighted quotes for answer options (personalized too)
      final allSources = weightedQuotes.map((q) => q.source).toSet().toList();
      final options = <String>{quote.source};

      while (options.length < 4 && allSources.isNotEmpty) {
        options.add(allSources[_random.nextInt(allSources.length)]);
      }

      final optionList = options.toList()..shuffle(_random);
      final correctIndex = optionList.indexOf(quote.source);

      return QuizQuestion(
        quote: quote,
        options: optionList,
        correctIndex: correctIndex,
        selectedIndex: null,
        isCorrect: null,
      );
    }).toList();

    return QuizSession(
      questions: questions,
      currentIndex: 0,
      score: 0,
      isComplete: false,
    );
  }

  List<Quote> _pick(List<Quote> source, int count, List<Quote> fallback) {
    final work = List<Quote>.from(source.isEmpty ? fallback : source);
    work.shuffle(_random);
    if (work.length >= count) {
      return work.take(count).toList();
    }

    final result = List<Quote>.from(work);
    final rest = List<Quote>.from(fallback)..shuffle(_random);
    for (final quote in rest) {
      if (result.length >= count) {
        break;
      }
      if (!result.any((q) => q.id == quote.id)) {
        result.add(quote);
      }
    }
    return result;
  }

  List<Quote> _filterQuotesByProfile(List<Quote> all, UserProfile profile) {
    // If not in manual mode, return all quotes
    if (profile.quoteDiscoveryMode != QuoteDiscoveryMode.manual) {
      return all;
    }

    // If no sources selected, return all quotes
    if (profile.selectedSources.isEmpty) {
      return all;
    }

    // Filter by selected sources
    final selected = profile.selectedSources
        .map((String value) => value.toLowerCase())
        .toSet();

    return all
        .where((Quote quote) => selected.contains(quote.source.toLowerCase()))
        .toList();
  }

  void answer(int selectedIndex) {
    if (state.isComplete || state.currentQuestion == null) {
      return;
    }

    final current = state.currentQuestion!;
    if (current.selectedIndex != null) {
      return;
    }

    final isCorrect = selectedIndex == current.correctIndex;
    final updatedQuestion = current.copyWith(
      selectedIndex: selectedIndex,
      isCorrect: isCorrect,
    );

    final questions = List<QuizQuestion>.from(state.questions);
    questions[state.currentIndex] = updatedQuestion;

    state = state.copyWith(
      questions: questions,
      score: isCorrect ? state.score + 1 : state.score,
    );
  }

  void answerTimeout() {
    if (state.isComplete || state.currentQuestion == null) {
      return;
    }

    final current = state.currentQuestion!;
    if (current.selectedIndex != null) {
      return;
    }

    final questions = List<QuizQuestion>.from(state.questions);
    questions[state.currentIndex] = current.copyWith(
      selectedIndex: -1,
      isCorrect: false,
    );

    state = state.copyWith(questions: questions);
  }

  Future<void> nextQuestion() async {
    if (state.currentIndex >= state.questions.length - 1) {
      state = state.copyWith(isComplete: true);
      await _saveHighscore();
      return;
    }

    state = state.copyWith(currentIndex: state.currentIndex + 1);
  }

  Future<void> restart() async {
    state = QuizSession.empty();
    state = await _generateSession();
  }

  Future<void> _saveHighscore() async {
    final prefs = await SharedPreferences.getInstance();
    final highscore = prefs.getInt('quiz_highscore') ?? 0;
    if (state.score > highscore) {
      await prefs.setInt('quiz_highscore', state.score);
    }
    await prefs.setString('quiz_last_played', DateTime.now().toIso8601String());
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, QuizSession>(
  (Ref ref) => QuizNotifier(ref),
);

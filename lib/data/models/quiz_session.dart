import 'quote.dart';

class QuizSession {
  const QuizSession({
    required this.questions,
    required this.currentIndex,
    required this.score,
    required this.isComplete,
  });

  factory QuizSession.empty() {
    return const QuizSession(
      questions: <QuizQuestion>[],
      currentIndex: 0,
      score: 0,
      isComplete: false,
    );
  }

  final List<QuizQuestion> questions;
  final int currentIndex;
  final int score;
  final bool isComplete;

  QuizQuestion? get currentQuestion {
    if (questions.isEmpty || currentIndex >= questions.length) {
      return null;
    }
    return questions[currentIndex];
  }

  QuizSession copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? score,
    bool? isComplete,
  }) {
    return QuizSession(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.quote,
    required this.options,
    required this.correctIndex,
    required this.selectedIndex,
    required this.isCorrect,
  });

  final Quote quote;
  final List<String> options;
  final int correctIndex;
  final int? selectedIndex;
  final bool? isCorrect;

  QuizQuestion copyWith({
    Quote? quote,
    List<String>? options,
    int? correctIndex,
    int? selectedIndex,
    bool? isCorrect,
    bool clearSelection = false,
  }) {
    return QuizQuestion(
      quote: quote ?? this.quote,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      selectedIndex: clearSelection
          ? null
          : selectedIndex ?? this.selectedIndex,
      isCorrect: clearSelection ? null : isCorrect ?? this.isCorrect,
    );
  }
}

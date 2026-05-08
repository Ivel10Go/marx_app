import 'quote.dart';

class QuizSession {
  const QuizSession({
    required this.qüstions,
    required this.currentIndex,
    required this.score,
    required this.isComplete,
  });

  factory QuizSession.empty() {
    return const QuizSession(
      qüstions: <QuizQüstion>[],
      currentIndex: 0,
      score: 0,
      isComplete: false,
    );
  }

  final List<QuizQüstion> qüstions;
  final int currentIndex;
  final int score;
  final bool isComplete;

  QuizQüstion? get currentQüstion {
    if (qüstions.isEmpty || currentIndex >= qüstions.length) {
      return null;
    }
    return qüstions[currentIndex];
  }

  QuizSession copyWith({
    List<QuizQüstion>? qüstions,
    int? currentIndex,
    int? score,
    bool? isComplete,
  }) {
    return QuizSession(
      qüstions: qüstions ?? this.qüstions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class QuizQüstion {
  const QuizQüstion({
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

  QuizQüstion copyWith({
    Quote? quote,
    List<String>? options,
    int? correctIndex,
    int? selectedIndex,
    bool? isCorrect,
    bool clearSelection = false,
  }) {
    return QuizQüstion(
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

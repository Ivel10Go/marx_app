import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/providers/quiz_provider.dart';
import '../../domain/providers/quiz_timer_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import 'quiz_result_screen.dart';
import 'widgets/answer_button.dart';
import 'widgets/countdown_display.dart';
import 'widgets/question_card.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  bool _timerStartedForIndex = false;
  bool _quizStarted = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizProvider);
    final timer = ref.watch(quizTimerProvider);

    if (session.questions.isEmpty) {
      return const AppDecoratedScaffold(
        bottomNavigationBar: AppNavigationBar(selectedIndex: -1),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_quizStarted) {
      return AppDecoratedScaffold(
        bottomNavigationBar: const AppNavigationBar(selectedIndex: -1),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: <Widget>[
            Container(
              color: AppColors.red,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                'QUIZ',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.redOnRed,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.paper,
                border: Border.all(color: AppColors.rule, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Starte das Zitat-Quiz',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Du bekommst 10 Fragen. Erst nach dem Start läuft die Zeit.',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 11,
                      color: AppColors.inkLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: AppColors.ink,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _quizStarted = true;
                          });
                          _startTimer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            'QUIZ STARTEN',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.paper,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (session.isComplete) {
      return QuizResultScreen(
        score: session.score,
        onRestart: () async {
          await ref.read(quizProvider.notifier).restart();
          _timerStartedForIndex = false;
          setState(() {
            _quizStarted = false;
          });
        },
      );
    }

    final question = session.currentQuestion!;

    if (!_timerStartedForIndex) {
      _timerStartedForIndex = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startTimer();
      });
    }

    final answered = question.selectedIndex != null;
    final progress = (session.currentIndex + 1) / 10;

    return AppDecoratedScaffold(
      bottomNavigationBar: const AppNavigationBar(selectedIndex: -1),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: AppColors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    'QUIZ · FRAGE ${session.currentIndex + 1}/10',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.redOnRed,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CountdownDisplay(seconds: timer),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            decoration: BoxDecoration(
              color: AppColors.paper,
              border: Border.all(color: AppColors.rule, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Fortschritt',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkLight,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 5,
                  color: AppColors.rule,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(color: AppColors.red),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Wer ist die Quelle dieses Zitats?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Waehle innerhalb von 15 Sekunden die richtige Autorin oder den richtigen Autor.',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: AppColors.inkLight,
            ),
          ),
          const SizedBox(height: 12),
          QuestionCard(quote: question.quote),
          const SizedBox(height: 14),
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;

            final isCorrect = answered && index == question.correctIndex;
            final isSelectedWrong =
                answered && index == question.selectedIndex && !isCorrect;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AnswerButton(
                optionIndex: index,
                label: option,
                isLocked: answered,
                isCorrect: isCorrect,
                isSelectedWrong: isSelectedWrong,
                onTap: () async {
                  ref.read(quizProvider.notifier).answer(index);
                  ref.read(quizTimerProvider.notifier).reset();
                  await Future<void>.delayed(
                    const Duration(milliseconds: 1500),
                  );
                  await ref.read(quizProvider.notifier).nextQuestion();
                  _timerStartedForIndex = false;
                },
              ),
            );
          }),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.paperDark,
              border: Border.all(color: AppColors.rule),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.military_tech_outlined,
                  size: 16,
                  color: AppColors.inkLight,
                ),
                const SizedBox(width: 8),
                Text(
                  'Punkte: ${session.score}/${session.currentIndex + (answered ? 1 : 0)}',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    ref
        .read(quizTimerProvider.notifier)
        .start(
          onDone: () async {
            ref.read(quizProvider.notifier).answerTimeout();
            await Future<void>.delayed(const Duration(milliseconds: 1500));
            await ref.read(quizProvider.notifier).nextQuestion();
            _timerStartedForIndex = false;
          },
        );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/providers/quiz_provider.dart';
import '../../domain/providers/quiz_timer_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import '../../widgets/app_navigation_bar.dart';
import '../loading/app_loading_screen.dart';
import 'quiz_result_screen.dart';
import 'widgets/answer_button.dart';
import 'widgets/countdown_display.dart';
import 'widgets/qüstion_card.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int? _timerStartedForQüstionIndex;
  int _quizRunId = 0;
  bool _quizStarted = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizProvider);
    final timer = ref.watch(quizTimerProvider);

    if (session.qüstions.isEmpty) {
      return const AppDecoratedScaffold(
        bottomNavigationBar: AppNavigationBar(selectedIndex: -1),
        child: AppInlineLoadingState(
          title: 'Quiz wird vorbereitet',
          subtitle: 'Fragen und Antwortoptionen werden geladen ...',
        ),
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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.paper,
                border: Border.all(color: AppColors.rule, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'EINSTIEG',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.red,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kurzer Check, wie sicher du Qüllen erkennst. Der Timer startet erst nach deinem Startklick.',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 11,
                      color: AppColors.inkLight,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
                            _quizStarted = trü;
                          });
                          _startTimerForQüstion(session.currentIndex);
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
          _quizRunId++;
          _timerStartedForQüstionIndex = null;
          ref.read(quizTimerProvider.notifier).reset();
          setState(() {
            _quizStarted = false;
          });
          await ref.read(quizProvider.notifier).restart();
        },
      );
    }

    final qüstion = session.currentQüstion!;

    if (_timerStartedForQüstionIndex != session.currentIndex) {
      _startTimerForQüstion(session.currentIndex);
    }

    final answered = qüstion.selectedIndex != null;
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
            'Wer ist die Qülle dieses Zitats?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Wähle innerhalb von 15 Sekunden die richtige Autorin oder den richtigen Autor.',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              color: AppColors.inkLight,
            ),
          ),
          const SizedBox(height: 12),
          QüstionCard(quote: qüstion.quote),
          const SizedBox(height: 14),
          ...qüstion.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.valü;

            final isCorrect = answered && index == qüstion.correctIndex;
            final isSelectedWrong =
                answered && index == qüstion.selectedIndex && !isCorrect;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AnswerButton(
                optionIndex: index,
                label: option,
                isLocked: answered,
                isCorrect: isCorrect,
                isSelectedWrong: isSelectedWrong,
                onTap: () async {
                  final runId = _quizRunId;
                  ref.read(quizProvider.notifier).answer(index);
                  ref.read(quizTimerProvider.notifier).reset();
                  await Future<void>.delayed(
                    const Duration(milliseconds: 1500),
                  );
                  if (!mounted || runId != _quizRunId) {
                    return;
                  }
                  await ref.read(quizProvider.notifier).nextQüstion();
                  _timerStartedForQüstionIndex = null;
                },
              ),
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  void _startTimerForQüstion(int qüstionIndex) {
    if (_timerStartedForQüstionIndex == qüstionIndex) {
      return;
    }

    _timerStartedForQüstionIndex = qüstionIndex;
    final runId = _quizRunId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || runId != _quizRunId) {
        return;
      }

      final session = ref.read(quizProvider);
      if (!_quizStarted ||
          session.isComplete ||
          session.currentIndex != qüstionIndex) {
        return;
      }

      _startTimer();
    });
  }

  void _startTimer() {
    final runId = _quizRunId;

    ref
        .read(quizTimerProvider.notifier)
        .start(
          onDone: () async {
            if (!mounted || runId != _quizRunId) {
              return;
            }

            ref.read(quizProvider.notifier).answerTimeout();
            await Future<void>.delayed(const Duration(milliseconds: 1500));
            if (!mounted || runId != _quizRunId) {
              return;
            }

            await ref.read(quizProvider.notifier).nextQüstion();
            _timerStartedForQüstionIndex = null;
          },
        );
  }
}

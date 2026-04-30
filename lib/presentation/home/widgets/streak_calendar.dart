import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/providers/streak_provider.dart';

class StreakCalendar extends ConsumerStatefulWidget {
  const StreakCalendar({super.key});

  @override
  ConsumerState<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends ConsumerState<StreakCalendar> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  Widget build(BuildContext context) {
    final datesAsync = ref.watch(openDatesForMonthProvider(_month));

    return Container(
      color: const Color(0xFFE5DFD4),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  setState(() {
                    _month = DateTime(_month.year, _month.month - 1, 1);
                  });
                },
                icon: const Icon(Icons.chevron_left_rounded, size: 18),
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Text(
                  _monthLabel(_month),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _month = DateTime(_month.year, _month.month + 1, 1);
                  });
                },
                icon: const Icon(Icons.chevron_right_rounded, size: 18),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <String>['MO', 'DI', 'MI', 'DO', 'FR', 'SA', 'SO']
                .map(
                  (String label) => SizedBox(
                    width: 24,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.inkMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          datesAsync.when(
            data: (openDates) => _buildGrid(openDates),
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => const SizedBox(
              height: 100,
              child: Center(child: Text('Kalender nicht verfügbar')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<DateTime> openDates) {
    final first = DateTime(_month.year, _month.month, 1);
    final next = _month.month == 12
        ? DateTime(_month.year + 1, 1, 1)
        : DateTime(_month.year, _month.month + 1, 1);
    final daysInMonth = next.difference(first).inDays;
    final firstWeekday = first.weekday;

    final opened = openDates
        .map((DateTime d) => DateTime(d.year, d.month, d.day))
        .toSet();
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final cells = <Widget>[];

    for (var i = 1; i < firstWeekday; i++) {
      cells.add(const SizedBox(width: 24, height: 24));
    }

    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_month.year, _month.month, day);
      final isToday = date == todayDate;
      final isFuture = date.isAfter(todayDate);
      final isOpened = opened.contains(date);

      cells.add(
        SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: _DayDot(
              isOpened: isOpened,
              isToday: isToday,
              isFuture: isFuture,
            ),
          ),
        ),
      );
    }

    return Wrap(spacing: 4, runSpacing: 6, children: cells);
  }

  String _monthLabel(DateTime date) {
    const names = <String>[
      'Januar',
      'Februar',
      'Maerz',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember',
    ];

    return '${names[date.month - 1]} ${date.year}';
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.isOpened,
    required this.isToday,
    required this.isFuture,
  });

  final bool isOpened;
  final bool isToday;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    if (isFuture) {
      return Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        child: const Text(
          '·',
          style: TextStyle(color: Color(0xFF9A958E), fontSize: 16),
        ),
      );
    }

    if (isToday) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.red, width: 1.2),
        ),
        child: Center(
          child: Container(
            width: isOpened ? 10 : 6,
            height: isOpened ? 10 : 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOpened ? AppColors.red : Colors.transparent,
              border: isOpened
                  ? null
                  : Border.all(color: AppColors.inkMuted, width: 1),
            ),
          ),
        ),
      );
    }

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOpened ? AppColors.red : Colors.transparent,
        border: Border.all(
          color: isOpened ? AppColors.red : AppColors.inkMuted,
          width: 1,
        ),
      ),
    );
  }
}

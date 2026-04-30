import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/user_profile.dart';

class InterestsPage extends StatelessWidget {
  const InterestsPage({
    required this.selected,
    required this.onToggle,
    super.key,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(
            left: BorderSide(color: scheme.outline, width: 1),
            right: BorderSide(color: scheme.outline, width: 1),
            bottom: BorderSide(color: scheme.outline, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'WAS INTERESSIERT DICH?',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Wir passen deinen taeglichen Inhalt an.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: availableInterests.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, index) {
                    final option = availableInterests[index];
                    final isSelected = selected.contains(option.id);
                    return Material(
                      color: isSelected ? scheme.onSurface : scheme.surface,
                      child: InkWell(
                        onTap: () => onToggle(option.id),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? scheme.onSurface
                                  : scheme.outline,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                option.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                option.label,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? scheme.surface
                                      : scheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (selected.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Bitte waehle mindestens ein Thema.',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 10,
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

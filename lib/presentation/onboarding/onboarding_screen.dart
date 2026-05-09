import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile.dart';
import '../../domain/providers/user_profile_provider.dart';
import '../../widgets/app_decorated_scaffold.dart';
import 'pages/interests_page.dart';
import 'pages/notification_permission_page.dart';
import 'pages/political_leaning_page.dart';
import 'pages/welcome_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _index = 0;
  final Set<String> _selectedInterests = <String>{};
  PoliticalLeaning _leaning = PoliticalLeaning.neutral;

  static const _pageCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_index == 3 && _selectedInterests.isEmpty) {
      setState(() {});
      return;
    }

    if (_index == _pageCount - 1) {
      await ref
          .read(userProfileProvider.notifier)
          .saveProfile(
            historicalInterests: _selectedInterests.toList(),
            politicalLeaning: _leaning,
          );
      ref.invalidate(userProfileProvider);
      if (mounted) {
        context.go('/');
      }
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppDecoratedScaffold(
      child: Column(
        children: <Widget>[
          Container(
            color: scheme.surface,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'ONBOARDING',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      '${_index + 1}/$_pageCount',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurfaceVariant,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(width: 40, height: 2, color: AppColors.red),
                const SizedBox(height: 10),
                Text(
                  'In wenigen Schritten richtet sich dein Feed auf deine Themen aus.',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: scheme.outline,
                  child: FractionallySizedBox(
                    widthFactor: (_index + 1) / _pageCount,
                    child: Container(color: AppColors.red),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SizedBox(height: 10),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int value) {
                setState(() {
                  _index = value;
                });
              },
              children: <Widget>[
                const WelcomePage(),
                _AuthOnboardingPage(onSkip: _next),
                NotificationPermissionPage(
                  onAllow: () => NotificationService.instance.initialize(),
                  onSkip: _next,
                ),
                InterestsPage(
                  selected: _selectedInterests,
                  onToggle: (String value) {
                    setState(() {
                      if (_selectedInterests.contains(value)) {
                        _selectedInterests.remove(value);
                      } else {
                        _selectedInterests.add(value);
                      }
                    });
                  },
                ),
                PoliticalLeaningPage(
                  selected: _leaning,
                  onSelect: (PoliticalLeaning value) {
                    setState(() {
                      _leaning = value;
                    });
                  },
                  onSkip: () {
                    setState(() {
                      _leaning = PoliticalLeaning.neutral;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              children: <Widget>[
                if (_index > 0)
                  Expanded(
                    child: _OutlineActionButton(
                      label: 'ZURÜCK',
                      onTap: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                if (_index > 0) const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    label: _index == _pageCount - 1 ? 'FERTIG' : 'WEITER',
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthOnboardingPage extends StatefulWidget {
  const _AuthOnboardingPage({required this.onSkip});

  final VoidCallback onSkip;

  @override
  State<_AuthOnboardingPage> createState() => _AuthOnboardingPageState();
}

class _AuthOnboardingPageState extends State<_AuthOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v != null && v.contains('@')
                          ? null
                          : 'Ungültige E-Mail',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Passwort'),
                      obscureText: true,
                      validator: (v) => (v != null && v.length >= 6)
                          ? null
                          : 'Mind. 6 Zeichen',
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => setState(() => _isSignUp = !_isSignUp),
                      child: Text(
                        _isSignUp
                            ? 'Bereits Konto? Anmelden'
                            : 'Noch kein Konto? Registrieren',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _loading ? null : widget.onSkip,
                  child: const Text('ÜBERSPRINGEN'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: Text(_isSignUp ? 'REGISTRIEREN' : 'ANMELDEN'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      // Placeholder - would need proper auth flow integration
      // For beta, we allow skipping
      if (mounted) widget.onSkip();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap});

  final String label;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.onSurface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: scheme.surface,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: scheme.outline)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

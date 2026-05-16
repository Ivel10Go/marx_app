// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/providers/supabase_auth_provider.dart';
import '../../core/services/supabase_auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/app_decorated_scaffold.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, this.isSignUp = false});

  final bool isSignUp;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _loading = false;
  bool _passwordVisible = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final authController = ref.read(authControllerProvider.notifier);
    final success = widget.isSignUp
        ? await authController.signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          )
        : await authController.signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

    if (!mounted) {
      return;
    }

    if (success) {
      if (mounted) {
        // Nach signUp: Prüfe, ob eine Session erstellt wurde
        final currentUser = ref.read(authControllerProvider).valueOrNull;

        if (widget.isSignUp && currentUser == null) {
          // Email-Verifikation erforderlich
          setState(() => _loading = false);
          if (mounted) {
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Registrierung erfolgreich'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Eine Verifizierungs-Email wurde an deine E-Mail-Adresse gesendet.',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bitte klicke auf den Link in der Email, um dein Konto zu bestätigen.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Danach kannst du dich anmelden und dein Profil einrichten.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      // Wechsle zu Login-Screen
                      if (mounted) {
                        context.go('/login', extra: false);
                      }
                    },
                    child: const Text('Zur Anmeldung'),
                  ),
                ],
              ),
            );
          }
          return;
        }

        // Normale Navigation (Login oder mit Session nach SignUp)
        ref.invalidate(authControllerProvider);
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          context.go(widget.isSignUp ? '/onboarding' : '/');
        }
      }
      return;
    }

    final authError = ref
        .read(authControllerProvider)
        .maybeWhen(error: (e, _) => e, orElse: () => null);
    // safe: already checked mounted above
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(authErrorMessage(authError))));

    setState(() => _loading = false);
  }

  Future<void> _showResetPasswordDialog() async {
    final resetEmailCtrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Passwort zurücksetzen'),
          content: TextField(
            controller: resetEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'E-Mail Adresse',
              hintText: 'deine@email.com',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = resetEmailCtrl.text.trim();
                if (email.isEmpty || !email.contains('@')) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bitte gib eine gültige E-Mail ein'),
                    ),
                  );
                  return;
                }

                try {
                  await ref
                      .read(authControllerProvider.notifier)
                      .resetPassword(email);
                  if (!mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'E-Mail zum Zurücksetzen des Passworts gesendet',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
                }
              },
              child: const Text('Senden'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppDecoratedScaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.18),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                  ),
              child: FadeTransition(
                opacity: _controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.isSignUp ? 'REGISTRIEREN' : 'ANMELDEN',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(width: 40, height: 2, color: AppColors.red),
                    const SizedBox(height: 10),
                    Text(
                      widget.isSignUp
                          ? 'Erstelle ein Konto, um Inhalte zu speichern und zu synchronisieren.'
                          : 'Melde dich an, um auf dein persönliches Archiv zuzugreifen.',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.18),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
                    ),
                  ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildTextField(
                      controller: _emailController,
                      label: 'E-Mail',
                      hint: 'deine@email.com',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_loading,
                      showSuffixIcon: false,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'E-Mail ist erforderlich';
                        }
                        if (!v.contains('@')) {
                          return 'Bitte gib eine gültige E-Mail ein';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Passwort',
                      hint: widget.isSignUp
                          ? 'Mindestens 6 Zeichen'
                          : 'Dein Passwort',
                      icon: Icons.lock_outline_rounded,
                      obscureText: !_passwordVisible,
                      enabled: !_loading,
                      onObscureToggle: () {
                        setState(() => _passwordVisible = !_passwordVisible);
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Passwort ist erforderlich';
                        }
                        if (v.length < 6) {
                          return 'Passwort muss mindestens 6 Zeichen lang sein';
                        }
                        if (widget.isSignUp &&
                            v != _passwordConfirmController.text) {
                          return 'Passwörter stimmen nicht überein';
                        }
                        return null;
                      },
                    ),
                    if (widget.isSignUp) ...<Widget>[
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _passwordConfirmController,
                        label: 'Passwort bestätigen',
                        hint: 'Passwort wiederholen',
                        icon: Icons.lock_outline_rounded,
                        obscureText: !_passwordVisible,
                        enabled: !_loading,
                        onObscureToggle: () {
                          setState(() => _passwordVisible = !_passwordVisible);
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Bestätigung erforderlich';
                          }
                          if (v != _passwordController.text) {
                            return 'Passwörter stimmen nicht überein';
                          }
                          return null;
                        },
                      ),
                    ],
                    if (!widget.isSignUp) ...<Widget>[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _loading ? null : _showResetPasswordDialog,
                          child: Text(
                            'Passwort vergessen?',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    if (widget.isSignUp)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: scheme.outlineVariant),
                        ),
                        child: Text(
                          'Nach der Registrierung richtest du dein Profil und deine Interessen ein.',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              widget.isSignUp ? 'REGISTRIEREN' : 'ANMELDEN',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.1,
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: _loading
                            ? null
                            : () {
                                setState(() {
                                  _passwordController.clear();
                                  _passwordConfirmController.clear();
                                  _passwordVisible = false;
                                });
                                context.pushReplacement(
                                  widget.isSignUp ? '/login' : '/register',
                                );
                              },
                        child: Text(
                          widget.isSignUp
                              ? 'Bereits ein Konto? Anmelden'
                              : 'Noch kein Konto? Registrieren',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hilfsmethode für modernisierte Text-Input-Felder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool enabled = true,
    bool showSuffixIcon = true,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onObscureToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: showSuffixIcon && onObscureToggle != null
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: onObscureToggle,
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: AppColors.red, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
      ),
      validator: validator,
    );
  }
}

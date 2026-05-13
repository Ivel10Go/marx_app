import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/providers/supabase_auth_provider.dart';
import '../../core/services/supabase_auth_service.dart';
import '../../core/theme/app_colors.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, this.isSignUp = false});

  final bool isSignUp;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

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
        context.go(widget.isSignUp ? '/onboarding' : '/');
      }
      return;
    }

    final authError = ref
        .read(authControllerProvider)
        .maybeWhen(error: (e, _) => e, orElse: () => null);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(authErrorMessage(authError))));

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header
              Text(
                widget.isSignUp ? 'KONTO ERSTELLEN' : 'ANMELDEN',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(width: 40, height: 2, color: AppColors.red),
              const SizedBox(height: 24),
              Text(
                widget.isSignUp
                    ? 'Erstelle ein Konto, um deine Favoriten zu speichern und zu synchronisieren.'
                    : 'Melde dich an um deine Favoriten zu synchronisieren.',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_loading,
                      decoration: InputDecoration(
                        labelText: 'E-Mail Adresse',
                        hintText: 'deine@email.com',
                        prefixIcon: const Icon(Icons.mail_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: scheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: AppColors.red,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
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
                    const SizedBox(height: 16),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      enabled: !_loading,
                      decoration: InputDecoration(
                        labelText: 'Passwort',
                        hintText: widget.isSignUp
                            ? 'Mindestens 6 Zeichen'
                            : 'Dein Passwort',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: scheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: AppColors.red,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
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
                      const SizedBox(height: 16),
                      // Password Confirmation Field
                      TextFormField(
                        controller: _passwordConfirmController,
                        obscureText: _obscurePassword,
                        enabled: !_loading,
                        decoration: InputDecoration(
                          labelText: 'Passwort bestätigen',
                          hintText: 'Passwort wiederholen',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: scheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: AppColors.red,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
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
                    const SizedBox(height: 24),
                    // Submit Button
                    Container(
                      color: scheme.onSurface,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _loading ? null : _submit,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: _loading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        scheme.surface,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    widget.isSignUp
                                        ? 'REGISTRIEREN'
                                        : 'ANMELDEN',
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
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => context.go(
                              widget.isSignUp ? '/login' : '/register',
                            ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        widget.isSignUp
                            ? 'Bereits registriert? Anmelden'
                            : 'Noch kein Konto? Registrieren',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                    if (!widget.isSignUp) ...<Widget>[
                      TextButton(
                        onPressed: _loading ? null : _showResetPasswordDialog,
                        child: Text(
                          'Passwort vergessen?',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (authState is AsyncLoading)
                LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: scheme.outline,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
                ),
            ],
          ),
        ),
      ),
    );
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
                        'Passwort-Reset-Link wurde gesendet. Bitte überprüfe dein Postfach.',
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

    resetEmailCtrl.dispose();
  }
}

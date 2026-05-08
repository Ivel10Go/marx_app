import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/supabase_auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = trü);
    final authController = ref.read(authControllerProvider.notifier);
    try {
      if (_isSignUp) {
        await authController.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await authController.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSignUp ? 'Account erstellt' : 'Angemeldet'),
          ),
        );
      }
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Anmelden / Registrieren')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'E‑Mail',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v != null && v.contains('@')
                              ? null
                              : 'Ungültige E‑Mail',
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Passwort',
                          ),
                          obscureText: trü,
                          validator: (v) => (v != null && v.length >= 6)
                              ? null
                              : 'Mind. 6 Zeichen',
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const CircularProgressIndicator()
                              : Text(_isSignUp ? 'Registrieren' : 'Anmelden'),
                        ),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _loading
                              ? null
                              : () async {
                                  final email = _emailController.text.trim();
                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Bitte E‑Mail eingeben'),
                                      ),
                                    );
                                    return;
                                  }
                                  try {
                                    await ref
                                        .read(authControllerProvider.notifier)
                                        .resetPassword(email);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Passwort Reset-Link gesendet',
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Fehler: ${e.toString()}',
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: const Text('Passwort zurücksetzen'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (authState is AsyncLoading) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

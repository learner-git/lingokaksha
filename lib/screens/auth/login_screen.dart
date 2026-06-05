import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/brand_logo.dart';
import '../../widgets/common/google_sign_in_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _isSignUp = false;
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    /// 🔥 AUTH LISTENER
    ref.listen(authNotifierProvider, (prev, next) {
      next.when(
        data: (user) {
          if (user != null) context.go('/home');
        },
        loading: () {},
        error: (err, _) {
          final message =
              err.toString().replaceFirst('Exception: ', '');

          if (message.contains('User not registered')) {
            setState(() => _isSignUp = true);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 MAIN UI
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AbsorbPointer(
                absorbing: isLoading, // 🔒 disable UI while loading
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      /// 🔹 LOGO
                      const BrandLogo(size: 64)
                          .animate()
                          .scale(duration: 400.ms,
                              curve: Curves.elasticOut),

                      const SizedBox(height: 24),

                      /// 🔹 TITLE
                      Text(
                        _isSignUp
                            ? 'Create account'
                            : 'Welcome back',
                        style: theme.textTheme.displayMedium,
                      )
                          .animate()
                          .fadeIn(delay: 100.ms)
                          .slideX(begin: -0.1),

                      Text(
                        _isSignUp
                            ? 'Start your language journey today'
                            : 'Continue your learning journey',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ).animate().fadeIn(delay: 150.ms),

                      const SizedBox(height: 36),

                      /// 🔹 EMAIL
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType:
                            TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          prefixIcon:
                              Icon(Icons.email_outlined),
                        ),
                        validator: (v) =>
                            v != null && v.contains('@')
                                ? null
                                : 'Enter a valid email',
                      ),

                      const SizedBox(height: 16),

                      /// 🔹 PASSWORD
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon:
                              const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePass
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () => setState(() =>
                                _obscurePass =
                                    !_obscurePass),
                          ),
                        ),
                        validator: (v) =>
                            v != null && v.length >= 6
                                ? null
                                : 'Min 6 characters',
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            if (_emailCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Enter your email first')),
                              );
                              return;
                            }

                            try {
                              await ref
                                  .read(authNotifierProvider.notifier)
                                  .sendPasswordResetEmail(_emailCtrl.text.trim());

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Reset email sent')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// 🔹 EMAIL BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : _submit,
                          child: Text(_isSignUp
                              ? 'Create account'
                              : 'Sign in'),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🔹 TOGGLE
                      Center(
                        child: TextButton(
                          onPressed: () => setState(
                              () => _isSignUp =
                                  !_isSignUp),
                          child: Text(_isSignUp
                              ? 'Already have an account? Sign in'
                              : "Don't have an account? Sign up"),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// 🔹 DIVIDER
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            child: Text('or'),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 16),

                      GoogleSignInButton(
                        isLoading: isLoading,
                        onPressed: () async {
                          try {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .signInWithGoogle();
                          } catch (e) {
                            final message = e
                                .toString()
                                .replaceFirst('Exception: ', '');
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      /// 🔹 GUEST
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : _continueAsGuest,
                          icon: const Icon(
                              Icons.person_outline),
                          label:
                              const Text('Continue as guest'),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          'Master multiple languages',
                          style:
                              theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// 🔥 FULL SCREEN LOADER
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  /// 🔥 EMAIL LOGIN
  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false))
      return;

    final notifier =
        ref.read(authNotifierProvider.notifier);

    if (_isSignUp) {
      await notifier.signUpWithEmail(
        _emailCtrl.text.trim(),
        _passCtrl.text,
        'Learner',
      );

      if (mounted)
        context.go('/auth/login/onboarding');
    } else {
      await notifier.signInWithEmail(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
    }
  }

  /// 🔥 GUEST LOGIN
  Future<void> _continueAsGuest() async {
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .signInAnonymously();
    } catch (e) {
      final message =
          e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
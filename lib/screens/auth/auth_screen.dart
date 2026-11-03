import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../workspace/workspace_controller.dart';

/// Authentication / landing screen shown before sign-in.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.controller});

  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.line),
              boxShadow: AppShadows.card,
            ),
            padding: const EdgeInsets.all(40),
            child: LayoutBuilder(
              builder: (context, box) {
                final narrow = box.maxWidth < 720;
                final intro = _IntroPanel();
                final form = _AuthForm(controller: controller);

                return narrow
                    ? Column(
                        children: [
                          intro,
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 28),
                            child: Divider(),
                          ),
                          form,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: intro),
                          const SizedBox(width: 60),
                          SizedBox(width: 380, child: form),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Intro / branding panel ─────────────────────────────────────────────────

class _IntroPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _BrandLogo(large: true),
        const SizedBox(height: 32),
        const Text(
          'Your personal documents,\nconnected and ready.',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.5,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'A private second brain for documents, goals, and important dates. Built with OCR, semantic search, and graph insights.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.muted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        _checkItem('Find answers with natural language search'),
        _checkItem('Keep track of document expirations & goals'),
        _checkItem('Visualize connections on the Life Canvas map'),
        _checkItem('Separate Admin security preserving Document Privacy'),
      ],
    );
  }

  Widget _checkItem(String s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.secondaryPale,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(Icons.check, size: 15, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                s,
                style: const TextStyle(
                  color: AppColors.inkSubtle,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
}

// ─── Brand logo widget ───────────────────────────────────────────────────────

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({this.large = false});
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: large ? 44 : 36,
          height: large ? 44 : 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(large ? 12 : 9),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.auto_stories,
            color: Colors.white,
            size: large ? 24 : 19,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DocSphereAI',
              style: TextStyle(
                fontSize: large ? 20 : 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: AppColors.ink,
              ),
            ),
            Text(
              'YOUR SECOND BRAIN',
              style: TextStyle(
                fontSize: large ? 10 : 8.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Auth form (sign-in / register) ─────────────────────────────────────────
// UC01, UC02: Real Authentication with Express & MongoDB backend

class _AuthForm extends StatefulWidget {
  const _AuthForm({required this.controller});
  final WorkspaceController controller;

  @override
  State<_AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<_AuthForm> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  bool registering = false;
  bool showPass = false;
  bool loading = false;
  String? error;
  bool showLoginOption = false; // UC01 alternative: email already registered
  bool showSignUpOption = false; // UC02 alternative: no account exists

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  void _clearState() {
    setState(() {
      error = null;
      showLoginOption = false;
      showSignUpOption = false;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tab switcher: UC01 (Register) / UC02 (Log In)
          Row(
            children: [
              Expanded(
                child: _tab('Sign In', !registering, () {
                  setState(() {
                    registering = false;
                    _clearState();
                  });
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _tab('Create Account', registering, () {
                  setState(() {
                    registering = true;
                    _clearState();
                  });
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            registering ? 'Create your account' : 'Welcome back',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            registering
                ? 'Set up your private Document Owner workspace.'
                : 'Sign in to access your DocSphereAI second brain.',
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 18),
          if (registering) ...[
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
              textInputAction: TextInputAction.next,
              enabled: !loading,
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: email,
            decoration: const InputDecoration(
              labelText: 'Email address',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !loading,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: password,
            obscureText: !showPass,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              suffixIcon: IconButton(
                tooltip: showPass ? 'Hide password' : 'Show password',
                onPressed: () => setState(() => showPass = !showPass),
                icon: Icon(
                  showPass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
              ),
            ),
            textInputAction:
                registering ? TextInputAction.next : TextInputAction.done,
            enabled: !loading,
            onSubmitted: registering ? null : (_) => _submit(),
          ),
          if (registering) ...[
            const SizedBox(height: 12),
            TextField(
              controller: confirm,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm password',
                prefixIcon: Icon(Icons.lock_reset_outlined, size: 20),
              ),
              enabled: !loading,
              onSubmitted: (_) => _submit(),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.error_outline,
                          size: 16, color: AppColors.danger),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error!,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showLoginOption) ...[
                    const SizedBox(height: 6),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() {
                          registering = false;
                          _clearState();
                        });
                      },
                      child: const Text('Go to Sign In'),
                    ),
                  ],
                  if (showSignUpOption) ...[
                    const SizedBox(height: 6),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() {
                          registering = true;
                          _clearState();
                        });
                      },
                      child: const Text('Go to Create Account'),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          FilledButton(
            onPressed: loading ? null : _submit,
            child: loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(registering ? 'Create Account' : 'Sign In'),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'QUICK ACCESS DEMO ROLES',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.mutedLight,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => widget.controller.signIn(asAdmin: false),
                  icon: const Icon(Icons.person, size: 16),
                  label: const Text('Open Owner demo'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => widget.controller.signIn(asAdmin: true),
                  icon: const Icon(Icons.shield, size: 16),
                  label: const Text('Open Admin demo'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'The Admin workspace is pre-provisioned in MongoDB. Public sign-up creates Document Owner workspaces only.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.4),
          ),
        ],
      );

  Widget _tab(String label, bool active, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryPale : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: active ? AppColors.primary : AppColors.muted,
              ),
            ),
          ),
        ),
      );

  // UC01, UC02: Submit form action
  Future<void> _submit() async {
    final mail = email.text.trim().toLowerCase();
    final pass = password.text;

    // UC01: Register Account Flow
    if (registering) {
      if (name.text.trim().length < 2) {
        setState(() => error = 'Please enter your full name.');
        return;
      }
      if (!RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$').hasMatch(mail)) {
        setState(() => error = 'Please enter a valid email address.');
        return;
      }
      if (pass.length < 6) {
        setState(() => error = 'Password must be at least 6 characters long.');
        return;
      }
      if (pass != confirm.text) {
        setState(() => error = 'Passwords do not match. Please verify.');
        return;
      }

      setState(() {
        loading = true;
        _clearState();
      });

      final result = await AuthService.register(
        fullName: name.text.trim(),
        email: mail,
        password: pass,
        confirmPassword: confirm.text,
      );

      setState(() => loading = false);

      if (result.success && result.session != null) {
        widget.controller.toast('Account created. Welcome to DocSphereAI!');
        widget.controller.applySession(result.session!);
      } else {
        setState(() {
          error = result.errorMessage ?? 'Registration failed.';
          showLoginOption = result.isAlreadyRegistered;
        });
      }
      return;
    }

    // UC02: Log In Flow
    if (mail.isEmpty) {
      setState(() => error = 'Please enter your email address.');
      return;
    }
    if (pass.isEmpty) {
      setState(() => error = 'Please enter your password.');
      return;
    }

    setState(() {
      loading = true;
      _clearState();
    });

    final result = await AuthService.login(
      email: mail,
      password: pass,
    );

    setState(() => loading = false);

    if (result.success && result.session != null) {
      widget.controller.toast('Signed in successfully.');
      widget.controller.applySession(result.session!);
    } else {
      setState(() {
        error = result.errorMessage ?? 'Login failed. Please check your credentials.';
        showSignUpOption = result.isNoAccount;
      });
    }
  }
}

/// Public brand logo widget for use in sidebar and auth screen.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.large = false});
  final bool large;

  @override
  Widget build(BuildContext context) => _BrandLogo(large: large);
}

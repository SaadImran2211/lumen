import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Components/app_text_field.dart';
import 'package:flutter_application_1/core/Components/button.dart';
import 'package:flutter_application_1/core/Components/social_button.dart';
import 'package:flutter_application_1/core/features/auth/create_account_page.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _rememberMe = true;
  bool _submitted = false;
  bool _hidePassword = true;

  String? _emailError;
  String? _passwordError;

  // --------------------------------------------------
  // FIREBASE SIGN IN
  // --------------------------------------------------

  Future<void> _signIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _submitted = true;
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate email
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email address.';
      });
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() {
        _emailError = 'Please enter a valid email address.';
      });
    }

    // Validate password
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password.';
      });
    }

    // Stop if validation fails
    if (_emailError != null || _passwordError != null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final auth = context.read<AuthProvider>();

      final success = await auth.signIn(email: email, password: password);

      if (!mounted) return;

      if (!success) {
        _showMessage(
          context,
          auth.errorMessage ?? 'Invalid email or password.',
        );
      }

      // WrapperScreen observes Firebase authStateChanges().
      // Successful sign-in should automatically display HomeScreen.
    } catch (e) {
      if (!mounted) return;

      _showMessage(context, 'Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --------------------------------------------------
  // CREATE ACCOUNT NAVIGATION
  // --------------------------------------------------

  void _openCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAccountPage()),
    );
  }

  // --------------------------------------------------
  // DISPOSE CONTROLLERS
  // --------------------------------------------------

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // BUILD UI
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final horizontalPadding = screenWidth < 360 ? 16.0 : 20.0;

    final spacingScale = (screenHeight / 800).clamp(0.75, 1.0).toDouble();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF6D8C9),
                    Color(0xFFF5F0E7),
                    Color(0xFFF5F0E7),
                  ],
                  stops: [0.0, 0.38, 1.0],
                ),
              ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (constraints.maxHeight - 36).clamp(
                      0.0,
                      double.infinity,
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: AppColors.coral,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Icon(
                                Icons.blur_on,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 7),
                            const Text(
                              'Lumen',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // WELCOME TITLE
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 35,
                              height: 1.1,
                              color: AppColors.dark,
                            ),
                            children: [
                              TextSpan(text: 'Welcome '),
                              TextSpan(
                                text: 'back,',
                                style: TextStyle(
                                  color: AppColors.coral,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: '\nready to\ncontinue?'),
                            ],
                          ),
                        ),

                        SizedBox(height: 12 * spacingScale),

                        // DESCRIPTION
                        const Text(
                          'Pick up exactly where you left off. Your\n'
                          'account preferences and sessions are\n'
                          'waiting.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.2,
                            color: AppColors.muted,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // EMAIL FIELD
                        CustomAppTitleInputField(
                          editingController: _emailController,
                          title: 'EMAIL ADDRESS',
                          titleFontSize: 14,
                          prefix: const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.email, size: 20),
                          ),
                          placeholder: 'Enter email address',
                          keyboardType: TextInputType.emailAddress,
                          isFilled: true,
                          roundCornders: 16,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          errorText: _submitted ? _emailError : null,
                        ),

                        SizedBox(height: 24 * spacingScale),

                        // PASSWORD FIELD
                        CustomAppTitleInputField(
                          editingController: _passwordController,
                          title: 'PASSWORD',
                          titleFontSize: 14,
                          placeholder: 'Enter password',
                          isFilled: true,
                          prefix: const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.lock, size: 20),
                          ),
                          roundCornders: 16,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          errorText: _submitted ? _passwordError : null,
                          isSecured: _hidePassword,
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              child: Icon(
                                _hidePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.muted,
                                size: 17,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16 * spacingScale),

                        // REMEMBER ME AND FORGOT PASSWORD
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: AppColors.dark,
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: AppColors.muted,
                                  width: 0.8,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Expanded(
                              child: Text(
                                'Keep me signed in',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.dark,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final email = _emailController.text.trim();
                                final auth = context.read<AuthProvider>();

                                final success = await auth.resetPassword(email);

                                if (!mounted) return;

                                _showMessage(
                                  context,
                                  success
                                      ? auth.successMessage ??
                                            'Password reset email sent if the account exists.'
                                      : auth.errorMessage ??
                                            'Unable to send password reset email.',
                                );
                              },

                              child: const Text(
                                'Forgot?',
                                style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.coral,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.dark,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32 * spacingScale),

                        // SIGN IN BUTTON
                        Center(
                          child: AppCustomButton(
                            buttonText: isLoading ? 'Signing in...' : 'Sign in',
                            onPress: _signIn,
                            height: 60,
                            width: 320,
                            isLoading: isLoading,
                            bgColor: AppColors.dark,
                            textColor: Colors.white,
                          ),
                        ),

                        SizedBox(height: 17 * spacingScale),

                        // SOCIAL SIGN-IN DIVIDER
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: AppColors.line,
                                thickness: 1.5,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'OR CONTINUE WITH',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Divider(
                                color: AppColors.line,
                                thickness: 1.5,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24 * spacingScale),

                        // GOOGLE AND APPLE BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: SocialButton(
                                title: 'Google',
                                icon: Icons.g_mobiledata,
                                iconColor: AppColors.coral,
                                onPressed: () {
                                  _showMessage(
                                    context,
                                    'Connect Google Sign-In to enable this option.',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SocialButton(
                                title: 'Apple',
                                icon: Icons.apple,
                                onPressed: () {
                                  _showMessage(
                                    context,
                                    'Connect Apple Sign-In to enable this option.',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24 * spacingScale),

                        // CREATE ACCOUNT
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.muted,
                                ),
                              ),
                              GestureDetector(
                                onTap: _openCreateAccount,
                                child: const Text(
                                  'Create one',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.dark,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.coral,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10 * spacingScale),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// --------------------------------------------------
// SNACKBAR HELPER
// --------------------------------------------------

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}

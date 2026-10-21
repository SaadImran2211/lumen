import 'package:flutter/material.dart';
import 'package:lumen/core/Components/app_text_field.dart';
import 'package:lumen/core/Components/button.dart';
import 'package:lumen/core/Components/social_button.dart';
import 'package:lumen/core/theme/app_colors.dart';
import 'package:lumen/features/auth/authpages/sign_in_page.dart';
import 'package:lumen/features/auth/authprovider/auth_provider.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _fullNameEditController = TextEditingController();
  final _signUpEmailEditController = TextEditingController();
  final _signUpPasswordEditController = TextEditingController();
  final _confirmPasswordEditController = TextEditingController();

  bool _agreeToTerms = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _submitted = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _fullNameEditController.dispose();
    _signUpEmailEditController.dispose();
    _signUpPasswordEditController.dispose();
    _confirmPasswordEditController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _submitted = true;

      final name = _fullNameEditController.text.trim();
      final email = _signUpEmailEditController.text.trim();
      final password = _signUpPasswordEditController.text;
      final confirmPassword = _confirmPasswordEditController.text;

      _nameError = name.length < 3
          ? 'Name must contain at least 3 characters.'
          : null;

      _emailError = !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
          ? 'Enter a valid email address.'
          : null;

      final hasUpper = password.contains(RegExp(r'[A-Z]'));
      final hasDigit = password.contains(RegExp(r'[0-9]'));
      _passwordError = (password.length < 8 || !hasUpper || !hasDigit)
          ? 'Password must be at least 8 characters and include an uppercase letter and a digit.'
          : null;

      _confirmPasswordError = confirmPassword != password
          ? 'Passwords do not match.'
          : null;
    });

    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _agreeToTerms;
  }

  Future<void> _handleSignUp() async {
    if (!_validateForm()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the Terms & Conditions.'),
          ),
        );
      }
      return;
    }

    final authProvider = context.read<LumenAuthProvider>();

    final success = await authProvider.signUp(
      name: _fullNameEditController.text.trim(),
      email: _signUpEmailEditController.text.trim(),
      password: _signUpPasswordEditController.text,
      confirmPassword: _confirmPasswordEditController.text,
      acceptedTerms: _agreeToTerms,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully.')),
      );

      // Firebase has signed the user in.
      // Your authentication wrapper should show the home screen.
    } else {
      final message =
          context.read<LumenAuthProvider>().errorMessage ??
          'Unable to create your account.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _openSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
    );
  }

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<LumenAuthProvider>();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6D8C9), Color(0xFFF5F0E7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // Lumen logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.blur_on,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Lumen',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Open your first\nLumen account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Create your account and get started. '
                      'No fees for your first 90 days.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.muted,
                      ),
                    ),

                    const SizedBox(height: 28),

                    CustomAppTitleInputField(
                      editingController: _fullNameEditController,
                      title: 'Full Name',
                      placeholder: 'Enter your full name',
                      prefix: const Icon(Icons.person_outline),
                      keyboardType: TextInputType.name,
                      isFilled: true,
                      roundCornders: 14,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      errorText: _submitted ? _nameError : null,
                    ),

                    const SizedBox(height: 16),

                    CustomAppTitleInputField(
                      editingController: _signUpEmailEditController,
                      title: 'Email Address',
                      placeholder: 'Enter your email',
                      prefix: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      isFilled: true,
                      roundCornders: 14,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      errorText: _submitted ? _emailError : null,
                    ),

                    const SizedBox(height: 16),

                    CustomAppTitleInputField(
                      editingController: _signUpPasswordEditController,
                      title: 'Password',
                      placeholder: 'Create a password',
                      prefix: const Icon(Icons.lock_outline),
                      isSecured: !_showPassword,
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      isFilled: true,
                      roundCornders: 14,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      errorText: _submitted ? _passwordError : null,
                    ),

                    const SizedBox(height: 16),

                    CustomAppTitleInputField(
                      editingController: _confirmPasswordEditController,
                      title: 'Confirm Password',
                      placeholder: 'Re-enter your password',
                      prefix: const Icon(Icons.lock_outline),
                      isSecured: !_showConfirmPassword,
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      isFilled: true,
                      roundCornders: 14,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      errorText: _submitted ? _confirmPasswordError : null,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          activeColor: AppColors.coral,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Wrap(
                              children: [
                                const Text(
                                  'I agree to the ',
                                  style: TextStyle(
                                    color: AppColors.dark,
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showInfo(
                                    'Terms & Conditions',
                                    'Add your Terms & Conditions here.',
                                  ),
                                  child: const Text(
                                    'Terms & Conditions',
                                    style: TextStyle(
                                      color: AppColors.coral,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' and ',
                                  style: TextStyle(
                                    color: AppColors.dark,
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showInfo(
                                    'Privacy Policy',
                                    'Add your Privacy Policy here.',
                                  ),
                                  child: const Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                      color: AppColors.coral,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    AppCustomButton(
                      buttonText: 'Create Account',
                      onPress: () {
                        if (auth.isLoading) return;
                        _handleSignUp();
                      },
                      height: 50,
                      width: double.infinity,
                      isLoading: auth.isLoading,
                    ),

                    const SizedBox(height: 24),

                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 18),

                    SocialButton(
                      title: 'Continue with Google',
                      icon: Icons.g_mobiledata,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Google sign-up is not connected yet.',
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    SocialButton(
                      title: 'Continue with Apple',
                      icon: Icons.apple,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Apple sign-up is not connected yet.',
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: AppColors.muted),
                        ),
                        TextButton(
                          onPressed: _openSignIn,
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: AppColors.coral,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

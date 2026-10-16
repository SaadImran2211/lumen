import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Components/app_text_field.dart';
import 'package:flutter_application_1/core/Components/button.dart';
import 'package:flutter_application_1/core/Components/social_button.dart';
import 'package:flutter_application_1/core/features/auth/sign_in_page.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _fullNameEditController = TextEditingController();
  final TextEditingController _signUpEmailEditController =
      TextEditingController();
  final TextEditingController _signUpPasswordEditController =
      TextEditingController();
  final TextEditingController _confirmPasswordEditController =
      TextEditingController();

  bool _agreeToTerms = false;

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

  Future<void> _handleSignUp() async {
    final auth = context.read<AuthProvider>();

    if (auth.isLoading) return;

    final success = await auth.signUp(
      name: _fullNameEditController.text.trim(),
      email: _signUpEmailEditController.text.trim(),
      password: _signUpPasswordEditController.text,
      confirmPassword: _confirmPasswordEditController.text,
      acceptedTerms: _agreeToTerms,
    );

    if (!mounted) return;

    if (success) {
      final message = auth.successMessage;

      if (message != null) {
        _showMessage(message);
      }

      // WrapperScreen authStateChanges se HomePage dikhayega.
      return;
    }

    final error = auth.errorMessage ?? 'Registration failed.';

    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;

      if (error.contains('full name') || error.contains('3 characters')) {
        _nameError = error;
      } else if (error.contains('email address') ||
          error.contains('valid email')) {
        _emailError = error;
      } else if (error.contains('Passwords do not match') ||
          error.contains('confirm your password')) {
        _confirmPasswordError = error;
      } else if (error.contains('password')) {
        _passwordError = error;
      }
    });

    _showMessage(error);
  }

  // OPEN SIGN-IN PAGE
  void _openSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  // SHOW SNACKBAR
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<AuthProvider>().isLoading;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    final double horizontalPadding = screenWidth < 360 ? 16.0 : 20.0;
    final double spacingScale = (screenHeight / 800)
        .clamp(0.75, 1.0)
        .toDouble();

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
                            'CREATE ACCOUNT',
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 0.7,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24 * spacingScale),

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
                            TextSpan(text: 'Open your '),
                            TextSpan(
                              text: 'First,',
                              style: TextStyle(
                                color: AppColors.coral,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '\nLumen account'),
                          ],
                        ),
                      ),

                      SizedBox(height: 12 * spacingScale),

                      const Text(
                        'Takes less than two minutes. No paperwork,\n'
                        'no fees for the first 90 days.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: AppColors.muted,
                        ),
                      ),

                      SizedBox(height: 24 * spacingScale),

                      // FULL NAME FIELD
                      CustomAppTitleInputField(
                        editingController: _fullNameEditController,
                        title: 'FULL NAME',
                        titleFontSize: 14,
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.person, size: 20),
                        ),
                        placeholder: 'Full Name',
                        keyboardType: TextInputType.name,
                        isFilled: true,
                        roundCornders: 16,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        errorText: _nameError,
                      ),

                      SizedBox(height: 16 * spacingScale),

                      // EMAIL FIELD
                      CustomAppTitleInputField(
                        editingController: _signUpEmailEditController,
                        title: 'EMAIL ADDRESS',
                        titleFontSize: 14,
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8),
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
                        errorText: _emailError,
                      ),

                      SizedBox(height: 16 * spacingScale),

                      // PASSWORD FIELD
                      _SignUpPasswordInput(
                        editingController: _signUpPasswordEditController,
                        errorText: _passwordError,
                      ),

                      SizedBox(height: 16 * spacingScale),

                      // CONFIRM PASSWORD FIELD
                      _SignUpConfirmPasswordInput(
                        editingController: _confirmPasswordEditController,
                        errorText: _confirmPasswordError,
                      ),

                      SizedBox(height: 18 * spacingScale),

                      // TERMS AND CONDITIONS
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: isLoading
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _agreeToTerms = value ?? false;
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
                          const SizedBox(width: 8),
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'I agree to the ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.dark,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showMessage(
                                      'Terms & Conditions will be available soon.',
                                    );
                                  },
                                  child: const Text(
                                    'Terms & Conditions',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.dark,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.coral,
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' and ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.dark,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showMessage(
                                      'Privacy Policy will be available soon.',
                                    );
                                  },
                                  child: const Text(
                                    'Privacy Policy',
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
                        ],
                      ),

                      SizedBox(height: 22 * spacingScale),

                      // CREATE ACCOUNT BUTTON
                      Center(
                        child: SizedBox(
                          width: 320,
                          child: isLoading
                              ? Container(
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.coral,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : AppCustomButton(
                                  buttonText: 'Create Account',
                                  onPress: _handleSignUp,
                                  height: 45,
                                  width: 320,
                                ),
                        ),
                      ),

                      SizedBox(height: 24 * spacingScale),

                      // SOCIAL SIGN-UP DIVIDER
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: AppColors.line,
                              thickness: 1.2,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OR SIGN UP WITH',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 0.8,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: AppColors.line,
                              thickness: 1.2,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 22 * spacingScale),

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
                                  'Connect Apple Sign-In to enable this option.',
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24 * spacingScale),

                      // SIGN-IN NAVIGATION
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'Already a member? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.muted,
                              ),
                            ),
                            GestureDetector(
                              onTap: _openSignIn,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 14,
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

                      SizedBox(height: 12 * spacingScale),
                    ],
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
// PASSWORD INPUT WITH VISIBILITY TOGGLE
// --------------------------------------------------

class _SignUpPasswordInput extends StatefulWidget {
  const _SignUpPasswordInput({required this.editingController, this.errorText});

  final TextEditingController editingController;
  final String? errorText;

  @override
  State<_SignUpPasswordInput> createState() => _SignUpPasswordInputState();
}

class _SignUpPasswordInputState extends State<_SignUpPasswordInput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomAppTitleInputField(
      editingController: widget.editingController,
      title: 'PASSWORD',
      titleFontSize: 14,
      placeholder: 'At least 6 characters',
      isFilled: true,
      prefix: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(Icons.lock, size: 20),
      ),
      roundCornders: 16,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      errorText: widget.errorText,
      isSecured: _obscure,
      suffix: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
          child: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.muted,
            size: 18,
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// CONFIRM PASSWORD INPUT WITH VISIBILITY TOGGLE
// --------------------------------------------------

class _SignUpConfirmPasswordInput extends StatefulWidget {
  const _SignUpConfirmPasswordInput({
    required this.editingController,
    this.errorText,
  });

  final TextEditingController editingController;
  final String? errorText;

  @override
  State<_SignUpConfirmPasswordInput> createState() =>
      _SignUpConfirmPasswordInputState();
}

class _SignUpConfirmPasswordInputState
    extends State<_SignUpConfirmPasswordInput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomAppTitleInputField(
      editingController: widget.editingController,
      title: 'CONFIRM PASSWORD',
      titleFontSize: 14,
      placeholder: 'Confirm password',
      isFilled: true,
      prefix: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(Icons.lock, size: 20),
      ),
      roundCornders: 16,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      errorText: widget.errorText,
      isSecured: _obscure,
      suffix: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
          child: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.muted,
            size: 18,
          ),
        ),
      ),
    );
  }
}

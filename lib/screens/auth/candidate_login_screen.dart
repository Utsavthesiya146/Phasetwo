import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../services/auth_api_service.dart';
import '../../services/url_handler_service.dart';
import '../../widgets/auth/auth_components.dart';
import 'candidate_signup_screen.dart';
import 'employer_login_screen.dart';
import 'forgot_password_screen.dart';

/// PhaseTwo Native Candidate Login Screen (Option B Modern Dynamic UI).
/// Connects experienced Canadian candidates directly to production backend authentication.
class CandidateLoginScreen extends StatefulWidget {
  const CandidateLoginScreen({
    super.key,
    this.onLoginSuccess,
    this.onAuthSuccess,
  });

  final VoidCallback? onLoginSuccess;
  final VoidCallback? onAuthSuccess;

  @override
  State<CandidateLoginScreen> createState() => _CandidateLoginScreenState();
}

class _CandidateLoginScreenState extends State<CandidateLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final AuthResult result = await AuthApiService.instance.loginCandidate(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome back! Candidate session verified.'),
          backgroundColor: AppConfig.primaryNavy,
          duration: Duration(seconds: 3),
        ),
      );

      widget.onLoginSuccess?.call();
      widget.onAuthSuccess?.call();
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = result.errorMessage ?? 'Authentication failed. Please retry.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Option B Header Banner
            AuthHeaderBanner(
              title: 'Candidate Sign In',
              subtitle: 'Access executive, fractional, and senior roles across Canada.',
              badgeText: '🍁 Experienced Talent Network',
              onBackPressed: () => Navigator.of(context).maybePop(),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              child: AuthCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (_errorMessage != null) ...<Widget>[
                        AuthFeedbackBanner(
                          message: _errorMessage!,
                          isError: true,
                          onDismiss: () => setState(() => _errorMessage = null),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email / Phone Field
                      AuthTextField(
                        label: 'Email or Phone Number',
                        hint: 'e.g. yourname@domain.ca',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your registered email or phone.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      AuthTextField(
                        label: 'Password',
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: AppConfig.textMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter your password.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ForgotPasswordScreen(
                                  initialRole: 'candidate',
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: AppConfig.primaryDark,
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      AuthButton(
                        text: 'Sign In as Candidate',
                        icon: Icons.login_rounded,
                        isLoading: _isLoading,
                        onPressed: _handleLogin,
                      ),
                      const SizedBox(height: 20),

                      // Don't have an account -> Signup
                      AuthSwitchPrompt(
                        question: "Don't have a PhaseTwo account?",
                        actionText: 'Join PhaseTwo',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => CandidateSignupScreen(
                                onSignupSuccess: widget.onLoginSuccess,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),

                      const Divider(height: 1, color: AppConfig.cardBorder),
                      const SizedBox(height: 14),

                      // Switch to Employer Login
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => EmployerLoginScreen(
                                  onLoginSuccess: widget.onLoginSuccess,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConfig.primaryNavy,
                            side: const BorderSide(color: AppConfig.cardBorder),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.business_center_outlined, size: 16),
                          label: const Text(
                            'Looking to Hire? Employer Login',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Terms and Privacy Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () => UrlHandlerService.launchExternal(AppConfig.termsUrl),
                            child: const Text(
                              'Terms of Service',
                              style: TextStyle(fontSize: 11, color: AppConfig.textMuted),
                            ),
                          ),
                          const Text(' · ', style: TextStyle(color: AppConfig.textMuted)),
                          InkWell(
                            onTap: () => UrlHandlerService.launchExternal(AppConfig.privacyUrl),
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(fontSize: 11, color: AppConfig.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

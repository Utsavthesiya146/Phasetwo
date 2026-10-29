import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../services/auth_api_service.dart';
import '../../widgets/auth/auth_components.dart';

/// PhaseTwo Native Password Reset Screen (Option B Modern Dynamic UI).
/// Submits password reset instructions directly to the production backend.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    this.initialRole = 'candidate',
  });

  final String initialRole; // 'candidate' or 'employer'

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final AuthResult result = await AuthApiService.instance.sendPasswordReset(
      email: _emailController.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      setState(() {
        _isLoading = false;
        _successMessage = result.successMessage ??
            'Password reset link dispatched. Please check your inbox.';
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage =
            result.errorMessage ?? 'Unable to send reset instructions. Please retry.';
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
            AuthHeaderBanner(
              title: 'Reset Password',
              subtitle: 'We will dispatch secure recovery instructions to your registered email.',
              badgeText: '🍁 Account Security & Recovery',
              onBackPressed: () => Navigator.of(context).maybePop(),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
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

                      if (_successMessage != null) ...<Widget>[
                        AuthFeedbackBanner(
                          message: _successMessage!,
                          isError: false,
                        ),
                        const SizedBox(height: 16),
                      ],

                      const Row(
                        children: <Widget>[
                          Icon(Icons.lock_reset_rounded, color: AppConfig.primaryNavy, size: 24),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Account Recovery',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppConfig.primaryNavy,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter the email associated with your PhaseTwo candidate or employer account. If an account is registered with this address, a reset link will be sent.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppConfig.textMuted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      AuthTextField(
                        label: 'Registered Email Address',
                        hint: 'e.g. name@domain.ca',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleReset(),
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your registered email.';
                          }
                          if (!val.contains('@') || !val.contains('.')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      AuthButton(
                        text: 'Send Password Reset Link',
                        icon: Icons.send_rounded,
                        isLoading: _isLoading,
                        onPressed: _handleReset,
                      ),
                      const SizedBox(height: 20),

                      // Return to Login Button
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: TextButton.styleFrom(
                            foregroundColor: AppConfig.primaryNavy,
                          ),
                          icon: const Icon(Icons.arrow_back_rounded, size: 16),
                          label: const Text(
                            'Return to Sign In',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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

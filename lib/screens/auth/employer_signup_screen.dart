import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../services/auth_api_service.dart';
import '../../services/url_handler_service.dart';
import '../../widgets/auth/auth_components.dart';
import 'employer_login_screen.dart';

/// PhaseTwo Native Employer / Recruiter Signup Screen (Option B Modern Dynamic UI).
/// Registers Canadian hiring organizations directly to the production backend.
class EmployerSignupScreen extends StatefulWidget {
  const EmployerSignupScreen({
    super.key,
    this.onSignupSuccess,
    this.onAuthSuccess,
  });

  final VoidCallback? onSignupSuccess;
  final VoidCallback? onAuthSuccess;

  @override
  State<EmployerSignupScreen> createState() => _EmployerSignupScreenState();
}

class _EmployerSignupScreenState extends State<EmployerSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cnfPasswordController = TextEditingController();

  String? _selectedStream;
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureCnfPassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  static const List<String> _streamOptions = <String>[
    'Operations',
    'Strategic & Top Management',
    'Finance & Accounting',
    'IT & Information Security',
    'Software Engineering',
    'Product Management',
    'Project & Program Management',
    'Consulting',
    'Human Resources',
    'Marketing / Brand / Digital Marketing',
    'Sales & BD',
    'Data Science & Analytics',
    'Engineering ',
    'Risk Management & Compliance',
    'Legal & Regulatory',
    'Healthcare / Doctor / Hospital Staff/',
    'Banking / Insurance / Financial Services',
    'Admin / Back Office',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStream = _streamOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _gstController.dispose();
    _passwordController.dispose();
    _cnfPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      setState(() {
        _errorMessage = 'Please accept the Terms of Service and Privacy Policy to proceed.';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final EmployerRegisterData payload = EmployerRegisterData(
      name: _nameController.text,
      companyName: _companyNameController.text,
      companyPhone: _phoneController.text,
      companyEmail: _emailController.text,
      stream: _selectedStream ?? _streamOptions.first,
      companyWebsite: _websiteController.text,
      gstNo: _gstController.text,
      planCode: 'PLANEMP00362f199753',
      password: _passwordController.text,
      cnfPassword: _cnfPasswordController.text,
    );

    final AuthResult result =
        await AuthApiService.instance.registerEmployer(payload);

    if (!mounted) return;

    if (result.isSuccess) {
      setState(() {
        _isLoading = false;
        _successMessage = result.successMessage ??
            'Organization registered successfully! You can now sign in.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employer account registered! Please sign in.'),
          backgroundColor: AppConfig.accentGreenDark,
          duration: Duration(seconds: 4),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
      widget.onSignupSuccess?.call();
      widget.onAuthSuccess?.call();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => EmployerLoginScreen(
            onLoginSuccess: widget.onSignupSuccess,
            onAuthSuccess: widget.onAuthSuccess,
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage =
            result.errorMessage ?? 'Employer registration failed. Please review company information.';
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
              title: 'Register Organization',
              subtitle: 'Access Canada\'s premier network of senior executives and fractional leaders.',
              badgeText: '🍁 Employer & Recruiter Registration',
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

                      // Free Plan Highlight Card
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppConfig.accentGreenLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppConfig.accentGreen.withOpacity(0.5)),
                        ),
                        child: const Row(
                          children: <Widget>[
                            Icon(Icons.check_circle_rounded, color: AppConfig.accentGreenDark, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Includes PhaseTwo Free Employer Starter Tier (\$0 CAD)',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppConfig.accentGreenDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Contact Person Name
                      AuthTextField(
                        label: 'Contact Person Name',
                        hint: 'e.g. Sarah Jenkins',
                        prefixIcon: Icons.person_outline_rounded,
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter the contact person\'s full name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Company Name
                      AuthTextField(
                        label: 'Company / Organization Name',
                        hint: 'e.g. NorthStar Advisory Group Inc.',
                        prefixIcon: Icons.business_rounded,
                        controller: _companyNameController,
                        textInputAction: TextInputAction.next,
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your organization name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Company Email
                      AuthTextField(
                        label: 'Corporate Email Address',
                        hint: 'e.g. hiring@company.ca',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your corporate email.';
                          }
                          if (!val.contains('@') || !val.contains('.')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Company Phone
                      AuthTextField(
                        label: 'Company Phone Number',
                        hint: 'e.g. +1 (416) 555-0188',
                        prefixIcon: Icons.phone_outlined,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your company phone.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Industry Stream Dropdown
                      AuthSelectField(
                        label: 'Industry / Primary Domain',
                        prefixIcon: Icons.apartment_rounded,
                        items: _streamOptions,
                        value: _selectedStream,
                        onChanged: (String? val) => setState(() => _selectedStream = val),
                      ),
                      const SizedBox(height: 16),

                      // Website (Optional)
                      AuthTextField(
                        label: 'Company Website (Optional)',
                        hint: 'e.g. https://northstar.ca',
                        prefixIcon: Icons.language_rounded,
                        controller: _websiteController,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // GST/Business No (Optional)
                      AuthTextField(
                        label: 'GST / Tax / Business Number (Optional)',
                        hint: 'e.g. 123456789 RT0001',
                        prefixIcon: Icons.receipt_long_outlined,
                        controller: _gstController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      AuthTextField(
                        label: 'Create Password',
                        hint: 'Min 6 characters',
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
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
                          if (val == null || val.length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Field
                      AuthTextField(
                        label: 'Confirm Password',
                        hint: 'Re-enter your password',
                        prefixIcon: Icons.lock_reset_rounded,
                        controller: _cnfPasswordController,
                        obscureText: _obscureCnfPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSignup(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCnfPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: AppConfig.textMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureCnfPassword = !_obscureCnfPassword;
                            });
                          },
                        ),
                        validator: (String? val) {
                          if (val != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Terms Agreement Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              activeColor: AppConfig.primaryNavy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (bool? val) {
                                setState(() {
                                  _agreedToTerms = val ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Wrap(
                              children: <Widget>[
                                const Text(
                                  'I represent the organization and agree to PhaseTwo\'s ',
                                  style: TextStyle(fontSize: 12, color: AppConfig.textDark),
                                ),
                                InkWell(
                                  onTap: () =>
                                      UrlHandlerService.launchExternal(AppConfig.termsUrl),
                                  child: const Text(
                                    'Employer Terms',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppConfig.primaryDark,
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' & ',
                                  style: TextStyle(fontSize: 12, color: AppConfig.textDark),
                                ),
                                InkWell(
                                  onTap: () =>
                                      UrlHandlerService.launchExternal(AppConfig.privacyUrl),
                                  child: const Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppConfig.primaryDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // Submit Button
                      AuthButton(
                        text: 'Register Organization',
                        icon: Icons.business_center_rounded,
                        backgroundColor: AppConfig.primaryNavy,
                        isLoading: _isLoading,
                        onPressed: _handleSignup,
                      ),
                      const SizedBox(height: 20),

                      // Switch to Sign In
                      AuthSwitchPrompt(
                        question: 'Already registered?',
                        actionText: 'Recruiter Sign In',
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => EmployerLoginScreen(
                                onLoginSuccess: widget.onSignupSuccess,
                              ),
                            ),
                          );
                        },
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

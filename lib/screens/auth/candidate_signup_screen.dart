import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../services/auth_api_service.dart';
import '../../services/url_handler_service.dart';
import '../../widgets/auth/auth_components.dart';
import 'candidate_login_screen.dart';

/// PhaseTwo Native Candidate Signup Screen (Option B Modern Dynamic UI).
/// Collects verified candidate registration fields matching the backend schema.
class CandidateSignupScreen extends StatefulWidget {
  const CandidateSignupScreen({
    super.key,
    this.onSignupSuccess,
    this.onAuthSuccess,
  });

  final VoidCallback? onSignupSuccess;
  final VoidCallback? onAuthSuccess;

  @override
  State<CandidateSignupScreen> createState() => _CandidateSignupScreenState();
}

class _CandidateSignupScreenState extends State<CandidateSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cnfPasswordController = TextEditingController();

  String? _selectedStream;
  String? _selectedQualification;
  String _selectedExp = '10+ year';
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
    'Purchase & Supply Chain',
    'Quality Assurance',
    'Healthcare / Doctor / Hospital Staff/',
    'Banking / Insurance / Financial Services',
    'Admin / Back Office',
    'Research & Development',
  ];

  static const List<String> _qualificationOptions = <String>[
    'Post Graduate',
    'Graduate',
    'Diploma',
    '12th Pass',
    '10th Or Below 10th',
  ];

  static const List<String> _experienceOptions = <String>[
    '10+ year',
    '12 year',
    '15 year',
    '18 year',
    '20 year',
    '25 year',
    '30+ year',
    '5 year',
    '0 year',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStream = _streamOptions.first;
    _selectedQualification = _qualificationOptions.first;
    _dobController.text = '1985-05-15'; // Default mature talent date
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _cnfPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime initialDate = DateTime(1985, 1, 1);
    final DateTime firstDate = DateTime(1940);
    final DateTime lastDate = DateTime(2005, 12, 31);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select Date of Birth',
    );

    if (picked != null) {
      final String month = picked.month.toString().padLeft(2, '0');
      final String day = picked.day.toString().padLeft(2, '0');
      setState(() {
        _dobController.text = '${picked.year}-$month-$day';
      });
    }
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

    final CandidateRegisterData payload = CandidateRegisterData(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      stream: _selectedStream ?? _streamOptions.first,
      dob: _dobController.text,
      jobPreference: _locationController.text.isNotEmpty
          ? _locationController.text
          : 'Canada Remote',
      qualification: _selectedQualification ?? _qualificationOptions.first,
      expYear: _selectedExp,
      password: _passwordController.text,
      cnfPassword: _cnfPasswordController.text,
    );

    final AuthResult result =
        await AuthApiService.instance.registerCandidate(payload);

    if (!mounted) return;

    if (result.isSuccess) {
      setState(() {
        _isLoading = false;
        _successMessage = result.successMessage ??
            'Account created successfully! You can now sign in.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created! Please sign in with your credentials.'),
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
          builder: (_) => CandidateLoginScreen(
            onLoginSuccess: widget.onSignupSuccess,
            onAuthSuccess: widget.onAuthSuccess,
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage =
            result.errorMessage ?? 'Registration failed. Please check inputs.';
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
              title: 'Join PhaseTwo',
              subtitle: 'Create your executive candidate profile for Canada\'s senior network.',
              badgeText: '🍁 Free Candidate Registration',
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

                      // Name Fields (First & Last)
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: AuthTextField(
                              label: 'First Name',
                              hint: 'e.g. Jean',
                              prefixIcon: Icons.person_outline_rounded,
                              controller: _firstNameController,
                              textInputAction: TextInputAction.next,
                              validator: (String? val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AuthTextField(
                              label: 'Last Name',
                              hint: 'e.g. Dupont',
                              prefixIcon: Icons.badge_outlined,
                              controller: _lastNameController,
                              textInputAction: TextInputAction.next,
                              validator: (String? val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      AuthTextField(
                        label: 'Email Address',
                        hint: 'e.g. jean.dupont@domain.ca',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your email.';
                          }
                          if (!val.contains('@') || !val.contains('.')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Field
                      AuthTextField(
                        label: 'Phone Number',
                        hint: 'e.g. +1 (416) 555-0199',
                        prefixIcon: Icons.phone_outlined,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your contact phone.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Stream / Category Selector
                      AuthSelectField(
                        label: 'Professional Stream / Domain',
                        prefixIcon: Icons.category_outlined,
                        items: _streamOptions,
                        value: _selectedStream,
                        onChanged: (String? val) => setState(() => _selectedStream = val),
                      ),
                      const SizedBox(height: 16),

                      // Location Preference
                      AuthTextField(
                        label: 'Preferred Work Location',
                        hint: 'e.g. Toronto, ON / Remote Canada',
                        prefixIcon: Icons.location_on_outlined,
                        controller: _locationController,
                        textInputAction: TextInputAction.next,
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please state your location or remote preference.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Qualification & Experience Row
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: AuthSelectField(
                              label: 'Qualification',
                              prefixIcon: Icons.school_outlined,
                              items: _qualificationOptions,
                              value: _selectedQualification,
                              onChanged: (String? val) =>
                                  setState(() => _selectedQualification = val),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AuthSelectField(
                              label: 'Experience',
                              prefixIcon: Icons.timeline_rounded,
                              items: _experienceOptions,
                              value: _selectedExp,
                              onChanged: (String? val) =>
                                  setState(() => _selectedExp = val ?? '10+ year'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      AuthTextField(
                        label: 'Date of Birth (YYYY-MM-DD)',
                        hint: 'YYYY-MM-DD',
                        prefixIcon: Icons.calendar_today_outlined,
                        controller: _dobController,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.event_rounded, size: 20, color: AppConfig.primaryNavy),
                          onPressed: _selectDateOfBirth,
                        ),
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Date of birth is required.';
                          }
                          return null;
                        },
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
                                  'I agree to PhaseTwo\'s ',
                                  style: TextStyle(fontSize: 12, color: AppConfig.textDark),
                                ),
                                InkWell(
                                  onTap: () =>
                                      UrlHandlerService.launchExternal(AppConfig.termsUrl),
                                  child: const Text(
                                    'Terms of Service',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppConfig.primaryDark,
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' and ',
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
                        text: 'Create Candidate Account',
                        icon: Icons.person_add_rounded,
                        backgroundColor: AppConfig.primaryDark,
                        isLoading: _isLoading,
                        onPressed: _handleSignup,
                      ),
                      const SizedBox(height: 20),

                      // Switch to Sign In
                      AuthSwitchPrompt(
                        question: 'Already have an account?',
                        actionText: 'Sign In',
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => CandidateLoginScreen(
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

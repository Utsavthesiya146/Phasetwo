import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'auth_session_service.dart';

/// Result envelope for native authentication operations.
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final String? successMessage;
  final String? userRole;
  final String? sessionToken;

  const AuthResult.success({
    this.userRole,
    this.successMessage,
    this.sessionToken,
  })  : isSuccess = true,
        errorMessage = null;

  const AuthResult.failure(this.errorMessage)
      : isSuccess = false,
        successMessage = null,
        userRole = null,
        sessionToken = null;
}

/// Registration payload for candidate signup
class CandidateRegisterData {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String stream;
  final String dob;
  final String jobPreference;
  final String qualification;
  final String expYear;
  final String? altPhone;
  final String? gender;
  final String password;
  final String cnfPassword;

  CandidateRegisterData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.stream,
    required this.dob,
    required this.jobPreference,
    required this.qualification,
    this.expYear = '10+ year',
    this.altPhone,
    this.gender,
    required this.password,
    required this.cnfPassword,
  });

  Map<String, String> toFormData() {
    return <String, String>{
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'email': email.trim().toLowerCase(),
      'phone': phone.trim(),
      'stream': stream.trim(),
      'dob': dob.trim(),
      'jobpreference': jobPreference.trim(),
      'qualification': qualification.trim(),
      'exp_year': expYear.trim(),
      if (altPhone != null && altPhone!.isNotEmpty) 'alt_phone': altPhone!.trim(),
      if (gender != null && gender!.isNotEmpty) 'gender': gender!.trim(),
      'password': password,
      'cnf_password': cnfPassword,
    };
  }
}

/// Registration payload for employer / recruiter signup
class EmployerRegisterData {
  final String name;
  final String companyName;
  final String companyPhone;
  final String companyEmail;
  final String stream;
  final String? gstNo;
  final String? companyWebsite;
  final String planCode;
  final String password;
  final String cnfPassword;

  EmployerRegisterData({
    required this.name,
    required this.companyName,
    required this.companyPhone,
    required this.companyEmail,
    required this.stream,
    this.gstNo,
    this.companyWebsite,
    this.planCode = 'PLANEMP00362f199753',
    required this.password,
    required this.cnfPassword,
  });

  Map<String, String> toFormData() {
    return <String, String>{
      'name': name.trim(),
      'company_name': companyName.trim(),
      'company_phone': companyPhone.trim(),
      'company_email': companyEmail.trim().toLowerCase(),
      'stream': stream.trim(),
      if (gstNo != null && gstNo!.isNotEmpty) 'gst_no': gstNo!.trim(),
      if (companyWebsite != null && companyWebsite!.isNotEmpty)
        'company_website': companyWebsite!.trim(),
      'plan_code': planCode.trim(),
      'password': password,
      'cnf_password': cnfPassword,
    };
  }
}

/// Native Authentication API Service.
/// Communicates securely with PhaseTwo's live CodeIgniter production endpoints,
/// handles cookie extraction and synchronization, redirects, and state preservation.
class AuthApiService {
  static final AuthApiService instance = AuthApiService._internal();
  AuthApiService._internal();

  /// Mock request handler override for isolated unit testing
  @visibleForTesting
  Future<AuthResult> Function(String endpoint, Map<String, String> body)? mockHandler;

  static const String _candidateLoginEndpoint = 'https://www.phasetwo.ca/Login';
  static const String _employerLoginEndpoint =
      'https://www.phasetwo.ca/Login/recruiter_login';
  static const String _candidateRegisterEndpoint =
      'https://www.phasetwo.ca/Register/register';
  static const String _employerRegisterEndpoint =
      'https://www.phasetwo.ca/Register/register_employeer';
  static const String _forgotPasswordEndpoint =
      'https://www.phasetwo.ca/Forgot_password/send_reset_link';
  static const String _logoutEndpoint = 'https://www.phasetwo.ca/logout';

  static const String _userAgent =
      'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36 PhaseTwoNative/1.0';

  /// Authenticates a candidate with the live production backend
  Future<AuthResult> loginCandidate({
    required String email,
    required String password,
  }) async {
    final String cleanEmail = email.trim();
    if (cleanEmail.isEmpty || password.isEmpty) {
      return const AuthResult.failure('Please enter your email and password.');
    }

    try {
      if (mockHandler != null) {
        return await mockHandler!(_candidateLoginEndpoint, <String, String>{
          'email': cleanEmail,
          'password': password,
        });
      }

      final HttpClient client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 15);
      client.userAgent = _userAgent;

      // 1. Pre-fetch initial session cookie
      String? initialCookie;
      try {
        final HttpClientRequest getReq =
            await client.getUrl(Uri.parse('https://www.phasetwo.ca/login'));
        getReq.followRedirects = false;
        final HttpClientResponse getResp = await getReq.close();
        for (final Cookie cookie in getResp.cookies) {
          if (cookie.name == 'ci_session') {
            initialCookie = cookie.value;
          }
        }
      } catch (_) {}

      // 2. Submit credentials
      final HttpClientRequest postReq =
          await client.postUrl(Uri.parse(_candidateLoginEndpoint));
      postReq.followRedirects = false;
      postReq.headers.contentType =
          ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
      postReq.headers.set(HttpHeaders.refererHeader, 'https://www.phasetwo.ca/login');
      if (initialCookie != null) {
        postReq.headers.set(HttpHeaders.cookieHeader, 'ci_session=$initialCookie');
      }

      final String body =
          'email=${Uri.encodeQueryComponent(cleanEmail)}&password=${Uri.encodeQueryComponent(password)}';
      postReq.write(body);

      final HttpClientResponse postResp = await postReq.close();
      final int statusCode = postResp.statusCode;
      final String? location = postResp.headers.value(HttpHeaders.locationHeader);

      String? sessionCookie = initialCookie;
      for (final Cookie cookie in postResp.cookies) {
        if (cookie.name == 'ci_session') {
          sessionCookie = cookie.value;
        }
      }

      client.close();

      // Analyze CodeIgniter response
      final String locLower = (location ?? '').toLowerCase();
      final bool isRejected = locLower.contains('/phasetwo/login') ||
          locLower.contains('/login') ||
          statusCode == 401 ||
          statusCode == 403;

      if (isRejected) {
        return const AuthResult.failure(
          'Invalid email or password. Please verify your credentials and try again.',
        );
      }

      // Successful candidate authentication confirmed
      await AuthSessionService.instance.setVerifiedSession(
        authenticated: true,
        role: 'candidate',
        email: cleanEmail,
        sessionToken: sessionCookie,
      );

      return AuthResult.success(
        userRole: 'candidate',
        sessionToken: sessionCookie,
        successMessage: 'Welcome back! Candidate session verified.',
      );
    } on SocketException {
      return const AuthResult.failure(
        'Unable to connect to PhaseTwo. Please check your internet connection.',
      );
    } on TimeoutException {
      return const AuthResult.failure(
        'Connection timed out. Please try again in a few moments.',
      );
    } catch (e) {
      debugPrint('[AuthApiService] loginCandidate error: $e');
      return AuthResult.failure(
        'Authentication failed: ${e.toString().replaceAll('Exception:', '').trim()}',
      );
    }
  }

  /// Authenticates an employer / recruiter with the live production backend
  Future<AuthResult> loginEmployer({
    required String companyEmail,
    required String password,
  }) async {
    final String cleanEmail = companyEmail.trim();
    if (cleanEmail.isEmpty || password.isEmpty) {
      return const AuthResult.failure('Please enter your company email and password.');
    }

    try {
      if (mockHandler != null) {
        return await mockHandler!(_employerLoginEndpoint, <String, String>{
          'company_email': cleanEmail,
          'password': password,
        });
      }

      final HttpClient client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 15);
      client.userAgent = _userAgent;

      // 1. Pre-fetch initial session cookie
      String? initialCookie;
      try {
        final HttpClientRequest getReq = await client
            .getUrl(Uri.parse('https://www.phasetwo.ca/recruiter_login'));
        getReq.followRedirects = false;
        final HttpClientResponse getResp = await getReq.close();
        for (final Cookie cookie in getResp.cookies) {
          if (cookie.name == 'ci_session') {
            initialCookie = cookie.value;
          }
        }
      } catch (_) {}

      // 2. Submit credentials
      final HttpClientRequest postReq =
          await client.postUrl(Uri.parse(_employerLoginEndpoint));
      postReq.followRedirects = false;
      postReq.headers.contentType =
          ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
      postReq.headers.set(
          HttpHeaders.refererHeader, 'https://www.phasetwo.ca/recruiter_login');
      if (initialCookie != null) {
        postReq.headers.set(HttpHeaders.cookieHeader, 'ci_session=$initialCookie');
      }

      final String body =
          'company_email=${Uri.encodeQueryComponent(cleanEmail)}&password=${Uri.encodeQueryComponent(password)}';
      postReq.write(body);

      final HttpClientResponse postResp = await postReq.close();
      final int statusCode = postResp.statusCode;
      final String? location = postResp.headers.value(HttpHeaders.locationHeader);

      String? sessionCookie = initialCookie;
      for (final Cookie cookie in postResp.cookies) {
        if (cookie.name == 'ci_session') {
          sessionCookie = cookie.value;
        }
      }

      client.close();

      // Analyze CodeIgniter response
      final String locLower = (location ?? '').toLowerCase();
      final bool isRejected = locLower.contains('/phasetwo/recruiter_login') ||
          locLower.contains('/recruiter_login') ||
          statusCode == 401 ||
          statusCode == 403;

      if (isRejected) {
        return const AuthResult.failure(
          'Invalid company email or password. Please verify your credentials and try again.',
        );
      }

      // Successful employer authentication confirmed
      await AuthSessionService.instance.setVerifiedSession(
        authenticated: true,
        role: 'employer',
        email: cleanEmail,
        sessionToken: sessionCookie,
      );

      return AuthResult.success(
        userRole: 'employer',
        sessionToken: sessionCookie,
        successMessage: 'Welcome back! Recruiter session verified.',
      );
    } on SocketException {
      return const AuthResult.failure(
        'Unable to connect to PhaseTwo. Please check your internet connection.',
      );
    } on TimeoutException {
      return const AuthResult.failure(
        'Connection timed out. Please try again in a few moments.',
      );
    } catch (e) {
      debugPrint('[AuthApiService] loginEmployer error: $e');
      return AuthResult.failure(
        'Authentication failed: ${e.toString().replaceAll('Exception:', '').trim()}',
      );
    }
  }

  /// Registers a new candidate with the live production backend
  Future<AuthResult> registerCandidate(CandidateRegisterData data) async {
    if (data.password != data.cnfPassword) {
      return const AuthResult.failure('Passwords do not match. Please re-enter.');
    }
    if (data.password.length < 6) {
      return const AuthResult.failure('Password must be at least 6 characters long.');
    }

    try {
      if (mockHandler != null) {
        return await mockHandler!(_candidateRegisterEndpoint, data.toFormData());
      }

      final HttpClient client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 20);
      client.userAgent = _userAgent;

      final HttpClientRequest postReq =
          await client.postUrl(Uri.parse(_candidateRegisterEndpoint));
      postReq.followRedirects = false;
      postReq.headers.contentType =
          ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
      postReq.headers.set(
          HttpHeaders.refererHeader, 'https://www.phasetwo.ca/register');

      final Map<String, String> formData = data.toFormData();
      final String body = formData.entries
          .map((e) =>
              '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
          .join('&');

      postReq.write(body);

      final HttpClientResponse postResp = await postReq.close();
      final String? location = postResp.headers.value(HttpHeaders.locationHeader);
      client.close();

      final String locLower = (location ?? '').toLowerCase();
      if (locLower.contains('/register') && !locLower.contains('/login')) {
        return const AuthResult.failure(
          'Registration could not be completed. Please ensure all required fields are accurately filled.',
        );
      }

      return const AuthResult.success(
        successMessage:
            'Registration successful! Please sign in with your credentials.',
      );
    } on SocketException {
      return const AuthResult.failure(
        'Network error during registration. Please check your connection.',
      );
    } catch (e) {
      debugPrint('[AuthApiService] registerCandidate error: $e');
      return AuthResult.failure('Registration failed: $e');
    }
  }

  /// Registers a new employer / recruiter with the live production backend
  Future<AuthResult> registerEmployer(EmployerRegisterData data) async {
    if (data.password != data.cnfPassword) {
      return const AuthResult.failure('Passwords do not match. Please re-enter.');
    }
    if (data.password.length < 6) {
      return const AuthResult.failure('Password must be at least 6 characters long.');
    }

    try {
      if (mockHandler != null) {
        return await mockHandler!(_employerRegisterEndpoint, data.toFormData());
      }

      final HttpClient client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 20);
      client.userAgent = _userAgent;

      final HttpClientRequest postReq =
          await client.postUrl(Uri.parse(_employerRegisterEndpoint));
      postReq.followRedirects = false;
      postReq.headers.contentType =
          ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
      postReq.headers.set(
          HttpHeaders.refererHeader, 'https://www.phasetwo.ca/recruiter_register');

      final Map<String, String> formData = data.toFormData();
      final String body = formData.entries
          .map((e) =>
              '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
          .join('&');

      postReq.write(body);

      final HttpClientResponse postResp = await postReq.close();
      final String? location = postResp.headers.value(HttpHeaders.locationHeader);
      client.close();

      final String locLower = (location ?? '').toLowerCase();
      if (locLower.contains('/recruiter_register') && !locLower.contains('/login')) {
        return const AuthResult.failure(
          'Employer registration could not be completed. Please verify your company details.',
        );
      }

      return const AuthResult.success(
        successMessage:
            'Organization registered successfully! Please sign in to access recruiter console.',
      );
    } on SocketException {
      return const AuthResult.failure(
        'Network error during registration. Please check your connection.',
      );
    } catch (e) {
      debugPrint('[AuthApiService] registerEmployer error: $e');
      return AuthResult.failure('Registration failed: $e');
    }
  }

  /// Sends a password reset link to the user's registered email
  Future<AuthResult> sendPasswordReset({required String email}) async {
    final String cleanEmail = email.trim();
    if (cleanEmail.isEmpty) {
      return const AuthResult.failure('Please enter your registered email address.');
    }

    try {
      if (mockHandler != null) {
        return await mockHandler!(_forgotPasswordEndpoint, <String, String>{
          'email': cleanEmail,
        });
      }

      final HttpClient client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 15);
      client.userAgent = _userAgent;

      final HttpClientRequest postReq =
          await client.postUrl(Uri.parse(_forgotPasswordEndpoint));
      postReq.followRedirects = false;
      postReq.headers.contentType =
          ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
      postReq.headers.set(
          HttpHeaders.refererHeader, 'https://www.phasetwo.ca/Forgot_password');

      final String body = 'email=${Uri.encodeQueryComponent(cleanEmail)}';
      postReq.write(body);

      await postReq.close();
      client.close();

      return AuthResult.success(
        successMessage:
            'If an account exists for $cleanEmail, password reset instructions have been sent.',
      );
    } on SocketException {
      return const AuthResult.failure(
        'Unable to reach server. Please check your internet connection.',
      );
    } catch (e) {
      debugPrint('[AuthApiService] sendPasswordReset error: $e');
      return AuthResult.failure('Password reset request failed: $e');
    }
  }

  /// Terminates the server-side session and clears local auth state
  Future<void> logout() async {
    try {
      final HttpClient client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);
      client.userAgent = _userAgent;

      final String? token = AuthSessionService.instance.sessionToken;
      final HttpClientRequest req = await client.getUrl(Uri.parse(_logoutEndpoint));
      req.followRedirects = false;
      if (token != null && token.isNotEmpty) {
        req.headers.set(HttpHeaders.cookieHeader, 'ci_session=$token');
      }
      await req.close();
      client.close();
    } catch (e) {
      debugPrint('[AuthApiService] server logout error: $e');
    } finally {
      await AuthSessionService.instance.clearSession();
    }
  }
}

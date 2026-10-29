import 'package:flutter_test/flutter_test.dart';
import 'package:phasetwo/config/app_config.dart';
import 'package:phasetwo/services/url_handler_service.dart';

void main() {
  group('UrlHandlerService Tests', () {
    test('Identifies internal PhaseTwo URLs correctly', () {
      expect(
        UrlHandlerService.isInternalUrl(Uri.parse('https://www.phasetwo.ca/')),
        isTrue,
      );
      expect(
        UrlHandlerService.isInternalUrl(Uri.parse('https://www.phasetwo.ca/login')),
        isTrue,
      );
      expect(
        UrlHandlerService.isInternalUrl(
          Uri.parse('https://www.phasetwo.ca/recruiter_login'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isInternalUrl(Uri.parse('https://www.phasetwo.ca/jobs')),
        isTrue,
      );
      expect(
        UrlHandlerService.isInternalUrl(Uri.parse('https://phasetwo.ca/about')),
        isTrue,
      );
    });

    test('Identifies allowed payment and authentication hosts', () {
      expect(
        UrlHandlerService.isInternalUrl(
          Uri.parse('https://checkout.stripe.com/c/pay/cs_live_123'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isInternalUrl(
          Uri.parse('https://www.paypal.com/checkoutnow'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isInternalUrl(
          Uri.parse('https://accounts.google.com/o/oauth2/auth'),
        ),
        isTrue,
      );
    });

    test('Identifies external un-allowed hosts', () {
      expect(
        UrlHandlerService.isInternalUrl(Uri.parse('https://www.random-website.com/')),
        isFalse,
      );
      expect(
        UrlHandlerService.isInternalUrl(Uri.parse('https://malicious-site.org/')),
        isFalse,
      );
    });

    test('Detects downloadable files correctly', () {
      expect(
        UrlHandlerService.isDownloadUrl(
          Uri.parse('https://www.phasetwo.ca/uploads/candidate_resume.pdf'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isDownloadUrl(
          Uri.parse('https://www.phasetwo.ca/files/job_spec.docx'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isDownloadUrl(
          Uri.parse('https://www.phasetwo.ca/data/report.xlsx'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isDownloadUrl(
          Uri.parse('https://www.phasetwo.ca/jobs?download=true'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isDownloadUrl(Uri.parse('https://www.phasetwo.ca/jobs')),
        isFalse,
      );
      expect(
        UrlHandlerService.isDownloadUrl(Uri.parse('https://www.phasetwo.ca/login')),
        isFalse,
      );
    });

    test('Detects special device schemes (mailto, tel, sms)', () {
      expect(
        UrlHandlerService.isSpecialScheme(Uri.parse('mailto:info@phasetwo.com')),
        isTrue,
      );
      expect(
        UrlHandlerService.isSpecialScheme(Uri.parse('tel:+14165550199')),
        isTrue,
      );
      expect(
        UrlHandlerService.isSpecialScheme(Uri.parse('sms:+14165550199')),
        isTrue,
      );
      expect(
        UrlHandlerService.isSpecialScheme(Uri.parse('whatsapp://send?phone=123')),
        isTrue,
      );
      expect(
        UrlHandlerService.isSpecialScheme(Uri.parse('https://www.phasetwo.ca/')),
        isFalse,
      );
    });

    test('Detects social media external links', () {
      expect(
        UrlHandlerService.isSocialOrExternalLink(
          Uri.parse('https://www.linkedin.com/company/phasetwo'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isSocialOrExternalLink(
          Uri.parse('https://facebook.com/phasetwo'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isSocialOrExternalLink(
          Uri.parse('https://x.com/phasetwo'),
        ),
        isTrue,
      );
      expect(
        UrlHandlerService.isSocialOrExternalLink(
          Uri.parse('https://www.phasetwo.ca/'),
        ),
        isFalse,
      );
    });

    test('AppConfig constants are defined properly', () {
      expect(AppConfig.appName, equals('PhaseTwo'));
      expect(AppConfig.initialUrl, equals('https://www.phasetwo.ca/'));
      expect(AppConfig.candidateLoginUrl, equals('https://www.phasetwo.ca/login'));
      expect(
        AppConfig.employerLoginUrl,
        equals('https://www.phasetwo.ca/recruiter_login'),
      );
    });
  });
}

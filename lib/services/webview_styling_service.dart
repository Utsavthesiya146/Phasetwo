/// PhaseTwo Mobile Injected Styles & Scripts Service
/// Transforms website content inside the WebView into a premium, modern mobile app
/// experience comparable to LinkedIn, Indeed, and Job Hai.
class WebViewStylingService {
  WebViewStylingService._();

  /// Clean, bulletproof CSS tailored specifically for PhaseTwo web pages on mobile devices.
  /// Eliminates duplicate web headers and footers, reformats job detail cards,
  /// fixes text truncation, styles action buttons (Quick Apply, Save), and polishes typography.
  static const String mobileAppCss = r'''
    /* --- PhaseTwo Mobile App Transform (LinkedIn & Indeed Theme) --- */

    /* 1. Eliminate Duplicate Web Headers & Navbars */
    header,
    .header,
    .header-light,
    .head-shadow,
    #navigation,
    .nav-header,
    .mobile_nav,
    .nav-menus-wrapper,
    .navigation-landscape,
    .top-header,
    #mobile,
    .navigation-portrait {
      display: none !important;
      height: 0 !important;
      min-height: 0 !important;
      visibility: hidden !important;
      margin: 0 !important;
      padding: 0 !important;
    }

    /* 2. Eliminate Bulky Footers on Mobile */
    footer,
    .footer,
    .dark-footer,
    .footer-bottom,
    #footer,
    .footer-area {
      display: none !important;
    }

    /* 3. Base Layout & Typography Optimization */
    html, body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif !important;
      background-color: #F8FAFC !important;
      color: #0F172A !important;
      margin: 0 !important;
      padding-top: 0 !important;
      padding-bottom: 72px !important; /* Space above mobile bottom bar */
      -webkit-font-smoothing: antialiased !important;
      -webkit-tap-highlight-color: transparent !important;
      overflow-x: hidden !important;
      width: 100% !important;
      max-width: 100vw !important;
    }

    #main-wrapper {
      padding-top: 0 !important;
      margin-top: 0 !important;
    }

    section,
    .gray-simple {
      padding-top: 12px !important;
      padding-bottom: 24px !important;
      background-color: #F8FAFC !important;
    }

    .container,
    .container-fluid {
      padding-left: 14px !important;
      padding-right: 14px !important;
      max-width: 100% !important;
    }

    /* 4. Job Details Card Transformation (Fixes Image 2 issues) */
    .jbs-grid-emp-head,
    .job-instructor-header,
    .jbs-grid-layout {
      background: #FFFFFF !important;
      border-radius: 18px !important;
      border: 1px solid #E2E8F0 !important;
      box-shadow: 0 4px 20px -2px rgba(15, 43, 70, 0.08) !important;
      padding: 18px 16px !important;
      margin-bottom: 16px !important;
      position: relative !important;
      box-sizing: border-box !important;
    }

    /* Avatar & Employer Info Row */
    .jbs-grid-emp-thumb {
      margin-bottom: 12px !important;
    }

    .jbs-grid-emp-thumb img,
    .instructor-thumb img {
      width: 52px !important;
      height: 52px !important;
      border-radius: 14px !important;
      border: 1.5px solid #E2E8F0 !important;
      object-fit: cover !important;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05) !important;
    }

    /* Fix Truncated Job Title: Give full width & clean wrapping */
    .jbs-job-title-wrap h4,
    .jbs-job-title,
    .instructor-title a,
    h4.instructor-title {
      font-size: 20px !important;
      font-weight: 800 !important;
      color: #0F2B46 !important;
      line-height: 1.35 !important;
      white-space: normal !important;
      overflow: visible !important;
      text-overflow: clip !important;
      word-break: break-word !important;
      display: block !important;
      margin: 8px 0 6px 0 !important;
      text-decoration: none !important;
      letter-spacing: -0.3px !important;
    }

    /* Category & Employer badge */
    .jbs-job-employer-wrap span,
    .jbs-grid-job-caption span {
      background: #E0F2FE !important;
      color: #0284C7 !important;
      font-weight: 700 !important;
      font-size: 11.5px !important;
      padding: 4px 12px !important;
      border-radius: 20px !important;
      display: inline-flex !important;
      align-items: center !important;
      margin: 2px 4px 4px 0 !important;
    }

    /* Vacancy Pill */
    .urgent,
    span.urgent,
    .badge-warning {
      background: #FEF3C7 !important;
      color: #B45309 !important;
      font-weight: 700 !important;
      font-size: 11.5px !important;
      padding: 4px 12px !important;
      border-radius: 20px !important;
      border: 1px solid #FDE68A !important;
      display: inline-flex !important;
      align-items: center !important;
      margin: 2px 4px 4px 0 !important;
    }

    /* Salary Tag */
    h5:has(span),
    .jbs-grid-job-caption h5,
    .job-salary {
      font-size: 19px !important;
      font-weight: 800 !important;
      color: #0F2B46 !important;
      margin: 12px 0 8px 0 !important;
      display: flex !important;
      align-items: baseline !important;
      gap: 4px !important;
    }

    h5 span,
    .job-salary span {
      font-size: 13px !important;
      color: #64748B !important;
      font-weight: 600 !important;
    }

    /* 5. Quick Apply & Save Jobs Buttons: Convert Floats to Modern Flex Row */
    .jbs-sng-blux {
      display: flex !important;
      flex-direction: row !important;
      gap: 10px !important;
      width: 100% !important;
      float: none !important;
      clear: both !important;
      margin-top: 16px !important;
      box-sizing: border-box !important;
    }

    /* All Action Buttons */
    .jbs-sng-blux a,
    .jbs-sng-blux .btn {
      flex: 1 1 0 !important;
      height: 48px !important;
      display: inline-flex !important;
      align-items: center !important;
      justify-content: center !important;
      border-radius: 12px !important;
      font-size: 14.5px !important;
      font-weight: 800 !important;
      letter-spacing: -0.2px !important;
      text-align: center !important;
      float: none !important;
      margin: 0 !important;
      padding: 0 12px !important;
      text-decoration: none !important;
      box-sizing: border-box !important;
      transition: all 0.2s ease !important;
    }

    /* Quick Apply Primary Button (LinkedIn / Indeed High-Impact Blue) */
    .jbs-sng-blux .btn-primary,
    .jbs-sng-blux a[data-bs-target*="apply"],
    .btn-apply {
      background: linear-gradient(135deg, #0284C7 0%, #38B6FF 100%) !important;
      color: #FFFFFF !important;
      border: none !important;
      box-shadow: 0 4px 14px rgba(56, 182, 255, 0.4) !important;
    }

    .jbs-sng-blux .btn-primary:active {
      transform: scale(0.98) !important;
      box-shadow: 0 2px 6px rgba(56, 182, 255, 0.3) !important;
    }

    /* Save Jobs Secondary Button */
    .jbs-sng-blux .btn-info,
    .jbs-sng-blux a:not(.btn-primary),
    .btn-save {
      background: #F1F5F9 !important;
      color: #0F2B46 !important;
      border: 1.5px solid #CBD5E1 !important;
      box-shadow: none !important;
    }

    .jbs-sng-blux .btn-info:active {
      background: #E2E8F0 !important;
      transform: scale(0.98) !important;
    }

    /* 6. Section Detail Cards (Job Description, Skills, Qualifications) */
    .jbs-content-group,
    .job-overview-inner,
    .jbs-bloc-body,
    .single-job-content {
      background: #FFFFFF !important;
      border-radius: 16px !important;
      border: 1px solid #E2E8F0 !important;
      padding: 18px 16px !important;
      margin-bottom: 14px !important;
      box-shadow: 0 2px 10px rgba(15, 43, 70, 0.04) !important;
      box-sizing: border-box !important;
    }

    /* Section Headings */
    .jbs-content-group h4,
    .jbs-content-group h5,
    .job-overview-inner h4,
    h4:not(.jbs-job-title) {
      font-size: 16px !important;
      font-weight: 800 !important;
      color: #0F2B46 !important;
      letter-spacing: -0.2px !important;
      margin-bottom: 12px !important;
      display: flex !important;
      align-items: center !important;
    }

    .jbs-content-group h4::before {
      content: '' !important;
      display: inline-block !important;
      width: 4px !important;
      height: 16px !important;
      background: #38B6FF !important;
      border-radius: 2px !important;
      margin-right: 8px !important;
    }

    /* List items & checkmarks */
    .jbs-content-group ul,
    .jbs-content-group ol {
      padding-left: 20px !important;
      margin: 8px 0 !important;
    }

    .jbs-content-group li {
      font-size: 14px !important;
      line-height: 1.6 !important;
      color: #334155 !important;
      margin-bottom: 6px !important;
    }

    /* 7. Job Search Listings Feed (/jobs, /browse_jobs) */
    .jbs-grid-layout,
    .jbs-list-layout,
    .job-grid {
      background: #FFFFFF !important;
      border-radius: 16px !important;
      border: 1px solid #E2E8F0 !important;
      box-shadow: 0 2px 12px rgba(15, 43, 70, 0.05) !important;
      padding: 16px !important;
      margin-bottom: 12px !important;
      box-sizing: border-box !important;
      transition: border-color 0.2s ease !important;
    }

    .jbs-grid-layout:hover,
    .jbs-grid-layout:active {
      border-color: #38B6FF !important;
    }

    /* Search Bar Form Controls */
    .form-control,
    .form-select,
    select,
    input[type="text"],
    input[type="search"] {
      height: 46px !important;
      border-radius: 12px !important;
      border: 1.5px solid #CBD5E1 !important;
      background-color: #F8FAFC !important;
      font-size: 14.5px !important;
      padding: 8px 14px !important;
      box-shadow: none !important;
    }

    .form-control:focus,
    .form-select:focus,
    input:focus {
      border-color: #0284C7 !important;
      background-color: #FFFFFF !important;
      outline: none !important;
      box-shadow: 0 0 0 3px rgba(56, 182, 255, 0.2) !important;
    }

    /* Modern Modals on Mobile */
    .modal-content {
      border-radius: 20px !important;
      border: none !important;
      box-shadow: 0 10px 40px rgba(15, 43, 70, 0.2) !important;
      padding: 16px !important;
    }

    .modal-header {
      border-bottom: 1px solid #E2E8F0 !important;
      padding-bottom: 12px !important;
    }

    .modal-title {
      font-weight: 800 !important;
      color: #0F2B46 !important;
      font-size: 18px !important;
    }

    /* Prevent mobile overflow */
    * {
      max-width: 100%;
    }
  ''';

  /// Injected JavaScript that runs on every page load and dynamically watches
  /// for DOM changes (MutationObserver) to enforce the mobile styling without delay.
  static String getInjectionScript() {
    // Escaped string for execution via WebViewController.runJavaScript
    return '''
      (function() {
        try {
          // 1. Ensure mobile viewport meta tag is present & proper
          var meta = document.querySelector('meta[name="viewport"]');
          if (!meta) {
            meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
            document.head.appendChild(meta);
          } else {
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
          }

          // 2. Inject or update the custom CSS stylesheet
          var existingStyle = document.getElementById('phasetwo-mobile-styles');
          if (!existingStyle) {
            var styleEl = document.createElement('style');
            styleEl.id = 'phasetwo-mobile-styles';
            styleEl.textContent = ${jsonEncodeString(mobileAppCss)};
            if (document.head) {
              document.head.appendChild(styleEl);
            } else if (document.documentElement) {
              document.documentElement.appendChild(styleEl);
            }
          }

          // 3. Remove web navbar elements if still in DOM
          function cleanHeaders() {
            var badSelectors = [
              '.header',
              '#navigation',
              '.nav-header',
              '.mobile_nav',
              '.top-header',
              '#mobile',
              '.navigation-landscape',
              '.footer',
              '.dark-footer',
              '#footer'
            ];
            badSelectors.forEach(function(sel) {
              var els = document.querySelectorAll(sel);
              els.forEach(function(el) {
                el.style.setProperty('display', 'none', 'important');
              });
            });

            // Fix button float in job details cards
            var actionBars = document.querySelectorAll('.jbs-sng-blux');
            actionBars.forEach(function(bar) {
              bar.style.setProperty('display', 'flex', 'important');
              bar.style.setProperty('float', 'none', 'important');
              var btns = bar.querySelectorAll('a, .btn');
              btns.forEach(function(btn) {
                btn.style.setProperty('float', 'none', 'important');
                btn.style.setProperty('margin', '0', 'important');
              });
            });

            // Fix title wrapping
            var titles = document.querySelectorAll('.jbs-job-title, .instructor-title a');
            titles.forEach(function(t) {
              t.style.setProperty('white-space', 'normal', 'important');
              t.style.setProperty('overflow', 'visible', 'important');
              t.style.setProperty('text-overflow', 'clip', 'important');
            });
          }

          cleanHeaders();

          // 4. Attach MutationObserver to watch for dynamic ajax content
          if (window.MutationObserver && !window._phasetwoObserverAttached) {
            window._phasetwoObserverAttached = true;
            var observer = new MutationObserver(function() {
              cleanHeaders();
            });
            observer.observe(document.body || document.documentElement, {
              childList: true,
              subtree: true
            });
          }
        } catch(e) {
          console.error('[PhaseTwoStyle] Injection error:', e);
        }
      })();
    ''';
  }

  /// Encodes a multi-line raw string safely into a JavaScript string literal
  static String jsonEncodeString(String text) {
    final StringBuffer sb = StringBuffer('"');
    for (int i = 0; i < text.length; i++) {
      final String char = text[i];
      switch (char) {
        case '\\':
          sb.write(r'\\');
          break;
        case '"':
          sb.write(r'\"');
          break;
        case '\n':
          sb.write(r'\n');
          break;
        case '\r':
          sb.write(r'\r');
          break;
        case '\t':
          sb.write(r'\t');
          break;
        default:
          sb.write(char);
      }
    }
    sb.write('"');
    return sb.toString();
  }
}


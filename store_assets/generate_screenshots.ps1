Add-Type -AssemblyName System.Drawing

$width = 1080
$height = 1920

function Create-BasePhoneFrame {
    param($title, $subtitle)

    $bmp = New-Object System.Drawing.Bitmap $width, $height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Backdrop gradient
    $rect = New-Object System.Drawing.Rectangle 0, 0, $width, $height
    $c1 = [System.Drawing.Color]::FromArgb(15, 23, 42)
    $c2 = [System.Drawing.Color]::FromArgb(15, 43, 70)
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $c1, $c2, 90
    $g.FillRectangle($brush, $rect)

    # Header title
    $titleFont = New-Object System.Drawing.Font('Segoe UI', 42, [System.Drawing.FontStyle]::Bold)
    $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString($title, $titleFont, $titleBrush, 80, 110)

    $subFont = New-Object System.Drawing.Font('Segoe UI', 22, [System.Drawing.FontStyle]::Regular)
    $subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(148, 163, 184))
    $g.DrawString($subtitle, $subFont, $subBrush, 80, 185)

    # Phone frame
    $phoneX = 90
    $phoneY = 280
    $phoneW = 900
    $phoneH = 1640

    $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(70, 0, 0, 0))
    $g.FillRectangle($shadowBrush, $phoneX - 8, $phoneY - 8, $phoneW + 16, $phoneH + 16)

    $bezelBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 41, 59))
    $g.FillRectangle($bezelBrush, $phoneX, $phoneY, $phoneW, $phoneH)

    $screenX = $phoneX + 16
    $screenY = $phoneY + 20
    $screenW = $phoneW - 32
    $screenH = $phoneH - 40
    $screenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillRectangle($screenBrush, $screenX, $screenY, $screenW, $screenH)

    $statusFont = New-Object System.Drawing.Font('Segoe UI', 15, [System.Drawing.FontStyle]::Bold)
    $statusBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(15, 23, 42))
    $g.DrawString("9:41", $statusFont, $statusBrush, $screenX + 30, $screenY + 14)
    $g.DrawString("PhaseTwo - 5G 100%", $statusFont, $statusBrush, $screenX + $screenW - 220, $screenY + 14)

    return @{ Bitmap = $bmp; Graphics = $g; ScreenX = $screenX; ScreenY = $screenY + 45; ScreenW = $screenW; ScreenH = $screenH - 45 }
}

# Common brushes
$darkBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(15, 43, 70))
$cyanBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(56, 182, 255))
$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$mutedBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 116, 139))
$cardBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(241, 245, 249))
$greenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(16, 185, 129))
$headerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)

$headTitleFont = New-Object System.Drawing.Font('Segoe UI', 26, [System.Drawing.FontStyle]::Bold)
$cTitleFont = New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Bold)
$cSubFont = New-Object System.Drawing.Font('Segoe UI', 13, [System.Drawing.FontStyle]::Regular)
$secFont = New-Object System.Drawing.Font('Segoe UI', 18, [System.Drawing.FontStyle]::Bold)
$navFont = New-Object System.Drawing.Font('Segoe UI', 13, [System.Drawing.FontStyle]::Bold)

# SCREEN 1
Write-Host "Creating Screenshot 1..."
$f1 = Create-BasePhoneFrame "Modern Executive Dashboard" "Option B Dynamic Experience for 10+ Yrs Talent"
$g = $f1.Graphics
$sx = $f1.ScreenX
$sy = $f1.ScreenY
$sw = $f1.ScreenW

$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $sy, $sw, 80))
$g.DrawString("Phase", $headTitleFont, $darkBrush, $sx + 30, $sy + 18)
$g.DrawString("Two", $headTitleFont, $cyanBrush, $sx + 145, $sy + 18)

$heroY = $sy + 85
$heroH = 320
$heroRect = New-Object System.Drawing.Rectangle $sx, $heroY, $sw, $heroH
$heroBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $heroRect, ([System.Drawing.Color]::FromArgb(15, 43, 70)), ([System.Drawing.Color]::FromArgb(2, 132, 199)), 45
$g.FillRectangle($heroBrush, $heroRect)
$g.DrawString("Flexible Work for Experienced", (New-Object System.Drawing.Font('Segoe UI', 24, [System.Drawing.FontStyle]::Bold)), $whiteBrush, $sx + 30, $heroY + 30)
$g.DrawString("Canadian Professionals", (New-Object System.Drawing.Font('Segoe UI', 24, [System.Drawing.FontStyle]::Bold)), $whiteBrush, $sx + 30, $heroY + 70)
$g.DrawString("Canada Wide  -  10+ Yrs Domain Talent", (New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)), $greenBrush, $sx + 30, $heroY + 120)

$searchRect = New-Object System.Drawing.Rectangle ($sx + 30), ($heroY + 175), ($sw - 60), 65
$g.FillRectangle($whiteBrush, $searchRect)
$g.DrawString("Search executive jobs, fractional leadership...", (New-Object System.Drawing.Font('Segoe UI', 15, [System.Drawing.FontStyle]::Regular)), $mutedBrush, $sx + 50, $heroY + 195)

$qaY = $heroY + $heroH + 25
$g.DrawString("EXPLORE OPPORTUNITIES", $secFont, $darkBrush, $sx + 30, $qaY)

$cardW = [int](($sw - 80) / 2)
$cardH = 140
$g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 30), ($qaY + 40), $cardW, $cardH))
$g.DrawString("Search Jobs", $cTitleFont, $darkBrush, $sx + 45, $qaY + 60)
$g.DrawString("Full-time and leadership", $cSubFont, $mutedBrush, $sx + 45, $qaY + 95)

$g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 50 + $cardW), ($qaY + 40), $cardW, $cardH))
$g.DrawString("Live Gigs", $cTitleFont, $darkBrush, $sx + 65 + $cardW, $qaY + 60)
$g.DrawString("Fractional and contract", $cSubFont, $mutedBrush, $sx + 65 + $cardW, $qaY + 95)

$wmY = $qaY + 210
$g.DrawString("FLEXIBLE WORK MODELS", $secFont, $darkBrush, $sx + 30, $wmY)
$models = @("Executive Leadership (VP / Director / C-Suite)", "Fractional Management (1-3 days / week)", "Advisory Board and Interim Roles", "Specialized Consulting and Project Delivery")
$mY = $wmY + 40
foreach ($m in $models) {
    $g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 30), $mY, ($sw - 60), 55))
    $g.DrawString("[V] $m", $cSubFont, $darkBrush, $sx + 50, $mY + 16)
    $mY += 68
}

$navY = $sy + $f1.ScreenH - 95
$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $navY, $sw, 95))
$g.DrawString("Home", $navFont, $cyanBrush, $sx + 45, $navY + 35)
$g.DrawString("Jobs", $navFont, $mutedBrush, $sx + 260, $navY + 35)
$g.DrawString("Candidate", $navFont, $mutedBrush, $sx + 475, $navY + 35)
$g.DrawString("Employer", $navFont, $mutedBrush, $sx + 690, $navY + 35)

$f1.Bitmap.Save("F:\phasetwo\store_assets\screenshots\01_home_dashboard.png", [System.Drawing.Imaging.ImageFormat]::Png)
$f1.Graphics.Dispose()
$f1.Bitmap.Dispose()

# SCREEN 2
Write-Host "Creating Screenshot 2..."
$f2 = Create-BasePhoneFrame "High-Density Job Search" "Targeted Canadian Cities and Flexible Categories"
$g = $f2.Graphics
$sx = $f2.ScreenX
$sy = $f2.ScreenY
$sw = $f2.ScreenW

$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $sy, $sw, 80))
$g.DrawString("Search Jobs and Gigs", $headTitleFont, $darkBrush, $sx + 30, $sy + 18)

$inY = $sy + 95
$g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 30), $inY, ($sw - 60), 65))
$g.DrawString("Chief Financial Officer, Toronto...", (New-Object System.Drawing.Font('Segoe UI', 15, [System.Drawing.FontStyle]::Regular)), $mutedBrush, $sx + 50, $inY + 20)

$chipY = $inY + 80
$cities = @("All Canada", "Remote", "Toronto", "Vancouver", "Montreal", "Calgary")
$cX = $sx + 30
foreach ($c in $cities) {
    $chipW = 125
    $cRect = New-Object System.Drawing.Rectangle $cX, $chipY, $chipW, 45
    if ($c -eq "Remote") {
        $chipBg = $cyanBrush
        $chipTxt = $whiteBrush
    } else {
        $chipBg = $cardBg
        $chipTxt = $darkBrush
    }
    $g.FillRectangle($chipBg, $cRect)
    $g.DrawString($c, (New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Bold)), $chipTxt, $cX + 18, $chipY + 12)
    $cX += $chipW + 12
}

$jobs = @(
    @{ Title = "Fractional Chief Technology Officer"; Org = "Apex Health AI"; Loc = "Toronto, ON (Hybrid)"; Comp = "$180K - $220K - Fractional 2 Days/Wk"; Type = "Executive Fractional" },
    @{ Title = "VP of Strategic Partnerships"; Org = "Maple Cleantech Inc"; Loc = "Vancouver, BC (Remote)"; Comp = "$195K CAD Base + Equity"; Type = "Full-Time Executive" },
    @{ Title = "Advisory Board Member - FinTech"; Org = "Horizon Payments Canada"; Loc = "Montreal, QC (Advisory)"; Comp = "Retainer + Equity Advisory"; Type = "Board Advisory" },
    @{ Title = "Interim Head of People and Culture"; Org = "Prairie SaaS Solutions"; Loc = "Calgary, AB (Remote)"; Comp = "$150/hr - 6-Month Contract"; Type = "Interim Leadership" }
)

$jY = $chipY + 70
foreach ($j in $jobs) {
    $g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 30), $jY, ($sw - 60), 165))
    $badgeRect = New-Object System.Drawing.Rectangle ($sx + 50), ($jY + 16), 190, 28
    $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(224, 242, 254))), $badgeRect)
    $g.DrawString($j.Type, (New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold)), (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(2, 132, 199))), $sx + 60, $jY + 22)
    $g.DrawString($j.Title, (New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Bold)), $darkBrush, $sx + 50, $jY + 52)
    $g.DrawString("$($j.Org) - $($j.Loc)", $cSubFont, $mutedBrush, $sx + 50, $jY + 86)
    $g.DrawString($j.Comp, (New-Object System.Drawing.Font('Segoe UI', 13, [System.Drawing.FontStyle]::Bold)), $greenBrush, $sx + 50, $jY + 120)
    $jY += 185
}

$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $navY, $sw, 95))
$g.DrawString("Home", $navFont, $mutedBrush, $sx + 45, $navY + 35)
$g.DrawString("Jobs", $navFont, $cyanBrush, $sx + 260, $navY + 35)
$g.DrawString("Candidate", $navFont, $mutedBrush, $sx + 475, $navY + 35)
$g.DrawString("Employer", $navFont, $mutedBrush, $sx + 690, $navY + 35)

$f2.Bitmap.Save("F:\phasetwo\store_assets\screenshots\02_job_search.png", [System.Drawing.Imaging.ImageFormat]::Png)
$f2.Graphics.Dispose()
$f2.Bitmap.Dispose()

# SCREEN 3
Write-Host "Creating Screenshot 3..."
$f3 = Create-BasePhoneFrame "Native Candidate Portal" "Option B Authentication and Registration"
$g = $f3.Graphics
$sx = $f3.ScreenX
$sy = $f3.ScreenY
$sw = $f3.ScreenW

$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $sy, $sw, 80))
$g.DrawString("Candidate Sign In", $headTitleFont, $darkBrush, $sx + 30, $sy + 18)

$cHeroY = $sy + 95
$cHeroH = 180
$cHeroRect = New-Object System.Drawing.Rectangle ($sx + 30), $cHeroY, ($sw - 60), $cHeroH
$cHeroBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $cHeroRect, ([System.Drawing.Color]::FromArgb(2, 132, 199)), ([System.Drawing.Color]::FromArgb(56, 182, 255)), 45
$g.FillRectangle($cHeroBrush, $cHeroRect)
$g.DrawString("Welcome Experienced Talent", (New-Object System.Drawing.Font('Segoe UI', 22, [System.Drawing.FontStyle]::Bold)), $whiteBrush, $sx + 60, $cHeroY + 30)
$g.DrawString("Sign in to your PhaseTwo candidate profile to manage credentials, search executive roles, and connect directly with hiring employers.", $cSubFont, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240, 249, 255))), (New-Object System.Drawing.RectangleF ($sx + 60), ($cHeroY + 80), ($sw - 120), 80))

$formY = $cHeroY + $cHeroH + 35
$g.DrawString("Email Address", (New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)), $darkBrush, $sx + 30, $formY)
$g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 30), ($formY + 30), ($sw - 60), 65))
$g.DrawString("candidate.executive@domain.ca", (New-Object System.Drawing.Font('Segoe UI', 15, [System.Drawing.FontStyle]::Regular)), $darkBrush, $sx + 50, $formY + 50)

$passY = $formY + 115
$g.DrawString("Password", (New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)), $darkBrush, $sx + 30, $passY)
$g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 30), ($passY + 30), ($sw - 60), 65))
$g.DrawString("****************", (New-Object System.Drawing.Font('Segoe UI', 15, [System.Drawing.FontStyle]::Regular)), $darkBrush, $sx + 50, $passY + 50)

$btnY = $passY + 125
$btnRect = New-Object System.Drawing.Rectangle ($sx + 30), $btnY, ($sw - 60), 70
$g.FillRectangle($cyanBrush, $btnRect)
$g.DrawString("Sign In as Candidate", (New-Object System.Drawing.Font('Segoe UI', 18, [System.Drawing.FontStyle]::Bold)), $whiteBrush, $sx + 290, $btnY + 20)

$regY = $btnY + 100
$g.DrawString("Don't have an account? Register as Candidate", (New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)), (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(2, 132, 199))), $sx + 190, $regY)

$secY = $regY + 75
$secRect = New-Object System.Drawing.Rectangle ($sx + 30), $secY, ($sw - 60), 120
$g.FillRectangle($cardBg, $secRect)
$g.DrawString("[Security] CodeIgniter Session Persistence and Role Segregation", (New-Object System.Drawing.Font('Segoe UI', 13, [System.Drawing.FontStyle]::Bold)), $darkBrush, $sx + 50, $secY + 25)
$g.DrawString("All candidate credentials and sensitive resumes are transmitted over strict TLS 1.3 encryption and isolated from employer consoles.", (New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Regular)), $mutedBrush, (New-Object System.Drawing.RectangleF ($sx + 50), ($secY + 55), ($sw - 100), 50))

$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $navY, $sw, 95))
$g.DrawString("Home", $navFont, $mutedBrush, $sx + 45, $navY + 35)
$g.DrawString("Jobs", $navFont, $mutedBrush, $sx + 260, $navY + 35)
$g.DrawString("Candidate", $navFont, $cyanBrush, $sx + 475, $navY + 35)
$g.DrawString("Employer", $navFont, $mutedBrush, $sx + 690, $navY + 35)

$f3.Bitmap.Save("F:\phasetwo\store_assets\screenshots\03_candidate_portal.png", [System.Drawing.Imaging.ImageFormat]::Png)
$f3.Graphics.Dispose()
$f3.Bitmap.Dispose()

# SCREEN 4
Write-Host "Creating Screenshot 4..."
$f4 = Create-BasePhoneFrame "Employer and Recruiter Hub" "Direct Job Posting and Access to Pre-Vetted Talent"
$g = $f4.Graphics
$sx = $f4.ScreenX
$sy = $f4.ScreenY
$sw = $f4.ScreenW

$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $sy, $sw, 80))
$g.DrawString("Employer Hub", $headTitleFont, $darkBrush, $sx + 30, $sy + 18)

$eHeroY = $sy + 95
$eHeroH = 190
$eHeroRect = New-Object System.Drawing.Rectangle ($sx + 30), $eHeroY, ($sw - 60), $eHeroH
$eHeroBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $eHeroRect, ([System.Drawing.Color]::FromArgb(15, 43, 70)), ([System.Drawing.Color]::FromArgb(30, 41, 59)), 45
$g.FillRectangle($eHeroBrush, $eHeroRect)
$g.DrawString("Hire Experienced Canadian Talent", (New-Object System.Drawing.Font('Segoe UI', 22, [System.Drawing.FontStyle]::Bold)), $whiteBrush, $sx + 60, $eHeroY + 30)
$g.DrawString("Connect with top-tier executives, fractional leaders, and specialized advisors across Ontario, BC, Quebec, Alberta and Canada.", $cSubFont, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(226, 232, 240))), (New-Object System.Drawing.RectangleF ($sx + 60), ($eHeroY + 80), ($sw - 120), 80))

$postY = $eHeroY + $eHeroH + 35
$g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 252, 231))), (New-Object System.Drawing.Rectangle ($sx + 30), $postY, ($sw - 60), 125))
$g.DrawString("[+] Post an Executive Job or Gig", (New-Object System.Drawing.Font('Segoe UI', 17, [System.Drawing.FontStyle]::Bold)), (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(21, 128, 61))), $sx + 50, $postY + 28)
$g.DrawString("Reach over 10,000+ experienced senior leaders in Canada.", $cSubFont, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(22, 101, 52))), $sx + 50, $postY + 70)

$cSecY = $postY + 155
$g.DrawString("ORGANIZATION MANAGEMENT", $secFont, $darkBrush, $sx + 30, $cSecY)
$eCards = @(
    @{ Title = "Employer Dashboard"; Sub = "View active postings, applicant pipelines and views" },
    @{ Title = "Talent Shortlists"; Sub = "Review vetted senior candidates and send interview requests" },
    @{ Title = "Plans and Subscriptions"; Sub = "Starter, Professional, and Enterprise hiring packages" }
)
$ecY = $cSecY + 40
foreach ($ec in $eCards) {
    $g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 30), $ecY, ($sw - 60), 105))
    $g.DrawString("[*] $($ec.Title)", (New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Bold)), $darkBrush, $sx + 50, $ecY + 22)
    $g.DrawString($ec.Sub, $cSubFont, $mutedBrush, $sx + 50, $ecY + 58)
    $ecY += 125
}

$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $navY, $sw, 95))
$g.DrawString("Home", $navFont, $mutedBrush, $sx + 45, $navY + 35)
$g.DrawString("Jobs", $navFont, $mutedBrush, $sx + 260, $navY + 35)
$g.DrawString("Candidate", $navFont, $mutedBrush, $sx + 475, $navY + 35)
$g.DrawString("Employer", $navFont, $cyanBrush, $sx + 690, $navY + 35)

$f4.Bitmap.Save("F:\phasetwo\store_assets\screenshots\04_employer_console.png", [System.Drawing.Imaging.ImageFormat]::Png)
$f4.Graphics.Dispose()
$f4.Bitmap.Dispose()

# SCREEN 5
Write-Host "Creating Screenshot 5..."
$f5 = Create-BasePhoneFrame "Store Compliance and Privacy" "Transparent Data Governance and Account Deletion"
$g = $f5.Graphics
$sx = $f5.ScreenX
$sy = $f5.ScreenY
$sw = $f5.ScreenW

$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $sy, $sw, 80))
$g.DrawString("Privacy and Compliance", $headTitleFont, $darkBrush, $sx + 30, $sy + 18)

$pCardY = $sy + 95
$g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 30), $pCardY, ($sw - 60), 160))
$g.DrawString("[Compliance] Apple and Google Play Store Standards", (New-Object System.Drawing.Font('Segoe UI', 17, [System.Drawing.FontStyle]::Bold)), $darkBrush, $sx + 50, $pCardY + 25)
$g.DrawString("PhaseTwo strictly adheres to Apple Review Guideline 5.1.1(v) and Google Play User Data policies, ensuring full user sovereignty over accounts and personal data.", $cSubFont, $mutedBrush, (New-Object System.Drawing.RectangleF ($sx + 50), ($pCardY + 65), ($sw - 100), 80))

$modalY = $pCardY + 190
$modalH = 430
$modalRect = New-Object System.Drawing.Rectangle ($sx + 50), $modalY, ($sw - 100), $modalH
$g.FillRectangle($whiteBrush, $modalRect)
$g.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226, 232, 240), 2)), $modalRect)

$g.DrawString("Account and Data Deletion", (New-Object System.Drawing.Font('Segoe UI', 18, [System.Drawing.FontStyle]::Bold)), (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(239, 68, 68))), $sx + 80, $modalY + 30)
$g.DrawString("Under PhaseTwo data privacy governance, you can permanently request deletion of:", $cSubFont, $darkBrush, $sx + 80, $modalY + 80)

$delItems = @(
    "- Candidate profile, resume and application history",
    "- Employer profile and active/archived job postings",
    "- Account credentials and authentication records"
)
$diY = $modalY + 125
foreach ($di in $delItems) {
    $g.DrawString($di, $cSubFont, $mutedBrush, $sx + 80, $diY)
    $diY += 35
}

$g.DrawString("Requests are verified and permanently purged within 30 days.", (New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Italic)), $mutedBrush, $sx + 80, $modalY + 265)

$delBtnRect = New-Object System.Drawing.Rectangle ($sx + 80), ($modalY + 320), 280, 60
$g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(239, 68, 68))), $delBtnRect)
$g.DrawString("Request Deletion", (New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)), $whiteBrush, $sx + 145, $modalY + 338)

$privBtnRect = New-Object System.Drawing.Rectangle ($sx + 380), ($modalY + 320), 280, 60
$g.FillRectangle($cardBg, $privBtnRect)
$g.DrawString("Privacy Policy", (New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)), $darkBrush, $sx + 455, $modalY + 338)

$ctY = $modalY + $modalH + 40
$g.FillRectangle($cardBg, (New-Object System.Drawing.Rectangle ($sx + 30), $ctY, ($sw - 60), 120))
$g.DrawString("Dedicated Privacy Contact: info@phasetwo.ca", (New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)), $darkBrush, $sx + 50, $ctY + 25)
$g.DrawString("Live Privacy Policy: https://www.phasetwo.ca/privacy_policy`nWeb Contact Form: https://www.phasetwo.ca/contact", (New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Regular)), $mutedBrush, $sx + 50, $ctY + 58)

$g.FillRectangle($headerBrush, (New-Object System.Drawing.Rectangle $sx, $navY, $sw, 95))
$g.DrawString("Home", $navFont, $cyanBrush, $sx + 45, $navY + 35)
$g.DrawString("Jobs", $navFont, $mutedBrush, $sx + 260, $navY + 35)
$g.DrawString("Candidate", $navFont, $mutedBrush, $sx + 475, $navY + 35)
$g.DrawString("Employer", $navFont, $mutedBrush, $sx + 690, $navY + 35)

$f5.Bitmap.Save("F:\phasetwo\store_assets\screenshots\05_privacy_account_deletion.png", [System.Drawing.Imaging.ImageFormat]::Png)
$f5.Graphics.Dispose()
$f5.Bitmap.Dispose()

Write-Host "All 5 PhaseTwo store screenshots generated successfully in F:\phasetwo\store_assets\screenshots\"

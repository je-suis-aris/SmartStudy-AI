<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartStudy AI — Create Account</title>

    <link href="https://fonts.googleapis.com/css2?family=Geist:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg: #f7f8fa;
            --surface: #ffffff;
            --surface-soft: #f3f4f6;
            --ink: #111827;
            --ink-2: #374151;
            --ink-3: #6b7280;
            --ink-4: #9ca3af;
            --rule: #e5e7eb;
            --primary: #1f3a5f;
            --primary-dark: #10243d;
            --primary-soft: #eef3f9;
            --green: #1f5e46;
            --green-bg: #eef7f1;
            --red: #991b1b;
            --red-bg: #fef2f2;
            --amber: #b7791f;
            --radius: 18px;
            --shadow: 0 12px 35px rgba(15, 23, 42, 0.08);
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Geist', Arial, sans-serif;
            background: var(--bg);
            color: var(--ink);
            font-size: 15px;
            line-height: 1.6;
            min-height: 100vh;
        }

        a {
            text-decoration: none;
        }

        .nav {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
            height: 66px;
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(14px);
            border-bottom: 1px solid var(--rule);
            display: flex;
            align-items: center;
            padding: 0 32px;
        }

        .nav-inner {
            width: 100%;
            display: flex;
            align-items: center;
            gap: 28px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--ink);
            font-size: 1.12rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            margin-right: auto;
            text-decoration: none;
            white-space: nowrap;
        }

        .brand-logo {
            width: 42px;
            height: 42px;
            min-width: 42px;
            max-width: 42px;
            object-fit: contain;
            display: block;
            background: transparent;
            border: none;
            box-shadow: none;
            padding: 0;
            border-radius: 0;
        }

        .brand-text span {
            color: var(--primary);
        }

        .nav-link {
            color: var(--ink-3);
            font-size: 0.84rem;
            font-weight: 500;
            padding: 8px 14px;
            border-radius: 9px;
            transition: 0.2s;
        }

        .nav-link:hover {
            color: var(--ink);
            background: var(--surface-soft);
        }

        .nav-cta {
            background: var(--ink);
            color: white;
            font-size: 0.84rem;
            font-weight: 600;
            padding: 9px 16px;
            border-radius: 10px;
            transition: 0.2s;
            margin-left: 8px;
        }

        .nav-cta:hover {
            background: var(--primary);
        }

        .auth-page {
            min-height: calc(100vh - 66px);
            display: grid;
            grid-template-columns: 1fr 1fr;
            padding-top: 66px;
        }

        .auth-left {
            background: var(--primary-dark);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 56px 56px;
            position: relative;
            overflow: hidden;
        }

        .auth-left::before {
            content: "";
            position: absolute;
            top: -120px;
            right: -120px;
            width: 420px;
            height: 420px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.03);
            pointer-events: none;
        }

        .auth-left::after {
            content: "";
            position: absolute;
            bottom: -80px;
            left: -80px;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.025);
            pointer-events: none;
        }

        .auth-left-inner {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 760px;
        }

        .auth-eyebrow {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.45);
            margin-bottom: 20px;
        }

        .auth-left h1 {
            font-size: clamp(2.25rem, 3.8vw, 3.25rem);
            line-height: 1.1;
            letter-spacing: -0.045em;
            color: #ffffff;
            font-weight: 700;
            margin-bottom: 18px;
        }

        .auth-left p {
            color: rgba(255, 255, 255, 0.68);
            font-size: 1.04rem;
            line-height: 1.85;
            max-width: 500px;
            margin-bottom: 40px;
        }

        .feature-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .feature-item {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            background: rgba(255, 255, 255, 0.045);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 20px 22px;
        }

        .feature-item-marker {
            width: 32px;
            height: 32px;
            min-width: 32px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.10);
            border: 1px solid rgba(255, 255, 255, 0.12);
            color: rgba(255, 255, 255, 0.88);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.82rem;
            font-weight: 700;
        }

        .feature-item-text h4 {
            font-size: 1rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 5px;
            letter-spacing: -0.01em;
        }

        .feature-item-text p {
            font-size: 0.88rem;
            color: rgba(255, 255, 255, 0.62);
            line-height: 1.65;
            margin: 0;
        }

        .testi-block {
            margin-top: 34px;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            padding-top: 26px;
            display: flex;
            justify-content: center;
        }

        .testi-slider {
            position: relative;
            width: 100%;
            max-width: 560px;
            min-height: 190px;
        }

        .testi-item {
            position: absolute;
            inset: 0;
            opacity: 0;
            transform: translateY(10px);
            transition: opacity 0.7s ease, transform 0.7s ease;
            pointer-events: none;
            text-align: center;
        }

        .testi-item.active {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }

        .testi-stars {
            color: #fbbf24;
            font-size: 0.82rem;
            letter-spacing: 2px;
            margin-bottom: 14px;
        }

        .testi-quote {
            font-size: 1rem;
            color: rgba(255, 255, 255, 0.78);
            line-height: 1.85;
            font-style: italic;
            margin-bottom: 22px;
            max-width: 520px;
            margin-left: auto;
            margin-right: auto;
        }

        .testi-author {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .testi-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.12);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.85);
        }

        .testi-name {
            font-size: 0.9rem;
            font-weight: 600;
            color: #ffffff;
        }

        .testi-role {
            font-size: 0.78rem;
            color: rgba(255, 255, 255, 0.5);
            margin-top: 2px;
        }

        .auth-right {
            background: var(--surface);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 56px 48px;
        }

        .auth-form-wrap {
            width: 100%;
            max-width: 460px;
        }

        .form-header {
            margin-bottom: 18px;
        }

        .form-header h2 {
            font-size: 1.75rem;
            font-weight: 700;
            letter-spacing: -0.04em;
            color: var(--ink);
            margin-bottom: 6px;
        }

        .form-header p {
            font-size: 0.875rem;
            color: var(--ink-3);
        }

        .form-header p a {
            color: var(--primary);
            font-weight: 500;
        }

        .form-header p a:hover {
            text-decoration: underline;
        }

        .account-info-box {
            background: var(--primary-soft);
            color: var(--primary-dark);
            border: 1px solid #dbe7f4;
            border-radius: 12px;
            padding: 11px 14px;
            font-size: 0.82rem;
            margin-bottom: 18px;
            line-height: 1.5;
        }

        .alert-error {
            background: var(--red-bg);
            border: 1px solid #fecaca;
            color: var(--red);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .field-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .field {
            margin-bottom: 16px;
        }

        .field-label {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--ink-2);
            margin-bottom: 6px;
        }

        .field-label span {
            font-weight: 400;
            color: var(--ink-4);
        }

        .field-input {
            width: 100%;
            background: var(--bg);
            border: 1.5px solid var(--rule);
            color: var(--ink);
            font-family: 'Geist', Arial, sans-serif;
            font-size: 0.9rem;
            padding: 11px 14px;
            border-radius: 11px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            -webkit-appearance: none;
        }

        .field-input::placeholder {
            color: var(--ink-4);
        }

        .field-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-soft);
            background: #ffffff;
        }

        textarea.field-input {
            resize: vertical;
            min-height: 88px;
        }

        .strength-wrap {
            margin-top: 7px;
        }

        .strength-bar {
            display: flex;
            gap: 4px;
            margin-bottom: 5px;
        }

        .strength-seg {
            flex: 1;
            height: 3px;
            border-radius: 99px;
            background: var(--rule);
            transition: background 0.3s;
        }

        .strength-label {
            font-size: 0.72rem;
            color: var(--ink-4);
        }

        .password-match-label {
            font-size: 0.72rem;
            margin-top: 6px;
            min-height: 16px;
        }

        .admin-request-box {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            background: var(--primary-soft);
            border: 1px solid #dbe7f4;
            border-radius: 12px;
            padding: 13px 14px;
            cursor: pointer;
            color: var(--primary-dark);
            font-size: 0.86rem;
            font-weight: 600;
        }

        .admin-request-box input {
            margin-top: 3px;
            accent-color: var(--primary);
        }

        .admin-request-help {
            margin-top: 7px;
            color: var(--ink-4);
            font-size: 0.76rem;
            line-height: 1.45;
        }

        .btn-submit {
            width: 100%;
            background: var(--primary);
            color: #ffffff;
            font-family: 'Geist', Arial, sans-serif;
            font-size: 0.94rem;
            font-weight: 600;
            padding: 13px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: 0.2s;
            margin-top: 4px;
        }

        .btn-submit:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-submit:active {
            transform: none;
        }

        .btn-submit:disabled {
            opacity: 0.65;
            cursor: not-allowed;
            transform: none;
        }

        .terms-note {
            font-size: 0.75rem;
            color: var(--ink-4);
            text-align: center;
            margin-top: 14px;
            line-height: 1.6;
        }

        .terms-note a {
            color: var(--ink-3);
        }

        .terms-note a:hover {
            color: var(--primary);
        }

        @media (max-width: 900px) {
            .auth-page {
                grid-template-columns: 1fr;
            }

            .auth-left {
                padding: 48px 32px;
                min-height: auto;
            }

            .auth-right {
                padding: 40px 24px;
            }

            .testi-slider {
                min-height: 230px;
            }
        }

        @media (max-width: 540px) {
            .field-row {
                grid-template-columns: 1fr;
            }

            .nav {
                padding: 0 20px;
            }

            .testi-slider {
                min-height: 270px;
            }

            .testi-quote {
                font-size: 0.95rem;
            }
        }
    </style>
</head>

<body>
<%
    String ctx = request.getContextPath();
%>

<nav class="nav">
    <div class="nav-inner">
        <a href="<%=ctx%>/home" class="brand">
            <img src="<%=ctx%>/assets/img/Logo.png?v=100" alt="SmartStudy AI" class="brand-logo">
            <span class="brand-text">SmartStudy <span>AI</span></span>
        </a>

        <a href="<%=ctx%>/login" class="nav-link">Sign in</a>
        <a href="<%=ctx%>/register" class="nav-cta">Create account</a>
    </div>
</nav>

<div class="auth-page">

    <section class="auth-left">
        <div class="auth-left-inner">

            <div class="auth-eyebrow">AI-assisted learning platform</div>

            <h1>Start learning smarter today.</h1>

            <p>
                Upload your course materials, get adaptive quizzes, detect your knowledge gaps,
                and follow a personalized study plan built around your exam date.
            </p>

            <div class="feature-list">

                <div class="feature-item">
                    <div class="feature-item-marker">01</div>
                    <div class="feature-item-text">
                        <h4>AI study planning</h4>
                        <p>Generate a clear revision plan based on your exam date, available time and current level.</p>
                    </div>
                </div>

                <div class="feature-item">
                    <div class="feature-item-marker">02</div>
                    <div class="feature-item-text">
                        <h4>Quizzes and flashcards</h4>
                        <p>Create practice questions and flashcards directly from uploaded course materials.</p>
                    </div>
                </div>

                <div class="feature-item">
                    <div class="feature-item-marker">03</div>
                    <div class="feature-item-text">
                        <h4>Knowledge gap detection</h4>
                        <p>Identify weak topics and receive focused recommendations before the exam.</p>
                    </div>
                </div>

            </div>

            <div class="testi-block">
                <div class="testi-slider" id="testiSlider">

                    <div class="testi-item active">
                        <div class="testi-stars">★★★★★</div>
                        <p class="testi-quote">
                            I passed my Web Programming exam on the first try.
                            SmartStudy detected I was weak on Servlets a week before the exam.
                        </p>
                        <div class="testi-author">
                            <div class="testi-avatar">SA</div>
                            <div>
                                <div class="testi-name">Sara A.</div>
                                <div class="testi-role">3rd Year Computer Science</div>
                            </div>
                        </div>
                    </div>

                    <div class="testi-item">
                        <div class="testi-stars">★★★★★</div>
                        <p class="testi-quote">
                            The generated quizzes helped me revise faster and focus only on the chapters
                            where I was losing points.
                        </p>
                        <div class="testi-author">
                            <div class="testi-avatar">TM</div>
                            <div>
                                <div class="testi-name">Thomas M.</div>
                                <div class="testi-role">2nd Year Software Engineering</div>
                            </div>
                        </div>
                    </div>

                    <div class="testi-item">
                        <div class="testi-stars">★★★★★</div>
                        <p class="testi-quote">
                            The personalized study plan made my revision process more structured
                            and much less stressful.
                        </p>
                        <div class="testi-author">
                            <div class="testi-avatar">LK</div>
                            <div>
                                <div class="testi-name">Lena K.</div>
                                <div class="testi-role">1st Year Information Technology</div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </section>

    <section class="auth-right">
        <div class="auth-form-wrap">

            <div class="form-header">
                <h2>Create your account</h2>
                <p>Already registered? <a href="<%=ctx%>/login">Sign in →</a></p>
            </div>

            <div class="account-info-box">
                All new accounts are created as student accounts. Administrator access can be requested
                during registration and must be approved by an existing administrator.
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-error">
                    ⚠ <%=request.getAttribute("error")%>
                </div>
            <% } %>

            <form method="post" action="<%=ctx%>/register" onsubmit="return validateRegisterForm();">

                <div class="field-row">
                    <div class="field">
                        <label class="field-label" for="firstName">First name</label>
                        <input id="firstName" name="firstName" class="field-input" type="text" placeholder="John" required>
                    </div>

                    <div class="field">
                        <label class="field-label" for="lastName">Last name</label>
                        <input id="lastName" name="lastName" class="field-input" type="text" placeholder="Doe" required>
                    </div>
                </div>

                <div class="field">
                    <label class="field-label" for="email">Email address</label>
                    <input id="email" name="email" class="field-input" type="email" placeholder="john.doe@university.edu" required>
                </div>

                <div class="field">
                    <label class="field-label" for="password">Password</label>
                    <input
                            id="password"
                            name="password"
                            class="field-input"
                            type="password"
                            placeholder="8+ characters"
                            minlength="8"
                            required
                            oninput="checkStrength(this.value); checkPasswordMatch();"
                    >

                    <div class="strength-wrap">
                        <div class="strength-bar">
                            <div class="strength-seg" id="s1"></div>
                            <div class="strength-seg" id="s2"></div>
                            <div class="strength-seg" id="s3"></div>
                            <div class="strength-seg" id="s4"></div>
                        </div>
                        <div class="strength-label" id="strengthLabel"></div>
                    </div>
                </div>

                <div class="field">
                    <label class="field-label" for="confirmPassword">Confirm password</label>
                    <input
                            id="confirmPassword"
                            name="confirmPassword"
                            class="field-input"
                            type="password"
                            placeholder="Repeat password"
                            minlength="8"
                            required
                            oninput="checkPasswordMatch();"
                    >
                    <div class="password-match-label" id="passwordMatchLabel"></div>
                </div>

                <div class="field">
                    <label class="field-label" for="bio">
                        Bio <span>(optional)</span>
                    </label>
                    <textarea id="bio" name="bio" class="field-input" placeholder="e.g. 3rd year Computer Science student, preparing for Web Programming II..."></textarea>
                </div>

                <div class="field">
                    <label class="field-label">
                        Administrator access <span>(optional)</span>
                    </label>

                    <label class="admin-request-box">
                        <input type="checkbox" name="requestAdmin" value="yes" onchange="toggleAdminReason(this)">
                        <span>I want to request administrator access</span>
                    </label>

                    <div class="admin-request-help">
                        New accounts are created as students by default. Administrator access must be approved by an existing admin.
                    </div>
                </div>

                <div class="field" id="adminReasonField" style="display:none;">
                    <label class="field-label" for="adminReason">
                        Reason for admin access <span>(required if requesting admin access)</span>
                    </label>

                    <textarea
                            id="adminReason"
                            name="adminReason"
                            class="field-input"
                            placeholder="Explain why you need administrator access..."
                    ></textarea>
                </div>

                <button type="submit" class="btn-submit" id="submitBtn">Create account →</button>

                <p class="terms-note">
                    By creating an account you agree to our
                    <a href="#">Terms of Service</a> and
                    <a href="#">Privacy Policy</a>.
                </p>

            </form>

        </div>
    </section>

</div>

<script>
function checkStrength(val) {
    const segs = ['s1', 's2', 's3', 's4'].map(id => document.getElementById(id));
    const label = document.getElementById('strengthLabel');
    const colors = ['#ef4444', '#f59e0b', '#3b82f6', '#22c55e'];
    const labels = ['Weak', 'Fair', 'Good', 'Strong'];
    let score = 0;

    if (val.length >= 8) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    segs.forEach((s, i) => {
        s.style.background = i < score ? colors[Math.min(score - 1, 3)] : 'var(--rule)';
    });

    label.textContent = val.length > 0 ? (labels[Math.min(score - 1, 3)] || '') : '';
    label.style.color = score > 0 ? colors[Math.min(score - 1, 3)] : '';
}

function checkPasswordMatch() {
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    const label = document.getElementById('passwordMatchLabel');
    const submitBtn = document.getElementById('submitBtn');

    if (!password || !confirmPassword || !label || !submitBtn) {
        return true;
    }

    if (confirmPassword.value.length === 0) {
        label.textContent = '';
        submitBtn.disabled = false;
        return true;
    }

    if (password.value === confirmPassword.value) {
        label.textContent = 'Passwords match.';
        label.style.color = '#1f5e46';
        submitBtn.disabled = false;
        return true;
    }

    label.textContent = 'Passwords do not match.';
    label.style.color = '#991b1b';
    submitBtn.disabled = true;
    return false;
}

function toggleAdminReason(checkbox) {
    const field = document.getElementById('adminReasonField');
    const textarea = document.getElementById('adminReason');

    if (!field || !textarea) {
        return;
    }

    if (checkbox.checked) {
        field.style.display = 'block';
        textarea.required = true;
    } else {
        field.style.display = 'none';
        textarea.required = false;
        textarea.value = '';
    }
}

function validateRegisterForm() {
    const passwordsMatch = checkPasswordMatch();

    if (!passwordsMatch) {
        alert('Passwords do not match.');
        return false;
    }

    const requestAdmin = document.querySelector('input[name="requestAdmin"]');
    const adminReason = document.getElementById('adminReason');

    if (requestAdmin && requestAdmin.checked) {
        if (!adminReason || adminReason.value.trim().length < 5) {
            alert('Please explain why you need administrator access.');
            return false;
        }
    }

    return true;
}

document.addEventListener("DOMContentLoaded", function () {
    const items = document.querySelectorAll("#testiSlider .testi-item");
    let current = 0;

    if (items.length > 1) {
        setInterval(function () {
            items[current].classList.remove("active");
            current = (current + 1) % items.length;
            items[current].classList.add("active");
        }, 4000);
    }
});
</script>

</body>
</html>
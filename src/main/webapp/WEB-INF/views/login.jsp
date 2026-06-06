<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartStudy AI — Sign In</title>

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
            min-height: 100vh;
            display: grid;
            grid-template-columns: 1fr 1fr;
            padding-top: 66px;
            background: var(--surface);
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

        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
            margin-bottom: 34px;
        }

        .stat-item {
            background: rgba(255, 255, 255, 0.045);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 18px 20px;
            text-align: center;
        }

        .stat-value {
            font-size: 1.55rem;
            font-weight: 700;
            letter-spacing: -0.04em;
            color: #ffffff;
        }

        .stat-label {
            font-size: 0.76rem;
            color: rgba(255, 255, 255, 0.5);
            margin-top: 4px;
        }

        .testi-block {
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
            margin-bottom: 28px;
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

        .alert-success {
            background: var(--green-bg);
            border: 1px solid #bbf7d0;
            color: var(--green);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
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

        .field-label a {
            font-weight: 400;
            color: var(--ink-3);
            font-size: 0.78rem;
            transition: 0.2s;
        }

        .field-label a:hover {
            color: var(--primary);
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

        .password-wrap {
            position: relative;
        }

        .password-wrap .field-input {
            padding-right: 74px;
        }

        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: var(--primary);
            font-size: 0.78rem;
            font-weight: 700;
            cursor: pointer;
            padding: 4px 6px;
            border-radius: 8px;
        }

        .password-toggle:hover {
            background: var(--primary-soft);
        }

        .login-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin: -4px 0 18px;
        }

        .remember-box {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--ink-3);
            font-size: 0.82rem;
            cursor: pointer;
            user-select: none;
        }

        .remember-box input {
            accent-color: var(--primary);
        }

        .login-options a {
            color: var(--ink-3);
            font-size: 0.78rem;
            transition: 0.2s;
        }

        .login-options a:hover {
            color: var(--primary);
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

            .stats-row {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 540px) {
            .nav {
                padding: 0 20px;
            }

            .stats-row {
                grid-template-columns: 1fr;
            }

            .testi-slider {
                min-height: 270px;
            }

            .testi-quote {
                font-size: 0.95rem;
            }

            .login-options {
                align-items: flex-start;
                flex-direction: column;
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

            <h1>Welcome back. Your study plan is waiting.</h1>

            <p>
                Pick up right where you left off — your revision tasks, quizzes,
                flashcards and knowledge gap alerts are ready for you.
            </p>

            <div class="stats-row">
                <div class="stat-item">
                    <div class="stat-value">24/7</div>
                    <div class="stat-label">Personalized study support</div>
                </div>

                <div class="stat-item">
                    <div class="stat-value">AI</div>
                    <div class="stat-label">Question generation from your materials</div>
                </div>

                <div class="stat-item">
                    <div class="stat-value">100%</div>
                    <div class="stat-label">Student-focused learning path</div>
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
                <h2>Sign in to your account</h2>
                <p>Don't have an account? <a href="<%=ctx%>/register">Create one →</a></p>
            </div>

            <% if ("1".equals(request.getParameter("registered"))) { %>
                <div class="alert-success">
                    ✅ Account created successfully. You can now sign in.
                </div>
            <% } %>
            
            <% if ("1".equals(request.getParameter("logout"))) { %>
    <div class="alert-success">
        ✅ You have been signed out successfully.
    </div>
<% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-error">
                    ⚠ <%=request.getAttribute("error")%>
                </div>
            <% } %>

            <form method="post" action="<%=ctx%>/login">

                <div class="field">
                    <label class="field-label" for="email">Email address</label>
                    <input id="email" name="email" class="field-input" type="email"
                           placeholder="john.doe@university.edu" required>
                </div>

                <div class="field">
                    <label class="field-label" for="password">Password</label>

                    <div class="password-wrap">
                        <input id="password" name="password" class="field-input" type="password"
                               placeholder="••••••••" required>
                        <button type="button" class="password-toggle" onclick="togglePassword()">Show</button>
                    </div>
                </div>

                <div class="login-options">
                    <label class="remember-box">
                        <input type="checkbox" name="rememberMe" value="yes">
                        <span>Remember me</span>
                    </label>

                    <a href="<%=ctx%>/forgot-password">Forgot password?</a>
                </div>

                <button type="submit" class="btn-submit">Sign in →</button>

                <p class="terms-note">
                    Protected by SmartStudy AI ·
                    <a href="#">Terms</a> ·
                    <a href="#">Privacy</a>
                </p>

            </form>

        </div>
    </section>

</div>

<script>
    function togglePassword() {
        const input = document.getElementById('password');
        const btn = document.querySelector('.password-toggle');

        if (!input || !btn) {
            return;
        }

        if (input.type === 'password') {
            input.type = 'text';
            btn.textContent = 'Hide';
        } else {
            input.type = 'password';
            btn.textContent = 'Show';
        }
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
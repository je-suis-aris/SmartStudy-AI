<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Forgot Password</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

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
            --shadow: 0 12px 35px rgba(15, 23, 42, 0.08);
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
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
            object-fit: contain;
            display: block;
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
            max-width: 520px;
            margin-bottom: 40px;
        }

        .steps-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin-bottom: 34px;
        }

        .step-item {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            background: rgba(255, 255, 255, 0.045);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 20px 22px;
        }

        .step-marker {
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

        .step-text h4 {
            font-size: 1rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 5px;
        }

        .step-text p {
            font-size: 0.88rem;
            color: rgba(255, 255, 255, 0.62);
            line-height: 1.65;
            margin: 0;
        }

        .security-note {
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            padding-top: 26px;
            color: rgba(255, 255, 255, 0.68);
            font-size: 0.95rem;
            line-height: 1.75;
            max-width: 560px;
        }

        .security-note strong {
            color: white;
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
            margin-bottom: 24px;
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

        .info-box {
            background: var(--primary-soft);
            color: var(--primary-dark);
            border: 1px solid #dbe7f4;
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.85rem;
            line-height: 1.55;
            margin-bottom: 20px;
        }

        .error {
            background: var(--red-bg);
            border: 1px solid #fecaca;
            color: var(--red);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.85rem;
            margin-bottom: 20px;
        }

        .message {
            background: var(--green-bg);
            border: 1px solid #bbf7d0;
            color: var(--green);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.85rem;
            margin-bottom: 20px;
        }

        .field {
            margin-bottom: 16px;
        }

        .field-label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--ink-2);
            margin-bottom: 6px;
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
        }

        .field-input::placeholder {
            color: var(--ink-4);
        }

        .field-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-soft);
            background: #ffffff;
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

        .back-link {
            display: block;
            text-align: center;
            margin-top: 16px;
            color: var(--primary);
            font-weight: 600;
            font-size: 0.9rem;
        }

        .back-link:hover {
            text-decoration: underline;
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
            }

            .auth-right {
                padding: 40px 24px;
            }
        }

        @media (max-width: 540px) {
            .nav {
                padding: 0 20px;
            }

            .nav-link {
                display: none;
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

            <div class="auth-eyebrow">Account recovery</div>

            <h1>Recover your access and continue learning.</h1>

            <p>
                Enter the email linked to your SmartStudy AI account. If the account exists,
                SmartStudy AI will generate a new password and send it to your inbox.
            </p>

            <div class="steps-list">

                <div class="step-item">
                    <div class="step-marker">01</div>
                    <div class="step-text">
                        <h4>Submit your email</h4>
                        <p>Use the same email address you used when creating your SmartStudy AI account.</p>
                    </div>
                </div>

                <div class="step-item">
                    <div class="step-marker">02</div>
                    <div class="step-text">
                        <h4>New password generated</h4>
                        <p>If the account exists, the system generates a new password, updates your account and sends it by email.</p>
                    </div>
                </div>

                <div class="step-item">
                    <div class="step-marker">03</div>
                    <div class="step-text">
                        <h4>Sign in again</h4>
                        <p>Use the new password from the email to access your SmartStudy AI dashboard.</p>
                    </div>
                </div>

            </div>

            <div class="security-note">
                <strong>Security note:</strong> for privacy, SmartStudy AI does not reveal whether an email
                exists in the system. This protects student accounts from being identified by others.
            </div>

        </div>
    </section>

    <section class="auth-right">
        <div class="auth-form-wrap">

            <div class="form-header">
                <h2>Forgot password?</h2>
                <p>Remembered your password? <a href="<%=ctx%>/login">Sign in →</a></p>
            </div>

            <div class="info-box">
                Enter your email address. If this account exists, SmartStudy AI will generate a new password and send it to your inbox.
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error">
                    ⚠ <%=request.getAttribute("error")%>
                </div>
            <% } %>

            <% if (request.getAttribute("message") != null) { %>
                <div class="message">
                    ✅ <%=request.getAttribute("message")%>
                </div>
            <% } %>

            <form method="post" action="<%=ctx%>/forgot-password">

                <div class="field">
                    <label class="field-label" for="email">Email address</label>
                    <input
                            id="email"
                            name="email"
                            class="field-input"
                            type="email"
                            placeholder="john.doe@university.edu"
                            required
                    >
                </div>

                <button type="submit" class="btn-submit">Generate new password →</button>

                <a href="<%=ctx%>/login" class="back-link">Back to sign in</a>

                <p class="terms-note">
                    Protected by SmartStudy AI ·
                    <a href="#">Terms</a> ·
                    <a href="#">Privacy</a>
                </p>

            </form>

        </div>
    </section>

</div>

</body>
</html>
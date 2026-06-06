<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.smartstudy.model.User" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://fonts.googleapis.com/css2?family=Geist:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

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
            --amber: #92400e;
            --amber-bg: #fffbeb;
            --shadow: 0 12px 35px rgba(15, 23, 42, 0.08);
            --shadow-strong: 0 18px 45px rgba(15, 23, 42, 0.14);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Geist', Arial, sans-serif;
            background:
                    radial-gradient(circle at top left, rgba(31, 58, 95, 0.07), transparent 32rem),
                    radial-gradient(circle at top right, rgba(59, 130, 246, 0.06), transparent 30rem),
                    var(--bg);
            color: var(--ink);
            min-height: 100vh;
            font-size: 15px;
            line-height: 1.6;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        button,
        input,
        textarea,
        select {
            font-family: 'Geist', Arial, sans-serif;
        }

        .page {
            min-height: 100vh;
            padding-top: 68px;
        }

        .nav {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 200;
            height: 68px;
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--rule);
            display: flex;
            align-items: center;
            padding: 0 34px;
        }

        .nav-inner {
            width: 100%;
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.12rem;
            font-weight: 800;
            margin-right: auto;
            color: var(--ink);
            white-space: nowrap;
            letter-spacing: -0.03em;
        }

        .brand-logo {
            width: 42px;
            height: 42px;
            object-fit: contain;
        }

        .brand-text span {
            color: var(--primary);
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 3px;
        }

        .nav-links a {
            color: var(--ink-3);
            font-size: 0.84rem;
            font-weight: 600;
            padding: 8px 11px;
            border-radius: 10px;
            transition: 0.18s ease;
            white-space: nowrap;
        }

        .nav-links a:hover {
            color: var(--ink);
            background: var(--surface-soft);
        }

        .nav-links a.active {
            color: var(--primary);
            background: var(--primary-soft);
            font-weight: 700;
        }

        .admin-view-link {
            background: var(--primary);
            color: white !important;
            font-weight: 800 !important;
        }

        .admin-view-link:hover {
            background: var(--primary-dark) !important;
            color: white !important;
        }

        .nav-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-left: 8px;
            background: var(--primary-dark);
            color: white;
            border: 2px solid var(--rule);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.78rem;
            font-weight: 800;
            overflow: hidden;
            transition: 0.2s ease;
        }

        .nav-avatar:hover {
            border-color: var(--primary);
            transform: translateY(-1px);
        }

        .nav-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .main {
            max-width: 1320px;
            margin: 0 auto;
            padding: 34px 32px 70px;
        }

        .hero {
            background: linear-gradient(135deg, #10243d 0%, #1f3a5f 100%);
            color: white;
            border-radius: 30px;
            padding: 40px;
            margin-bottom: 26px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 330px;
            gap: 32px;
            align-items: center;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.13);
            overflow: hidden;
            position: relative;
        }

        .hero::before {
            content: "";
            position: absolute;
            right: -120px;
            top: -150px;
            width: 390px;
            height: 390px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
        }

        .hero::after {
            content: "";
            position: absolute;
            right: 70px;
            bottom: -130px;
            width: 280px;
            height: 280px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
        }

        .hero-content,
        .hero-panel {
            position: relative;
            z-index: 1;
        }

        .hero-kicker {
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: rgba(255,255,255,0.55);
            margin-bottom: 15px;
        }

        .hero h1 {
            font-size: clamp(2.25rem, 4vw, 3.7rem);
            line-height: 1.02;
            letter-spacing: -0.065em;
            margin-bottom: 16px;
            max-width: 850px;
        }

        .hero p {
            color: rgba(255,255,255,0.72);
            max-width: 780px;
            font-size: 1rem;
            line-height: 1.75;
        }

        .hero-panel {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.14);
            border-radius: 24px;
            padding: 24px;
            backdrop-filter: blur(10px);
        }

        .hero-panel-label {
            color: rgba(255,255,255,0.58);
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 0.11em;
            text-transform: uppercase;
            margin-bottom: 12px;
        }

        .hero-panel-value {
            font-size: 1.45rem;
            font-weight: 800;
            letter-spacing: -0.04em;
            line-height: 1.15;
        }

        .hero-panel-note {
            color: rgba(255,255,255,0.68);
            font-size: 0.86rem;
            margin-top: 8px;
        }

        .alert {
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }

        .alert-success {
            background: var(--green-bg);
            color: var(--green);
            border: 1px solid #bbf7d0;
        }

        .alert-error {
            background: var(--red-bg);
            color: var(--red);
            border: 1px solid #fecaca;
        }

        .profile-layout {
            display: grid;
            grid-template-columns: 360px minmax(0, 1fr);
            gap: 24px;
            align-items: start;
        }

        .profile-side,
        .profile-main {
            display: grid;
            gap: 24px;
            align-content: start;
        }

        .profile-side {
            position: sticky;
            top: 92px;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            padding: 26px;
        }

        .profile-card {
            text-align: center;
        }

        .avatar-wrap {
            width: 132px;
            height: 132px;
            margin: 0 auto 18px;
        }

        .avatar,
        .avatar-fallback {
            width: 132px;
            height: 132px;
            border-radius: 50%;
            border: 5px solid white;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.18);
        }

        .avatar {
            object-fit: cover;
            background: var(--primary-soft);
        }

        .avatar-fallback {
            background: var(--primary-dark);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            font-weight: 800;
        }

        .profile-name {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--ink);
            letter-spacing: -0.035em;
        }

        .profile-email {
            color: var(--ink-3);
            font-size: 0.9rem;
            margin-top: 4px;
            word-break: break-word;
        }

        .profile-role {
            display: inline-flex;
            margin-top: 14px;
            padding: 6px 12px;
            border-radius: 999px;
            background: var(--primary-soft);
            color: var(--primary);
            font-size: 0.78rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .side-info {
            margin-top: 24px;
            display: grid;
            gap: 12px;
            text-align: left;
        }

        .info-row {
            background: var(--surface-soft);
            border: 1px solid var(--rule);
            border-radius: 14px;
            padding: 13px 14px;
        }

        .info-label {
            color: var(--ink-4);
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .info-value {
            margin-top: 4px;
            color: var(--ink-2);
            font-size: 0.9rem;
        }

        .side-actions {
            margin-top: 18px;
            display: grid;
            gap: 10px;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--ink);
            letter-spacing: -0.04em;
        }

        .section-subtitle {
            color: var(--ink-3);
            font-size: 0.92rem;
            margin-top: 5px;
            line-height: 1.7;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-top: 24px;
        }

        .field {
            display: grid;
            gap: 7px;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .label {
            font-size: 0.82rem;
            font-weight: 800;
            color: var(--ink-2);
        }

        .input,
        .textarea,
        .select {
            width: 100%;
            border: 1.5px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 13px;
            padding: 12px 14px;
            font-size: 0.92rem;
            color: var(--ink);
            outline: none;
            transition: 0.2s;
        }

        .textarea {
            min-height: 120px;
            resize: vertical;
            line-height: 1.7;
        }

        .input:focus,
        .textarea:focus,
        .select:focus {
            background: white;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(31, 58, 95, 0.12);
        }

        .file-box {
            border: 1.5px dashed #cbd5e1;
            background: #f8fafc;
            border-radius: 16px;
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .file-icon {
            width: 44px;
            height: 44px;
            border-radius: 14px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            flex-shrink: 0;
        }

        .file-box input {
            width: 100%;
            font-size: 0.88rem;
        }

        .help {
            color: var(--ink-4);
            font-size: 0.78rem;
            line-height: 1.45;
            margin-top: 4px;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            margin-top: 24px;
            border-top: 1px solid var(--rule);
            padding-top: 22px;
        }

        .btn {
            border: none;
            border-radius: 13px;
            padding: 12px 18px;
            font-weight: 800;
            font-size: 0.9rem;
            cursor: pointer;
            transition: 0.2s;
            text-align: center;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: white;
            color: var(--ink-2);
            border: 1px solid var(--rule);
        }

        .btn-secondary:hover {
            border-color: var(--ink-4);
            transform: translateY(-1px);
        }

        .btn-soft {
            background: var(--primary-soft);
            color: var(--primary);
            border: 1px solid #dbe7f4;
        }

        .btn-soft:hover {
            background: #e4edf8;
            transform: translateY(-1px);
        }

        .preference-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .preference-card,
        .snapshot-card,
        .summary-card,
        .tip-card {
            border: 1px solid var(--rule);
            background: #fbfcfe;
            border-radius: 18px;
            padding: 16px;
        }

        .preference-title,
        .summary-title,
        .tip-title {
            font-size: 0.9rem;
            font-weight: 800;
            color: var(--ink);
        }

        .preference-text,
        .summary-text,
        .tip-text {
            color: var(--ink-3);
            font-size: 0.8rem;
            margin-top: 5px;
            line-height: 1.55;
        }

        .snapshot-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
        }

        .snapshot-label {
            color: var(--ink-4);
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .snapshot-value {
            margin-top: 10px;
            color: var(--ink);
            font-size: 1.25rem;
            line-height: 1.05;
            font-weight: 800;
            letter-spacing: -0.05em;
        }

        .snapshot-text {
            margin-top: 7px;
            color: var(--ink-3);
            font-size: 0.78rem;
            line-height: 1.45;
        }

        .summary-grid,
        .tips-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }

        .tips-grid {
            grid-template-columns: repeat(2, 1fr);
        }

        .summary-icon {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            margin-bottom: 12px;
        }

        .ai-profile-coach {
            background: var(--primary-dark);
            border-radius: 26px;
            padding: 28px;
            color: white;
            box-shadow: var(--shadow-strong);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        .ai-profile-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }

        .ai-profile-pulse {
            width: 11px;
            height: 11px;
            border-radius: 50%;
            background: #22c55e;
            box-shadow: 0 0 0 5px rgba(34, 197, 94, 0.18);
            animation: aiPulse 2s infinite;
        }

        @keyframes aiPulse {
            0%, 100% {
                box-shadow: 0 0 0 5px rgba(34, 197, 94, 0.18);
            }

            50% {
                box-shadow: 0 0 0 9px rgba(34, 197, 94, 0.07);
            }
        }

        .ai-profile-title {
            font-size: 1.15rem;
            font-weight: 800;
            letter-spacing: -0.03em;
        }

        .ai-profile-subtitle {
            color: rgba(255, 255, 255, 0.68);
            font-size: 0.9rem;
            line-height: 1.65;
            margin-bottom: 18px;
        }

        .ai-profile-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
            margin-bottom: 16px;
        }

        .ai-profile-question {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.12);
            color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 12px 14px;
            font-size: 0.84rem;
            font-weight: 700;
            cursor: pointer;
            transition: 0.18s ease;
            text-align: left;
        }

        .ai-profile-question:hover {
            background: rgba(255, 255, 255, 0.14);
            color: white;
            transform: translateY(-1px);
        }

        .ai-profile-input-row {
            display: flex;
            gap: 10px;
            margin-top: 12px;
        }

        .ai-profile-input {
            flex: 1;
            min-height: 45px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, 0.14);
            background: rgba(255, 255, 255, 0.08);
            color: white;
            padding: 12px 14px;
            font-size: 0.9rem;
            outline: none;
        }

        .ai-profile-input::placeholder {
            color: rgba(255, 255, 255, 0.42);
        }

        .ai-profile-input:focus {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(255, 255, 255, 0.32);
        }

        .ai-profile-send {
            min-height: 45px;
            border: none;
            border-radius: 14px;
            padding: 12px 18px;
            background: white;
            color: #10243d;
            font-weight: 800;
            cursor: pointer;
            transition: 0.18s ease;
            white-space: nowrap;
        }

        .ai-profile-send:hover {
            background: #eef3f9;
            transform: translateY(-1px);
        }

        .ai-profile-send:disabled {
            opacity: 0.65;
            cursor: not-allowed;
            transform: none;
        }

        .ai-profile-response {
            display: none;
            margin-top: 15px;
            padding: 15px 17px;
            border-radius: 16px;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.88);
            font-size: 0.88rem;
            line-height: 1.75;
            white-space: pre-wrap;
        }

        .ai-profile-note {
            margin-top: 12px;
            color: rgba(255, 255, 255, 0.48);
            font-size: 0.78rem;
        }

        @media (max-width: 1180px) {
            .hero {
                grid-template-columns: 1fr;
            }

            .profile-layout {
                grid-template-columns: 1fr;
            }

            .profile-side {
                position: static;
            }

            .snapshot-grid,
            .summary-grid,
            .preference-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 900px) {
            .nav-links {
                display: none;
            }

            .form-grid,
            .tips-grid,
            .ai-profile-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 700px) {
            .nav {
                padding: 0 20px;
            }

            .main {
                padding: 24px 18px 60px;
            }

            .hero {
                padding: 28px;
                border-radius: 24px;
            }

            .hero h1 {
                font-size: 2.15rem;
            }

            .snapshot-grid,
            .summary-grid,
            .preference-grid {
                grid-template-columns: 1fr;
            }

            .actions,
            .ai-profile-input-row {
                flex-direction: column;
                align-items: stretch;
            }

            .btn,
            .ai-profile-send {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");

    if (currentUser == null) {
        response.sendRedirect(ctx + "/login");
        return;
    }

    String fullName = currentUser.getFullName() == null ? "" : currentUser.getFullName();
    String email = currentUser.getEmail() == null ? "" : currentUser.getEmail();
    String role = currentUser.getRole() == null ? "Student" : currentUser.getRole();
    String description = currentUser.getDescription() == null ? "" : currentUser.getDescription();
    String profilePhoto = currentUser.getProfilePhoto();

    boolean isAdmin = "ADMIN".equalsIgnoreCase(role);

    String preferredStudyRhythm = currentUser.getPreferredStudyRhythm() == null || currentUser.getPreferredStudyRhythm().isBlank()
            ? "Balanced revision"
            : currentUser.getPreferredStudyRhythm();

    String learningStyle = currentUser.getLearningStyle() == null || currentUser.getLearningStyle().isBlank()
            ? "Mixed learning"
            : currentUser.getLearningStyle();

    String initials = "ST";

    if (!fullName.trim().isEmpty()) {
        String[] parts = fullName.trim().split("\\s+");

        if (parts.length >= 2) {
            initials = parts[0].substring(0, 1).toUpperCase() + parts[1].substring(0, 1).toUpperCase();
        } else {
            initials = fullName.substring(0, 1).toUpperCase();
        }
    }

    String rhythmAdvice = "Balanced revision".equals(preferredStudyRhythm)
            ? "Tasks are distributed progressively."
            : "Intensive revision".equals(preferredStudyRhythm)
            ? "The planner can allocate stronger daily blocks."
            : "Light daily revision".equals(preferredStudyRhythm)
            ? "Short sessions are prioritized."
            : "Exam sprint".equals(preferredStudyRhythm)
            ? "The planner can focus on urgent preparation."
            : "Weekend sessions can carry more workload.";

    String styleAdvice = "Quizzes and practice".equals(learningStyle)
            ? "Practice questions should appear frequently."
            : "Flashcards".equals(learningStyle)
            ? "Concept review cards should be prioritized."
            : "Reading summaries".equals(learningStyle)
            ? "Summaries should be used before practice."
            : "Visual explanations".equals(learningStyle)
            ? "Visual explanations and diagrams should be favored."
            : "A mixed path combines summaries, quizzes and flashcards.";
%>

<nav class="nav">
    <div class="nav-inner">
        <a href="<%=ctx%>/home" class="brand">
            <img src="<%=ctx%>/assets/img/Logo.png?v=100" alt="SmartStudy AI" class="brand-logo">
            <span class="brand-text">SmartStudy <span>AI</span></span>
        </a>

        <div class="nav-links">
            <a href="<%=ctx%>/dashboard">Dashboard</a>
            <a href="<%=ctx%>/materials">Materials</a>
            <a href="<%=ctx%>/planner">Planner</a>
            <a href="<%=ctx%>/assessment">Assessment</a>
            <a href="<%=ctx%>/flashcards">Flashcards</a>
            <a href="<%=ctx%>/insights">Insights</a>
            <a href="<%=ctx%>/stats">Stats</a>
            <a href="<%=ctx%>/profile" class="active">Profile</a>
            <a href="<%=ctx%>/chat">Support</a>
            <a href="<%=ctx%>/ai-coach">AI Coach</a>

            <% if (isAdmin) { %>
                <a href="<%=ctx%>/admin/dashboard" class="admin-view-link">Admin view</a>
            <% } %>

            <a href="<%=ctx%>/logout">Logout</a>
        </div>

        <a href="<%=ctx%>/profile" class="nav-avatar" title="Profile">
            <% if (profilePhoto != null && !profilePhoto.isBlank()) { %>
                <img src="<%=ctx%>/<%=profilePhoto%>?v=<%=System.currentTimeMillis()%>" alt="Profile photo">
            <% } else { %>
                <%=initials%>
            <% } %>
        </a>
    </div>
</nav>

<div class="page">
    <main class="main">

        <section class="hero">
            <div class="hero-content">
                <div class="hero-kicker">Learning identity and personalization</div>
                <h1>Manage your learning profile.</h1>
                <p>
                    Personalize your SmartStudy AI experience, update your study identity and control how
                    the platform understands your rhythm, learning style and preparation goals.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Profile mode</div>
                <div class="hero-panel-value"><%=preferredStudyRhythm%></div>
                <div class="hero-panel-note"><%=learningStyle%></div>
            </div>
        </section>

        <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">
                Profile changes saved successfully.
            </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%=request.getAttribute("success")%>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%=request.getAttribute("error")%>
            </div>
        <% } %>

        <section class="profile-layout">

            <aside class="profile-side">

                <div class="card profile-card">

                    <div class="avatar-wrap">
                        <% if (profilePhoto != null && !profilePhoto.isBlank()) { %>
                            <img src="<%=ctx%>/<%=profilePhoto%>?v=<%=System.currentTimeMillis()%>" class="avatar" alt="Profile photo">
                        <% } else { %>
                            <div class="avatar-fallback"><%=initials%></div>
                        <% } %>
                    </div>

                    <div class="profile-name"><%=fullName.isBlank() ? "Student" : fullName%></div>
                    <div class="profile-email"><%=email%></div>
                    <div class="profile-role"><%=role%></div>

                    <div class="side-info">
                        <div class="info-row">
                            <div class="info-label">Learning identity</div>
                            <div class="info-value">
                                <%=description.isBlank() ? "No profile description added yet." : description%>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Study rhythm</div>
                            <div class="info-value"><%=preferredStudyRhythm%></div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Learning style</div>
                            <div class="info-value"><%=learningStyle%></div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Account status</div>
                            <div class="info-value">Active learning account</div>
                        </div>
                    </div>

                    <div class="side-actions">
                        <a href="<%=ctx%>/planner" class="btn btn-soft">Open study planner</a>
                        <a href="<%=ctx%>/flashcards" class="btn btn-secondary">Review flashcards</a>
                    </div>

                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Learning snapshot</div>
                            <div class="section-subtitle">How your profile influences SmartStudy AI.</div>
                        </div>
                    </div>

                    <div class="side-info" style="margin-top:0;">
                        <div class="info-row">
                            <div class="info-label">Rhythm advice</div>
                            <div class="info-value"><%=rhythmAdvice%></div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Style advice</div>
                            <div class="info-value"><%=styleAdvice%></div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">AI focus</div>
                            <div class="info-value">Adaptive recommendations based on profile and quiz activity.</div>
                        </div>
                    </div>
                </div>

            </aside>

            <div class="profile-main">

                <section class="card">

                    <div class="card-header">
                        <div>
                            <div class="section-title">Profile information</div>
                            <div class="section-subtitle">
                                Update your name, description and profile image. This information helps the interface
                                feel more personal and improves future AI-based recommendations.
                            </div>
                        </div>
                    </div>

                    <form method="post" action="<%=ctx%>/profile" enctype="multipart/form-data">

                        <div class="form-grid">

                            <div class="field">
                                <label class="label">Full name</label>
                                <input
                                        type="text"
                                        name="fullName"
                                        value="<%=fullName%>"
                                        class="input"
                                        placeholder="Your full name"
                                        required
                                >
                            </div>

                            <div class="field">
                                <label class="label">Email address</label>
                                <input
                                        type="email"
                                        value="<%=email%>"
                                        class="input"
                                        readonly
                                >
                                <div class="help">Your email is used for login and cannot be changed here.</div>
                            </div>

                            <div class="field full">
                                <label class="label">Profile photo</label>

                                <div class="file-box">
                                    <div class="file-icon">IMG</div>
                                    <div style="flex: 1;">
                                        <input
                                                type="file"
                                                name="profilePhoto"
                                                accept="image/png,image/jpeg,image/jpg"
                                        >
                                        <div class="help">Accepted formats: PNG, JPG, JPEG. Maximum recommended size: 5 MB.</div>
                                    </div>
                                </div>
                            </div>

                            <div class="field full">
                                <label class="label">About you</label>
                                <textarea
                                        name="description"
                                        class="textarea"
                                        placeholder="Example: 3rd year Computer Science student preparing for Web Programming, Databases and Networks..."
                                ><%=description%></textarea>
                                <div class="help">
                                    Write a short description of your academic profile, current exams or learning goals.
                                </div>
                            </div>

                            <div class="field">
                                <label class="label">Preferred study rhythm</label>
                                <select class="select" name="preferredStudyRhythm">
                                    <option value="Balanced revision" <%= "Balanced revision".equals(preferredStudyRhythm) ? "selected" : "" %>>
                                        Balanced revision
                                    </option>

                                    <option value="Intensive revision" <%= "Intensive revision".equals(preferredStudyRhythm) ? "selected" : "" %>>
                                        Intensive revision
                                    </option>

                                    <option value="Light daily revision" <%= "Light daily revision".equals(preferredStudyRhythm) ? "selected" : "" %>>
                                        Light daily revision
                                    </option>

                                    <option value="Exam sprint" <%= "Exam sprint".equals(preferredStudyRhythm) ? "selected" : "" %>>
                                        Exam sprint
                                    </option>

                                    <option value="Weekend-focused" <%= "Weekend-focused".equals(preferredStudyRhythm) ? "selected" : "" %>>
                                        Weekend-focused
                                    </option>
                                </select>
                                <div class="help">
                                    This controls how the planner distributes your tasks across the available days.
                                </div>
                            </div>

                            <div class="field">
                                <label class="label">Learning style</label>
                                <select class="select" name="learningStyle">
                                    <option value="Quizzes and practice" <%= "Quizzes and practice".equals(learningStyle) ? "selected" : "" %>>
                                        Quizzes and practice
                                    </option>

                                    <option value="Flashcards" <%= "Flashcards".equals(learningStyle) ? "selected" : "" %>>
                                        Flashcards
                                    </option>

                                    <option value="Reading summaries" <%= "Reading summaries".equals(learningStyle) ? "selected" : "" %>>
                                        Reading summaries
                                    </option>

                                    <option value="Visual explanations" <%= "Visual explanations".equals(learningStyle) ? "selected" : "" %>>
                                        Visual explanations
                                    </option>

                                    <option value="Mixed learning" <%= "Mixed learning".equals(learningStyle) ? "selected" : "" %>>
                                        Mixed learning
                                    </option>
                                </select>
                                <div class="help">
                                    This controls whether the AI prioritizes quizzes, flashcards, summaries or mixed activities.
                                </div>
                            </div>

                            <div class="field full">
                                <label class="label">Personal experience controls</label>

                                <div class="preference-grid">
                                    <div class="preference-card">
                                        <div class="preference-title">AI recommendations</div>
                                        <div class="preference-text">
                                            Use my profile and results to suggest better study activities.
                                        </div>
                                    </div>

                                    <div class="preference-card">
                                        <div class="preference-title">Progress tracking</div>
                                        <div class="preference-text">
                                            Keep my quiz history and learning progress visible in dashboard.
                                        </div>
                                    </div>

                                    <div class="preference-card">
                                        <div class="preference-title">Study personalization</div>
                                        <div class="preference-text">
                                            Adapt my revision plan based on weak topics, rhythm, learning style and exam dates.
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <div class="actions">
                            <a href="<%=ctx%>/dashboard" class="btn btn-secondary">Cancel</a>
                            <button class="btn btn-primary" type="submit">Save profile changes</button>
                        </div>

                    </form>

                </section>

                <section class="ai-profile-coach">
                    <div class="ai-profile-header">
                        <div class="ai-profile-pulse"></div>
                        <div class="ai-profile-title">AI Learning Coach</div>
                    </div>

                    <p class="ai-profile-subtitle">
                        Ask personalized questions about your progress, preparation level, exam readiness, study rhythm,
                        weak topics and what you should improve next.
                    </p>

                    <div class="ai-profile-grid">
                        <button type="button" class="ai-profile-question" onclick="fillProfileAiPrompt(this)">
                            What is my current preparation level?
                        </button>

                        <button type="button" class="ai-profile-question" onclick="fillProfileAiPrompt(this)">
                            What should I revise first based on my quiz mistakes?
                        </button>

                        <button type="button" class="ai-profile-question" onclick="fillProfileAiPrompt(this)">
                            Am I studying enough according to my progress?
                        </button>

                        <button type="button" class="ai-profile-question" onclick="fillProfileAiPrompt(this)">
                            Create a personalized improvement plan for me.
                        </button>
                    </div>

                    <div class="ai-profile-input-row">
                        <input
                                type="text"
                                id="profileAiInput"
                                class="ai-profile-input"
                                placeholder="Ask about progress, exams, weak topics or study strategy..."
                        >

                        <button type="button" class="ai-profile-send" onclick="sendProfileAiMessage()">
                            Ask AI →
                        </button>
                    </div>

                    <div id="profileAiResponse" class="ai-profile-response"></div>

                    <div class="ai-profile-note">
                        The coach uses your learning profile context and the AI tutor endpoint to generate personalized study advice.
                    </div>
                </section>

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Personalization summary</div>
                            <div class="section-subtitle">
                                These rules explain how your profile information guides SmartStudy AI.
                            </div>
                        </div>
                    </div>

                    <div class="summary-grid">
                        <div class="summary-card">
                            <div class="summary-icon">🧭</div>
                            <div class="summary-title">Study plan behavior</div>
                            <div class="summary-text">
                                Your rhythm helps the planner choose between lighter daily sessions, balanced revision,
                                intensive work or exam sprint planning.
                            </div>
                        </div>

                        <div class="summary-card">
                            <div class="summary-icon">🎯</div>
                            <div class="summary-title">AI recommendations</div>
                            <div class="summary-text">
                                Your learning style helps the AI decide whether to recommend summaries, quizzes,
                                flashcards, practice tasks or a mixed workflow.
                            </div>
                        </div>

                        <div class="summary-card">
                            <div class="summary-icon">🧠</div>
                            <div class="summary-title">Adaptive learning</div>
                            <div class="summary-text">
                                Quiz mistakes and weak topics can be transformed into targeted flashcards and
                                personalized improvement suggestions.
                            </div>
                        </div>
                    </div>
                </section>

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Profile tips</div>
                            <div class="section-subtitle">
                                Small improvements that make AI recommendations more useful.
                            </div>
                        </div>
                    </div>

                    <div class="tips-grid">
                        <div class="tip-card">
                            <div class="tip-title">Write a specific academic profile</div>
                            <div class="tip-text">
                                Mention your year, main subjects, upcoming exams and learning goals. This gives the AI better context.
                            </div>
                        </div>

                        <div class="tip-card">
                            <div class="tip-title">Update your rhythm before exam periods</div>
                            <div class="tip-text">
                                Switch to Exam sprint or Intensive revision when deadlines are close, then return to Balanced revision later.
                            </div>
                        </div>

                        <div class="tip-card">
                            <div class="tip-title">Use quizzes to create better recommendations</div>
                            <div class="tip-text">
                                Quiz mistakes help the platform detect weak topics and generate adaptive flashcards.
                            </div>
                        </div>

                        <div class="tip-card">
                            <div class="tip-title">Use learning style as a preference, not a limit</div>
                            <div class="tip-text">
                                Mixed learning is often the best choice when preparing for exams because it combines reading, recall and practice.
                            </div>
                        </div>
                    </div>
                </section>

            </div>

        </section>

    </main>
</div>

<script>
    function fillProfileAiPrompt(el) {
        const input = document.getElementById('profileAiInput');

        if (input) {
            input.value = el.textContent.trim();
            input.focus();
        }
    }

    function sendProfileAiMessage() {
        const input = document.getElementById('profileAiInput');
        const response = document.getElementById('profileAiResponse');
        const button = document.querySelector('.ai-profile-send');

        if (!input || !response) {
            return;
        }

        const question = input.value.trim();

        if (!question) {
            response.style.display = 'block';
            response.textContent = 'Please write a question first.';
            return;
        }

        const profileContext =
            'You are answering from the Profile page of SmartStudy AI. ' +
            'Focus on personal learning progress, exam readiness, study rhythm, learning style, quiz performance, weak topics, adaptive flashcards and study strategy. ' +
            'Current preferred study rhythm: <%=preferredStudyRhythm.replace("'", "\\'")%>. ' +
            'Current learning style: <%=learningStyle.replace("'", "\\'")%>. ' +
            'Give practical, clear and personalized advice. User question: ';

        response.style.display = 'block';
        response.textContent = 'Analyzing your learning profile...';

        if (button) {
            button.disabled = true;
            button.textContent = 'Analyzing...';
        }

        fetch('<%=ctx%>/ai-tutor', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: 'question=' + encodeURIComponent(profileContext + question)
        })
        .then(function(res) {
            return res.text().then(function(text) {
                let data;

                try {
                    data = JSON.parse(text);
                } catch (e) {
                    data = {
                        answer: text
                    };
                }

                if (!res.ok) {
                    throw new Error(data.answer || ('HTTP ' + res.status));
                }

                return data;
            });
        })
        .then(function(data) {
            if (data && data.answer) {
                response.textContent = data.answer;
            } else {
                response.textContent = 'No answer received from AI coach.';
            }
        })
        .catch(function(error) {
            response.textContent = 'AI coach error: ' + error.message;
        })
        .finally(function() {
            if (button) {
                button.disabled = false;
                button.textContent = 'Ask AI →';
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        const input = document.getElementById('profileAiInput');

        if (input) {
            input.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    sendProfileAiMessage();
                }
            });
        }
    });
</script>

</body>
</html>
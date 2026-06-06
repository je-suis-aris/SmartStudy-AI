<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.*" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Statistics</title>
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
            --green-accent: #22c55e;
            --red: #991b1b;
            --red-bg: #fef2f2;
            --red-accent: #ef4444;
            --amber: #b7791f;
            --amber-bg: #fffbeb;
            --amber-accent: #f59e0b;
            --blue-bg: #eff6ff;
            --shadow: 0 12px 35px rgba(15, 23, 42, 0.08);
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

        button {
            font-family: inherit;
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
            display: grid;
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 32px;
            align-items: center;
            margin-bottom: 26px;
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
        .hero-score {
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
            max-width: 860px;
        }

        .hero p {
            color: rgba(255,255,255,0.72);
            max-width: 760px;
            font-size: 1rem;
            line-height: 1.75;
        }

        .hero-score {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.14);
            border-radius: 24px;
            padding: 24px;
            backdrop-filter: blur(10px);
        }

        .hero-score-label {
            color: rgba(255,255,255,0.58);
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 0.11em;
            text-transform: uppercase;
            margin-bottom: 12px;
        }

        .hero-score-value {
            font-size: 2.85rem;
            font-weight: 800;
            letter-spacing: -0.06em;
            line-height: 1;
        }

        .hero-score-note {
            color: rgba(255,255,255,0.68);
            font-size: 0.86rem;
            margin-top: 8px;
        }

        .action-row {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid transparent;
            border-radius: 13px;
            padding: 11px 16px;
            font-size: 0.88rem;
            font-weight: 800;
            cursor: pointer;
            transition: 0.2s;
            white-space: nowrap;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-white {
            background: white;
            color: var(--primary-dark);
        }

        .btn-white:hover {
            background: #f8fafc;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: white;
            color: var(--ink-2);
            border-color: var(--rule);
        }

        .btn-secondary:hover {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-soft);
        }

        .metric-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 26px;
        }

        .metric-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            transition: 0.2s;
            min-height: 168px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .metric-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow);
        }

        .metric-top {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: flex-start;
        }

        .metric-label {
            color: var(--ink-3);
            font-size: 0.76rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .metric-icon {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.05rem;
        }

        .metric-icon.blue {
            background: var(--primary-soft);
        }

        .metric-icon.green {
            background: var(--green-bg);
        }

        .metric-icon.amber {
            background: var(--amber-bg);
        }

        .metric-icon.red {
            background: var(--red-bg);
        }

        .metric-value {
            font-size: 2.25rem;
            font-weight: 800;
            letter-spacing: -0.055em;
            line-height: 1;
            margin-top: 18px;
        }

        .metric-sub {
            color: var(--ink-3);
            font-size: 0.84rem;
            margin-top: 8px;
        }

        .badge {
            display: inline-flex;
            width: fit-content;
            align-items: center;
            gap: 6px;
            padding: 6px 11px;
            border-radius: 999px;
            font-size: 0.76rem;
            font-weight: 800;
            margin-top: 12px;
        }

        .badge.green {
            background: var(--green-bg);
            color: var(--green);
        }

        .badge.amber {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .badge.blue {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .badge.red {
            background: var(--red-bg);
            color: var(--red);
        }

        .stats-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.35fr) minmax(360px, 0.65fr);
            gap: 24px;
            align-items: start;
        }

        .stats-left,
        .stats-right {
            display: grid;
            gap: 24px;
            align-content: start;
        }

        .stats-right {
            position: sticky;
            top: 92px;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 26px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
        }

        .compact-card {
            padding: 22px;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
            margin-bottom: 20px;
        }

        .compact-card .card-header {
            margin-bottom: 16px;
        }

        .card-title {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--ink);
            letter-spacing: -0.035em;
        }

        .card-subtitle {
            font-size: 0.86rem;
            color: var(--ink-3);
            margin-top: 4px;
        }

        .chart-wrap {
            margin-top: 8px;
        }

        .bar-chart {
            height: 210px;
            display: flex;
            align-items: flex-end;
            gap: 12px;
            padding: 18px 8px 8px;
            border-radius: 18px;
            background: linear-gradient(180deg, #f8fafc 0%, #ffffff 100%);
            border: 1px solid var(--rule);
        }

        .bar-item {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-end;
            height: 100%;
            gap: 8px;
        }

        .bar {
            width: 100%;
            max-width: 48px;
            min-height: 6px;
            border-radius: 10px 10px 4px 4px;
            background: var(--primary);
            transition: 0.2s;
            position: relative;
        }

        .bar:hover {
            opacity: 0.85;
            transform: translateY(-2px);
        }

        .bar-label {
            font-size: 0.72rem;
            color: var(--ink-4);
            text-align: center;
            white-space: nowrap;
        }

        .bar-score {
            font-size: 0.72rem;
            font-weight: 800;
            color: var(--ink-3);
        }

        .insight-list {
            display: grid;
            gap: 12px;
        }

        .insight-item {
            border: 1px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 16px;
            padding: 15px 16px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }

        .insight-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-top: 7px;
            flex-shrink: 0;
        }

        .insight-dot.green {
            background: var(--green-accent);
        }

        .insight-dot.amber {
            background: var(--amber-accent);
        }

        .insight-dot.blue {
            background: var(--primary);
        }

        .insight-dot.red {
            background: var(--red-accent);
        }

        .insight-title {
            font-size: 0.9rem;
            font-weight: 800;
            color: var(--ink);
        }

        .insight-text {
            color: var(--ink-3);
            font-size: 0.82rem;
            margin-top: 2px;
            line-height: 1.55;
        }

        .progress-section {
            margin-top: 6px;
        }

        .progress-row {
            display: grid;
            grid-template-columns: 140px 1fr 48px;
            gap: 12px;
            align-items: center;
            margin-bottom: 14px;
        }

        .progress-name {
            color: var(--ink-2);
            font-size: 0.86rem;
            font-weight: 700;
        }

        .progress-track {
            height: 9px;
            background: var(--rule);
            border-radius: 999px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 999px;
            background: var(--primary);
        }

        .progress-fill.green {
            background: var(--green-accent);
        }

        .progress-fill.amber {
            background: var(--amber-accent);
        }

        .progress-fill.red {
            background: var(--red-accent);
        }

        .progress-score {
            color: var(--ink-3);
            font-size: 0.78rem;
            font-weight: 800;
            text-align: right;
        }

        .quick-action-grid {
            display: grid;
            gap: 10px;
        }

        .quick-action-link {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 15px;
            padding: 13px 14px;
            color: var(--ink-2);
            font-size: 0.86rem;
            font-weight: 800;
            transition: 0.2s;
        }

        .quick-action-link:hover {
            background: var(--primary-soft);
            color: var(--primary);
            border-color: #d8e3f1;
            transform: translateY(-1px);
        }

        .quick-action-link span {
            color: var(--ink-4);
            font-size: 0.8rem;
        }

        .learning-plan {
            display: grid;
            gap: 12px;
        }

        .plan-step {
            border: 1px solid var(--rule);
            border-radius: 18px;
            padding: 16px;
            display: grid;
            grid-template-columns: 38px 1fr;
            gap: 14px;
            background: #ffffff;
        }

        .step-number {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-weight: 800;
        }

        .step-title {
            font-weight: 800;
            color: var(--ink);
            font-size: 0.92rem;
        }

        .step-text {
            color: var(--ink-3);
            font-size: 0.84rem;
            margin-top: 3px;
        }

        .table-card {
            margin-top: 0;
        }

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 760px;
        }

        th {
            text-align: left;
            color: var(--ink-3);
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            padding: 12px 10px;
            border-bottom: 1px solid var(--rule);
        }

        td {
            padding: 15px 10px;
            border-bottom: 1px solid var(--rule);
            color: var(--ink-2);
            font-size: 0.9rem;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .score-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 10px;
            border-radius: 999px;
            font-weight: 800;
            font-size: 0.78rem;
        }

        .score-pill.high {
            background: var(--green-bg);
            color: var(--green);
        }

        .score-pill.mid {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .score-pill.low {
            background: var(--red-bg);
            color: var(--red);
        }

        .empty-state {
            border: 1px dashed #cbd5e1;
            background: #f8fafc;
            border-radius: 18px;
            padding: 28px;
            text-align: center;
            color: var(--ink-3);
        }

        .empty-state h3 {
            color: var(--ink);
            font-size: 1.1rem;
            margin-bottom: 6px;
        }

        @media (max-width: 1180px) {
            .hero {
                grid-template-columns: 1fr;
            }

            .metric-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .stats-layout {
                grid-template-columns: 1fr;
            }

            .stats-right {
                position: static;
            }
        }

        @media (max-width: 900px) {
            .nav-links {
                display: none;
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

            .metric-grid {
                grid-template-columns: 1fr;
            }

            .progress-row {
                grid-template-columns: 1fr;
                gap: 6px;
            }

            .progress-score {
                text-align: left;
            }
        }
    </style>
</head>

<body>
<%
    String ctx = request.getContextPath();

    User currentUser = (User) session.getAttribute("user");

    String initials = "ST";
    String profilePhoto = null;
    boolean isAdmin = false;

    if (currentUser != null) {
        isAdmin = "ADMIN".equalsIgnoreCase(currentUser.getRole());
        profilePhoto = currentUser.getProfilePhoto();

        if (currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty()) {
            String fullName = currentUser.getFullName().trim();
            String[] parts = fullName.split("\\s+");

            if (parts.length >= 2) {
                initials = parts[0].substring(0, 1).toUpperCase()
                        + parts[1].substring(0, 1).toUpperCase();
            } else {
                initials = fullName.substring(0, 1).toUpperCase();
            }
        }
    }

    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    List<QuizResult> results = (List<QuizResult>) request.getAttribute("results");

    if (results == null) {
        results = new ArrayList<QuizResult>();
    }

    int totalStudyMinutes = stats != null ? stats.getTotalStudyMinutes() : 0;
    double averageScore = stats != null ? stats.getAverageScore() : 0.0;

    int totalAttempts = results.size();
    int totalQuestionsAnswered = 0;
    int totalCorrectAnswers = 0;
    double bestPercent = 0.0;
    String bestCourse = "No quiz yet";

    double lastPercent = 0.0;
    double previousPercent = 0.0;

    for (int i = 0; i < results.size(); i++) {
        QuizResult r = results.get(i);

        int score = r.getScore();
        int total = r.getTotalQuestions();

        totalCorrectAnswers += score;
        totalQuestionsAnswered += total;

        double percent = total > 0 ? (score * 100.0 / total) : 0.0;

        if (percent > bestPercent) {
            bestPercent = percent;
            bestCourse = r.getCourseTitle();
        }

        if (i == results.size() - 1) {
            lastPercent = percent;
        }

        if (i == results.size() - 2) {
            previousPercent = percent;
        }
    }

    double accuracy = totalQuestionsAnswered > 0
            ? totalCorrectAnswers * 100.0 / totalQuestionsAnswered
            : 0.0;

    double trendDelta = totalAttempts >= 2 ? lastPercent - previousPercent : 0.0;

    String learnerBadge = "Focused Learner";

    if (averageScore >= 85) {
        learnerBadge = "Excellent Performer";
    } else if (averageScore >= 65) {
        learnerBadge = "Consistent Learner";
    } else if (totalAttempts == 0) {
        learnerBadge = "New Learner";
    } else if (averageScore < 45) {
        learnerBadge = "Revision Priority";
    }

    int studyHours = totalStudyMinutes / 60;
    int studyMinutes = totalStudyMinutes % 60;

    int chartLimit = Math.min(results.size(), 7);

    int readiness = (int)Math.round((averageScore * 0.65) + (Math.min(totalAttempts, 10) * 3.5));
    readiness = Math.max(0, Math.min(100, readiness));

    int practiceVolume = Math.min(100, totalAttempts * 12);
    int studyConsistency = Math.min(100, totalStudyMinutes / 2);
    int accuracyRounded = (int)Math.round(accuracy);

    String nextAction;

    if (totalAttempts == 0) {
        nextAction = "Start your first assessment to create an initial performance baseline.";
    } else if (averageScore < 50) {
        nextAction = "Review weak topics in Insights, generate flashcards, then retake a short quiz.";
    } else if (averageScore < 75) {
        nextAction = "Focus on medium-level topics and repeat targeted quizzes to stabilize your score.";
    } else {
        nextAction = "Maintain performance with spaced repetition and short revision quizzes.";
    }
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
            <a href="<%=ctx%>/stats" class="active">Stats</a>
            <a href="<%=ctx%>/profile">Profile</a>
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
                <div class="hero-kicker">Performance analytics</div>
                <h1>Your learning progress, clearly measured.</h1>
                <p>
                    Track your study time, quiz results, consistency and performance trends.
                    Use these statistics to decide what to revise next and when to ask SmartStudy AI for deeper guidance.
                </p>

                <div class="action-row">
                    <a href="<%=ctx%>/assessment" class="btn btn-white">Start new assessment</a>
                    <a href="<%=ctx%>/planner" class="btn btn-primary">Update study plan</a>
                    <a href="<%=ctx%>/insights" class="btn btn-white">Open insights</a>
                </div>
            </div>

            <div class="hero-score">
                <div class="hero-score-label">Average score</div>
                <div class="hero-score-value"><%=String.format("%.1f", averageScore)%>%</div>
                <div class="hero-score-note">
                    Based on <%=totalAttempts%> quiz attempt<%=totalAttempts == 1 ? "" : "s"%>.
                    <% if (totalAttempts >= 2) { %>
                        Trend: <%=trendDelta >= 0 ? "+" : ""%><%=String.format("%.1f", trendDelta)%>%
                    <% } %>
                </div>
            </div>
        </section>

        <section class="metric-grid">

            <div class="metric-card">
                <div>
                    <div class="metric-top">
                        <div class="metric-label">Study time</div>
                        <div class="metric-icon blue">⏱</div>
                    </div>

                    <div class="metric-value">
                        <% if (studyHours > 0) { %>
                            <%=studyHours%>h <%=studyMinutes%>m
                        <% } else { %>
                            <%=studyMinutes%> min
                        <% } %>
                    </div>

                    <div class="metric-sub">Total time registered in your learning activity.</div>
                </div>

                <div class="badge blue">Learning activity</div>
            </div>

            <div class="metric-card">
                <div>
                    <div class="metric-top">
                        <div class="metric-label">Quiz attempts</div>
                        <div class="metric-icon green">📝</div>
                    </div>

                    <div class="metric-value"><%=totalAttempts%></div>
                    <div class="metric-sub">Completed quiz sessions saved in your history.</div>
                </div>

                <div class="badge green">Practice history</div>
            </div>

            <div class="metric-card">
                <div>
                    <div class="metric-top">
                        <div class="metric-label">Accuracy</div>
                        <div class="metric-icon amber">✅</div>
                    </div>

                    <div class="metric-value"><%=String.format("%.0f", accuracy)%>%</div>
                    <div class="metric-sub"><%=totalCorrectAnswers%>/<%=totalQuestionsAnswered%> correct answers.</div>
                </div>

                <div class="badge amber">Accuracy tracking</div>
            </div>

            <div class="metric-card">
                <div>
                    <div class="metric-top">
                        <div class="metric-label">Best result</div>
                        <div class="metric-icon red">🎯</div>
                    </div>

                    <div class="metric-value"><%=String.format("%.0f", bestPercent)%>%</div>
                    <div class="metric-sub"><%=bestCourse%></div>
                </div>

                <div class="badge <%=averageScore >= 65 ? "green" : averageScore >= 45 ? "amber" : "red"%>"><%=learnerBadge%></div>
            </div>

        </section>

        <section class="stats-layout">

            <div class="stats-left">

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Score evolution</div>
                            <div class="card-subtitle">Your last quiz attempts, transformed into percentages.</div>
                        </div>
                    </div>

                    <% if (results.isEmpty()) { %>
                        <div class="empty-state">
                            <h3>No quiz history yet</h3>
                            <p>Take your first quiz to generate a performance chart.</p>
                            <div class="action-row" style="justify-content:center;">
                                <a href="<%=ctx%>/assessment" class="btn btn-primary">Start quiz</a>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="chart-wrap">
                            <div class="bar-chart">
                                <%
                                    int start = Math.max(0, results.size() - chartLimit);
                                    for (int i = start; i < results.size(); i++) {
                                        QuizResult r = results.get(i);
                                        int score = r.getScore();
                                        int total = r.getTotalQuestions();
                                        double percent = total > 0 ? (score * 100.0 / total) : 0.0;
                                        int height = Math.max(8, (int)Math.round(percent * 1.65));
                                %>
                                    <div class="bar-item">
                                        <div class="bar-score"><%=String.format("%.0f", percent)%>%</div>
                                        <div class="bar" style="height:<%=height%>px;"></div>
                                        <div class="bar-label">Quiz <%=i + 1%></div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Skill readiness overview</div>
                            <div class="card-subtitle">Computed from quiz accuracy, practice volume and recorded study time.</div>
                        </div>
                    </div>

                    <div class="progress-section">
                        <div class="progress-row">
                            <div class="progress-name">Study consistency</div>
                            <div class="progress-track">
                                <div class="progress-fill green" style="width:<%=studyConsistency%>%"></div>
                            </div>
                            <div class="progress-score"><%=studyConsistency%>%</div>
                        </div>

                        <div class="progress-row">
                            <div class="progress-name">Quiz accuracy</div>
                            <div class="progress-track">
                                <div class="progress-fill <%=accuracy >= 60 ? "green" : accuracy >= 40 ? "amber" : "red"%>" style="width:<%=Math.max(5, Math.min(100, accuracyRounded))%>%"></div>
                            </div>
                            <div class="progress-score"><%=accuracyRounded%>%</div>
                        </div>

                        <div class="progress-row">
                            <div class="progress-name">Practice volume</div>
                            <div class="progress-track">
                                <div class="progress-fill amber" style="width:<%=practiceVolume%>%"></div>
                            </div>
                            <div class="progress-score"><%=practiceVolume%>%</div>
                        </div>

                        <div class="progress-row">
                            <div class="progress-name">Exam readiness</div>
                            <div class="progress-track">
                                <div class="progress-fill <%=readiness >= 70 ? "green" : readiness >= 40 ? "amber" : "red"%>" style="width:<%=readiness%>%"></div>
                            </div>
                            <div class="progress-score"><%=readiness%>%</div>
                        </div>
                    </div>
                </div>

                <section class="card table-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Score history</div>
                            <div class="card-subtitle">Detailed list of your recorded quiz results.</div>
                        </div>
                    </div>

                    <% if (results.isEmpty()) { %>
                        <div class="empty-state">
                            <h3>No saved results</h3>
                            <p>Your score history will appear here after you complete quizzes.</p>
                        </div>
                    <% } else { %>
                        <div class="table-wrap">
                            <table>
                                <thead>
                                <tr>
                                    <th>Course</th>
                                    <th>Score</th>
                                    <th>Percentage</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                </tr>
                                </thead>

                                <tbody>
                                <% for (QuizResult r : results) {
                                    int score = r.getScore();
                                    int total = r.getTotalQuestions();
                                    double percent = total > 0 ? (score * 100.0 / total) : 0.0;

                                    String pillClass = "low";
                                    String status = "Needs revision";

                                    if (percent >= 75) {
                                        pillClass = "high";
                                        status = "Strong";
                                    } else if (percent >= 50) {
                                        pillClass = "mid";
                                        status = "Moderate";
                                    }
                                %>
                                    <tr>
                                        <td><%=r.getCourseTitle()%></td>
                                        <td><%=score%>/<%=total%></td>
                                        <td>
                                            <span class="score-pill <%=pillClass%>">
                                                <%=String.format("%.0f", percent)%>%
                                            </span>
                                        </td>
                                        <td><%=status%></td>
                                        <td><%=r.getCreatedAt()%></td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </section>

            </div>

            <div class="stats-right">

                <div class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Performance coach</div>
                            <div class="card-subtitle">Automatic interpretation of your activity.</div>
                        </div>
                    </div>

                    <div class="insight-list">

                        <div class="insight-item">
                            <div class="insight-dot blue"></div>
                            <div>
                                <div class="insight-title">Consistency level</div>
                                <div class="insight-text">
                                    You have completed <%=totalAttempts%> quiz attempt<%=totalAttempts == 1 ? "" : "s"%>.
                                    More attempts will make your statistics and insights more reliable.
                                </div>
                            </div>
                        </div>

                        <div class="insight-item">
                            <div class="insight-dot <%=averageScore >= 60 ? "green" : "amber"%>"></div>
                            <div>
                                <div class="insight-title">Performance trend</div>
                                <div class="insight-text">
                                    Your average score is <%=String.format("%.1f", averageScore)%>%.
                                    <% if (averageScore >= 70) { %>
                                        Your results are strong, but targeted revision can still improve retention.
                                    <% } else { %>
                                        You should focus on weak topics and repeat short practice sessions.
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <div class="insight-item">
                            <div class="insight-dot <%=trendDelta >= 0 ? "green" : "red"%>"></div>
                            <div>
                                <div class="insight-title">Latest trend</div>
                                <div class="insight-text">
                                    <% if (totalAttempts < 2) { %>
                                        Complete at least two quizzes to calculate a real trend.
                                    <% } else if (trendDelta >= 0) { %>
                                        Your latest result improved by <%=String.format("%.1f", trendDelta)%> percentage points.
                                    <% } else { %>
                                        Your latest result decreased by <%=String.format("%.1f", Math.abs(trendDelta))%> percentage points. Review before retaking.
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <div class="insight-item">
                            <div class="insight-dot amber"></div>
                            <div>
                                <div class="insight-title">Recommended next action</div>
                                <div class="insight-text"><%=nextAction%></div>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Quick actions</div>
                            <div class="card-subtitle">Continue your study workflow.</div>
                        </div>
                    </div>

                    <div class="quick-action-grid">
                        <a class="quick-action-link" href="<%=ctx%>/assessment">
                            Start a new quiz
                            <span>→</span>
                        </a>

                        <a class="quick-action-link" href="<%=ctx%>/insights">
                            View weak topics
                            <span>→</span>
                        </a>

                        <a class="quick-action-link" href="<%=ctx%>/flashcards">
                            Review flashcards
                            <span>→</span>
                        </a>

                        <a class="quick-action-link" href="<%=ctx%>/planner">
                            Update study plan
                            <span>→</span>
                        </a>

                        <a class="quick-action-link" href="<%=ctx%>/ai-coach">
                            Ask AI Coach
                            <span>→</span>
                        </a>
                    </div>
                </div>

                <div class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Gamification profile</div>
                            <div class="card-subtitle">Your current learner status.</div>
                        </div>
                    </div>

                    <div class="metric-value" style="font-size:2rem;"><%=learnerBadge%></div>
                    <div class="metric-sub">
                        This badge is calculated from your quiz activity and average performance.
                    </div>

                    <div class="action-row">
                        <a href="<%=ctx%>/assessment" class="btn btn-primary">Improve badge</a>
                        <a href="<%=ctx%>/materials" class="btn btn-secondary">Upload material</a>
                    </div>
                </div>

                <div class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Suggested performance path</div>
                            <div class="card-subtitle">Simple sequence for improving your statistics.</div>
                        </div>
                    </div>

                    <div class="learning-plan">
                        <div class="plan-step">
                            <div class="step-number">1</div>
                            <div>
                                <div class="step-title">Review weakest topics</div>
                                <div class="step-text">Open Insights and focus first on low mastery areas.</div>
                            </div>
                        </div>

                        <div class="plan-step">
                            <div class="step-number">2</div>
                            <div>
                                <div class="step-title">Use flashcards</div>
                                <div class="step-text">Revise concepts before retaking a quiz.</div>
                            </div>
                        </div>

                        <div class="plan-step">
                            <div class="step-number">3</div>
                            <div>
                                <div class="step-title">Retake a targeted assessment</div>
                                <div class="step-text">A new quiz attempt updates your trend and readiness score.</div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </section>

    </main>
</div>

</body>
</html>
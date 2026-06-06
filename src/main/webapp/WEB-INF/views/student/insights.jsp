<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.User" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Insights</title>
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
            --amber: #b7791f;
            --amber-bg: #fffbeb;
            --amber-accent: #f59e0b;
            --red: #991b1b;
            --red-bg: #fef2f2;
            --red-accent: #ef4444;
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

        button,
        textarea {
            font-family: inherit;
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

        .page {
            padding-top: 68px;
            min-height: 100vh;
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
            grid-template-columns: minmax(0, 1fr) 360px;
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
            max-width: 760px;
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
            font-size: 2.75rem;
            font-weight: 800;
            letter-spacing: -0.06em;
            line-height: 1;
        }

        .hero-panel-note {
            color: rgba(255,255,255,0.68);
            font-size: 0.86rem;
            margin-top: 8px;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 26px;
        }

        .metric-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 24px;
            padding: 22px;
            min-height: 140px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.04);
            transition: 0.2s;
        }

        .metric-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow);
        }

        .metric-label {
            color: var(--ink-3);
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .metric-value {
            color: var(--ink);
            font-size: 2.15rem;
            font-weight: 800;
            letter-spacing: -0.055em;
            margin-top: 12px;
            line-height: 1;
        }

        .metric-sub {
            color: var(--ink-3);
            font-size: 0.82rem;
            margin-top: 8px;
        }

        .layout {
            display: grid;
            grid-template-columns: minmax(0, 1.1fr) minmax(350px, 0.9fr);
            gap: 24px;
            align-items: start;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 26px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
        }

        .card + .card {
            margin-top: 24px;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
            margin-bottom: 22px;
        }

        .card-title {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--ink);
            letter-spacing: -0.035em;
        }

        .card-subtitle {
            color: var(--ink-3);
            font-size: 0.86rem;
            margin-top: 4px;
        }

        .knowledge-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
        }

        .knowledge-card {
            border: 1px solid var(--rule);
            border-radius: 22px;
            background: white;
            padding: 20px;
            transition: 0.2s;
            min-height: 210px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .knowledge-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow);
        }

        .knowledge-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
        }

        .knowledge-title {
            font-weight: 800;
            color: var(--ink);
            font-size: 0.98rem;
            line-height: 1.35;
        }

        .status-pill {
            border-radius: 999px;
            padding: 5px 9px;
            font-size: 0.68rem;
            font-weight: 800;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .status-mastered {
            color: var(--green);
            background: var(--green-bg);
        }

        .status-medium {
            color: var(--amber);
            background: var(--amber-bg);
        }

        .status-gap {
            color: var(--red);
            background: var(--red-bg);
        }

        .donut-wrap {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 20px 0 16px;
        }

        .donut {
            --percent: 0;
            --color: var(--red-accent);
            width: 112px;
            height: 112px;
            border-radius: 50%;
            background:
                    conic-gradient(var(--color) calc(var(--percent) * 1%), #edf0f4 0);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .donut::after {
            content: "";
            position: absolute;
            width: 78px;
            height: 78px;
            border-radius: 50%;
            background: white;
        }

        .donut-value {
            position: relative;
            z-index: 1;
            font-size: 1.15rem;
            font-weight: 800;
            letter-spacing: -0.04em;
            color: var(--ink);
        }

        .progress-block {
            margin-top: 6px;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            color: var(--ink-3);
            font-size: 0.75rem;
            margin-bottom: 6px;
        }

        .progress-track {
            height: 8px;
            background: var(--rule);
            border-radius: 999px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 999px;
        }

        .fill-green {
            background: var(--green-accent);
        }

        .fill-amber {
            background: var(--amber-accent);
        }

        .fill-red {
            background: var(--red-accent);
        }

        .chart-card {
            min-height: 340px;
        }

        .bar-chart {
            display: grid;
            gap: 14px;
        }

        .bar-row {
            display: grid;
            grid-template-columns: 145px 1fr 55px;
            gap: 12px;
            align-items: center;
        }

        .bar-name {
            color: var(--ink-2);
            font-size: 0.84rem;
            font-weight: 700;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .bar-track {
            height: 12px;
            background: var(--rule);
            border-radius: 999px;
            overflow: hidden;
        }

        .bar-fill {
            height: 100%;
            border-radius: 999px;
            transition: width 0.6s ease;
        }

        .bar-score {
            color: var(--ink-3);
            font-size: 0.8rem;
            font-weight: 800;
            text-align: right;
        }

        .legend {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 20px;
            color: var(--ink-3);
            font-size: 0.82rem;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .legend-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }

        .recommendation-list {
            display: grid;
            gap: 12px;
        }

        .recommendation-item {
            border: 1px solid var(--rule);
            border-radius: 18px;
            padding: 16px;
            background: #ffffff;
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 14px;
        }

        .recommendation-dot {
            width: 11px;
            height: 11px;
            border-radius: 50%;
            margin-top: 6px;
            background: var(--red-accent);
        }

        .recommendation-dot.medium {
            background: var(--amber-accent);
        }

        .recommendation-dot.good {
            background: var(--green-accent);
        }

        .recommendation-title {
            font-weight: 800;
            color: var(--ink);
            font-size: 0.92rem;
        }

        .recommendation-text {
            color: var(--ink-3);
            font-size: 0.84rem;
            margin-top: 3px;
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

        .empty-state {
            border: 1px dashed #cbd5e1;
            background: #f8fafc;
            border-radius: 20px;
            padding: 36px 24px;
            text-align: center;
            color: var(--ink-3);
        }

        .empty-state-title {
            color: var(--ink);
            font-weight: 800;
            font-size: 1.1rem;
            margin-bottom: 6px;
        }

        .ai-insight-box {
            background: #eef3f9;
            color: #1f3a5f;
            border: 1px solid #d8e3f1;
            border-radius: 18px;
            padding: 18px;
            line-height: 1.75;
            font-size: 0.9rem;
            white-space: normal;
        }

        .ai-warning-box {
            background: #fffbeb;
            color: #92400e;
            border: 1px solid #fde68a;
            border-radius: 18px;
            padding: 16px;
            line-height: 1.6;
            font-size: 0.88rem;
        }

        .ai-generate-form {
            margin-top: 16px;
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
            font-family: 'Geist', Arial, sans-serif;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-full {
            width: 100%;
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

        .ai-mini-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .ai-mini-card {
            border: 1px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 16px;
            padding: 14px;
        }

        .ai-mini-label {
            color: var(--ink-3);
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .ai-mini-value {
            margin-top: 6px;
            color: var(--ink);
            font-size: 1.1rem;
            font-weight: 800;
        }

        @media (max-width: 1180px) {
            .hero {
                grid-template-columns: 1fr;
            }

            .metrics-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .layout {
                grid-template-columns: 1fr;
            }

            .knowledge-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 900px) {
            .nav-links {
                display: none;
            }
        }

        @media (max-width: 700px) {
            .main {
                padding: 24px 18px 60px;
            }

            .nav {
                padding: 0 20px;
            }

            .hero {
                padding: 28px;
                border-radius: 24px;
            }

            .hero h1 {
                font-size: 2.15rem;
            }

            .metrics-grid,
            .knowledge-grid,
            .ai-mini-grid {
                grid-template-columns: 1fr;
            }

            .bar-row {
                grid-template-columns: 1fr;
                gap: 6px;
            }

            .bar-score {
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

    String aiInsightsText = (String) session.getAttribute("aiInsightsText");

    List<Map<String, String>> aiRecommendationCards =
            (List<Map<String, String>>) session.getAttribute("aiRecommendationCards");

    if (aiRecommendationCards == null) {
        aiRecommendationCards = new ArrayList<Map<String, String>>();
    }

    List<Map<String,Object>> map = (List<Map<String,Object>>) request.getAttribute("knowledgeMap");

    if (map == null) {
        map = new ArrayList<Map<String,Object>>();
    }

    int totalTopics = map.size();
    int masteredCount = 0;
    int mediumCount = 0;
    int gapCount = 0;
    double sumMastery = 0.0;

    String weakestTopic = "";
    double weakestScore = 101.0;

    for (Map<String,Object> m : map) {
        String title = String.valueOf(m.get("title"));

        double mastery = 0.0;

        Object masteryObj = m.get("mastery");
        if (masteryObj instanceof Number) {
            mastery = ((Number) masteryObj).doubleValue();
        }

        sumMastery += mastery;

        if (mastery < weakestScore) {
            weakestScore = mastery;
            weakestTopic = title;
        }

        if (mastery >= 70.0) {
            masteredCount++;
        } else if (mastery >= 40.0) {
            mediumCount++;
        } else {
            gapCount++;
        }
    }

    double averageMastery = totalTopics > 0 ? sumMastery / totalTopics : 0.0;

    String mainRiskLabel;
    if (averageMastery >= 70.0) {
        mainRiskLabel = "Strong preparation";
    } else if (averageMastery >= 40.0) {
        mainRiskLabel = "Needs consolidation";
    } else {
        mainRiskLabel = "High revision priority";
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
            <a href="<%=ctx%>/insights" class="active">Insights</a>
            <a href="<%=ctx%>/stats">Stats</a>
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
                <div class="hero-kicker">AI learning insights</div>
                <h1>Understand your weak points before the exam.</h1>
                <p>
                    SmartStudy analyzes your quiz results, detects weak topics and transforms your progress
                    into a visual knowledge map with AI-generated recommendation cards.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Average mastery</div>
                <div class="hero-panel-value"><%=String.format("%.1f", averageMastery)%>%</div>
                <div class="hero-panel-note"><%=mainRiskLabel%></div>
            </div>
        </section>

        <section class="metrics-grid">
            <div class="metric-card">
                <div class="metric-label">Analyzed topics</div>
                <div class="metric-value"><%=totalTopics%></div>
                <div class="metric-sub">Courses and subjects included in the map.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Mastered</div>
                <div class="metric-value"><%=masteredCount%></div>
                <div class="metric-sub">Topics above 70% mastery.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">To consolidate</div>
                <div class="metric-value"><%=mediumCount%></div>
                <div class="metric-sub">Topics between 40% and 70%.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Critical gaps</div>
                <div class="metric-value"><%=gapCount%></div>
                <div class="metric-sub">Topics under 40% requiring revision.</div>
            </div>
        </section>

        <% if (map.isEmpty()) { %>

            <div class="empty-state">
                <div class="empty-state-title">No insight data available yet</div>
                <div>
                    Take a quiz first. After you submit results, the system will generate your knowledge map,
                    weak topics and AI-assisted recommendations.
                </div>
            </div>

        <% } else { %>

            <section class="layout">

                <div>

                    <div class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Knowledge map</div>
                                <div class="card-subtitle">
                                    Each topic is represented as a mastery card with a circular progress indicator.
                                </div>
                            </div>
                        </div>

                        <div class="knowledge-grid">
                            <% for (Map<String,Object> m : map) {
                                String title = String.valueOf(m.get("title"));

                                double mastery = 0.0;
                                Object masteryObj = m.get("mastery");
                                if (masteryObj instanceof Number) {
                                    mastery = ((Number) masteryObj).doubleValue();
                                }

                                String statusClass;
                                String statusText;
                                String colorClass;
                                String colorValue;

                                if (mastery >= 70.0) {
                                    statusClass = "status-mastered";
                                    statusText = "Mastered";
                                    colorClass = "fill-green";
                                    colorValue = "var(--green-accent)";
                                } else if (mastery >= 40.0) {
                                    statusClass = "status-medium";
                                    statusText = "Medium";
                                    colorClass = "fill-amber";
                                    colorValue = "var(--amber-accent)";
                                } else {
                                    statusClass = "status-gap";
                                    statusText = "Gap";
                                    colorClass = "fill-red";
                                    colorValue = "var(--red-accent)";
                                }
                            %>

                                <div class="knowledge-card">
                                    <div class="knowledge-top">
                                        <div class="knowledge-title"><%=title%></div>
                                        <span class="status-pill <%=statusClass%>"><%=statusText%></span>
                                    </div>

                                    <div class="donut-wrap">
                                        <div class="donut" style="--percent:<%=String.format(java.util.Locale.US, "%.1f", mastery)%>; --color:<%=colorValue%>;">
                                            <div class="donut-value"><%=String.format("%.1f", mastery)%>%</div>
                                        </div>
                                    </div>

                                    <div class="progress-block">
                                        <div class="progress-label">
                                            <span>Mastery level</span>
                                            <span><%=String.format("%.1f", mastery)%>%</span>
                                        </div>
                                        <div class="progress-track">
                                            <div class="progress-fill <%=colorClass%>" style="width:<%=String.format(java.util.Locale.US, "%.1f", mastery)%>%"></div>
                                        </div>
                                    </div>
                                </div>

                            <% } %>
                        </div>

                        <div class="legend">
                            <div class="legend-item">
                                <span class="legend-dot" style="background: var(--green-accent);"></span>
                                Green = mastered
                            </div>
                            <div class="legend-item">
                                <span class="legend-dot" style="background: var(--amber-accent);"></span>
                                Orange = needs consolidation
                            </div>
                            <div class="legend-item">
                                <span class="legend-dot" style="background: var(--red-accent);"></span>
                                Red = knowledge gap
                            </div>
                        </div>
                    </div>

                    <div class="card chart-card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Mastery comparison</div>
                                <div class="card-subtitle">
                                    A horizontal visual ranking of all analyzed topics.
                                </div>
                            </div>
                        </div>

                        <div class="bar-chart">
                            <% for (Map<String,Object> m : map) {
                                String title = String.valueOf(m.get("title"));

                                double mastery = 0.0;
                                Object masteryObj = m.get("mastery");
                                if (masteryObj instanceof Number) {
                                    mastery = ((Number) masteryObj).doubleValue();
                                }

                                String colorClass;
                                if (mastery >= 70.0) {
                                    colorClass = "fill-green";
                                } else if (mastery >= 40.0) {
                                    colorClass = "fill-amber";
                                } else {
                                    colorClass = "fill-red";
                                }
                            %>

                                <div class="bar-row">
                                    <div class="bar-name" title="<%=title%>"><%=title%></div>
                                    <div class="bar-track">
                                        <div class="bar-fill <%=colorClass%>" style="width:<%=String.format(java.util.Locale.US, "%.1f", mastery)%>%"></div>
                                    </div>
                                    <div class="bar-score"><%=String.format("%.1f", mastery)%>%</div>
                                </div>

                            <% } %>
                        </div>
                    </div>

                </div>

                <div>

                    <div class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">AI insight coach</div>
                                <div class="card-subtitle">
                                    Personalized interpretation generated from your current knowledge map.
                                </div>
                            </div>
                        </div>

                        <div class="ai-mini-grid">
                            <div class="ai-mini-card">
                                <div class="ai-mini-label">Weakest topic</div>
                                <div class="ai-mini-value">
                                    <% if (weakestTopic != null && !weakestTopic.isBlank() && weakestScore <= 100.0) { %>
                                        <%=weakestTopic%>
                                    <% } else { %>
                                        Not available
                                    <% } %>
                                </div>
                            </div>

                            <div class="ai-mini-card">
                                <div class="ai-mini-label">Weakest score</div>
                                <div class="ai-mini-value">
                                    <% if (weakestScore <= 100.0) { %>
                                        <%=String.format("%.1f", weakestScore)%>%
                                    <% } else { %>
                                        -
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <% if (aiInsightsText != null && !aiInsightsText.isBlank()) { %>
                            <div class="ai-insight-box">
                                <%=aiInsightsText.replace("\n", "<br>")%>
                            </div>
                        <% } else { %>
                            <div class="ai-warning-box">
                                No AI interpretation generated yet. Generate an AI analysis to receive a personalized diagnosis,
                                weak-topic explanation and concrete revision strategy.
                            </div>
                        <% } %>

                        <form method="post" action="<%=ctx%>/generate-insights-ai" class="ai-generate-form">
                            <textarea name="knowledgeMapText" style="display:none;"><%
                                for (Map<String,Object> m : map) {
                                    String title = String.valueOf(m.get("title"));

                                    double mastery = 0.0;
                                    Object masteryObj = m.get("mastery");

                                    if (masteryObj instanceof Number) {
                                        mastery = ((Number) masteryObj).doubleValue();
                                    }
                            %>Topic: <%=title%> | Mastery: <%=String.format("%.1f", mastery)%>%
<% } %></textarea>

                            <button class="btn btn-primary btn-full" type="submit">
                                Generate AI analysis and recommendations
                            </button>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">AI recommendations</div>
                                <div class="card-subtitle">
                                    Personalized recommendation cards generated by SmartStudy AI for each topic.
                                </div>
                            </div>
                        </div>

                        <% if (aiRecommendationCards != null && !aiRecommendationCards.isEmpty()) { %>

                            <div class="recommendation-list">
                                <% for (Map<String, String> rec : aiRecommendationCards) {
                                    String topic = rec.get("topic");
                                    String priority = rec.get("priority");
                                    String text = rec.get("text");

                                    if (topic == null) {
                                        topic = "Topic";
                                    }

                                    if (priority == null || priority.trim().isEmpty()) {
                                        priority = "MEDIUM";
                                    }

                                    if (text == null) {
                                        text = "";
                                    }

                                    String dotClass = "";

                                    if ("MEDIUM".equalsIgnoreCase(priority)) {
                                        dotClass = "medium";
                                    } else if ("LOW".equalsIgnoreCase(priority)) {
                                        dotClass = "good";
                                    }
                                %>

                                    <div class="recommendation-item">
                                        <div class="recommendation-dot <%=dotClass%>"></div>
                                        <div>
                                            <div class="recommendation-title">
                                                <%=priority%> priority: <%=topic%>
                                            </div>
                                            <div class="recommendation-text">
                                                <%=text%>
                                            </div>
                                        </div>
                                    </div>

                                <% } %>
                            </div>

                        <% } else { %>

                            <div class="ai-warning-box">
                                No AI recommendation cards generated yet. Click the button in the AI Insight Coach card to generate
                                personalized recommendations for every topic.
                            </div>

                        <% } %>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Suggested study path</div>
                                <div class="card-subtitle">
                                    A simple sequence for improving weak areas efficiently.
                                </div>
                            </div>
                        </div>

                        <div class="learning-plan">
                            <div class="plan-step">
                                <div class="step-number">1</div>
                                <div>
                                    <div class="step-title">Start with red topics</div>
                                    <div class="step-text">
                                        Review the materials connected to the lowest mastery scores before studying easier topics.
                                    </div>
                                </div>
                            </div>

                            <div class="plan-step">
                                <div class="step-number">2</div>
                                <div>
                                    <div class="step-title">Generate flashcards</div>
                                    <div class="step-text">
                                        Use flashcards for definitions, formulas and key concepts that appear repeatedly in mistakes.
                                    </div>
                                </div>
                            </div>

                            <div class="plan-step">
                                <div class="step-number">3</div>
                                <div>
                                    <div class="step-title">Repeat a short quiz</div>
                                    <div class="step-text">
                                        After revision, take a focused quiz to verify whether the mastery percentage improves.
                                    </div>
                                </div>
                            </div>

                            <div class="plan-step">
                                <div class="step-number">4</div>
                                <div>
                                    <div class="step-title">Recheck the map</div>
                                    <div class="step-text">
                                        Use the updated insight map to decide the next revision priority.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Quick actions</div>
                                <div class="card-subtitle">
                                    Act directly on your weak topics.
                                </div>
                            </div>
                        </div>

                        <div class="quick-action-grid">
                            <a class="quick-action-link" href="<%=ctx%>/flashcards">
                                Review flashcards
                                <span>→</span>
                            </a>

                            <a class="quick-action-link" href="<%=ctx%>/assessment">
                                Take a targeted quiz
                                <span>→</span>
                            </a>

                            <a class="quick-action-link" href="<%=ctx%>/materials">
                                Open learning materials
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

                </div>

            </section>

        <% } %>

    </main>
</div>

</body>
</html>
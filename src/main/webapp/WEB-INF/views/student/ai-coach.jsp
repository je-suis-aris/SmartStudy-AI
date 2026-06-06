<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.smartstudy.model.User" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — AI Coach</title>
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
        textarea {
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
            grid-template-columns: minmax(0, 1fr) 340px;
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
            font-size: 2.45rem;
            font-weight: 800;
            letter-spacing: -0.06em;
            line-height: 1;
        }

        .hero-panel-note {
            color: rgba(255,255,255,0.68);
            font-size: 0.86rem;
            margin-top: 8px;
        }

        .coach-metrics {
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
            min-height: 130px;
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
            font-size: 1.8rem;
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
            grid-template-columns: minmax(0, 1.45fr) minmax(340px, 0.55fr);
            gap: 24px;
            align-items: start;
        }

        .coach-left,
        .coach-right {
            display: grid;
            gap: 24px;
            align-content: start;
        }

        .coach-right {
            position: sticky;
            top: 92px;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            overflow: hidden;
        }

        .card-padding {
            padding: 24px;
        }

        .card-header {
            padding: 22px 24px 18px;
            border-bottom: 1px solid var(--rule);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 800;
            letter-spacing: -0.04em;
            color: var(--ink);
        }

        .section-subtitle {
            color: var(--ink-3);
            font-size: 0.9rem;
            margin-top: 4px;
            line-height: 1.6;
        }

        .coach-body {
            padding: 24px;
        }

        .suggestions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }

        .suggestion-chip {
            border: 1px solid #dbe4ef;
            background: #f8fbff;
            color: var(--primary);
            border-radius: 999px;
            padding: 9px 12px;
            font-size: 0.8rem;
            font-weight: 700;
            cursor: pointer;
            transition: 0.18s ease;
        }

        .suggestion-chip:hover {
            background: var(--primary-soft);
            transform: translateY(-1px);
        }

        .question-input {
            width: 100%;
            min-height: 150px;
            max-height: 280px;
            resize: vertical;
            border: 1.5px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 18px;
            padding: 16px;
            font-size: 0.95rem;
            color: var(--ink);
            outline: none;
            transition: 0.2s ease;
            line-height: 1.7;
        }

        .question-input:focus {
            background: white;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(31, 58, 95, 0.12);
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            align-items: center;
            margin-top: 16px;
            flex-wrap: wrap;
        }

        .helper-text {
            color: var(--ink-4);
            font-size: 0.8rem;
        }

        .btn {
            border: none;
            background: var(--primary);
            color: white;
            min-height: 48px;
            padding: 0 20px;
            border-radius: 14px;
            font-size: 0.92rem;
            font-weight: 800;
            cursor: pointer;
            transition: 0.18s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            white-space: nowrap;
        }

        .btn:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: white;
            color: var(--ink-2);
            border: 1px solid var(--rule);
        }

        .btn-secondary:hover {
            background: var(--primary-soft);
            color: var(--primary);
            border-color: #d8e3f1;
        }

        .error-box {
            margin-top: 16px;
            border-radius: 16px;
            padding: 14px 16px;
            background: var(--red-bg);
            color: var(--red);
            border: 1px solid #fecaca;
            font-size: 0.9rem;
        }

        .answer-card {
            margin-top: 0;
        }

        .question-box {
            background: #f9fafb;
            border: 1px solid var(--rule);
            border-radius: 18px;
            padding: 16px;
            margin-bottom: 16px;
            color: var(--ink-2);
            line-height: 1.7;
        }

        .answer {
            background: var(--primary-soft);
            border: 1px solid #dbe7f5;
            color: var(--primary-dark);
            border-radius: 18px;
            padding: 18px;
            line-height: 1.8;
            font-size: 0.94rem;
        }

        .answer-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 16px;
        }

        .side-card {
            padding: 24px;
        }

        .support-list {
            display: grid;
            gap: 12px;
            margin-top: 16px;
        }

        .support-item {
            border: 1px solid var(--rule);
            background: #fbfcfe;
            border-radius: 16px;
            padding: 14px;
        }

        .support-item-title {
            font-size: 0.92rem;
            font-weight: 800;
            color: var(--ink);
            margin-bottom: 4px;
        }

        .support-item-text {
            font-size: 0.84rem;
            color: var(--ink-3);
            line-height: 1.55;
        }

        .mini-badge {
            display: inline-flex;
            padding: 5px 10px;
            border-radius: 999px;
            background: var(--primary-soft);
            color: var(--primary);
            font-size: 0.74rem;
            font-weight: 800;
            margin-top: 10px;
        }

        .cta-box {
            background: linear-gradient(135deg, #10243d 0%, #1f3a5f 100%);
            color: white;
            border-radius: 26px;
            padding: 24px;
            box-shadow: var(--shadow-strong);
        }

        .cta-box h3 {
            font-size: 1.18rem;
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: -0.03em;
        }

        .cta-box p {
            color: rgba(255,255,255,0.74);
            font-size: 0.88rem;
            line-height: 1.65;
            margin-bottom: 14px;
        }

        .cta-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: white;
            color: var(--primary-dark);
            border-radius: 12px;
            padding: 10px 14px;
            font-size: 0.84rem;
            font-weight: 800;
            transition: 0.18s ease;
        }

        .cta-link:hover {
            background: #eef3f9;
            transform: translateY(-1px);
        }

        @media (max-width: 1180px) {
            .hero {
                grid-template-columns: 1fr;
            }

            .coach-metrics {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .layout {
                grid-template-columns: 1fr;
            }

            .coach-right {
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

            .coach-metrics {
                grid-template-columns: 1fr;
            }

            .form-actions {
                align-items: stretch;
                flex-direction: column;
            }

            .btn {
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

    boolean isAdmin = "ADMIN".equalsIgnoreCase(currentUser.getRole());

    String fullName = currentUser.getFullName() == null ? "Student" : currentUser.getFullName();
    String role = currentUser.getRole() == null ? "STUDENT" : currentUser.getRole();
    String profilePhoto = currentUser.getProfilePhoto();

    String initials = "ST";

    if (fullName != null && !fullName.trim().isEmpty()) {
        String[] parts = fullName.trim().split("\\s+");

        if (parts.length >= 2) {
            initials = parts[0].substring(0, 1).toUpperCase()
                    + parts[1].substring(0, 1).toUpperCase();
        } else {
            initials = fullName.substring(0, 1).toUpperCase();
        }
    }

    String question = (String) request.getAttribute("question");
    String answer = (String) request.getAttribute("answer");
    String error = (String) request.getAttribute("error");
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
            <a href="<%=ctx%>/profile">Profile</a>
            <a href="<%=ctx%>/chat">Support</a>
            <a href="<%=ctx%>/ai-coach" class="active">AI Coach</a>

            <% if (isAdmin) { %>
                <a href="<%=ctx%>/admin/dashboard" class="admin-view-link">Admin view</a>
            <% } %>

            <a href="<%=ctx%>/logout">Logout</a>
        </div>

        <a href="<%=ctx%>/profile" class="nav-avatar" title="Profile">
            <% if (profilePhoto != null && !profilePhoto.trim().isEmpty()) { %>
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
                <div class="hero-kicker">Personal AI coach</div>
                <h1>Ask AI about your progress.</h1>
                <p>
                    Ask what to study next, how ready you are for an exam, why your score is low,
                    what weak topics to revise first or how to organize your learning plan.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Coach mode</div>
                <div class="hero-panel-value">Personalized</div>
                <div class="hero-panel-note">
                    Uses your courses, quiz results, planner tasks and learning resources.
                </div>
            </div>
        </section>

        <section class="coach-metrics">
            <div class="metric-card">
                <div class="metric-label">Advice type</div>
                <div class="metric-value">Study plan</div>
                <div class="metric-sub">Ask for what to revise next.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Exam focus</div>
                <div class="metric-value">Readiness</div>
                <div class="metric-sub">Ask how prepared you are.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Weak topics</div>
                <div class="metric-value">Explained</div>
                <div class="metric-sub">Ask why your score is low.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Learning tools</div>
                <div class="metric-value">AI + Quiz</div>
                <div class="metric-sub">Combine AI, flashcards and assessment.</div>
            </div>
        </section>

        <section class="layout">

            <div class="coach-left">

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Ask a learning question</div>
                            <div class="section-subtitle">
                                The AI coach uses your learning context to generate practical study guidance.
                            </div>
                        </div>
                    </div>

                    <div class="coach-body">

                        <div class="suggestions">
                            <button type="button" class="suggestion-chip" onclick="fillQuestion('What should I study today based on my current progress?')">
                                What should I study today?
                            </button>

                            <button type="button" class="suggestion-chip" onclick="fillQuestion('How ready am I for my exam and what should I improve?')">
                                How ready am I for my exam?
                            </button>

                            <button type="button" class="suggestion-chip" onclick="fillQuestion('Why is my score low and how can I improve it?')">
                                Why is my score low?
                            </button>

                            <button type="button" class="suggestion-chip" onclick="fillQuestion('What should I revise first and why?')">
                                What should I revise first?
                            </button>

                            <button type="button" class="suggestion-chip" onclick="fillQuestion('Create a 3-day personalized revision plan for me.')">
                                Create a 3-day plan
                            </button>
                        </div>

                        <form method="post" action="<%=ctx%>/ai-coach">
                            <textarea
                                    id="questionInput"
                                    name="question"
                                    class="question-input"
                                    placeholder="Write your question here..."
                                    required
                            ><%=question == null ? "" : question%></textarea>

                            <div class="form-actions">
                                <div class="helper-text">
                                    Tip: mention the course, exam date or weak topic for a more precise answer.
                                </div>

                                <button type="submit" class="btn">
                                    Ask AI Coach →
                                </button>
                            </div>
                        </form>

                        <% if (error != null && !error.trim().isEmpty()) { %>
                            <div class="error-box">
                                <strong>Error:</strong> <%=error%>
                            </div>
                        <% } %>

                    </div>
                </section>

                <% if (answer != null && !answer.trim().isEmpty()) { %>
                    <section class="card answer-card">
                        <div class="card-header">
                            <div>
                                <div class="section-title">AI Coach answer</div>
                                <div class="section-subtitle">
                                    Personalized response generated from your learning context.
                                </div>
                            </div>
                        </div>

                        <div class="coach-body">
                            <% if (question != null && !question.trim().isEmpty()) { %>
                                <div class="question-box">
                                    <strong>Your question:</strong><br>
                                    <%=question%>
                                </div>
                            <% } %>

                            <div class="answer">
                                <%=answer.replace("\n", "<br>")%>
                            </div>

                            <div class="answer-actions">
                                <a href="<%=ctx%>/insights" class="btn btn-secondary">Open Insights</a>
                                <a href="<%=ctx%>/planner" class="btn btn-secondary">Open Planner</a>
                                <a href="<%=ctx%>/flashcards" class="btn btn-secondary">Review Flashcards</a>
                                <a href="<%=ctx%>/assessment" class="btn btn-secondary">Take Quiz</a>
                            </div>
                        </div>
                    </section>
                <% } %>

            </div>

            <aside class="coach-right">

                <section class="card side-card">
                    <div class="section-title">Best questions to ask</div>
                    <div class="section-subtitle">
                        Use AI Coach for strategic learning guidance, not just simple definitions.
                    </div>

                    <div class="support-list">
                        <div class="support-item">
                            <div class="support-item-title">Revision strategy</div>
                            <div class="support-item-text">
                                Ask what to study first, how to split your time and how to avoid wasting effort.
                            </div>
                            <div class="mini-badge">Study plan</div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Weak topic explanation</div>
                            <div class="support-item-text">
                                Ask why a topic is difficult and what concepts you should review before retaking a quiz.
                            </div>
                            <div class="mini-badge">Insights</div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Exam readiness</div>
                            <div class="support-item-text">
                                Ask if your current score, study time and quiz history suggest that you are ready.
                            </div>
                            <div class="mini-badge">Performance</div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Learning workflow</div>
                            <div class="support-item-text">
                                Ask how to combine summaries, flashcards, quizzes and planner tasks efficiently.
                            </div>
                            <div class="mini-badge">Workflow</div>
                        </div>
                    </div>
                </section>

                <section class="card side-card">
                    <div class="section-title">How to get better answers</div>
                    <div class="section-subtitle">
                        Add context to your question.
                    </div>

                    <div class="support-list">
                        <div class="support-item">
                            <div class="support-item-title">Mention the course</div>
                            <div class="support-item-text">
                                Example: Java, BD2, Web Programming, Management or another uploaded subject.
                            </div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Mention the objective</div>
                            <div class="support-item-text">
                                Example: exam preparation, quiz improvement, final revision or weekly planning.
                            </div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Mention your problem</div>
                            <div class="support-item-text">
                                Example: low score, lack of time, too many materials, unclear concepts or weak topics.
                            </div>
                        </div>
                    </div>
                </section>

                <section class="cta-box">
                    <h3>Need data-based insights?</h3>
                    <p>
                        Use the Insights page to see detected weak topics, mastery levels and AI-generated recommendations.
                    </p>
                    <a href="<%=ctx%>/insights" class="cta-link">Open Insights →</a>
                </section>

            </aside>

        </section>

    </main>
</div>

<script>
    function fillQuestion(text) {
        const input = document.getElementById("questionInput");

        if (input) {
            input.value = text;
            input.focus();
        }
    }
</script>

</body>
</html>
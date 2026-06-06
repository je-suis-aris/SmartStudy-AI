<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.*" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Assessment</title>
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
            --amber: #b7791f;
            --amber-bg: #fffbeb;
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
        input,
        select,
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
            min-height: 100vh;
            padding-top: 68px;
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
            grid-template-columns: minmax(0, 1fr) 350px;
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
            max-width: 830px;
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

        .alert {
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 20px;
            font-size: 0.88rem;
        }

        .alert-success {
            background: var(--green-bg);
            color: var(--green);
            border: 1px solid #bbf7d0;
        }

        .alert-danger {
            background: var(--red-bg);
            color: var(--red);
            border: 1px solid #fecaca;
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
            padding: 22px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            min-height: 145px;
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
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .metric-value {
            margin-top: 12px;
            color: var(--ink);
            font-size: 2.15rem;
            font-weight: 800;
            letter-spacing: -0.055em;
            line-height: 1;
        }

        .metric-sub {
            color: var(--ink-3);
            font-size: 0.82rem;
            margin-top: 8px;
        }

        .layout {
            display: grid;
            grid-template-columns: minmax(330px, 0.78fr) minmax(0, 1.22fr);
            gap: 24px;
            align-items: start;
        }

        .left-column {
            display: grid;
            gap: 24px;
            align-content: start;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 26px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 1.15rem;
            font-weight: 800;
            letter-spacing: -0.035em;
            color: var(--ink);
        }

        .card-subtitle {
            color: var(--ink-3);
            font-size: 0.86rem;
            margin-top: 4px;
        }

        .field {
            display: grid;
            gap: 7px;
            margin-bottom: 14px;
        }

        .field-label {
            color: var(--ink-2);
            font-size: 0.82rem;
            font-weight: 800;
        }

        .field-control,
        .textarea-control {
            width: 100%;
            border: 1.5px solid var(--rule);
            border-radius: 13px;
            background: var(--surface-soft);
            color: var(--ink);
            outline: none;
            font-size: 0.9rem;
            transition: 0.2s;
        }

        .field-control {
            height: 44px;
            padding: 0 14px;
        }

        .textarea-control {
            min-height: 96px;
            padding: 12px 14px;
            resize: vertical;
        }

        .field-control:focus,
        .textarea-control:focus {
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px var(--primary-soft);
        }

        .answer-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
        }

        .btn-primary-full {
            width: 100%;
            border: none;
            border-radius: 13px;
            background: var(--primary);
            color: white;
            font-size: 0.9rem;
            font-weight: 800;
            padding: 12px 16px;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-primary-full:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .course-list,
        .material-list {
            display: grid;
            gap: 12px;
        }

        .course-action {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 15px 16px;
            border: 1px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 16px;
            transition: 0.2s;
        }

        .course-action:hover {
            border-color: var(--primary);
            background: var(--primary-soft);
            transform: translateY(-2px);
        }

        .course-name {
            font-weight: 800;
            color: var(--ink);
            font-size: 0.92rem;
        }

        .course-meta {
            color: var(--ink-3);
            font-size: 0.78rem;
            margin-top: 2px;
        }

        .start-pill {
            background: var(--primary);
            color: white;
            padding: 7px 11px;
            border-radius: 999px;
            font-size: 0.76rem;
            font-weight: 800;
            white-space: nowrap;
        }

        .material-form {
            margin-bottom: 12px;
        }

        .material-button {
            width: 100%;
            text-align: left;
            border: 1px solid var(--rule);
            background: white;
            border-radius: 16px;
            padding: 15px 16px;
            cursor: pointer;
            transition: 0.2s;
            font-family: 'Geist', Arial, sans-serif;
        }

        .material-button:hover {
            border-color: var(--green);
            background: var(--green-bg);
            transform: translateY(-2px);
        }

        .material-title {
            color: var(--ink);
            font-size: 0.9rem;
            font-weight: 800;
        }

        .material-meta {
            color: var(--ink-3);
            font-size: 0.78rem;
            margin-top: 3px;
        }

        .ai-tag {
            display: inline-flex;
            align-items: center;
            width: fit-content;
            background: var(--green-bg);
            color: var(--green);
            font-size: 0.72rem;
            font-weight: 800;
            border-radius: 999px;
            padding: 4px 9px;
            margin-top: 8px;
        }

        .question-row {
            border: 1px solid var(--rule);
            border-radius: 18px;
            background: #ffffff;
            padding: 16px 18px;
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 16px;
            align-items: start;
            transition: 0.2s;
        }

        .question-row:hover {
            box-shadow: var(--shadow);
            transform: translateY(-2px);
        }

        .question-text {
            color: var(--ink);
            font-size: 0.93rem;
            font-weight: 700;
            line-height: 1.55;
        }

        .answer-list {
            margin-top: 10px;
            display: grid;
            gap: 6px;
        }

        .answer-item {
            font-size: 0.8rem;
            color: var(--ink-3);
            background: #f8fafc;
            border: 1px solid var(--rule);
            border-radius: 10px;
            padding: 7px 9px;
        }

        .answer-item.correct {
            background: var(--green-bg);
            color: var(--green);
            border-color: #bbf7d0;
            font-weight: 800;
        }

        .question-meta {
            display: flex;
            gap: 8px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .pill {
            display: inline-flex;
            align-items: center;
            width: fit-content;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 800;
        }

        .pill-ai {
            background: var(--green-bg);
            color: var(--green);
        }

        .pill-manual {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .pill-type {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .question-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            align-items: flex-end;
        }

        .small-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--rule);
            background: white;
            color: var(--ink-2);
            border-radius: 11px;
            padding: 7px 10px;
            font-size: 0.76rem;
            font-weight: 800;
            white-space: nowrap;
        }

        .small-btn:hover {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-soft);
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

        .search-row {
            display: flex;
            gap: 10px;
            margin-bottom: 18px;
        }

        .search-input {
            flex: 1;
            height: 42px;
            border: 1.5px solid var(--rule);
            border-radius: 13px;
            background: var(--surface-soft);
            padding: 0 14px;
            outline: none;
            font-size: 0.88rem;
        }

        .search-input:focus {
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px var(--primary-soft);
        }

        .info-box {
            border: 1px solid var(--primary-soft);
            background: var(--primary-soft);
            border-radius: 18px;
            padding: 18px;
        }

        .info-title {
            font-size: 0.92rem;
            font-weight: 800;
            color: var(--primary-dark);
        }

        .info-text {
            color: var(--ink-3);
            font-size: 0.84rem;
            margin-top: 5px;
            line-height: 1.6;
        }

        .course-question-group {
            border: 1px solid var(--rule);
            border-radius: 20px;
            background: #ffffff;
            overflow: hidden;
            margin-bottom: 14px;
            transition: 0.2s;
        }

        .course-question-group:hover {
            box-shadow: var(--shadow);
        }

        .course-question-header {
            width: 100%;
            border: none;
            background: #ffffff;
            padding: 18px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            cursor: pointer;
            font-family: 'Geist', Arial, sans-serif;
            text-align: left;
        }

        .course-question-title {
            font-size: 1rem;
            font-weight: 800;
            color: var(--ink);
        }

        .course-question-meta {
            font-size: 0.8rem;
            color: var(--ink-3);
            margin-top: 3px;
        }

        .course-question-count {
            background: var(--primary-soft);
            color: var(--primary);
            padding: 6px 11px;
            border-radius: 999px;
            font-size: 0.76rem;
            font-weight: 800;
            white-space: nowrap;
        }

        .course-question-arrow {
            color: var(--ink-3);
            font-size: 1rem;
            transition: 0.2s;
        }

        .course-question-header.active .course-question-arrow {
            transform: rotate(180deg);
        }

        .course-question-content {
            display: none;
            padding: 0 18px 18px;
            border-top: 1px solid var(--rule);
            background: #fafafa;
        }

        .course-question-content.open {
            display: grid;
            gap: 12px;
        }

        .course-question-content .question-row {
            margin-top: 12px;
            background: #ffffff;
        }

        @media (max-width: 1180px) {
            .hero {
                grid-template-columns: 1fr;
            }

            .metric-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .layout {
                grid-template-columns: 1fr;
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

            .metric-grid,
            .answer-grid {
                grid-template-columns: 1fr;
            }

            .question-row {
                grid-template-columns: 1fr;
            }

            .question-actions {
                align-items: flex-start;
                flex-direction: row;
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

    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Material> materials = (List<Material>) request.getAttribute("materials");
    List<Question> questions = (List<Question>) request.getAttribute("questions");

    if (courses == null) {
        courses = new ArrayList<Course>();
    }

    if (materials == null) {
        materials = new ArrayList<Material>();
    }

    if (questions == null) {
        questions = new ArrayList<Question>();
    }

    int aiQuestions = 0;

    for (Question q : questions) {
        if (q.isGeneratedByAi()) {
            aiQuestions++;
        }
    }

    int manualQuestions = Math.max(0, questions.size() - aiQuestions);

    Map<Integer, List<Question>> questionsByCourse = new LinkedHashMap<Integer, List<Question>>();

    for (Course c : courses) {
        questionsByCourse.put(c.getId(), new ArrayList<Question>());
    }

    List<Question> questionsWithoutCourse = new ArrayList<Question>();

    for (Question q : questions) {
        int courseId = q.getCourseId();

        if (questionsByCourse.containsKey(courseId)) {
            questionsByCourse.get(courseId).add(q);
        } else {
            questionsWithoutCourse.add(q);
        }
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
            <a href="<%=ctx%>/assessment" class="active">Assessment</a>
            <a href="<%=ctx%>/flashcards">Flashcards</a>
            <a href="<%=ctx%>/insights">Insights</a>
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
                <div class="hero-kicker">Assessment center</div>
                <h1>Generate, organize and practice smarter quizzes.</h1>
                <p>
                    Use your uploaded materials to create AI-generated questions, add manual questions,
                    then start quizzes by course and track your weak topics.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Question bank</div>
                <div class="hero-panel-value"><%=questions.size()%></div>
                <div class="hero-panel-note">
                    <%=aiQuestions%> AI-generated · <%=manualQuestions%> manual
                </div>
            </div>
        </section>

        <% if (request.getParameter("manualAdded") != null) { %>
            <div class="alert alert-success">
                Manual question saved successfully.
            </div>
        <% } %>

        <% if (request.getParameter("manualError") != null) { %>
            <div class="alert alert-danger">
                Manual question could not be saved. Please complete all required fields.
            </div>
        <% } %>

        <% if (request.getParameter("generated") != null) { %>
            <div class="alert alert-success">
                AI questions were generated successfully.
            </div>
        <% } %>

        <section class="metric-grid">
            <div class="metric-card">
                <div class="metric-label">Courses ready</div>
                <div class="metric-value"><%=courses.size()%></div>
                <div class="metric-sub">Courses available for quiz practice.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Materials saved</div>
                <div class="metric-value"><%=materials.size()%></div>
                <div class="metric-sub">Documents that can generate questions.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">AI questions</div>
                <div class="metric-value"><%=aiQuestions%></div>
                <div class="metric-sub">Questions produced from uploaded content.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Manual questions</div>
                <div class="metric-value"><%=manualQuestions%></div>
                <div class="metric-sub">Questions created directly by the user.</div>
            </div>
        </section>

        <section class="layout">

            <div class="left-column">

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Start a quiz</div>
                            <div class="card-subtitle">Choose a course and begin assessment.</div>
                        </div>
                    </div>

                    <% if (courses.isEmpty()) { %>
                        <div class="empty-state">
                            <h3>No courses available</h3>
                            <p>Add a course or upload material first.</p>
                        </div>
                    <% } else { %>
                        <div class="course-list">
                            <% for (Course c : courses) { %>
                                <a class="course-action" href="<%=ctx%>/take-quiz?courseId=<%=c.getId()%>">
                                    <div>
                                        <div class="course-name"><%=c.getTitle()%></div>
                                        <div class="course-meta">Start a quiz using saved questions</div>
                                    </div>
                                    <span class="start-pill">Start</span>
                                </a>
                            <% } %>
                        </div>
                    <% } %>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Add manual question</div>
                            <div class="card-subtitle">
                                Write your own multiple-choice question and store it in the question bank.
                            </div>
                        </div>
                    </div>

                    <% if (courses.isEmpty()) { %>
                        <div class="empty-state">
                            <h3>No course available</h3>
                            <p>Create or upload a course first, then add manual questions.</p>
                        </div>
                    <% } else { %>
                        <form method="post" action="<%=ctx%>/add-manual-question">

                            <div class="field">
                                <label class="field-label" for="manualCourseId">Course</label>
                                <select id="manualCourseId" name="courseId" class="field-control" required>
                                    <% for (Course c : courses) { %>
                                        <option value="<%=c.getId()%>"><%=c.getTitle()%></option>
                                    <% } %>
                                </select>
                            </div>

                            <div class="field">
                                <label class="field-label" for="questionText">Question text</label>
                                <textarea
                                        id="questionText"
                                        name="questionText"
                                        class="textarea-control"
                                        placeholder="Example: What is the role of a servlet in a Java web application?"
                                        required></textarea>
                            </div>

                            <div class="answer-grid">
                                <div class="field">
                                    <label class="field-label" for="optionA">Option A</label>
                                    <input id="optionA" name="optionA" class="field-control" required>
                                </div>

                                <div class="field">
                                    <label class="field-label" for="optionB">Option B</label>
                                    <input id="optionB" name="optionB" class="field-control" required>
                                </div>

                                <div class="field">
                                    <label class="field-label" for="optionC">Option C</label>
                                    <input id="optionC" name="optionC" class="field-control" required>
                                </div>

                                <div class="field">
                                    <label class="field-label" for="optionD">Option D</label>
                                    <input id="optionD" name="optionD" class="field-control" required>
                                </div>
                            </div>

                            <div class="field">
                                <label class="field-label" for="correctAnswer">Correct answer</label>
                                <select id="correctAnswer" name="correctAnswer" class="field-control" required>
                                    <option value="A">A</option>
                                    <option value="B">B</option>
                                    <option value="C">C</option>
                                    <option value="D">D</option>
                                </select>
                            </div>

                            <div class="field">
                                <label class="field-label" for="explanation">Explanation</label>
                                <textarea
                                        id="explanation"
                                        name="explanation"
                                        class="textarea-control"
                                        placeholder="Optional explanation shown after the quiz."></textarea>
                            </div>

                            <button class="btn-primary-full" type="submit">
                                Save manual question
                            </button>
                        </form>
                    <% } %>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Generate questions with AI</div>
                            <div class="card-subtitle">Create questions from saved course materials.</div>
                        </div>
                    </div>

                    <% if (materials.isEmpty()) { %>
                        <div class="empty-state">
                            <h3>No materials uploaded</h3>
                            <p>Upload a PDF or text material before generating questions.</p>
                        </div>
                    <% } else { %>
                        <div class="material-list">
                            <% for (Material m : materials) { %>
                                <form method="post" action="<%=ctx%>/generate-questions" class="material-form">
                                    <input type="hidden" name="materialId" value="<%=m.getId()%>">
                                    <input type="hidden" name="action" value="questions">

                                    <button class="material-button" type="submit">
                                        <div class="material-title"><%=m.getTitle()%></div>
                                        <div class="material-meta">Generate quiz questions from this material</div>
                                        <span class="ai-tag">AI generation</span>
                                    </button>
                                </form>
                            <% } %>
                        </div>
                    <% } %>
                </div>

                <div class="info-box">
                    <div class="info-title">Recommended workflow</div>
                    <div class="info-text">
                        Upload a material, generate AI questions or add manual questions, then start a quiz from the related course.
                        After submitting the quiz, your results will appear in Stats and help detect weak topics.
                    </div>
                </div>

            </div>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="card-title">Question bank by course</div>
                        <div class="card-subtitle">
                            Questions are grouped by course. Click a course to expand its question list.
                        </div>
                    </div>
                </div>

                <div class="search-row">
                    <input id="questionSearch" class="search-input" type="text" placeholder="Search courses or questions..." oninput="filterQuestions()">
                </div>

                <% if (questions.isEmpty()) { %>

                    <div class="empty-state">
                        <h3>No questions generated yet</h3>
                        <p>Generate AI questions from uploaded materials or add a manual question.</p>
                    </div>

                <% } else { %>

                    <div id="questionBank">

                        <% for (Course c : courses) {
                            List<Question> courseQuestions = questionsByCourse.get(c.getId());

                            if (courseQuestions == null || courseQuestions.isEmpty()) {
                                continue;
                            }

                            int courseAiQuestions = 0;

                            for (Question q : courseQuestions) {
                                if (q.isGeneratedByAi()) {
                                    courseAiQuestions++;
                                }
                            }
                        %>

                            <div class="course-question-group searchable-question-group">

                                <button type="button" class="course-question-header" onclick="toggleCourseQuestions(this)">
                                    <div>
                                        <div class="course-question-title"><%=c.getTitle()%></div>
                                        <div class="course-question-meta">
                                            <%=courseQuestions.size()%> question<%=courseQuestions.size() == 1 ? "" : "s"%>
                                            · <%=courseAiQuestions%> AI-generated
                                            · <%=courseQuestions.size() - courseAiQuestions%> manual
                                        </div>
                                    </div>

                                    <div style="display:flex;align-items:center;gap:10px;">
                                        <span class="course-question-count"><%=courseQuestions.size()%></span>
                                        <span class="course-question-arrow">⌄</span>
                                    </div>
                                </button>

                                <div class="course-question-content">

                                    <% for (Question q : courseQuestions) {
                                        boolean generated = q.isGeneratedByAi();
                                        String correct = q.getCorrectAnswer() == null ? "" : q.getCorrectAnswer().trim().toUpperCase();
                                    %>

                                        <div class="question-row searchable-question">
                                            <div>
                                                <div class="question-text"><%=q.getQuestionText()%></div>

                                                <div class="answer-list">
                                                    <div class="answer-item <%= "A".equals(correct) ? "correct" : "" %>">
                                                        A. <%=q.getOptionA()%>
                                                    </div>
                                                    <div class="answer-item <%= "B".equals(correct) ? "correct" : "" %>">
                                                        B. <%=q.getOptionB()%>
                                                    </div>
                                                    <div class="answer-item <%= "C".equals(correct) ? "correct" : "" %>">
                                                        C. <%=q.getOptionC()%>
                                                    </div>
                                                    <div class="answer-item <%= "D".equals(correct) ? "correct" : "" %>">
                                                        D. <%=q.getOptionD()%>
                                                    </div>
                                                </div>

                                                <div class="question-meta">
                                                    <% if (generated) { %>
                                                        <span class="pill pill-ai">AI-generated</span>
                                                    <% } else { %>
                                                        <span class="pill pill-manual">Manual</span>
                                                    <% } %>

                                                    <span class="pill pill-type">Correct: <%=correct%></span>
                                                </div>
                                            </div>

                                            <div class="question-actions">
                                                <a class="small-btn" href="<%=ctx%>/take-quiz?courseId=<%=c.getId()%>">Practice</a>
                                            </div>
                                        </div>

                                    <% } %>

                                </div>
                            </div>

                        <% } %>

                        <% if (!questionsWithoutCourse.isEmpty()) { %>

                            <div class="course-question-group searchable-question-group">

                                <button type="button" class="course-question-header" onclick="toggleCourseQuestions(this)">
                                    <div>
                                        <div class="course-question-title">Unassigned questions</div>
                                        <div class="course-question-meta">
                                            Questions that are not linked to a specific course.
                                        </div>
                                    </div>

                                    <div style="display:flex;align-items:center;gap:10px;">
                                        <span class="course-question-count"><%=questionsWithoutCourse.size()%></span>
                                        <span class="course-question-arrow">⌄</span>
                                    </div>
                                </button>

                                <div class="course-question-content">

                                    <% for (Question q : questionsWithoutCourse) {
                                        boolean generated = q.isGeneratedByAi();
                                        String correct = q.getCorrectAnswer() == null ? "" : q.getCorrectAnswer().trim().toUpperCase();
                                    %>

                                        <div class="question-row searchable-question">
                                            <div>
                                                <div class="question-text"><%=q.getQuestionText()%></div>

                                                <div class="answer-list">
                                                    <div class="answer-item <%= "A".equals(correct) ? "correct" : "" %>">
                                                        A. <%=q.getOptionA()%>
                                                    </div>
                                                    <div class="answer-item <%= "B".equals(correct) ? "correct" : "" %>">
                                                        B. <%=q.getOptionB()%>
                                                    </div>
                                                    <div class="answer-item <%= "C".equals(correct) ? "correct" : "" %>">
                                                        C. <%=q.getOptionC()%>
                                                    </div>
                                                    <div class="answer-item <%= "D".equals(correct) ? "correct" : "" %>">
                                                        D. <%=q.getOptionD()%>
                                                    </div>
                                                </div>

                                                <div class="question-meta">
                                                    <% if (generated) { %>
                                                        <span class="pill pill-ai">AI-generated</span>
                                                    <% } else { %>
                                                        <span class="pill pill-manual">Manual</span>
                                                    <% } %>

                                                    <span class="pill pill-type">Correct: <%=correct%></span>
                                                </div>
                                            </div>

                                            <div class="question-actions">
                                                <a class="small-btn" href="<%=ctx%>/take-quiz">Practice</a>
                                            </div>
                                        </div>

                                    <% } %>

                                </div>
                            </div>

                        <% } %>

                    </div>

                <% } %>
            </div>

        </section>

    </main>
</div>

<script>
    function toggleCourseQuestions(button) {
        const content = button.nextElementSibling;

        button.classList.toggle("active");
        content.classList.toggle("open");
    }

    function filterQuestions() {
        const input = document.getElementById("questionSearch");
        const query = input.value.toLowerCase().trim();
        const groups = document.querySelectorAll(".searchable-question-group");

        groups.forEach(function(group) {
            const text = group.innerText.toLowerCase();
            const content = group.querySelector(".course-question-content");
            const header = group.querySelector(".course-question-header");

            if (text.includes(query)) {
                group.style.display = "block";

                if (query.length > 0) {
                    content.classList.add("open");
                    header.classList.add("active");
                }
            } else {
                group.style.display = "none";
            }

            if (query.length === 0) {
                content.classList.remove("open");
                header.classList.remove("active");
            }
        });
    }
</script>

</body>
</html>
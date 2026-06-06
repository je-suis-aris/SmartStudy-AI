<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Admin Courses</title>
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
            --blue: #1d4ed8;
            --blue-bg: #eff6ff;
            --shadow: 0 12px 35px rgba(15, 23, 42, 0.08);
            --shadow-strong: 0 18px 45px rgba(15, 23, 42, 0.14);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            width: 100%;
            overflow-x: hidden;
        }

        body {
            min-height: 100vh;
            width: 100%;
            overflow-x: hidden;
            font-family: 'Geist', Arial, sans-serif;
            background:
                    radial-gradient(circle at top left, rgba(31, 58, 95, 0.07), transparent 32rem),
                    radial-gradient(circle at top right, rgba(59, 130, 246, 0.06), transparent 30rem),
                    var(--bg);
            color: var(--ink);
            font-size: 15px;
            line-height: 1.6;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        button,
        input,
        textarea,
        select {
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
            min-width: 0;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-right: auto;
            font-size: 1.12rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            white-space: nowrap;
            color: var(--ink);
            flex-shrink: 0;
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

        .admin-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 9px;
            border-radius: 999px;
            background: var(--primary);
            color: white;
            font-size: 0.66rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 3px;
            min-width: 0;
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

        .student-view-link {
            background: var(--primary);
            color: white !important;
            font-weight: 800 !important;
        }

        .student-view-link:hover {
            background: var(--primary-dark) !important;
            color: white !important;
        }

        .main {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
            padding: 34px 32px 70px;
        }

        .hero {
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #10243d 0%, #1f3a5f 100%);
            color: white;
            border-radius: 30px;
            padding: 40px;
            margin-bottom: 26px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 32px;
            align-items: center;
            box-shadow: var(--shadow-strong);
        }

        .hero::before {
            content: "";
            position: absolute;
            right: -120px;
            top: -150px;
            width: 390px;
            height: 390px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.06);
        }

        .hero::after {
            content: "";
            position: absolute;
            right: 70px;
            bottom: -130px;
            width: 280px;
            height: 280px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.04);
        }

        .hero-left,
        .hero-panel {
            position: relative;
            z-index: 1;
            min-width: 0;
        }

        .hero-kicker {
            color: rgba(255, 255, 255, 0.56);
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 0.14em;
            text-transform: uppercase;
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
            max-width: 780px;
            color: rgba(255, 255, 255, 0.72);
            font-size: 1rem;
            line-height: 1.75;
        }

        .hero-actions {
            margin-top: 24px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .hero-panel {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.14);
            border-radius: 24px;
            padding: 24px;
            backdrop-filter: blur(10px);
        }

        .hero-panel-label {
            color: rgba(255, 255, 255, 0.58);
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 0.11em;
            text-transform: uppercase;
            margin-bottom: 12px;
        }

        .hero-panel-value {
            font-size: 2.85rem;
            line-height: 1;
            font-weight: 800;
            letter-spacing: -0.06em;
        }

        .hero-panel-note {
            margin-top: 8px;
            color: rgba(255, 255, 255, 0.68);
            font-size: 0.86rem;
        }

        .btn {
            border: none;
            border-radius: 12px;
            padding: 10px 15px;
            font-size: 0.82rem;
            font-weight: 800;
            cursor: pointer;
            transition: 0.18s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
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

        .btn-light {
            background: white;
            color: var(--primary-dark);
        }

        .btn-light:hover {
            background: var(--primary-soft);
            transform: translateY(-1px);
        }

        .btn-ghost-light {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.14);
            color: white;
        }

        .btn-ghost-light:hover {
            background: rgba(255, 255, 255, 0.14);
            transform: translateY(-1px);
        }

        .btn-danger {
            background: var(--red-bg);
            color: var(--red);
        }

        .btn-danger:hover {
            filter: brightness(0.98);
            transform: translateY(-1px);
        }

        .btn-soft {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .btn-soft:hover {
            background: #e4edf8;
            transform: translateY(-1px);
        }

        .btn-message {
            background: var(--blue-bg);
            color: var(--blue);
        }

        .btn-message:hover {
            filter: brightness(0.98);
            transform: translateY(-1px);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 26px;
        }

        .stat-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 24px;
            padding: 24px;
            min-height: 145px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            transition: 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow);
        }

        .stat-label {
            color: var(--ink-3);
            font-size: 0.74rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.09em;
        }

        .stat-value {
            margin-top: 12px;
            color: var(--ink);
            font-size: 2.35rem;
            line-height: 1;
            font-weight: 800;
            letter-spacing: -0.06em;
        }

        .stat-sub {
            margin-top: 8px;
            color: var(--ink-3);
            font-size: 0.84rem;
        }

        .admin-layout {
            display: grid;
            grid-template-columns: minmax(380px, 450px) minmax(0, 1fr);
            gap: 24px;
            align-items: start;
            width: 100%;
        }

        .admin-left,
        .admin-right {
            min-width: 0;
            display: flex;
            flex-direction: column;
            gap: 24px;
            align-content: start;
        }

        .card {
            position: static;
            width: 100%;
            min-width: 0;
            height: auto;
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

        .card-title {
            color: var(--ink);
            font-size: 1.18rem;
            font-weight: 800;
            letter-spacing: -0.04em;
        }

        .card-subtitle {
            margin-top: 4px;
            color: var(--ink-3);
            font-size: 0.88rem;
            line-height: 1.6;
        }

        .field {
            margin-bottom: 14px;
        }

        .label {
            display: block;
            color: var(--ink-2);
            font-size: 0.8rem;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .input,
        .textarea,
        .select {
            width: 100%;
            border: 1.5px solid var(--rule);
            background: var(--surface-soft);
            color: var(--ink);
            border-radius: 12px;
            padding: 11px 13px;
            font-size: 0.9rem;
            outline: none;
            transition: 0.18s ease;
        }

        .textarea {
            min-height: 100px;
            resize: vertical;
            line-height: 1.6;
        }

        .input:focus,
        .textarea:focus,
        .select:focus {
            background: white;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(31, 58, 95, 0.12);
        }

        .help {
            color: var(--ink-4);
            font-size: 0.76rem;
            margin-top: 5px;
        }

        .jquery-note {
            color: var(--primary);
            background: var(--primary-soft);
            border: 1px solid #d8e5f5;
            border-radius: 12px;
            padding: 9px 11px;
            font-size: 0.78rem;
            font-weight: 700;
            margin-bottom: 14px;
        }

        .table-wrap {
            width: 100%;
            max-width: 100%;
            min-width: 0;
            overflow-x: auto;
            overflow-y: hidden;
            border: 1px solid var(--rule);
            border-radius: 18px;
            background: #fbfcfe;
        }

        table {
            width: 100%;
            min-width: 0;
            table-layout: fixed;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            color: var(--ink-3);
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            padding: 14px 16px;
            border-bottom: 1px solid var(--rule);
            white-space: nowrap;
        }

        td {
            padding: 15px 16px;
            border-bottom: 1px solid var(--rule);
            color: var(--ink-2);
            font-size: 0.88rem;
            vertical-align: middle;
            overflow-wrap: anywhere;
        }

        th:nth-child(1),
        td:nth-child(1) {
            width: 38%;
        }

        th:nth-child(2),
        td:nth-child(2) {
            width: 25%;
        }

        th:nth-child(3),
        td:nth-child(3) {
            width: 13%;
        }

        th:nth-child(4),
        td:nth-child(4) {
            width: 13%;
        }

        th:nth-child(5),
        td:nth-child(5) {
            width: 11%;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background: white;
        }

        .course-title {
            color: var(--ink);
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .course-desc {
            color: var(--ink-3);
            font-size: 0.78rem;
            margin-top: 3px;
            max-width: 100%;
            overflow-wrap: anywhere;
        }

        .student-chip {
            display: inline-flex;
            flex-direction: column;
            gap: 1px;
            max-width: 100%;
        }

        .student-name {
            color: var(--ink);
            font-weight: 700;
            overflow-wrap: anywhere;
        }

        .student-email {
            color: var(--ink-4);
            font-size: 0.76rem;
            overflow-wrap: anywhere;
        }

        .badge {
            display: inline-flex;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .badge.easy {
            background: var(--green-bg);
            color: var(--green);
        }

        .badge.medium {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .badge.hard {
            background: var(--red-bg);
            color: var(--red);
        }

        .badge.blue {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .student-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .student-card,
        .side-item {
            border: 1px solid var(--rule);
            border-radius: 18px;
            background: #fbfcfe;
            padding: 16px;
            min-width: 0;
        }

        .student-card-name,
        .side-title {
            color: var(--ink);
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .student-card-email,
        .side-text {
            color: var(--ink-4);
            font-size: 0.78rem;
            margin-top: 2px;
            line-height: 1.55;
            overflow-wrap: anywhere;
        }

        .student-card-count {
            margin-top: 14px;
            font-size: 1.8rem;
            font-weight: 800;
            letter-spacing: -0.06em;
        }

        .student-card-label {
            color: var(--ink-3);
            font-size: 0.78rem;
        }

        .empty {
            border: 1px dashed #cbd5e1;
            border-radius: 18px;
            padding: 22px;
            background: #fbfcfe;
            color: var(--ink-3);
            font-size: 0.88rem;
            line-height: 1.65;
        }

        .quick-actions {
            display: grid;
            gap: 10px;
        }

        .quick-actions a {
            justify-content: flex-start;
            min-height: 44px;
            font-size: 0.86rem;
        }

        .hidden-row {
            display: none;
        }

        @media (max-width: 1320px) {
            .main {
                max-width: 1180px;
            }

            .admin-layout {
                grid-template-columns: minmax(340px, 410px) minmax(0, 1fr);
            }

            th,
            td {
                padding: 13px 12px;
            }
        }

        @media (max-width: 1180px) {
            .hero,
            .admin-layout {
                grid-template-columns: 1fr;
            }

            .stats-grid,
            .student-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .hero-panel {
                max-width: 380px;
            }

            table {
                min-width: 820px;
                table-layout: auto;
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

            .brand {
                font-size: 1rem;
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

            .stats-grid,
            .student-grid {
                grid-template-columns: 1fr;
            }

            .card {
                padding: 20px;
            }

            .card-header {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>
<%
    String ctx = request.getContextPath();

    List<Map<String, Object>> courses = (List<Map<String, Object>>) request.getAttribute("courses");
    List<Map<String, Object>> students = (List<Map<String, Object>>) request.getAttribute("students");
    List<Map<String, Object>> studentCourseStats = (List<Map<String, Object>>) request.getAttribute("studentCourseStats");

    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    Integer mediumCourses = (Integer) request.getAttribute("mediumCourses");
    Integer hardCourses = (Integer) request.getAttribute("hardCourses");

    if (courses == null) courses = new ArrayList<Map<String, Object>>();
    if (students == null) students = new ArrayList<Map<String, Object>>();
    if (studentCourseStats == null) studentCourseStats = new ArrayList<Map<String, Object>>();

    if (totalCourses == null) totalCourses = courses.size();
    if (totalStudents == null) totalStudents = students.size();
    if (mediumCourses == null) mediumCourses = 0;
    if (hardCourses == null) hardCourses = 0;
%>

<nav class="nav">
    <div class="nav-inner">
        <a href="<%=ctx%>/admin/dashboard" class="brand">
            <img src="<%=ctx%>/assets/img/Logo.png?v=100" alt="SmartStudy AI" class="brand-logo">
            <span class="brand-text">SmartStudy <span>AI</span></span>
            <span class="admin-pill">Admin</span>
        </a>

        <div class="nav-links">
            <a href="<%=ctx%>/admin/dashboard">Dashboard</a>
            <a href="<%=ctx%>/admin/users">Users</a>
            <a href="<%=ctx%>/admin/courses" class="active">Courses</a>
            <a href="<%=ctx%>/admin/chat">Messages</a>
            <a href="<%=ctx%>/admin/profile">Admin profile</a>
            <a href="<%=ctx%>/dashboard?preview=admin" class="student-view-link">Student view</a>
            <a href="<%=ctx%>/logout">Logout</a>
        </div>
    </div>
</nav>

<div class="page">
    <main class="main">

        <section class="hero">
            <div class="hero-left">
                <div class="hero-kicker">Course administration</div>
                <h1>Manage courses and student enrolments.</h1>
                <p>
                    Create course objectives for students, monitor exam dates, assign learning difficulty
                    and keep a clear overview of how many courses each student follows.
                </p>

                <div class="hero-actions">
                    <a href="<%=ctx%>/admin/dashboard" class="btn btn-light">Admin dashboard</a>
                    <a href="<%=ctx%>/admin/users" class="btn btn-ghost-light">Manage users</a>
                    <a href="<%=ctx%>/admin/chat" class="btn btn-ghost-light">Messages</a>
                    <a href="<%=ctx%>/dashboard?preview=admin" class="btn btn-ghost-light">Open student view</a>
                </div>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Total courses</div>
                <div class="hero-panel-value"><%=totalCourses%></div>
                <div class="hero-panel-note">Courses currently assigned to students.</div>
            </div>
        </section>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Courses</div>
                <div class="stat-value"><%=totalCourses%></div>
                <div class="stat-sub">Total configured courses</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Students</div>
                <div class="stat-value"><%=totalStudents%></div>
                <div class="stat-sub">Available student accounts</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Medium difficulty</div>
                <div class="stat-value"><%=mediumCourses%></div>
                <div class="stat-sub">Courses marked as medium</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Hard difficulty</div>
                <div class="stat-value"><%=hardCourses%></div>
                <div class="stat-sub">Courses needing extra attention</div>
            </div>
        </section>

        <section class="admin-layout">

            <div class="admin-left">

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Assign a new course</div>
                            <div class="card-subtitle">
                                Create a course for a selected student. The course will appear in the student's planner and materials flow.
                            </div>
                        </div>
                    </div>

                    <form method="post" action="<%=ctx%>/admin/courses">
                        <input type="hidden" name="action" value="create">

                        <div class="field">
                            <label class="label">Student</label>
                            <select name="studentId" class="select" required>
                                <option value="">Select student...</option>
                                <% for (Map<String, Object> s : students) { %>
                                    <option value="<%=s.get("id")%>">
                                        <%=s.get("full_name")%> — <%=s.get("email")%>
                                    </option>
                                <% } %>
                            </select>
                            <div class="help">The selected student will be enrolled in this course.</div>
                        </div>

                        <div class="field">
                            <label class="label">Course title</label>
                            <input name="title" class="input" placeholder="Example: Web Programming II" required>
                        </div>

                        <div class="field">
                            <label class="label">Description</label>
                            <textarea name="description" class="textarea" placeholder="Short description of the course objectives, topics or exam requirements..."></textarea>
                        </div>

                        <div class="field">
                            <label class="label">Exam date</label>
                            <input type="date" name="examDate" class="input" required>
                        </div>

                        <div class="field">
                            <label class="label">Difficulty</label>
                            <select name="difficulty" class="select">
                                <option value="EASY">Easy</option>
                                <option value="MEDIUM" selected>Medium</option>
                                <option value="HARD">Hard</option>
                            </select>
                        </div>

                        <button class="btn btn-primary" type="submit">Create course</button>
                    </form>
                </section>

                <section class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Admin actions</div>
                            <div class="card-subtitle">
                                Quick links for course supervision.
                            </div>
                        </div>
                    </div>

                    <div class="quick-actions">
                        <a href="<%=ctx%>/admin/dashboard" class="btn btn-primary">📊 Admin dashboard</a>
                        <a href="<%=ctx%>/admin/users" class="btn btn-soft">👥 Manage users</a>
                        <a href="<%=ctx%>/admin/chat" class="btn btn-message">💬 Messages</a>
                        <a href="<%=ctx%>/dashboard?preview=admin" class="btn btn-soft">🎓 Open student view</a>
                    </div>
                </section>

                <section class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Course rules</div>
                            <div class="card-subtitle">
                                How course assignment works.
                            </div>
                        </div>
                    </div>

                    <div class="student-grid">
                        <div class="side-item">
                            <div class="side-title">Student-specific courses</div>
                            <div class="side-text">
                                Each course is assigned to one student and appears in that student's learning workspace.
                            </div>
                        </div>

                        <div class="side-item">
                            <div class="side-title">Exam date tracking</div>
                            <div class="side-text">
                                Exam dates help the planner prioritize revision tasks.
                            </div>
                        </div>

                        <div class="side-item">
                            <div class="side-title">Difficulty level</div>
                            <div class="side-text">
                                Difficulty can help administrators detect courses needing extra support.
                            </div>
                        </div>

                        <div class="side-item">
                            <div class="side-title">Materials connection</div>
                            <div class="side-text">
                                Uploaded materials can later be linked to the student's course flow.
                            </div>
                        </div>
                    </div>
                </section>

            </div>

            <div class="admin-right">

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Courses library</div>
                            <div class="card-subtitle">
                                Overview of all courses assigned to students.
                            </div>
                        </div>
                    </div>

                    <div class="field">
                        <label class="label">Search course</label>
                        <input type="text" id="courseSearch" class="input"
                               placeholder="Search by course title, student, exam date or difficulty...">
                        <div class="help">
                            This dynamic search uses the jQuery JavaScript library.
                        </div>
                    </div>

                    <div class="jquery-note">
                        jQuery is used here to filter the database records displayed in the table without reloading the page.
                    </div>

                    <div class="table-wrap">
                        <table id="coursesTable">
                            <thead>
                            <tr>
                                <th>Course</th>
                                <th>Student</th>
                                <th>Exam date</th>
                                <th>Difficulty</th>
                                <th>Actions</th>
                            </tr>
                            </thead>

                            <tbody>
                            <% if (!courses.isEmpty()) {
                                for (Map<String, Object> c : courses) {
                                    String difficulty = c.get("difficulty") == null ? "MEDIUM" : String.valueOf(c.get("difficulty"));
                                    String diffClass = difficulty.toLowerCase();

                                    if (!diffClass.equals("easy") && !diffClass.equals("medium") && !diffClass.equals("hard")) {
                                        diffClass = "medium";
                                    }
                            %>
                                <tr class="course-row">
                                    <td>
                                        <div class="course-title"><%=c.get("title") == null ? "Untitled course" : c.get("title")%></div>
                                        <div class="course-desc"><%=c.get("description") == null ? "" : c.get("description")%></div>
                                    </td>

                                    <td>
                                        <div class="student-chip">
                                            <span class="student-name"><%=c.get("student_name") == null ? "Unknown student" : c.get("student_name")%></span>
                                            <span class="student-email"><%=c.get("student_email") == null ? "-" : c.get("student_email")%></span>
                                        </div>
                                    </td>

                                    <td><%=c.get("exam_date") == null ? "-" : c.get("exam_date")%></td>

                                    <td>
                                        <span class="badge <%=diffClass%>"><%=difficulty%></span>
                                    </td>

                                    <td>
                                        <form method="post" action="<%=ctx%>/admin/courses"
                                              onsubmit="return confirm('Are you sure you want to delete this course?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="courseId" value="<%=c.get("id")%>">
                                            <button class="btn btn-danger" type="submit">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            <%  }
                            } else { %>
                                <tr>
                                    <td colspan="5">No courses found.</td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </section>

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Courses per student</div>
                            <div class="card-subtitle">
                                Quick overview of how many courses each student currently has.
                            </div>
                        </div>
                    </div>

                    <% if (!studentCourseStats.isEmpty()) { %>
                        <div class="student-grid">
                            <% for (Map<String, Object> s : studentCourseStats) { %>
                                <div class="student-card">
                                    <div class="student-card-name"><%=s.get("full_name") == null ? "Unnamed student" : s.get("full_name")%></div>
                                    <div class="student-card-email"><%=s.get("email") == null ? "-" : s.get("email")%></div>
                                    <div class="student-card-count"><%=s.get("total_courses")%></div>
                                    <div class="student-card-label">assigned courses</div>

                                    <div style="margin-top:14px;">
                                        <a href="<%=ctx%>/admin/student-details?id=<%=s.get("student_id")%>" class="btn btn-soft">
                                            View evolution
                                        </a>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="empty">
                            No student accounts found.
                        </div>
                    <% } %>
                </section>

            </div>

        </section>

    </main>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>
    $(document).ready(function () {
        $("#courseSearch").on("keyup", function () {
            var value = $(this).val().toLowerCase().trim();

            $("#coursesTable tbody tr.course-row").each(function () {
                var rowText = $(this).text().toLowerCase();

                if (rowText.indexOf(value) > -1) {
                    $(this).removeClass("hidden-row");
                } else {
                    $(this).addClass("hidden-row");
                }
            });
        });
    });
</script>

</body>
</html>
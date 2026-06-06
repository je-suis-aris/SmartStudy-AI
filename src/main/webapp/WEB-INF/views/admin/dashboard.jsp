<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.User" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Admin Dashboard</title>
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

        body {
            min-height: 100vh;
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
            background: rgba(255,255,255,0.96);
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
            max-width: 1320px;
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
            color: rgba(255,255,255,0.56);
            font-size: 0.74rem;
            font-weight: 800;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            margin-bottom: 14px;
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
            font-size: 2.85rem;
            font-weight: 800;
            line-height: 1;
            letter-spacing: -0.06em;
        }

        .hero-panel-note {
            margin-top: 8px;
            color: rgba(255,255,255,0.68);
            font-size: 0.86rem;
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
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            transition: 0.2s;
            min-height: 145px;
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
            letter-spacing: 0.1em;
        }

        .stat-value {
            margin-top: 12px;
            font-size: 2.35rem;
            line-height: 1;
            font-weight: 800;
            letter-spacing: -0.06em;
        }

        .stat-sub {
            color: var(--ink-3);
            font-size: 0.84rem;
            margin-top: 8px;
        }

        .admin-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.35fr) minmax(350px, 0.65fr);
            gap: 24px;
            align-items: start;
        }

        .admin-left,
        .admin-right {
            display: grid;
            gap: 24px;
            align-content: start;
        }

        .admin-right {
            position: sticky;
            top: 92px;
        }

        .monitoring-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 24px;
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
            gap: 18px;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .compact-card .card-header {
            margin-bottom: 16px;
        }

        .card-title {
            font-size: 1.18rem;
            font-weight: 800;
            letter-spacing: -0.04em;
        }

        .card-subtitle {
            color: var(--ink-3);
            font-size: 0.88rem;
            margin-top: 4px;
            line-height: 1.6;
        }

        .btn {
            border: none;
            border-radius: 12px;
            padding: 10px 14px;
            font-size: 0.8rem;
            font-weight: 800;
            cursor: pointer;
            transition: 0.18s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
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

        .quick-actions {
            display: grid;
            gap: 10px;
        }

        .quick-actions a {
            justify-content: flex-start;
            min-height: 44px;
            font-size: 0.86rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 760px;
        }

        .table-wrap {
            overflow-x: auto;
        }

        th {
            text-align: left;
            color: var(--ink-3);
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            padding: 13px 10px;
            border-bottom: 1px solid var(--rule);
            white-space: nowrap;
        }

        td {
            padding: 14px 10px;
            border-bottom: 1px solid var(--rule);
            font-size: 0.88rem;
            color: var(--ink-2);
            vertical-align: middle;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .role {
            display: inline-flex;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
        }

        .role.admin {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .role.student {
            background: var(--green-bg);
            color: var(--green);
        }

        .request-card,
        .monitor-list,
        .activity-list {
            display: grid;
            gap: 12px;
        }

        .request-item,
        .monitor-item,
        .activity-item {
            border: 1px solid var(--rule);
            border-radius: 18px;
            padding: 16px;
            background: #fbfcfe;
        }

        .request-top,
        .monitor-top,
        .activity-top {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            align-items: flex-start;
            margin-bottom: 10px;
        }

        .request-name,
        .monitor-name,
        .activity-name {
            font-weight: 800;
            color: var(--ink);
        }

        .request-email,
        .monitor-meta,
        .activity-meta {
            color: var(--ink-3);
            font-size: 0.82rem;
            margin-top: 2px;
            line-height: 1.55;
        }

        .request-badge,
        .monitor-badge,
        .activity-badge {
            padding: 5px 9px;
            border-radius: 999px;
            font-size: 0.68rem;
            font-weight: 800;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .request-badge {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .monitor-badge.risk {
            background: var(--red-bg);
            color: var(--red);
        }

        .monitor-badge.ai {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .activity-badge {
            background: var(--blue-bg);
            color: var(--blue);
        }

        .request-reason {
            color: var(--ink-2);
            font-size: 0.86rem;
            line-height: 1.55;
            background: white;
            border: 1px solid var(--rule);
            border-radius: 14px;
            padding: 12px;
        }

        .request-meta {
            color: var(--ink-4);
            font-size: 0.76rem;
            margin-top: 8px;
        }

        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 12px;
        }

        .empty {
            border: 1px dashed #cbd5e1;
            border-radius: 18px;
            padding: 22px;
            color: var(--ink-3);
            background: #fbfcfe;
            font-size: 0.88rem;
            line-height: 1.65;
        }

        .health-grid {
            display: grid;
            gap: 12px;
        }

        .health-item {
            border: 1px solid var(--rule);
            border-radius: 16px;
            padding: 14px;
            background: #fbfcfe;
        }

        .health-label {
            color: var(--ink-3);
            font-size: 0.76rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .health-value {
            margin-top: 6px;
            color: var(--ink);
            font-size: 1rem;
            font-weight: 800;
        }

        .health-note {
            color: var(--ink-3);
            font-size: 0.82rem;
            margin-top: 4px;
        }

        @media (max-width: 1180px) {
            .hero,
            .admin-layout {
                grid-template-columns: 1fr;
            }

            .admin-right {
                position: static;
            }

            .stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .monitoring-grid {
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

            .hero h1 {
                font-size: 2.15rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<%
    String ctx = request.getContextPath();

    List<User> users = (List<User>) request.getAttribute("users");
    List<User> pendingAdminRequests = (List<User>) request.getAttribute("pendingAdminRequests");

    List<Map<String, Object>> atRiskStudents =
            (List<Map<String, Object>>) request.getAttribute("atRiskStudents");

    List<Map<String, Object>> recentMaterials =
            (List<Map<String, Object>>) request.getAttribute("recentMaterials");

    List<Map<String, Object>> recentActivities =
            (List<Map<String, Object>>) request.getAttribute("recentActivities");

    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    Integer totalAdmins = (Integer) request.getAttribute("totalAdmins");
    Integer pendingRequestsCount = (Integer) request.getAttribute("pendingRequestsCount");

    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    Integer totalMaterials = (Integer) request.getAttribute("totalMaterials");
    Integer totalQuizzes = (Integer) request.getAttribute("totalQuizzes");
    Integer totalFlashcards = (Integer) request.getAttribute("totalFlashcards");
    Integer totalGapAlerts = (Integer) request.getAttribute("totalGapAlerts");
    Integer totalStudyMinutes = (Integer) request.getAttribute("totalStudyMinutes");

    if (users == null) users = new ArrayList<User>();
    if (pendingAdminRequests == null) pendingAdminRequests = new ArrayList<User>();
    if (atRiskStudents == null) atRiskStudents = new ArrayList<Map<String, Object>>();
    if (recentMaterials == null) recentMaterials = new ArrayList<Map<String, Object>>();
    if (recentActivities == null) recentActivities = new ArrayList<Map<String, Object>>();

    if (totalUsers == null) totalUsers = 0;
    if (totalStudents == null) totalStudents = 0;
    if (totalAdmins == null) totalAdmins = 0;
    if (pendingRequestsCount == null) pendingRequestsCount = 0;

    if (totalCourses == null) totalCourses = 0;
    if (totalMaterials == null) totalMaterials = 0;
    if (totalQuizzes == null) totalQuizzes = 0;
    if (totalFlashcards == null) totalFlashcards = 0;
    if (totalGapAlerts == null) totalGapAlerts = 0;
    if (totalStudyMinutes == null) totalStudyMinutes = 0;
%>

<nav class="nav">
    <div class="nav-inner">
        <a href="<%=ctx%>/admin/dashboard" class="brand">
            <img src="<%=ctx%>/assets/img/Logo.png?v=100" alt="SmartStudy AI" class="brand-logo">
            <span class="brand-text">SmartStudy <span>AI</span></span>
            <span class="admin-pill">Admin</span>
        </a>

        <div class="nav-links">
            <a href="<%=ctx%>/admin/dashboard" class="active">Dashboard</a>
            <a href="<%=ctx%>/admin/users">Users</a>
            <a href="<%=ctx%>/admin/courses">Courses</a>
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
            <div class="hero-content">
                <div class="hero-kicker">Administration dashboard</div>
                <h1>Manage platform access and learning data.</h1>
                <p>
                    Monitor students, review administrator access requests, supervise uploaded materials
                    and identify learners who may need additional support.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Pending requests</div>
                <div class="hero-panel-value"><%=pendingRequestsCount%></div>
                <div class="hero-panel-note">
                    Administrator access requests waiting for review.
                </div>
            </div>
        </section>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Total users</div>
                <div class="stat-value"><%=totalUsers%></div>
                <div class="stat-sub">Registered accounts</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Students</div>
                <div class="stat-value"><%=totalStudents%></div>
                <div class="stat-sub">Learning accounts</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Administrators</div>
                <div class="stat-value"><%=totalAdmins%></div>
                <div class="stat-sub">Platform supervision accounts</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Courses</div>
                <div class="stat-value"><%=totalCourses%></div>
                <div class="stat-sub">Assigned learning tracks</div>
            </div>
        </section>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Materials</div>
                <div class="stat-value"><%=totalMaterials%></div>
                <div class="stat-sub">Uploaded resources</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Quizzes</div>
                <div class="stat-value"><%=totalQuizzes%></div>
                <div class="stat-sub">Completed quiz attempts</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Flashcards</div>
                <div class="stat-value"><%=totalFlashcards%></div>
                <div class="stat-sub">Generated study cards</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Gap alerts</div>
                <div class="stat-value"><%=totalGapAlerts%></div>
                <div class="stat-sub">Weakness indicators</div>
            </div>
        </section>

        <section class="admin-layout">

            <div class="admin-left">

                <section class="monitoring-grid">

                    <section class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">At-risk students</div>
                                <div class="card-subtitle">
                                    Students with weak quiz performance or repeated knowledge gaps.
                                </div>
                            </div>
                        </div>

                        <div class="monitor-list">
                            <% if (!atRiskStudents.isEmpty()) {
                                for (Map<String, Object> s : atRiskStudents) {
                                    double avgScore = 0.0;
                                    int gapAlerts = 0;

                                    if (s.get("avg_score") != null) {
                                        avgScore = Double.parseDouble(String.valueOf(s.get("avg_score")));
                                    }

                                    if (s.get("gap_alerts") != null) {
                                        gapAlerts = Integer.parseInt(String.valueOf(s.get("gap_alerts")));
                                    }
                            %>

                                <div class="monitor-item">
                                    <div class="monitor-top">
                                        <div>
                                            <div class="monitor-name">
                                                <%=s.get("full_name") == null ? "Unnamed student" : s.get("full_name")%>
                                            </div>

                                            <div class="monitor-meta">
                                                <%=s.get("email") == null ? "-" : s.get("email")%>
                                            </div>

                                            <div class="monitor-meta">
                                                Average score:
                                                <strong><%=String.format("%.0f", avgScore)%>%</strong>
                                                · Gap alerts:
                                                <strong><%=gapAlerts%></strong>
                                            </div>
                                        </div>

                                        <span class="monitor-badge risk">Needs attention</span>
                                    </div>

                                    <div class="actions">
                                        <a href="<%=ctx%>/admin/student-details?id=<%=s.get("student_id")%>" class="btn btn-soft">
                                            View evolution
                                        </a>
                                    </div>
                                </div>

                            <%  }
                            } else { %>

                                <div class="empty">
                                    No at-risk students detected at the moment.
                                </div>

                            <% } %>
                        </div>
                    </section>

                    <section class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Recent materials</div>
                                <div class="card-subtitle">
                                    Latest uploaded resources and AI processing status.
                                </div>
                            </div>
                        </div>

                        <div class="monitor-list">
                            <% if (!recentMaterials.isEmpty()) {
                                for (Map<String, Object> m : recentMaterials) {
                                    String aiStatus = m.get("ai_status") == null ? "UNKNOWN" : String.valueOf(m.get("ai_status"));
                            %>

                                <div class="monitor-item">
                                    <div class="monitor-top">
                                        <div>
                                            <div class="monitor-name">
                                                <%=m.get("title") == null ? "Untitled material" : m.get("title")%>
                                            </div>

                                            <div class="monitor-meta">
                                                Student:
                                                <strong><%=m.get("student_name") == null ? "-" : m.get("student_name")%></strong>
                                            </div>

                                            <div class="monitor-meta">
                                                Course:
                                                <strong><%=m.get("course_title") == null ? "-" : m.get("course_title")%></strong>
                                            </div>

                                            <div class="monitor-meta">
                                                Type:
                                                <%=m.get("material_type") == null ? "-" : m.get("material_type")%>
                                            </div>
                                        </div>

                                        <span class="monitor-badge ai"><%=aiStatus%></span>
                                    </div>
                                </div>

                            <%  }
                            } else { %>

                                <div class="empty">
                                    No uploaded materials found yet.
                                </div>

                            <% } %>
                        </div>
                    </section>

                </section>

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Administrator access requests</div>
                            <div class="card-subtitle">
                                Review users who requested administrator access during registration.
                            </div>
                        </div>
                    </div>

                    <div class="request-card">
                        <% if (!pendingAdminRequests.isEmpty()) {
                            for (User u : pendingAdminRequests) {
                        %>

                            <div class="request-item">
                                <div class="request-top">
                                    <div>
                                        <div class="request-name"><%=u.getFullName()%></div>
                                        <div class="request-email"><%=u.getEmail()%></div>
                                    </div>

                                    <div class="request-badge">Pending</div>
                                </div>

                                <div class="request-reason">
                                    <%=u.getAdminRequestReason() == null || u.getAdminRequestReason().isBlank()
                                            ? "No reason provided."
                                            : u.getAdminRequestReason()%>
                                </div>

                                <div class="request-meta">
                                    Requested at:
                                    <%=u.getAdminRequestCreatedAt() == null ? "-" : u.getAdminRequestCreatedAt()%>
                                </div>

                                <div class="actions">
                                    <form method="post" action="<%=ctx%>/admin/admin-request-decision">
                                        <input type="hidden" name="userId" value="<%=u.getId()%>">
                                        <input type="hidden" name="decision" value="approve">
                                        <button class="btn btn-primary" type="submit">Approve admin</button>
                                    </form>

                                    <form method="post" action="<%=ctx%>/admin/admin-request-decision">
                                        <input type="hidden" name="userId" value="<%=u.getId()%>">
                                        <input type="hidden" name="decision" value="reject">
                                        <button class="btn btn-danger" type="submit">Reject</button>
                                    </form>
                                </div>
                            </div>

                        <%  }
                        } else { %>

                            <div class="empty">
                                No pending administrator access requests.
                            </div>

                        <% } %>
                    </div>
                </section>

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Recent platform activity</div>
                            <div class="card-subtitle">
                                Latest actions detected across users, materials, quizzes and generated flashcards.
                            </div>
                        </div>
                    </div>

                    <div class="activity-list">
                        <% if (!recentActivities.isEmpty()) {
                            for (Map<String, Object> a : recentActivities) {
                        %>

                            <div class="activity-item">
                                <div class="activity-top">
                                    <div>
                                        <div class="activity-name">
                                            <%=a.get("actor") == null ? "Unknown user" : a.get("actor")%>
                                        </div>

                                        <div class="activity-meta">
                                            <%=a.get("details") == null ? "-" : a.get("details")%>
                                        </div>
                                    </div>

                                    <span class="activity-badge">
                                        <%=a.get("type") == null ? "Activity" : a.get("type")%>
                                    </span>
                                </div>
                            </div>

                        <%  }
                        } else { %>

                            <div class="empty">
                                No recent platform activity found.
                            </div>

                        <% } %>
                    </div>
                </section>

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Recent users</div>
                            <div class="card-subtitle">
                                Latest accounts registered in the platform.
                            </div>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table>
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Full name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Admin request</th>
                            </tr>
                            </thead>

                            <tbody>
                            <% if (!users.isEmpty()) {
                                int shown = 0;

                                for (User u : users) {
                                    if (shown >= 8) {
                                        break;
                                    }

                                    shown++;

                                    String userRole = u.getRole() == null ? "STUDENT" : u.getRole();
                                    boolean userIsAdmin = "ADMIN".equalsIgnoreCase(userRole);

                                    String status = u.getAdminRequestStatus() == null ? "NONE" : u.getAdminRequestStatus();
                            %>

                                <tr>
                                    <td><%=u.getId()%></td>
                                    <td><%=u.getFullName()%></td>
                                    <td><%=u.getEmail()%></td>
                                    <td>
                                        <span class="role <%=userIsAdmin ? "admin" : "student"%>">
                                            <%=userRole%>
                                        </span>
                                    </td>
                                    <td><%=status%></td>
                                </tr>

                            <%  }
                            } else { %>

                                <tr>
                                    <td colspan="5">No users found.</td>
                                </tr>

                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </section>

            </div>

            <aside class="admin-right">

                <section class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Admin actions</div>
                            <div class="card-subtitle">
                                Quick links for platform supervision.
                            </div>
                        </div>
                    </div>

                    <div class="quick-actions">
                        <a href="<%=ctx%>/admin/users" class="btn btn-primary">👥 Manage users</a>
                        <a href="<%=ctx%>/admin/courses" class="btn btn-soft">📚 Manage courses</a>
                        <a href="<%=ctx%>/dashboard?preview=admin" class="btn btn-soft">🎓 Open student view</a>
                        <a href="<%=ctx%>/logout" class="btn btn-danger">↪ Logout</a>
                    </div>
                </section>

                <section class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Security model</div>
                            <div class="card-subtitle">
                                How admin access works.
                            </div>
                        </div>
                    </div>

                    <div class="empty">
                        New users are created as students by default. Administrator access is only granted
                        after an existing admin approves the request.
                    </div>
                </section>

                <section class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Platform health</div>
                            <div class="card-subtitle">
                                Quick interpretation of current learning activity.
                            </div>
                        </div>
                    </div>

                    <div class="health-grid">
                        <div class="health-item">
                            <div class="health-label">Gap alerts</div>
                            <div class="health-value"><%=totalGapAlerts%> alerts</div>
                            <div class="health-note">Weakness indicators detected across students.</div>
                        </div>

                        <div class="health-item">
                            <div class="health-label">Quiz activity</div>
                            <div class="health-value"><%=totalQuizzes%> attempts</div>
                            <div class="health-note">Completed quiz attempts recorded in the platform.</div>
                        </div>

                        <div class="health-item">
                            <div class="health-label">Study time</div>
                            <div class="health-value"><%=totalStudyMinutes%> minutes</div>
                            <div class="health-note">Total minutes of tracked study activity.</div>
                        </div>
                    </div>
                </section>

            </aside>

        </section>

    </main>
</div>

</body>
</html>
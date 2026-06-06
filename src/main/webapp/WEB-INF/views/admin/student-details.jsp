<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.User" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Student Evolution</title>
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

        .nav {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
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
            margin-right: auto;
            font-size: 1.12rem;
            font-weight: 800;
            letter-spacing: -0.03em;
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
        }

        .nav-links a:hover,
        .nav-links a.active {
            color: var(--primary);
            background: var(--primary-soft);
        }

        .page {
            padding-top: 68px;
            min-height: 100vh;
        }

        .main {
            max-width: 1240px;
            margin: 0 auto;
            padding: 34px 28px 72px;
        }

        .hero {
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #10243d 0%, #1f3a5f 100%);
            color: white;
            border-radius: 30px;
            padding: 40px;
            margin-bottom: 24px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 330px;
            gap: 28px;
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

        .hero-left,
        .hero-panel {
            position: relative;
            z-index: 1;
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
            font-size: clamp(2.25rem, 4vw, 3.4rem);
            line-height: 1.05;
            letter-spacing: -0.06em;
            margin-bottom: 14px;
        }

        .hero p {
            max-width: 760px;
            color: rgba(255, 255, 255, 0.72);
            font-size: 1rem;
            line-height: 1.75;
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
            letter-spacing: 0.1em;
            text-transform: uppercase;
        }

        .hero-panel-value {
            margin-top: 12px;
            font-size: 2.6rem;
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

        .btn-soft {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .btn-soft:hover {
            background: #e4edf8;
            transform: translateY(-1px);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 24px;
            padding: 23px;
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

        .grid-two {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            gap: 24px;
            margin-bottom: 24px;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 26px;
            box-shadow: var(--shadow);
            margin-bottom: 24px;
        }

        .card-title {
            color: var(--ink);
            font-size: 1.18rem;
            font-weight: 800;
            letter-spacing: -0.04em;
            margin-bottom: 5px;
        }

        .card-subtitle {
            color: var(--ink-3);
            font-size: 0.88rem;
            margin-bottom: 18px;
        }

        .profile-grid {
            display: grid;
            grid-template-columns: 140px 1fr;
            gap: 14px;
        }

        .profile-label {
            color: var(--ink-4);
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .profile-value {
            color: var(--ink-2);
            font-size: 0.9rem;
        }

        .item-list {
            display: grid;
            gap: 12px;
        }

        .item {
            border: 1px solid var(--rule);
            border-radius: 18px;
            background: #fbfcfe;
            padding: 15px;
        }

        .item-top {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            align-items: flex-start;
            margin-bottom: 6px;
        }

        .item-title {
            color: var(--ink);
            font-weight: 800;
            font-size: 0.94rem;
        }

        .item-meta {
            color: var(--ink-4);
            font-size: 0.78rem;
        }

        .item-text {
            color: var(--ink-3);
            font-size: 0.86rem;
            margin-top: 6px;
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

        .badge.green {
            background: var(--green-bg);
            color: var(--green);
        }

        .badge.red {
            background: var(--red-bg);
            color: var(--red);
        }

        .badge.amber {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .badge.blue {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .badge.gray {
            background: var(--surface-soft);
            color: var(--ink-3);
        }

        .progress-track {
            height: 9px;
            background: var(--rule);
            border-radius: 999px;
            overflow: hidden;
            margin-top: 12px;
        }

        .progress-fill {
            height: 100%;
            border-radius: 999px;
            background: var(--primary);
        }

        .empty {
            border: 1px dashed #cbd5e1;
            border-radius: 18px;
            padding: 22px;
            background: #fbfcfe;
            color: var(--ink-3);
            font-size: 0.88rem;
        }

        @media (max-width: 1080px) {
            .hero,
            .grid-two {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 760px) {
            .nav {
                padding: 0 18px;
            }

            .nav-links {
                display: none;
            }

            .main {
                padding: 24px 18px 60px;
            }

            .hero {
                padding: 28px;
                border-radius: 24px;
            }

            .hero h1 {
                font-size: 2.1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .profile-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<%
    String ctx = request.getContextPath();

    User student = (User) request.getAttribute("student");

    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    Integer totalMaterials = (Integer) request.getAttribute("totalMaterials");
    Integer totalFlashcards = (Integer) request.getAttribute("totalFlashcards");
    Integer totalGapAlerts = (Integer) request.getAttribute("totalGapAlerts");
    Integer totalPlanTasks = (Integer) request.getAttribute("totalPlanTasks");
    Integer completedPlanTasks = (Integer) request.getAttribute("completedPlanTasks");
    Integer totalStudyMinutes = (Integer) request.getAttribute("totalStudyMinutes");
    Double averageScore = (Double) request.getAttribute("averageScore");

    List<Map<String, Object>> courses = (List<Map<String, Object>>) request.getAttribute("courses");
    List<Map<String, Object>> recentQuizzes = (List<Map<String, Object>>) request.getAttribute("recentQuizzes");
    List<Map<String, Object>> recentPlanTasks = (List<Map<String, Object>>) request.getAttribute("recentPlanTasks");
    List<Map<String, Object>> gapAlerts = (List<Map<String, Object>>) request.getAttribute("gapAlerts");
    List<Map<String, Object>> adaptiveFlashcards = (List<Map<String, Object>>) request.getAttribute("adaptiveFlashcards");

    if (totalCourses == null) totalCourses = 0;
    if (totalMaterials == null) totalMaterials = 0;
    if (totalFlashcards == null) totalFlashcards = 0;
    if (totalGapAlerts == null) totalGapAlerts = 0;
    if (totalPlanTasks == null) totalPlanTasks = 0;
    if (completedPlanTasks == null) completedPlanTasks = 0;
    if (totalStudyMinutes == null) totalStudyMinutes = 0;
    if (averageScore == null) averageScore = 0.0;

    if (courses == null) courses = new ArrayList<Map<String, Object>>();
    if (recentQuizzes == null) recentQuizzes = new ArrayList<Map<String, Object>>();
    if (recentPlanTasks == null) recentPlanTasks = new ArrayList<Map<String, Object>>();
    if (gapAlerts == null) gapAlerts = new ArrayList<Map<String, Object>>();
    if (adaptiveFlashcards == null) adaptiveFlashcards = new ArrayList<Map<String, Object>>();

    String studentName = student == null || student.getFullName() == null ? "Student" : student.getFullName();
    String studentEmail = student == null || student.getEmail() == null ? "-" : student.getEmail();
    String description = student == null || student.getDescription() == null || student.getDescription().isBlank()
            ? "No profile description added yet."
            : student.getDescription();

    String rhythm = student == null || student.getPreferredStudyRhythm() == null ? "Balanced revision" : student.getPreferredStudyRhythm();
    String style = student == null || student.getLearningStyle() == null ? "Mixed learning" : student.getLearningStyle();

    int completionPercent = 0;

    if (totalPlanTasks > 0) {
        completionPercent = (int) Math.round(completedPlanTasks * 100.0 / totalPlanTasks);
    }

    String readinessLabel = averageScore >= 70 ? "Good readiness" : averageScore >= 50 ? "Moderate readiness" : "Needs support";
%>

<nav class="nav">
    <div class="nav-inner">
        <a href="<%=ctx%>/admin/dashboard" class="brand">
            <img src="<%=ctx%>/assets/img/Logo.png?v=100" alt="SmartStudy AI" class="brand-logo">
            <span class="brand-text">SmartStudy <span>AI</span> Admin</span>
        </a>

        <div class="nav-links">
            <a href="<%=ctx%>/admin/dashboard">Dashboard</a>
            <a href="<%=ctx%>/admin/users">Users</a>
            <a href="<%=ctx%>/admin/courses">Courses</a>
            <a href="<%=ctx%>/dashboard">Student view</a>
            <a href="<%=ctx%>/logout">Logout</a>
        </div>
    </div>
</nav>

<div class="page">
    <main class="main">

        <section class="hero">
            <div class="hero-left">
                <div class="hero-kicker">Student monitoring</div>
                <h1><%=studentName%></h1>
                <p>
                    Administrative overview of this student's profile, study activity, quiz performance,
                    weak topics, planner progress and adaptive learning resources.
                </p>

                <div style="margin-top: 24px; display:flex; gap:12px; flex-wrap:wrap;">
                    <a href="<%=ctx%>/admin/users" class="btn btn-soft">Back to users</a>
                    <a href="<%=ctx%>/admin/dashboard" class="btn btn-primary">Admin dashboard</a>
                </div>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Preparation level</div>
                <div class="hero-panel-value"><%=String.format("%.0f", averageScore)%>%</div>
                <div class="hero-panel-note"><%=readinessLabel%> based on submitted quizzes</div>
            </div>
        </section>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Courses</div>
                <div class="stat-value"><%=totalCourses%></div>
                <div class="stat-sub">Active learning paths</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Study time</div>
                <div class="stat-value"><%=totalStudyMinutes%></div>
                <div class="stat-sub">Total minutes tracked</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Average score</div>
                <div class="stat-value"><%=String.format("%.0f", averageScore)%>%</div>
                <div class="stat-sub">Across quiz attempts</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Weak alerts</div>
                <div class="stat-value"><%=totalGapAlerts%></div>
                <div class="stat-sub">Detected knowledge gaps</div>
            </div>
        </section>

        <section class="grid-two">

            <section class="card">
                <div class="card-title">Profile overview</div>
                <div class="card-subtitle">Basic information and learning preferences.</div>

                <div class="profile-grid">
                    <div class="profile-label">Name</div>
                    <div class="profile-value"><%=studentName%></div>

                    <div class="profile-label">Email</div>
                    <div class="profile-value"><%=studentEmail%></div>

                    <div class="profile-label">Description</div>
                    <div class="profile-value"><%=description%></div>

                    <div class="profile-label">Study rhythm</div>
                    <div class="profile-value"><%=rhythm%></div>

                    <div class="profile-label">Learning style</div>
                    <div class="profile-value"><%=style%></div>

                    <div class="profile-label">Flashcards</div>
                    <div class="profile-value"><%=totalFlashcards%> generated cards</div>
                </div>
            </section>

            <section class="card">
                <div class="card-title">Planner completion</div>
                <div class="card-subtitle">Completed study tasks compared with total planned tasks.</div>

                <div class="item">
                    <div class="item-top">
                        <div>
                            <div class="item-title"><%=completedPlanTasks%> / <%=totalPlanTasks%> tasks completed</div>
                            <div class="item-meta">Planner progress</div>
                        </div>

                        <span class="badge <%=completionPercent >= 70 ? "green" : completionPercent >= 40 ? "amber" : "red"%>">
                            <%=completionPercent%>%
                        </span>
                    </div>

                    <div class="progress-track">
                        <div class="progress-fill" style="width:<%=completionPercent%>%"></div>
                    </div>
                </div>
            </section>

        </section>

        <section class="grid-two">

            <section class="card">
                <div class="card-title">Courses</div>
                <div class="card-subtitle">Courses connected to this student's account.</div>

                <div class="item-list">
                    <% if (!courses.isEmpty()) {
                        for (Map<String, Object> c : courses) {
                    %>
                        <div class="item">
                            <div class="item-top">
                                <div>
                                    <div class="item-title"><%=c.get("title") == null ? "Untitled course" : c.get("title")%></div>
                                    <div class="item-meta">Exam date: <%=c.get("exam_date") == null ? "-" : c.get("exam_date")%></div>
                                </div>
                                <span class="badge blue">Course</span>
                            </div>
                            <div class="item-text">
                                <%=c.get("description") == null ? "No description available." : c.get("description")%>
                            </div>
                        </div>
                    <%  }
                    } else { %>
                        <div class="empty">No courses found for this student.</div>
                    <% } %>
                </div>
            </section>

            <section class="card">
                <div class="card-title">Recent quiz results</div>
                <div class="card-subtitle">Latest submitted quiz attempts and scores.</div>

                <div class="item-list">
                    <% if (!recentQuizzes.isEmpty()) {
                        for (Map<String, Object> q : recentQuizzes) {
                            int score = q.get("score") == null ? 0 : Integer.parseInt(String.valueOf(q.get("score")));
                            int total = q.get("total_questions") == null ? 0 : Integer.parseInt(String.valueOf(q.get("total_questions")));
                            int percent = total > 0 ? (int) Math.round(score * 100.0 / total) : 0;
                    %>
                        <div class="item">
                            <div class="item-top">
                                <div>
                                    <div class="item-title"><%=q.get("course_title") == null ? "Course" : q.get("course_title")%></div>
                                    <div class="item-meta">Score: <%=score%> / <%=total%></div>
                                </div>

                                <span class="badge <%=percent >= 70 ? "green" : percent >= 50 ? "amber" : "red"%>">
                                    <%=percent%>%
                                </span>
                            </div>
                        </div>
                    <%  }
                    } else { %>
                        <div class="empty">No quiz results found for this student.</div>
                    <% } %>
                </div>
            </section>

        </section>

        <section class="grid-two">

            <section class="card">
                <div class="card-title">Recent study plan tasks</div>
                <div class="card-subtitle">Latest planned activities and completion status.</div>

                <div class="item-list">
                    <% if (!recentPlanTasks.isEmpty()) {
                        for (Map<String, Object> t : recentPlanTasks) {
                            boolean completed = false;

                            if (t.get("completed") != null) {
                                String v = String.valueOf(t.get("completed"));
                                completed = "1".equals(v) || "true".equalsIgnoreCase(v);
                            }
                    %>
                        <div class="item">
                            <div class="item-top">
                                <div>
                                    <div class="item-title"><%=t.get("task_title") == null ? "Study task" : t.get("task_title")%></div>
                                    <div class="item-meta">
                                        <%=t.get("course_title") == null ? "Course" : t.get("course_title")%>
                                        · <%=t.get("plan_date") == null ? "-" : t.get("plan_date")%>
                                        · <%=t.get("estimated_minutes") == null ? "0" : t.get("estimated_minutes")%> min
                                    </div>
                                </div>

                                <span class="badge <%=completed ? "green" : "amber"%>">
                                    <%=completed ? "Completed" : "Pending"%>
                                </span>
                            </div>

                            <div class="item-text">
                                <%=t.get("description") == null ? "" : t.get("description")%>
                            </div>
                        </div>
                    <%  }
                    } else { %>
                        <div class="empty">No study plan tasks found for this student.</div>
                    <% } %>
                </div>
            </section>

            <section class="card">
                <div class="card-title">Knowledge gap alerts</div>
                <div class="card-subtitle">Weak topics detected from low scores or failed attempts.</div>

                <div class="item-list">
                    <% if (!gapAlerts.isEmpty()) {
                        for (Map<String, Object> g : gapAlerts) {
                            String severity = g.get("severity") == null ? "MEDIUM" : String.valueOf(g.get("severity"));
                    %>
                        <div class="item">
                            <div class="item-top">
                                <div class="item-title"><%=g.get("message") == null ? "Knowledge gap detected." : g.get("message")%></div>

                                <span class="badge <%=severity.equalsIgnoreCase("HIGH") ? "red" : severity.equalsIgnoreCase("MEDIUM") ? "amber" : "blue"%>">
                                    <%=severity%>
                                </span>
                            </div>
                        </div>
                    <%  }
                    } else { %>
                        <div class="empty">No active knowledge gap alerts for this student.</div>
                    <% } %>
                </div>
            </section>

        </section>

        <section class="card">
            <div class="card-title">Recent adaptive flashcards</div>
            <div class="card-subtitle">Latest generated flashcards, including those created from quiz mistakes.</div>

            <div class="item-list">
                <% if (!adaptiveFlashcards.isEmpty()) {
                    for (Map<String, Object> f : adaptiveFlashcards) {
                        String source = f.get("generation_source") == null ? "AI" : String.valueOf(f.get("generation_source"));
                %>
                    <div class="item">
                        <div class="item-top">
                            <div>
                                <div class="item-title"><%=f.get("front_text") == null ? "Flashcard" : f.get("front_text")%></div>
                                <div class="item-meta">
                                    Source: <%=source%>
                                    · Created at: <%=f.get("created_at") == null ? "-" : f.get("created_at")%>
                                </div>
                            </div>

                            <span class="badge <%=source.equalsIgnoreCase("WEAKNESS_AI") ? "red" : "blue"%>">
                                <%=source%>
                            </span>
                        </div>

                        <div class="item-text">
                            <%=f.get("back_text") == null ? "" : f.get("back_text")%>
                        </div>
                    </div>
                <%  }
                } else { %>
                    <div class="empty">No flashcards found for this student.</div>
                <% } %>
            </div>
        </section>

    </main>
</div>

</body>
</html>
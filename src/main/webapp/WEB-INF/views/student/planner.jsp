<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,java.time.*,com.smartstudy.model.*" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Planner</title>
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
            --blue-bg: #eff6ff;
            --blue: #1d4ed8;
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
        select {
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

        .grid {
            display: grid;
            grid-template-columns: minmax(340px, 0.78fr) minmax(0, 1.22fr);
            gap: 24px;
            margin-bottom: 24px;
            align-items: start;
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

        .planner-form {
            display: grid;
            gap: 16px;
        }

        .field {
            display: grid;
            gap: 7px;
        }

        .field-label {
            color: var(--ink-2);
            font-size: 0.82rem;
            font-weight: 800;
        }

        .field-control {
            width: 100%;
            height: 44px;
            border: 1.5px solid var(--rule);
            border-radius: 13px;
            background: var(--surface-soft);
            color: var(--ink);
            padding: 0 14px;
            outline: none;
            font-size: 0.9rem;
            transition: 0.2s;
        }

        .field-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-soft);
            background: #ffffff;
        }

        .difficulty-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
        }

        .difficulty-option {
            position: relative;
        }

        .difficulty-option input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .difficulty-pill {
            height: 42px;
            border: 1.5px solid var(--rule);
            border-radius: 13px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--ink-3);
            font-size: 0.82rem;
            font-weight: 800;
            background: var(--surface-soft);
            cursor: pointer;
            transition: 0.2s;
        }

        .difficulty-option input:checked + .difficulty-pill {
            border-color: var(--primary);
            background: var(--primary-soft);
            color: var(--primary);
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

        .btn-secondary {
            background: white;
            color: var(--ink-2);
            border-color: var(--rule);
        }

        .btn-secondary:hover {
            border-color: var(--ink-4);
            transform: translateY(-1px);
        }

        .btn-full {
            width: 100%;
            height: 46px;
            margin-top: 4px;
        }

        .btn-small {
            padding: 7px 10px;
            border-radius: 10px;
            font-size: 0.74rem;
        }

        .btn-start {
            background: var(--primary);
            color: white;
        }

        .btn-finish {
            background: var(--green);
            color: white;
        }

        .btn-reset {
            background: white;
            color: var(--ink-3);
            border-color: var(--rule);
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 20px;
        }

        .summary-card {
            border: 1px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 18px;
            padding: 16px;
        }

        .summary-label {
            color: var(--ink-3);
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .summary-value {
            margin-top: 6px;
            color: var(--ink);
            font-size: 1.45rem;
            font-weight: 800;
            letter-spacing: -0.04em;
            line-height: 1;
        }

        .summary-note {
            margin-top: 5px;
            color: var(--ink-4);
            font-size: 0.78rem;
        }

        .timeline {
            display: grid;
            gap: 12px;
        }

        .task-row {
            display: grid;
            grid-template-columns: 120px minmax(0, 1fr) 120px 180px;
            gap: 14px;
            align-items: center;
            border: 1px solid var(--rule);
            background: #ffffff;
            border-radius: 18px;
            padding: 15px 16px;
            transition: 0.2s;
        }

        .task-row:hover {
            box-shadow: var(--shadow);
            transform: translateY(-2px);
        }

        .task-row.task-done {
            background: #f8fafc;
            opacity: 0.88;
        }

        .task-row.task-done .task-title {
            text-decoration: line-through;
            color: var(--ink-3);
        }

        .task-date {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .task-date-main {
            font-size: 0.86rem;
            font-weight: 800;
            color: var(--ink);
        }

        .task-date-sub {
            font-size: 0.72rem;
            color: var(--ink-4);
        }

        .task-main {
            min-width: 0;
        }

        .task-course {
            color: var(--primary);
            font-size: 0.74rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.07em;
        }

        .task-title {
            color: var(--ink);
            font-size: 0.94rem;
            font-weight: 700;
            margin-top: 2px;
        }

        .task-description {
            margin-top: 5px;
            color: var(--ink-3);
            font-size: 0.8rem;
            line-height: 1.45;
        }

        .task-meta-row {
            display: flex;
            gap: 7px;
            flex-wrap: wrap;
            margin-top: 8px;
        }

        .task-time {
            justify-self: start;
            background: var(--primary-soft);
            color: var(--primary);
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 800;
            white-space: nowrap;
            display: inline-flex;
            margin-bottom: 6px;
        }

        .real-time-pill {
            background: #ecfdf5;
            color: #047857;
        }

        .planned-time-pill {
            background: #f8fafc;
            color: #64748b;
        }

        .status-pill {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 0.76rem;
            font-weight: 800;
            white-space: nowrap;
        }

        .status-done {
            background: var(--green-bg);
            color: var(--green);
        }

        .status-todo {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .status-progress {
            background: var(--blue-bg);
            color: var(--blue);
        }

        .task-actions {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
            flex-wrap: wrap;
        }

        .badge-ai {
            background: #ecfdf5;
            color: #047857;
            padding: 4px 8px;
            border-radius: 999px;
            font-size: 0.68rem;
            font-weight: 800;
        }

        .badge-rule {
            background: #fffbeb;
            color: #92400e;
            padding: 4px 8px;
            border-radius: 999px;
            font-size: 0.68rem;
            font-weight: 800;
        }

        .badge-priority {
            background: #f1f5f9;
            color: #334155;
            padding: 4px 8px;
            border-radius: 999px;
            font-size: 0.68rem;
            font-weight: 800;
        }

        .side-section {
            display: grid;
            gap: 24px;
        }

        .mini-list {
            display: grid;
            gap: 12px;
        }

        .mini-item {
            display: flex;
            gap: 12px;
            align-items: flex-start;
            border: 1px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 16px;
            padding: 14px;
        }

        .mini-icon {
            width: 34px;
            height: 34px;
            border-radius: 12px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 0.85rem;
            font-weight: 800;
        }

        .mini-title {
            font-weight: 800;
            color: var(--ink);
            font-size: 0.9rem;
        }

        .mini-text {
            color: var(--ink-3);
            font-size: 0.82rem;
            margin-top: 2px;
            line-height: 1.5;
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

        .progress-wrap {
            margin-top: 12px;
        }

        .progress-head {
            display: flex;
            justify-content: space-between;
            color: rgba(255,255,255,0.7);
            font-size: 0.78rem;
            font-weight: 800;
            margin-bottom: 7px;
        }

        .progress-track {
            height: 9px;
            background: rgba(255,255,255,0.32);
            border-radius: 999px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 999px;
            background: #ffffff;
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

        .toolbar {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .completed-overview {
            margin-bottom: 24px;
        }

        .completed-list {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
        }

        .completed-chip {
            border: 1px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 16px;
            padding: 14px;
            display: grid;
            gap: 4px;
        }

        .completed-chip strong {
            color: var(--ink);
            font-size: 0.9rem;
        }

        .completed-chip span {
            color: var(--ink-3);
            font-size: 0.78rem;
        }

        .completed-chip small {
            color: var(--green);
            font-size: 0.74rem;
            font-weight: 800;
        }

        .print-only {
            display: none;
        }

        @media print {
            .nav,
            .hero,
            .planner-settings,
            .side-section,
            .toolbar,
            .completed-overview,
            .task-actions {
                display: none !important;
            }

            .page {
                padding-top: 0;
            }

            .main {
                max-width: none;
                padding: 0;
            }

            .grid {
                display: block;
            }

            .card {
                box-shadow: none;
                border: none;
                padding: 0;
            }

            .task-row {
                break-inside: avoid;
                box-shadow: none;
            }

            .print-only {
                display: block;
                margin-bottom: 20px;
            }
        }

        @media (max-width: 1180px) {
            .hero {
                grid-template-columns: 1fr;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .completed-list {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 900px) {
            .nav-links {
                display: none;
            }
        }

        @media (max-width: 760px) {
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

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .task-row {
                grid-template-columns: 1fr;
                gap: 8px;
            }

            .task-actions {
                justify-content: flex-start;
            }

            .task-time {
                justify-self: start;
            }

            .difficulty-row {
                grid-template-columns: 1fr;
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
    List<Map<String,Object>> plan = (List<Map<String,Object>>) request.getAttribute("plan");
    List<Map<String,Object>> completedPlan = (List<Map<String,Object>>) request.getAttribute("completedPlan");
    List<Map<String,Object>> recommendations = (List<Map<String,Object>>) request.getAttribute("recommendations");

    if (courses == null) {
        courses = new ArrayList<Course>();
    }

    if (plan == null) {
        plan = new ArrayList<Map<String,Object>>();
    }

    if (completedPlan == null) {
        completedPlan = new ArrayList<Map<String,Object>>();
    }

    if (recommendations == null) {
        recommendations = new ArrayList<Map<String,Object>>();
    }

    Object realStudySecondsObj = request.getAttribute("realStudySeconds");
    int realStudySeconds = 0;

    if (realStudySecondsObj != null) {
        try {
            realStudySeconds = Integer.parseInt(String.valueOf(realStudySecondsObj));
        } catch (Exception ignored) {}
    }

    int realStudyMinutes = 0;

    if (realStudySeconds > 0) {
        realStudyMinutes = Math.max(1, (int) Math.ceil(realStudySeconds / 60.0));
    }

    int realStudyHours = realStudyMinutes / 60;
    int realStudyRemainingMinutes = realStudyMinutes % 60;

    int totalTasks = plan.size();
    int completedTasks = 0;
    int inProgressTasks = 0;
    int totalMinutes = 0;

    for (Map<String,Object> m : plan) {
        Object completedObj = m.get("completed");
        boolean completed = completedObj instanceof Boolean && ((Boolean) completedObj);

        String status = String.valueOf(m.get("status"));

        if ("IN_PROGRESS".equalsIgnoreCase(status)) {
            inProgressTasks++;
        }

        if (completed || "DONE".equalsIgnoreCase(status)) {
            completedTasks++;
        }

        Object minutesObj = m.get("minutes");

        if (minutesObj != null) {
            try {
                totalMinutes += Integer.parseInt(String.valueOf(minutesObj));
            } catch (Exception ignored) {}
        }
    }

    int completionPercent = totalTasks > 0 ? (int)Math.round(completedTasks * 100.0 / totalTasks) : 0;
    int totalHours = totalMinutes / 60;
    int remainingTasks = Math.max(0, totalTasks - completedTasks);
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
            <a href="<%=ctx%>/planner" class="active">Planner</a>
            <a href="<%=ctx%>/assessment">Assessment</a>
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
                <div class="hero-kicker">AI study planner</div>
                <h1>Turn your exam date into a clear daily plan.</h1>
                <p>
                    Generate an AI-based revision plan, start each task, finish it when done,
                    and track real study time as evidence of your progress.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Current plan</div>
                <div class="hero-panel-value"><%=totalTasks%> tasks</div>
                <div class="hero-panel-note">
                    <%=remainingTasks%> remaining · <%=inProgressTasks%> in progress · <%=completionPercent%>% completed
                </div>

                <div class="progress-wrap">
                    <div class="progress-head">
                        <span>Completion</span>
                        <span><%=completionPercent%>%</span>
                    </div>
                    <div class="progress-track">
                        <div class="progress-fill" style="width:<%=completionPercent%>%"></div>
                    </div>
                </div>
            </div>
        </section>

        <section class="card completed-overview">
            <div class="card-header">
                <div>
                    <div class="card-title">Completed tasks evidence</div>
                    <div class="card-subtitle">
                        Recently finished tasks and real study time tracked from Start / Finish actions.
                    </div>
                </div>

                <div class="task-time real-time-pill">
                    <% if (realStudyHours > 0) { %>
                        <%=realStudyHours%>h <%=realStudyRemainingMinutes%>m studied
                    <% } else { %>
                        <%=realStudyMinutes%> min studied
                    <% } %>
                </div>
            </div>

            <% if (completedPlan.isEmpty()) { %>
                <div class="empty-state">
                    <h3>No completed tasks yet</h3>
                    <p>Start a task, finish it, and it will appear here as learning evidence.</p>
                </div>
            <% } else { %>
                <div class="completed-list">
                    <% for (Map<String,Object> done : completedPlan) {
                        int seconds = 0;

                        try {
                            seconds = Integer.parseInt(String.valueOf(done.get("actualSeconds")));
                        } catch (Exception ignored) {}

                        int minutes = 0;

                        if (seconds > 0) {
                            minutes = Math.max(1, (int) Math.ceil(seconds / 60.0));
                        }
                    %>
                        <div class="completed-chip">
                            <strong><%=done.get("task")%></strong>
                            <span><%=done.get("course")%> · <%=minutes%> min real study</span>
                            <small>Completed</small>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </section>

        <section class="grid">

            <div class="side-section">

                <div class="card planner-settings">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Objective settings</div>
                            <div class="card-subtitle">Configure the plan before generating it.</div>
                        </div>
                    </div>

                    <form method="post" action="<%=ctx%>/planner" class="planner-form">
                        <input type="hidden" name="action" value="generate">

                        <div class="field">
                            <label class="field-label" for="courseId">Course</label>

                            <select id="courseId" name="courseId" class="field-control" required>
                                <% if (courses.isEmpty()) { %>
                                    <option value="">No courses available</option>
                                <% } else {
                                    for (Course c : courses) { %>
                                        <option value="<%=c.getId()%>"><%=c.getTitle()%></option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <div class="field">
                            <label class="field-label" for="examDate">Exam date</label>
                            <input id="examDate" type="date" name="examDate" class="field-control" required>
                        </div>

                        <div class="field">
                            <label class="field-label">Difficulty level</label>

                            <div class="difficulty-row">
                                <label class="difficulty-option">
                                    <input type="radio" name="difficulty" value="EASY">
                                    <span class="difficulty-pill">Easy</span>
                                </label>

                                <label class="difficulty-option">
                                    <input type="radio" name="difficulty" value="MEDIUM" checked>
                                    <span class="difficulty-pill">Medium</span>
                                </label>

                                <label class="difficulty-option">
                                    <input type="radio" name="difficulty" value="HARD">
                                    <span class="difficulty-pill">Hard</span>
                                </label>
                            </div>
                        </div>

                        <button class="btn btn-primary btn-full" type="submit">Generate with AI</button>
                    </form>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Quick actions</div>
                            <div class="card-subtitle">
                                Continue your revision workflow from the planner.
                            </div>
                        </div>
                    </div>

                    <div class="quick-action-grid">
                        <a class="quick-action-link" href="<%=ctx%>/materials">
                            Upload or review materials
                            <span>→</span>
                        </a>

                        <a class="quick-action-link" href="<%=ctx%>/flashcards">
                            Review flashcards
                            <span>→</span>
                        </a>

                        <a class="quick-action-link" href="<%=ctx%>/assessment">
                            Start a new quiz
                            <span>→</span>
                        </a>

                        <a class="quick-action-link" href="<%=ctx%>/insights">
                            View weak topics
                            <span>→</span>
                        </a>

                        <a class="quick-action-link" href="<%=ctx%>/ai-coach">
                            Ask AI Coach
                            <span>→</span>
                        </a>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Personal AI recommendations</div>
                            <div class="card-subtitle">Generated after analyzing your completed tasks and study time.</div>
                        </div>
                    </div>

                    <form method="post" action="<%=ctx%>/planner" style="margin-bottom:14px;">
                        <input type="hidden" name="action" value="generateRecommendations">
                        <button class="btn btn-primary btn-full" type="submit">Analyze my progress with AI</button>
                    </form>

                    <div class="mini-list">
                        <% if (recommendations.isEmpty()) { %>
                            <div class="mini-item">
                                <div class="mini-icon">AI</div>
                                <div>
                                    <div class="mini-title">No AI analysis yet</div>
                                    <div class="mini-text">
                                        Complete or start some tasks, then press the button to generate personalized recommendations.
                                    </div>
                                </div>
                            </div>
                        <% } else {
                            int recIndex = 1;
                            for (Map<String,Object> r : recommendations) { %>
                                <div class="mini-item">
                                    <div class="mini-icon"><%=recIndex%></div>
                                    <div>
                                        <div class="mini-title"><%=r.get("title")%></div>
                                        <div class="mini-text"><%=r.get("body")%></div>
                                    </div>
                                </div>
                        <%      recIndex++;
                            }
                        } %>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Study guidance</div>
                            <div class="card-subtitle">Static tips for using your plan effectively.</div>
                        </div>
                    </div>

                    <div class="mini-list">
                        <div class="mini-item">
                            <div class="mini-icon">1</div>
                            <div>
                                <div class="mini-title">Start with summaries</div>
                                <div class="mini-text">Read the course summary first to reactivate the main concepts before solving quizzes.</div>
                            </div>
                        </div>

                        <div class="mini-item">
                            <div class="mini-icon">2</div>
                            <div>
                                <div class="mini-title">Practice after revision</div>
                                <div class="mini-text">Use generated quizzes after each revision block to verify if the concepts were understood.</div>
                            </div>
                        </div>

                        <div class="mini-item">
                            <div class="mini-icon">3</div>
                            <div>
                                <div class="mini-title">Repeat weak topics</div>
                                <div class="mini-text">If a result is low, return to the related material and add a short extra revision session.</div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <div class="card">
                <div class="print-only">
                    <h2>SmartStudy AI — Study Plan</h2>
                    <p>Generated revision schedule</p>
                </div>

                <div class="card-header">
                    <div>
                        <div class="card-title">Dynamic study plan</div>
                        <div class="card-subtitle">Your daily tasks are organized by date, course and estimated effort.</div>
                    </div>

                    <div class="toolbar">
                        <button onclick="window.print()" class="btn btn-secondary" type="button">PDF Export</button>
                    </div>
                </div>

                <div class="summary-grid">
                    <div class="summary-card">
                        <div class="summary-label">Total tasks</div>
                        <div class="summary-value"><%=totalTasks%></div>
                        <div class="summary-note">Planned activities</div>
                    </div>

                    <div class="summary-card">
                        <div class="summary-label">Study load</div>
                        <div class="summary-value">
                            <% if (totalHours > 0) { %>
                                <%=totalHours%>h
                            <% } else { %>
                                <%=totalMinutes%>m
                            <% } %>
                        </div>
                        <div class="summary-note"><%=totalMinutes%> minutes estimated</div>
                    </div>

                    <div class="summary-card">
                        <div class="summary-label">Real study</div>
                        <div class="summary-value">
                            <% if (realStudyHours > 0) { %>
                                <%=realStudyHours%>h
                            <% } else { %>
                                <%=realStudyMinutes%>m
                            <% } %>
                        </div>
                        <div class="summary-note"><%=realStudyMinutes%> minutes tracked</div>
                    </div>

                    <div class="summary-card">
                        <div class="summary-label">Progress</div>
                        <div class="summary-value"><%=completionPercent%>%</div>
                        <div class="summary-note"><%=completedTasks%> completed</div>
                    </div>
                </div>

                <% if (plan.isEmpty()) { %>
                    <div class="empty-state">
                        <h3>No plan generated yet</h3>
                        <p>Select a course, choose an exam date and generate your first AI study plan.</p>
                    </div>
                <% } else { %>
                    <div class="timeline">
                        <% for (Map<String,Object> m : plan) {
                            Object completedObj = m.get("completed");
                            boolean completed = completedObj instanceof Boolean && ((Boolean) completedObj);

                            String status = String.valueOf(m.get("status"));
                            if (status == null || status.equals("null") || status.trim().isEmpty()) {
                                status = completed ? "DONE" : "TODO";
                            }

                            boolean inProgress = "IN_PROGRESS".equalsIgnoreCase(status);
                            boolean done = completed || "DONE".equalsIgnoreCase(status);

                            String statusClass;
                            String statusText;

                            if (done) {
                                statusClass = "status-done";
                                statusText = "Done";
                            } else if (inProgress) {
                                statusClass = "status-progress";
                                statusText = "In progress";
                            } else {
                                statusClass = "status-todo";
                                statusText = "To do";
                            }

                            String dateValue = String.valueOf(m.get("date"));
                            String dayLabel = "Planned day";

                            try {
                                LocalDate d = LocalDate.parse(dateValue);
                                dayLabel = d.getDayOfWeek().toString().substring(0, 1)
                                        + d.getDayOfWeek().toString().substring(1).toLowerCase();
                            } catch (Exception ignored) {}

                            String generatedBy = String.valueOf(m.get("generatedBy"));
                            boolean aiGenerated = "AI".equalsIgnoreCase(generatedBy);

                            String priority = String.valueOf(m.get("priority"));
                            if (priority == null || priority.equals("null") || priority.trim().isEmpty()) {
                                priority = "MEDIUM";
                            }

                            String description = String.valueOf(m.get("description"));
                            if (description == null || description.equals("null")) {
                                description = "";
                            }

                            int actualSeconds = 0;

                            try {
                                actualSeconds = Integer.parseInt(String.valueOf(m.get("actualSeconds")));
                            } catch (Exception ignored) {}

                            int actualMinutes = 0;

                            if (actualSeconds > 0) {
                                actualMinutes = Math.max(1, (int) Math.ceil(actualSeconds / 60.0));
                            }
                        %>

                            <div class="task-row <%=done ? "task-done" : ""%>">
                                <div class="task-date">
                                    <div class="task-date-main"><%=dateValue%></div>
                                    <div class="task-date-sub"><%=dayLabel%></div>
                                </div>

                                <div class="task-main">
                                    <div class="task-course"><%=m.get("course")%></div>
                                    <div class="task-title"><%=m.get("task")%></div>

                                    <% if (!description.trim().isEmpty()) { %>
                                        <div class="task-description"><%=description%></div>
                                    <% } %>

                                    <div class="task-meta-row">
                                        <span class="<%=aiGenerated ? "badge-ai" : "badge-rule"%>">
                                            <%=aiGenerated ? "AI generated" : "Rule fallback"%>
                                        </span>

                                        <span class="badge-priority"><%=priority%> priority</span>

                                        <% if (actualMinutes > 0) { %>
                                            <span class="badge-priority"><%=actualMinutes%> min real</span>
                                        <% } %>
                                    </div>
                                </div>

                                <div>
                                    <div class="task-time">
                                        Est. <%=m.get("minutes")%> min
                                    </div>

                                    <% if (actualMinutes > 0) { %>
                                        <div class="task-time real-time-pill">
                                            Real <%=actualMinutes%> min
                                        </div>
                                    <% } else { %>
                                        <div class="task-time planned-time-pill">
                                            Not tracked yet
                                        </div>
                                    <% } %>

                                    <div class="status-pill <%=statusClass%>" style="margin-top:8px;">
                                        <%=statusText%>
                                    </div>
                                </div>

                                <div class="task-actions">
                                    <% if (!done && !inProgress) { %>
                                        <form method="post" action="<%=ctx%>/planner">
                                            <input type="hidden" name="action" value="startTask">
                                            <input type="hidden" name="taskId" value="<%=m.get("id")%>">
                                            <button class="btn btn-small btn-start" type="submit">Start task</button>
                                        </form>
                                    <% } %>

                                    <% if (!done && inProgress) { %>
                                        <form method="post" action="<%=ctx%>/planner">
                                            <input type="hidden" name="action" value="finishTask">
                                            <input type="hidden" name="taskId" value="<%=m.get("id")%>">
                                            <button class="btn btn-small btn-finish" type="submit">Finish task</button>
                                        </form>
                                    <% } %>

                                    <% if (done) { %>
                                        <form method="post" action="<%=ctx%>/planner">
                                            <input type="hidden" name="action" value="resetTask">
                                            <input type="hidden" name="taskId" value="<%=m.get("id")%>">
                                            <button class="btn btn-small btn-reset" type="submit">Reset</button>
                                        </form>
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

</body>
</html>
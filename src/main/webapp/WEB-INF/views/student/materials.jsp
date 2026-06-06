<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.*" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Materials</title>
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
            --blue: #1d4ed8;
            --blue-bg: #eff6ff;
            --shadow-sm: 0 8px 24px rgba(15, 23, 42, 0.04);
            --shadow-md: 0 12px 35px rgba(15, 23, 42, 0.08);
            --shadow-hero: 0 18px 45px rgba(15, 23, 42, 0.13);
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

        button,
        input {
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
            white-space: nowrap;
        }

        .nav-links a:hover {
            color: var(--ink);
            background: var(--surface-soft);
        }

        .nav-links a.active {
            color: var(--primary);
            background: var(--primary-soft);
        }

        .admin-view-link {
            background: var(--primary);
            color: white !important;
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
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #10243d 0%, #1f3a5f 100%);
            color: white;
            border-radius: 30px;
            padding: 40px;
            margin-bottom: 24px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 350px;
            gap: 32px;
            align-items: center;
            box-shadow: var(--shadow-hero);
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

        .hero-content,
        .hero-panel {
            position: relative;
            z-index: 1;
        }

        .hero-kicker {
            color: rgba(255, 255, 255, 0.55);
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
            max-width: 820px;
            margin-bottom: 16px;
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
            letter-spacing: 0.11em;
            text-transform: uppercase;
        }

        .hero-panel-value {
            font-size: 2.75rem;
            font-weight: 800;
            line-height: 1;
            letter-spacing: -0.06em;
            margin-top: 14px;
        }

        .hero-panel-note {
            color: rgba(255, 255, 255, 0.68);
            font-size: 0.86rem;
            margin-top: 8px;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 24px;
        }

        .metric-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 24px;
            padding: 23px;
            min-height: 150px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--shadow-sm);
            transition: 0.22s ease;
        }

        .metric-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .metric-label {
            color: var(--ink-3);
            font-size: 0.74rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.09em;
        }

        .metric-value {
            font-size: 2.35rem;
            line-height: 1;
            font-weight: 800;
            letter-spacing: -0.065em;
            color: var(--ink);
            margin-top: 14px;
        }

        .metric-sub {
            margin-top: 8px;
            color: var(--ink-3);
            font-size: 0.84rem;
        }

        .layout {
            display: grid;
            grid-template-columns: minmax(340px, 0.78fr) minmax(0, 1.22fr);
            gap: 24px;
            align-items: start;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 26px;
            box-shadow: var(--shadow-sm);
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
            margin-bottom: 20px;
        }

        .alert {
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 18px;
            font-size: 0.88rem;
        }

        .alert-danger {
            background: var(--red-bg);
            color: var(--red);
            border: 1px solid #fecaca;
        }

        .alert-success {
            background: var(--green-bg);
            color: var(--green);
            border: 1px solid #bbf7d0;
        }

        .pdf-note {
            background: var(--primary-soft);
            border: 1px solid #d8e3f1;
            color: var(--primary);
            border-radius: 16px;
            padding: 14px 16px;
            font-size: 0.86rem;
            line-height: 1.6;
            margin-bottom: 18px;
        }

        .pdf-note strong {
            display: block;
            margin-bottom: 4px;
        }

        .course-preview {
            background: #f8fafc;
            border: 1px solid var(--rule);
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 20px;
        }

        .course-preview-title {
            font-size: 0.76rem;
            font-weight: 800;
            color: var(--ink-3);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 10px;
        }

        .course-chip-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .course-chip {
            font-size: 0.76rem;
            font-weight: 800;
            color: var(--primary);
            background: var(--primary-soft);
            border-radius: 999px;
            padding: 6px 10px;
        }

        .field {
            margin-bottom: 16px;
        }

        .field-label {
            display: block;
            font-size: 0.82rem;
            font-weight: 800;
            color: var(--ink-2);
            margin-bottom: 7px;
        }

        .field-input {
            width: 100%;
            border: 1.5px solid var(--rule);
            border-radius: 13px;
            background: var(--surface-soft);
            color: var(--ink);
            padding: 12px 14px;
            outline: none;
            font-size: 0.9rem;
            transition: 0.2s;
        }

        .field-input:focus {
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px var(--primary-soft);
        }

        .field-help {
            color: var(--ink-3);
            font-size: 0.78rem;
            margin-top: 6px;
        }

        .file-upload {
            border: 1.5px dashed #cbd5e1;
            border-radius: 18px;
            padding: 18px;
            background: #f8fafc;
            transition: 0.2s;
        }

        .file-upload:hover {
            border-color: var(--primary);
            background: var(--primary-soft);
        }

        .file-upload input {
            width: 100%;
            font-size: 0.86rem;
        }

        .submit-btn {
            width: 100%;
            border: none;
            background: var(--primary);
            color: white;
            font-weight: 800;
            font-size: 0.92rem;
            padding: 13px 16px;
            border-radius: 13px;
            cursor: pointer;
            transition: 0.2s;
            margin-top: 6px;
        }

        .submit-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .library-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 18px;
        }

        .library-tools {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 18px;
        }

        .tool-card {
            border: 1px solid var(--rule);
            background: #f8fafc;
            border-radius: 16px;
            padding: 14px;
        }

        .tool-value {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--ink);
            line-height: 1;
        }

        .tool-label {
            font-size: 0.75rem;
            color: var(--ink-3);
            margin-top: 6px;
        }

        .search-input {
            width: 100%;
            height: 44px;
            border: 1.5px solid var(--rule);
            border-radius: 14px;
            background: var(--surface-soft);
            padding: 0 14px;
            outline: none;
            font-size: 0.9rem;
            margin-bottom: 18px;
        }

        .search-input:focus {
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px var(--primary-soft);
        }

        .materials-list {
            display: grid;
            gap: 16px;
        }

        .material-card {
            border: 1px solid var(--rule);
            border-radius: 22px;
            background: white;
            padding: 20px;
            transition: 0.2s;
        }

        .material-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .material-top {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: flex-start;
            margin-bottom: 12px;
        }

        .material-title {
            font-size: 1.02rem;
            font-weight: 800;
            color: var(--ink);
            letter-spacing: -0.02em;
        }

        .material-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 8px;
        }

        .badge-soft,
        .badge-success-soft,
        .badge-warning-soft,
        .badge-danger-soft,
        .badge-blue-soft {
            display: inline-flex;
            align-items: center;
            width: fit-content;
            border-radius: 999px;
            padding: 5px 10px;
            font-size: 0.72rem;
            font-weight: 800;
        }

        .badge-soft {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .badge-blue-soft {
            background: var(--blue-bg);
            color: var(--blue);
        }

        .badge-success-soft {
            background: var(--green-bg);
            color: var(--green);
        }

        .badge-warning-soft {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .badge-danger-soft {
            background: var(--red-bg);
            color: var(--red);
        }

        .material-ai-panel {
            margin-top: 14px;
            margin-bottom: 14px;
            padding: 15px;
            border-radius: 18px;
            background: #f8fafc;
            border: 1px solid var(--rule);
        }

        .material-ai-title {
            font-size: 0.86rem;
            font-weight: 800;
            color: var(--ink);
            margin-bottom: 5px;
        }

        .material-ai-text {
            font-size: 0.82rem;
            color: var(--ink-3);
            line-height: 1.55;
        }

        .summary-box {
            margin-top: 14px;
            background: var(--primary-soft);
            border: 1px solid #d8e3f1;
            border-radius: 16px;
            padding: 15px;
        }

        .summary-title {
            font-size: 0.85rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 8px;
        }

        .summary-text {
            font-size: 0.84rem;
            color: var(--ink-2);
            line-height: 1.75;
            max-height: 260px;
            overflow: auto;
            padding-right: 6px;
        }

        .summary-empty {
            margin-top: 14px;
            background: #ffffff;
            border: 1px dashed #cbd5e1;
            border-radius: 16px;
            padding: 14px;
            font-size: 0.82rem;
            color: var(--ink-3);
        }

        .material-mini-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 10px;
            margin-top: 14px;
        }

        .material-mini-box {
            border: 1px solid var(--rule);
            border-radius: 14px;
            padding: 12px;
            background: #ffffff;
        }

        .material-mini-title {
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--ink-4);
        }

        .material-mini-value {
            margin-top: 6px;
            font-size: 0.82rem;
            font-weight: 800;
            color: var(--ink-2);
        }

        .ai-actions {
            display: flex;
            gap: 9px;
            flex-wrap: wrap;
            margin-top: 14px;
        }

        .action-btn {
            border: 1px solid var(--rule);
            background: white;
            color: var(--ink-2);
            padding: 9px 12px;
            border-radius: 12px;
            font-size: 0.82rem;
            font-weight: 800;
            cursor: pointer;
            transition: 0.2s;
        }

        .action-btn:hover {
            transform: translateY(-1px);
        }

        .action-btn.green {
            border-color: #bbf7d0;
            color: var(--green);
            background: var(--green-bg);
        }

        .action-btn.blue {
            border-color: #d8e3f1;
            color: var(--primary);
            background: var(--primary-soft);
        }

        .action-btn.gray {
            border-color: var(--rule);
            color: var(--ink-2);
            background: white;
        }

        .action-btn:disabled,
        .action-btn.disabled {
            opacity: 0.45;
            cursor: not-allowed;
            transform: none;
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
        }

        @media (max-width: 760px) {
            .main {
                padding: 24px 18px 60px;
            }

            .nav {
                padding: 0 18px;
            }

            .nav-links {
                display: none;
            }

            .hero {
                padding: 28px;
                border-radius: 24px;
            }

            .hero h1 {
                font-size: 2.15rem;
            }

            .metrics-grid,
            .library-tools,
            .material-mini-grid {
                grid-template-columns: 1fr;
            }

            .material-top {
                flex-direction: column;
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

    if (currentUser != null) {
        profilePhoto = currentUser.getProfilePhoto();

        if (currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty()) {
            String fullName = currentUser.getFullName().trim();
            String[] parts = fullName.split("\\s+");

            if (parts.length >= 2) {
                initials = parts[0].substring(0, 1).toUpperCase() + parts[1].substring(0, 1).toUpperCase();
            } else {
                initials = fullName.substring(0, 1).toUpperCase();
            }
        }
    }

    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Material> materials = (List<Material>) request.getAttribute("materials");

    if (courses == null) {
        courses = new ArrayList<Course>();
    }

    if (materials == null) {
        materials = new ArrayList<Material>();
    }

    int extractedTextMaterials = 0;
    int pdfMaterials = 0;
    int summaryReady = 0;
    int aiReadyMaterials = 0;

    for (Material m : materials) {
        if (m.getContentText() != null && !m.getContentText().trim().isEmpty()) {
            extractedTextMaterials++;
            aiReadyMaterials++;
        }

        if (m.getMaterialType() != null && m.getMaterialType().toUpperCase().contains("PDF")) {
            pdfMaterials++;
        }

        if (m.getSummary() != null && !m.getSummary().trim().isEmpty()) {
            summaryReady++;
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
            <a href="<%=ctx%>/materials" class="active">Materials</a>
            <a href="<%=ctx%>/planner">Planner</a>
            <a href="<%=ctx%>/assessment">Assessment</a>
            <a href="<%=ctx%>/flashcards">Flashcards</a>
            <a href="<%=ctx%>/insights">Insights</a>
            <a href="<%=ctx%>/stats">Stats</a>
            <a href="<%=ctx%>/profile">Profile</a>
            <a href="<%=ctx%>/chat">Support</a>
            <a href="<%=ctx%>/ai-coach">AI Coach</a>

            <% if (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>
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
                <div class="hero-kicker">PDF document workspace</div>
                <h1>Turn PDF course materials into AI learning resources.</h1>
                <p>
                    Upload a clean PDF, extract the text, then generate AI summaries, questions and flashcards
                    directly from the document content.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">PDF materials</div>
                <div class="hero-panel-value"><%=pdfMaterials%></div>
                <div class="hero-panel-note">
                    <%=extractedTextMaterials%> with extracted text · <%=summaryReady%> with AI summary
                </div>
            </div>
        </section>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <strong>Error:</strong> <%=request.getAttribute("error")%>
            </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%=request.getAttribute("success")%>
            </div>
        <% } %>

        <% if (request.getParameter("aiError") != null || session.getAttribute("aiError") != null) { %>
            <div class="alert alert-danger">
                <strong>AI generation failed:</strong>
                <%=session.getAttribute("aiError") != null ? session.getAttribute("aiError") : "Please check your Gemini API key, internet connection or API limits."%>
            </div>
            <%
                session.removeAttribute("aiError");
            %>
        <% } %>

        <section class="metrics-grid">
            <div class="metric-card">
                <div>
                    <div class="metric-label">Courses</div>
                    <div class="metric-value"><%=courses.size()%></div>
                    <div class="metric-sub">Courses connected to your account.</div>
                </div>
            </div>

            <div class="metric-card">
                <div>
                    <div class="metric-label">PDF materials</div>
                    <div class="metric-value"><%=pdfMaterials%></div>
                    <div class="metric-sub">Only PDF upload is enabled.</div>
                </div>
            </div>

            <div class="metric-card">
                <div>
                    <div class="metric-label">AI ready</div>
                    <div class="metric-value"><%=aiReadyMaterials%></div>
                    <div class="metric-sub">Materials with extracted text.</div>
                </div>
            </div>

            <div class="metric-card">
                <div>
                    <div class="metric-label">AI summaries</div>
                    <div class="metric-value"><%=summaryReady%></div>
                    <div class="metric-sub">Generated and visible below.</div>
                </div>
            </div>
        </section>

        <section class="layout">

            <div class="card">
                <div class="card-title">Upload PDF material</div>
                <div class="card-subtitle">
                    Upload a course PDF. SmartStudy AI will use only the extracted text from this file.
                </div>

                <div class="pdf-note">
                    <strong>Recommended maximum for stable AI generation</strong>
                    PDF size: maximum 8 MB. Ideal length: 10–15 pages. Use selectable text PDFs, not scanned image PDFs.
                    If the PDF is too long, split it into chapters before uploading.
                </div>

                <% if (!courses.isEmpty()) { %>
                    <div class="course-preview">
                        <div class="course-preview-title">Your existing courses</div>

                        <div class="course-chip-list">
                            <% for (Course c : courses) { %>
                                <span class="course-chip"><%=c.getTitle()%></span>
                            <% } %>
                        </div>
                    </div>
                <% } %>

                <form method="post" action="<%=ctx%>/materials" enctype="multipart/form-data" id="uploadForm">

                    <input type="hidden" name="materialType" value="PDF">
                    <input type="hidden" name="contentText" value="">
                    <input type="hidden" name="disciplineId" value="0">

                    <div class="field">
                        <label class="field-label">Material title</label>
                        <input
                                type="text"
                                name="title"
                                class="field-input"
                                placeholder="Example: Java Servlets Course"
                                autocomplete="off"
                                required
                        >
                    </div>

                    <div class="field">
                        <label class="field-label">Course</label>
                        <input
                                type="text"
                                name="courseName"
                                class="field-input"
                                placeholder="Example: Java, Web Programming, Databases..."
                                autocomplete="off"
                                required
                        >

                        <div class="field-help">
                            Write the course name manually. Example: Java, Web Programming, Databases.
                        </div>
                    </div>

                    <div class="field">
                        <label class="field-label">Discipline / topic</label>
                        <input
                                type="text"
                                name="disciplineName"
                                class="field-input"
                                placeholder="Example: Servlets, JDBC, OOP, SQL..."
                                autocomplete="off"
                        >

                        <div class="field-help">
                            Write the topic manually. Example: Servlets, JDBC, OOP, SQL.
                        </div>
                    </div>

                    <div class="field">
                        <label class="field-label">Upload PDF</label>

                        <div class="file-upload">
                            <input id="pdfFile" type="file" name="pdfFile" accept="application/pdf" required>
                        </div>

                        <div class="field-help">
                            Accepted format: PDF only. Recommended maximum: 8 MB.
                        </div>
                    </div>

                    <button class="submit-btn" type="submit">
                        Save PDF and extract text →
                    </button>

                </form>
            </div>

            <div class="card">
                <div class="library-header">
                    <div>
                        <div class="card-title">PDF materials library</div>
                        <div class="card-subtitle">
                            Generate AI summaries, quizzes and flashcards from extracted PDF text.
                        </div>
                    </div>
                </div>

                <div class="library-tools">
                    <div class="tool-card">
                        <div class="tool-value"><%=pdfMaterials%></div>
                        <div class="tool-label">PDF materials</div>
                    </div>

                    <div class="tool-card">
                        <div class="tool-value"><%=extractedTextMaterials%></div>
                        <div class="tool-label">AI ready</div>
                    </div>

                    <div class="tool-card">
                        <div class="tool-value"><%=summaryReady%></div>
                        <div class="tool-label">AI summaries</div>
                    </div>
                </div>

                <input
                        id="searchInput"
                        class="search-input"
                        placeholder="Search by title, course, type or status..."
                >

                <% if (!materials.isEmpty()) { %>

                    <div class="materials-list">
                        <% for (Material m : materials) {
                            boolean hasText = m.getContentText() != null && !m.getContentText().trim().isEmpty();
                            boolean hasSummary = m.getSummary() != null && !m.getSummary().trim().isEmpty();
                            boolean isPdf = m.getMaterialType() != null && m.getMaterialType().toUpperCase().contains("PDF");

                            int textLength = hasText ? m.getContentText().length() : 0;
                            int summaryLength = hasSummary ? m.getSummary().length() : 0;
                        %>

                            <div class="material-card searchable">

                                <div class="material-top">
                                    <div>
                                        <div class="material-title"><%=m.getTitle()%></div>

                                        <div class="material-meta">
                                            <span class="badge-soft"><%=isPdf ? "PDF" : "Material"%></span>

                                            <% if (hasText) { %>
                                                <span class="badge-success-soft">Text extracted</span>
                                            <% } else { %>
                                                <span class="badge-warning-soft">No extracted text</span>
                                            <% } %>

                                            <% if (hasSummary) { %>
                                                <span class="badge-blue-soft">AI summary ready</span>
                                            <% } else { %>
                                                <span class="badge-soft">No AI summary yet</span>
                                            <% } %>

                                            <% if (m.getAiStatus() != null && !m.getAiStatus().trim().isEmpty()) { %>
                                                <span class="badge-success-soft"><%=m.getAiStatus()%></span>
                                            <% } else { %>
                                                <span class="badge-soft">New</span>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>

                                <div class="material-mini-grid">
                                    <div class="material-mini-box">
                                        <div class="material-mini-title">Text length</div>
                                        <div class="material-mini-value"><%=textLength%> chars</div>
                                    </div>

                                    <div class="material-mini-box">
                                        <div class="material-mini-title">Summary</div>
                                        <div class="material-mini-value"><%=hasSummary ? summaryLength + " chars" : "Not generated"%></div>
                                    </div>

                                    <div class="material-mini-box">
                                        <div class="material-mini-title">AI status</div>
                                        <div class="material-mini-value"><%=hasText ? "Ready" : "Not ready"%></div>
                                    </div>
                                </div>

                                <div class="material-ai-panel">
                                    <div class="material-ai-title">AI generation status</div>

                                    <% if (hasText) { %>
                                        <div class="material-ai-text">
                                            This PDF has extracted text and can be used to generate AI questions, summaries and flashcards.
                                        </div>
                                    <% } else { %>
                                        <div class="material-ai-text">
                                            This PDF does not have extracted text yet. AI generation may fail if the PDF is scanned or unreadable.
                                        </div>
                                    <% } %>

                                    <% if (hasSummary) { %>
                                        <div class="summary-box">
                                            <div class="summary-title">AI summary</div>
                                            <div class="summary-text">
                                                <%=m.getSummary().replace("\n", "<br>")%>
                                            </div>
                                        </div>
                                    <% } else { %>
                                        <div class="summary-empty">
                                            No AI summary generated yet. Press <strong>Generate AI summary</strong> to create one.
                                        </div>
                                    <% } %>
                                </div>

                                <div class="ai-actions">

                                    <form method="post" action="<%=ctx%>/generate-questions">
                                        <input type="hidden" name="materialId" value="<%=m.getId()%>">
                                        <input type="hidden" name="action" value="questions">
                                        <button class="action-btn green <%=hasText ? "" : "disabled"%>" type="submit" <%=hasText ? "" : "disabled"%>>
                                            Generate AI questions
                                        </button>
                                    </form>

                                    <form method="post" action="<%=ctx%>/generate-questions">
                                        <input type="hidden" name="materialId" value="<%=m.getId()%>">
                                        <input type="hidden" name="action" value="summary">
                                        <button class="action-btn blue <%=hasText ? "" : "disabled"%>" type="submit" <%=hasText ? "" : "disabled"%>>
                                            Generate AI summary
                                        </button>
                                    </form>

                                    <form method="post" action="<%=ctx%>/generate-questions">
                                        <input type="hidden" name="materialId" value="<%=m.getId()%>">
                                        <input type="hidden" name="action" value="flashcards">
                                        <button class="action-btn gray <%=hasText ? "" : "disabled"%>" type="submit" <%=hasText ? "" : "disabled"%>>
                                            Generate AI flashcards
                                        </button>
                                    </form>

                                </div>

                            </div>

                        <% } %>
                    </div>

                <% } else { %>

                    <div class="empty-state">
                        <div class="empty-state-title">No PDF materials uploaded yet</div>
                        <div>
                            Upload a PDF with selectable text to start generating AI study content.
                        </div>
                    </div>

                <% } %>

            </div>

        </section>

    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const searchInput = document.getElementById("searchInput");

        if (searchInput) {
            searchInput.addEventListener("keyup", function () {
                const value = this.value.toLowerCase().trim();
                const items = document.querySelectorAll(".searchable");

                items.forEach(function (item) {
                    const text = item.textContent.toLowerCase();
                    item.style.display = text.includes(value) ? "" : "none";
                });
            });
        }

        const uploadForm = document.getElementById("uploadForm");
        const pdfFile = document.getElementById("pdfFile");

        if (uploadForm && pdfFile) {
            uploadForm.addEventListener("submit", function (e) {
                if (!pdfFile.files || pdfFile.files.length === 0) {
                    alert("Please upload a PDF file.");
                    e.preventDefault();
                    return;
                }

                const file = pdfFile.files[0];
                const maxSize = 8 * 1024 * 1024;

                if (file.type !== "application/pdf" && !file.name.toLowerCase().endsWith(".pdf")) {
                    alert("Only PDF files are accepted.");
                    e.preventDefault();
                    return;
                }

                if (file.size > maxSize) {
                    alert("The PDF is too large. Please upload a file smaller than 8 MB or split the document into chapters.");
                    e.preventDefault();
                }
            });
        }
    });
</script>

</body>
</html>
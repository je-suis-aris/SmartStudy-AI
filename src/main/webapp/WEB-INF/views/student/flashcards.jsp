<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.*" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Flashcards</title>
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
            --amber: #b7791f;
            --amber-bg: #fffbeb;
            --red: #991b1b;
            --red-bg: #fef2f2;
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
            font-size: 15px;
            line-height: 1.6;
            min-height: 100vh;
        }

        a {
            text-decoration: none;
            color: inherit;
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
            letter-spacing: -0.03em;
            margin-right: auto;
            white-space: nowrap;
            color: var(--ink);
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
            min-height: 140px;
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

        .toolbar-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 24px;
            padding: 20px;
            margin-bottom: 24px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto auto;
            gap: 14px;
            align-items: center;
        }

        .search {
            width: 100%;
            background: var(--surface-soft);
            border: 1.5px solid var(--rule);
            border-radius: 14px;
            padding: 13px 14px;
            outline: none;
            font-size: 0.9rem;
        }

        .search:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(31, 58, 95, 0.1);
            background: white;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 12px 16px;
            border-radius: 13px;
            font-size: 0.86rem;
            font-weight: 800;
            border: 1px solid transparent;
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
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-soft);
            transform: translateY(-1px);
        }

        .section-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 800;
            letter-spacing: -0.04em;
            color: var(--ink);
        }

        .section-subtitle {
            color: var(--ink-3);
            font-size: 0.88rem;
            margin-top: 3px;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 22px;
        }

        .flashcard {
            min-height: 280px;
            perspective: 1000px;
        }

        .flashcard-inner {
            position: relative;
            width: 100%;
            min-height: 280px;
            transition: transform 0.65s;
            transform-style: preserve-3d;
            cursor: pointer;
        }

        .flashcard.flipped .flashcard-inner {
            transform: rotateY(180deg);
        }

        .flashcard-face {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            background: white;
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 24px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: 0.2s;
            overflow: hidden;
        }

        .flashcard:hover .flashcard-face {
            box-shadow: var(--shadow);
        }

        .flashcard-back {
            transform: rotateY(180deg);
            background: linear-gradient(135deg, #10243d 0%, #1f3a5f 100%);
            color: white;
            border-color: var(--primary-dark);
        }

        .card-meta {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }

        .badge {
            border-radius: 999px;
            padding: 5px 9px;
            font-size: 0.72rem;
            font-weight: 800;
        }

        .badge-course {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .badge-material {
            background: var(--green-bg);
            color: var(--green);
        }

        .badge-mode {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .front-title {
            font-size: 1.22rem;
            font-weight: 800;
            letter-spacing: -0.035em;
            color: var(--ink);
            line-height: 1.35;
        }

        .back-title {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            color: rgba(255,255,255,0.52);
            font-weight: 800;
            margin-bottom: 14px;
        }

        .back-text {
            font-size: 1rem;
            color: rgba(255,255,255,0.86);
            line-height: 1.7;
        }

        .flip-hint {
            font-size: 0.78rem;
            color: var(--ink-4);
            margin-top: 18px;
        }

        .flashcard-back .flip-hint {
            color: rgba(255,255,255,0.48);
        }

        .empty-state {
            background: white;
            border: 1px dashed #cbd5e1;
            border-radius: 26px;
            padding: 46px 28px;
            text-align: center;
            color: var(--ink-3);
        }

        .empty-title {
            font-size: 1.3rem;
            font-weight: 800;
            color: var(--ink);
            margin-bottom: 8px;
        }

        .empty-actions {
            margin-top: 18px;
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        @media (max-width: 1180px) {
            .hero {
                grid-template-columns: 1fr;
            }

            .metric-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .cards-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .toolbar-card {
                grid-template-columns: 1fr;
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

            .metric-grid,
            .cards-grid {
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

    List<Flashcard> flashcards = (List<Flashcard>) request.getAttribute("flashcards");

    if (flashcards == null) {
        flashcards = new ArrayList<Flashcard>();
    }

    Set<String> courseTitles = new LinkedHashSet<String>();
    Set<String> materialTitles = new LinkedHashSet<String>();

    for (Flashcard f : flashcards) {
        if (f.getCourseTitle() != null && !f.getCourseTitle().trim().isEmpty()) {
            courseTitles.add(f.getCourseTitle().trim());
        }

        if (f.getMaterialTitle() != null && !f.getMaterialTitle().trim().isEmpty()) {
            materialTitles.add(f.getMaterialTitle().trim());
        }
    }

    int totalFlashcards = flashcards.size();
    int totalCourses = courseTitles.size();
    int totalMaterials = materialTitles.size();
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
            <a href="<%=ctx%>/flashcards" class="active">Flashcards</a>
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
                <div class="hero-kicker">AI-generated study cards</div>
                <h1>Review key concepts with adaptive flashcards.</h1>
                <p>
                    Study the concepts extracted from your uploaded materials. Click a card to reveal the explanation,
                    then return to Materials whenever you need to generate more flashcards.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Flashcard library</div>
                <div class="hero-panel-value"><%=totalFlashcards%></div>
                <div class="hero-panel-note">
                    <%=totalCourses%> course<%=totalCourses == 1 ? "" : "s"%> ·
                    <%=totalMaterials%> material<%=totalMaterials == 1 ? "" : "s"%>
                </div>
            </div>
        </section>

        <section class="metric-grid">
            <div class="metric-card">
                <div class="metric-label">Flashcards</div>
                <div class="metric-value"><%=totalFlashcards%></div>
                <div class="metric-sub">Study cards available.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Courses</div>
                <div class="metric-value"><%=totalCourses%></div>
                <div class="metric-sub">Courses represented in cards.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Materials</div>
                <div class="metric-value"><%=totalMaterials%></div>
                <div class="metric-sub">Source materials used.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Revision mode</div>
                <div class="metric-value">Flip</div>
                <div class="metric-sub">Click cards to reveal answers.</div>
            </div>
        </section>

        <section class="toolbar-card">
            <input class="search" id="searchInput" placeholder="Search flashcards by concept, course or material...">

            <a href="<%=ctx%>/materials" class="btn btn-primary">
                + Generate more flashcards
            </a>

            <a href="<%=ctx%>/assessment" class="btn btn-secondary">
                Practice quiz
            </a>
        </section>

        <section>
            <div class="section-header">
                <div>
                    <div class="section-title">Flashcard deck</div>
                    <div class="section-subtitle">
                        Click each card to switch between concept and explanation.
                    </div>
                </div>
            </div>

            <% if (flashcards.isEmpty()) { %>

                <div class="empty-state">
                    <div class="empty-title">No flashcards generated yet</div>
                    <div>
                        Go to Materials, choose an uploaded document and click “Generate flashcards”.
                    </div>

                    <div class="empty-actions">
                        <a href="<%=ctx%>/materials" class="btn btn-primary">
                            Go to Materials
                        </a>

                        <a href="<%=ctx%>/assessment" class="btn btn-secondary">
                            Go to Assessment
                        </a>
                    </div>
                </div>

            <% } else { %>

                <div class="cards-grid">

                    <% for (Flashcard f : flashcards) { %>

                        <div class="flashcard searchable" onclick="this.classList.toggle('flipped')">

                            <div class="flashcard-inner">

                                <div class="flashcard-face flashcard-front">
                                    <div>
                                        <div class="card-meta">
                                            <% if (f.getCourseTitle() != null && !f.getCourseTitle().trim().isEmpty()) { %>
                                                <span class="badge badge-course"><%=f.getCourseTitle()%></span>
                                            <% } %>

                                            <% if (f.getMaterialTitle() != null && !f.getMaterialTitle().trim().isEmpty()) { %>
                                                <span class="badge badge-material"><%=f.getMaterialTitle()%></span>
                                            <% } %>

                                            <span class="badge badge-mode">Concept</span>
                                        </div>

                                        <div class="front-title">
                                            <%=f.getFrontText()%>
                                        </div>
                                    </div>

                                    <div class="flip-hint">
                                        Click to reveal explanation →
                                    </div>
                                </div>

                                <div class="flashcard-face flashcard-back">
                                    <div>
                                        <div class="back-title">Explanation</div>

                                        <div class="back-text">
                                            <%=f.getBackText()%>
                                        </div>
                                    </div>

                                    <div class="flip-hint">
                                        Click again to return
                                    </div>
                                </div>

                            </div>

                        </div>

                    <% } %>

                </div>

            <% } %>

        </section>

    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const searchInput = document.getElementById("searchInput");

        if (searchInput) {
            searchInput.addEventListener("keyup", function () {
                const value = this.value.toLowerCase();
                const cards = document.querySelectorAll(".searchable");

                cards.forEach(function (card) {
                    const text = card.textContent.toLowerCase();
                    card.style.display = text.includes(value) ? "" : "none";
                });
            });
        }
    });
</script>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.ChatMessage,com.smartstudy.model.User" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Support Chat</title>
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

        .alert {
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }

        .alert-success {
            background: var(--green-bg);
            color: var(--green);
            border: 1px solid #bbf7d0;
        }

        .alert-error {
            background: var(--red-bg);
            color: var(--red);
            border: 1px solid #fecaca;
        }

        .support-metrics {
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
            grid-template-columns: minmax(0, 1.45fr) minmax(340px, 0.55fr);
            gap: 24px;
            align-items: start;
        }

        .support-left,
        .support-right {
            display: grid;
            gap: 24px;
            align-content: start;
        }

        .support-right {
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

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            border-radius: 999px;
            padding: 8px 12px;
            background: var(--green-bg);
            color: var(--green);
            font-size: 0.8rem;
            font-weight: 800;
            white-space: nowrap;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #22c55e;
        }

        .quick-topics {
            padding: 18px 24px 0;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .topic-chip {
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

        .topic-chip:hover {
            background: var(--primary-soft);
            transform: translateY(-1px);
        }

        .chat-body {
            background: linear-gradient(180deg, #fafbfd 0%, #f6f8fb 100%);
            padding: 24px;
            min-height: 460px;
            max-height: 620px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .empty-chat {
            margin: auto;
            max-width: 560px;
            text-align: center;
            color: var(--ink-3);
            padding: 30px 10px;
        }

        .empty-chat-icon {
            width: 74px;
            height: 74px;
            border-radius: 22px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.9rem;
            margin: 0 auto 16px;
        }

        .empty-chat h3 {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--ink);
            margin-bottom: 8px;
        }

        .message-row {
            display: flex;
            width: 100%;
        }

        .message-row.student {
            justify-content: flex-end;
        }

        .message-row.admin {
            justify-content: flex-start;
        }

        .message-bubble {
            max-width: 78%;
            border-radius: 22px;
            padding: 14px 16px 12px;
            box-shadow: 0 6px 18px rgba(15, 23, 42, 0.05);
        }

        .message-row.student .message-bubble {
            background: var(--primary);
            color: white;
            border-bottom-right-radius: 10px;
        }

        .message-row.admin .message-bubble {
            background: white;
            color: var(--ink);
            border: 1px solid var(--rule);
            border-bottom-left-radius: 10px;
        }

        .message-meta {
            font-size: 0.76rem;
            opacity: 0.78;
            margin-top: 8px;
        }

        .message-text {
            font-size: 0.93rem;
            line-height: 1.7;
            white-space: pre-wrap;
            word-break: break-word;
        }

        .chat-form-wrap {
            padding: 18px 24px 24px;
            border-top: 1px solid var(--rule);
            background: white;
        }

        .chat-form {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 12px;
            align-items: end;
        }

        .chat-input {
            width: 100%;
            min-height: 78px;
            max-height: 180px;
            resize: vertical;
            border: 1.5px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 16px;
            padding: 14px 16px;
            font-size: 0.92rem;
            color: var(--ink);
            outline: none;
            transition: 0.2s ease;
        }

        .chat-input:focus {
            background: white;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(31, 58, 95, 0.12);
        }

        .send-btn {
            border: none;
            background: var(--primary);
            color: white;
            min-height: 50px;
            padding: 0 22px;
            border-radius: 14px;
            font-size: 0.92rem;
            font-weight: 800;
            cursor: pointer;
            transition: 0.18s ease;
        }

        .send-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .helper-text {
            margin-top: 10px;
            color: var(--ink-4);
            font-size: 0.78rem;
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

            .support-metrics {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .layout {
                grid-template-columns: 1fr;
            }

            .support-right {
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

            .support-metrics {
                grid-template-columns: 1fr;
            }

            .chat-form {
                grid-template-columns: 1fr;
            }

            .send-btn {
                min-height: 46px;
                width: 100%;
            }

            .message-bubble {
                max-width: 92%;
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

    String fullName = currentUser.getFullName() == null ? "Student" : currentUser.getFullName();
    String role = currentUser.getRole() == null ? "STUDENT" : currentUser.getRole();
    String profilePhoto = currentUser.getProfilePhoto();
    boolean isAdmin = "ADMIN".equalsIgnoreCase(role);

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

    List<ChatMessage> messages = (List<ChatMessage>) request.getAttribute("messages");

    if (messages == null) {
        messages = new ArrayList<ChatMessage>();
    }

    int totalMessages = messages.size();
    int studentMessages = 0;
    int adminReplies = 0;

    for (ChatMessage m : messages) {
        boolean sentByStudent = "STUDENT".equalsIgnoreCase(m.getSenderRole());

        if (sentByStudent) {
            studentMessages++;
        } else {
            adminReplies++;
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
            <a href="<%=ctx%>/assessment">Assessment</a>
            <a href="<%=ctx%>/flashcards">Flashcards</a>
            <a href="<%=ctx%>/insights">Insights</a>
            <a href="<%=ctx%>/stats">Stats</a>
            <a href="<%=ctx%>/profile">Profile</a>
            <a href="<%=ctx%>/chat" class="active">Support</a>
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
                <div class="hero-kicker">Student support</div>
                <h1>Chat with the administration team.</h1>
                <p>
                    Ask questions about your courses, uploaded materials, study planner, AI generation,
                    flashcards or quiz issues. The admin team can review your messages and reply here.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Support status</div>
                <div class="hero-panel-value">Active</div>
                <div class="hero-panel-note">
                    Direct support channel for academic and platform questions.
                </div>
            </div>
        </section>

        <section class="support-metrics">
            <div class="metric-card">
                <div class="metric-label">Total messages</div>
                <div class="metric-value"><%=totalMessages%></div>
                <div class="metric-sub">All messages in this conversation.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Your messages</div>
                <div class="metric-value"><%=studentMessages%></div>
                <div class="metric-sub">Questions sent by you.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Admin replies</div>
                <div class="metric-value"><%=adminReplies%></div>
                <div class="metric-sub">Answers from the support team.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Channel type</div>
                <div class="metric-value" style="font-size:1.55rem;">Direct</div>
                <div class="metric-sub">For courses, account and platform support.</div>
            </div>
        </section>

        <section class="layout">

            <div class="support-left">

                <section class="card">

                    <div class="card-header">
                        <div>
                            <div class="section-title">Support conversation</div>
                            <div class="section-subtitle">
                                Messages between you and the administration team.
                            </div>
                        </div>

                        <div class="status-badge">
                            <span class="status-dot"></span>
                            Active
                        </div>
                    </div>

                    <div class="quick-topics">
                        <button type="button" class="topic-chip" onclick="fillTopic('I need help with uploaded materials and PDF processing.')">
                            Materials issue
                        </button>

                        <button type="button" class="topic-chip" onclick="fillTopic('I have a problem with my study planner and exam scheduling.')">
                            Planner issue
                        </button>

                        <button type="button" class="topic-chip" onclick="fillTopic('I need help with quiz generation or assessment results.')">
                            Assessment / quiz
                        </button>

                        <button type="button" class="topic-chip" onclick="fillTopic('I have a question about flashcards or AI-generated learning resources.')">
                            Flashcards / AI
                        </button>

                        <button type="button" class="topic-chip" onclick="fillTopic('I need account or profile support.')">
                            Account support
                        </button>
                    </div>

                    <div class="chat-body" id="messagesBox">

                        <% if (!messages.isEmpty()) { %>

                            <% for (ChatMessage m : messages) {
                                boolean sentByStudent = "STUDENT".equalsIgnoreCase(m.getSenderRole());
                            %>

                                <div class="message-row <%=sentByStudent ? "student" : "admin"%>">
                                    <div class="message-bubble">
                                        <div class="message-text"><%=m.getMessageText()%></div>

                                        <div class="message-meta">
                                            <%=sentByStudent ? "You" : "Admin"%>
                                            <% if (m.getCreatedAt() != null) { %>
                                                · <%=m.getCreatedAt()%>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>

                            <% } %>

                        <% } else { %>

                            <div class="empty-chat">
                                <div class="empty-chat-icon">💬</div>
                                <h3>No messages yet</h3>
                                <p>
                                    Start the conversation by sending your first question to the administration team.
                                    You can ask about materials, quizzes, flashcards, planner issues or your account.
                                </p>
                            </div>

                        <% } %>

                    </div>

                    <div class="chat-form-wrap">
                        <form method="post" action="<%=ctx%>/chat" class="chat-form">
                            <textarea
                                    id="messageInput"
                                    name="messageText"
                                    class="chat-input"
                                    placeholder="Write your message here..."
                                    required
                            ></textarea>

                            <button type="submit" class="send-btn">Send</button>
                        </form>

                        <div class="helper-text">
                            Tip: mention the page, course and error message so support can answer faster.
                        </div>
                    </div>

                </section>

            </div>

            <aside class="support-right">

                <section class="card card-padding">
                    <div class="section-title">What you can ask here</div>
                    <div class="section-subtitle">
                        Useful support categories for faster assistance.
                    </div>

                    <div class="support-list">
                        <div class="support-item">
                            <div class="support-item-title">Materials and PDF upload</div>
                            <div class="support-item-text">
                                Problems with uploading PDFs, extracted text, AI summaries or missing materials.
                            </div>
                            <div class="mini-badge">Course resources</div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Planner and deadlines</div>
                            <div class="support-item-text">
                                Issues with your study plan, exam dates or task organization.
                            </div>
                            <div class="mini-badge">Planning help</div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Assessments and flashcards</div>
                            <div class="support-item-text">
                                Manual questions, quiz results, generated questions, flashcards or weak topic practice.
                            </div>
                            <div class="mini-badge">Learning support</div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Profile and account settings</div>
                            <div class="support-item-text">
                                Help with profile data, study preferences, password or account-related problems.
                            </div>
                            <div class="mini-badge">Account</div>
                        </div>
                    </div>
                </section>

                <section class="card card-padding">
                    <div class="section-title">Before sending</div>
                    <div class="section-subtitle">
                        Include these details to get a better answer.
                    </div>

                    <div class="support-list">
                        <div class="support-item">
                            <div class="support-item-title">Mention the page</div>
                            <div class="support-item-text">
                                Example: Materials, Planner, Assessment, Flashcards, Profile or Dashboard.
                            </div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Describe the problem clearly</div>
                            <div class="support-item-text">
                                Say what you expected, what happened and whether an error appeared.
                            </div>
                        </div>

                        <div class="support-item">
                            <div class="support-item-title">Add the course or topic</div>
                            <div class="support-item-text">
                                Example: Java, BD2, Web Programming, Management or another uploaded course.
                            </div>
                        </div>
                    </div>
                </section>

                <section class="cta-box">
                    <h3>Need instant study help?</h3>
                    <p>
                        For revision strategy, weak-topic explanations or learning recommendations,
                        ask the AI Coach before contacting admin support.
                    </p>
                    <a href="<%=ctx%>/ai-coach" class="cta-link">Open AI Coach →</a>
                </section>

            </aside>

        </section>

    </main>
</div>

<script>
    function fillTopic(text) {
        const input = document.getElementById("messageInput");

        if (input) {
            input.value = text;
            input.focus();
        }
    }

    const box = document.getElementById("messagesBox");

    if (box) {
        box.scrollTop = box.scrollHeight;
    }
</script>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.ChatMessage,com.smartstudy.model.ChatConversation,com.smartstudy.model.User" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Admin Messages</title>
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

        button,
        textarea {
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

        .chat-layout {
            display: grid;
            grid-template-columns: 360px minmax(0, 1fr);
            gap: 24px;
            align-items: start;
        }

        .panel {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            overflow: hidden;
        }

        .panel-header {
            padding: 22px 24px 18px;
            border-bottom: 1px solid var(--rule);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
        }

        .panel-title {
            color: var(--ink);
            font-size: 1.18rem;
            font-weight: 800;
            letter-spacing: -0.04em;
        }

        .panel-subtitle {
            margin-top: 4px;
            color: var(--ink-3);
            font-size: 0.88rem;
            line-height: 1.6;
        }

        .conversation-list {
            max-height: 720px;
            overflow-y: auto;
        }

        .conversation {
            display: block;
            padding: 16px 18px;
            border-bottom: 1px solid var(--rule);
            transition: 0.16s ease;
            background: white;
        }

        .conversation:last-child {
            border-bottom: none;
        }

        .conversation:hover,
        .conversation.active {
            background: var(--primary-soft);
        }

        .conversation-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 10px;
        }

        .conversation-name {
            font-weight: 800;
            color: var(--ink);
            font-size: 0.94rem;
        }

        .conversation-email {
            color: var(--ink-3);
            font-size: 0.76rem;
            margin-top: 2px;
        }

        .conversation-last {
            color: var(--ink-3);
            font-size: 0.82rem;
            margin-top: 8px;
            line-height: 1.45;
        }

        .unread {
            background: var(--red-bg);
            color: var(--red);
            padding: 5px 9px;
            border-radius: 999px;
            font-size: 0.68rem;
            font-weight: 800;
        }

        .chat-panel {
            display: grid;
            grid-template-rows: auto minmax(440px, 1fr) auto;
            min-height: 720px;
        }

        .chat-top {
            padding: 22px 24px 18px;
            border-bottom: 1px solid var(--rule);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
        }

        .chat-name {
            color: var(--ink);
            font-size: 1.18rem;
            font-weight: 800;
            letter-spacing: -0.03em;
        }

        .chat-email {
            color: var(--ink-3);
            font-size: 0.84rem;
            margin-top: 3px;
        }

        .messages {
            padding: 24px;
            overflow-y: auto;
            background: linear-gradient(180deg, #fafbfd 0%, #f6f8fb 100%);
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .message-row {
            display: flex;
            width: 100%;
        }

        .message-row.student {
            justify-content: flex-start;
        }

        .message-row.admin {
            justify-content: flex-end;
        }

        .bubble {
            max-width: 74%;
            padding: 14px 16px 12px;
            border-radius: 22px;
            line-height: 1.65;
            font-size: 0.92rem;
            box-shadow: 0 6px 18px rgba(15, 23, 42, 0.05);
        }

        .student .bubble {
            background: white;
            border: 1px solid var(--rule);
            color: var(--ink-2);
            border-bottom-left-radius: 8px;
        }

        .admin .bubble {
            background: var(--primary);
            color: white;
            border-bottom-right-radius: 8px;
        }

        .message-text {
            white-space: pre-wrap;
            word-break: break-word;
        }

        .message-meta {
            font-size: 0.72rem;
            opacity: 0.72;
            margin-top: 7px;
        }

        .chat-form {
            border-top: 1px solid var(--rule);
            padding: 18px 24px 24px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            gap: 12px;
            background: white;
            align-items: end;
        }

        textarea {
            width: 100%;
            min-height: 70px;
            max-height: 180px;
            resize: vertical;
            border: 1.5px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 16px;
            padding: 14px 16px;
            font-family: 'Geist', Arial, sans-serif;
            font-size: 0.92rem;
            color: var(--ink);
            outline: none;
            line-height: 1.6;
            transition: 0.18s ease;
        }

        textarea:focus {
            background: white;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(31, 58, 95, 0.12);
        }

        .send-btn {
            min-height: 50px;
            padding: 0 22px;
        }

        .empty {
            border: 1px dashed #cbd5e1;
            border-radius: 18px;
            padding: 22px;
            color: var(--ink-3);
            background: white;
            text-align: center;
            margin: 20px;
            font-size: 0.9rem;
            line-height: 1.6;
        }

        .empty.center {
            margin: auto;
            max-width: 480px;
        }

        @media (max-width: 1180px) {
            .hero {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .chat-layout {
                grid-template-columns: 1fr;
            }

            .conversation-list {
                max-height: 360px;
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

            .chat-form {
                grid-template-columns: 1fr;
            }

            .send-btn {
                width: 100%;
                min-height: 46px;
            }

            .bubble {
                max-width: 90%;
            }
        }
    </style>
</head>

<body>
<%
    String ctx = request.getContextPath();

    List<ChatConversation> conversations =
            (List<ChatConversation>) request.getAttribute("conversations");

    List<ChatMessage> messages =
            (List<ChatMessage>) request.getAttribute("messages");

    User selectedStudent = (User) request.getAttribute("selectedStudent");

    Integer selectedStudentIdObj = (Integer) request.getAttribute("selectedStudentId");
    int selectedStudentId = selectedStudentIdObj == null ? 0 : selectedStudentIdObj;

    Integer unreadCountObj = (Integer) request.getAttribute("unreadCount");
    int unreadCount = unreadCountObj == null ? 0 : unreadCountObj;

    if (conversations == null) conversations = new ArrayList<ChatConversation>();
    if (messages == null) messages = new ArrayList<ChatMessage>();

    int totalConversations = conversations.size();
    int totalMessages = messages.size();
    int selectedUnread = 0;

    for (ChatConversation c : conversations) {
        if (c.getStudentId() == selectedStudentId) {
            selectedUnread = c.getUnreadCount();
        }
    }
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
            <a href="<%=ctx%>/admin/courses">Courses</a>
            <a href="<%=ctx%>/admin/chat" class="active">Messages</a>
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
                <div class="hero-kicker">Student support messages</div>
                <h1>Manage conversations with students.</h1>
                <p>
                    Review student questions, respond to support messages and open each student's evolution page
                    when you need more context about courses, materials, quizzes or learning progress.
                </p>

                <div class="hero-actions">
                    <a href="<%=ctx%>/admin/dashboard" class="btn btn-light">Admin dashboard</a>
                    <a href="<%=ctx%>/admin/users" class="btn btn-ghost-light">Manage users</a>
                    <a href="<%=ctx%>/admin/courses" class="btn btn-ghost-light">Manage courses</a>
                    <a href="<%=ctx%>/dashboard?preview=admin" class="btn btn-ghost-light">Open student view</a>
                </div>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Unread messages</div>
                <div class="hero-panel-value"><%=unreadCount%></div>
                <div class="hero-panel-note">
                    Student messages waiting for administrator review.
                </div>
            </div>
        </section>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Conversations</div>
                <div class="stat-value"><%=totalConversations%></div>
                <div class="stat-sub">Student support threads</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Unread</div>
                <div class="stat-value"><%=unreadCount%></div>
                <div class="stat-sub">Messages waiting for reply</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Selected thread</div>
                <div class="stat-value"><%=selectedStudent == null ? "—" : totalMessages%></div>
                <div class="stat-sub">Messages in the opened conversation</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Thread unread</div>
                <div class="stat-value"><%=selectedStudent == null ? "—" : selectedUnread%></div>
                <div class="stat-sub">Unread messages in current thread</div>
            </div>
        </section>

        <section class="chat-layout">

            <aside class="panel">
                <div class="panel-header">
                    <div>
                        <div class="panel-title">Conversations</div>
                        <div class="panel-subtitle">
                            Select a student thread to read and answer support messages.
                        </div>
                    </div>
                </div>

                <div class="conversation-list">
                    <% if (!conversations.isEmpty()) {
                        for (ChatConversation c : conversations) {
                            boolean active = c.getStudentId() == selectedStudentId;
                            String last = c.getLastMessage() == null ? "" : c.getLastMessage();

                            if (last.length() > 80) {
                                last = last.substring(0, 80) + "...";
                            }
                    %>

                        <a href="<%=ctx%>/admin/chat?studentId=<%=c.getStudentId()%>"
                           class="conversation <%=active ? "active" : ""%>">

                            <div class="conversation-top">
                                <div>
                                    <div class="conversation-name">
                                        <%=c.getStudentName() == null ? "Unnamed student" : c.getStudentName()%>
                                    </div>

                                    <div class="conversation-email">
                                        <%=c.getStudentEmail() == null ? "-" : c.getStudentEmail()%>
                                    </div>
                                </div>

                                <% if (c.getUnreadCount() > 0) { %>
                                    <span class="unread"><%=c.getUnreadCount()%></span>
                                <% } %>
                            </div>

                            <div class="conversation-last">
                                <%=last.isBlank() ? "No preview available." : last%>
                            </div>
                        </a>

                    <%  }
                    } else { %>

                        <div class="empty">
                            No student conversations yet.
                        </div>

                    <% } %>
                </div>
            </aside>

            <section class="panel chat-panel">

                <% if (selectedStudent != null) { %>

                    <div class="chat-top">
                        <div>
                            <div class="chat-name"><%=selectedStudent.getFullName()%></div>
                            <div class="chat-email"><%=selectedStudent.getEmail()%></div>
                        </div>

                        <a href="<%=ctx%>/admin/student-details?id=<%=selectedStudent.getId()%>" class="btn btn-soft">
                            View evolution
                        </a>
                    </div>

                    <div class="messages" id="messagesBox">
                        <% if (!messages.isEmpty()) {
                            for (ChatMessage m : messages) {
                                boolean sentByAdmin = "ADMIN".equalsIgnoreCase(m.getSenderRole());
                        %>

                            <div class="message-row <%=sentByAdmin ? "admin" : "student"%>">
                                <div class="bubble">
                                    <div class="message-text"><%=m.getMessageText()%></div>
                                    <div class="message-meta">
                                        <%=sentByAdmin ? "Admin" : "Student"%>
                                        · <%=m.getCreatedAt() == null ? "" : m.getCreatedAt()%>
                                    </div>
                                </div>
                            </div>

                        <%  }
                        } else { %>

                            <div class="empty center">
                                No messages in this conversation yet.
                            </div>

                        <% } %>
                    </div>

                    <form method="post" action="<%=ctx%>/admin/chat" class="chat-form">
                        <input type="hidden" name="studentId" value="<%=selectedStudent.getId()%>">
                        <textarea name="messageText" placeholder="Write an answer to this student..." required></textarea>
                        <button type="submit" class="btn btn-primary send-btn">Send</button>
                    </form>

                <% } else { %>

                    <div class="empty center">
                        Select a conversation from the left side to start replying.
                    </div>

                <% } %>

            </section>

        </section>

    </main>
</div>

<script>
    const box = document.getElementById("messagesBox");

    if (box) {
        box.scrollTop = box.scrollHeight;
    }
</script>

</body>
</html>
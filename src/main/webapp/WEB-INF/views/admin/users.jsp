<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.User" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Admin Users</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://fonts.googleapis.com/css2?family=Geist:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap used only for the delete confirmation modal -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

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
            max-width: 1500px;
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
            text-decoration: none;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            color: white;
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
            color: white;
        }

        .btn-danger {
            background: var(--red-bg);
            color: var(--red);
        }

        .btn-danger:hover {
            filter: brightness(0.98);
            transform: translateY(-1px);
            color: var(--red);
        }

        .btn-soft {
            background: var(--primary-soft);
            color: var(--primary);
        }

        .btn-soft:hover {
            background: #e4edf8;
            transform: translateY(-1px);
            color: var(--primary);
        }

        .btn-message {
            background: var(--blue-bg);
            color: var(--blue);
        }

        .btn-message:hover {
            filter: brightness(0.98);
            transform: translateY(-1px);
            color: var(--blue);
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
            grid-template-columns: minmax(0, 1fr) 360px;
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

        .admin-right {
            position: static;
            width: 100%;
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
            min-width: 980px;
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
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background: white;
        }

        .user-cell {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
        }

        .user-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 800;
            flex-shrink: 0;
        }

        .user-name {
            color: var(--ink);
            font-weight: 800;
        }

        .user-id {
            color: var(--ink-4);
            font-size: 0.75rem;
            margin-top: 2px;
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

        .status {
            display: inline-flex;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .status.none {
            background: var(--surface-soft);
            color: var(--ink-3);
        }

        .status.pending {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .status.approved {
            background: var(--green-bg);
            color: var(--green);
        }

        .status.rejected {
            background: var(--red-bg);
            color: var(--red);
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
        }

        .request-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .request-item,
        .side-item {
            border: 1px solid var(--rule);
            border-radius: 18px;
            padding: 16px;
            background: #fbfcfe;
            min-width: 0;
        }

        .request-top,
        .side-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
            margin-bottom: 12px;
        }

        .request-name,
        .side-title {
            color: var(--ink);
            font-weight: 800;
        }

        .request-email,
        .side-text {
            color: var(--ink-3);
            font-size: 0.82rem;
            margin-top: 2px;
            line-height: 1.55;
            overflow-wrap: anywhere;
        }

        .request-reason {
            color: var(--ink-2);
            background: white;
            border: 1px solid var(--rule);
            border-radius: 14px;
            padding: 12px;
            font-size: 0.86rem;
            line-height: 1.55;
            overflow-wrap: anywhere;
        }

        .request-meta {
            color: var(--ink-4);
            font-size: 0.76rem;
            margin-top: 8px;
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

        .bootstrap-note {
            margin-bottom: 16px;
            padding: 10px 12px;
            border-radius: 14px;
            background: var(--primary-soft);
            color: var(--primary);
            font-size: 0.78rem;
            font-weight: 700;
            border: 1px solid #d8e5f5;
        }

        .modal-content {
            border: none;
            border-radius: 24px;
            box-shadow: 0 24px 70px rgba(15, 23, 42, 0.22);
            overflow: hidden;
        }

        .modal-header {
            border-bottom: 1px solid var(--rule);
            padding: 20px 22px;
        }

        .modal-title {
            font-weight: 800;
            color: var(--ink);
            letter-spacing: -0.03em;
        }

        .modal-body {
            padding: 22px;
            color: var(--ink-2);
            line-height: 1.7;
        }

        .modal-footer {
            border-top: 1px solid var(--rule);
            padding: 18px 22px;
            background: #fbfcfe;
        }

        .delete-user-name {
            font-weight: 800;
            color: var(--red);
        }

        @media (max-width: 1320px) {
            .main {
                max-width: 1180px;
            }

            .admin-layout {
                grid-template-columns: minmax(0, 1fr) 330px;
            }

            table {
                min-width: 980px;
            }
        }

        @media (max-width: 1180px) {
            .hero,
            .admin-layout {
                grid-template-columns: 1fr;
            }

            .admin-right {
                position: static;
                display: grid;
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 20px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .hero-panel {
                max-width: 380px;
            }
        }

        @media (max-width: 980px) {
            .admin-right {
                grid-template-columns: 1fr;
            }

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

            .stats-grid {
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

    List<User> users = (List<User>) request.getAttribute("users");
    List<User> pendingAdminRequests = (List<User>) request.getAttribute("pendingAdminRequests");

    if (users == null) {
        users = new ArrayList<User>();
    }

    if (pendingAdminRequests == null) {
        pendingAdminRequests = new ArrayList<User>();
    }

    int totalUsers = users.size();
    int totalAdmins = 0;
    int totalStudents = 0;

    for (User u : users) {
        String userRole = u.getRole() == null ? "STUDENT" : u.getRole();

        if ("ADMIN".equalsIgnoreCase(userRole)) {
            totalAdmins++;
        } else {
            totalStudents++;
        }
    }

    int pendingRequests = pendingAdminRequests.size();
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
            <a href="<%=ctx%>/admin/users" class="active">Users</a>
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
            <div class="hero-left">
                <div class="hero-kicker">Administrator workspace</div>
                <h1>Manage users and access requests.</h1>
                <p>
                    Review platform accounts, monitor user roles and validate administrator access requests.
                    New accounts remain students until an administrator explicitly approves elevated access.
                </p>

                <div class="hero-actions">
                    <a href="<%=ctx%>/admin/dashboard" class="btn btn-light">Admin dashboard</a>
                    <a href="<%=ctx%>/admin/courses" class="btn btn-ghost-light">Manage courses</a>
                    <a href="<%=ctx%>/admin/chat" class="btn btn-ghost-light">Messages</a>
                    <a href="<%=ctx%>/dashboard?preview=admin" class="btn btn-ghost-light">Open student view</a>
                </div>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Pending requests</div>
                <div class="hero-panel-value"><%=pendingRequests%></div>
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
                <div class="stat-sub">Management accounts</div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Admin requests</div>
                <div class="stat-value"><%=pendingRequests%></div>
                <div class="stat-sub">Pending validation</div>
            </div>
        </section>

        <section class="admin-layout">

            <div class="admin-left">

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Administrator access requests</div>
                            <div class="card-subtitle">
                                Users who asked for administrator access during registration.
                            </div>
                        </div>
                    </div>

                    <% if (!pendingAdminRequests.isEmpty()) { %>
                        <div class="request-list">
                            <% for (User u : pendingAdminRequests) { %>
                                <div class="request-item">
                                    <div class="request-top">
                                        <div>
                                            <div class="request-name"><%=u.getFullName()%></div>
                                            <div class="request-email"><%=u.getEmail()%></div>
                                        </div>

                                        <span class="status pending">Pending</span>
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

                                    <div class="actions" style="margin-top: 12px;">
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

                                        <a href="<%=ctx%>/admin/chat?studentId=<%=u.getId()%>" class="btn btn-message">
                                            Message
                                        </a>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="empty">
                            No pending administrator requests. When a student asks for administrator access during registration,
                            the request will appear here.
                        </div>
                    <% } %>
                </section>

                <section class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">User management</div>
                            <div class="card-subtitle">
                                View all registered users, open learning progress and contact students directly.
                            </div>
                        </div>
                    </div>

                    <div class="bootstrap-note">
                        Bootstrap is used on this page for the delete confirmation modal, while the main design remains custom CSS.
                    </div>

                    <div class="table-wrap">
                        <table>
                            <thead>
                            <tr>
                                <th>User</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Admin request</th>
                                <th>Requested at</th>
                                <th>Actions</th>
                            </tr>
                            </thead>

                            <tbody>
                            <% if (!users.isEmpty()) {
                                for (User u : users) {
                                    String userRole = u.getRole() == null ? "STUDENT" : u.getRole();
                                    boolean userIsAdmin = "ADMIN".equalsIgnoreCase(userRole);

                                    String status = u.getAdminRequestStatus() == null ? "NONE" : u.getAdminRequestStatus();
                                    String statusClass = status.toLowerCase();

                                    if (!statusClass.equals("pending")
                                            && !statusClass.equals("approved")
                                            && !statusClass.equals("rejected")) {
                                        statusClass = "none";
                                    }

                                    String fullName = u.getFullName() == null || u.getFullName().isBlank()
                                            ? "Unnamed user"
                                            : u.getFullName();

                                    String initials = "U";
                                    String[] parts = fullName.trim().split("\\s+");

                                    if (parts.length >= 2) {
                                        initials = parts[0].substring(0, 1).toUpperCase()
                                                + parts[1].substring(0, 1).toUpperCase();
                                    } else if (parts.length == 1 && !parts[0].isBlank()) {
                                        initials = parts[0].substring(0, 1).toUpperCase();
                                    }

                                    boolean mainAdmin = u.getId() == 1 && userIsAdmin;
                            %>
                                <tr>
                                    <td>
                                        <div class="user-cell">
                                            <div class="user-avatar"><%=initials%></div>
                                            <div>
                                                <div class="user-name"><%=fullName%></div>
                                                <div class="user-id">ID #<%=u.getId()%></div>
                                            </div>
                                        </div>
                                    </td>

                                    <td><%=u.getEmail()%></td>

                                    <td>
                                        <span class="role <%=userIsAdmin ? "admin" : "student"%>">
                                            <%=userRole%>
                                        </span>
                                    </td>

                                    <td>
                                        <span class="status <%=statusClass%>">
                                            <%=status%>
                                        </span>
                                    </td>

                                    <td>
                                        <%=u.getAdminRequestCreatedAt() == null ? "-" : u.getAdminRequestCreatedAt()%>
                                    </td>

                                    <td>
                                        <div class="actions">

                                            <% if (mainAdmin) { %>

                                                <span class="status approved">Main admin</span>

                                            <% } else { %>

                                                <% if (userIsAdmin) { %>

                                                    <form method="post" action="<%=ctx%>/admin/update-role"
                                                          onsubmit="return confirm('Are you sure you want to remove administrator access from this user?');">
                                                        <input type="hidden" name="userId" value="<%=u.getId()%>">
                                                        <input type="hidden" name="role" value="STUDENT">
                                                        <button class="btn btn-soft" type="submit">Make student</button>
                                                    </form>

                                                <% } else { %>

                                                    <a href="<%=ctx%>/admin/student-details?id=<%=u.getId()%>" class="btn btn-primary">
                                                        View evolution
                                                    </a>

                                                    <a href="<%=ctx%>/admin/chat?studentId=<%=u.getId()%>" class="btn btn-message">
                                                        Message
                                                    </a>

                                                    <span class="status none">Student account</span>

                                                <% } %>

                                                <button type="button"
                                                        class="btn btn-danger"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#deleteUserModal"
                                                        data-user-id="<%=u.getId()%>"
                                                        data-user-name="<%=fullName%>">
                                                    Delete
                                                </button>

                                            <% } %>

                                        </div>
                                    </td>
                                </tr>
                            <%  }
                            } else { %>
                                <tr>
                                    <td colspan="6">No users found.</td>
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
                                Quick links for managing users and access.
                            </div>
                        </div>
                    </div>

                    <div class="quick-actions">
                        <a href="<%=ctx%>/admin/dashboard" class="btn btn-primary">📊 Admin dashboard</a>
                        <a href="<%=ctx%>/admin/courses" class="btn btn-soft">📚 Manage courses</a>
                        <a href="<%=ctx%>/admin/chat" class="btn btn-message">💬 Messages</a>
                        <a href="<%=ctx%>/dashboard?preview=admin" class="btn btn-soft">🎓 Open student view</a>
                    </div>
                </section>

                <section class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Access policy</div>
                            <div class="card-subtitle">
                                Rules applied to administrator privileges.
                            </div>
                        </div>
                    </div>

                    <div class="request-list">
                        <div class="side-item">
                            <div class="side-title">Students by default</div>
                            <div class="side-text">
                                New accounts remain students until an administrator validates the request.
                            </div>
                        </div>

                        <div class="side-item">
                            <div class="side-title">Manual approval</div>
                            <div class="side-text">
                                Admin rights are granted only after approval from this page.
                            </div>
                        </div>

                        <div class="side-item">
                            <div class="side-title">Main admin protection</div>
                            <div class="side-text">
                                The main administrator account should not be deleted or downgraded.
                            </div>
                        </div>
                    </div>
                </section>

                <section class="card compact-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">User overview</div>
                            <div class="card-subtitle">
                                Current account distribution.
                            </div>
                        </div>
                    </div>

                    <div class="request-list">
                        <div class="side-item">
                            <div class="side-title"><%=totalStudents%> students</div>
                            <div class="side-text">Learning accounts using materials, quizzes and study plans.</div>
                        </div>

                        <div class="side-item">
                            <div class="side-title"><%=totalAdmins%> administrators</div>
                            <div class="side-text">Accounts with platform supervision permissions.</div>
                        </div>

                        <div class="side-item">
                            <div class="side-title"><%=pendingRequests%> pending requests</div>
                            <div class="side-text">Administrator access requests waiting for validation.</div>
                        </div>
                    </div>
                </section>

            </aside>

        </section>

    </main>
</div>

<!-- Bootstrap modal -->
<div class="modal fade" id="deleteUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Confirm user deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                Are you sure you want to delete
                <span class="delete-user-name" id="deleteUserName">this user</span>?
                <br>
                This action cannot be undone.
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-soft" data-bs-dismiss="modal">
                    Cancel
                </button>

                <form method="post" action="<%=ctx%>/admin/users" id="deleteUserForm">
                    <input type="hidden" name="id" id="deleteUserId">
                    <button type="submit" class="btn btn-danger">
                        Delete user
                    </button>
                </form>
            </div>

        </div>
    </div>
</div>

<!-- Bootstrap JS used for the modal component -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const deleteUserModal = document.getElementById('deleteUserModal');

    if (deleteUserModal) {
        deleteUserModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const userId = button.getAttribute('data-user-id');
            const userName = button.getAttribute('data-user-name');

            document.getElementById('deleteUserId').value = userId;
            document.getElementById('deleteUserName').textContent = userName || 'this user';
        });
    }
</script>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.smartstudy.model.User" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Admin Profile</title>
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
            text-decoration: none;
            color: inherit;
        }

        input,
        textarea,
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

        .hero-left,
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
            margin-bottom: 15px;
        }

        .hero h1 {
            font-size: clamp(2.25rem, 4vw, 3.7rem);
            line-height: 1.02;
            letter-spacing: -0.065em;
            margin-bottom: 16px;
        }

        .hero p {
            max-width: 780px;
            color: rgba(255,255,255,0.72);
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
            font-size: 1.8rem;
            line-height: 1.1;
            font-weight: 800;
            letter-spacing: -0.05em;
        }

        .hero-panel-note {
            margin-top: 8px;
            color: rgba(255,255,255,0.68);
            font-size: 0.86rem;
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

        .layout {
            display: grid;
            grid-template-columns: 360px minmax(0, 1fr);
            gap: 24px;
            align-items: start;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 26px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.04);
        }

        .profile-card {
            text-align: center;
        }

        .avatar-wrap {
            width: 132px;
            height: 132px;
            margin: 0 auto 18px;
        }

        .avatar,
        .avatar-fallback {
            width: 132px;
            height: 132px;
            border-radius: 50%;
            border: 5px solid white;
            box-shadow: 0 12px 28px rgba(15,23,42,0.18);
        }

        .avatar {
            object-fit: cover;
            background: var(--primary-soft);
        }

        .avatar-fallback {
            background: var(--primary-dark);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            font-weight: 800;
        }

        .profile-name {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--ink);
            letter-spacing: -0.035em;
        }

        .profile-email {
            color: var(--ink-3);
            font-size: 0.9rem;
            margin-top: 4px;
            word-break: break-word;
        }

        .profile-role {
            display: inline-flex;
            margin-top: 14px;
            padding: 6px 12px;
            border-radius: 999px;
            background: var(--primary-soft);
            color: var(--primary);
            font-size: 0.78rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .info-list {
            display: grid;
            gap: 12px;
            margin-top: 24px;
            text-align: left;
        }

        .info-row {
            background: var(--surface-soft);
            border: 1px solid var(--rule);
            border-radius: 14px;
            padding: 13px 14px;
        }

        .info-label {
            color: var(--ink-4);
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .info-value {
            margin-top: 4px;
            color: var(--ink-2);
            font-size: 0.9rem;
        }

        .section-title {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--ink);
            letter-spacing: -0.04em;
        }

        .section-subtitle {
            color: var(--ink-3);
            font-size: 0.92rem;
            margin-top: 5px;
            line-height: 1.7;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-top: 24px;
        }

        .field {
            display: grid;
            gap: 7px;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .label {
            font-size: 0.82rem;
            font-weight: 800;
            color: var(--ink-2);
        }

        .input,
        .textarea {
            width: 100%;
            border: 1.5px solid var(--rule);
            background: var(--surface-soft);
            border-radius: 13px;
            padding: 12px 14px;
            font-size: 0.92rem;
            color: var(--ink);
            outline: none;
            transition: 0.2s;
        }

        .textarea {
            min-height: 130px;
            resize: vertical;
            line-height: 1.7;
        }

        .input:focus,
        .textarea:focus {
            background: white;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(31,58,95,0.12);
        }

        .file-box {
            border: 1.5px dashed #cbd5e1;
            background: #f8fafc;
            border-radius: 16px;
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .file-icon {
            width: 44px;
            height: 44px;
            border-radius: 14px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            flex-shrink: 0;
        }

        .help {
            color: var(--ink-4);
            font-size: 0.78rem;
            line-height: 1.45;
            margin-top: 4px;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            margin-top: 24px;
            border-top: 1px solid var(--rule);
            padding-top: 22px;
        }

        .btn {
            border: none;
            border-radius: 13px;
            padding: 12px 18px;
            font-weight: 800;
            font-size: 0.9rem;
            cursor: pointer;
            transition: 0.2s;
            text-align: center;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
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
            border: 1px solid var(--rule);
        }

        .btn-secondary:hover {
            border-color: var(--ink-4);
            transform: translateY(-1px);
        }

        @media (max-width: 1180px) {
            .hero,
            .layout {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 900px) {
            .nav-links {
                display: none;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 700px) {
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

    if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(ctx + "/dashboard");
        return;
    }

    String fullName = currentUser.getFullName() == null ? "" : currentUser.getFullName();
    String email = currentUser.getEmail() == null ? "" : currentUser.getEmail();
    String role = currentUser.getRole() == null ? "ADMIN" : currentUser.getRole();
    String description = currentUser.getDescription() == null ? "" : currentUser.getDescription();
    String profilePhoto = currentUser.getProfilePhoto();

    String initials = "AD";

    if (!fullName.trim().isEmpty()) {
        String[] parts = fullName.trim().split("\\s+");

        if (parts.length >= 2) {
            initials = parts[0].substring(0, 1).toUpperCase()
                    + parts[1].substring(0, 1).toUpperCase();
        } else {
            initials = fullName.substring(0, 1).toUpperCase();
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
            <a href="<%=ctx%>/admin/chat">Messages</a>
            <a href="<%=ctx%>/admin/profile" class="active">Admin profile</a>
            <a href="<%=ctx%>/dashboard?preview=admin" class="student-view-link">Student view</a>
            <a href="<%=ctx%>/logout">Logout</a>
        </div>
    </div>
</nav>

<div class="page">
    <main class="main">

        <section class="hero">
            <div class="hero-left">
                <div class="hero-kicker">Administrator identity</div>
                <h1>Manage your admin profile.</h1>
                <p>
                    Update your administrator identity, profile image and internal description.
                    This profile is separate from the student profile and is used only in the administration workspace.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Admin account</div>
                <div class="hero-panel-value"><%=fullName.isBlank() ? "Administrator" : fullName%></div>
                <div class="hero-panel-note">Platform supervision and support access.</div>
            </div>
        </section>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%=request.getAttribute("success")%></div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%=request.getAttribute("error")%></div>
        <% } %>

        <section class="layout">

            <aside class="card profile-card">
                <div class="avatar-wrap">
                    <% if (profilePhoto != null && !profilePhoto.isBlank()) { %>
                        <img src="<%=ctx%>/<%=profilePhoto%>?v=<%=System.currentTimeMillis()%>" class="avatar" alt="Admin profile photo">
                    <% } else { %>
                        <div class="avatar-fallback"><%=initials%></div>
                    <% } %>
                </div>

                <div class="profile-name"><%=fullName.isBlank() ? "Administrator" : fullName%></div>
                <div class="profile-email"><%=email%></div>
                <div class="profile-role"><%=role%></div>

                <div class="info-list">
                    <div class="info-row">
                        <div class="info-label">Workspace</div>
                        <div class="info-value">Administration panel</div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Permissions</div>
                        <div class="info-value">Users, courses, messages and student monitoring</div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Description</div>
                        <div class="info-value">
                            <%=description.isBlank() ? "No admin description added yet." : description%>
                        </div>
                    </div>
                </div>
            </aside>

            <section class="card">
                <div>
                    <div class="section-title">Profile information</div>
                    <div class="section-subtitle">
                        Update your admin name, internal description and profile image.
                    </div>
                </div>

                <form method="post" action="<%=ctx%>/admin/profile" enctype="multipart/form-data">

                    <div class="form-grid">
                        <div class="field">
                            <label class="label">Full name</label>
                            <input type="text" name="fullName" value="<%=fullName%>" class="input" required>
                        </div>

                        <div class="field">
                            <label class="label">Email address</label>
                            <input type="email" value="<%=email%>" class="input" readonly>
                            <div class="help">Email is used for login and cannot be changed here.</div>
                        </div>

                        <div class="field full">
                            <label class="label">Profile photo</label>
                            <div class="file-box">
                                <div class="file-icon">IMG</div>
                                <div style="flex:1;">
                                    <input type="file" name="profilePhoto" accept="image/png,image/jpeg,image/jpg">
                                    <div class="help">Accepted formats: PNG, JPG, JPEG. Maximum recommended size: 5 MB.</div>
                                </div>
                            </div>
                        </div>

                        <div class="field full">
                            <label class="label">Admin description</label>
                            <textarea name="description" class="textarea" placeholder="Example: Platform administrator responsible for validating users, supervising student progress and responding to support messages."><%=description%></textarea>
                            <div class="help">This text is visible in your admin profile card only.</div>
                        </div>
                    </div>

                    <div class="actions">
                        <a href="<%=ctx%>/admin/dashboard" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">Save admin profile</button>
                    </div>

                </form>
            </section>

        </section>

    </main>
</div>

</body>
</html>
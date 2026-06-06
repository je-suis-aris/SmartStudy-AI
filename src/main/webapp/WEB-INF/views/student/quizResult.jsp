<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.*" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Quiz Result</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://fonts.googleapis.com/css2?family=Geist:wght@300;400;500;600;700&display=swap" rel="stylesheet">

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
            --green-border: #bbf7d0;
            --red: #991b1b;
            --red-bg: #fef2f2;
            --red-border: #fecaca;
            --amber: #b7791f;
            --amber-bg: #fffbeb;
            --shadow: 0 12px 35px rgba(15, 23, 42, 0.08);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Geist', Arial, sans-serif;
            background: var(--bg);
            color: var(--ink);
            min-height: 100vh;
            font-size: 15px;
            line-height: 1.6;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .nav {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 200;
            height: 66px;
            background: rgba(255,255,255,0.96);
            backdrop-filter: blur(14px);
            border-bottom: 1px solid var(--rule);
            display: flex;
            align-items: center;
            padding: 0 32px;
        }

        .nav-inner {
            width: 100%;
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.12rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            margin-right: auto;
            white-space: nowrap;
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
            gap: 4px;
        }

        .nav-links a {
            color: var(--ink-3);
            font-size: 0.84rem;
            font-weight: 500;
            padding: 8px 11px;
            border-radius: 9px;
            transition: 0.2s;
        }

        .nav-links a:hover {
            color: var(--ink);
            background: var(--surface-soft);
        }

        .nav-links a.active {
            color: var(--primary);
            background: var(--primary-soft);
            font-weight: 600;
        }

        .page {
            padding-top: 66px;
            min-height: 100vh;
        }

        .main {
            max-width: 1280px;
            margin: 0 auto;
            padding: 34px 32px 70px;
        }

        .hero {
            background: linear-gradient(135deg, #10243d 0%, #1f3a5f 100%);
            color: white;
            border-radius: 28px;
            padding: 36px 40px;
            margin-bottom: 26px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 30px;
            align-items: center;
            box-shadow: 0 16px 40px rgba(15, 23, 42, 0.14);
            position: relative;
            overflow: hidden;
        }

        .hero::after {
            content: "";
            position: absolute;
            right: -120px;
            top: -140px;
            width: 390px;
            height: 390px;
            border-radius: 50%;
            background: rgba(255,255,255,0.05);
        }

        .hero-content,
        .score-panel {
            position: relative;
            z-index: 1;
        }

        .hero-kicker {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.13em;
            text-transform: uppercase;
            color: rgba(255,255,255,0.55);
            margin-bottom: 14px;
        }

        .hero h1 {
            font-size: clamp(2rem, 4vw, 3.2rem);
            line-height: 1.05;
            letter-spacing: -0.055em;
            margin-bottom: 14px;
        }

        .hero p {
            color: rgba(255,255,255,0.72);
            max-width: 760px;
            font-size: 1rem;
            line-height: 1.75;
        }

        .score-panel {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.14);
            border-radius: 22px;
            padding: 24px;
        }

        .score-label {
            color: rgba(255,255,255,0.58);
            font-size: 0.76rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .score-value {
            font-size: 2.6rem;
            font-weight: 700;
            letter-spacing: -0.055em;
            line-height: 1;
        }

        .score-note {
            color: rgba(255,255,255,0.65);
            font-size: 0.85rem;
            margin-top: 8px;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 26px;
        }

        .metric-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 22px;
            padding: 22px;
            min-height: 135px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.04);
        }

        .metric-label {
            color: var(--ink-3);
            font-size: 0.74rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .metric-value {
            color: var(--ink);
            font-size: 2rem;
            font-weight: 700;
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
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 24px;
            align-items: start;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 24px;
            padding: 26px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
        }

        .card-title {
            font-size: 1.15rem;
            font-weight: 700;
            letter-spacing: -0.025em;
            margin-bottom: 6px;
        }

        .card-subtitle {
            color: var(--ink-3);
            font-size: 0.86rem;
            margin-bottom: 22px;
        }

        .review-list {
            display: grid;
            gap: 14px;
        }

        .question-review {
            border: 1px solid var(--rule);
            background: white;
            border-radius: 20px;
            padding: 18px;
            display: grid;
            grid-template-columns: 44px 1fr auto;
            gap: 14px;
            align-items: start;
            transition: 0.2s;
        }

        .question-review:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .question-review.correct {
            border-color: var(--green-border);
            background: linear-gradient(135deg, #ffffff 0%, #f7fff9 100%);
        }

        .question-review.wrong {
            border-color: var(--red-border);
            background: linear-gradient(135deg, #ffffff 0%, #fff8f8 100%);
        }

        .question-number {
            width: 44px;
            height: 44px;
            border-radius: 14px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }

        .question-text {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--ink);
            line-height: 1.55;
        }

        .question-meta {
            color: var(--ink-3);
            font-size: 0.82rem;
            margin-top: 6px;
        }

        .status-badge {
            border-radius: 999px;
            padding: 7px 11px;
            font-size: 0.72rem;
            font-weight: 700;
            white-space: nowrap;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .status-badge.correct {
            color: var(--green);
            background: var(--green-bg);
        }

        .status-badge.wrong {
            color: var(--red);
            background: var(--red-bg);
        }

        .side-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
            margin-bottom: 18px;
        }

        .progress-ring {
            width: 170px;
            height: 170px;
            border-radius: 50%;
            margin: 18px auto;
            background:
                conic-gradient(var(--primary) var(--percent), #edf0f4 0);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .progress-ring::after {
            content: "";
            position: absolute;
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: white;
        }

        .progress-ring-value {
            position: relative;
            z-index: 1;
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: -0.05em;
            color: var(--ink);
        }

        .feedback-box {
            background: var(--primary-soft);
            color: var(--primary-dark);
            border: 1px solid #d8e3f1;
            border-radius: 18px;
            padding: 16px;
            font-size: 0.88rem;
            line-height: 1.7;
        }

        .ai-feedback-box {
            background: linear-gradient(135deg, #eef3f9 0%, #f8fbff 100%);
            color: var(--primary-dark);
            border: 1px solid #d8e3f1;
            border-radius: 18px;
            padding: 18px;
            line-height: 1.75;
            font-size: 0.92rem;
        }

        .ai-metric-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
            margin-top: 14px;
        }

        .ai-mini-metric {
            background: #fbfcfe;
            border: 1px solid var(--rule);
            border-radius: 16px;
            padding: 14px;
        }

        .ai-mini-label {
            color: var(--ink-3);
            font-size: 0.68rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .ai-mini-value {
            color: var(--ink);
            font-size: 1.7rem;
            font-weight: 700;
            margin-top: 6px;
            line-height: 1;
        }

        .actions {
            display: grid;
            gap: 10px;
            margin-top: 16px;
        }

        .btn {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            border-radius: 13px;
            padding: 12px 16px;
            font-size: 0.88rem;
            font-weight: 700;
            border: 1px solid transparent;
            transition: 0.2s;
            cursor: pointer;
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
        }

        .empty-state {
            background: white;
            border: 1px dashed #cbd5e1;
            border-radius: 24px;
            padding: 34px 26px;
            text-align: center;
            color: var(--ink-3);
        }

        .empty-title {
            color: var(--ink);
            font-size: 1.15rem;
            font-weight: 700;
            margin-bottom: 6px;
        }

        @media (max-width: 1050px) {
            .hero,
            .layout {
                grid-template-columns: 1fr;
            }

            .metrics-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 700px) {
            .main {
                padding: 24px 18px 60px;
            }

            .nav {
                padding: 0 20px;
            }

            .nav-links {
                display: none;
            }

            .metrics-grid,
            .ai-metric-grid {
                grid-template-columns: 1fr;
            }

            .question-review {
                grid-template-columns: 1fr;
            }

            .status-badge {
                width: fit-content;
            }
        }
    </style>
</head>

<body>

<%
    String ctx = request.getContextPath();

    Object scoreObj = request.getAttribute("score");
    Object totalObj = request.getAttribute("total");

    int score = 0;
    int total = 0;

    if (scoreObj instanceof Number) {
        score = ((Number) scoreObj).intValue();
    }

    if (totalObj instanceof Number) {
        total = ((Number) totalObj).intValue();
    }

    double percent = total > 0 ? (score * 100.0 / total) : 0.0;
    int wrong = total - score;

    String resultMessage;
    if (total == 0) {
        resultMessage = "No quiz answers were received. Please retake the quiz and make sure the answers are submitted correctly.";
    } else if (percent >= 80) {
        resultMessage = "Excellent result. You understand most of the tested concepts.";
    } else if (percent >= 50) {
        resultMessage = "Good progress. Review the questions marked as needs review to improve your score.";
    } else {
        resultMessage = "This result shows that some topics need more revision. Focus first on the questions marked as needs review.";
    }

    List<Map<String,Object>> reviewItems = (List<Map<String,Object>>) request.getAttribute("reviewItems");

    if (reviewItems == null) {
        reviewItems = new ArrayList<Map<String,Object>>();
    }

    String aiFeedback = (String) request.getAttribute("aiFeedback");

    if (aiFeedback == null || aiFeedback.trim().isEmpty()) {
        aiFeedback = "AI feedback is not available for this quiz.";
    }

    Object mistakesObj = request.getAttribute("mistakesSaved");
    Object flashcardsObj = request.getAttribute("adaptiveFlashcards");

    int mistakesSaved = 0;
    int adaptiveFlashcards = 0;

    if (mistakesObj instanceof Number) {
        mistakesSaved = ((Number) mistakesObj).intValue();
    }

    if (flashcardsObj instanceof Number) {
        adaptiveFlashcards = ((Number) flashcardsObj).intValue();
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
            <a href="<%=ctx%>/assessment" class="active">Assessment</a>
            <a href="<%=ctx%>/insights">Insights</a>
            <a href="<%=ctx%>/stats">Stats</a>
            <a href="<%=ctx%>/profile">Profile</a>
            <a href="<%=ctx%>/chat">Support</a>
            <a href="<%=ctx%>/ai-coach">AI Coach</a>
            <a href="<%=ctx%>/logout">Logout</a>
        </div>
    </div>
</nav>

<div class="page">
    <main class="main">

        <section class="hero">
            <div class="hero-content">
                <div class="hero-kicker">Quiz completed</div>
                <h1>Your quiz result is ready.</h1>
                <p>
                    Your score has been saved. Use this review page to see which questions were correct
                    and which ones need revision. SmartStudy AI also generated personalized feedback from your performance.
                </p>
            </div>

            <div class="score-panel">
                <div class="score-label">Final score</div>
                <div class="score-value"><%=score%> / <%=total%></div>
                <div class="score-note"><%=String.format("%.1f", percent)%>% performance</div>
            </div>
        </section>

        <section class="metrics-grid">
            <div class="metric-card">
                <div class="metric-label">Correct answers</div>
                <div class="metric-value"><%=score%></div>
                <div class="metric-sub">Questions answered correctly.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Needs review</div>
                <div class="metric-value"><%=wrong%></div>
                <div class="metric-sub">Questions to revise again.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Total questions</div>
                <div class="metric-value"><%=total%></div>
                <div class="metric-sub">Questions submitted in this session.</div>
            </div>

            <div class="metric-card">
                <div class="metric-label">Performance</div>
                <div class="metric-value"><%=String.format("%.0f", percent)%>%</div>
                <div class="metric-sub">Overall result percentage.</div>
            </div>
        </section>

        <section class="layout">

            <div class="card">
                <div class="card-title">Question review</div>
                <div class="card-subtitle">
                    The system shows the question status only. The answer options are hidden.
                </div>

                <% if (reviewItems.isEmpty()) { %>

                    <div class="empty-state">
                        <div class="empty-title">No question review data available</div>
                        <div>
                            The score was received, but the servlet did not send the list of reviewed questions.
                            Update SubmitQuizServlet to send <strong>reviewItems</strong>.
                        </div>
                    </div>

                <% } else { %>

                    <div class="review-list">
                        <% int index = 1; %>

                        <% for (Map<String,Object> item : reviewItems) {
                            String questionText = String.valueOf(item.get("questionText"));
                            boolean correct = Boolean.TRUE.equals(item.get("correct"));
                            String explanation = item.get("explanation") != null ? String.valueOf(item.get("explanation")) : "";
                        %>

                            <div class="question-review <%=correct ? "correct" : "wrong"%>">
                                <div class="question-number"><%=index%></div>

                                <div>
                                    <div class="question-text"><%=questionText%></div>

                                    <% if (!explanation.trim().isEmpty()) { %>
                                        <div class="question-meta"><%=explanation%></div>
                                    <% } else { %>
                                        <div class="question-meta">
                                            <%=correct ? "This question was answered correctly." : "Review the related material and try this concept again."%>
                                        </div>
                                    <% } %>
                                </div>

                                <div class="status-badge <%=correct ? "correct" : "wrong"%>">
                                    <%=correct ? "Correct" : "Needs review"%>
                                </div>
                            </div>

                        <% index++; } %>
                    </div>

                <% } %>
            </div>

            <aside>
                <div class="side-card">
                    <div class="card-title">Performance overview</div>
                    <div class="card-subtitle">
                        A visual summary of your quiz result.
                    </div>

                    <div class="progress-ring" style="--percent:<%=String.format(java.util.Locale.US, "%.1f", percent)%>%;">
                        <div class="progress-ring-value"><%=String.format("%.0f", percent)%>%</div>
                    </div>

                    <div class="feedback-box">
                        <%=resultMessage%>
                    </div>

                    <div class="actions">
                        <a href="<%=ctx%>/assessment" class="btn btn-primary">Take another quiz</a>
                        <a href="<%=ctx%>/insights" class="btn btn-secondary">View AI insights</a>
                        <a href="<%=ctx%>/materials" class="btn btn-secondary">Review materials</a>
                    </div>
                </div>

                <div class="side-card">
                    <div class="card-title">AI feedback</div>
                    <div class="card-subtitle">
                        Personalized interpretation of your quiz performance.
                    </div>

                    <div class="ai-feedback-box">
                        <%=aiFeedback.replace("\n", "<br>")%>
                    </div>

                    <div class="ai-metric-grid">
                        <div class="ai-mini-metric">
                            <div class="ai-mini-label">Mistakes saved</div>
                            <div class="ai-mini-value"><%=mistakesSaved%></div>
                        </div>

                        <div class="ai-mini-metric">
                            <div class="ai-mini-label">Flashcards</div>
                            <div class="ai-mini-value"><%=adaptiveFlashcards%></div>
                        </div>
                    </div>

                    <div class="actions">
                        <a href="<%=ctx%>/flashcards" class="btn btn-secondary">Review adaptive flashcards</a>
                        <a href="<%=ctx%>/ai-coach" class="btn btn-secondary">Ask AI Coach</a>
                    </div>
                </div>
            </aside>

        </section>

    </main>
</div>

</body>
</html>
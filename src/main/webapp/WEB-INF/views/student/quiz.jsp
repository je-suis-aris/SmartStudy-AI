<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.smartstudy.model.*" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Quiz</title>
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
            --red: #991b1b;
            --red-bg: #fef2f2;
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
            font-size: 15px;
            line-height: 1.6;
            min-height: 100vh;
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
            max-width: 1320px;
            margin: 0 auto;
            padding: 34px 32px 70px;
        }

        .quiz-hero {
            background: linear-gradient(135deg, #10243d 0%, #1f3a5f 100%);
            color: white;
            border-radius: 28px;
            padding: 34px 38px;
            margin-bottom: 26px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 28px;
            align-items: center;
            box-shadow: 0 16px 40px rgba(15, 23, 42, 0.14);
            position: relative;
            overflow: hidden;
        }

        .quiz-hero::after {
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
        .hero-panel {
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

        .quiz-hero h1 {
            font-size: clamp(2rem, 4vw, 3.2rem);
            line-height: 1.05;
            letter-spacing: -0.055em;
            margin-bottom: 14px;
        }

        .quiz-hero p {
            color: rgba(255,255,255,0.72);
            max-width: 780px;
            font-size: 1rem;
            line-height: 1.75;
        }

        .hero-panel {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.14);
            border-radius: 22px;
            padding: 24px;
        }

        .hero-panel-label {
            color: rgba(255,255,255,0.58);
            font-size: 0.76rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .hero-panel-value {
            font-size: 2.4rem;
            font-weight: 700;
            letter-spacing: -0.055em;
            line-height: 1;
        }

        .hero-panel-note {
            color: rgba(255,255,255,0.65);
            font-size: 0.85rem;
            margin-top: 8px;
        }

        .layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 330px;
            gap: 24px;
            align-items: start;
        }

        .quiz-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 28px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
        }

        .question-list {
            display: grid;
            gap: 18px;
        }

        .question-card {
            border: 1px solid var(--rule);
            border-radius: 22px;
            background: white;
            padding: 22px;
            transition: 0.2s;
        }

        .question-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .question-header {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            margin-bottom: 16px;
        }

        .question-number {
            min-width: 36px;
            height: 36px;
            border-radius: 12px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
        }

        .question-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--ink);
            line-height: 1.5;
        }

        .options {
            display: grid;
            gap: 10px;
        }

        .option {
            position: relative;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            border: 1px solid var(--rule);
            border-radius: 15px;
            background: #f8fafc;
            padding: 13px 14px;
            cursor: pointer;
            transition: 0.2s;
        }

        .option:hover {
            border-color: #cbd5e1;
            background: white;
        }

        .option input {
            margin-top: 4px;
            accent-color: var(--primary);
        }

        .option span {
            color: var(--ink-2);
            font-size: 0.92rem;
            line-height: 1.55;
        }

        .option:has(input:checked) {
            border-color: var(--primary);
            background: var(--primary-soft);
            box-shadow: 0 0 0 3px rgba(31, 58, 95, 0.08);
        }

        .sidebar-panel {
            position: sticky;
            top: 90px;
            display: grid;
            gap: 18px;
        }

        .side-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 24px;
            padding: 22px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
        }

        .side-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--ink);
            letter-spacing: -0.02em;
            margin-bottom: 6px;
        }

        .side-text {
            color: var(--ink-3);
            font-size: 0.86rem;
            line-height: 1.65;
        }

        .progress-box {
            margin-top: 16px;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            color: var(--ink-3);
            font-size: 0.78rem;
            margin-bottom: 7px;
        }

        .progress-track {
            height: 9px;
            background: var(--rule);
            border-radius: 999px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            width: 0%;
            background: var(--primary);
            border-radius: 999px;
            transition: width 0.3s ease;
        }

        .question-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 16px;
        }

        .question-pill {
            width: 34px;
            height: 34px;
            border-radius: 11px;
            border: 1px solid var(--rule);
            background: #f8fafc;
            color: var(--ink-3);
            font-size: 0.78rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .question-pill.done {
            background: var(--green-bg);
            color: var(--green);
            border-color: #bbf7d0;
        }

        .timer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--surface-soft);
            border-radius: 16px;
            padding: 14px 16px;
            margin-top: 14px;
        }

        .timer-label {
            color: var(--ink-3);
            font-size: 0.8rem;
            font-weight: 600;
        }

        .timer-value {
            color: var(--primary);
            font-size: 1.15rem;
            font-weight: 700;
            letter-spacing: -0.04em;
        }

        .submit-section {
            margin-top: 24px;
            padding-top: 22px;
            border-top: 1px solid var(--rule);
            display: flex;
            justify-content: space-between;
            gap: 14px;
            align-items: center;
            flex-wrap: wrap;
        }

        .submit-note {
            color: var(--ink-3);
            font-size: 0.84rem;
        }

        .submit-btn {
            border: none;
            background: var(--primary);
            color: white;
            padding: 13px 20px;
            border-radius: 14px;
            font-family: 'Geist', Arial, sans-serif;
            font-size: 0.92rem;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
        }

        .submit-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .empty-state {
            background: white;
            border: 1px dashed #cbd5e1;
            border-radius: 24px;
            padding: 38px 26px;
            text-align: center;
            color: var(--ink-3);
        }

        .empty-state-title {
            color: var(--ink);
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 8px;
        }

        @media (max-width: 1100px) {
            .quiz-hero,
            .layout {
                grid-template-columns: 1fr;
            }

            .sidebar-panel {
                position: static;
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

            .quiz-hero {
                padding: 28px;
            }

            .quiz-card {
                padding: 20px;
            }

            .question-card {
                padding: 18px;
            }
        }
    </style>
</head>

<body>

<%
    String ctx = request.getContextPath();

    List<Question> questions = (List<Question>) request.getAttribute("questions");

    if (questions == null) {
        questions = new ArrayList<Question>();
    }

    String courseId = request.getParameter("courseId");

    if (courseId == null || courseId.trim().isEmpty()) {
        Object courseIdObj = request.getAttribute("courseId");
        courseId = courseIdObj != null ? String.valueOf(courseIdObj) : "";
    }

    int totalQuestions = questions.size();
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
            <a href="<%=ctx%>/logout">Logout</a>
        </div>
    </div>
</nav>

<div class="page">
    <main class="main">

        <section class="quiz-hero">
            <div class="hero-content">
                <div class="hero-kicker">Exam simulation mode</div>
                <h1>Answer focused questions and measure your preparation.</h1>
                <p>
                    This quiz was generated from your uploaded materials and question bank.
                    Select one answer for each question, then submit your answers to calculate your score.
                </p>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Questions</div>
                <div class="hero-panel-value"><%=totalQuestions%></div>
                <div class="hero-panel-note">AI-assisted assessment session</div>
            </div>
        </section>

        <% if (questions.isEmpty()) { %>

            <div class="empty-state">
                <div class="empty-state-title">No questions available</div>
                <div>
                    Generate questions from a material first, then start the quiz again.
                </div>
            </div>

        <% } else { %>

            <form method="post" action="<%=ctx%>/submit-quiz" id="quizForm">

                <input type="hidden" name="courseId" value="<%=courseId%>">

                <section class="layout">

                    <div class="quiz-card">
                        <div class="question-list">

                            <% int index = 1; %>

                            <% for (Question q : questions) { %>

                                <div class="question-card" id="question-<%=index%>">

                                    <input type="hidden" name="questionId" value="<%=q.getId()%>">

                                    <div class="question-header">
                                        <div class="question-number"><%=index%></div>

                                        <div class="question-title">
                                            <%=q.getQuestionText()%>
                                        </div>
                                    </div>

                                    <div class="options">

                                        <label class="option">
                                            <input
                                                    type="radio"
                                                    name="answer_<%=q.getId()%>"
                                                    value="A"
                                                    data-question-index="<%=index%>"
                                                    required
                                            >
                                            <span><%=q.getOptionA()%></span>
                                        </label>

                                        <label class="option">
                                            <input
                                                    type="radio"
                                                    name="answer_<%=q.getId()%>"
                                                    value="B"
                                                    data-question-index="<%=index%>"
                                            >
                                            <span><%=q.getOptionB()%></span>
                                        </label>

                                        <label class="option">
                                            <input
                                                    type="radio"
                                                    name="answer_<%=q.getId()%>"
                                                    value="C"
                                                    data-question-index="<%=index%>"
                                            >
                                            <span><%=q.getOptionC()%></span>
                                        </label>

                                        <label class="option">
                                            <input
                                                    type="radio"
                                                    name="answer_<%=q.getId()%>"
                                                    value="D"
                                                    data-question-index="<%=index%>"
                                            >
                                            <span><%=q.getOptionD()%></span>
                                        </label>

                                    </div>

                                </div>

                                <% index++; %>

                            <% } %>

                        </div>

                        <div class="submit-section">
                            <div class="submit-note">
                                Make sure every question has one selected answer before submitting.
                            </div>

                            <button type="submit" class="submit-btn">
                                Submit quiz →
                            </button>
                        </div>
                    </div>

                    <aside class="sidebar-panel">

                        <div class="side-card">
                            <div class="side-title">Quiz progress</div>
                            <div class="side-text">
                                Track how many questions you have answered before submitting the quiz.
                            </div>

                            <div class="progress-box">
                                <div class="progress-label">
                                    <span>Answered</span>
                                    <span id="progressText">0 / <%=totalQuestions%></span>
                                </div>

                                <div class="progress-track">
                                    <div class="progress-fill" id="progressFill"></div>
                                </div>
                            </div>

                            <div class="question-pills">
                                <% for (int i = 1; i <= totalQuestions; i++) { %>
                                    <div class="question-pill" id="pill-<%=i%>"><%=i%></div>
                                <% } %>
                            </div>
                        </div>

                        <div class="side-card">
                            <div class="side-title">Session timer</div>
                            <div class="side-text">
                                Use the timer to simulate exam pressure and stay focused.
                            </div>

                            <div class="timer">
                                <div class="timer-label">Elapsed time</div>
                                <div class="timer-value" id="timerValue">00:00</div>
                            </div>
                        </div>

                        <div class="side-card">
                            <div class="side-title">Study tip</div>
                            <div class="side-text">
                                After submitting, review the explanations for missed questions and return to the related material.
                            </div>
                        </div>

                    </aside>

                </section>

            </form>

        <% } %>

    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const totalQuestions = <%=totalQuestions%>;
        const progressText = document.getElementById("progressText");
        const progressFill = document.getElementById("progressFill");
        const radios = document.querySelectorAll("input[type='radio'][data-question-index]");

        function updateProgress() {
            const answered = new Set();

            radios.forEach(function (radio) {
                if (radio.checked) {
                    answered.add(radio.getAttribute("data-question-index"));
                }
            });

            const answeredCount = answered.size;
            const percent = totalQuestions > 0 ? (answeredCount / totalQuestions) * 100 : 0;

            if (progressText) {
                progressText.textContent = answeredCount + " / " + totalQuestions;
            }

            if (progressFill) {
                progressFill.style.width = percent + "%";
            }

            for (let i = 1; i <= totalQuestions; i++) {
                const pill = document.getElementById("pill-" + i);

                if (pill) {
                    if (answered.has(String(i))) {
                        pill.classList.add("done");
                    } else {
                        pill.classList.remove("done");
                    }
                }
            }
        }

        radios.forEach(function (radio) {
            radio.addEventListener("change", updateProgress);
        });

        updateProgress();

        const timerValue = document.getElementById("timerValue");
        let seconds = 0;

        setInterval(function () {
            seconds++;

            const min = Math.floor(seconds / 60);
            const sec = seconds % 60;

            const mm = String(min).padStart(2, "0");
            const ss = String(sec).padStart(2, "0");

            if (timerValue) {
                timerValue.textContent = mm + ":" + ss;
            }
        }, 1000);
    });
</script>

</body>
</html>
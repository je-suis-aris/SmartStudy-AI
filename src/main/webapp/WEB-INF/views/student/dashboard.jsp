<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,java.time.*,com.smartstudy.model.*" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartStudy AI — Dashboard</title>
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
            padding: 34px 32px 72px;
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

        .hero-left,
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
        }

        .hero p {
            margin-top: 16px;
            max-width: 760px;
            color: rgba(255, 255, 255, 0.72);
            font-size: 1rem;
            line-height: 1.75;
        }

        .hero-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 24px;
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

        .hero-progress {
            margin-top: 18px;
        }

        .hero-progress-top {
            display: flex;
            justify-content: space-between;
            font-size: 0.78rem;
            color: rgba(255, 255, 255, 0.6);
            margin-bottom: 7px;
            font-weight: 700;
        }

        .hero-progress-track,
        .progress-track {
            height: 8px;
            background: var(--rule);
            border-radius: 999px;
            overflow: hidden;
        }

        .hero-progress-track {
            background: rgba(255, 255, 255, 0.2);
        }

        .hero-progress-fill,
        .progress-fill {
            height: 100%;
            border-radius: 999px;
            background: var(--primary);
            transition: width 0.5s ease;
        }

        .hero-progress-fill {
            background: white;
        }

        .progress-fill.green {
            background: #22c55e;
        }

        .progress-fill.amber {
            background: #f59e0b;
        }

        .progress-fill.red {
            background: #ef4444;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 42px;
            padding: 10px 17px;
            border-radius: 12px;
            border: 1px solid transparent;
            font-size: 0.87rem;
            font-weight: 800;
            cursor: pointer;
            transition: 0.2s ease;
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
            border-color: var(--rule);
            color: var(--ink-2);
        }

        .btn-secondary:hover {
            color: var(--ink);
            border-color: var(--ink-4);
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
            border-color: rgba(255, 255, 255, 0.14);
            color: white;
        }

        .btn-ghost-light:hover {
            background: rgba(255, 255, 255, 0.14);
            transform: translateY(-1px);
        }

        .btn-sm {
            min-height: 36px;
            padding: 8px 13px;
            border-radius: 10px;
            font-size: 0.8rem;
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
            min-height: 158px;
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

        .metric-top {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            align-items: flex-start;
            margin-bottom: 18px;
        }

        .metric-label {
            color: var(--ink-3);
            font-size: 0.74rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.09em;
        }

        .metric-icon {
            width: 42px;
            height: 42px;
            border-radius: 15px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.05rem;
        }

        .metric-icon.blue {
            background: var(--primary-soft);
        }

        .metric-icon.green {
            background: var(--green-bg);
        }

        .metric-icon.amber {
            background: var(--amber-bg);
        }

        .metric-icon.red {
            background: var(--red-bg);
        }

        .metric-value {
            font-size: 2.35rem;
            line-height: 1;
            font-weight: 800;
            letter-spacing: -0.065em;
            color: var(--ink);
        }

        .metric-sub {
            margin-top: 8px;
            color: var(--ink-3);
            font-size: 0.84rem;
        }

        .pill {
            width: fit-content;
            display: inline-flex;
            margin-top: 12px;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 0.74rem;
            font-weight: 800;
        }

        .pill.green {
            background: var(--green-bg);
            color: var(--green);
        }

        .pill.red {
            background: var(--red-bg);
            color: var(--red);
        }

        .pill.amber {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .pill.neutral {
            background: var(--surface-soft);
            color: var(--ink-3);
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 26px;
            box-shadow: var(--shadow-sm);
        }

        .grid-main {
            display: grid;
            grid-template-columns: minmax(0, 1.12fr) minmax(0, 0.88fr);
            gap: 24px;
            margin-bottom: 24px;
        }

        .grid-equal {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 24px;
            margin-bottom: 24px;
        }

        .next-action-card,
        .personal-plan-card {
            margin-bottom: 24px;
            background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
            border: 1px solid #d8e3f1;
        }

        .next-action-content,
        .personal-plan-result {
            background: var(--primary-soft);
            color: var(--primary-dark);
            border: 1px solid #d8e3f1;
            border-radius: 18px;
            padding: 18px;
            line-height: 1.75;
            font-size: 0.92rem;
            margin-bottom: 16px;
        }

        .next-action-empty,
        .personal-plan-empty {
            border: 1px dashed #cbd5e1;
            background: #fbfcfe;
            border-radius: 18px;
            padding: 18px;
            color: var(--ink-3);
            font-size: 0.9rem;
            margin-bottom: 16px;
        }

        .personal-plan-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 16px;
        }

        .personal-plan-box {
            border: 1px solid var(--rule);
            background: #fbfcfe;
            border-radius: 18px;
            padding: 16px;
        }

        .personal-plan-box-title {
            color: var(--ink);
            font-size: 0.9rem;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .personal-plan-box-text {
            color: var(--ink-3);
            font-size: 0.84rem;
            line-height: 1.65;
        }

        .plan-action-row {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 800;
            letter-spacing: -0.035em;
            color: var(--ink);
        }

        .card-subtitle {
            color: var(--ink-3);
            font-size: 0.86rem;
            margin-top: 4px;
        }

        .card-link {
            color: var(--primary);
            font-size: 0.8rem;
            font-weight: 800;
            white-space: nowrap;
        }

        .card-link:hover {
            text-decoration: underline;
        }

        .mini-card-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 18px;
        }

        .mini-card {
            background: #fbfcfe;
            border: 1px solid var(--rule);
            border-radius: 18px;
            padding: 15px;
        }

        .mini-label {
            color: var(--ink-4);
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .mini-value {
            font-size: 1.65rem;
            line-height: 1;
            font-weight: 800;
            letter-spacing: -0.06em;
            color: var(--ink);
            margin-top: 9px;
        }

        .mini-sub {
            color: var(--ink-3);
            font-size: 0.78rem;
            margin-top: 5px;
        }

        .plan-list {
            display: grid;
            gap: 11px;
        }

        .plan-item {
            display: grid;
            grid-template-columns: 24px minmax(0, 1fr) auto;
            gap: 14px;
            align-items: center;
            padding: 14px;
            border: 1px solid var(--rule);
            border-radius: 18px;
            background: #fbfcfe;
        }

        .plan-check {
            width: 24px;
            height: 24px;
            border: 1.5px solid #d1d5db;
            border-radius: 8px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.7rem;
            font-weight: 800;
        }

        .plan-check.done {
            background: var(--green);
            border-color: var(--green);
        }

        .plan-course {
            color: var(--primary);
            font-size: 0.75rem;
            font-weight: 800;
            letter-spacing: 0.07em;
            text-transform: uppercase;
        }

        .plan-task {
            color: var(--ink);
            font-size: 0.92rem;
            font-weight: 700;
            margin-top: 2px;
        }

        .plan-time {
            color: var(--primary);
            background: var(--primary-soft);
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 0.76rem;
            font-weight: 800;
            white-space: nowrap;
        }

        .alert-list {
            display: grid;
            gap: 12px;
        }

        .alert-item {
            display: grid;
            grid-template-columns: 10px minmax(0, 1fr) auto;
            align-items: start;
            gap: 12px;
            padding: 15px;
            border-radius: 18px;
            border: 1px solid #bfdbfe;
            background: var(--blue-bg);
        }

        .alert-item.high {
            border-color: #fecaca;
            background: var(--red-bg);
        }

        .alert-item.medium {
            border-color: #fde68a;
            background: var(--amber-bg);
        }

        .alert-dot {
            width: 8px;
            height: 8px;
            margin-top: 7px;
            border-radius: 50%;
            background: var(--primary);
        }

        .alert-item.high .alert-dot {
            background: var(--red);
        }

        .alert-item.medium .alert-dot {
            background: var(--amber);
        }

        .alert-severity {
            font-size: 0.7rem;
            font-weight: 800;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--primary);
        }

        .alert-message {
            margin-top: 3px;
            color: var(--ink-2);
            font-size: 0.88rem;
        }

        .alert-action {
            align-self: center;
            color: var(--primary);
            font-size: 0.78rem;
            font-weight: 800;
            white-space: nowrap;
        }

        .knowledge-list {
            display: grid;
            gap: 14px;
        }

        .knowledge-row {
            display: grid;
            grid-template-columns: 160px minmax(0, 1fr) 46px;
            align-items: center;
            gap: 14px;
        }

        .knowledge-name {
            color: var(--ink-2);
            font-size: 0.86rem;
            font-weight: 700;
        }

        .knowledge-score {
            color: var(--ink-3);
            font-size: 0.78rem;
            text-align: right;
            font-weight: 700;
        }

        .chart-box {
            display: grid;
            gap: 12px;
        }

        .bar-chart {
            height: 92px;
            display: flex;
            align-items: flex-end;
            gap: 9px;
            padding-top: 10px;
        }

        .bar-chart-bar {
            flex: 1;
            min-width: 10px;
            border-radius: 8px 8px 0 0;
            background: var(--primary-soft);
        }

        .bar-chart-bar.active,
        .bar-chart-bar:hover {
            background: var(--primary);
        }

        .bar-chart-labels {
            display: flex;
            gap: 9px;
        }

        .bar-label {
            flex: 1;
            text-align: center;
            color: var(--ink-4);
            font-size: 0.68rem;
            font-weight: 700;
        }

        .score-list {
            display: grid;
            gap: 10px;
            margin-top: 16px;
        }

        .score-row {
            display: grid;
            grid-template-columns: 46px minmax(0, 1fr);
            gap: 12px;
            align-items: center;
            padding: 12px;
            border-radius: 16px;
            border: 1px solid var(--rule);
            background: #fbfcfe;
        }

        .score-circle {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.76rem;
            font-weight: 800;
        }

        .score-circle.high {
            background: var(--green-bg);
            color: var(--green);
        }

        .score-circle.mid {
            background: var(--amber-bg);
            color: var(--amber);
        }

        .score-circle.low {
            background: var(--red-bg);
            color: var(--red);
        }

        .score-title {
            font-weight: 800;
            font-size: 0.88rem;
            color: var(--ink);
        }

        .score-meta {
            color: var(--ink-4);
            font-size: 0.76rem;
            margin-top: 2px;
        }

        .section-label {
            color: var(--ink-4);
            font-size: 0.74rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            margin: 0 0 16px;
        }

        .dashboard-lower-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(380px, 0.82fr);
            gap: 24px;
            align-items: stretch;
            margin-bottom: 24px;
        }

        .dashboard-left-column {
            display: grid;
            grid-template-rows: auto 1fr;
            gap: 0;
            min-height: 100%;
        }

        .dashboard-right-stack {
            display: grid;
            grid-template-rows: auto 1fr auto 1fr;
            gap: 16px;
            min-height: 100%;
        }

        .courses-list {
            display: grid;
            grid-template-columns: 1fr;
            gap: 18px;
            height: 100%;
        }

        .course-card {
            background: var(--surface);
            border: 1px solid var(--rule);
            border-radius: 26px;
            padding: 26px;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            gap: 18px;
            transition: 0.22s ease;
        }

        .course-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .equal-height-course {
            min-height: 520px;
            height: 100%;
            justify-content: space-between;
        }

        .course-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
        }

        .course-title {
            font-size: 1.15rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: var(--ink);
        }

        .course-desc {
            color: var(--ink-3);
            font-size: 0.88rem;
            margin-top: 5px;
        }

        .course-badge {
            padding: 6px 11px;
            border-radius: 999px;
            font-size: 0.68rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            white-space: nowrap;
            background: var(--primary-soft);
            color: var(--primary);
        }

        .course-badge.active {
            background: var(--green-bg);
            color: var(--green);
        }

        .course-badge.critical {
            background: var(--red-bg);
            color: var(--red);
        }

        .course-meta {
            color: var(--ink-3);
            font-size: 0.84rem;
            display: flex;
            gap: 7px;
            align-items: center;
        }

        .course-meta strong {
            color: var(--ink-2);
        }

        .course-progress-label {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            color: var(--ink-3);
            font-size: 0.78rem;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .course-actions {
            display: flex;
            gap: 9px;
            flex-wrap: wrap;
        }

        .course-focus-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
        }

        .course-focus-box {
            background: #fbfcfe;
            border: 1px solid var(--rule);
            border-radius: 18px;
            padding: 16px;
        }

        .course-focus-title {
            font-size: 0.82rem;
            font-weight: 800;
            color: var(--ink);
            margin-bottom: 6px;
        }

        .course-focus-text {
            font-size: 0.8rem;
            color: var(--ink-3);
            line-height: 1.55;
        }

        .course-bottom-note {
            border: 1px dashed #cbd5e1;
            background: #fbfcfe;
            color: var(--ink-3);
            border-radius: 18px;
            padding: 16px;
            font-size: 0.84rem;
            line-height: 1.65;
        }

        .exam-list {
            display: grid;
            gap: 12px;
        }

        .exam-item {
            display: grid;
            grid-template-columns: 56px minmax(0, 1fr);
            gap: 14px;
            align-items: center;
            padding: 13px;
            border: 1px solid var(--rule);
            border-radius: 18px;
            background: #fbfcfe;
        }

        .exam-badge {
            width: 56px;
            height: 58px;
            border-radius: 16px;
            background: var(--primary-soft);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .exam-badge.urgent {
            background: var(--red-bg);
        }

        .exam-day {
            color: var(--primary);
            font-size: 1.3rem;
            line-height: 1;
            font-weight: 800;
            letter-spacing: -0.04em;
        }

        .exam-badge.urgent .exam-day {
            color: var(--red);
        }

        .exam-month {
            color: var(--ink-3);
            font-size: 0.6rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-top: 3px;
        }

        .exam-title {
            color: var(--ink);
            font-weight: 800;
            font-size: 0.92rem;
        }

        .exam-sub {
            color: var(--ink-4);
            font-size: 0.76rem;
            margin-top: 2px;
        }

        .exam-sub.urgent {
            color: var(--red);
            font-weight: 800;
        }

        .quick-actions {
            display: grid;
            gap: 10px;
        }

        .quick-actions .btn {
            justify-content: flex-start;
        }

        .ai-tutor {
            background: var(--primary-dark);
            color: white;
            border-radius: 28px;
            padding: 28px;
            box-shadow: var(--shadow-hero);
            margin-top: 8px;
        }

        .ai-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 7px;
        }

        .ai-pulse {
            width: 11px;
            height: 11px;
            border-radius: 50%;
            background: #22c55e;
            box-shadow: 0 0 0 5px rgba(34, 197, 94, 0.18);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 0 0 5px rgba(34, 197, 94, 0.18);
            }

            50% {
                box-shadow: 0 0 0 9px rgba(34, 197, 94, 0.07);
            }
        }

        .ai-title {
            font-size: 1.1rem;
            font-weight: 800;
            letter-spacing: -0.03em;
        }

        .ai-sub {
            color: rgba(255, 255, 255, 0.68);
            font-size: 0.9rem;
            max-width: 950px;
            margin-bottom: 18px;
        }

        .ai-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 16px;
        }

        .ai-chip {
            color: rgba(255, 255, 255, 0.86);
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 999px;
            padding: 7px 13px;
            font-size: 0.79rem;
            font-weight: 700;
            cursor: pointer;
        }

        .ai-input-row {
            display: flex;
            gap: 10px;
        }

        .ai-input {
            flex: 1;
            min-height: 44px;
            color: white;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.14);
            border-radius: 13px;
            outline: none;
            padding: 12px 14px;
            font-size: 0.9rem;
        }

        .ai-input::placeholder {
            color: rgba(255, 255, 255, 0.42);
        }

        .ai-send {
            min-height: 44px;
            padding: 12px 18px;
            border: none;
            border-radius: 13px;
            background: white;
            color: var(--primary-dark);
            font-weight: 800;
            cursor: pointer;
            white-space: nowrap;
        }

        .ai-response {
            display: none;
            margin-top: 14px;
            color: rgba(255, 255, 255, 0.86);
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 14px;
            padding: 14px 16px;
            font-size: 0.88rem;
            line-height: 1.7;
            white-space: pre-wrap;
        }

        .empty-state {
            border: 1px dashed #cbd5e1;
            border-radius: 18px;
            padding: 24px;
            background: #fbfcfe;
            color: var(--ink-3);
            font-size: 0.88rem;
        }

        @media (max-width: 1180px) {
            .metrics-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .grid-main,
            .grid-equal,
            .dashboard-lower-grid {
                grid-template-columns: 1fr;
            }

            .dashboard-right-stack {
                grid-template-rows: auto auto auto auto;
            }

            .equal-height-course {
                min-height: auto;
            }

            .hero {
                grid-template-columns: 1fr;
            }

            .hero-panel {
                max-width: 420px;
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
                font-size: 2.15rem;
            }

            .metrics-grid,
            .mini-card-grid,
            .personal-plan-grid,
            .course-focus-grid {
                grid-template-columns: 1fr;
            }

            .plan-item {
                grid-template-columns: 24px minmax(0, 1fr);
            }

            .plan-time {
                grid-column: 2;
                width: fit-content;
            }

            .knowledge-row {
                grid-template-columns: 1fr;
                gap: 7px;
            }

            .knowledge-score {
                text-align: left;
            }

            .ai-input-row {
                flex-direction: column;
            }

            .ai-send {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<%
    String ctx = request.getContextPath();

    String nextBestAction = (String) session.getAttribute("nextBestAction");

    if (nextBestAction == null || nextBestAction.trim().isEmpty()) {
        nextBestAction = "";
    }

    String aiPersonalPlan = (String) session.getAttribute("aiPersonalPlan");

    if (aiPersonalPlan == null || aiPersonalPlan.trim().isEmpty()) {
        aiPersonalPlan = "";
    }

    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Map<String,Object>> alerts = (List<Map<String,Object>>) request.getAttribute("alerts");
    List<Map<String,Object>> today = (List<Map<String,Object>>) request.getAttribute("todayPlan");

    User currentUser = (User) session.getAttribute("user");

    String fullName = "Student";
    String initials = "ST";
    String profilePhoto = null;
    String description = "";

    if (currentUser != null) {
        profilePhoto = currentUser.getProfilePhoto();

        if (currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty()) {
            fullName = currentUser.getFullName().trim();

            String[] parts = fullName.split("\\s+");

            if (parts.length >= 2) {
                initials = parts[0].substring(0, 1).toUpperCase() + parts[1].substring(0, 1).toUpperCase();
            } else {
                initials = fullName.substring(0, 1).toUpperCase();
            }
        }

        if (currentUser.getDescription() != null && !currentUser.getDescription().trim().isEmpty()) {
            description = currentUser.getDescription().trim();
        }
    }

    int hour = LocalTime.now().getHour();

    String greeting;
    String timeMessage;

    if (hour >= 5 && hour < 12) {
        greeting = "Good morning";
        timeMessage = "Start the day with a focused revision session and keep your weak topics visible.";
    } else if (hour >= 12 && hour < 18) {
        greeting = "Good afternoon";
        timeMessage = "Continue your learning flow with your next task, a short quiz or adaptive flashcards.";
    } else {
        greeting = "Good evening";
        timeMessage = "A short revision session tonight can consolidate the concepts you practiced today.";
    }

    String heroMessage = description.isBlank() ? timeMessage : description;

    int totalCourses = stats != null ? stats.getTotalCourses() : 0;
    int totalMaterials = stats != null ? stats.getTotalMaterials() : 0;
    int totalStudyMinutes = stats != null ? stats.getTotalStudyMinutes() : 0;
    double averageScore = stats != null ? stats.getAverageScore() : 0.0;

    int alertCount = alerts != null ? alerts.size() : 0;
    int todayCount = today != null ? today.size() : 0;

    int progressPercent = 0;

    if (averageScore > 0) {
        progressPercent = (int) Math.min(100, Math.max(0, Math.round(averageScore)));
    }

    if (progressPercent == 0 && todayCount > 0) {
        progressPercent = 35;
    }
%>

<nav class="nav">
    <div class="nav-inner">
        <a href="<%=ctx%>/home" class="brand">
            <img src="<%=ctx%>/assets/img/Logo.png?v=100" alt="SmartStudy AI" class="brand-logo">
            <span class="brand-text">SmartStudy <span>AI</span></span>
        </a>

        <div class="nav-links">
            <a href="<%=ctx%>/dashboard" class="active">Dashboard</a>
            <a href="<%=ctx%>/materials">Materials</a>
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
            <div class="hero-left">
                <div class="hero-kicker">Personal learning dashboard</div>
                <h1><%=greeting%>, <%=fullName%> 👋</h1>
                <p><%=heroMessage%></p>

                <div class="hero-actions">
                    <a href="<%=ctx%>/materials" class="btn btn-light">+ Upload material</a>
                    <a href="<%=ctx%>/planner" class="btn btn-ghost-light">Open study planner</a>
                    <a href="<%=ctx%>/assessment" class="btn btn-ghost-light">Start quiz</a>
                    <a href="<%=ctx%>/flashcards" class="btn btn-ghost-light">Review flashcards</a>
                </div>
            </div>

            <div class="hero-panel">
                <div class="hero-panel-label">Learning readiness</div>
                <div class="hero-panel-value"><%=progressPercent%>%</div>
                <div class="hero-panel-note">
                    Based on quiz performance, study sessions and current revision activity.
                </div>

                <div class="hero-progress">
                    <div class="hero-progress-top">
                        <span>Progress</span>
                        <span><%=progressPercent%>%</span>
                    </div>
                    <div class="hero-progress-track">
                        <div class="hero-progress-fill" style="width:<%=progressPercent%>%"></div>
                    </div>
                </div>
            </div>
        </section>

        <section class="metrics-grid">
            <div class="metric-card">
                <div>
                    <div class="metric-top">
                        <div class="metric-label">Courses</div>
                        <div class="metric-icon blue">📚</div>
                    </div>
                    <div class="metric-value"><%=totalCourses%></div>
                    <div class="metric-sub">Active learning paths</div>
                </div>
                <div class="pill neutral">All subjects</div>
            </div>

            <div class="metric-card">
                <div>
                    <div class="metric-top">
                        <div class="metric-label">Materials</div>
                        <div class="metric-icon green">📄</div>
                    </div>
                    <div class="metric-value"><%=totalMaterials%></div>
                    <div class="metric-sub">Uploaded resources</div>
                </div>
                <div class="pill green">Ready for AI</div>
            </div>

            <div class="metric-card">
                <div>
                    <div class="metric-top">
                        <div class="metric-label">Study time</div>
                        <div class="metric-icon amber">⏱</div>
                    </div>
                    <div class="metric-value"><%=totalStudyMinutes%></div>
                    <div class="metric-sub">Total minutes logged</div>
                </div>
                <div class="pill amber">Tracked sessions</div>
            </div>

            <div class="metric-card">
                <div>
                    <div class="metric-top">
                        <div class="metric-label">Average score</div>
                        <div class="metric-icon red">🎯</div>
                    </div>
                    <div class="metric-value"><%=String.format("%.0f", averageScore)%>%</div>
                    <div class="metric-sub">Across submitted quizzes</div>
                </div>

                <% if (averageScore >= 70) { %>
                    <div class="pill green">Strong progress</div>
                <% } else if (averageScore >= 50) { %>
                    <div class="pill amber">Needs practice</div>
                <% } else { %>
                    <div class="pill red">Needs revision</div>
                <% } %>
            </div>
        </section>

        <section class="card next-action-card">
            <div class="card-header">
                <div>
                    <div class="card-title">AI next best action</div>
                    <div class="card-subtitle">
                        Personalized recommendation based on your quiz performance, learning activity and detected weak topics.
                    </div>
                </div>
                <a href="<%=ctx%>/ai-coach" class="card-link">Open AI Coach →</a>
            </div>

            <% if (!nextBestAction.isBlank()) { %>
                <div class="next-action-content">
                    <%=nextBestAction.replace("\n", "<br>")%>
                </div>
            <% } else { %>
                <div class="next-action-empty">
                    No personalized action generated yet. Ask SmartStudy AI to analyze your current progress
                    and suggest what you should study next.
                </div>
            <% } %>

            <form method="post" action="<%=ctx%>/generate-next-action">
                <button type="submit" class="btn btn-primary">
                    Generate next action with AI
                </button>
            </form>
        </section>

        <section class="card personal-plan-card">
            <div class="card-header">
                <div>
                    <div class="card-title">AI personal learning plan</div>
                    <div class="card-subtitle">
                        A personalized 7-day study strategy generated from your learning profile, quiz performance, study time and weak topics.
                    </div>
                </div>
                <a href="<%=ctx%>/planner" class="card-link">Open planner →</a>
            </div>

            <div class="personal-plan-grid">
                <div class="personal-plan-box">
                    <div class="personal-plan-box-title">Current learning profile</div>
                    <div class="personal-plan-box-text">
                        <strong><%=totalCourses%></strong> active course(s),
                        <strong><%=totalMaterials%></strong> uploaded material(s),
                        <strong><%=totalStudyMinutes%></strong> minutes studied,
                        and an average quiz score of <strong><%=String.format("%.0f", averageScore)%>%</strong>.
                    </div>
                </div>

                <div class="personal-plan-box">
                    <div class="personal-plan-box-title">Recommended AI focus</div>
                    <div class="personal-plan-box-text">
                        <% if (alertCount > 0) { %>
                            The system detected <strong><%=alertCount%></strong> knowledge gap alert(s).
                            Your personal plan should prioritize weak topics, active recall and short revision cycles.
                        <% } else { %>
                            No major knowledge gaps are active. Your personal plan should maintain consistency,
                            prepare upcoming exams and consolidate already learned concepts.
                        <% } %>
                    </div>
                </div>
            </div>

            <% if (!aiPersonalPlan.isBlank()) { %>
                <div class="personal-plan-result">
                    <%=aiPersonalPlan.replace("\n", "<br>")%>
                </div>
            <% } else { %>
                <div class="personal-plan-empty">
                    No AI personal learning plan generated yet. Generate a structured revision plan adapted to your current progress.
                </div>
            <% } %>

            <div class="plan-action-row">
                <form method="post" action="<%=ctx%>/generate-personal-plan">
                    <button type="submit" class="btn btn-primary">
                        Generate personal learning plan with AI
                    </button>
                </form>
                <a href="<%=ctx%>/flashcards" class="btn btn-secondary">Review flashcards</a>
                <a href="<%=ctx%>/assessment" class="btn btn-secondary">Take adaptive quiz</a>
            </div>
        </section>

        <section class="grid-main">
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="card-title">Today's revision plan</div>
                        <div class="card-subtitle">Focused tasks generated from your planner and learning activity</div>
                    </div>
                    <a href="<%=ctx%>/planner" class="card-link">Full planner →</a>
                </div>

                <div class="mini-card-grid">
                    <div class="mini-card">
                        <div class="mini-label">Tasks today</div>
                        <div class="mini-value"><%=todayCount%></div>
                        <div class="mini-sub">planned activities</div>
                    </div>
                    <div class="mini-card">
                        <div class="mini-label">Study time</div>
                        <div class="mini-value"><%=totalStudyMinutes%></div>
                        <div class="mini-sub">minutes total</div>
                    </div>
                    <div class="mini-card">
                        <div class="mini-label">Alerts</div>
                        <div class="mini-value"><%=alertCount%></div>
                        <div class="mini-sub">topics to revise</div>
                    </div>
                </div>

                <div class="plan-list">
                    <% if (today != null && !today.isEmpty()) {
                        for (Map<String,Object> m : today) {
                            Object courseObj = m.get("course");
                            Object taskObj = m.get("task");
                            Object minutesObj = m.get("minutes");

                            String courseName = courseObj != null ? String.valueOf(courseObj) : "Course";
                            String taskName = taskObj != null ? String.valueOf(taskObj) : "Revision task";
                            String minutesText = minutesObj != null ? String.valueOf(minutesObj) : "30";
                    %>
                        <div class="plan-item">
                            <div class="plan-check" onclick="toggleCheck(this)"></div>
                            <div>
                                <div class="plan-course"><%=courseName%></div>
                                <div class="plan-task"><%=taskName%></div>
                            </div>
                            <div class="plan-time"><%=minutesText%> min</div>
                        </div>
                    <%  }
                    } else { %>
                        <div class="empty-state">
                            No revision tasks are planned for today. Open the study planner to generate a personalized schedule.
                        </div>
                    <% } %>
                </div>

                <div style="margin-top:18px; display:flex; gap:10px; flex-wrap:wrap;">
                    <a href="<%=ctx%>/planner" class="btn btn-primary btn-sm">Generate study plan</a>
                    <a href="<%=ctx%>/materials" class="btn btn-secondary btn-sm">+ Add material</a>
                    <a href="<%=ctx%>/flashcards" class="btn btn-secondary btn-sm">Review flashcards</a>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="card-title">Knowledge gap alerts</div>
                        <div class="card-subtitle">Weak topics detected from quiz results and activity</div>
                    </div>
                    <a href="<%=ctx%>/insights" class="card-link">View map →</a>
                </div>

                <div class="alert-list">
                    <% if (alerts != null && !alerts.isEmpty()) {
                        for (Map<String,Object> m : alerts) {
                            Object severityObj = m.get("severity");
                            Object messageObj = m.get("message");

                            String severity = severityObj != null ? String.valueOf(severityObj) : "MEDIUM";
                            String message = messageObj != null ? String.valueOf(messageObj) : "Review this topic.";
                            String sevClass = severity.toLowerCase();

                            if (!sevClass.equals("high") && !sevClass.equals("medium") && !sevClass.equals("low")) {
                                sevClass = "medium";
                            }
                    %>
                        <div class="alert-item <%=sevClass%>">
                            <div class="alert-dot"></div>
                            <div>
                                <div class="alert-severity"><%=severity%></div>
                                <div class="alert-message"><%=message%></div>
                            </div>
                            <a href="<%=ctx%>/assessment" class="alert-action">Revise →</a>
                        </div>
                    <%  }
                    } else { %>
                        <div class="empty-state">
                            No active knowledge gap alerts. Complete quizzes to let the system detect weak topics.
                        </div>
                    <% } %>
                </div>
            </div>
        </section>

        <section class="grid-equal">
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="card-title">Knowledge map</div>
                        <div class="card-subtitle">A visual overview of topic mastery</div>
                    </div>
                    <a href="<%=ctx%>/insights" class="card-link">Full insights →</a>
                </div>

                <div class="knowledge-list">
                    <div class="knowledge-row">
                        <div class="knowledge-name">Course concepts</div>
                        <div class="progress-track">
                            <div class="progress-fill <%=averageScore >= 70 ? "green" : averageScore >= 50 ? "amber" : "red"%>" style="width:<%=Math.max(5, progressPercent)%>%"></div>
                        </div>
                        <div class="knowledge-score"><%=progressPercent%>%</div>
                    </div>

                    <div class="knowledge-row">
                        <div class="knowledge-name">Quiz readiness</div>
                        <div class="progress-track">
                            <div class="progress-fill <%=averageScore >= 70 ? "green" : averageScore >= 50 ? "amber" : "red"%>" style="width:<%=Math.max(5, progressPercent)%>%"></div>
                        </div>
                        <div class="knowledge-score"><%=progressPercent%>%</div>
                    </div>

                    <div class="knowledge-row">
                        <div class="knowledge-name">Material coverage</div>
                        <div class="progress-track">
                            <div class="progress-fill green" style="width:<%=totalMaterials > 0 ? 75 : 15%>%"></div>
                        </div>
                        <div class="knowledge-score"><%=totalMaterials > 0 ? 75 : 15%>%</div>
                    </div>

                    <div class="knowledge-row">
                        <div class="knowledge-name">Study consistency</div>
                        <div class="progress-track">
                            <div class="progress-fill <%=totalStudyMinutes >= 120 ? "green" : totalStudyMinutes >= 45 ? "amber" : "red"%>" style="width:<%=Math.min(100, Math.max(10, totalStudyMinutes))%>%"></div>
                        </div>
                        <div class="knowledge-score"><%=Math.min(100, Math.max(10, totalStudyMinutes))%>%</div>
                    </div>

                    <div class="knowledge-row">
                        <div class="knowledge-name">Adaptive revision</div>
                        <div class="progress-track">
                            <div class="progress-fill <%=alertCount == 0 ? "green" : alertCount <= 2 ? "amber" : "red"%>" style="width:<%=alertCount == 0 ? 85 : alertCount <= 2 ? 55 : 30%>%"></div>
                        </div>
                        <div class="knowledge-score"><%=alertCount == 0 ? 85 : alertCount <= 2 ? 55 : 30%>%</div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="card-title">Recent quiz trend</div>
                        <div class="card-subtitle">A compact view of learning performance</div>
                    </div>
                    <a href="<%=ctx%>/stats" class="card-link">All stats →</a>
                </div>

                <div class="chart-box">
                    <div class="bar-chart" id="scoreChart"></div>
                    <div class="bar-chart-labels" id="chartLabels"></div>
                </div>

                <div class="score-list">
                    <div class="score-row">
                        <div class="score-circle <%=averageScore >= 70 ? "high" : averageScore >= 50 ? "mid" : "low"%>">
                            <%=String.format("%.0f", averageScore)%>%
                        </div>
                        <div>
                            <div class="score-title">Overall quiz average</div>
                            <div class="score-meta">Updated from submitted assessments</div>
                        </div>
                    </div>

                    <div class="score-row">
                        <div class="score-circle <%=alertCount == 0 ? "high" : alertCount <= 2 ? "mid" : "low"%>">
                            <%=alertCount%>
                        </div>
                        <div>
                            <div class="score-title">Knowledge gaps detected</div>
                            <div class="score-meta">Used for targeted revision and adaptive flashcards</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="dashboard-lower-grid">

            <div class="dashboard-left-column">
                <div class="section-label">Courses and learning paths</div>

                <div class="courses-list">
                    <% if (courses != null && !courses.isEmpty()) {
                        int index = 0;

                        for (Course c : courses) {
                            index++;

                            String title = c.getTitle() != null ? c.getTitle() : "Course";
                            String desc = c.getDescription() != null && !c.getDescription().trim().isEmpty()
                                    ? c.getDescription()
                                    : "Course created from your uploaded learning resources.";

                            String examDate = c.getExamDate() != null ? String.valueOf(c.getExamDate()) : "Not set";
                            int courseProgress = Math.min(95, Math.max(25, 40 + index * 10));
                            String badgeClass = courseProgress < 45 ? "critical" : courseProgress < 70 ? "upcoming" : "active";
                            String badgeText = courseProgress < 45 ? "Critical" : courseProgress < 70 ? "In progress" : "Active";
                    %>

                        <div class="course-card equal-height-course">
                            <div>
                                <div class="course-top">
                                    <div>
                                        <div class="course-title"><%=title%></div>
                                        <div class="course-desc"><%=desc%></div>
                                    </div>
                                    <span class="course-badge <%=badgeClass%>"><%=badgeText%></span>
                                </div>

                                <div style="margin-top:18px;" class="course-meta">
                                    📅 Exam:
                                    <strong><%=examDate%></strong>
                                </div>

                                <div style="margin-top:20px;">
                                    <div class="course-progress-label">
                                        <span>Study progress</span>
                                        <span><%=courseProgress%>%</span>
                                    </div>

                                    <div class="progress-track">
                                        <div class="progress-fill <%=courseProgress >= 70 ? "green" : courseProgress >= 45 ? "amber" : "red"%>" style="width:<%=courseProgress%>%"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="course-focus-grid">
                                <div class="course-focus-box">
                                    <div class="course-focus-title">Recommended next step</div>
                                    <div class="course-focus-text">
                                        Start with a short quiz, then review flashcards generated from weak answers.
                                    </div>
                                </div>

                                <div class="course-focus-box">
                                    <div class="course-focus-title">Best revision method</div>
                                    <div class="course-focus-text">
                                        Use active recall: read less, test more, and repeat difficult concepts daily.
                                    </div>
                                </div>

                                <div class="course-focus-box">
                                    <div class="course-focus-title">Material status</div>
                                    <div class="course-focus-text">
                                        Your uploaded material is ready for quizzes, flashcards and AI explanations.
                                    </div>
                                </div>

                                <div class="course-focus-box">
                                    <div class="course-focus-title">Exam preparation</div>
                                    <div class="course-focus-text">
                                        Keep this course in your daily plan until your score becomes stable.
                                    </div>
                                </div>
                            </div>

                            <div class="course-bottom-note">
                                SmartStudy AI recommends combining this course with daily flashcards and at least one adaptive quiz session.
                                This keeps the learning path active and reduces knowledge gaps before the exam.
                            </div>

                            <div class="course-actions">
                                <a href="<%=ctx%>/take-quiz?courseId=<%=c.getId()%>" class="btn btn-primary btn-sm">Take quiz</a>
                                <a href="<%=ctx%>/materials?courseId=<%=c.getId()%>" class="btn btn-secondary btn-sm">Materials</a>
                                <a href="<%=ctx%>/flashcards?courseId=<%=c.getId()%>" class="btn btn-secondary btn-sm">Flashcards</a>
                                <a href="<%=ctx%>/planner" class="btn btn-secondary btn-sm">Add to planner</a>
                            </div>
                        </div>

                    <%  }
                    } else { %>

                        <div class="card equal-height-course">
                            <div>
                                <div class="card-title">No courses yet</div>
                                <div class="card-subtitle">
                                    Upload a PDF material to create your first course and start generating quizzes, flashcards and study plans.
                                </div>
                            </div>

                            <div class="course-focus-grid">
                                <div class="course-focus-box">
                                    <div class="course-focus-title">Step 1</div>
                                    <div class="course-focus-text">Upload a course material.</div>
                                </div>

                                <div class="course-focus-box">
                                    <div class="course-focus-title">Step 2</div>
                                    <div class="course-focus-text">Generate quizzes and flashcards.</div>
                                </div>
                            </div>

                            <div>
                                <a href="<%=ctx%>/materials" class="btn btn-primary">Upload your first material</a>
                            </div>
                        </div>

                    <% } %>
                </div>
            </div>

            <div class="dashboard-right-stack">

                <div class="section-label">Upcoming exams</div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Upcoming exams</div>
                            <div class="card-subtitle">Dates and urgency overview</div>
                        </div>
                        <a href="<%=ctx%>/planner" class="card-link">Planner →</a>
                    </div>

                    <div class="exam-list">
                        <div class="exam-item">
                            <div class="exam-badge urgent">
                                <div class="exam-day">28</div>
                                <div class="exam-month">May</div>
                            </div>
                            <div>
                                <div class="exam-title">Web Programming II</div>
                                <div class="exam-sub urgent">⚡ Study gap detected — revise priority topics</div>
                            </div>
                        </div>

                        <div class="exam-item">
                            <div class="exam-badge">
                                <div class="exam-day">10</div>
                                <div class="exam-month">Jun</div>
                            </div>
                            <div>
                                <div class="exam-title">Database Systems</div>
                                <div class="exam-sub">Continue weekly practice and review SQL exercises</div>
                            </div>
                        </div>

                        <div class="exam-item">
                            <div class="exam-badge">
                                <div class="exam-day">22</div>
                                <div class="exam-month">Jun</div>
                            </div>
                            <div>
                                <div class="exam-title">Computer Networks</div>
                                <div class="exam-sub">Prepare summaries and flashcards from uploaded materials</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="section-label">Quick actions</div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Quick actions</div>
                            <div class="card-subtitle">Continue your study workflow</div>
                        </div>
                    </div>

                    <div class="quick-actions">
                        <a href="<%=ctx%>/assessment" class="btn btn-primary">⚡ Start a new quiz</a>
                        <a href="<%=ctx%>/flashcards" class="btn btn-secondary">🗂 Review flashcards</a>
                        <a href="<%=ctx%>/materials" class="btn btn-secondary">📄 Upload course material</a>
                        <a href="<%=ctx%>/planner" class="btn btn-secondary">📅 Update study plan</a>
                        <a href="<%=ctx%>/insights" class="btn btn-secondary">🧠 View knowledge insights</a>
                        <a href="<%=ctx%>/ai-coach" class="btn btn-secondary">🤖 Ask AI Coach</a>
                    </div>
                </div>

            </div>

        </section>

        <div class="section-label">AI tutor</div>

        <section class="ai-tutor">
            <div class="ai-header">
                <div class="ai-pulse"></div>
                <div class="ai-title">AI Study Tutor</div>
            </div>

            <p class="ai-sub">
                Ask questions about your courses. The tutor can use your uploaded materials, quiz history,
                study plan and detected knowledge gaps to guide revision.
            </p>

            <div class="ai-chips">
                <span class="ai-chip" onclick="fillPrompt(this)">What should I study today?</span>
                <span class="ai-chip" onclick="fillPrompt(this)">Summarize my weak topics</span>
                <span class="ai-chip" onclick="fillPrompt(this)">Explain the hardest concept from my last quiz</span>
                <span class="ai-chip" onclick="fillPrompt(this)">Create a short revision plan for tonight</span>
                <span class="ai-chip" onclick="fillPrompt(this)">How can I improve my quiz score?</span>
            </div>

            <div class="ai-input-row">
                <input class="ai-input" id="aiInput" placeholder="Ask the AI tutor anything about your courses...">
                <button class="ai-send" onclick="sendAiMessage()">Ask →</button>
            </div>

            <div class="ai-response" id="aiResponse"></div>
        </section>

    </main>
</div>

<script>
    function toggleCheck(el) {
        el.classList.toggle('done');

        if (el.classList.contains('done')) {
            el.textContent = '✓';
        } else {
            el.textContent = '';
        }
    }

    function fillPrompt(el) {
        const input = document.getElementById('aiInput');

        if (input) {
            input.value = el.textContent;
            input.focus();
        }
    }

    function sendAiMessage() {
        const input = document.getElementById('aiInput');
        const response = document.getElementById('aiResponse');
        const button = document.querySelector('.ai-send');

        if (!input || !response) {
            return;
        }

        const question = input.value.trim();

        if (!question) {
            response.style.display = 'block';
            response.textContent = 'Please write a question first.';
            return;
        }

        response.style.display = 'block';
        response.textContent = 'Thinking...';

        if (button) {
            button.disabled = true;
            button.textContent = 'Thinking...';
        }

        fetch('<%=ctx%>/ai-tutor', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: 'question=' + encodeURIComponent(question)
        })
        .then(function(res) {
            return res.text().then(function(text) {
                let data;

                try {
                    data = JSON.parse(text);
                } catch (e) {
                    data = {
                        answer: text
                    };
                }

                if (!res.ok) {
                    throw new Error(data.answer || ('HTTP ' + res.status));
                }

                return data;
            });
        })
        .then(function(data) {
            if (data && data.answer) {
                response.textContent = data.answer;
            } else {
                response.textContent = 'No answer received from AI tutor.';
            }
        })
        .catch(function(error) {
            response.textContent = 'AI tutor error: ' + error.message;
        })
        .finally(function() {
            if (button) {
                button.disabled = false;
                button.textContent = 'Ask →';
            }

            input.value = '';
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        const aiInput = document.getElementById('aiInput');

        if (aiInput) {
            aiInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    sendAiMessage();
                }
            });
        }

        const scoreBase = <%=Math.max(0, Math.min(100, averageScore))%>;
        const scores = [
            Math.max(12, scoreBase - 12),
            Math.max(15, scoreBase - 6),
            Math.max(18, scoreBase + 3),
            Math.max(10, scoreBase - 16),
            Math.max(15, scoreBase + 5),
            Math.max(20, scoreBase + 9),
            Math.max(25, scoreBase)
        ].map(function(value) {
            return Math.min(100, Math.round(value));
        });

        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        const chart = document.getElementById('scoreChart');
        const labels = document.getElementById('chartLabels');
        const maxScore = 100;

        if (chart && labels) {
            chart.innerHTML = '';
            labels.innerHTML = '';

            scores.forEach(function(score, index) {
                const bar = document.createElement('div');

                bar.className = 'bar-chart-bar' + (index === scores.length - 1 ? ' active' : '');
                bar.style.height = Math.max(10, (score / maxScore * 82)) + 'px';
                bar.title = days[index] + ': ' + score + '%';

                chart.appendChild(bar);

                const label = document.createElement('div');

                label.className = 'bar-label';
                label.textContent = days[index];

                labels.appendChild(label);
            });
        }
    });
</script>

</body>
</html>
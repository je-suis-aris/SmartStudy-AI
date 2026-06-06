<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartStudy AI — Intelligent Exam Preparation</title>

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
            --amber: #b7791f;
            --red: #991b1b;
            --radius: 18px;
            --shadow: 0 12px 35px rgba(15, 23, 42, 0.08);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Geist', Arial, sans-serif;
            background: var(--bg);
            color: var(--ink);
            font-size: 15px;
            line-height: 1.6;
        }

        a {
            text-decoration: none;
        }

        .nav {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 100;

    height: 66px;
    background: rgba(255, 255, 255, 0.96);
    backdrop-filter: blur(14px);
    border-bottom: 1px solid var(--rule);

    display: flex;
    align-items: center;
    padding: 0 32px;
}

.nav-inner {
    width: 100%;
    max-width: none;
    margin: 0;

    display: flex;
    align-items: center;
    gap: 28px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 12px;
    color: var(--ink);
    font-size: 1.12rem;
    font-weight: 700;
    letter-spacing: -0.02em;
    margin-right: auto;
    text-decoration: none;
    white-space: nowrap;
    background: transparent;
}

.brand-logo {
    width: 42px;
    height: 42px;
    min-width: 42px;
    max-width: 42px;
    object-fit: contain;
    display: block;

    background: transparent;
    border: none;
    box-shadow: none;
    padding: 0;
    border-radius: 0;
}
.brand-text {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    line-height: 1;
}

.brand-text span {
    color: var(--primary);
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 6px;
}

.nav-links a {
    color: var(--ink-3);
    font-size: 0.84rem;
    font-weight: 500;
    padding: 8px 11px;
    border-radius: 9px;
    transition: 0.2s;
    text-decoration: none;
}

.nav-links a:hover {
    color: var(--ink);
    background: var(--surface-soft);
}

.nav-cta {
    background: var(--ink);
    color: white;
    font-size: 0.84rem;
    font-weight: 600;
    padding: 9px 16px;
    border-radius: 10px;
    transition: 0.2s;
    text-decoration: none;
    margin-left: 8px;
}

.nav-cta:hover {
    background: var(--primary);
}

        .wrap {
            width: 100%;
            max-width: 1180px;
            margin: 0 auto;
            padding: 0 32px;
        }

        .hero {
            padding: 138px 0 72px;
            display: grid;
            grid-template-columns: 1.05fr 0.95fr;
            gap: 56px;
            align-items: center;
        }

        .eyebrow {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--primary);
            letter-spacing: 0.12em;
            text-transform: uppercase;
            margin-bottom: 18px;
        }

        .hero h1 {
            font-size: clamp(2.8rem, 5vw, 4.7rem);
            line-height: 1.02;
            letter-spacing: -0.055em;
            font-weight: 700;
            color: var(--ink);
            max-width: 720px;
        }

        .hero-text {
            margin-top: 24px;
            font-size: 1.06rem;
            color: var(--ink-2);
            max-width: 610px;
            line-height: 1.8;
        }

        .hero-actions {
            margin-top: 34px;
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border-radius: 12px;
            font-size: 0.94rem;
            font-weight: 600;
            padding: 13px 22px;
            transition: 0.2s;
            border: 1px solid transparent;
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
            color: var(--ink);
            transform: translateY(-1px);
        }

        .hero-meta {
            margin-top: 36px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            max-width: 620px;
        }

        .meta-card {
            background: white;
            border: 1px solid var(--rule);
            border-radius: 14px;
            padding: 16px;
        }

        .meta-value {
            font-size: 1.45rem;
            font-weight: 700;
            color: var(--ink);
            letter-spacing: -0.04em;
        }

        .meta-label {
            margin-top: 3px;
            font-size: 0.78rem;
            color: var(--ink-3);
        }

        .preview-card {
            background: white;
            border: 1px solid var(--rule);
            border-radius: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .preview-header {
            padding: 18px 22px;
            border-bottom: 1px solid var(--rule);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .preview-title {
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--ink);
        }

        .preview-subtitle {
            font-size: 0.75rem;
            color: var(--ink-3);
            margin-top: 2px;
        }

        .preview-status {
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--green);
            background: #eef7f1;
            padding: 6px 10px;
            border-radius: 999px;
        }

        .preview-body {
            padding: 22px;
        }

        .document-box {
            background: var(--surface-soft);
            border: 1px solid var(--rule);
            border-radius: 16px;
            padding: 18px;
            margin-bottom: 18px;
        }

        .document-top {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 14px;
        }

        .document-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: white;
            border: 1px solid var(--rule);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.76rem;
            font-weight: 700;
            color: var(--primary);
        }

        .document-name {
            font-weight: 700;
            color: var(--ink);
            font-size: 0.92rem;
        }

        .document-info {
            font-size: 0.76rem;
            color: var(--ink-3);
        }

        .progress-group {
            margin-top: 14px;
        }

        .progress-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 6px;
            font-size: 0.76rem;
            color: var(--ink-3);
        }

        .progress-track {
            height: 7px;
            background: #e5e7eb;
            border-radius: 999px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            width: 84%;
            background: var(--primary);
            border-radius: 999px;
        }

        .generated-list {
            display: grid;
            gap: 10px;
        }

        .generated-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 13px 14px;
            background: white;
            border: 1px solid var(--rule);
            border-radius: 13px;
        }

        .generated-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .generated-icon {
            width: 30px;
            height: 30px;
            border-radius: 9px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.8rem;
        }

        .generated-title {
            font-size: 0.84rem;
            font-weight: 600;
            color: var(--ink);
        }

        .generated-count {
            font-size: 0.72rem;
            color: var(--ink-3);
        }

        .section {
            padding: 70px 0;
        }

        .section-border {
            border-top: 1px solid var(--rule);
        }

        .section-heading {
            margin-bottom: 34px;
            display: flex;
            justify-content: space-between;
            align-items: end;
            gap: 28px;
        }

        .section-heading h2 {
            font-size: clamp(2rem, 3.5vw, 3rem);
            line-height: 1.08;
            letter-spacing: -0.045em;
            color: var(--ink);
            max-width: 600px;
        }

        .section-heading p {
            max-width: 380px;
            color: var(--ink-3);
            font-size: 0.95rem;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
        }

        .feature-card {
            background: white;
            border: 1px solid var(--rule);
            border-radius: 20px;
            padding: 24px;
            min-height: 210px;
            transition: 0.2s;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow);
        }

        .feature-number {
            font-size: 0.76rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 18px;
        }

        .feature-card h3 {
            font-size: 1.06rem;
            color: var(--ink);
            margin-bottom: 10px;
        }

        .feature-card p {
            color: var(--ink-3);
            font-size: 0.9rem;
            line-height: 1.7;
        }

       .workflow-impact {
    position: relative;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 18px;
}

.workflow-impact::before {
    content: "";
    position: absolute;
    top: 52px;
    left: 8%;
    right: 8%;
    height: 2px;
    background: linear-gradient(to right, transparent, var(--primary), transparent);
    opacity: 0.18;
    z-index: 0;
}

.workflow-card {
    position: relative;
    z-index: 1;
    background: #ffffff;
    border: 1px solid var(--rule);
    border-radius: 24px;
    padding: 26px 24px;
    min-height: 250px;
    box-shadow: 0 10px 28px rgba(15, 23, 42, 0.05);
    transition: 0.25s ease;
}

.workflow-card:hover {
    transform: translateY(-6px);
    border-color: rgba(31, 58, 95, 0.28);
    box-shadow: 0 18px 40px rgba(15, 23, 42, 0.1);
}

.workflow-top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24px;
}

.workflow-number {
    width: 38px;
    height: 38px;
    border-radius: 13px;
    background: var(--primary);
    color: white;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 800;
    font-size: 0.9rem;
    box-shadow: 0 10px 22px rgba(31, 58, 95, 0.22);
}

.workflow-icon {
    width: 46px;
    height: 46px;
    border-radius: 16px;
    background: var(--primary-soft);
    color: var(--primary);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
}

.workflow-card h3 {
    font-size: 1.08rem;
    color: var(--ink);
    margin-bottom: 12px;
    letter-spacing: -0.02em;
}

.workflow-card p {
    color: var(--ink-3);
    font-size: 0.9rem;
    line-height: 1.75;
}

.workflow-arrow {
    position: absolute;
    top: 45px;
    right: -18px;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: #ffffff;
    border: 1px solid var(--rule);
    color: var(--primary);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 800;
    z-index: 5;
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.06);
}

.workflow-card:last-child .workflow-arrow {
    display: none;
}

.workflow-result {
    margin-top: 22px;
    background: linear-gradient(135deg, var(--primary-dark), var(--primary));
    color: white;
    border-radius: 22px;
    padding: 24px 28px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
    box-shadow: 0 18px 40px rgba(31, 58, 95, 0.18);
}

.workflow-result h3 {
    font-size: 1.15rem;
    margin-bottom: 4px;
}

.workflow-result p {
    color: rgba(255, 255, 255, 0.72);
    font-size: 0.9rem;
}

.workflow-result-badge {
    background: rgba(255, 255, 255, 0.12);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: white;
    padding: 10px 16px;
    border-radius: 999px;
    font-size: 0.82rem;
    font-weight: 700;
    white-space: nowrap;
}

@media (max-width: 980px) {
    .workflow-impact {
        grid-template-columns: 1fr 1fr;
    }

    .workflow-impact::before,
    .workflow-arrow {
        display: none;
    }

    .workflow-result {
        flex-direction: column;
        align-items: flex-start;
    }
}

@media (max-width: 640px) {
    .workflow-impact {
        grid-template-columns: 1fr;
    }
}

        .insights-layout {
            display: grid;
            grid-template-columns: 0.9fr 1.1fr;
            gap: 32px;
            align-items: center;
        }

        .knowledge-card {
            background: white;
            border: 1px solid var(--rule);
            border-radius: 22px;
            box-shadow: var(--shadow);
            padding: 26px;
        }

        .knowledge-row {
            display: grid;
            grid-template-columns: 140px 1fr 42px;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
        }

        .knowledge-name {
            color: var(--ink-2);
            font-size: 0.86rem;
            font-weight: 500;
        }

        .knowledge-track {
            height: 8px;
            background: #e5e7eb;
            border-radius: 999px;
            overflow: hidden;
        }

        .knowledge-fill {
            height: 100%;
            border-radius: 999px;
            background: var(--green);
        }

        .knowledge-fill.medium {
            background: var(--amber);
        }

        .knowledge-fill.low {
            background: var(--red);
        }

        .knowledge-score {
            font-size: 0.78rem;
            color: var(--ink-3);
            text-align: right;
        }

        .comparison-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            border: 1px solid var(--rule);
        }

        .comparison-table th {
            background: var(--primary-dark);
            color: white;
            text-align: left;
            padding: 16px 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .comparison-table td {
            padding: 15px 20px;
            border-top: 1px solid var(--rule);
            color: var(--ink-2);
            font-size: 0.9rem;
        }

        .comparison-table td:first-child {
            font-weight: 600;
            color: var(--ink);
        }

        .check {
            color: var(--green);
            font-weight: 700;
        }

        .cross {
            color: var(--ink-4);
            font-weight: 700;
        }

       .pricing-grid {
    display: grid;
    grid-template-columns: repeat(2, 370px);
    gap: 24px;
    max-width: 100%;
    justify-content: center;
    align-items: stretch;
}

      .price-card {
    background: white;
    border: 1px solid var(--rule);
    border-radius: 22px;
    padding: 34px;
    min-height: 420px;
}
        .price-card.featured {
            background: var(--primary-dark);
            color: white;
            border-color: var(--primary-dark);
        }

        .price-tier {
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--primary);
            margin-bottom: 12px;
        }

        .price-card.featured .price-tier {
            color: rgba(255, 255, 255, 0.55);
        }

        .price-amount {
            font-size: 2.4rem;
            font-weight: 700;
            letter-spacing: -0.05em;
            margin-bottom: 4px;
        }

        .price-sub {
            color: var(--ink-3);
            font-size: 0.86rem;
            margin-bottom: 22px;
        }

        .price-card.featured .price-sub {
            color: rgba(255, 255, 255, 0.58);
        }

        .price-feats {
            list-style: none;
            display: grid;
            gap: 10px;
            margin-bottom: 24px;
        }

        .price-feats li {
            font-size: 0.9rem;
            color: var(--ink-2);
        }

        .price-card.featured .price-feats li {
            color: rgba(255, 255, 255, 0.78);
        }

       	 	.faq-list {
	    		display: grid;
	    		gap: 12px;
		}

			.faq-item {
			    background: white;
			    border: 1px solid var(--rule);
			    border-radius: 16px;
			    overflow: hidden;
			    transition: 0.2s;
		}
		
		.faq-item:hover {
		    border-color: #cbd5e1;
		    box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
		}
		
		.faq-question {
		    width: 100%;
		    padding: 20px;
		    border: none;
		    background: transparent;
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    gap: 18px;
		    cursor: pointer;
		    text-align: left;
		    font-family: 'Geist', Arial, sans-serif;
		}
		
		.faq-question span:first-child {
		    font-size: 0.98rem;
		    font-weight: 700;
		    color: var(--ink);
		}
		
		.faq-icon {
		    width: 28px;
		    height: 28px;
		    border-radius: 50%;
		    background: var(--primary-soft);
		    color: var(--primary);
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    font-size: 1.1rem;
		    font-weight: 700;
		    flex-shrink: 0;
		    transition: 0.2s;
		}
		
		.faq-answer {
		    max-height: 0;
		    overflow: hidden;
		    transition: max-height 0.28s ease;
		}
		
		.faq-answer p {
		    padding: 0 20px 20px;
		    color: var(--ink-3);
		    font-size: 0.9rem;
		    line-height: 1.7;
		}
		
		.faq-item.active .faq-answer {
		    max-height: 220px;
		}
		
		.faq-item.active .faq-icon {
		    background: var(--primary);
		    color: white;
		    transform: rotate(45deg);
		}

        .cta {
            background: var(--primary-dark);
            border-radius: 28px;
            padding: 52px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 30px;
        }

        .cta h2 {
            font-size: clamp(2rem, 4vw, 3rem);
            line-height: 1.08;
            letter-spacing: -0.045em;
            max-width: 650px;
        }

        .cta p {
            color: rgba(255, 255, 255, 0.7);
            margin-top: 14px;
            max-width: 540px;
        }

        .cta-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-white {
            background: white;
            color: var(--primary-dark);
        }

        .btn-white:hover {
            opacity: 0.9;
        }

        .btn-ghost {
            color: white;
            border-color: rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.08);
        }

        .btn-ghost:hover {
            background: rgba(255, 255, 255, 0.14);
        }

        .footer {
    width: 100%;
    border-top: 1px solid var(--rule);
    background: #ffffff;
    margin-top: 30px;
}

.footer-inner {
    width: 100%;
    padding: 34px 32px;
    display: grid;
    grid-template-columns: 1fr auto 1fr;
    align-items: center;
    gap: 24px;
}

.footer-brand {
    display: flex;
    align-items: center;
    gap: 12px;
    background: transparent;
}

.footer-logo {
    width: 42px;
    height: 42px;
    min-width: 42px;
    max-width: 42px;
    object-fit: contain;
    display: block;

    background: transparent;
    border: none;
    box-shadow: none;
    padding: 0;
    border-radius: 0;
}

.footer-title {
    font-size: 0.95rem;
    font-weight: 700;
    color: var(--ink);
}

.footer-subtitle {
    font-size: 0.78rem;
    color: var(--ink-4);
    margin-top: 2px;
}

.footer-links {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 22px;
    flex-wrap: wrap;
}

.footer-links a {
    color: var(--ink-3);
    font-size: 0.84rem;
    font-weight: 500;
    text-decoration: none;
    transition: 0.2s;
}

.footer-links a:hover {
    color: var(--primary);
}

.footer-copy {
    font-size: 0.8rem;
    color: var(--ink-4);
    justify-self: end;
    text-align: right;
}

@media (max-width: 900px) {
    .footer-inner {
        grid-template-columns: 1fr;
        align-items: flex-start;
    }

    .footer-brand,
    .footer-links,
    .footer-copy {
        justify-self: start;
        text-align: left;
    }

    .footer-links {
        justify-content: flex-start;
        gap: 14px;
    }
}

        @media (max-width: 980px) {
            .nav {
                padding: 0 20px;
            }

            .nav-links {
                display: none;
            }

            .brand-logo {
                width: 30px;
                height: 30px;
            }

            .hero {
                grid-template-columns: 1fr;
                padding-top: 110px;
            }

            .hero-meta {
                grid-template-columns: 1fr;
            }

            .features-grid {
                grid-template-columns: 1fr 1fr;
            }

            .workflow {
                grid-template-columns: 1fr 1fr;
            }

            .insights-layout {
                grid-template-columns: 1fr;
            }

            .cta {
                flex-direction: column;
                align-items: flex-start;
                padding: 36px;
            }
        }

        @media (max-width: 640px) {
            .wrap {
                padding: 0 20px;
            }

            .features-grid,
            .workflow,
            .pricing-grid {
                grid-template-columns: 1fr;
            }

            .section-heading {
                flex-direction: column;
                align-items: flex-start;
            }

            .hero h1 {
                font-size: 2.55rem;
            }

            .knowledge-row {
                grid-template-columns: 1fr;
                gap: 7px;
            }

            .knowledge-score {
                text-align: left;
            }

            .comparison-table {
                font-size: 0.82rem;
            }

            .comparison-table th,
            .comparison-table td {
                padding: 12px;
            }
        }
        
        .live-activity-section {
    width: 100%;
    background: #ffffff;
    border-top: 1px solid var(--rule);
    border-bottom: 1px solid var(--rule);
    overflow: hidden;
    padding: 22px 0;
}

.live-activity-header {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    margin-bottom: 16px;
    color: var(--ink-3);
    font-size: 0.76rem;
    font-weight: 800;
    letter-spacing: 0.12em;
    text-transform: uppercase;
}

.live-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #22c55e;
    box-shadow: 0 0 0 6px rgba(34, 197, 94, 0.14);
}

.live-marquee {
    width: 100%;
    overflow: hidden;
    position: relative;
}

.live-marquee::before,
.live-marquee::after {
    content: "";
    position: absolute;
    top: 0;
    width: 140px;
    height: 100%;
    z-index: 2;
    pointer-events: none;
}

.live-marquee::before {
    left: 0;
    background: linear-gradient(to right, #ffffff, rgba(255, 255, 255, 0));
}

.live-marquee::after {
    right: 0;
    background: linear-gradient(to left, #ffffff, rgba(255, 255, 255, 0));
}

.live-track {
    display: flex;
    width: max-content;
    gap: 14px;
    animation: liveActivityScroll 32s linear infinite;
}

.live-marquee:hover .live-track {
    animation-play-state: paused;
}

.live-item {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    white-space: nowrap;
    padding: 11px 18px;
    border-radius: 999px;
    background: var(--surface-soft);
    border: 1px solid var(--rule);
    color: var(--ink-2);
    font-size: 0.88rem;
    font-weight: 500;
}

.live-item strong {
    color: var(--primary);
    font-weight: 800;
}

.live-icon {
    width: 28px;
    height: 28px;
    min-width: 28px;
    border-radius: 50%;
    background: var(--primary-soft);
    color: var(--primary);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 0.78rem;
    font-weight: 800;
}

@keyframes liveActivityScroll {
    from {
        transform: translateX(0);
    }

    to {
        transform: translateX(-50%);
    }
}

@media (max-width: 640px) {
    .live-activity-header {
        font-size: 0.68rem;
        padding: 0 20px;
        text-align: center;
    }

    .live-item {
        font-size: 0.8rem;
        padding: 9px 14px;
    }

    .live-marquee::before,
    .live-marquee::after {
        width: 60px;
    }
}
    </style>
</head>

<body>
<%
    String ctx = request.getContextPath();
%>

<nav class="nav">
    <div class="nav-inner">

        <a href="<%=request.getContextPath()%>/home" class="brand">
    <img 
        src="<%=request.getContextPath()%>/assets/img/Logo.png?v=100" 
        alt="SmartStudy AI logo" 
        class="brand-logo"
    >
    <span class="brand-text">SmartStudy <span>AI</span></span>
</a>

        <div class="nav-links">
            <a href="<%=ctx%>/dashboard">Dashboard</a>
            <a href="<%=ctx%>/materials">Materials</a>
            <a href="<%=ctx%>/planner">Planner</a>
            <a href="<%=ctx%>/assessment">Assessment</a>
            <a href="<%=ctx%>/insights">Insights</a>
            <a href="<%=ctx%>/stats">Stats</a>
            <a href="<%=ctx%>/profile">Profile</a>
        </div>

        <a href="<%=ctx%>/register" class="nav-cta">Create account</a>

    </div>
</nav>

<main>
    <section class="wrap hero">
        <div>
            <div class="eyebrow">AI-assisted learning platform</div>

            <h1>
                Prepare exams with a smarter and more structured learning system.
            </h1>

            <p class="hero-text">
                SmartStudy AI helps students upload course materials, generate summaries,
                create quizzes and flashcards, plan exam preparation and identify knowledge gaps
                through personalized recommendations.
            </p>

            <div class="hero-actions">
                <a href="<%=ctx%>/register" class="btn btn-primary">Create account</a>
                <a href="<%=ctx%>/login" class="btn btn-secondary">Sign in</a>
            </div>

            <div class="hero-meta">
                <div class="meta-card">
                    <div class="meta-value">AI</div>
                    <div class="meta-label">Question generation from uploaded materials</div>
                </div>

                <div class="meta-card">
                    <div class="meta-value">24/7</div>
                    <div class="meta-label">Personalized study support</div>
                </div>

                <div class="meta-card">
                    <div class="meta-value">100%</div>
                    <div class="meta-label">Student-focused learning path</div>
                </div>
            </div>
        </div>

        <div class="preview-card">
            <div class="preview-header">
                <div>
                    <div class="preview-title">Course Analysis Preview</div>
                    <div class="preview-subtitle">Material processing and study generation</div>
                </div>
                <div class="preview-status">Ready</div>
            </div>

            <div class="preview-body">
                <div class="document-box">
                    <div class="document-top">
                        <div class="document-icon">PDF</div>
                        <div>
                            <div class="document-name">Web_Programming_2_Course.pdf</div>
                            <div class="document-info">48 pages · course material uploaded</div>
                        </div>
                    </div>

                    <div class="progress-group">
                        <div class="progress-row">
                            <span>AI analysis progress</span>
                            <span>84%</span>
                        </div>

                        <div class="progress-track">
                            <div class="progress-fill"></div>
                        </div>
                    </div>
                </div>

                <div class="generated-list">
                    <div class="generated-item">
                        <div class="generated-left">
                            <div class="generated-icon">Q</div>
                            <div>
                                <div class="generated-title">Adaptive quiz generated</div>
                                <div class="generated-count">24 questions</div>
                            </div>
                        </div>
                    </div>

                    <div class="generated-item">
                        <div class="generated-left">
                            <div class="generated-icon">F</div>
                            <div>
                                <div class="generated-title">Flashcards created</div>
                                <div class="generated-count">36 cards</div>
                            </div>
                        </div>
                    </div>

                    <div class="generated-item">
                        <div class="generated-left">
                            <div class="generated-icon">P</div>
                            <div>
                                <div class="generated-title">Study plan prepared</div>
                                <div class="generated-count">7-day revision plan</div>
                            </div>
                        </div>
                    </div>

                    <div class="generated-item">
                        <div class="generated-left">
                            <div class="generated-icon">G</div>
                            <div>
                                <div class="generated-title">Knowledge gap detected</div>
                                <div class="generated-count">Servlets and JSP integration</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <section class="live-activity-section">
    <div class="live-activity-header">
        <span class="live-dot"></span>
        <span>Live activity from the learning community</span>
    </div>

    <div class="live-marquee">
        <div class="live-track">

            <div class="live-item">
                <span class="live-icon">F</span>
                <span>A student just generated <strong>20 flashcards</strong> for Biochemistry</span>
            </div>

            <div class="live-item">
                <span class="live-icon">P</span>
                <span>A study plan was created for a <strong>Computer Networks exam</strong></span>
            </div>

            <div class="live-item">
                <span class="live-icon">Q</span>
                <span><strong>500 questions</strong> were solved in the last hour</span>
            </div>

            <div class="live-item">
                <span class="live-icon">A</span>
                <span>AI detected weak topics in <strong>Database Systems</strong></span>
            </div>

            <div class="live-item">
                <span class="live-icon">S</span>
                <span>A student completed an <strong>exam simulation</strong> with 86%</span>
            </div>

            <div class="live-item">
                <span class="live-icon">M</span>
                <span>New material uploaded for <strong>Web Programming II</strong></span>
            </div>

            <div class="live-item">
                <span class="live-icon">R</span>
                <span>Personalized revision recommendations generated for <strong>Java Servlets</strong></span>
            </div>

            <div class="live-item">
                <span class="live-icon">G</span>
                <span>A knowledge gap was identified in <strong>Operating Systems</strong></span>
            </div>

            <div class="live-item">
                <span class="live-icon">F</span>
                <span>A student just generated <strong>20 flashcards</strong> for Biochemistry</span>
            </div>

            <div class="live-item">
                <span class="live-icon">P</span>
                <span>A study plan was created for a <strong>Computer Networks exam</strong></span>
            </div>

            <div class="live-item">
                <span class="live-icon">Q</span>
                <span><strong>500 questions</strong> were solved in the last hour</span>
            </div>

            <div class="live-item">
                <span class="live-icon">A</span>
                <span>AI detected weak topics in <strong>Database Systems</strong></span>
            </div>

            <div class="live-item">
                <span class="live-icon">S</span>
                <span>A student completed an <strong>exam simulation</strong> with 86%</span>
            </div>

            <div class="live-item">
                <span class="live-icon">M</span>
                <span>New material uploaded for <strong>Web Programming II</strong></span>
            </div>

            <div class="live-item">
                <span class="live-icon">R</span>
                <span>Personalized revision recommendations generated for <strong>Java Servlets</strong></span>
            </div>

            <div class="live-item">
                <span class="live-icon">G</span>
                <span>A knowledge gap was identified in <strong>Operating Systems</strong></span>
            </div>

        </div>
    </div>
</section>

    <section class="section section-border">
        <div class="wrap">
            <div class="section-heading">
                <h2>A complete learning environment for exam preparation.</h2>
                <p>
                    The platform combines document management, automated assessment,
                    study planning and progress tracking in one personalized dashboard.
                </p>
            </div>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-number">01</div>
                    <h3>Personalized Dashboard</h3>
                    <p>
                        Students can see their courses, study time, upcoming exams,
                        weak disciplines, best results and daily recommendations.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-number">02</div>
                    <h3>Material Workspace</h3>
                    <p>
                        Course materials can be uploaded and stored in the database.
                        The system analyzes them and prepares summaries, quizzes and flashcards.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-number">03</div>
                    <h3>AI Study Planner</h3>
                    <p>
                        The student enters the exam date and desired difficulty level.
                        The platform creates a dynamic revision plan.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-number">04</div>
                    <h3>Assessment Center</h3>
                    <p>
                        The platform generates quizzes and flashcards from uploaded materials
                        and stores quiz results for each student.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-number">05</div>
                    <h3>Gap Analysis</h3>
                    <p>
                        The system detects weak topics based on quiz scores and recommends
                        targeted revision activities.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-number">06</div>
                    <h3>Performance Statistics</h3>
                    <p>
                        Students can follow score history, learning efficiency,
                        study time and progress evolution over time.
                    </p>
                </div>
            </div>
        </div>
    </section>

   <section class="section section-border">
    <div class="wrap">
        <div class="section-heading">
            <h2>From raw course material to a personalized exam strategy.</h2>
            <p>
                SmartStudy AI transforms uploaded materials into summaries, quizzes,
                flashcards, gap alerts and a clear revision path.
            </p>
        </div>

        <div class="workflow-impact">

            <div class="workflow-card">
                <div class="workflow-top">
                    <span class="workflow-number">1</span>
                    <span class="workflow-icon">📄</span>
                </div>

                <h3>Upload learning materials</h3>
                <p>
                    Students upload course files or write their own notes. The content is stored
                    securely and becomes the foundation for all AI-generated activities.
                </p>

                <span class="workflow-arrow">→</span>
            </div>

            <div class="workflow-card">
                <div class="workflow-top">
                    <span class="workflow-number">2</span>
                    <span class="workflow-icon">🧠</span>
                </div>

                <h3>AI analyzes the content</h3>
                <p>
                    The system identifies key concepts, important definitions, chapters,
                    possible exam topics and relationships between ideas.
                </p>

                <span class="workflow-arrow">→</span>
            </div>

            <div class="workflow-card">
                <div class="workflow-top">
                    <span class="workflow-number">3</span>
                    <span class="workflow-icon">⚡</span>
                </div>

                <h3>Activities are generated</h3>
                <p>
                    SmartStudy creates quizzes, flashcards, summaries and revision tasks
                    adapted to the student’s exam date and difficulty level.
                </p>

                <span class="workflow-arrow">→</span>
            </div>

            <div class="workflow-card">
                <div class="workflow-top">
                    <span class="workflow-number">4</span>
                    <span class="workflow-icon">📈</span>
                </div>

                <h3>Progress becomes actionable</h3>
                <p>
                    Quiz results are tracked, weak topics are detected, and the platform
                    recommends exactly what the student should revise next.
                </p>
            </div>

        </div>

        <div class="workflow-result">
            <div>
                <h3>The result: a smarter, adaptive study path.</h3>
                <p>
                    Instead of studying everything randomly, each student receives a focused plan
                    based on their materials, results and remaining preparation time.
                </p>
            </div>

            <div class="workflow-result-badge">
                Personalized learning loop
            </div>
        </div>
    </div>
</section>

    <section class="section section-border">
        <div class="wrap insights-layout">
            <div>
                <div class="eyebrow">AI insights</div>

                <h2 style="font-size: clamp(2rem, 4vw, 3.1rem); line-height: 1.08; letter-spacing: -0.045em;">
                    A knowledge map that shows what the student has mastered.
                </h2>

                <p class="hero-text" style="margin-top: 20px;">
                    After each quiz, the platform updates the student's mastery level for each topic.
                    Low scores become gap alerts, and the system recommends what should be studied next.
                </p>

                <div class="hero-actions">
                    <a href="<%=ctx%>/insights" class="btn btn-primary">View insights</a>
                    <a href="<%=ctx%>/assessment" class="btn btn-secondary">Start assessment</a>
                </div>
            </div>

            <div class="knowledge-card">
                <div class="knowledge-row">
                    <div class="knowledge-name">HTML and CSS</div>
                    <div class="knowledge-track">
                        <div class="knowledge-fill" style="width: 88%;"></div>
                    </div>
                    <div class="knowledge-score">88%</div>
                </div>

                <div class="knowledge-row">
                    <div class="knowledge-name">JSP pages</div>
                    <div class="knowledge-track">
                        <div class="knowledge-fill" style="width: 76%;"></div>
                    </div>
                    <div class="knowledge-score">76%</div>
                </div>

                <div class="knowledge-row">
                    <div class="knowledge-name">Servlets</div>
                    <div class="knowledge-track">
                        <div class="knowledge-fill medium" style="width: 58%;"></div>
                    </div>
                    <div class="knowledge-score">58%</div>
                </div>

                <div class="knowledge-row">
                    <div class="knowledge-name">JDBC</div>
                    <div class="knowledge-track">
                        <div class="knowledge-fill medium" style="width: 49%;"></div>
                    </div>
                    <div class="knowledge-score">49%</div>
                </div>

                <div class="knowledge-row">
                    <div class="knowledge-name">MVC architecture</div>
                    <div class="knowledge-track">
                        <div class="knowledge-fill low" style="width: 34%;"></div>
                    </div>
                    <div class="knowledge-score">34%</div>
                </div>
            </div>
        </div>
    </section>

    <section class="section section-border">
        <div class="wrap">
            <div class="section-heading">
                <h2>The difference is measurable.</h2>
                <p>
                    SmartStudy AI replaces passive revision with structured preparation,
                    adaptive assessment and personalized recommendations.
                </p>
            </div>

            <table class="comparison-table">
                <thead>
                <tr>
                    <th>Aspect</th>
                    <th>Traditional method</th>
                    <th>SmartStudy AI</th>
                </tr>
                </thead>

                <tbody>
                <tr>
                    <td>Planning</td>
                    <td><span class="cross">×</span> Manual organization</td>
                    <td><span class="check">✓</span> Dynamic study plan</td>
                </tr>

                <tr>
                    <td>Assessment</td>
                    <td><span class="cross">×</span> Static exercises</td>
                    <td><span class="check">✓</span> Quizzes generated from course materials</td>
                </tr>

                <tr>
                    <td>Gap detection</td>
                    <td><span class="cross">×</span> Difficult to identify weak topics</td>
                    <td><span class="check">✓</span> Automatic gap alerts</td>
                </tr>

                <tr>
                    <td>Progress tracking</td>
                    <td><span class="cross">×</span> No detailed history</td>
                    <td><span class="check">✓</span> Personalized dashboard and statistics</td>
                </tr>

                <tr>
                    <td>Revision</td>
                    <td><span class="cross">×</span> Same method for all students</td>
                    <td><span class="check">✓</span> Recommendations based on personal results</td>
                </tr>
                </tbody>
            </table>
        </div>
    </section>

    <section class="section section-border">
        <div class="wrap">
            <div class="section-heading">
                <h2>Simple access for students.</h2>
                <p>
                    The application can be used with a free account or a premium plan
                    for extended learning features.
                </p>
            </div>

            <div class="pricing-grid">
                <div class="price-card">
                    <div class="price-tier">Student</div>
                    <div class="price-amount">Free</div>
                    <div class="price-sub">Basic learning support</div>

                    <ul class="price-feats">
                        <li><span class="check">✓</span> Create an account</li>
                        <li><span class="check">✓</span> Upload course materials</li>
                        <li><span class="check">✓</span> Generate basic quizzes</li>
                        <li><span class="check">✓</span> Track quiz results</li>
                    </ul>

                    <a href="<%=ctx%>/register" class="btn btn-secondary">Create account</a>
                </div>

                <div class="price-card featured">
                    <div class="price-tier">Advanced</div>
                    <div class="price-amount">Premium</div>
                    <div class="price-sub">Extended exam preparation</div>

                    <ul class="price-feats">
                        <li><span class="check">✓</span> Advanced AI insights</li>
                        <li><span class="check">✓</span> Full exam simulation</li>
                        <li><span class="check">✓</span> Detailed knowledge map</li>
                        <li><span class="check">✓</span> Personalized revision path</li>
                    </ul>

                    <a href="<%=ctx%>/register" class="btn btn-white">Start now</a>
                </div>
            </div>
        </div>
    </section>

    <section class="section section-border">
    <div class="wrap insights-layout">
        <div>
            <div class="eyebrow">FAQ</div>

            <h2 style="font-size: clamp(2rem, 4vw, 3.1rem); line-height: 1.08; letter-spacing: -0.045em;">
                Frequently asked questions.
            </h2>

            <p class="hero-text" style="margin-top: 20px;">
                Click on a question to display the answer. This section explains the most important
                functionalities of the SmartStudy AI platform.
            </p>
        </div>

        <div class="faq-list">
            <div class="faq-item">
                <button class="faq-question" type="button">
                    <span>Where are uploaded materials stored?</span>
                    <span class="faq-icon">+</span>
                </button>

                <div class="faq-answer">
                    <p>
                        Uploaded materials are stored in the database and linked to the connected
                        student account. Each material can then be used by the AI module to generate
                        summaries, quizzes and flashcards.
                    </p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question" type="button">
                    <span>How are questions generated?</span>
                    <span class="faq-icon">+</span>
                </button>

                <div class="faq-answer">
                    <p>
                        The AI module analyzes the text of the uploaded materials, extracts important
                        concepts and creates quiz questions from the content. These generated questions
                        are then saved in the database.
                    </p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question" type="button">
                    <span>How are gaps detected?</span>
                    <span class="faq-icon">+</span>
                </button>

                <div class="faq-answer">
                    <p>
                        Gaps are detected by comparing the student's quiz results with the topics of
                        each course. If the score is low for a specific topic, the platform marks it as
                        a weak area and recommends targeted revision.
                    </p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question" type="button">
                    <span>Can students create an account?</span>
                    <span class="faq-icon">+</span>
                </button>

                <div class="faq-answer">
                    <p>
                        Yes. Students can create a new account from the register page. The account is
                        saved in the users table and can later be used to access the personalized dashboard.
                    </p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question" type="button">
                    <span>Can the platform create a personalized study plan?</span>
                    <span class="faq-icon">+</span>
                </button>

                <div class="faq-answer">
                    <p>
                        Yes. The student enters the exam date and the desired difficulty level. The system
                        creates a study plan that divides the material into revision tasks and helps the
                        student prepare before the exam.
                    </p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question" type="button">
                    <span>What happens after a quiz is completed?</span>
                    <span class="faq-icon">+</span>
                </button>

                <div class="faq-answer">
                    <p>
                        After a quiz is submitted, the result is saved in the database. The platform updates
                        the student's performance statistics, detects weak topics and may generate new
                        recommendations for revision.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

    <section class="section">
        <div class="wrap">
            <div class="cta">
                <div>
                    <h2>Start building a personalized study path.</h2>
                    <p>
                        Create an account, upload your first course material and let the platform
                        generate quizzes, flashcards and revision recommendations.
                    </p>
                </div>

                <div class="cta-actions">
                    <a href="<%=ctx%>/register" class="btn btn-white">Create account</a>
                    <a href="<%=ctx%>/login" class="btn btn-ghost">Sign in</a>
                </div>
            </div>
        </div>
    </section>
</main>

<footer class="footer">
    <div class="footer-inner">

        <div class="footer-brand">
            <img 
                src="<%=ctx%>/assets/img/Logo.png?v=2" 
                alt="SmartStudy AI logo" 
                class="footer-logo"
            >

            <div>
                <div class="footer-title">SmartStudy AI</div>
                <div class="footer-subtitle">Intelligent exam preparation platform</div>
            </div>
        </div>

        <div class="footer-links">
            <a href="<%=ctx%>/home">Home</a>
            <a href="<%=ctx%>/dashboard">Dashboard</a>
            <a href="<%=ctx%>/materials">Materials</a>
            <a href="<%=ctx%>/planner">Planner</a>
            <a href="<%=ctx%>/assessment">Assessment</a>
            <a href="<%=ctx%>/insights">Insights</a>
        </div>

        <div class="footer-copy">
            © 2026 SmartStudy AI. All rights reserved.
        </div>

    </div>
</footer>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const faqItems = document.querySelectorAll(".faq-item");

        faqItems.forEach(function (item) {
            const question = item.querySelector(".faq-question");

            question.addEventListener("click", function () {
                const isActive = item.classList.contains("active");

                faqItems.forEach(function (otherItem) {
                    otherItem.classList.remove("active");
                });

                if (!isActive) {
                    item.classList.add("active");
                }
            });
        });
    });
</script>
</body>
</html>


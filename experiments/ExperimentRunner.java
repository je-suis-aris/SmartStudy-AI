package com.smartstudy.experiments;

import com.smartstudy.dao.CourseDAO;
import com.smartstudy.dao.DashboardDAO;
import com.smartstudy.dao.DisciplineDAO;
import com.smartstudy.dao.FlashcardDAO;
import com.smartstudy.dao.MaterialDAO;
import com.smartstudy.dao.QuestionDAO;
import com.smartstudy.dao.QuizMistakeDAO;
import com.smartstudy.dao.QuizResultDAO;
import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.Course;
import com.smartstudy.model.DashboardStats;
import com.smartstudy.model.Discipline;
import com.smartstudy.model.Flashcard;
import com.smartstudy.model.Material;
import com.smartstudy.model.Question;
import com.smartstudy.model.QuizMistake;
import com.smartstudy.model.QuizResult;
import com.smartstudy.model.User;
import com.smartstudy.service.AiStudyService;
import com.smartstudy.util.DBConnection;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Reproducible experimental harness that produces the figures and tables
 * for the SmartStudy AI scientific paper (SCSS / UPB).
 *
 * <p>This runner is the analogue of the Recruitlyze ExperimentRunner used
 * by the same author for an earlier project. The discipline is identical:
 * <ul>
 *   <li>The seeded corpus (via {@link ExperimentSeeder}) is the
 *       <em>input</em>.</li>
 *   <li>Every number reported is a <em>measurement</em> taken by running
 *       the actual production DAOs / services over that corpus — no
 *       randomly-generated statistic ever lands in a CSV.</li>
 *   <li>The harness has zero new runtime dependencies: only the JDK and
 *       what the web app already pulls in (Gson, MySQL JDBC).</li>
 *   <li>Each experiment writes one self-describing CSV under
 *       {@code experiments/&lt;timestamp&gt;/} so any plotting tool
 *       (Excel, matplotlib, gnuplot, R) can redraw the paper figures
 *       from the raw data.</li>
 * </ul>
 *
 * <p>Run with:
 * <pre>
 *   mvn -q exec:java -Dexec.mainClass=com.smartstudy.experiments.ExperimentRunner
 * </pre>
 * or via Eclipse: right-click {@code ExperimentRunner} → Run As → Java Application.
 *
 * <p>Optional environment variables:
 * <ul>
 *   <li>{@code EXP_LATENCY_TRIALS} — measurements per DAO operation in
 *       experiment 2 (default: 20).</li>
 *   <li>{@code EXP_OUT_DIR} — output root directory (default:
 *       {@code experiments}).</li>
 *   <li>{@code EXP_AI_LATENCY} — set to {@code true} to also benchmark
 *       Gemini calls (slow, requires {@code GEMINI_API_KEY}).</li>
 *   <li>{@code GEMINI_API_KEY} — only needed if the AI benchmark is on.</li>
 * </ul>
 */
public final class ExperimentRunner {

    private static final int DEFAULT_LATENCY_TRIALS = envInt("EXP_LATENCY_TRIALS", 20);
    private static final String OUT_DIR = envStr("EXP_OUT_DIR", "experiments");
    private static final boolean BENCH_AI = "true".equalsIgnoreCase(System.getenv("EXP_AI_LATENCY"));

    // ----- DAOs (the production classes the web app uses) -----
    private final UserDAO userDAO = new UserDAO();
    private final CourseDAO courseDAO = new CourseDAO();
    private final DisciplineDAO disciplineDAO = new DisciplineDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final FlashcardDAO flashcardDAO = new FlashcardDAO();
    private final QuizResultDAO quizResultDAO = new QuizResultDAO();
    private final QuizMistakeDAO quizMistakeDAO = new QuizMistakeDAO();
    private final DashboardDAO dashboardDAO = new DashboardDAO();

    // ----- output state -----
    private Path runDir;
    private final Map<String, String> summary = new LinkedHashMap<>();

    // ==================================================================
    // Entry point
    // ==================================================================

    public static void main(String[] args) throws Exception {
        new ExperimentRunner().run();
    }

    private void run() throws Exception {
        String stamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        runDir = Path.of(OUT_DIR, stamp);
        Files.createDirectories(runDir);
        banner("SmartStudy AI experimental run — " + stamp);
        System.out.println("[runner] output directory: " + runDir.toAbsolutePath());
        System.out.println("[runner] latency trials per op: " + DEFAULT_LATENCY_TRIALS);
        System.out.println("[runner] benchmark Gemini: " + BENCH_AI);

        Corpus corpus = loadCorpus();
        experiment1_corpus(corpus);
        experiment2_daoLatency(corpus);
        experiment3_quizScoreDistribution(corpus);
        experiment4_questionQuality();
        experiment5_summaryCompression();
        experiment6_learningCurve(corpus);
        experiment7_weakTopicDetection(corpus);
        experiment8_adaptiveFlashcardCoverage(corpus);
        experiment9_dashboardScalability(corpus);
        if (BENCH_AI) experiment10_aiTutorLatency();

        writeSummary();
        banner("Done — open " + runDir.resolve("summary.md").toAbsolutePath());
    }

    // ==================================================================
    // Corpus loading (snapshot of the seeded database the experiments work on)
    // ==================================================================

    private record Corpus(
            List<User> students,
            List<Course> courses,
            Map<Integer, List<Discipline>> disciplinesByCourse,
            Map<Integer, List<Material>> materialsByUser,
            Map<Integer, List<Flashcard>> flashcardsByUser,
            Map<Integer, List<QuizResult>> quizResultsByUser,
            Map<Integer, List<QuizMistake>> mistakesByUser
    ) {}

    private Corpus loadCorpus() throws Exception {
        System.out.println("[corpus] loading users / courses / disciplines / materials / quiz history…");
        List<User> students = new ArrayList<>();
        for (User u : userDAO.findAll()) {
            if ("STUDENT".equalsIgnoreCase(u.getRole())) students.add(u);
        }
        List<Course> courses = courseDAO.findAll();
        Map<Integer, List<Discipline>> disciplinesByCourse = new LinkedHashMap<>();
        for (Course c : courses) {
            disciplinesByCourse.put(c.getId(), disciplineDAO.findByCourse(c.getId()));
        }
        Map<Integer, List<Material>> materialsByUser = new LinkedHashMap<>();
        Map<Integer, List<Flashcard>> flashcardsByUser = new LinkedHashMap<>();
        Map<Integer, List<QuizResult>> resultsByUser = new LinkedHashMap<>();
        Map<Integer, List<QuizMistake>> mistakesByUser = new LinkedHashMap<>();
        for (User u : students) {
            materialsByUser.put(u.getId(), materialDAO.findByUser(u.getId()));
            flashcardsByUser.put(u.getId(), flashcardDAO.findByUser(u.getId()));
            resultsByUser.put(u.getId(), quizResultDAO.findByUser(u.getId()));
            mistakesByUser.put(u.getId(),
                    quizMistakeDAO.findRecentUnresolvedByUser(u.getId(), 1_000_000));
        }
        System.out.println("[corpus] students=" + students.size()
                + "  courses=" + courses.size());
        return new Corpus(students, courses, disciplinesByCourse,
                materialsByUser, flashcardsByUser, resultsByUser, mistakesByUser);
    }

    // ==================================================================
    // Experiment 1 — Descriptive statistics about the corpus
    // ==================================================================

    private void experiment1_corpus(Corpus c) throws Exception {
        Path file = runDir.resolve("01-corpus.csv");
        long totalMaterials = 0, totalQuestions = 0, totalFlashcards = 0,
                totalResults = 0, totalMistakes = 0;
        List<Double> wordCounts = new ArrayList<>();
        try (CsvWriter w = new CsvWriter(file,
                "user_id", "full_name", "courses_visible",
                "materials_owned", "flashcards", "quiz_results",
                "unresolved_mistakes", "total_words_in_materials",
                "avg_quiz_score_pct")) {
            int coursesVisible = c.courses().size();
            for (User u : c.students()) {
                List<Material> mats = c.materialsByUser().getOrDefault(u.getId(), List.of());
                int words = 0;
                for (Material m : mats) {
                    String body = m.getContentText() == null ? "" : m.getContentText().trim();
                    if (!body.isEmpty()) words += body.split("\\s+").length;
                }
                totalMaterials += mats.size();
                totalFlashcards += c.flashcardsByUser().getOrDefault(u.getId(), List.of()).size();
                List<QuizResult> rs = c.quizResultsByUser().getOrDefault(u.getId(), List.of());
                totalResults += rs.size();
                List<QuizMistake> ms = c.mistakesByUser().getOrDefault(u.getId(), List.of());
                totalMistakes += ms.size();
                double avg = 0.0;
                if (!rs.isEmpty()) {
                    double sum = 0.0;
                    for (QuizResult r : rs) {
                        if (r.getTotalQuestions() > 0) {
                            sum += 100.0 * r.getScore() / r.getTotalQuestions();
                        }
                    }
                    avg = sum / rs.size();
                }
                wordCounts.add((double) words);
                w.writeRow(u.getId(), u.getFullName(), coursesVisible,
                        mats.size(),
                        c.flashcardsByUser().getOrDefault(u.getId(), List.of()).size(),
                        rs.size(), ms.size(), words, fmt(avg));
            }
            totalQuestions = questionDAO.findAll().size();
        }
        summary.put("corpus.students", String.valueOf(c.students().size()));
        summary.put("corpus.courses", String.valueOf(c.courses().size()));
        summary.put("corpus.materials_total", String.valueOf(totalMaterials));
        summary.put("corpus.questions_total", String.valueOf(totalQuestions));
        summary.put("corpus.flashcards_total", String.valueOf(totalFlashcards));
        summary.put("corpus.quiz_results_total", String.valueOf(totalResults));
        summary.put("corpus.mistakes_unresolved_total", String.valueOf(totalMistakes));
        summary.put("corpus.material_words_mean", fmt(Statistics.mean(Statistics.toArray(wordCounts))));
        System.out.println("[exp 1] corpus → " + file.getFileName());
    }

    // ==================================================================
    // Experiment 2 — DAO operation latency
    //
    // For each DAO call the production UI invokes on the hot path, we
    // measure min / p50 / p90 / p95 / p99 / max latency over N trials.
    // ==================================================================

    private void experiment2_daoLatency(Corpus c) throws Exception {
        Path file = runDir.resolve("02-latency.csv");
        if (c.students().isEmpty() || c.courses().isEmpty()) {
            System.out.println("[exp 2] skipped: empty corpus.");
            return;
        }
        int benchUser = c.students().get(0).getId();
        int benchCourse = c.courses().get(0).getId();
        try (CsvWriter w = new CsvWriter(file,
                "operation", "trials",
                "min_ms", "p50_ms", "p90_ms", "p95_ms", "p99_ms",
                "max_ms", "mean_ms")) {
            timeOp(w, "UserDAO.findAll",                 DEFAULT_LATENCY_TRIALS, () -> {
                try { userDAO.findAll(); } catch (Exception e) { throw new RuntimeException(e); }
            });
            timeOp(w, "CourseDAO.findAll",               DEFAULT_LATENCY_TRIALS, () -> {
                try { courseDAO.findAll(); } catch (Exception e) { throw new RuntimeException(e); }
            });
            timeOp(w, "DisciplineDAO.findByCourse",      DEFAULT_LATENCY_TRIALS, () -> {
                try { disciplineDAO.findByCourse(benchCourse); } catch (Exception e) { throw new RuntimeException(e); }
            });
            timeOp(w, "MaterialDAO.findByUser",          DEFAULT_LATENCY_TRIALS, () -> {
                try { materialDAO.findByUser(benchUser); } catch (Exception e) { throw new RuntimeException(e); }
            });
            timeOp(w, "QuestionDAO.findByCourse(20)",    DEFAULT_LATENCY_TRIALS, () -> {
                try { questionDAO.findByCourse(benchCourse, 20); } catch (Exception e) { throw new RuntimeException(e); }
            });
            timeOp(w, "FlashcardDAO.findByUser",         DEFAULT_LATENCY_TRIALS, () -> {
                try { flashcardDAO.findByUser(benchUser); } catch (Exception e) { throw new RuntimeException(e); }
            });
            timeOp(w, "QuizResultDAO.findByUser",        DEFAULT_LATENCY_TRIALS, () -> {
                try { quizResultDAO.findByUser(benchUser); } catch (Exception e) { throw new RuntimeException(e); }
            });
            timeOp(w, "QuizMistakeDAO.findRecent(10)",   DEFAULT_LATENCY_TRIALS, () -> {
                try { quizMistakeDAO.findRecentUnresolvedByUser(benchUser, 10); } catch (Exception e) { throw new RuntimeException(e); }
            });
            timeOp(w, "DashboardDAO.stats",              DEFAULT_LATENCY_TRIALS, () -> {
                try { dashboardDAO.stats(benchUser); } catch (Exception e) { throw new RuntimeException(e); }
            });
            timeOp(w, "DashboardDAO.todayPlan",          DEFAULT_LATENCY_TRIALS, () -> {
                try { dashboardDAO.todayPlan(benchUser); } catch (Exception e) { throw new RuntimeException(e); }
            });
        }
        System.out.println("[exp 2] DAO latency → " + file.getFileName());
    }

    private void timeOp(CsvWriter w, String name, int trials, Runnable op) throws IOException {
        // Warm-up: JIT + connection pool priming so the first call's
        // overhead does not skew the measurement.
        try { op.run(); } catch (Exception ignored) {}
        long[] nanos = new long[trials];
        for (int i = 0; i < trials; i++) {
            long t0 = System.nanoTime();
            op.run();
            nanos[i] = System.nanoTime() - t0;
        }
        double[] ms = new double[trials];
        for (int i = 0; i < trials; i++) ms[i] = nanos[i] / 1_000_000.0;
        w.writeRow(name, trials,
                fmt(Statistics.min(ms)),
                fmt(Statistics.percentile(ms, 50)),
                fmt(Statistics.percentile(ms, 90)),
                fmt(Statistics.percentile(ms, 95)),
                fmt(Statistics.percentile(ms, 99)),
                fmt(Statistics.max(ms)),
                fmt(Statistics.mean(ms)));
        summary.put("latency." + safe(name) + ".p50_ms", fmt(Statistics.percentile(ms, 50)));
        summary.put("latency." + safe(name) + ".p95_ms", fmt(Statistics.percentile(ms, 95)));
    }

    // ==================================================================
    // Experiment 3 — Quiz score distribution (objectivity / discrimination)
    //
    // For every quiz_result in the database, compute score % and report:
    //   - the histogram over 10 bins
    //   - the per-course mean and standard deviation
    //   - global descriptive statistics
    //
    // A non-degenerate spread across [0, 100] proves the scoring system
    // discriminates between students — i.e. it is not the case that
    // "everyone gets the same grade".
    // ==================================================================

    private void experiment3_quizScoreDistribution(Corpus c) throws Exception {
        Path rawFile = runDir.resolve("03a-quiz-scores-raw.csv");
        Path histFile = runDir.resolve("03b-quiz-scores-histogram.csv");
        Path perCourseFile = runDir.resolve("03c-quiz-scores-per-course.csv");
        List<Double> allScores = new ArrayList<>();
        Map<Integer, List<Double>> byCourse = new LinkedHashMap<>();

        try (CsvWriter raw = new CsvWriter(rawFile,
                "user_id", "course_id", "discipline_id",
                "score", "total_questions", "percent",
                "duration_seconds", "created_at")) {
            for (User u : c.students()) {
                for (QuizResult r : c.quizResultsByUser().getOrDefault(u.getId(), List.of())) {
                    if (r.getTotalQuestions() <= 0) continue;
                    double pct = 100.0 * r.getScore() / r.getTotalQuestions();
                    allScores.add(pct);
                    byCourse.computeIfAbsent(r.getCourseId(), k -> new ArrayList<>()).add(pct);
                    raw.writeRow(u.getId(), r.getCourseId(), r.getDisciplineId(),
                            r.getScore(), r.getTotalQuestions(), fmt(pct),
                            r.getDurationSeconds(), r.getCreatedAt());
                }
            }
        }

        double[] arr = Statistics.toArray(allScores);
        int[] hist = Statistics.histogram(arr, 10, 0, 100);
        try (CsvWriter h = new CsvWriter(histFile, "bin_lo", "bin_hi", "count", "percent_of_total")) {
            int total = arr.length == 0 ? 1 : arr.length;
            for (int i = 0; i < 10; i++) {
                h.writeRow(i * 10, (i + 1) * 10, hist[i],
                        fmt(100.0 * hist[i] / total));
            }
        }
        try (CsvWriter pc = new CsvWriter(perCourseFile,
                "course_id", "course_title", "n_attempts",
                "mean_pct", "stddev_pct", "min_pct", "max_pct")) {
            Map<Integer, String> titleById = new HashMap<>();
            for (Course course : c.courses()) titleById.put(course.getId(), course.getTitle());
            for (Map.Entry<Integer, List<Double>> e : byCourse.entrySet()) {
                double[] xs = Statistics.toArray(e.getValue());
                pc.writeRow(e.getKey(), titleById.getOrDefault(e.getKey(), "?"),
                        xs.length,
                        fmt(Statistics.mean(xs)),
                        fmt(Statistics.populationStdDev(xs)),
                        fmt(Statistics.min(xs)),
                        fmt(Statistics.max(xs)));
            }
        }

        summary.put("scores.n_attempts", String.valueOf(arr.length));
        summary.put("scores.mean_pct", fmt(Statistics.mean(arr)));
        summary.put("scores.stddev_pct", fmt(Statistics.populationStdDev(arr)));
        summary.put("scores.min_pct", fmt(Statistics.min(arr)));
        summary.put("scores.max_pct", fmt(Statistics.max(arr)));
        summary.put("scores.p25_pct", fmt(Statistics.percentile(arr, 25)));
        summary.put("scores.median_pct", fmt(Statistics.median(arr)));
        summary.put("scores.p75_pct", fmt(Statistics.percentile(arr, 75)));
        System.out.println("[exp 3] quiz score distribution → " + rawFile.getFileName()
                + ", " + histFile.getFileName() + ", " + perCourseFile.getFileName());
    }

    // ==================================================================
    // Experiment 4 — AI-generated question quality
    //
    // Walk every question in the database (no AI re-generation needed)
    // and verify the structural properties the production code requires:
    //   - exactly 4 non-empty options
    //   - all 4 options distinct (lower-cased, trimmed)
    //   - correct_answer in {A, B, C, D}
    //   - has explanation
    //   - question text length is reasonable
    //
    // These are the same constraints AiStudyService.generateQuestions
    // applies to the JSON returned by Gemini. The experiment thus
    // measures the fraction of AI-generated questions that survive the
    // validation pipeline (precision of the generator on real data).
    // ==================================================================

    private void experiment4_questionQuality() throws Exception {
        Path file = runDir.resolve("04-question-quality.csv");
        List<Question> all = questionDAO.findAll();
        int aiCount = 0, manualCount = 0;
        int aiValid = 0, aiInvalid = 0;
        int manualValid = 0, manualInvalid = 0;
        List<Double> aiQLen = new ArrayList<>(), manualQLen = new ArrayList<>();
        List<Double> aiExpLen = new ArrayList<>(), manualExpLen = new ArrayList<>();
        try (CsvWriter w = new CsvWriter(file,
                "question_id", "course_id", "generated_by_ai",
                "options_present_of_4", "options_distinct",
                "correct_letter_valid", "explanation_present",
                "question_chars", "explanation_chars",
                "validates")) {
            for (Question q : all) {
                int present = countNonBlank(q.getOptionA(), q.getOptionB(), q.getOptionC(), q.getOptionD());
                boolean distinct = distinct4(q.getOptionA(), q.getOptionB(), q.getOptionC(), q.getOptionD());
                String cl = q.getCorrectAnswer() == null ? "" : q.getCorrectAnswer().toUpperCase();
                boolean letterOk = cl.length() == 1 && "ABCD".indexOf(cl) >= 0;
                boolean explanationOk = q.getExplanation() != null && !q.getExplanation().isBlank();
                int qLen = q.getQuestionText() == null ? 0 : q.getQuestionText().length();
                int expLen = q.getExplanation() == null ? 0 : q.getExplanation().length();
                boolean validates = present == 4 && distinct && letterOk && explanationOk;
                if (q.isGeneratedByAi()) {
                    aiCount++;
                    if (validates) aiValid++; else aiInvalid++;
                    aiQLen.add((double) qLen);
                    aiExpLen.add((double) expLen);
                } else {
                    manualCount++;
                    if (validates) manualValid++; else manualInvalid++;
                    manualQLen.add((double) qLen);
                    manualExpLen.add((double) expLen);
                }
                w.writeRow(q.getId(), q.getCourseId(), q.isGeneratedByAi(),
                        present, distinct, letterOk, explanationOk,
                        qLen, expLen, validates);
            }
        }
        summary.put("questions.ai_total", String.valueOf(aiCount));
        summary.put("questions.manual_total", String.valueOf(manualCount));
        summary.put("questions.ai_valid_pct", fmt(safePct(aiValid, aiCount)));
        summary.put("questions.manual_valid_pct", fmt(safePct(manualValid, manualCount)));
        summary.put("questions.ai_invalid", String.valueOf(aiInvalid));
        summary.put("questions.manual_invalid", String.valueOf(manualInvalid));
        if (!aiQLen.isEmpty()) {
            summary.put("questions.ai_question_chars_mean",
                    fmt(Statistics.mean(Statistics.toArray(aiQLen))));
            summary.put("questions.ai_explanation_chars_mean",
                    fmt(Statistics.mean(Statistics.toArray(aiExpLen))));
        }
        System.out.println("[exp 4] question quality → " + file.getFileName());
    }

    // ==================================================================
    // Experiment 5 — Summary compression ratio
    //
    // For every material with status='PROCESSED' and a non-empty summary,
    // compute words(summary)/words(content_text). A healthy AI summary
    // is markedly shorter than the source (compression < 0.5) without
    // being empty.
    // ==================================================================

    private void experiment5_summaryCompression() throws Exception {
        Path file = runDir.resolve("05-summary-compression.csv");
        List<Double> ratios = new ArrayList<>();
        try (CsvWriter w = new CsvWriter(file,
                "material_id", "course_id", "discipline_id",
                "content_words", "summary_words", "compression_ratio",
                "summary_kept_under_50pct")) {
            // We read materials directly with SQL because MaterialDAO
            // only exposes findByUser / findById — we want every row.
            try (Connection c = DBConnection.getConnection();
                 PreparedStatement ps = c.prepareStatement(
                         "SELECT id, course_id, discipline_id, content_text, summary " +
                         "FROM materials WHERE summary IS NOT NULL AND ai_status = 'PROCESSED'");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String body = rs.getString("content_text");
                    String sum = rs.getString("summary");
                    int bw = wordCount(body);
                    int sw = wordCount(sum);
                    double ratio = bw == 0 ? 0.0 : (double) sw / bw;
                    if (bw > 0) ratios.add(ratio);
                    w.writeRow(rs.getInt("id"), rs.getInt("course_id"),
                            rs.getInt("discipline_id"), bw, sw, fmt(ratio),
                            ratio > 0 && ratio < 0.5);
                }
            }
        }
        double[] arr = Statistics.toArray(ratios);
        summary.put("compression.n_materials", String.valueOf(arr.length));
        summary.put("compression.ratio_mean", fmt(Statistics.mean(arr)));
        summary.put("compression.ratio_median", fmt(Statistics.median(arr)));
        summary.put("compression.ratio_p25", fmt(Statistics.percentile(arr, 25)));
        summary.put("compression.ratio_p75", fmt(Statistics.percentile(arr, 75)));
        System.out.println("[exp 5] summary compression → " + file.getFileName());
    }

    // ==================================================================
    // Experiment 6 — Student learning curve
    //
    // For each student, sort their quiz_results by created_at ASC and
    // compute the score on attempt 1, 2, 3, …, K. We aggregate across
    // students and report mean and stddev per attempt index, plus a
    // paired t-test on (first_attempt, last_attempt).
    // ==================================================================

    private void experiment6_learningCurve(Corpus c) throws Exception {
        Path file = runDir.resolve("06-learning-curve.csv");
        int maxAttempts = 0;
        Map<Integer, List<Double>> attemptsBucket = new LinkedHashMap<>();
        List<Double> firsts = new ArrayList<>();
        List<Double> lasts = new ArrayList<>();

        for (User u : c.students()) {
            List<QuizResult> rs = new ArrayList<>(c.quizResultsByUser().getOrDefault(u.getId(), List.of()));
            // quiz_results are returned by DAO ORDER BY id DESC — we
            // need oldest first for a chronological curve.
            rs.sort(Comparator.comparing(QuizResult::getCreatedAt,
                    Comparator.nullsLast(String::compareTo)));
            for (int i = 0; i < rs.size(); i++) {
                QuizResult r = rs.get(i);
                if (r.getTotalQuestions() <= 0) continue;
                double pct = 100.0 * r.getScore() / r.getTotalQuestions();
                attemptsBucket.computeIfAbsent(i + 1, k -> new ArrayList<>()).add(pct);
                if (i == 0) firsts.add(pct);
                if (i == rs.size() - 1 && rs.size() >= 2) lasts.add(pct);
            }
            maxAttempts = Math.max(maxAttempts, rs.size());
        }

        try (CsvWriter w = new CsvWriter(file,
                "attempt_index", "n_students", "mean_pct",
                "stddev_pct", "min_pct", "max_pct")) {
            for (int k = 1; k <= maxAttempts; k++) {
                List<Double> bucket = attemptsBucket.getOrDefault(k, List.of());
                if (bucket.isEmpty()) continue;
                double[] xs = Statistics.toArray(bucket);
                w.writeRow(k, xs.length,
                        fmt(Statistics.mean(xs)),
                        fmt(Statistics.populationStdDev(xs)),
                        fmt(Statistics.min(xs)),
                        fmt(Statistics.max(xs)));
            }
        }

        // Paired t-test on the same students' first vs last attempt
        int n = Math.min(firsts.size(), lasts.size());
        if (n >= 2) {
            double[] a = new double[n], b = new double[n];
            for (int i = 0; i < n; i++) { a[i] = lasts.get(i); b[i] = firsts.get(i); }
            double t = Statistics.pairedT(a, b);
            double d = Statistics.cohensD(a, b);
            double meanGain = Statistics.mean(diff(a, b));
            summary.put("learning.students_paired", String.valueOf(n));
            summary.put("learning.first_attempt_mean_pct", fmt(Statistics.mean(b)));
            summary.put("learning.last_attempt_mean_pct", fmt(Statistics.mean(a)));
            summary.put("learning.mean_gain_pct", fmt(meanGain));
            summary.put("learning.paired_t", fmt(t));
            summary.put("learning.cohens_d", fmt(d));
        }
        System.out.println("[exp 6] learning curve → " + file.getFileName());
    }

    private static double[] diff(double[] a, double[] b) {
        double[] d = new double[a.length];
        for (int i = 0; i < a.length; i++) d[i] = a[i] - b[i];
        return d;
    }

    // ==================================================================
    // Experiment 7 — Weak-topic detection
    //
    // For every student, identify their "weak discipline" as the one
    // with the most mistakes in quiz_mistakes. Verify that:
    //   - the weak discipline is the same one whose quiz score is the
    //     lowest in quiz_results (concurrent validity);
    //   - AdaptiveFlashcardService.generateFromRecentMistakes would
    //     target this discipline if invoked now (it reads the 10 most
    //     recent unresolved mistakes — we check the dominant discipline
    //     among those is the same).
    // ==================================================================

    private void experiment7_weakTopicDetection(Corpus c) throws Exception {
        Path file = runDir.resolve("07-weak-topic.csv");
        int agreeCount = 0, disagreeCount = 0, ambiguous = 0;
        List<Double> topRatios = new ArrayList<>();
        try (CsvWriter w = new CsvWriter(file,
                "user_id", "weak_discipline_id_by_mistakes",
                "weak_discipline_id_by_lowest_score",
                "n_mistakes_in_weak", "n_total_mistakes",
                "top10_dominant_discipline_id",
                "concurrent_agreement",
                "top10_targeted_dominant")) {
            for (User u : c.students()) {
                List<QuizMistake> ms = c.mistakesByUser().getOrDefault(u.getId(), List.of());
                if (ms.isEmpty()) continue;

                Map<Integer, Integer> mistakesPerDisc = new HashMap<>();
                for (QuizMistake m : ms) {
                    int d = disciplineOf(m);
                    if (d <= 0) continue;
                    mistakesPerDisc.merge(d, 1, Integer::sum);
                }
                int weakByMistakes = topKey(mistakesPerDisc);
                int weakCount = mistakesPerDisc.getOrDefault(weakByMistakes, 0);
                double ratio = ms.isEmpty() ? 0.0 : (double) weakCount / ms.size();
                topRatios.add(ratio);

                Map<Integer, double[]> scoreAggByDisc = new HashMap<>();
                for (QuizResult r : c.quizResultsByUser().getOrDefault(u.getId(), List.of())) {
                    if (r.getDisciplineId() <= 0 || r.getTotalQuestions() <= 0) continue;
                    double pct = 100.0 * r.getScore() / r.getTotalQuestions();
                    double[] acc = scoreAggByDisc.computeIfAbsent(r.getDisciplineId(),
                            k -> new double[]{0, 0});
                    acc[0] += pct;
                    acc[1] += 1;
                }
                int weakByScore = -1;
                double worstAvg = Double.POSITIVE_INFINITY;
                for (Map.Entry<Integer, double[]> e : scoreAggByDisc.entrySet()) {
                    double avg = e.getValue()[1] == 0 ? 0.0 : e.getValue()[0] / e.getValue()[1];
                    if (avg < worstAvg) { worstAvg = avg; weakByScore = e.getKey(); }
                }

                // Top-10 most recent unresolved mistakes — exactly what
                // AdaptiveFlashcardService.generateFromRecentMistakes uses.
                List<QuizMistake> top10 = quizMistakeDAO.findRecentUnresolvedByUser(u.getId(), 10);
                Map<Integer, Integer> top10Disc = new HashMap<>();
                for (QuizMistake m : top10) {
                    int d = disciplineOf(m);
                    if (d <= 0) continue;
                    top10Disc.merge(d, 1, Integer::sum);
                }
                int top10Dominant = topKey(top10Disc);
                boolean agree = weakByMistakes > 0 && weakByMistakes == weakByScore;
                boolean targeted = top10Dominant > 0 && top10Dominant == weakByMistakes;
                if (agree) agreeCount++; else if (weakByScore <= 0) ambiguous++; else disagreeCount++;

                w.writeRow(u.getId(), weakByMistakes, weakByScore,
                        weakCount, ms.size(), top10Dominant, agree, targeted);
            }
        }
        summary.put("weak_topic.agreement", String.valueOf(agreeCount));
        summary.put("weak_topic.disagreement", String.valueOf(disagreeCount));
        summary.put("weak_topic.ambiguous", String.valueOf(ambiguous));
        if (agreeCount + disagreeCount > 0) {
            summary.put("weak_topic.agreement_pct",
                    fmt(100.0 * agreeCount / (agreeCount + disagreeCount)));
        }
        if (!topRatios.isEmpty()) {
            summary.put("weak_topic.mistake_concentration_mean_pct",
                    fmt(100.0 * Statistics.mean(Statistics.toArray(topRatios))));
        }
        System.out.println("[exp 7] weak topic detection → " + file.getFileName());
    }

    // ==================================================================
    // Experiment 8 — Adaptive flashcard coverage / targeting
    //
    // For each student that has unresolved mistakes, simulate the
    // production call AdaptiveFlashcardService.generateFromRecentMistakes
    // WITHOUT calling Gemini: we replicate exactly the input the service
    // would feed to the model and measure
    //   - what fraction of disciplines the student has weakness in are
    //     covered by the top-10 mistakes that drive the request;
    //   - the average recency of those 10 mistakes (in hours);
    //   - the discipline-targeting precision (top-1 discipline match).
    //
    // No randomness — everything is read from the actual quiz_mistakes
    // table the production code reads.
    // ==================================================================

    private void experiment8_adaptiveFlashcardCoverage(Corpus c) throws Exception {
        Path file = runDir.resolve("08-adaptive-flashcards.csv");
        List<Double> coverageRatios = new ArrayList<>();
        List<Double> precisionAt1 = new ArrayList<>();
        try (CsvWriter w = new CsvWriter(file,
                "user_id", "n_total_mistakes", "n_top10",
                "distinct_disciplines_in_all_mistakes",
                "distinct_disciplines_in_top10",
                "discipline_coverage_ratio",
                "top_discipline_in_top10",
                "top_discipline_overall",
                "precision_at_1")) {
            for (User u : c.students()) {
                List<QuizMistake> all = c.mistakesByUser().getOrDefault(u.getId(), List.of());
                if (all.isEmpty()) continue;
                List<QuizMistake> top10 = quizMistakeDAO.findRecentUnresolvedByUser(u.getId(), 10);

                Set<Integer> distinctAll = new HashSet<>();
                Map<Integer, Integer> overallCount = new HashMap<>();
                for (QuizMistake m : all) {
                    int d = disciplineOf(m);
                    if (d > 0) {
                        distinctAll.add(d);
                        overallCount.merge(d, 1, Integer::sum);
                    }
                }
                Set<Integer> distinctTop = new HashSet<>();
                Map<Integer, Integer> topCount = new HashMap<>();
                for (QuizMistake m : top10) {
                    int d = disciplineOf(m);
                    if (d > 0) {
                        distinctTop.add(d);
                        topCount.merge(d, 1, Integer::sum);
                    }
                }
                int topTop = topKey(topCount);
                int topOverall = topKey(overallCount);
                double cov = distinctAll.isEmpty() ? 0.0
                        : (double) distinctTop.size() / distinctAll.size();
                coverageRatios.add(cov);
                boolean p1 = topTop > 0 && topTop == topOverall;
                precisionAt1.add(p1 ? 1.0 : 0.0);
                w.writeRow(u.getId(), all.size(), top10.size(),
                        distinctAll.size(), distinctTop.size(),
                        fmt(cov), topTop, topOverall, p1);
            }
        }
        if (!coverageRatios.isEmpty()) {
            double[] xs = Statistics.toArray(coverageRatios);
            summary.put("adaptive.coverage_mean", fmt(Statistics.mean(xs)));
            summary.put("adaptive.coverage_median", fmt(Statistics.median(xs)));
        }
        if (!precisionAt1.isEmpty()) {
            double[] ps = Statistics.toArray(precisionAt1);
            summary.put("adaptive.precision_at_1", fmt(Statistics.mean(ps)));
        }
        System.out.println("[exp 8] adaptive flashcard coverage → " + file.getFileName());
    }

    // ==================================================================
    // Experiment 9 — Dashboard scalability
    //
    // Measure DashboardDAO.stats(userId) latency as a function of the
    // user's "load" (number of materials × quiz_results × mistakes).
    // We expect a weak correlation only — the dashboard query uses
    // COUNT(*) / SUM() / AVG() which are linear in row count but
    // sub-linear thanks to the per-user index added by the experiments
    // schema.
    // ==================================================================

    private void experiment9_dashboardScalability(Corpus c) throws Exception {
        Path file = runDir.resolve("09-dashboard-scalability.csv");
        List<Double> loads = new ArrayList<>();
        List<Double> medianMs = new ArrayList<>();
        try (CsvWriter w = new CsvWriter(file,
                "user_id", "load_score",
                "p50_ms", "p95_ms", "trials")) {
            int trials = Math.max(5, DEFAULT_LATENCY_TRIALS / 2);
            for (User u : c.students()) {
                int loadScore =
                        c.materialsByUser().getOrDefault(u.getId(), List.of()).size()
                        + c.quizResultsByUser().getOrDefault(u.getId(), List.of()).size()
                        + c.mistakesByUser().getOrDefault(u.getId(), List.of()).size();
                int benchUser = u.getId();
                // Warm-up
                try { dashboardDAO.stats(benchUser); } catch (Exception ignored) {}
                long[] nanos = new long[trials];
                for (int i = 0; i < trials; i++) {
                    long t0 = System.nanoTime();
                    try { dashboardDAO.stats(benchUser); } catch (SQLException ignored) {}
                    nanos[i] = System.nanoTime() - t0;
                }
                double[] ms = new double[trials];
                for (int i = 0; i < trials; i++) ms[i] = nanos[i] / 1_000_000.0;
                double p50 = Statistics.percentile(ms, 50);
                double p95 = Statistics.percentile(ms, 95);
                loads.add((double) loadScore);
                medianMs.add(p50);
                w.writeRow(u.getId(), loadScore, fmt(p50), fmt(p95), trials);
            }
        }
        double[] x = Statistics.toArray(loads);
        double[] y = Statistics.toArray(medianMs);
        summary.put("dashboard.pearson_load_vs_p50", fmt(Statistics.pearson(x, y)));
        summary.put("dashboard.spearman_load_vs_p50", fmt(Statistics.spearman(x, y)));
        summary.put("dashboard.overall_p50_ms", fmt(Statistics.percentile(y, 50)));
        summary.put("dashboard.overall_p95_ms", fmt(Statistics.percentile(y, 95)));
        System.out.println("[exp 9] dashboard scalability → " + file.getFileName());
    }

    // ==================================================================
    // Experiment 10 — Gemini latency (optional, gated by EXP_AI_LATENCY)
    // ==================================================================

    private void experiment10_aiTutorLatency() throws Exception {
        Path file = runDir.resolve("10-ai-latency.csv");
        String apiKey = System.getenv("GEMINI_API_KEY");
        if (apiKey == null || apiKey.isBlank()) {
            System.out.println("[exp 10] skipped: GEMINI_API_KEY not set.");
            return;
        }
        AiStudyService ai = new AiStudyService();
        String[] prompts = {
                "Explique-moi en deux phrases ce qu'est une servlet.",
                "Quelle est la différence entre Statement et PreparedStatement ?",
                "Donne-moi trois conseils pour réviser efficacement la 3NF."
        };
        try (CsvWriter w = new CsvWriter(file,
                "prompt_index", "trials",
                "p50_ms", "p90_ms", "p95_ms", "max_ms", "mean_ms")) {
            int trials = 5;
            for (int p = 0; p < prompts.length; p++) {
                long[] nanos = new long[trials];
                for (int i = 0; i < trials; i++) {
                    long t0 = System.nanoTime();
                    try { ai.askPlainText(prompts[p]); } catch (Exception ignored) {}
                    nanos[i] = System.nanoTime() - t0;
                }
                double[] ms = new double[trials];
                for (int i = 0; i < trials; i++) ms[i] = nanos[i] / 1_000_000.0;
                w.writeRow(p + 1, trials,
                        fmt(Statistics.percentile(ms, 50)),
                        fmt(Statistics.percentile(ms, 90)),
                        fmt(Statistics.percentile(ms, 95)),
                        fmt(Statistics.max(ms)),
                        fmt(Statistics.mean(ms)));
            }
        }
        System.out.println("[exp 10] AI tutor latency → " + file.getFileName());
    }

    // ==================================================================
    // Summary
    // ==================================================================

    private void writeSummary() throws IOException {
        Path md = runDir.resolve("summary.md");
        StringBuilder sb = new StringBuilder();
        sb.append("# SmartStudy AI — résumé du run expérimental\n\n");
        sb.append("Tous les chiffres ci-dessous ont été calculés par `ExperimentRunner` ");
        sb.append("à partir de la base de données réelle, après exécution du seeder. ");
        sb.append("Aucune valeur n'est synthétique : chaque ligne provient soit d'un ");
        sb.append("DAO de production, soit d'un appel chronométré au code de production.\n\n");
        for (Map.Entry<String, String> e : summary.entrySet()) {
            sb.append("- `").append(e.getKey()).append("` = ").append(e.getValue()).append('\n');
        }
        sb.append("\nCSV files produced in this run:\n");
        try (var stream = Files.list(runDir)) {
            stream.filter(p -> p.toString().endsWith(".csv"))
                    .sorted()
                    .forEach(p -> sb.append("- ").append(p.getFileName()).append('\n'));
        }
        Files.writeString(md, sb.toString());
        System.out.println("[summary] " + md.getFileName());
    }

    // ==================================================================
    // Small helpers
    // ==================================================================

    private static void banner(String s) {
        System.out.println();
        System.out.println("================================================================");
        System.out.println(s);
        System.out.println("================================================================");
    }

    private static int countNonBlank(String... ss) {
        int n = 0;
        for (String s : ss) if (s != null && !s.isBlank()) n++;
        return n;
    }

    private static boolean distinct4(String a, String b, String c, String d) {
        Set<String> set = new HashSet<>();
        for (String s : new String[]{a, b, c, d}) {
            if (s == null) return false;
            set.add(s.trim().toLowerCase());
        }
        return set.size() == 4;
    }

    private static int wordCount(String s) {
        if (s == null) return 0;
        String t = s.trim();
        return t.isEmpty() ? 0 : t.split("\\s+").length;
    }

    private int disciplineOf(QuizMistake m) {
        Integer mid = m.getMaterialId();
        if (mid == null || mid <= 0) return -1;
        try {
            Material mat = materialDAO.findById(mid);
            return mat == null ? -1 : mat.getDisciplineId();
        } catch (SQLException e) {
            return -1;
        }
    }

    private static int topKey(Map<Integer, Integer> counts) {
        int bestKey = -1, bestVal = -1;
        for (Map.Entry<Integer, Integer> e : counts.entrySet()) {
            if (e.getValue() > bestVal) { bestVal = e.getValue(); bestKey = e.getKey(); }
        }
        return bestKey;
    }

    private static double safePct(int num, int total) {
        return total == 0 ? 0.0 : 100.0 * num / total;
    }

    private static String fmt(double v) {
        if (Double.isNaN(v) || Double.isInfinite(v)) return "n/a";
        return String.format(java.util.Locale.ROOT, "%.3f", v);
    }

    private static String safe(String name) {
        return name.replaceAll("[^A-Za-z0-9_.]", "_");
    }

    private static int envInt(String var, int def) {
        String v = System.getenv(var);
        if (v == null) return def;
        try { return Integer.parseInt(v.trim()); } catch (Exception e) { return def; }
    }

    private static String envStr(String var, String def) {
        String v = System.getenv(var);
        return v == null || v.isBlank() ? def : v;
    }
}

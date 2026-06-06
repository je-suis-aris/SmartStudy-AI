package com.smartstudy.service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.smartstudy.util.DBConnection;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class StudyPlanService {

    private static final String MODEL = "gemini-2.5-flash";

    private static final String GEMINI_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/" + MODEL + ":generateContent";

    private static final int MATERIAL_CONTEXT_LIMIT = 3000;
    private static final int MAX_OUTPUT_TOKENS = 4096;

    private final HttpClient client = HttpClient.newHttpClient();
    private final Gson gson = new Gson();

    public void generatePlan(
            int userId,
            int courseId,
            LocalDate examDate,
            String difficulty,
            String preferredStudyRhythm,
            String learningStyle
    ) throws SQLException {

        if (examDate == null) {
            examDate = LocalDate.now().plusDays(7);
        }

        if (difficulty == null || difficulty.trim().isEmpty()) {
            difficulty = "MEDIUM";
        }

        if (preferredStudyRhythm == null || preferredStudyRhythm.trim().isEmpty()) {
            preferredStudyRhythm = "Balanced revision";
        }

        if (learningStyle == null || learningStyle.trim().isEmpty()) {
            learningStyle = "Mixed learning";
        }

        try (Connection c = DBConnection.getConnection()) {
            deleteOldPlan(c, userId, courseId);

            try {
                System.out.println("Trying to generate AI study plan with Gemini...");
                System.out.println("User ID: " + userId);
                System.out.println("Course ID: " + courseId);
                System.out.println("Exam date: " + examDate);
                System.out.println("Difficulty: " + difficulty);
                System.out.println("Preferred rhythm: " + preferredStudyRhythm);
                System.out.println("Learning style: " + learningStyle);

                List<PlanTask> aiTasks = generatePlanWithAi(
                        c,
                        userId,
                        courseId,
                        examDate,
                        difficulty,
                        preferredStudyRhythm,
                        learningStyle
                );

                if (aiTasks != null && !aiTasks.isEmpty()) {
                    System.out.println("AI plan generated successfully. Tasks: " + aiTasks.size());
                    insertPlan(c, userId, courseId, aiTasks, "AI");
                    return;
                }

                System.out.println("AI returned no tasks. Using rule-based fallback.");

                List<PlanTask> fallbackTasks = buildRuleBasedPlan(
                        examDate,
                        difficulty,
                        preferredStudyRhythm,
                        learningStyle
                );

                insertPlan(c, userId, courseId, fallbackTasks, "RULE");

            } catch (Exception aiError) {
                System.out.println("AI plan generation failed. Using rule-based fallback.");
                aiError.printStackTrace();

                List<PlanTask> fallbackTasks = buildRuleBasedPlan(
                        examDate,
                        difficulty,
                        preferredStudyRhythm,
                        learningStyle
                );

                insertPlan(c, userId, courseId, fallbackTasks, "RULE");
            }
        }
    }

    public void generatePlan(
            int userId,
            int courseId,
            LocalDate examDate,
            String difficulty
    ) throws SQLException {

        generatePlan(
                userId,
                courseId,
                examDate,
                difficulty,
                "Balanced revision",
                "Mixed learning"
        );
    }

    private List<PlanTask> generatePlanWithAi(
            Connection c,
            int userId,
            int courseId,
            LocalDate examDate,
            String difficulty,
            String preferredStudyRhythm,
            String learningStyle
    ) throws Exception {

        String courseTitle = findCourseTitle(c, courseId);
        String materialContext = findMaterialContext(c, userId, courseId);
        String quizContext = findQuizContext(c, userId, courseId);
        String gapContext = findGapContext(c, userId, courseId);

        LocalDate today = LocalDate.now();
        int availableDays = Math.max(1, (int) ChronoUnit.DAYS.between(today, examDate));
        int totalDays = Math.min(availableDays, 7);

        String rhythmInstruction = explainStudyRhythm(preferredStudyRhythm);
        String styleInstruction = explainLearningStyle(learningStyle);

        String prompt =
                "You are SmartStudy AI, an academic learning planner.\n" +
                "Generate a personalized study plan for a student.\n\n" +

                "IMPORTANT RULES:\n" +
                "1. Return ONLY valid JSON. No markdown. No code fences. No explanations outside JSON.\n" +
                "2. Generate exactly " + totalDays + " tasks.\n" +
                "3. Each task must be concrete, useful and adapted to the student profile.\n" +
                "4. Use the uploaded material, quiz results and weak topics when available.\n" +
                "5. Do not generate generic tasks only.\n" +
                "6. The plan must respect the preferred study rhythm and learning style.\n" +
                "7. Use dates starting from " + today + " until before or on the exam date.\n" +
                "8. Priority must be one of: HIGH, MEDIUM, LOW.\n" +
                "9. estimatedMinutes must be a number between 15 and 90.\n" +
                "10. Task titles must be specific to the uploaded material and course.\n" +
                "11. Do not use generic titles such as 'Read the course summary', 'Rewrite the main ideas', or 'Review definitions and concepts'.\n" +
                "12. Each task title must mention a concrete concept, chapter, topic, method, theory, case study or weak area found in the uploaded material.\n" +
                "13. Keep each description under 180 characters.\n" +
                "14. Keep each taskTitle under 80 characters.\n" +
                "15. Return compact JSON only.\n\n" +

                "STUDENT PREFERENCES:\n" +
                "Preferred study rhythm: " + preferredStudyRhythm + "\n" +
                "Rhythm instruction: " + rhythmInstruction + "\n\n" +
                "Learning style: " + learningStyle + "\n" +
                "Learning style instruction: " + styleInstruction + "\n\n" +

                "COURSE INFORMATION:\n" +
                "Course title: " + courseTitle + "\n" +
                "Exam date: " + examDate + "\n" +
                "Difficulty: " + difficulty + "\n" +
                "Available days: " + totalDays + "\n\n" +

                "UPLOADED MATERIAL CONTEXT:\n" +
                materialContext + "\n\n" +
                "Use the real topics from this material when naming tasks. For example, instead of 'Review definitions', write a title that includes the real concept from the material.\n\n" +

                "QUIZ RESULTS CONTEXT:\n" +
                quizContext + "\n\n" +

                "WEAK TOPICS / GAP ALERTS:\n" +
                gapContext + "\n\n" +

                "JSON FORMAT REQUIRED:\n" +
                "[\n" +
                "  {\n" +
                "    \"date\": \"2026-05-16\",\n" +
                "    \"taskTitle\": \"Review Danone management structure\",\n" +
                "    \"description\": \"Study the organizational structure and identify the main management functions.\",\n" +
                "    \"estimatedMinutes\": 45,\n" +
                "    \"priority\": \"HIGH\"\n" +
                "  }\n" +
                "]";

        System.out.println("Course title used for AI planner: " + courseTitle);
        System.out.println("Material context length: " + materialContext.length());
        System.out.println("Quiz context: " + quizContext);
        System.out.println("Gap context: " + gapContext);

        String aiText = callGeminiText(prompt);

        System.out.println("Raw AI response:");
        System.out.println(aiText);

        String jsonOnly = extractJsonArray(aiText);

        JsonArray array = JsonParser.parseString(jsonOnly).getAsJsonArray();

        List<PlanTask> tasks = new ArrayList<>();

        for (int i = 0; i < array.size(); i++) {
            JsonObject obj = array.get(i).getAsJsonObject();

            String dateText = getString(obj, "date");
            String taskTitle = getString(obj, "taskTitle");
            String description = getString(obj, "description");
            String priority = getString(obj, "priority").toUpperCase();

            int minutes = getInt(obj, "estimatedMinutes", determineMinutes(difficulty, preferredStudyRhythm));

            if (taskTitle.isBlank()) {
                continue;
            }

            if (description.isBlank()) {
                description = "Complete this personalized study activity based on your course material.";
            }

            if (!priority.equals("HIGH") && !priority.equals("MEDIUM") && !priority.equals("LOW")) {
                priority = "MEDIUM";
            }

            if (minutes < 15) {
                minutes = 15;
            }

            if (minutes > 90) {
                minutes = 90;
            }

            LocalDate taskDate;

            try {
                taskDate = LocalDate.parse(dateText);
            } catch (Exception e) {
                taskDate = today.plusDays(i);
            }

            if (taskDate.isBefore(today)) {
                taskDate = today.plusDays(i);
            }

            if (taskDate.isAfter(examDate)) {
                taskDate = examDate;
            }

            tasks.add(new PlanTask(
                    taskDate,
                    shorten(taskTitle, 180),
                    shorten(description, 900),
                    minutes,
                    priority
            ));
        }

        return tasks;
    }

    private String callGeminiText(String prompt) throws IOException, InterruptedException {
        String apiKey = System.getenv("GEMINI_API_KEY");

        System.out.println("GEMINI_API_KEY exists: " + (apiKey != null && !apiKey.trim().isEmpty()));

        if (apiKey == null || apiKey.trim().isEmpty()) {
            throw new IOException("GEMINI_API_KEY is not configured.");
        }

        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", prompt);

        JsonArray parts = new JsonArray();
        parts.add(textPart);

        JsonObject content = new JsonObject();
        content.add("parts", parts);

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.35);
        generationConfig.addProperty("topP", 0.85);
        generationConfig.addProperty("maxOutputTokens", MAX_OUTPUT_TOKENS);
        generationConfig.addProperty("responseMimeType", "application/json");

        JsonObject body = new JsonObject();
        body.add("contents", contents);
        body.add("generationConfig", generationConfig);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(GEMINI_URL + "?key=" + apiKey))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(body)))
                .build();

        HttpResponse<String> response =
                client.send(request, HttpResponse.BodyHandlers.ofString());

        System.out.println("Gemini HTTP status: " + response.statusCode());

        if (response.statusCode() == 429) {
            throw new IOException("Google AI quota limit reached. Response: " + response.body());
        }

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("Google AI API error " + response.statusCode() + ": " + response.body());
        }

        return extractGeminiText(response.body());
    }

    private String extractGeminiText(String responseBody) throws IOException {
        JsonObject root = JsonParser.parseString(responseBody).getAsJsonObject();

        JsonArray candidates = root.getAsJsonArray("candidates");

        if (candidates == null || candidates.size() == 0) {
            throw new IOException("No candidates returned by Gemini. Raw response: " + responseBody);
        }

        JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
        JsonObject content = firstCandidate.getAsJsonObject("content");

        if (content == null) {
            throw new IOException("No content returned by Gemini. Raw response: " + responseBody);
        }

        JsonArray parts = content.getAsJsonArray("parts");

        if (parts == null || parts.size() == 0) {
            throw new IOException("No text parts returned by Gemini. Raw response: " + responseBody);
        }

        StringBuilder result = new StringBuilder();

        for (int i = 0; i < parts.size(); i++) {
            JsonObject part = parts.get(i).getAsJsonObject();

            if (part.has("text")) {
                result.append(part.get("text").getAsString());
            }
        }

        return result.toString().trim();
    }

    private String extractJsonArray(String text) throws IOException {
        if (text == null || text.trim().isEmpty()) {
            throw new IOException("AI returned empty response.");
        }

        String clean = text.trim();

        if (clean.startsWith("```")) {
            clean = clean.replace("```json", "")
                    .replace("```", "")
                    .trim();
        }

        int start = clean.indexOf("[");
        int end = clean.lastIndexOf("]");

        if (start == -1 || end == -1 || end <= start) {
            throw new IOException("Could not extract JSON array from AI response: " + text);
        }

        return clean.substring(start, end + 1);
    }

    private String findCourseTitle(Connection c, int courseId) {
        String sql = "SELECT title FROM courses WHERE id = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("title");
                }
            }
        } catch (Exception ignored) {
        }

        return "Selected course";
    }

    private String findMaterialContext(Connection c, int userId, int courseId) {
        String sql =
                "SELECT title, summary, content_text " +
                "FROM materials " +
                "WHERE user_id = ? AND course_id = ? " +
                "ORDER BY id DESC " +
                "LIMIT 3";

        StringBuilder sb = new StringBuilder();

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String title = rs.getString("title");
                    String summary = rs.getString("summary");
                    String content = rs.getString("content_text");

                    sb.append("Material title: ").append(title).append("\n");

                    if (summary != null && !summary.trim().isEmpty()) {
                        sb.append("Summary: ").append(limitText(summary, 1000)).append("\n");
                    } else if (content != null && !content.trim().isEmpty()) {
                        sb.append("Extract: ").append(limitText(content, 1200)).append("\n");
                    }

                    sb.append("\n");
                }
            }
        } catch (Exception ignored) {
        }

        if (sb.length() == 0) {
            return "No uploaded material found for this course.";
        }

        return limitText(sb.toString(), MATERIAL_CONTEXT_LIMIT);
    }

    private String findQuizContext(Connection c, int userId, int courseId) {
        String sql =
                "SELECT score, total_questions, created_at " +
                "FROM quiz_results " +
                "WHERE user_id = ? AND course_id = ? " +
                "ORDER BY id DESC " +
                "LIMIT 5";

        StringBuilder sb = new StringBuilder();

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int score = rs.getInt("score");
                    int total = rs.getInt("total_questions");

                    double percent = 0;

                    if (total > 0) {
                        percent = (score * 100.0) / total;
                    }

                    sb.append("Quiz result: ")
                            .append(score)
                            .append("/")
                            .append(total)
                            .append(" (")
                            .append(String.format("%.1f", percent))
                            .append("%)")
                            .append("\n");
                }
            }
        } catch (Exception ignored) {
        }

        if (sb.length() == 0) {
            return "No quiz results available yet.";
        }

        return sb.toString();
    }

    private String findGapContext(Connection c, int userId, int courseId) {
        String sql =
                "SELECT message, severity " +
                "FROM gap_alerts " +
                "WHERE user_id = ? AND course_id = ? AND solved = false " +
                "ORDER BY FIELD(severity, 'HIGH', 'MEDIUM', 'LOW') " +
                "LIMIT 5";

        StringBuilder sb = new StringBuilder();

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sb.append("Gap alert [")
                            .append(rs.getString("severity"))
                            .append("]: ")
                            .append(rs.getString("message"))
                            .append("\n");
                }
            }
        } catch (Exception ignored) {
        }

        if (sb.length() == 0) {
            return "No active weak topic alerts.";
        }

        return sb.toString();
    }

    private List<PlanTask> buildRuleBasedPlan(
            LocalDate examDate,
            String difficulty,
            String preferredStudyRhythm,
            String learningStyle
    ) {
        List<PlanTask> tasks = new ArrayList<>();

        LocalDate today = LocalDate.now();
        int availableDays = Math.max(1, (int) ChronoUnit.DAYS.between(today, examDate));

        int totalDays = Math.min(availableDays, 21);
        int minutes = determineMinutes(difficulty, preferredStudyRhythm);
        String normalizedStyle = learningStyle.toLowerCase();

        for (int i = 0; i < totalDays; i++) {
            LocalDate taskDate = today.plusDays(i);

            PlanTask task;

            if (normalizedStyle.contains("quiz")) {
                task = quizFocusedTask(taskDate, i, minutes);
            } else if (normalizedStyle.contains("flashcard")) {
                task = flashcardFocusedTask(taskDate, i, minutes);
            } else if (normalizedStyle.contains("summary") || normalizedStyle.contains("reading")) {
                task = summaryFocusedTask(taskDate, i, minutes);
            } else {
                task = mixedTask(taskDate, i, minutes);
            }

            task = adaptTaskToRhythm(task, preferredStudyRhythm, i, totalDays);
            tasks.add(task);
        }

        return tasks;
    }

    private int determineMinutes(String difficulty, String preferredStudyRhythm) {
        String diff = difficulty == null ? "MEDIUM" : difficulty.toUpperCase();
        String rhythm = preferredStudyRhythm == null ? "" : preferredStudyRhythm.toLowerCase();

        int minutes;

        if ("HARD".equals(diff)) {
            minutes = 70;
        } else if ("EASY".equals(diff)) {
            minutes = 30;
        } else {
            minutes = 45;
        }

        if (rhythm.contains("intensive")) {
            minutes += 20;
        } else if (rhythm.contains("light")) {
            minutes -= 15;
        } else if (rhythm.contains("sprint")) {
            minutes += 25;
        } else if (rhythm.contains("weekend")) {
            minutes = 35;
        }

        if (minutes < 15) {
            minutes = 15;
        }

        if (minutes > 90) {
            minutes = 90;
        }

        return minutes;
    }

    private String explainStudyRhythm(String rhythm) {
        if (rhythm == null) {
            return "Use a balanced revision rhythm with moderate daily sessions.";
        }

        if ("Intensive revision".equalsIgnoreCase(rhythm)) {
            return "Create longer and more demanding sessions, with frequent quizzes and exam simulation tasks.";
        }

        if ("Light daily revision".equalsIgnoreCase(rhythm)) {
            return "Create short daily sessions of 15-25 minutes, focused on consistency and repetition.";
        }

        if ("Exam sprint".equalsIgnoreCase(rhythm)) {
            return "Create an urgent compressed plan focused on weak topics, quizzes and final revision.";
        }

        if ("Weekend-focused".equalsIgnoreCase(rhythm)) {
            return "Place lighter tasks during weekdays and longer study blocks during the weekend.";
        }

        return "Distribute the workload evenly across the available days with a balance of reading, practice and review.";
    }

    private String explainLearningStyle(String style) {
        if (style == null) {
            return "Use a mixed learning style with summaries, flashcards and quizzes.";
        }

        if ("Quizzes and practice".equalsIgnoreCase(style)) {
            return "Prioritize quizzes, practice questions, review of wrong answers and exam-style tasks.";
        }

        if ("Flashcards".equalsIgnoreCase(style)) {
            return "Prioritize flashcard review, memorization, definitions and spaced repetition.";
        }

        if ("Reading summaries".equalsIgnoreCase(style)) {
            return "Prioritize reading summaries, understanding concepts and reviewing explanations.";
        }

        if ("Visual explanations".equalsIgnoreCase(style)) {
            return "Prioritize diagrams, structured explanations, examples and simplified concept breakdowns.";
        }

        return "Combine summaries, flashcards, quizzes, weak topic review and AI tutor explanations.";
    }

    private PlanTask quizFocusedTask(LocalDate date, int index, int minutes) {
        int step = index % 5;

        if (step == 0) {
            return new PlanTask(
                    date,
                    "Take a diagnostic quiz",
                    "Start with a short quiz to identify weak topics and check what you remember from the course material.",
                    minutes,
                    "HIGH"
            );
        }

        if (step == 1) {
            return new PlanTask(
                    date,
                    "Review incorrect quiz answers",
                    "Analyze the questions answered incorrectly and connect each mistake to the corresponding concept from the material.",
                    minutes,
                    "HIGH"
            );
        }

        if (step == 2) {
            return new PlanTask(
                    date,
                    "Practice exam-style questions",
                    "Solve new questions focused on the most important concepts and definitions from the uploaded material.",
                    minutes,
                    "MEDIUM"
            );
        }

        if (step == 3) {
            return new PlanTask(
                    date,
                    "Revise weak concepts",
                    "Review the concepts marked as weak in the insights page and prepare short notes for each one.",
                    minutes,
                    "HIGH"
            );
        }

        return new PlanTask(
                date,
                "Mini exam simulation",
                "Complete a timed quiz session and check if your score improves compared with the previous attempt.",
                minutes,
                "MEDIUM"
        );
    }

    private PlanTask flashcardFocusedTask(LocalDate date, int index, int minutes) {
        int step = index % 5;

        if (step == 0) {
            return new PlanTask(
                    date,
                    "Generate and review flashcards",
                    "Create flashcards from the uploaded material and review the most important definitions.",
                    minutes,
                    "HIGH"
            );
        }

        if (step == 1) {
            return new PlanTask(
                    date,
                    "Memorize key concepts",
                    "Use flashcards to memorize concepts, terms and relationships that are essential for the exam.",
                    minutes,
                    "MEDIUM"
            );
        }

        if (step == 2) {
            return new PlanTask(
                    date,
                    "Repeat difficult flashcards",
                    "Focus only on flashcards that were difficult or unclear during the previous revision session.",
                    minutes,
                    "HIGH"
            );
        }

        if (step == 3) {
            return new PlanTask(
                    date,
                    "Connect flashcards to examples",
                    "For each important flashcard, write or explain one concrete example from the course material.",
                    minutes,
                    "MEDIUM"
            );
        }

        return new PlanTask(
                date,
                "Self-test with flashcards",
                "Test yourself without looking at the answer side and mark the cards that need more repetition.",
                minutes,
                "MEDIUM"
        );
    }

    private PlanTask summaryFocusedTask(LocalDate date, int index, int minutes) {
        int step = index % 5;

        if (step == 0) {
            return new PlanTask(
                    date,
                    "Read the course summary",
                    "Start with the AI-generated summary and identify the main ideas of the uploaded material.",
                    minutes,
                    "MEDIUM"
            );
        }

        if (step == 1) {
            return new PlanTask(
                    date,
                    "Rewrite the main ideas",
                    "Rewrite the most important points in your own words to check if you understood them correctly.",
                    minutes,
                    "MEDIUM"
            );
        }

        if (step == 2) {
            return new PlanTask(
                    date,
                    "Review definitions and concepts",
                    "Focus on the definitions, classifications and explanations that appear repeatedly in the material.",
                    minutes,
                    "HIGH"
            );
        }

        if (step == 3) {
            return new PlanTask(
                    date,
                    "Create a structured revision sheet",
                    "Organize the content into sections, keywords and short explanations for fast revision.",
                    minutes,
                    "MEDIUM"
            );
        }

        return new PlanTask(
                date,
                "Check understanding with questions",
                "After reading, answer a few questions to verify that the summary was understood, not only memorized.",
                minutes,
                "MEDIUM"
        );
    }

    private PlanTask mixedTask(LocalDate date, int index, int minutes) {
        int step = index % 6;

        if (step == 0) {
            return new PlanTask(
                    date,
                    "Read the course summary",
                    "Review the AI-generated summary and identify the main ideas from the uploaded material.",
                    minutes,
                    "MEDIUM"
            );
        }

        if (step == 1) {
            return new PlanTask(
                    date,
                    "Review important concepts",
                    "Focus on definitions, key ideas and relationships between concepts.",
                    minutes,
                    "HIGH"
            );
        }

        if (step == 2) {
            return new PlanTask(
                    date,
                    "Practice with flashcards",
                    "Use flashcards to memorize important definitions and examples from the material.",
                    minutes,
                    "MEDIUM"
            );
        }

        if (step == 3) {
            return new PlanTask(
                    date,
                    "Take a quiz",
                    "Answer quiz questions generated from the uploaded material and check your score.",
                    minutes,
                    "HIGH"
            );
        }

        if (step == 4) {
            return new PlanTask(
                    date,
                    "Review weak topics",
                    "Use the insights page to identify weak areas and revise them carefully.",
                    minutes,
                    "HIGH"
            );
        }

        return new PlanTask(
                date,
                "Ask the AI tutor for explanations",
                "Use the AI tutor to clarify difficult concepts and request examples or simplified explanations.",
                minutes,
                "LOW"
        );
    }

    private PlanTask adaptTaskToRhythm(PlanTask task, String preferredStudyRhythm, int index, int totalDays) {
        String rhythm = preferredStudyRhythm == null ? "" : preferredStudyRhythm.toLowerCase();

        if (rhythm.contains("intensive")) {
            task.minutes = Math.min(task.minutes + 15, 90);

            if ("MEDIUM".equals(task.priority)) {
                task.priority = "HIGH";
            }

            task.description += " This is part of an intensive revision rhythm, so focus deeply.";
        } else if (rhythm.contains("light")) {
            task.minutes = Math.max(task.minutes - 10, 15);
            task.description += " This is a light revision task, so keep it short and consistent.";
        } else if (rhythm.contains("sprint")) {
            task.minutes = Math.min(task.minutes + 20, 90);
            task.priority = "HIGH";
            task.description += " Because this is an exam sprint, prioritize exam-relevant concepts.";
        } else if (rhythm.contains("weekend")) {
            boolean weekend = task.date.getDayOfWeek().getValue() == 6 || task.date.getDayOfWeek().getValue() == 7;

            if (weekend) {
                task.minutes = Math.min(task.minutes + 25, 90);
                task.priority = "HIGH";
                task.description += " Use this longer weekend block for deeper revision.";
            } else {
                task.minutes = Math.max(task.minutes - 10, 15);
                task.description += " This is a lighter weekday task before a weekend block.";
            }
        } else {
            task.description += " This task follows a balanced revision rhythm.";
        }

        if (index >= totalDays - 2) {
            task.priority = "HIGH";
            task.description += " The exam is approaching, so consolidate the key ideas.";
        }

        return task;
    }

    private void deleteOldPlan(Connection c, int userId, int courseId) throws SQLException {
        String sql = "DELETE FROM study_plan_items WHERE user_id = ? AND course_id = ?";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            ps.executeUpdate();
        }
    }

    private void insertPlan(Connection c, int userId, int courseId, List<PlanTask> tasks, String generatedBy) throws SQLException {
        String sql =
                "INSERT INTO study_plan_items " +
                "(user_id, course_id, plan_date, task_title, description, estimated_minutes, completed, priority, generated_by) " +
                "VALUES (?, ?, ?, ?, ?, ?, false, ?, ?)";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            for (PlanTask task : tasks) {
                ps.setInt(1, userId);
                ps.setInt(2, courseId);
                ps.setDate(3, Date.valueOf(task.date));
                ps.setString(4, task.title);
                ps.setString(5, task.description);
                ps.setInt(6, task.minutes);
                ps.setString(7, task.priority);
                ps.setString(8, generatedBy);
                ps.addBatch();
            }

            ps.executeBatch();
        }
    }

    private String getString(JsonObject obj, String key) {
        if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) {
            return "";
        }

        return obj.get(key).getAsString().trim();
    }

    private int getInt(JsonObject obj, String key, int defaultValue) {
        try {
            if (obj != null && obj.has(key) && !obj.get(key).isJsonNull()) {
                return obj.get(key).getAsInt();
            }
        } catch (Exception ignored) {
        }

        return defaultValue;
    }

    private String limitText(String text, int maxLength) {
        if (text == null) {
            return "";
        }

        String clean = text
                .replace("\r", " ")
                .replace("\n", " ")
                .replace("\t", " ")
                .replaceAll("\\s+", " ")
                .trim();

        if (clean.length() <= maxLength) {
            return clean;
        }

        return clean.substring(0, maxLength);
    }

    private String shorten(String text, int maxLength) {
        if (text == null) {
            return "";
        }

        String clean = text.trim();

        if (clean.length() <= maxLength) {
            return clean;
        }

        int cut = clean.lastIndexOf(" ", maxLength);

        if (cut < 50) {
            cut = maxLength;
        }

        return clean.substring(0, cut).trim() + "...";
    }

    private static class PlanTask {
        private LocalDate date;
        private String title;
        private String description;
        private int minutes;
        private String priority;

        private PlanTask(LocalDate date, String title, String description, int minutes, String priority) {
            this.date = date;
            this.title = title;
            this.description = description;
            this.minutes = minutes;
            this.priority = priority;
        }
    }
}
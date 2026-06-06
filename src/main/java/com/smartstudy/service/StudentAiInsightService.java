package com.smartstudy.service;

import com.smartstudy.dao.AiFeedbackDAO;
import com.smartstudy.model.AiFeedback;
import com.smartstudy.model.User;
import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;

public class StudentAiInsightService {

    private final AiStudyService aiStudyService;
    private final AiFeedbackDAO aiFeedbackDAO;

    public StudentAiInsightService() {
        this.aiStudyService = new AiStudyService();
        this.aiFeedbackDAO = new AiFeedbackDAO();
    }

    public String generateQuizFeedback(
            User user,
            int courseId,
            int score,
            int total,
            List<Map<String, Object>> reviewItems
    ) {
        StringBuilder prompt = new StringBuilder();

        prompt.append("You are an academic AI learning coach. ");
        prompt.append("Give personalized feedback after a quiz. ");
        prompt.append("Use clear English. Be encouraging but precise. ");
        prompt.append("Do not invent facts. Base your feedback only on the quiz data. ");
        prompt.append("\n\nStudent name: ").append(user.getFullName());
        prompt.append("\nScore: ").append(score).append("/").append(total);

        if (total > 0) {
            double percent = score * 100.0 / total;
            prompt.append("\nPercentage: ").append(String.format("%.1f", percent)).append("%");
        }

        prompt.append("\n\nQuiz review items:");

        if (reviewItems != null) {
            for (Map<String, Object> item : reviewItems) {
                prompt.append("\n- Question: ").append(value(item.get("questionText")));
                prompt.append("\n  Correct: ").append(value(item.get("correct")));
                prompt.append("\n  Explanation: ").append(value(item.get("explanation")));
            }
        }

        prompt.append("\n\nReturn the answer in this structure:");
        prompt.append("\n1. Overall feedback");
        prompt.append("\n2. Main weakness");
        prompt.append("\n3. What the student should revise next");
        prompt.append("\n4. Recommended next action");

        String feedback = safeAsk(prompt.toString(), fallbackQuizFeedback(score, total));

        saveFeedback(user.getId(), courseId, "QUIZ_FEEDBACK", feedback);

        return feedback;
    }

    public String generateNextBestAction(int userId) {
        String context = buildStudentContext(userId);

        String prompt =
                "You are an AI study coach. Based on the following student learning context, " +
                "recommend exactly one next best action. " +
                "Use short, practical English. " +
                "Structure the answer as: Action, Reason, Estimated time.\n\n" +
                context;

        String response = safeAsk(
                prompt,
                "Action: Review the flashcards generated from your mistakes.\n" +
                        "Reason: This is usually the fastest way to fix weak topics before taking another quiz.\n" +
                        "Estimated time: 20 minutes."
        );

        saveFeedback(userId, null, "NEXT_BEST_ACTION", response);

        return response;
    }

    public String explainWeakTopic(int userId, int gapId) {
        String gapContext = findGapContext(userId, gapId);

        String prompt =
                "You are an AI tutor. Explain this weak topic to a student. " +
                "Use simple English and give a concrete example. " +
                "Structure the answer as: Why it is difficult, Simple explanation, Example, What to revise next.\n\n" +
                gapContext;

        String response = safeAsk(
                prompt,
                "Why it is difficult: This topic may be difficult because it connects several concepts.\n" +
                        "Simple explanation: Start by revising the basic definition, then compare it with one example.\n" +
                        "Example: Try to apply the concept to a small practical case.\n" +
                        "What to revise next: Review your course notes and redo the related quiz questions."
        );

        saveFeedback(userId, null, "WEAK_TOPIC_EXPLANATION", response);

        return response;
    }

    public String answerCoachQuestion(int userId, String question) {
        String context = buildStudentContext(userId);

        String prompt =
                "You are SmartStudy AI Coach. Answer the student's question using only the available learning context. " +
                "Be practical, academic and supportive. " +
                "If there is not enough data, say what data is missing and give a general recommendation.\n\n" +
                "Student context:\n" + context +
                "\n\nStudent question:\n" + question;

        String response = safeAsk(
                prompt,
                "Based on your current learning activity, I recommend reviewing your latest weak topics, completing your planner tasks, and taking a short quiz afterwards to verify progress."
        );

        saveFeedback(userId, null, "AI_COACH", response);

        return response;
    }

    private String buildStudentContext(int userId) {
        StringBuilder sb = new StringBuilder();

        try (Connection c = DBConnection.getConnection()) {
            sb.append("Student courses:\n");
            appendRows(
                    c,
                    sb,
                    "SELECT title, difficulty, exam_date FROM courses WHERE user_id = ? ORDER BY exam_date ASC LIMIT 5",
                    userId
            );

            sb.append("\nLatest quiz results:\n");
            appendRows(
                    c,
                    sb,
                    "SELECT score, total_questions, created_at FROM quiz_results WHERE user_id = ? ORDER BY id DESC LIMIT 5",
                    userId
            );

            sb.append("\nGap alerts:\n");
            appendRows(
                    c,
                    sb,
                    "SELECT message, severity, created_at FROM gap_alerts WHERE user_id = ? ORDER BY id DESC LIMIT 5",
                    userId
            );

            sb.append("\nStudy plan tasks:\n");
            appendRows(
                    c,
                    sb,
                    "SELECT task_title, completed, estimated_minutes, priority FROM study_plan_items WHERE user_id = ? ORDER BY plan_date ASC LIMIT 8",
                    userId
            );

            sb.append("\nRecent flashcards:\n");
            appendRows(
                    c,
                    sb,
                    "SELECT front_text, generation_source FROM flashcards WHERE user_id = ? ORDER BY id DESC LIMIT 5",
                    userId
            );

        } catch (Exception e) {
            sb.append("Context could not be fully loaded.");
        }

        return sb.toString();
    }

    private String findGapContext(int userId, int gapId) {
        String sql =
                "SELECT ga.id, ga.message, ga.severity, ga.created_at, c.title AS course_title " +
                "FROM gap_alerts ga " +
                "LEFT JOIN courses c ON ga.course_id = c.id " +
                "WHERE ga.id = ? AND ga.user_id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, gapId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return "Course: " + value(rs.getString("course_title")) +
                            "\nGap message: " + value(rs.getString("message")) +
                            "\nSeverity: " + value(rs.getString("severity")) +
                            "\nCreated at: " + value(rs.getString("created_at"));
                }
            }

        } catch (Exception ignored) {
        }

        return "No detailed gap context found. Explain a general weak topic.";
    }

    private void appendRows(Connection c, StringBuilder sb, String sql, int userId) {
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                int count = 0;

                while (rs.next()) {
                    count++;
                    sb.append("- ");

                    int columns = rs.getMetaData().getColumnCount();

                    for (int i = 1; i <= columns; i++) {
                        String columnName = rs.getMetaData().getColumnLabel(i);
                        Object value = rs.getObject(i);

                        sb.append(columnName)
                                .append(": ")
                                .append(value == null ? "-" : value)
                                .append("; ");
                    }

                    sb.append("\n");
                }

                if (count == 0) {
                    sb.append("- No data found.\n");
                }
            }

        } catch (Exception e) {
            sb.append("- Data unavailable for this section.\n");
        }
    }

    private String safeAsk(String prompt, String fallback) {
        try {
            String answer = aiStudyService.askPlainText(prompt);

            if (answer == null || answer.trim().isEmpty()) {
                return fallback;
            }

            return answer.trim();

        } catch (Exception e) {
            return fallback;
        }
    }

    private void saveFeedback(int userId, Integer courseId, String type, String text) {
        try {
            aiFeedbackDAO.create(new AiFeedback(userId, courseId, type, text));
        } catch (Exception ignored) {
        }
    }

    private String fallbackQuizFeedback(int score, int total) {
        if (total <= 0) {
            return "No quiz data was available. Start with a short quiz after reviewing your materials.";
        }

        double percent = score * 100.0 / total;

        if (percent >= 80) {
            return "Overall feedback: Very good result. You understand most concepts.\n" +
                    "Main weakness: Focus only on the questions you missed.\n" +
                    "What to revise next: Review explanations for incorrect answers.\n" +
                    "Recommended next action: Try a harder quiz or an exam simulation.";
        }

        if (percent >= 50) {
            return "Overall feedback: You have a partial understanding of the topic.\n" +
                    "Main weakness: Some concepts are still unstable.\n" +
                    "What to revise next: Review the incorrect answers and generate flashcards from mistakes.\n" +
                    "Recommended next action: Study for 20 minutes, then retake a short quiz.";
        }

        return "Overall feedback: The result shows that you need more revision before moving forward.\n" +
                "Main weakness: Several core concepts are not yet clear.\n" +
                "What to revise next: Start with the explanations of your incorrect answers.\n" +
                "Recommended next action: Review weak-topic flashcards before taking another quiz.";
    }

    private String value(Object obj) {
        return obj == null ? "-" : String.valueOf(obj);
    }
}
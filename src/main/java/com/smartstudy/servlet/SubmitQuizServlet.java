package com.smartstudy.servlet;

import com.smartstudy.dao.DashboardDAO;
import com.smartstudy.dao.QuestionDAO;
import com.smartstudy.dao.QuizMistakeDAO;
import com.smartstudy.dao.QuizResultDAO;
import com.smartstudy.model.Question;
import com.smartstudy.model.QuizResult;
import com.smartstudy.model.User;
import com.smartstudy.service.AdaptiveFlashcardService;
import com.smartstudy.service.StudentAiInsightService;
import com.smartstudy.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SubmitQuizServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");

            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String courseIdParam = req.getParameter("courseId");

            if (courseIdParam == null || courseIdParam.isBlank()) {
                throw new ServletException("Missing courseId parameter.");
            }

            int courseId = Integer.parseInt(courseIdParam);

            String[] ids = req.getParameterValues("questionId");

            int score = 0;
            int total = ids == null ? 0 : ids.length;
            int mistakesSaved = 0;
            int adaptiveFlashcards = 0;

            QuestionDAO questionDAO = new QuestionDAO();
            QuizMistakeDAO quizMistakeDAO = new QuizMistakeDAO();

            List<Map<String, Object>> reviewItems = new ArrayList<>();

            if (ids != null) {
                for (String id : ids) {
                    int questionId = Integer.parseInt(id);

                    Question q = questionDAO.findById(questionId);

                    if (q == null) {
                        continue;
                    }

                    String selectedAnswer = req.getParameter("answer_" + questionId);

                    if (selectedAnswer == null) {
                        selectedAnswer = "";
                    }

                    selectedAnswer = selectedAnswer.trim().toUpperCase();

                    String correctAnswer = "";

                    if (q.getCorrectAnswer() != null) {
                        correctAnswer = q.getCorrectAnswer().trim().toUpperCase();
                    }

                    boolean correct = !selectedAnswer.isBlank() && selectedAnswer.equals(correctAnswer);

                    if (correct) {
                        score++;
                    } else {
                        String correctAnswerText = getCorrectAnswerText(q);

                        quizMistakeDAO.create(
                                user.getId(),
                                courseId,
                                null,
                                q.getId(),
                                q.getQuestionText(),
                                selectedAnswer,
                                correctAnswer,
                                correctAnswerText,
                                q.getExplanation()
                        );

                        mistakesSaved++;
                    }

                    Map<String, Object> item = new HashMap<>();

                    item.put("questionText", q.getQuestionText());
                    item.put("selectedAnswer", selectedAnswer.isBlank() ? "-" : selectedAnswer);
                    item.put("correctAnswer", correctAnswer);
                    item.put("correctAnswerText", getCorrectAnswerText(q));
                    item.put("correct", correct);
                    item.put("explanation", q.getExplanation());

                    reviewItems.add(item);
                }
            }

            QuizResult result = new QuizResult();

            result.setUserId(user.getId());
            result.setCourseId(courseId);
            result.setScore(score);
            result.setTotalQuestions(total);
            result.setDurationSeconds(0);

            new QuizResultDAO().create(result);

            if (total > 0) {
                int minutesSpent = Math.max(5, total * 2);
                new DashboardDAO().addStudySession(user.getId(), courseId, minutesSpent);
            }

            if (total > 0 && (score * 100.0 / total) < 60) {
                createGap(
                        user.getId(),
                        courseId,
                        "Low quiz result detected. Review the incorrect answers and weak-topic flashcards."
                );
            }

            if (mistakesSaved > 0) {
                try {
                    adaptiveFlashcards = new AdaptiveFlashcardService()
                            .generateFromRecentMistakes(user.getId());
                } catch (Exception adaptiveError) {
                    adaptiveError.printStackTrace();
                    adaptiveFlashcards = 0;
                }
            }

            String aiFeedback = new StudentAiInsightService()
                    .generateQuizFeedback(user, courseId, score, total, reviewItems);

            req.setAttribute("score", score);
            req.setAttribute("total", total);
            req.setAttribute("reviewItems", reviewItems);
            req.setAttribute("mistakesSaved", mistakesSaved);
            req.setAttribute("adaptiveFlashcards", adaptiveFlashcards);
            req.setAttribute("aiFeedback", aiFeedback);

            req.getRequestDispatcher("/WEB-INF/views/student/quizResult.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String getCorrectAnswerText(Question question) {
        if (question == null || question.getCorrectAnswer() == null) {
            return "";
        }

        String correct = question.getCorrectAnswer().trim().toUpperCase();

        switch (correct) {
            case "A":
                return question.getOptionA() == null ? "" : question.getOptionA();

            case "B":
                return question.getOptionB() == null ? "" : question.getOptionB();

            case "C":
                return question.getOptionC() == null ? "" : question.getOptionC();

            case "D":
                return question.getOptionD() == null ? "" : question.getOptionD();

            default:
                return "";
        }
    }

    private void createGap(int userId, int courseId, String message) throws SQLException {
        String sql =
                "INSERT INTO gap_alerts(user_id, course_id, message, severity) " +
                "VALUES (?, ?, ?, 'HIGH')";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            ps.setString(3, message);

            ps.executeUpdate();
        }
    }
}
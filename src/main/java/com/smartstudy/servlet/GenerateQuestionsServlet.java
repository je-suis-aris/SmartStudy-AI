package com.smartstudy.servlet;

import com.smartstudy.dao.DashboardDAO;
import com.smartstudy.dao.FlashcardDAO;
import com.smartstudy.dao.MaterialDAO;
import com.smartstudy.dao.QuestionDAO;
import com.smartstudy.model.Material;
import com.smartstudy.model.Question;
import com.smartstudy.model.User;
import com.smartstudy.service.AiStudyService;
import com.smartstudy.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class GenerateQuestionsServlet extends HttpServlet {

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

            int materialId = Integer.parseInt(req.getParameter("materialId"));
            String action = req.getParameter("action");

            if (action == null || action.trim().isEmpty()) {
                action = "questions";
            }

            Material material = new MaterialDAO().findById(materialId);

            if (material == null) {
                throw new ServletException("Material not found.");
            }

            if (material.getContentText() == null || material.getContentText().trim().isEmpty()) {
                throw new ServletException("This material has no extracted text. AI generation cannot continue.");
            }

            AiStudyService ai = new AiStudyService();

            if ("questions".equalsIgnoreCase(action)) {
                generateQuestions(user, material, ai);
                resp.sendRedirect(req.getContextPath() + "/assessment?generated=1");
                return;
            }

            if ("summary".equalsIgnoreCase(action)) {
                generateSummary(material, ai);
                resp.sendRedirect(req.getContextPath() + "/materials?summary=1");
                return;
            }

            if ("flashcards".equalsIgnoreCase(action)) {
                generateFlashcards(user, material, ai);
                resp.sendRedirect(req.getContextPath() + "/flashcards?generated=1");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/materials");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void generateQuestions(User user, Material material, AiStudyService ai) throws Exception {
        QuestionDAO questionDAO = new QuestionDAO();

        List<Question> generatedQuestions = ai.generateQuestions(material, 5);

        for (Question q : generatedQuestions) {
            questionDAO.create(q);
        }

        if (!generatedQuestions.isEmpty()) {
            new DashboardDAO().addStudySession(user.getId(), material.getCourseId(), 5);
        }
    }

    private void generateSummary(Material material, AiStudyService ai) throws Exception {
        String summary = ai.generateSummary(material.getContentText());

        String sql =
                "UPDATE materials " +
                "SET summary = ?, ai_status = 'PROCESSED' " +
                "WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, summary);
            ps.setInt(2, material.getId());

            ps.executeUpdate();
        }
    }

    private void generateFlashcards(User user, Material material, AiStudyService ai) throws Exception {
        List<String[]> cards = ai.generateFlashcards(material.getContentText());

        FlashcardDAO flashcardDAO = new FlashcardDAO();

        String generationBatch =
                "AI-" +
                LocalDateTime.now()
                        .format(DateTimeFormatter.ofPattern("yyyyMMdd-HHmmss"));

        int insertedCards = 0;

        for (String[] card : cards) {
            if (card == null || card.length < 2) {
                continue;
            }

            String front = card[0];
            String back = card[1];

            if (front == null || front.trim().isEmpty()) {
                continue;
            }

            if (back == null || back.trim().isEmpty()) {
                continue;
            }

            boolean inserted = flashcardDAO.create(
                    user.getId(),
                    material.getCourseId(),
                    material.getId(),
                    front.trim(),
                    back.trim(),
                    "AI",
                    generationBatch
            );

            if (inserted) {
                insertedCards++;
            }
        }

        if (insertedCards > 0) {
            new DashboardDAO().addStudySession(user.getId(), material.getCourseId(), 5);
        }
    }
}
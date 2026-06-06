package com.smartstudy.servlet;

import com.smartstudy.dao.DashboardDAO;
import com.smartstudy.dao.FlashcardDAO;
import com.smartstudy.dao.QuizMistakeDAO;
import com.smartstudy.model.QuizMistake;
import com.smartstudy.model.User;
import com.smartstudy.service.AiStudyService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class GenerateWeakFlashcardsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            QuizMistakeDAO mistakeDAO = new QuizMistakeDAO();
            List<QuizMistake> mistakes = mistakeDAO.findRecentUnresolvedByUser(user.getId(), 10);

            if (mistakes.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/flashcards?weak=none");
                return;
            }

            AiStudyService ai = new AiStudyService();
            List<String[]> cards = ai.generateFlashcardsFromMistakes(mistakes);

            String batch =
                    "WEAK-" +
                    LocalDateTime.now()
                            .format(DateTimeFormatter.ofPattern("yyyyMMdd-HHmmss"));

            FlashcardDAO flashcardDAO = new FlashcardDAO();

            int inserted = 0;
            int courseId = mistakes.get(0).getCourseId();

            Integer materialIdObj = mistakes.get(0).getMaterialId();
            int materialId = materialIdObj == null ? 0 : materialIdObj;

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

                boolean ok = flashcardDAO.create(
                        user.getId(),
                        courseId,
                        materialId,
                        front.trim(),
                        back.trim(),
                        "WEAKNESS_AI",
                        batch
                );

                if (ok) {
                    inserted++;
                }
            }

            if (inserted > 0) {
                new DashboardDAO().addStudySession(user.getId(), courseId, 5);
                mistakeDAO.markAsResolvedForUser(user.getId());
            }

            resp.sendRedirect(req.getContextPath() + "/flashcards?weak=generated");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
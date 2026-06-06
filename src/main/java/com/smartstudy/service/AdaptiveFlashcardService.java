package com.smartstudy.service;

import com.smartstudy.dao.DashboardDAO;
import com.smartstudy.dao.FlashcardDAO;
import com.smartstudy.dao.QuizMistakeDAO;
import com.smartstudy.model.QuizMistake;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class AdaptiveFlashcardService {

    public int generateFromRecentMistakes(int userId) throws Exception {
        QuizMistakeDAO mistakeDAO = new QuizMistakeDAO();

        List<QuizMistake> mistakes = mistakeDAO.findRecentUnresolvedByUser(userId, 10);

        if (mistakes == null || mistakes.isEmpty()) {
            return 0;
        }

        AiStudyService ai = new AiStudyService();
        List<String[]> cards = ai.generateFlashcardsFromMistakes(mistakes);

        if (cards == null || cards.isEmpty()) {
            return 0;
        }

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
                    userId,
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
            new DashboardDAO().addStudySession(userId, courseId, 5);
            mistakeDAO.markAsResolvedForUser(userId);
        }

        return inserted;
    }
}
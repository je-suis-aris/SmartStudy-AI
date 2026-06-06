package com.smartstudy.servlet;

import com.smartstudy.model.User;
import com.smartstudy.service.AiStudyService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GenerateInsightsAiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AiStudyService aiStudyService = new AiStudyService();

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

            String knowledgeMapText = req.getParameter("knowledgeMapText");

            if (knowledgeMapText == null || knowledgeMapText.trim().isEmpty()) {
                req.getSession().setAttribute("aiInsightsText",
                        "AI analysis could not be generated because there is no knowledge map data yet.");
                req.getSession().removeAttribute("aiRecommendationCards");

                resp.sendRedirect(req.getContextPath() + "/insights?ai=empty");
                return;
            }

            String globalPrompt =
                    "You are SmartStudy AI, an academic learning assistant. " +
                    "Analyze the student's knowledge map and generate a useful personalized learning insight. " +
                    "Write the answer in English. Use this exact structure:\n\n" +
                    "1. Overall diagnosis\n" +
                    "2. Weakest topics and why they matter\n" +
                    "3. Priority study plan for the next 3 study sessions\n" +
                    "4. Recommended use of flashcards, quizzes and materials\n" +
                    "5. Motivational final advice\n\n" +
                    "Student knowledge map:\n" +
                    knowledgeMapText;

            String cardsPrompt =
                    "You are SmartStudy AI. Based on the student's knowledge map, generate one personalized recommendation card for EACH topic. " +
                    "Return ONLY lines in this exact format, no introduction, no markdown:\n" +
                    "CARD|topic name|priority level|short personalized recommendation\n\n" +
                    "Priority level must be one of: HIGH, MEDIUM, LOW.\n" +
                    "The recommendation must be specific, not generic, and must mention what the student should do next.\n\n" +
                    "Example:\n" +
                    "CARD|Java Servlets|HIGH|Review the request-response lifecycle, then generate 5 flashcards and retake a short quiz focused on servlet methods.\n\n" +
                    "Student knowledge map:\n" +
                    knowledgeMapText;

            String aiGlobalResponse = aiStudyService.askPlainText(globalPrompt);
            String aiCardsResponse = aiStudyService.askPlainText(cardsPrompt);

            if (aiGlobalResponse == null || aiGlobalResponse.trim().isEmpty()) {
                aiGlobalResponse = "AI analysis is currently unavailable. Please try again later.";
            }

            List<Map<String, String>> cards = parseAiCards(aiCardsResponse);

            req.getSession().setAttribute("aiInsightsText", aiGlobalResponse.trim());
            req.getSession().setAttribute("aiRecommendationCards", cards);

            resp.sendRedirect(req.getContextPath() + "/insights?ai=generated");

        } catch (Exception e) {
            e.printStackTrace();

            req.getSession().setAttribute(
                    "aiInsightsText",
                    "AI analysis failed: " + e.getMessage()
            );
            req.getSession().removeAttribute("aiRecommendationCards");

            resp.sendRedirect(req.getContextPath() + "/insights?ai=error");
        }
    }

    private List<Map<String, String>> parseAiCards(String response) {
        List<Map<String, String>> cards = new ArrayList<>();

        if (response == null || response.trim().isEmpty()) {
            return cards;
        }

        String[] lines = response.split("\\r?\\n");

        for (String line : lines) {
            if (line == null) {
                continue;
            }

            line = line.trim();

            if (!line.startsWith("CARD|")) {
                continue;
            }

            String[] parts = line.split("\\|", 4);

            if (parts.length < 4) {
                continue;
            }

            Map<String, String> card = new HashMap<>();
            card.put("topic", parts[1].trim());
            card.put("priority", parts[2].trim().toUpperCase());
            card.put("text", parts[3].trim());

            cards.add(card);
        }

        return cards;
    }
}
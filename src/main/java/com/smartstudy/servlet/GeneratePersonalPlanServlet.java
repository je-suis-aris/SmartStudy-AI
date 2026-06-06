package com.smartstudy.servlet;

import com.smartstudy.model.User;
import com.smartstudy.service.AiStudyService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class GeneratePersonalPlanServlet extends HttpServlet {

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

            String nextBestAction = (String) req.getSession().getAttribute("nextBestAction");

            String prompt =
                    "You are SmartStudy AI, an academic personal learning assistant for students.\n\n" +
                    "Generate a personalized learning plan for the following student.\n\n" +
                    "Student name: " + safe(user.getFullName()) + "\n" +
                    "Student description: " + safe(user.getDescription()) + "\n" +
                    "Preferred study rhythm: " + safe(user.getPreferredStudyRhythm()) + "\n" +
                    "Learning style: " + safe(user.getLearningStyle()) + "\n\n" +
                    "Existing AI next best action:\n" +
                    safe(nextBestAction) + "\n\n" +
                    "Use this exact structure:\n" +
                    "1. Main objective for the next 7 days\n" +
                    "2. Daily study routine\n" +
                    "3. Priority topics to revise first\n" +
                    "4. How to use flashcards effectively\n" +
                    "5. How to use quizzes effectively\n" +
                    "6. Recommended rhythm until the next exam\n" +
                    "7. Final motivational advice\n\n" +
                    "Keep the answer concise, useful and academic.";

            AiStudyService ai = new AiStudyService();
            String result = ai.askPlainText(prompt);

            if (result == null || result.trim().isEmpty()) {
                result = "AI could not generate a personal learning plan right now. Please try again later.";
            }

            req.getSession().setAttribute("aiPersonalPlan", result.trim());

            resp.sendRedirect(req.getContextPath() + "/dashboard");

        } catch (Exception e) {
            e.printStackTrace();

            req.getSession().setAttribute(
                    "aiPersonalPlan",
                    "AI personal learning plan could not be generated. Please check the AI configuration."
            );

            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }

    private String safe(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "Not specified";
        }

        return value.trim();
    }
}
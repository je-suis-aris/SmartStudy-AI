package com.smartstudy.servlet;

import com.smartstudy.model.User;
import com.smartstudy.service.StudentAiInsightService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class AiCoachServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final StudentAiInsightService insightService = new StudentAiInsightService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/student/ai-coach.jsp")
                .forward(req, resp);
    }

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

            String question = req.getParameter("question");

            if (question == null || question.trim().isEmpty()) {
                req.setAttribute("error", "Please write a question for the AI coach.");
                req.getRequestDispatcher("/WEB-INF/views/student/ai-coach.jsp")
                        .forward(req, resp);
                return;
            }

            String answer = insightService.answerCoachQuestion(user.getId(), question.trim());

            req.setAttribute("question", question);
            req.setAttribute("answer", answer);

            req.getRequestDispatcher("/WEB-INF/views/student/ai-coach.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
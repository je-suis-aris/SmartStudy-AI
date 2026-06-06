package com.smartstudy.servlet;

import com.smartstudy.model.User;
import com.smartstudy.service.StudentAiInsightService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class NextBestActionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final StudentAiInsightService insightService = new StudentAiInsightService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String action = insightService.generateNextBestAction(user.getId());

            req.getSession().setAttribute("nextBestAction", action);

            resp.sendRedirect(req.getContextPath() + "/dashboard?nextAction=generated");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
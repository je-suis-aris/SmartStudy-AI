package com.smartstudy.servlet;

import com.smartstudy.model.User;
import com.smartstudy.service.StudentAiInsightService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class ExplainWeakTopicServlet extends HttpServlet {

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

            String gapIdParam = req.getParameter("gapId");

            if (gapIdParam == null || gapIdParam.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/insights?missingGap=1");
                return;
            }

            int gapId = Integer.parseInt(gapIdParam);

            String explanation = insightService.explainWeakTopic(user.getId(), gapId);

            req.getSession().setAttribute("weakTopicExplanation", explanation);

            resp.sendRedirect(req.getContextPath() + "/insights?aiExplanation=1");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
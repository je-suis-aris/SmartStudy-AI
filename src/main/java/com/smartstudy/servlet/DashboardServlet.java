package com.smartstudy.servlet;

import com.smartstudy.dao.CourseDAO;
import com.smartstudy.dao.DashboardDAO;
import com.smartstudy.dao.QuizResultDAO;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = (User) request.getSession().getAttribute("user");

            DashboardDAO dashboardDAO = new DashboardDAO();

            request.setAttribute("stats", dashboardDAO.stats(user.getId()));
            request.setAttribute("alerts", dashboardDAO.alerts(user.getId()));
            request.setAttribute("todayPlan", dashboardDAO.todayPlan(user.getId()));
            request.setAttribute("courses", new CourseDAO().findByUser(user.getId()));
            request.setAttribute("results", new QuizResultDAO().findByUser(user.getId()));

            request.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception exception) {
            throw new ServletException(exception);
        }
    }
}
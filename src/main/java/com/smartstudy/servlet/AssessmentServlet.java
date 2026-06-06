package com.smartstudy.servlet;

import com.smartstudy.dao.CourseDAO;
import com.smartstudy.dao.MaterialDAO;
import com.smartstudy.dao.QuestionDAO;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class AssessmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = (User) request.getSession().getAttribute("user");

            request.setAttribute("courses", new CourseDAO().findByUser(user.getId()));
            request.setAttribute("materials", new MaterialDAO().findByUser(user.getId()));
            request.setAttribute("questions", new QuestionDAO().findAll());

            request.getRequestDispatcher("/WEB-INF/views/student/assessment.jsp")
                    .forward(request, response);

        } catch (Exception exception) {
            throw new ServletException(exception);
        }
    }
}
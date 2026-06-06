package com.smartstudy.servlet;

import com.smartstudy.dao.QuestionDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class TakeQuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            request.setAttribute("courseId", courseId);
            request.setAttribute("questions", new QuestionDAO().findByCourse(courseId, 10));

            request.getRequestDispatcher("/WEB-INF/views/student/quiz.jsp")
                    .forward(request, response);

        } catch (Exception exception) {
            throw new ServletException(exception);
        }
    }
}
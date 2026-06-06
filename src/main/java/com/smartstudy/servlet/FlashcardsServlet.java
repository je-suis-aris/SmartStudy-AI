package com.smartstudy.servlet;

import com.smartstudy.dao.FlashcardDAO;
import com.smartstudy.model.Flashcard;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class FlashcardsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            List<Flashcard> flashcards = new FlashcardDAO().findByUser(user.getId());

            req.setAttribute("flashcards", flashcards);

            req.getRequestDispatcher("/WEB-INF/views/student/flashcards.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
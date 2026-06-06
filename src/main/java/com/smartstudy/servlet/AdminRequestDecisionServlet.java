package com.smartstudy.servlet;

import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class AdminRequestDecisionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User currentUser = (User) req.getSession().getAttribute("user");

            if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
                return;
            }

            int userId = Integer.parseInt(req.getParameter("userId"));
            String decision = req.getParameter("decision");

            UserDAO userDAO = new UserDAO();

            if ("approve".equalsIgnoreCase(decision)) {
                userDAO.approveAdminRequest(userId);
            } else if ("reject".equalsIgnoreCase(decision)) {
                userDAO.rejectAdminRequest(userId);
            } else {
                throw new ServletException("Invalid decision.");
            }

            resp.sendRedirect(req.getContextPath() + "/admin/users");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
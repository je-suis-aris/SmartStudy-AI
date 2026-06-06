package com.smartstudy.servlet;

import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class AdminUsersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User currentUser = (User) req.getSession().getAttribute("user");

            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
                return;
            }

            UserDAO userDAO = new UserDAO();

            List<User> users = userDAO.findAll();
            List<User> pendingAdminRequests = userDAO.findPendingAdminRequests();

            req.setAttribute("users", users);
            req.setAttribute("pendingAdminRequests", pendingAdminRequests);
            req.setAttribute("currentAdmin", currentUser);

            req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User currentUser = (User) req.getSession().getAttribute("user");

            if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
                return;
            }

            int userId = Integer.parseInt(req.getParameter("id"));

            if (userId == currentUser.getId()) {
                throw new ServletException("You cannot delete your own administrator account.");
            }

            if (userId == 1) {
                throw new ServletException("The main administrator account cannot be deleted.");
            }

            new UserDAO().delete(userId);

            resp.sendRedirect(req.getContextPath() + "/admin/users");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
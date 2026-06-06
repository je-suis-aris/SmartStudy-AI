package com.smartstudy.servlet;

import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/register.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");

            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            String bio = req.getParameter("bio");

            String requestAdmin = req.getParameter("requestAdmin");
            String adminReason = req.getParameter("adminReason");

            if (firstName == null || firstName.trim().isEmpty()
                    || lastName == null || lastName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || confirmPassword == null || confirmPassword.trim().isEmpty()) {

                req.setAttribute("error", "Please complete all required fields.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp")
                        .forward(req, resp);
                return;
            }

            firstName = firstName.trim();
            lastName = lastName.trim();
            email = email.trim();
            password = password.trim();
            confirmPassword = confirmPassword.trim();

            if (password.length() < 8) {
                req.setAttribute("error", "Password must contain at least 8 characters.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp")
                        .forward(req, resp);
                return;
            }

            if (!password.equals(confirmPassword)) {
                req.setAttribute("error", "Passwords do not match.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp")
                        .forward(req, resp);
                return;
            }

            boolean wantsAdmin = "yes".equalsIgnoreCase(requestAdmin);

            if (wantsAdmin) {
                if (adminReason == null || adminReason.trim().length() < 5) {
                    req.setAttribute("error", "Please explain why you need administrator access.");
                    req.getRequestDispatcher("/WEB-INF/views/register.jsp")
                            .forward(req, resp);
                    return;
                }
            }

            UserDAO userDAO = new UserDAO();

            if (userDAO.emailExists(email)) {
                req.setAttribute("error", "An account with this email already exists.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp")
                        .forward(req, resp);
                return;
            }

            String fullName = firstName + " " + lastName;

            User user = new User();

            user.setFullName(fullName);
            user.setEmail(email);
            user.setPasswordHash(password);
            user.setRole("STUDENT");
            user.setDescription(bio == null ? "" : bio.trim());
            user.setProfilePhoto(null);
            user.setPreferredStudyRhythm("Balanced revision");
            user.setLearningStyle("Mixed learning");

            if (wantsAdmin) {
                user.setAdminRequestStatus("PENDING");
                user.setAdminRequestReason(adminReason.trim());
            } else {
                user.setAdminRequestStatus("NONE");
                user.setAdminRequestReason(null);
            }

            boolean created = userDAO.create(user);

            if (!created) {
                req.setAttribute("error", "Account could not be created. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp")
                        .forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/login?registered=1");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
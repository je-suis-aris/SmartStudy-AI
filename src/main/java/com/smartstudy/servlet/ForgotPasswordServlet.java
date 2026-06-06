package com.smartstudy.servlet;

import com.smartstudy.dao.UserDAO;
import com.smartstudy.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.SecureRandom;

public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String PASSWORD_CHARS =
            "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789@#$%";

    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");

            String email = req.getParameter("email");

            if (email == null || email.trim().isEmpty()) {
                req.setAttribute("error", "Please enter your email address.");
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                        .forward(req, resp);
                return;
            }

            email = email.trim();

            UserDAO userDAO = new UserDAO();

            /*
             * We use a generic message if the email does not exist,
             * so nobody can check which accounts are registered.
             */
            if (!userDAO.emailExists(email)) {
                req.setAttribute("message", "If this email exists, a new password has been sent.");
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                        .forward(req, resp);
                return;
            }

            String newPassword = generateNewPassword(12);

            boolean updated = userDAO.updatePasswordByEmail(email, newPassword);

            if (!updated) {
                req.setAttribute("error", "The password could not be reset. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                        .forward(req, resp);
                return;
            }

            String subject = "SmartStudy AI - Your new password";

            String body =
                    "Hello,\n\n" +
                    "We received a password recovery request for your SmartStudy AI account.\n\n" +
                    "Your password has been changed successfully.\n\n" +
                    "Your new password is:\n\n" +
                    newPassword + "\n\n" +
                    "You can now sign in using this new password.\n" +
                    "This password replaces your old password and will remain active until you change it again.\n\n" +
                    "If you did not request this password reset, please contact the platform administrator immediately.\n\n" +
                    "SmartStudy AI";

            EmailUtil.sendEmail(email, subject, body);

            req.setAttribute("message", "A new password has been generated and sent to your email address.");

            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();

            req.setAttribute("error", "The recovery email could not be sent. Please check the SMTP configuration.");
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                    .forward(req, resp);
        }
    }

    private String generateNewPassword(int length) {
        StringBuilder password = new StringBuilder();

        for (int i = 0; i < length; i++) {
            int index = RANDOM.nextInt(PASSWORD_CHARS.length());
            password.append(PASSWORD_CHARS.charAt(index));
        }

        return password.toString();
    }
}
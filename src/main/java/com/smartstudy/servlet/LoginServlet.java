package com.smartstudy.servlet;

import com.smartstudy.dao.RememberTokenDAO;
import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.User;
import com.smartstudy.util.RememberMeUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/login.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");

            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String rememberMe = req.getParameter("rememberMe");

            User user = new UserDAO().login(email, password);

            if (user == null) {
                req.setAttribute("error", "Email or password is incorrect.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp")
                        .forward(req, resp);
                return;
            }

            req.getSession(true).setAttribute("user", user);

            if ("yes".equalsIgnoreCase(rememberMe)) {
                RememberTokenDAO rememberTokenDAO = new RememberTokenDAO();

                rememberTokenDAO.deleteByUserId(user.getId());
                rememberTokenDAO.deleteExpiredTokens();

                String selector = RememberMeUtil.generateSecureToken();
                String token = RememberMeUtil.generateSecureToken();
                String tokenHash = RememberMeUtil.hashToken(token);

                rememberTokenDAO.createToken(
                        user.getId(),
                        selector,
                        tokenHash,
                        RememberMeUtil.DAYS_VALID
                );

                RememberMeUtil.addRememberCookie(
                        resp,
                        selector,
                        token,
                        req.getContextPath()
                );
            }

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
package com.smartstudy.servlet;

import com.smartstudy.dao.RememberTokenDAO;
import com.smartstudy.util.RememberMeUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Cookie cookie = RememberMeUtil.findRememberCookie(req);

            if (cookie != null) {
                String[] parts = RememberMeUtil.parseCookieValue(cookie.getValue());

                if (parts != null) {
                    String selector = parts[0];
                    new RememberTokenDAO().deleteBySelector(selector);
                }
            }

            RememberMeUtil.clearRememberCookie(resp, req.getContextPath());

            HttpSession session = req.getSession(false);

            if (session != null) {
                session.invalidate();
            }

            resp.sendRedirect(req.getContextPath() + "/login?logout=1");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
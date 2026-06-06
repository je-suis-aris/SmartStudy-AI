package com.smartstudy.filter;

import com.smartstudy.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();

        boolean staticResource =
                uri.startsWith(contextPath + "/assets/") ||
                uri.startsWith(contextPath + "/css/") ||
                uri.startsWith(contextPath + "/js/") ||
                uri.startsWith(contextPath + "/images/") ||
                uri.endsWith(".css") ||
                uri.endsWith(".js") ||
                uri.endsWith(".png") ||
                uri.endsWith(".jpg") ||
                uri.endsWith(".jpeg") ||
                uri.endsWith(".svg") ||
                uri.endsWith(".gif") ||
                uri.endsWith(".ico") ||
                uri.endsWith(".webp");

        boolean publicPage =
                uri.equals(contextPath + "/") ||
                uri.equals(contextPath + "/home") ||
                uri.equals(contextPath + "/login") ||
                uri.equals(contextPath + "/register") ||
                uri.equals(contextPath + "/forgot-password") ||
                uri.equals(contextPath + "/logout");

        if (staticResource || publicPage) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);

        User user = null;

        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        String role = user.getRole();

        if (role == null || role.trim().isEmpty()) {
            role = "STUDENT";
        }

        boolean adminArea = uri.startsWith(contextPath + "/admin");

        if (adminArea && !"ADMIN".equalsIgnoreCase(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Administrator role required.");
            return;
        }

        boolean studentArea =
                uri.equals(contextPath + "/dashboard") ||
                uri.equals(contextPath + "/materials") ||
                uri.equals(contextPath + "/planner") ||
                uri.equals(contextPath + "/assessment") ||
                uri.equals(contextPath + "/flashcards") ||
                uri.equals(contextPath + "/insights") ||
                uri.equals(contextPath + "/stats") ||
                uri.equals(contextPath + "/profile") ||
                uri.equals(contextPath + "/chat") ||
                uri.equals(contextPath + "/ai-coach") ||
                uri.equals(contextPath + "/take-quiz") ||
                uri.equals(contextPath + "/submit-quiz") ||
                uri.equals(contextPath + "/generate-questions") ||
                uri.equals(contextPath + "/generate-weak-flashcards") ||
                uri.equals(contextPath + "/generate-next-action") ||
                uri.equals(contextPath + "/generate-personal-plan") ||
                uri.equals(contextPath + "/explain-weak-topic") ||
                uri.equals(contextPath + "/ai-tutor");

        if (studentArea && "ADMIN".equalsIgnoreCase(role)) {
            chain.doFilter(request, response);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
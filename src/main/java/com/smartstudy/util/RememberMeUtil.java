package com.smartstudy.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class RememberMeUtil {

    public static final String COOKIE_NAME = "SMARTSTUDY_REMEMBER";
    public static final int DAYS_VALID = 14;
    public static final int COOKIE_MAX_AGE = DAYS_VALID * 24 * 60 * 60;

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    public static String generateSecureToken() {
        byte[] bytes = new byte[32];
        SECURE_RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    public static String hashToken(String token) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");

        byte[] hash = digest.digest(token.getBytes(StandardCharsets.UTF_8));

        return Base64.getUrlEncoder().withoutPadding().encodeToString(hash);
    }

    public static String buildCookieValue(String selector, String token) {
        return selector + ":" + token;
    }

    public static String[] parseCookieValue(String value) {
        if (value == null || !value.contains(":")) {
            return null;
        }

        String[] parts = value.split(":", 2);

        if (parts.length != 2 || parts[0].isBlank() || parts[1].isBlank()) {
            return null;
        }

        return parts;
    }

    public static Cookie findRememberCookie(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();

        if (cookies == null) {
            return null;
        }

        for (Cookie cookie : cookies) {
            if (COOKIE_NAME.equals(cookie.getName())) {
                return cookie;
            }
        }

        return null;
    }

    public static void addRememberCookie(HttpServletResponse resp, String selector, String token, String contextPath) {
        Cookie cookie = new Cookie(COOKIE_NAME, buildCookieValue(selector, token));

        cookie.setHttpOnly(true);
        cookie.setSecure(false);
        cookie.setPath(contextPath == null || contextPath.isBlank() ? "/" : contextPath);
        cookie.setMaxAge(COOKIE_MAX_AGE);

        resp.addCookie(cookie);
    }

    public static void clearRememberCookie(HttpServletResponse resp, String contextPath) {
        Cookie cookie = new Cookie(COOKIE_NAME, "");

        cookie.setHttpOnly(true);
        cookie.setSecure(false);
        cookie.setPath(contextPath == null || contextPath.isBlank() ? "/" : contextPath);
        cookie.setMaxAge(0);

        resp.addCookie(cookie);
    }
}
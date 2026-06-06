package com.smartstudy.servlet;

import com.smartstudy.dao.MaterialDAO;
import com.smartstudy.model.Material;
import com.smartstudy.model.User;
import com.smartstudy.service.AiTutorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class AiTutorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AiTutorService aiTutorService = new AiTutorService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");
            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json; charset=UTF-8");

            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.getWriter().write("{\"answer\":\"You must be logged in.\"}");
                return;
            }

            String question = req.getParameter("question");

            if (question == null || question.trim().isEmpty()) {
                resp.getWriter().write("{\"answer\":\"Please write a question first.\"}");
                return;
            }

            List<Material> materials = new MaterialDAO().findByUser(user.getId());

            StringBuilder context = new StringBuilder();

            if (materials != null && !materials.isEmpty()) {
                int materialCount = 0;

                for (Material material : materials) {
                    if (material == null) {
                        continue;
                    }

                    materialCount++;

                    context.append("MATERIAL ")
                            .append(materialCount)
                            .append("\n");

                    if (material.getTitle() != null && !material.getTitle().trim().isEmpty()) {
                        context.append("Title: ")
                                .append(material.getTitle())
                                .append("\n");
                    }

                    if (material.getMaterialType() != null && !material.getMaterialType().trim().isEmpty()) {
                        context.append("Type: ")
                                .append(material.getMaterialType())
                                .append("\n");
                    }

                    if (material.getSummary() != null && !material.getSummary().trim().isEmpty()) {
                        context.append("Summary: ")
                                .append(limitText(material.getSummary(), 1200))
                                .append("\n");
                    }

                    if (material.getContentText() != null && !material.getContentText().trim().isEmpty()) {
                        context.append("Content excerpt: ")
                                .append(limitText(material.getContentText(), 2500))
                                .append("\n");
                    }

                    context.append("\n---\n\n");

                    if (materialCount >= 5) {
                        break;
                    }
                }
            } else {
                context.append("No uploaded materials found for this user.");
            }

            String answer = aiTutorService.ask(question, context.toString());

            resp.getWriter().write("{\"answer\":\"" + escapeJson(answer) + "\"}");

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            String errorMessage = "AI tutor error: " + e.getMessage();

            resp.getWriter().write("{\"answer\":\"" + escapeJson(errorMessage) + "\"}");
        }
    }

    private String limitText(String text, int maxLength) {
        if (text == null) {
            return "";
        }

        String clean = text.replaceAll("\\s+", " ").trim();

        if (clean.length() <= maxLength) {
            return clean;
        }

        return clean.substring(0, maxLength) + "...";
    }

    private String escapeJson(String text) {
        if (text == null) {
            return "";
        }

        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "")
                .replace("\t", "\\t");
    }
}
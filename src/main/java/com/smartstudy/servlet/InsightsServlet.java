package com.smartstudy.servlet;

import com.smartstudy.dao.QuizResultDAO;
import com.smartstudy.model.User;
import com.smartstudy.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InsightsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = (User) request.getSession().getAttribute("user");

            request.setAttribute("results", new QuizResultDAO().findByUser(user.getId()));
            request.setAttribute("knowledgeMap", knowledgeMap(user.getId()));

            request.getRequestDispatcher("/WEB-INF/views/student/insights.jsp")
                    .forward(request, response);

        } catch (Exception exception) {
            throw new ServletException(exception);
        }
    }

    private List<Map<String, Object>> knowledgeMap(int userId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
                SELECT 
                    c.title,
                    COALESCE(AVG(qr.score / qr.total_questions * 100), 0) AS mastery
                FROM courses c
                LEFT JOIN quiz_results qr 
                    ON c.id = qr.course_id 
                    AND qr.user_id = ?
                GROUP BY c.id, c.title
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Map<String, Object> item = new HashMap<>();

                    double mastery = resultSet.getDouble("mastery");

                    item.put("title", resultSet.getString("title"));
                    item.put("mastery", mastery);
                    item.put("level", getMasteryLevel(mastery));

                    list.add(item);
                }
            }
        }

        return list;
    }

    private String getMasteryLevel(double mastery) {
        if (mastery >= 75) {
            return "MASTERED";
        }

        if (mastery >= 50) {
            return "MEDIUM";
        }

        return "GAP";
    }
}
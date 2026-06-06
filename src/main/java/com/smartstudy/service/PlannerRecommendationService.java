package com.smartstudy.service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.smartstudy.util.DBConnection;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PlannerRecommendationService {

    private static final String MODEL = "gemini-2.5-flash";

    private static final String GEMINI_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/" + MODEL + ":generateContent";

    private final HttpClient client = HttpClient.newHttpClient();
    private final Gson gson = new Gson();

    public void generateAndSaveRecommendations(int userId) throws Exception {
        String context = buildContext(userId);

        try {
            String aiResponse = callGemini(context);
            JsonArray array = extractJsonArray(aiResponse);

            deleteOldRecommendations(userId);

            try (Connection c = DBConnection.getConnection()) {
                String sql =
                        "INSERT INTO planner_recommendations(user_id, title, body, source) " +
                        "VALUES (?, ?, ?, 'AI')";

                try (PreparedStatement ps = c.prepareStatement(sql)) {
                    int count = Math.min(3, array.size());

                    for (int i = 0; i < count; i++) {
                        JsonObject obj = array.get(i).getAsJsonObject();

                        ps.setInt(1, userId);
                        ps.setString(2, getString(obj, "title", "Personalized recommendation"));
                        ps.setString(3, getString(obj, "body", "Continue following your study plan and revise weak areas."));
                        ps.addBatch();
                    }

                    ps.executeBatch();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            saveFallbackRecommendations(userId);
        }
    }

    private String buildContext(int userId) throws Exception {
        StringBuilder sb = new StringBuilder();

        sb.append("Analyze this student's recent planner progress and generate exactly 3 personalized recommendations.\n");
        sb.append("Return ONLY valid JSON array. No markdown.\n");
        sb.append("Each recommendation must have title and body.\n");
        sb.append("Keep title under 70 characters and body under 160 characters.\n\n");

        sb.append("Required JSON format:\n");
        sb.append("[{\"title\":\"...\",\"body\":\"...\"}]\n\n");

        sb.append("Student planner data:\n");

        String sql =
                "SELECT spi.task_title, spi.description, spi.estimated_minutes, spi.actual_seconds, " +
                "spi.completed, spi.status, spi.priority, spi.generated_by, c.title AS course_title " +
                "FROM study_plan_items spi " +
                "JOIN courses c ON spi.course_id = c.id " +
                "WHERE spi.user_id = ? " +
                "ORDER BY spi.plan_date ASC, spi.id ASC " +
                "LIMIT 20";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sb.append("- Course: ").append(rs.getString("course_title")).append("\n");
                    sb.append("  Task: ").append(rs.getString("task_title")).append("\n");
                    sb.append("  Completed: ").append(rs.getBoolean("completed")).append("\n");
                    sb.append("  Status: ").append(rs.getString("status")).append("\n");
                    sb.append("  Estimated minutes: ").append(rs.getInt("estimated_minutes")).append("\n");
                    sb.append("  Actual seconds: ").append(rs.getInt("actual_seconds")).append("\n");
                    sb.append("  Priority: ").append(rs.getString("priority")).append("\n");
                    sb.append("  Source: ").append(rs.getString("generated_by")).append("\n\n");
                }
            }
        }

        return sb.toString();
    }

    private String callGemini(String prompt) throws IOException, InterruptedException {
        String apiKey = System.getenv("GEMINI_API_KEY");

        if (apiKey == null || apiKey.trim().isEmpty()) {
            throw new IOException("GEMINI_API_KEY is not configured.");
        }

        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", prompt);

        JsonArray parts = new JsonArray();
        parts.add(textPart);

        JsonObject content = new JsonObject();
        content.add("parts", parts);

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.35);
        generationConfig.addProperty("topP", 0.85);
        generationConfig.addProperty("maxOutputTokens", 1200);
        generationConfig.addProperty("responseMimeType", "application/json");

        JsonObject body = new JsonObject();
        body.add("contents", contents);
        body.add("generationConfig", generationConfig);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(GEMINI_URL + "?key=" + apiKey))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(body)))
                .build();

        HttpResponse<String> response =
                client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("Gemini error " + response.statusCode() + ": " + response.body());
        }

        JsonObject root = JsonParser.parseString(response.body()).getAsJsonObject();
        JsonArray candidates = root.getAsJsonArray("candidates");

        if (candidates == null || candidates.size() == 0) {
            throw new IOException("No Gemini candidates.");
        }

        JsonObject first = candidates.get(0).getAsJsonObject();
        JsonObject responseContent = first.getAsJsonObject("content");
        JsonArray responseParts = responseContent.getAsJsonArray("parts");

        StringBuilder result = new StringBuilder();

        for (int i = 0; i < responseParts.size(); i++) {
            JsonObject part = responseParts.get(i).getAsJsonObject();

            if (part.has("text")) {
                result.append(part.get("text").getAsString());
            }
        }

        return result.toString();
    }

    private JsonArray extractJsonArray(String text) {
        String clean = text.trim();

        if (clean.startsWith("```")) {
            clean = clean.replace("```json", "")
                    .replace("```", "")
                    .trim();
        }

        int start = clean.indexOf("[");
        int end = clean.lastIndexOf("]");

        if (start >= 0 && end > start) {
            clean = clean.substring(start, end + 1);
        }

        return JsonParser.parseString(clean).getAsJsonArray();
    }

    private String getString(JsonObject obj, String key, String fallback) {
        if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) {
            return fallback;
        }

        String value = obj.get(key).getAsString();

        if (value == null || value.trim().isEmpty()) {
            return fallback;
        }

        return value.trim();
    }

    private void deleteOldRecommendations(int userId) throws Exception {
        String sql = "DELETE FROM planner_recommendations WHERE user_id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    private void saveFallbackRecommendations(int userId) throws Exception {
        deleteOldRecommendations(userId);

        String sql =
                "INSERT INTO planner_recommendations(user_id, title, body, source) " +
                "VALUES (?, ?, ?, 'RULE')";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, "Continue the current plan");
            ps.setString(3, "Complete at least one planned task before generating new recommendations.");
            ps.addBatch();

            ps.setInt(1, userId);
            ps.setString(2, "Focus on unfinished tasks");
            ps.setString(3, "Start with high-priority tasks that are still marked as To do or In progress.");
            ps.addBatch();

            ps.setInt(1, userId);
            ps.setString(2, "Track real study time");
            ps.setString(3, "Use Start task and Finish task so the dashboard reflects your real work.");
            ps.addBatch();

            ps.executeBatch();
        }
    }
}
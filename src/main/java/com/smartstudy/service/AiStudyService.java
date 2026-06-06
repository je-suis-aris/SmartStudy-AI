package com.smartstudy.service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.smartstudy.model.Material;
import com.smartstudy.model.Question;
import com.smartstudy.model.QuizMistake;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.List;

public class AiStudyService {

    private static final String MODEL = "gemini-2.5-flash";

    private static final String GEMINI_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/" + MODEL + ":generateContent";

    private static final int SUMMARY_CONTEXT_LIMIT = 4000;
    private static final int QUESTIONS_CONTEXT_LIMIT = 4500;
    private static final int FLASHCARDS_CONTEXT_LIMIT = 3000;
    private static final int WEAKNESS_CONTEXT_LIMIT = 3500;
    private static final int MAX_OUTPUT_TOKENS = 4096;

    private static final String AI_COACH_SYSTEM_INSTRUCTION =
            "You are SmartStudy AI, a personal learning assistant. " +
            "Answer in the same language as the student's question. " +
            "If the student asks in Romanian, answer in Romanian. " +
            "If the student asks in French, answer in French. " +
            "If the student asks in English, answer in English. " +
            "Give clear, structured and educational answers. " +
            "Focus on study planning, weak topics, quiz results, flashcards, summaries and exam preparation. " +
            "Do not invent personal data. If information is missing, explain what the student should provide.";

    private final HttpClient client;
    private final Gson gson;

    public AiStudyService() {
        this.client = HttpClient.newHttpClient();
        this.gson = new Gson();
    }

    public String generateSummary(String contentText) throws IOException, InterruptedException {
        if (contentText == null || contentText.trim().isEmpty()) {
            return "No content available for summary.";
        }

        String prompt =
                "You are SmartStudy AI. Generate a concise academic summary from the uploaded course material.\n" +
                "Write in the same language as the material when possible.\n" +
                "If the material is in French, write the summary in French.\n" +
                "If the material is in Romanian, write the summary in Romanian.\n" +
                "If the material is in English, write the summary in English.\n" +
                "Do not invent information. Use only the provided document content.\n" +
                "Avoid cover-page information, student names, coordinator names, table of contents and bibliography.\n" +
                "Return only the summary text.\n\n" +
                "DOCUMENT CONTENT:\n" +
                limitText(contentText, SUMMARY_CONTEXT_LIMIT);

        return callGeminiText(prompt, false);
    }

    public List<Question> generateQuestions(Material material, int count) throws IOException, InterruptedException {
        List<Question> questions = new ArrayList<>();

        if (material == null || material.getContentText() == null || material.getContentText().trim().isEmpty()) {
            return questions;
        }

        int safeCount = Math.min(count, 5);
        String documentText = cleanText(material.getContentText());

        String prompt =
                "You are SmartStudy AI, an academic quiz generator.\n" +
                "Generate exactly " + safeCount + " multiple-choice questions based ONLY on the uploaded document.\n" +
                "Write the questions, answers and explanations in the same language as the uploaded document when possible.\n\n" +

                "IMPORTANT RULES:\n" +
                "1. The questions must be generated from the real document content.\n" +
                "2. The questions must be specific and meaningful, not generic.\n" +
                "3. Do NOT start every question with the same phrase.\n" +
                "4. The correct answer must be directly supported by the document.\n" +
                "5. The wrong answers must be plausible and related to the same topic, but clearly incorrect.\n" +
                "6. Do NOT use cover-page information, student name, university name, coordinator name, group, specialization, table of contents or bibliography.\n" +
                "7. Focus on concepts, definitions, objectives, processes, advantages, disadvantages, examples and relationships from the document.\n" +
                "8. The field correctAnswer must contain only one letter: A, B, C, or D.\n" +
                "9. Return ONLY valid JSON. No markdown. No explanation outside JSON.\n\n" +

                "JSON FORMAT REQUIRED:\n" +
                "[\n" +
                "  {\n" +
                "    \"questionText\": \"Question here\",\n" +
                "    \"optionA\": \"Answer A\",\n" +
                "    \"optionB\": \"Answer B\",\n" +
                "    \"optionC\": \"Answer C\",\n" +
                "    \"optionD\": \"Answer D\",\n" +
                "    \"correctAnswer\": \"A\",\n" +
                "    \"explanation\": \"Short explanation based on the document\"\n" +
                "  }\n" +
                "]\n\n" +

                "DOCUMENT CONTENT:\n" +
                limitText(documentText, QUESTIONS_CONTEXT_LIMIT);

        String aiText = callGeminiText(prompt, true);
        String jsonOnly = extractJsonArray(aiText);

        JsonArray array = JsonParser.parseString(jsonOnly).getAsJsonArray();

        for (int i = 0; i < array.size(); i++) {
            JsonObject obj = array.get(i).getAsJsonObject();

            String questionText = getString(obj, "questionText");
            String optionA = getString(obj, "optionA");
            String optionB = getString(obj, "optionB");
            String optionC = getString(obj, "optionC");
            String optionD = getString(obj, "optionD");
            String correctAnswer = getString(obj, "correctAnswer").toUpperCase();
            String explanation = getString(obj, "explanation");

            if (questionText.isBlank()
                    || optionA.isBlank()
                    || optionB.isBlank()
                    || optionC.isBlank()
                    || optionD.isBlank()) {
                continue;
            }

            if (!correctAnswer.equals("A")
                    && !correctAnswer.equals("B")
                    && !correctAnswer.equals("C")
                    && !correctAnswer.equals("D")) {
                correctAnswer = "A";
            }

            Question q = new Question();

            q.setCourseId(material.getCourseId());
            q.setQuestionText(shorten(questionText, 700));
            q.setOptionA(shorten(optionA, 700));
            q.setOptionB(shorten(optionB, 700));
            q.setOptionC(shorten(optionC, 700));
            q.setOptionD(shorten(optionD, 700));
            q.setCorrectAnswer(correctAnswer);
            q.setExplanation(shorten(explanation, 1000));
            q.setGeneratedByAi(true);

            questions.add(q);
        }

        return questions;
    }

    public List<String[]> generateFlashcards(String contentText) throws IOException, InterruptedException {
        List<String[]> flashcards = new ArrayList<>();

        if (contentText == null || contentText.trim().isEmpty()) {
            return flashcards;
        }

        String documentText = cleanText(contentText);

        String prompt =
                "You are SmartStudy AI, an academic flashcard generator.\n" +
                "Generate exactly 5 flashcards based ONLY on the uploaded document.\n" +
                "Write the flashcards in the same language as the uploaded document when possible.\n\n" +

                "IMPORTANT RULES:\n" +
                "1. Return ONLY a valid JSON array. No markdown. No explanation outside JSON.\n" +
                "2. Each object must contain only two fields: front and back.\n" +
                "3. Keep front under 120 characters.\n" +
                "4. Keep back under 220 characters.\n" +
                "5. Do not invent information.\n" +
                "6. Do not use cover-page information, student names, coordinator names, university name, group, table of contents or bibliography.\n" +
                "7. Focus on concepts, definitions, important ideas, relationships and exam-relevant information.\n\n" +

                "REQUIRED JSON FORMAT:\n" +
                "[{\"front\":\"question or concept\",\"back\":\"short answer from the document\"}]\n\n" +

                "DOCUMENT CONTENT:\n" +
                limitText(documentText, FLASHCARDS_CONTEXT_LIMIT);

        try {
            String aiText = callGeminiText(prompt, true);
            String jsonOnly = extractJsonArray(aiText);

            JsonArray array = JsonParser.parseString(jsonOnly).getAsJsonArray();

            for (int i = 0; i < array.size(); i++) {
                JsonObject obj = array.get(i).getAsJsonObject();

                String front = getString(obj, "front");
                String back = getString(obj, "back");

                if (front.isBlank() || back.isBlank()) {
                    continue;
                }

                flashcards.add(new String[]{
                        shorten(front, 300),
                        shorten(back, 600)
                });
            }

            if (flashcards.isEmpty()) {
                flashcards.addAll(buildFallbackFlashcards());
            }

        } catch (Exception e) {
            e.printStackTrace();
            flashcards.clear();
            flashcards.addAll(buildFallbackFlashcards());
        }

        return flashcards;
    }

    public List<String[]> generateFlashcardsFromMistakes(List<QuizMistake> mistakes) throws IOException, InterruptedException {
        List<String[]> flashcards = new ArrayList<>();

        if (mistakes == null || mistakes.isEmpty()) {
            return flashcards;
        }

        StringBuilder context = new StringBuilder();

        for (QuizMistake mistake : mistakes) {
            context.append("Wrong quiz question:\n");
            context.append("Question: ").append(nullToEmpty(mistake.getQuestionText())).append("\n");
            context.append("Student selected answer: ").append(nullToEmpty(mistake.getSelectedAnswer())).append("\n");
            context.append("Correct answer letter: ").append(nullToEmpty(mistake.getCorrectAnswer())).append("\n");
            context.append("Correct answer text: ").append(nullToEmpty(mistake.getCorrectAnswerText())).append("\n");
            context.append("Explanation: ").append(nullToEmpty(mistake.getExplanation())).append("\n\n");
        }

        String prompt =
                "You are SmartStudy AI, an adaptive learning assistant.\n" +
                "Generate exactly 5 flashcards based on the student's wrong quiz answers.\n" +
                "Write the flashcards in the same language as the wrong quiz questions when possible.\n\n" +

                "IMPORTANT RULES:\n" +
                "1. Return ONLY a valid JSON array. No markdown. No explanation outside JSON.\n" +
                "2. Each object must contain only two fields: front and back.\n" +
                "3. The flashcards must target what the student did not understand.\n" +
                "4. Do not repeat the original multiple-choice options.\n" +
                "5. The front must be a short question or weak concept.\n" +
                "6. The back must explain the correct idea clearly.\n" +
                "7. Keep front under 120 characters.\n" +
                "8. Keep back under 240 characters.\n\n" +

                "REQUIRED JSON FORMAT:\n" +
                "[{\"front\":\"question or weak concept\",\"back\":\"clear corrective explanation\"}]\n\n" +

                "STUDENT WRONG ANSWERS:\n" +
                limitText(context.toString(), WEAKNESS_CONTEXT_LIMIT);

        try {
            String aiText = callGeminiText(prompt, true);
            String jsonOnly = extractJsonArray(aiText);

            JsonArray array = JsonParser.parseString(jsonOnly).getAsJsonArray();

            for (int i = 0; i < array.size(); i++) {
                JsonObject obj = array.get(i).getAsJsonObject();

                String front = getString(obj, "front");
                String back = getString(obj, "back");

                if (front.isBlank() || back.isBlank()) {
                    continue;
                }

                flashcards.add(new String[]{
                        shorten(front, 300),
                        shorten(back, 700)
                });
            }

            if (flashcards.isEmpty()) {
                flashcards.addAll(buildFallbackWeaknessFlashcards());
            }

        } catch (Exception e) {
            e.printStackTrace();
            flashcards.clear();
            flashcards.addAll(buildFallbackWeaknessFlashcards());
        }

        return flashcards;
    }

    public String askPlainText(String prompt) throws IOException, InterruptedException {
        if (prompt == null || prompt.trim().isEmpty()) {
            return "No prompt was provided.";
        }

        String finalPrompt =
                AI_COACH_SYSTEM_INSTRUCTION +
                "\n\nSTUDENT QUESTION:\n" +
                prompt.trim();

        return callGeminiText(finalPrompt, false);
    }

    private String callGeminiText(String prompt, boolean jsonMode) throws IOException, InterruptedException {
        String apiKey = System.getenv("GEMINI_API_KEY");

        if (apiKey == null || apiKey.trim().isEmpty()) {
            throw new IOException("GEMINI_API_KEY is not configured. Add it as an environment variable and restart Eclipse.");
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
        generationConfig.addProperty("temperature", 0.25);
        generationConfig.addProperty("topP", 0.8);
        generationConfig.addProperty("maxOutputTokens", MAX_OUTPUT_TOKENS);

        if (jsonMode) {
            generationConfig.addProperty("responseMimeType", "application/json");
        }

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

        System.out.println("Gemini HTTP status: " + response.statusCode());

        if (response.statusCode() == 429) {
            throw new IOException(
                    "Google AI quota limit reached. Please wait 20-60 seconds and try again. " +
                    "For the free tier, generate fewer questions or flashcards and send less document text."
            );
        }

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("Google AI API error " + response.statusCode() + ": " + response.body());
        }

        return extractGeminiText(response.body());
    }

    private String extractGeminiText(String responseBody) throws IOException {
        JsonObject root = JsonParser.parseString(responseBody).getAsJsonObject();

        JsonArray candidates = root.getAsJsonArray("candidates");

        if (candidates == null || candidates.size() == 0) {
            throw new IOException("No candidates returned by Gemini. Raw response: " + responseBody);
        }

        JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
        JsonObject content = firstCandidate.getAsJsonObject("content");

        if (content == null) {
            throw new IOException("No content returned by Gemini. Raw response: " + responseBody);
        }

        JsonArray parts = content.getAsJsonArray("parts");

        if (parts == null || parts.size() == 0) {
            throw new IOException("No text parts returned by Gemini. Raw response: " + responseBody);
        }

        StringBuilder result = new StringBuilder();

        for (int i = 0; i < parts.size(); i++) {
            JsonObject part = parts.get(i).getAsJsonObject();

            if (part.has("text")) {
                result.append(part.get("text").getAsString());
            }
        }

        return result.toString().trim();
    }

    private String extractJsonArray(String text) throws IOException {
        if (text == null || text.trim().isEmpty()) {
            throw new IOException("Gemini returned an empty response.");
        }

        String clean = text.trim();

        if (clean.startsWith("```")) {
            clean = clean.replace("```json", "")
                    .replace("```", "")
                    .trim();
        }

        int start = clean.indexOf("[");
        int end = clean.lastIndexOf("]");

        if (start == -1) {
            throw new IOException("Could not find JSON array start in Gemini response: " + text);
        }

        if (end == -1 || end <= start) {
            String partial = clean.substring(start).trim();

            if (partial.endsWith(",")) {
                partial = partial.substring(0, partial.length() - 1);
            }

            partial = partial + "]";

            return partial;
        }

        return clean.substring(start, end + 1);
    }

    private String getString(JsonObject obj, String key) {
        if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) {
            return "";
        }

        return obj.get(key).getAsString().trim();
    }

    private String cleanText(String text) {
        if (text == null) {
            return "";
        }

        return text
                .replace("\r", " ")
                .replace("\n", " ")
                .replace("\t", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    private String limitText(String text, int maxLength) {
        if (text == null) {
            return "";
        }

        String clean = cleanText(text);

        if (clean.length() <= maxLength) {
            return clean;
        }

        return clean.substring(0, maxLength);
    }

    private String shorten(String text, int maxLength) {
        if (text == null) {
            return "";
        }

        String clean = text.trim();

        if (clean.length() <= maxLength) {
            return clean;
        }

        int cut = clean.lastIndexOf(" ", maxLength);

        if (cut < 100) {
            cut = maxLength;
        }

        return clean.substring(0, cut).trim() + "...";
    }

    private String nullToEmpty(String value) {
        return value == null ? "" : value;
    }

    private List<String[]> buildFallbackFlashcards() {
        List<String[]> fallback = new ArrayList<>();

        fallback.add(new String[]{
                "What is the main topic of this material?",
                "Review the extracted document text and identify the central topic discussed."
        });

        fallback.add(new String[]{
                "Which concepts should be revised first?",
                "Start with the concepts that appear repeatedly and are important for understanding the material."
        });

        fallback.add(new String[]{
                "How should this document be studied?",
                "Read the main ideas, create short notes, then test your understanding with questions."
        });

        return fallback;
    }

    private List<String[]> buildFallbackWeaknessFlashcards() {
        List<String[]> fallback = new ArrayList<>();

        fallback.add(new String[]{
                "What concept caused the mistake?",
                "Review the explanation of the wrong quiz answer and identify the concept behind the correct answer."
        });

        fallback.add(new String[]{
                "How can this mistake be corrected?",
                "Compare your selected answer with the correct answer and focus on the difference between them."
        });

        fallback.add(new String[]{
                "What should be revised before the next quiz?",
                "Revise the topic related to the incorrect answer and test yourself again with a similar question."
        });

        return fallback;
    }
}
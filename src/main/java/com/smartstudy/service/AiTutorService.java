package com.smartstudy.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class AiTutorService {

	private static final String MODEL = "gemini-2.5-flash";
    private static final String GEMINI_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/" + MODEL + ":generateContent";

    private final HttpClient client;

    public AiTutorService() {
        this.client = HttpClient.newHttpClient();
    }

    public String ask(String question, String context) throws IOException, InterruptedException {
        if (question == null || question.trim().isEmpty()) {
            return "Please write a question first.";
        }

        String apiKey = System.getenv("GEMINI_API_KEY");

        if (apiKey == null || apiKey.trim().isEmpty()) {
            return "GEMINI_API_KEY is not configured. Add it as an environment variable and restart Eclipse.";
        }

        if (context == null || context.trim().isEmpty()) {
            context = "No uploaded course material is available yet.";
        }

        String prompt =
                "You are SmartStudy AI, a helpful study tutor inside a student learning platform.\n" +
                "Answer clearly, academically, and in the same language as the student's question.\n" +
                "Use the uploaded course material when relevant.\n" +
                "If the answer is not present in the material, say that clearly and then give a general explanation.\n\n" +
                "STUDY CONTEXT:\n" +
                limitText(context, 7000) + "\n\n" +
                "STUDENT QUESTION:\n" +
                question;

        String jsonBody =
                "{"
                        + "\"contents\":["
                        + "{"
                        + "\"parts\":["
                        + "{"
                        + "\"text\":\"" + escapeJson(prompt) + "\""
                        + "}"
                        + "]"
                        + "}"
                        + "]"
                        + "}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(GEMINI_URL + "?key=" + apiKey))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                .build();

        HttpResponse<String> response =
                client.send(request, HttpResponse.BodyHandlers.ofString());

        String responseBody = response.body();

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            return "Google AI API error " + response.statusCode() + ": " + responseBody;
        }

        String answer = extractTextWithoutRegex(responseBody);

        if (answer == null || answer.trim().isEmpty()) {
            return "Google AI answered, but the text could not be extracted. Raw response: " + responseBody;
        }

        return answer.trim();
    }

    private String extractTextWithoutRegex(String json) {
        if (json == null || json.isEmpty()) {
            return "";
        }

        StringBuilder result = new StringBuilder();

        int searchFrom = 0;
        String marker = "\"text\"";

        while (true) {
            int textKeyIndex = json.indexOf(marker, searchFrom);

            if (textKeyIndex == -1) {
                break;
            }

            int colonIndex = json.indexOf(":", textKeyIndex);

            if (colonIndex == -1) {
                break;
            }

            int firstQuoteIndex = json.indexOf("\"", colonIndex + 1);

            if (firstQuoteIndex == -1) {
                break;
            }

            StringBuilder extracted = new StringBuilder();
            boolean escaping = false;

            for (int i = firstQuoteIndex + 1; i < json.length(); i++) {
                char ch = json.charAt(i);

                if (escaping) {
                    switch (ch) {
                        case '"':
                            extracted.append('"');
                            break;
                        case '\\':
                            extracted.append('\\');
                            break;
                        case '/':
                            extracted.append('/');
                            break;
                        case 'b':
                            extracted.append('\b');
                            break;
                        case 'f':
                            extracted.append('\f');
                            break;
                        case 'n':
                            extracted.append('\n');
                            break;
                        case 'r':
                            extracted.append('\r');
                            break;
                        case 't':
                            extracted.append('\t');
                            break;
                        case 'u':
                            if (i + 4 < json.length()) {
                                String hex = json.substring(i + 1, i + 5);

                                try {
                                    extracted.append((char) Integer.parseInt(hex, 16));
                                    i += 4;
                                } catch (NumberFormatException e) {
                                    extracted.append("\\u").append(hex);
                                    i += 4;
                                }
                            } else {
                                extracted.append("\\u");
                            }
                            break;
                        default:
                            extracted.append(ch);
                            break;
                    }

                    escaping = false;
                } else {
                    if (ch == '\\') {
                        escaping = true;
                    } else if (ch == '"') {
                        searchFrom = i + 1;
                        break;
                    } else {
                        extracted.append(ch);
                    }
                }
            }

            if (extracted.length() > 0) {
                if (result.length() > 0) {
                    result.append("\n");
                }

                result.append(extracted);
            }

            if (searchFrom <= textKeyIndex) {
                searchFrom = textKeyIndex + marker.length();
            }
        }

        return result.toString();
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
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
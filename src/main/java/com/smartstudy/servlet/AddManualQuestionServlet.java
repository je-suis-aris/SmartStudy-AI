package com.smartstudy.servlet;

import com.smartstudy.dao.QuestionDAO;
import com.smartstudy.model.Question;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class AddManualQuestionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");

            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String courseIdParam = req.getParameter("courseId");
            String questionText = clean(req.getParameter("questionText"));
            String optionA = clean(req.getParameter("optionA"));
            String optionB = clean(req.getParameter("optionB"));
            String optionC = clean(req.getParameter("optionC"));
            String optionD = clean(req.getParameter("optionD"));
            String correctAnswer = clean(req.getParameter("correctAnswer")).toUpperCase();
            String explanation = clean(req.getParameter("explanation"));

            if (courseIdParam == null || courseIdParam.trim().isEmpty()
                    || questionText.isEmpty()
                    || optionA.isEmpty()
                    || optionB.isEmpty()
                    || optionC.isEmpty()
                    || optionD.isEmpty()
                    || correctAnswer.isEmpty()) {

                resp.sendRedirect(req.getContextPath() + "/assessment?manualError=1");
                return;
            }

            if (!correctAnswer.equals("A")
                    && !correctAnswer.equals("B")
                    && !correctAnswer.equals("C")
                    && !correctAnswer.equals("D")) {

                resp.sendRedirect(req.getContextPath() + "/assessment?manualError=1");
                return;
            }

            int courseId = Integer.parseInt(courseIdParam);

            Question question = new Question();

            question.setCourseId(courseId);
            question.setQuestionText(shorten(questionText, 700));
            question.setOptionA(shorten(optionA, 700));
            question.setOptionB(shorten(optionB, 700));
            question.setOptionC(shorten(optionC, 700));
            question.setOptionD(shorten(optionD, 700));
            question.setCorrectAnswer(correctAnswer);
            question.setExplanation(shorten(explanation, 1000));
            question.setGeneratedByAi(false);

            boolean created = new QuestionDAO().create(question);

            if (!created) {
                resp.sendRedirect(req.getContextPath() + "/assessment?manualError=1");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/assessment?manualAdded=1");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private String shorten(String value, int maxLength) {
        if (value == null) {
            return "";
        }

        String cleaned = value.trim();

        if (cleaned.length() <= maxLength) {
            return cleaned;
        }

        return cleaned.substring(0, maxLength);
    }
}
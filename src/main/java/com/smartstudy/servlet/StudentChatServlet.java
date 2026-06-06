package com.smartstudy.servlet;

import com.smartstudy.dao.ChatMessageDAO;
import com.smartstudy.model.ChatMessage;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class StudentChatServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ChatMessageDAO chatDAO = new ChatMessageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            int studentId = user.getId();

            chatDAO.markAdminMessagesAsReadForStudent(studentId);

            List<ChatMessage> messages = chatDAO.findByStudentId(studentId);
            int unreadCount = chatDAO.countUnreadForStudent(studentId);

            req.setAttribute("messages", messages);
            req.setAttribute("unreadCount", unreadCount);

            req.getRequestDispatcher("/WEB-INF/views/student/chat.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

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

            String messageText = req.getParameter("messageText");

            if (messageText == null || messageText.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/chat?empty=1");
                return;
            }

            ChatMessage message = new ChatMessage(
                    user.getId(),
                    null,
                    user.getId(),
                    "STUDENT",
                    messageText.trim()
            );

            chatDAO.create(message);

            resp.sendRedirect(req.getContextPath() + "/chat");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
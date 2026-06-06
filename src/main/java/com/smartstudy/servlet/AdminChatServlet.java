package com.smartstudy.servlet;

import com.smartstudy.dao.ChatMessageDAO;
import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.ChatConversation;
import com.smartstudy.model.ChatMessage;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class AdminChatServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ChatMessageDAO chatDAO = new ChatMessageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User currentUser = (User) req.getSession().getAttribute("user");

            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
                return;
            }

            List<ChatConversation> conversations = chatDAO.findAllConversations();

            int selectedStudentId = 0;

            String studentIdParam = req.getParameter("studentId");

            if (studentIdParam != null && !studentIdParam.trim().isEmpty()) {
                selectedStudentId = Integer.parseInt(studentIdParam);
            } else if (!conversations.isEmpty()) {
                selectedStudentId = conversations.get(0).getStudentId();
            }

            User selectedStudent = null;
            List<ChatMessage> messages = null;

            if (selectedStudentId > 0) {
                selectedStudent = new UserDAO().findById(selectedStudentId);
                messages = chatDAO.findByStudentId(selectedStudentId);
                chatDAO.markStudentMessagesAsRead(selectedStudentId);
            }

            int unreadCount = chatDAO.countUnreadForAdmin();

            req.setAttribute("conversations", conversations);
            req.setAttribute("selectedStudentId", selectedStudentId);
            req.setAttribute("selectedStudent", selectedStudent);
            req.setAttribute("messages", messages);
            req.setAttribute("unreadCount", unreadCount);

            req.getRequestDispatcher("/WEB-INF/views/admin/chat.jsp")
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

            User currentUser = (User) req.getSession().getAttribute("user");

            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
                return;
            }

            String studentIdParam = req.getParameter("studentId");
            String messageText = req.getParameter("messageText");

            if (studentIdParam == null || studentIdParam.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/chat?missingStudent=1");
                return;
            }

            if (messageText == null || messageText.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/chat?studentId=" + studentIdParam + "&empty=1");
                return;
            }

            int studentId = Integer.parseInt(studentIdParam);

            ChatMessage message = new ChatMessage(
                    studentId,
                    currentUser.getId(),
                    currentUser.getId(),
                    "ADMIN",
                    messageText.trim()
            );

            chatDAO.create(message);

            resp.sendRedirect(req.getContextPath() + "/admin/chat?studentId=" + studentId);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
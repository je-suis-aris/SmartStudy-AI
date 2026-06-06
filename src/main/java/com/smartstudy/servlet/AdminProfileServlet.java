package com.smartstudy.servlet;

import com.smartstudy.model.User;
import com.smartstudy.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/admin/profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class AdminProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/profile";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String fullName = request.getParameter("fullName");
        String description = request.getParameter("description");

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full name cannot be empty.");
            request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
            return;
        }

        String profilePhotoPath = currentUser.getProfilePhoto();

        Part filePart = request.getPart("profilePhoto");

        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            if (submittedFileName != null && !submittedFileName.isBlank()) {
                String lowerName = submittedFileName.toLowerCase();

                if (!lowerName.endsWith(".png")
                        && !lowerName.endsWith(".jpg")
                        && !lowerName.endsWith(".jpeg")) {

                    request.setAttribute("error", "Only PNG, JPG and JPEG images are allowed.");
                    request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
                    return;
                }

                String extension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                String newFileName = "admin_" + currentUser.getId() + "_" + System.currentTimeMillis() + extension;

                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                File file = new File(uploadDir, newFileName);
                filePart.write(file.getAbsolutePath());

                profilePhotoPath = UPLOAD_DIR + "/" + newFileName;
            }
        }

        try {
            updateAdminProfile(
                    currentUser.getId(),
                    fullName.trim(),
                    description,
                    profilePhotoPath
            );

            currentUser.setFullName(fullName.trim());
            currentUser.setDescription(description);
            currentUser.setProfilePhoto(profilePhotoPath);

            session.setAttribute("user", currentUser);

            request.setAttribute("success", "Admin profile updated successfully.");
            request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Profile update failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
        }
    }

    private void updateAdminProfile(
            int userId,
            String fullName,
            String description,
            String profilePhoto
    ) throws Exception {

        String sql =
                "UPDATE users " +
                "SET full_name = ?, description = ?, profile_photo = ? " +
                "WHERE id = ? AND role = 'ADMIN'";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, description);
            ps.setString(3, profilePhoto);
            ps.setInt(4, userId);

            ps.executeUpdate();
        }
    }
}
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import dao.userDAO;
import model.User;

@WebServlet("/changePassword")
public class ChangePasswordController extends HttpServlet {
    private userDAO userDAO;

    @Override
    public void init() {
        userDAO = new userDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to change password page (no session check needed)
        request.getRequestDispatcher("/views/changePassword.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String username = request.getParameter("username");
        String currentPassword = request.getParameter("password");
        String newPassword = request.getParameter("newPassword");

        // Validate username and current password
        User user = userDAO.authenticate(username, currentPassword);
        if (user == null) {
            request.setAttribute("error", "Invalid username or current password");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/changePassword.jsp").forward(request, response);
            return;
        }

        // Validate new password length
        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("error", "New password must be at least 6 characters long");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/changePassword.jsp").forward(request, response);
            return;
        }

        // Hash new password
        String hashedNewPassword = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt());

        // Update in database
        if (userDAO.updatePassword(user.getId(), hashedNewPassword)) {
            response.sendRedirect("login?message=Password changed successfully. Please login with your new password.");
        } else {
            request.setAttribute("error", "Failed to change password");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/changePassword.jsp").forward(request, response);
        }
    }
}

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String idParam = request.getParameter("id");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    // Validation
    if (idParam == null || idParam.trim().isEmpty() || 
        fullName == null || fullName.trim().isEmpty()) {
        response.sendRedirect("list_student.jsp?error=" + 
            java.net.URLEncoder.encode("Required fields are missing!", "UTF-8"));
        return;
    }
    
    int studentId = 0;
    try {
        studentId = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("list_student.jsp?error=" + 
            java.net.URLEncoder.encode("Invalid student ID!", "UTF-8"));
        return;
    }
   
    //verify email
    if (email != null && !email.trim().isEmpty()) {
        if (!email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=" + 
                java.net.URLEncoder.encode("Invalid email format! Please enter a valid email (e.g., studentID@student.hcmiu.edu.vn)", "UTF-8"));
            return;
        }
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/lab4";
        String username = "root";
        String password = "khanhtai";
        
        conn = DriverManager.getConnection(url, username, password);
        
        String sql = "UPDATE students SET full_name = ?, email = ?, major = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, fullName.trim());
        pstmt.setString(2, email != null && !email.trim().isEmpty() ? email.trim() : null);
        pstmt.setString(3, major != null && !major.trim().isEmpty() ? major.trim() : null);
        pstmt.setInt(4, studentId);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("list_student.jsp?message=" + 
                java.net.URLEncoder.encode("Student updated successfully!", "UTF-8"));
        } else {
            response.sendRedirect("list_student.jsp?error=" + 
                java.net.URLEncoder.encode("Student not found or no changes made!", "UTF-8"));
        }
        
    } catch (ClassNotFoundException e) {
        response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=" + 
            java.net.URLEncoder.encode("Database Driver not found: " + e.getMessage(), "UTF-8"));
    } catch (SQLException e) {
        response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=" + 
            java.net.URLEncoder.encode("Database Error: " + e.getMessage(), "UTF-8"));
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
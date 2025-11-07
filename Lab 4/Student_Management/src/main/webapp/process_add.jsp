<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String studentID = request.getParameter("student_ID");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    // Server-side validation
    if (studentID == null || studentID.trim().isEmpty() || 
        fullName == null || fullName.trim().isEmpty()) {
        response.sendRedirect("add_student.jsp?error=" + 
            java.net.URLEncoder.encode("Student Code and Full Name are required!", "UTF-8"));
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/lab4";
        String username = "root";
        String password = "khanhtai";
        
        conn = DriverManager.getConnection(url, username, password);
        
        // Insert student
        String sql = "INSERT INTO students (student_ID, full_name, email, major) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentID.trim());
        pstmt.setString(2, fullName.trim());
        pstmt.setString(3, email != null && !email.trim().isEmpty() ? email.trim() : null);
        pstmt.setString(4, major != null && !major.trim().isEmpty() ? major.trim() : null);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("list_student.jsp?message=" + 
                java.net.URLEncoder.encode("Student added successfully!", "UTF-8"));
        } else {
            response.sendRedirect("add_student.jsp?error=" + 
                java.net.URLEncoder.encode("Failed to add student. Please try again.", "UTF-8"));
        }
        
    } catch (SQLIntegrityConstraintViolationException e) {
        response.sendRedirect("add_student.jsp?error=" + 
            java.net.URLEncoder.encode("Student code already exists!", "UTF-8"));
    } catch (Exception e) {
        response.sendRedirect("add_student.jsp?error=" + 
            java.net.URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
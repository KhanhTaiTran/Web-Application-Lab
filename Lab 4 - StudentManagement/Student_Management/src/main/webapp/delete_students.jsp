<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String idParam = request.getParameter("id");
    
    // Validate ID parameter
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("list_student.jsp?error=" + 
            java.net.URLEncoder.encode("Invalid student ID!", "UTF-8"));
        return;
    }
    
    int studentId = 0;
    try {
        studentId = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("list_student.jsp?error=" + 
            java.net.URLEncoder.encode("Invalid student ID format!", "UTF-8"));
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/lab4";
        String username = "root";
        String password = "admin";
        
        conn = DriverManager.getConnection(url, username, password);
        
        String sql = "DELETE FROM students WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, studentId);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("list_student.jsp?message=" + 
                java.net.URLEncoder.encode("Student deleted successfully!", "UTF-8"));
        } else {
            response.sendRedirect("list_student.jsp?error=" + 
                java.net.URLEncoder.encode("Student not found or already deleted!", "UTF-8"));
        }
        
    } catch (ClassNotFoundException e) {
        response.sendRedirect("list_student.jsp?error=" + 
            java.net.URLEncoder.encode("Database Driver not found: " + e.getMessage(), "UTF-8"));
    } catch (SQLException e) {
        response.sendRedirect("list_student.jsp?error=" + 
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
<%@ page import="java.sql.*" %>
<%@ page contentType="text/csv;charset=UTF-8" language="java" %>
<%
    // Set response headers for CSV download
    response.setContentType("text/csv; charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=\"students_" + System.currentTimeMillis() + ".csv\"");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // Connect to database
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/lab4";
        String username = "root";
        String password = "khanhtai";
        
        conn = DriverManager.getConnection(url, username, password);
        
        // CSV Header with UTF-8 BOM for Excel compatibility
        out.write('\ufeff'); // UTF-8 BOM
        out.println("ID,Student ID,Full Name,Email,Major,Created At");
        
        // Query all students
        String sql = "SELECT * FROM students ORDER BY id";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        
        // Write data rows
        while (rs.next()) {
            int id = rs.getInt("id");
            String studentID = rs.getString("student_ID");
            String fullName = rs.getString("full_name");
            String email = rs.getString("email");
            String major = rs.getString("major");
            String createdAt = rs.getString("created_at");
            
            // Escape values that contain commas or quotes
            fullName = escapeCSV(fullName);
            email = email != null ? escapeCSV(email) : "";
            major = major != null ? escapeCSV(major) : "";
            
            // Write CSV row
            out.println(id + "," + 
                       studentID + "," + 
                       fullName + "," + 
                       email + "," + 
                       major + "," + 
                       createdAt);
        }
        
    } catch (ClassNotFoundException e) {
        out.println("Error: MySQL Driver not found - " + e.getMessage());
    } catch (SQLException e) {
        out.println("Error: Database error - " + e.getMessage());
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<%!
    // Helper method to escape CSV values
    private String escapeCSV(String value) {
        if (value == null) return "";
        
        // If value contains comma, quote, or newline, wrap in quotes and escape quotes
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            value = "\"" + value.replace("\"", "\"\"") + "\"";
        }
        
        return value;
    }
%>
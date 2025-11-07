<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Student - Student Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>Edit Student</h1>
        
        <%
            String error = request.getParameter("error");
            if (error != null && !error.isEmpty()) {
        %>
            <div class="message error"><%= error %></div>
        <%
            }
            String idParam = request.getParameter("id");
            
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
            ResultSet rs = null;
            
            String studentID = "";
            String fullName = "";
            String email = "";
            String major = "";
            boolean studentFound = false;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/lab4";
                String username = "root";
                String password = "khanhtai";
                
                conn = DriverManager.getConnection(url, username, password);
                
                // Query student by ID
                String sql = "SELECT * FROM students WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, studentId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    studentFound = true;
                    studentID = rs.getString("student_ID");
                    fullName = rs.getString("full_name");
                    email = rs.getString("email");
                    major = rs.getString("major");
                } else {
                    response.sendRedirect("list_student.jsp?error=" + 
                        java.net.URLEncoder.encode("Student not found!", "UTF-8"));
                    return;
                }
                
            } catch (ClassNotFoundException e) {
                out.println("<div class='message error'>Database Driver not found: " + e.getMessage() + "</div>");
            } catch (SQLException e) {
                out.println("<div class='message error'>Database Error: " + e.getMessage() + "</div>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            
            if (studentFound) {
        %>
        
        <form action="process_edit.jsp" method="POST">
            <input type="hidden" name="id" value="<%= studentId %>">
            
            <div class="form-group">
                <label for="student_ID">Student Code <span style="color: red;">*</span></label>
                <input type="text" 
                       id="student_ID" 
                       name="student_ID" 
                       value="<%= studentID %>"
                       readonly
                       style="background-color: #f3f4f6; cursor: not-allowed;">
                <small style="color: #6b7280;">Student code cannot be changed</small>
            </div>
            
            <div class="form-group">
                <label for="full_name">Full Name <span style="color: red;">*</span></label>
                <input type="text" 
                       id="full_name" 
                       name="full_name" 
                       value="<%= fullName %>"
                       required>
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       value="<%= email != null ? email : "" %>">
            </div>
            
            <div class="form-group">
                <label for="major">Major</label>
                <input type="text" 
                       id="major" 
                       name="major" 
                       value="<%= major != null ? major : "" %>">
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-success">Update Student</button>
                <a href="list_students.jsp" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
        
        <%
            }
        %>
    </div>
</body>
</html>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - Student Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>Student Management System</h1>
        
        <%
            String message = request.getParameter("message");
            String error = request.getParameter("error");
            
            if (message != null && !message.isEmpty()) {
        %>
            <div class="message success"><%= message %></div>
        <%
            }
            if (error != null && !error.isEmpty()) {
        %>
            <div class="message error"><%= error %></div>
        <%
            }
        %>
        
        <div class="toolbar">
            <h2>Student List</h2>
            <a href="add_student.jsp" class="btn btn-success">Add New Student</a>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Student ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Major</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                boolean hasData = false;
                
                try {
                    //connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    
                    String url = "jdbc:mysql://localhost:3306/lab4";
                    String username = "root";  
                    String password = "khanhtai";      
                    
                    conn = DriverManager.getConnection(url, username, password);
                    
                    // Query students
                    String sql = "SELECT * FROM students ORDER BY id DESC";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        hasData = true;
                        int id = rs.getInt("id");
                        String studentID = rs.getString("student_ID");
                        String fullName = rs.getString("full_name");
                        String email = rs.getString("email");
                        String major = rs.getString("major");
                        Timestamp createdAt = rs.getTimestamp("created_at");
            %>
                <tr>
                    <td><%= id %></td>
                    <td><strong><%= studentID %></strong></td>
                    <td><%= fullName %></td>
                    <td><%= email != null ? email : "-" %></td>
                    <td><%= major != null ? major : "-" %></td>
                    <td><%= createdAt %></td>
                    <td>
                        <div class="actions">
                            <a href="edit_students.jsp?id=<%= id %>" class="btn btn-primary">Edit</a>
                            <a href="delete_students.jsp?id=<%= id %>" 
                               class="btn btn-danger"
                               onclick="return confirm('Are you sure you want to delete this student?')">
                               Delete
                            </a>
                        </div>
                    </td>
                </tr>
            <%
                    }
                    
                } catch (ClassNotFoundException e) {
            %>
                <tr>
                    <td colspan="7" style="padding: 20px; background: #fee2e2; color: #991b1b;">
                        <strong>Error:</strong> MySQL Driver not found!<br>
                        <small>Make sure mysql-connector-java is in dependencies</small><br>
                        <small>Error: <%= e.getMessage() %></small>
                    </td>
                </tr>
            <%
                } catch (SQLException e) {
            %>
                <tr>
                    <td colspan="7" style="padding: 20px; background: #fee2e2; color: #991b1b;">
                        <strong>Database Error:</strong><br>
                        <%= e.getMessage() %><br>
                        <small>Check if MySQL is running and database exists</small>
                    </td>
                </tr>
            <%
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='7'>Error closing resources: " + e.getMessage() + "</td></tr>");
                    }
                }
                
                if (!hasData) {
            %>
                <tr>
                    <td colspan="7" class="no-data">
                        <p style="font-size: 48px;">📭</p>
                        <p style="font-size: 18px; margin: 20px 0;">No students found</p>
                        <a href="add_student.jsp" class="btn btn-success">Add your first student</a>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>
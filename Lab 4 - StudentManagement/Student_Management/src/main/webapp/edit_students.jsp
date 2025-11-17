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
                String password = "admin";
                
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
        
        <form action="process_edit.jsp" method="POST" onsubmit="return handleSubmit(this)">
            <input type="hidden" name="id" value="<%= studentId %>">
            
            <div class="form-group">
                <label for="student_ID">Student ID <span style="color: red;">*</span></label>
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
                <a href="list_student.jsp" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
        
        <%
            }
        %>
    </div>
    
    <script>
    setTimeout(function() {
        var messages = document.querySelectorAll('.message');
        messages.forEach(function(msg) {
            msg.style.transition = 'opacity 0.5s';
            msg.style.opacity = '0';
            setTimeout(function() {
                msg.style.display = 'none';
            }, 500);
        });
    }, 3000);

    function handleSubmit(form) {
        var btn = form.querySelector('button[type="submit"]');
        var studentID = form.student_ID.value;
        var email = form.email.value;
        
        var studentIDPattern = /^[A-Z]{6,}[0-9]{5,}$/;
        if (!studentIDPattern.test(studentID)) {
            alert('❌ Invalid Student ID format!\n\nMust be:\n- Start with 6+ uppercase letters\n- Followed by 5+ letters or numbers\n\nExamples: ITITIU21300');
            return false;
        }
        
        if (email && email.trim() !== '') {
            var emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
            if (!emailPattern.test(email)) {
                alert('❌ Invalid email format!\n\nPlease enter a valid email like:\nstudentID@example.com');
                return false;
            }
        }
        
        // Show loading state
        btn.disabled = true;
        btn.textContent = '⏳ Processing...';
        return true;
    }
    </script>
</body>
</html>
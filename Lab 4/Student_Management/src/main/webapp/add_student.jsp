<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Student - Student Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>Add New Student</h1>
        
        <%
            String error = request.getParameter("error");
            if (error != null && !error.isEmpty()) {
        %>
            <div class="message error"><%= error %></div>
        <%
            }
        %>
        
        <form action="process_add.jsp" method="POST">
            <div class="form-group">
                <label for="student_ID">Student ID <span style="color: red;">*</span></label>
                <input type="text" 
                       id="student_ID" 
                       name="student_ID" 
                       placeholder="e.g., ITITIU21300" 
                       required
                       pattern="[A-Za-z0-9]+"
                       title="Student code should contain only letters and numbers">
            </div>
            
            <div class="form-group">
                <label for="full_name">Full Name <span style="color: red;">*</span></label>
                <input type="text" 
                       id="full_name" 
                       name="full_name" 
                       placeholder="Enter full name" 
                       required>
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       placeholder="student@example.com">
            </div>
            
            <div class="form-group">
                <label for="major">Major</label>
                <input type="text" 
                       id="major" 
                       name="major" 
                       placeholder="e.g., Computer Science">
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-success">Save Student</button>
                <a href="list_student.jsp" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>
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
        
        <form action="process_add.jsp" method="POST" onsubmit="return handleSubmit(this)">
            <div class="form-group">
                <label for="student_ID">Student ID <span style="color: red;">*</span></label>
                <input type="text" 
                       id="student_ID" 
                       name="student_ID" 
                       placeholder="e.g., ITITIU21300" 
                       required
                       pattern="[A-Z]{6,}[0-9]{5,}"
                       title="Student ID should contain only 6 uppercasse letters and 5 numbers">
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
                       placeholder="student@example.com"
                       pattern="[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"
                       title="Pls enter valid email">
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
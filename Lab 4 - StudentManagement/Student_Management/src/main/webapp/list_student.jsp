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
        <!-- search form -->
        <form action="list_student.jsp" method="GET" class="search-form">
            <input type="text" id="search" name="keyword" placeholder="Search by name or code..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
            <button type="submit" class="btn btn-secondary">Search</button>
            <a href="list_student.jsp" class="btn btn-secondary">Clear</a>
        </form>
            
        <div class="toolbar">
            <h2>Student List</h2>
            <div>
                <a href="export_csv.jsp" class="btn" style="background: #10b981;">
                    📥 Export CSV
                </a>
                <a href="add_student.jsp" class="btn btn-success">Add New Student</a>
            </div>
            
        </div>
            
        <%
            String keyword = request.getParameter("keyword");
            boolean isSearch = (keyword != null && !keyword.trim().isEmpty());  
            
            if(isSearch){
        %>
            <p style="color: #6b7280; margin-bottom: 10px;">Search results for : <strong>"<%= keyword %>"</strong></p>
        <% 
            }
            
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            if(pageParam != null && !pageParam.isEmpty()){
                try{
                    currentPage = Integer.parseInt(pageParam);
                    if(currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e){
                    currentPage = 1;
                }
            } 

            int recordPerPage = 10; //10 student per page
            int offset = (currentPage - 1) * recordPerPage;

            int totalRecords = 0;
            int totalPages = 0;
        %>
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
                
                PreparedStatement countPstmt = null;
                ResultSet countRs = null;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    
                    String url = "jdbc:mysql://localhost:3306/lab4";
                    String username = "root";  
                    String password = "admin";      
                    conn = DriverManager.getConnection(url, username, password);
                    
                    String sql;
                    if(isSearch){
                        // Search query với LIKE operator
                        sql = "SELECT * FROM students WHERE full_name LIKE ? OR student_ID LIKE ? ORDER BY id ";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, "%" + keyword.trim() + "%");
                        pstmt.setString(2, "%" + keyword.trim() + "%");
                    } else {
                        //get total record
                        String countSQL = "SELECT COUNT(*) as total FROM students";
                        countPstmt = conn.prepareStatement(countSQL);
                        countRs = countPstmt.executeQuery();
                   
                        if (countRs.next()){
                            totalRecords = countRs.getInt("total");
                            totalPages = (int) Math.ceil((double) totalRecords / recordPerPage);
                        }
                    
                        //limit and offset
                        sql = "SELECT * FROM students ORDER BY id LIMIT ? OFFSET ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setInt(1, recordPerPage);
                        pstmt.setInt(2, offset);
                    }
                    rs = pstmt.executeQuery();
                    
                    
                    while (rs.next()) {
                        hasData = true;
                        int id = rs.getInt("id");
                        String studentID = rs.getString("student_ID");
                        String fullName = rs.getString("full_name");
                        String email = rs.getString("email");
                        String major = rs.getString("major");
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        
                        if (isSearch) {
                            String pattern = "(?i)(" + keyword.trim() + ")";
                            fullName = fullName.replaceAll(pattern, "<span class='highlight'>$1</span>");
                            studentID = studentID.replaceAll(pattern, "<span class='highlight'>$1</span>");
                        }
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
                            <a href="edit_students.jsp?id=<%= id %>" class="btn btn-primary">️Edit</a>
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
                        <strong>❌ Error:</strong> MySQL Driver not found!<br>
                        <small>Make sure mysql-connector-java is in dependencies</small><br>
                        <small>Error: <%= e.getMessage() %></small>
                    </td>
                </tr>
            <%
                } catch (SQLException e) {
            %>
                <tr>
                    <td colspan="7" style="padding: 20px; background: #fee2e2; color: #991b1b;">
                        <strong>❌ Database Error:</strong><br>
                        <%= e.getMessage() %><br>
                        <small>Check if MySQL is running and database exists</small>
                    </td>
                </tr>
            <%
                } finally {
                    try {
                        if (countRs != null) countRs.close();
                        if (countPstmt != null) countPstmt.close();
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='7'>Error closing resources: " + e.getMessage() + "</td></tr>");
                    }
                }
                
                if (!hasData) {
                    if(isSearch){
            %>
                        <tr>
                            <td colspan="7" class="no-data">
                                <p style="font-size: 48px;">🔍</p>
                                <p style="font-size: 18px; margin: 20px 0;">No students found for "<%= keyword %>"</p>
                                <a href="list_student.jsp" class="btn btn-secondary">Clear Search</a>
                            </td>
                        </tr>
            <%
                    }else{
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
                }
            %>
            </tbody>
        </table>
            
            <% 
                if (totalPages > 1) { 
            %>
                    <div class="pagination">
            <% 
                if (currentPage > 1) { 
            %>
                    <a href="list_student.jsp?page=<%= currentPage - 1 %>">« Previous</a>
            <% 
                } 
            %>
                
            <%
                // Show page numbers
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                if (startPage > 1) {
            %>
                    <a href="list_student.jsp?page=1">1</a>
            <%  
                    if (startPage > 2) { 
            %>
                        <span>...</span>
            <%      
                    } 
                }
                for (int i = startPage; i <= endPage; i++) {
                    if (i == currentPage) { 
            %>            
                        <strong><%= i %></strong>
            <%      
                    } else { 
            %>
                        <a href="list_student.jsp?page=<%= i %>"><%= i %></a>
            <%  
                    } 
                }   
                if (endPage < totalPages) { 
                    if (endPage < totalPages - 1) {
            %>
                        <span>...</span>
            <% 
                    } 
            %>
                    <a href="list_student.jsp?page=<%= totalPages %>"><%= totalPages %></a>
            <% 
                } 
            %>
                
            <% 
                if (currentPage < totalPages) { 
            %>
                    <a href="list_student.jsp?page=<%= currentPage + 1 %>">Next »</a>
            <% 
                } 
            %>
            </div>
            
            <div class="pagination-info">
                Showing <%= offset + 1 %> to <%= Math.min(offset + recordPerPage, totalRecords) %> of <%= totalRecords %> students
            </div>
        <% 
            } 
        %>
    </div>
    
    <script>
    // Auto-hide messages
    setTimeout(function() {
        var messages = document.querySelectorAll('.message');
        messages.forEach(function(msg) {
            msg.style.transition = 'opacity 0.5s';
            msg.style.opacity = '0';
            setTimeout(function() {
                msg.style.display = 'none';
            }, 500);
        });
    }, 2000);
    </script>
</body>
</html>
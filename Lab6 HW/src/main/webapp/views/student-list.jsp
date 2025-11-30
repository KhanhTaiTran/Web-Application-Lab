<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-style: italic;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }
        
        th a {
            color: white;
            text-decoration: none;
            cursor: pointer;
        }
        
        th a:hover {
            text-decoration: underline;
        }
        
        tbody tr {
            transition: background-color 0.2s;
        }
        
        tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .actions {
            display: flex;
            gap: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        
        .search-box {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .search-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .search-input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .search-results-message {
            color: #666;
            font-size: 14px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
        }
        
        .btn-clear {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-clear:hover {
            background-color: #5a6268;
        }

        .pagination {
            margin: 20px 0;
            text-align: center;
        }

        .pagination a {
            padding: 8px 12px;
            margin: 0 4px;
            border: 1px solid #ddd;
            text-decoration: none;
        }
        .pagination strong {
            padding: 8px 12px;
            margin: 0 4px;
            background-color: #4CAF50;
            color: white;
            border: 1px solid #4CAF50;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>📚 Student Management System</h2>
        <div class="navbar-right">
            <div class="user-info">
                <span>Welcome, ${sessionScope.fullName}</span>
                <span class="role-badge role-${sessionScope.role}">
                    ${sessionScope.role}
                </span>
            </div>
            <a href="dashboard">Dashboard</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <!-- TODO: Show error from URL parameter -->
    <c:if test="${not empty param.error}">
        <div class="alert alert-error">
            ${param.error}
        </div>
    </c:if>

    <div class="container">
        <h1>📚 Student List</h1>
        <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>
        
       <!-- Add button - Admin only -->
        <c:if test="${sessionScope.role eq 'admin'}">
            <div style="margin: 20px 0;">
                <a href="student?action=new" class="btn btn-primary">➕ Add New Student</a>
            </div>
        </c:if>

        <!-- Search Bar -->
        <div class="search-box">
            <form action="student" method="get" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" 
                       name="keyword" 
                       class="search-input"
                       placeholder="🔍 Search by student code, name, email, or major..." 
                       value="${keyword}">
                <button type="submit" class="btn btn-primary">🔍 Search</button>
                <c:if test="${not empty keyword}">
                    <a href="student?action=list" class="btn btn-clear">❌ Show All</a>
                </c:if>
            </form>
            
            <!-- Search Results Message -->
            <c:if test="${not empty keyword}">
                <div class="search-results-message">
                    🔎 Search results for: <strong>"${keyword}"</strong>
                </div>
            </c:if>
        </div>
        
        <!-- Add Export Button -->
        <div style="margin-bottom: 20px; display: flex; gap: 10px;">
            
            <a href="export" class="btn btn-secondary" style="background-color: #28a745;">
                📥 Export to Excel
            </a>
        </div>
        
        <!-- Student Table -->
        <c:choose>
            <c:when test="${not empty students}">
                <div>
                    <form action="student" method="get">
                        <input type="hidden" name="action" value="filter">
                        <label>Filter by Major:</label>
                        <select name="major" >
                            <option value="All Majors" ${selectedMajor == 'All Majors' ? 'selected' : ''}>All Majors</option>
                            <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                            <option value="Information Technology" ${selectedMajor == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                            <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                            <option value="Business Administration" ${selectedMajor == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
                        </select>
                        <button type="submit">Apply</button>
                        <c:if test="${not empty selectedMajor}">
                            <a href="student?action=list">Clear Filter</a>
                            <p>Currently filtering by: <strong>${selectedMajor}</strong></p>
                        </c:if>
                    </form>
                </div>
                <!-- Student Table -->
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Major</th>
                            <c:if test="${sessionScope.role eq 'admin'}">
                                <th>Actions</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td>${student.studentCode}</td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>${student.major}</td>
                                
                                <!-- Action buttons - Admin only -->
                                <c:if test="${sessionScope.role eq 'admin'}">
                                    <td>
                                        <a href="student?action=edit&id=${student.id}" 
                                        class="btn-edit">Edit</a>
                                        <a href="student?action=delete&id=${student.id}" 
                                        class="btn-delete"
                                        onclick="return confirm('Delete this student?')">Delete</a>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty students}">
                            <tr>
                                <td colspan="6" style="text-align: center;">
                                    No students found
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <div class="pagination">
                    <!--Prev button-->
                    <c:if test="${currentPage > 1}">
                        <a href="student?action=${not empty sortBy ? 'sort' : (not empty selectedMajor ? 'filter' : (not empty keyword ? 'search' : 'list'))}&page=${currentPage - 1}<c:if test='${not empty sortBy}'>&sortBy=${sortBy}&order=${order}</c:if><c:if test='${not empty selectedMajor}'>&major=${selectedMajor}</c:if><c:if test='${not empty keyword}'>&keyword=${keyword}</c:if>" class="btn btn-secondary">« Prev</a>
                    </c:if>

                    <!--Page numbers-->
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <strong>${i}</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="student?action=${not empty sortBy ? 'sort' : (not empty selectedMajor ? 'filter' : (not empty keyword ? 'search' : 'list'))}&page=${i}<c:if test='${not empty sortBy}'>&sortBy=${sortBy}&order=${order}</c:if><c:if test='${not empty selectedMajor}'>&major=${selectedMajor}</c:if><c:if test='${not empty keyword}'>&keyword=${keyword}</c:if>">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <!--Next button-->
                    <c:if test="${currentPage < totalPages}">
                        <a href="student?action=${not empty sortBy ? 'sort' : (not empty selectedMajor ? 'filter' : (not empty keyword ? 'search' : 'list'))}&page=${currentPage + 1}<c:if test='${not empty sortBy}'>&sortBy=${sortBy}&order=${order}</c:if><c:if test='${not empty selectedMajor}'>&major=${selectedMajor}</c:if><c:if test='${not empty keyword}'>&keyword=${keyword}</c:if>" class="btn btn-secondary">Next »</a>
                    </c:if>
                </div>
                <p>Showing page ${currentPage} of ${totalPages}</p>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3>No students found</h3>
                    <p>Start by adding a new student</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>

<%@ page import="java.sql.*" %> <%@ page contentType="text/html;charset=UTF-8"
language="java" %>

<html>
  <head>
    <title>Student List</title>
    <style>
      table {
        border-collapse: collapse;
        width: 80%;
        margin: 20px auto;
      }
      th,
      td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
      }
      th {
        background-color: #f2f2f2;
      }
      .message {
        text-align: center;
        color: green;
      }
      .error {
        color: red;
      }
    </style>
  </head>
  <body>
    <h2 style="text-align: center">List of Students</h2>

    <% String message = request.getParameter("message"); String error =
    request.getParameter("error"); if (message != null && !message.isEmpty()) {
    %>
    <div class="message"><%= message %></div>
    <% } if (error != null && !error.isEmpty()) { %>
    <div class="message error"><%= error %></div>
    <% } %>

    <table>
      <tr>
        <th>ID</th>
        <th>Student Code</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Phone</th>
      </tr>

      <% Connection conn = null; PreparedStatement pstmt = null; ResultSet rs =
      null; try { Class.forName("com.mysql.cj.jdbc.Driver"); String url =
      "jdbc:mysql://localhost:3306/student_management"; String username =
      "root"; // Thay bằng username MySQL của bạn String password = "khanhtai";
      // Thay bằng password MySQL của bạn conn =
      DriverManager.getConnection(url, username, password); String sql = "SELECT
      * FROM students ORDER BY id DESC"; pstmt = conn.prepareStatement(sql); rs
      = pstmt.executeQuery(); boolean hasData = false; while (rs.next()) {
      hasData = true; %>
      <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("student_code") %></td>
        <td><%= rs.getString("full_name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("phone") %></td>
      </tr>
      <% } if (!hasData) { %>
      <tr>
        <td colspan="5" class="error">No data found</td>
      </tr>
      <% } } catch (ClassNotFoundException e) { %>
      <tr>
        <td colspan="5" class="error">
          Database Driver not found: <%= e.getMessage() %>
        </td>
      </tr>
      <% } catch (SQLException e) { %>
      <tr>
        <td colspan="5" class="error">Database Error: <%= e.getMessage() %></td>
      </tr>
      <% } finally { try { if (rs != null) rs.close(); if (pstmt != null)
      pstmt.close(); if (conn != null) conn.close(); } catch (SQLException e) {
      %>
      <tr>
        <td colspan="5" class="error">
          Error closing resources: <%= e.getMessage() %>
        </td>
      </tr>
      <% } } %>
    </table>
  </body>
</html>

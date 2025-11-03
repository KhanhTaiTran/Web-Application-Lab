<%@ page import="java.sql.*, java.util.*,
com.studentmanagement.utils.DBConnection" %>
<html>
  <head>
    <title>Student List</title>
  </head>
  <body>
    <h2>Student List</h2>
    <table border="1">
      <tr>
        <th>ID</th>
        <th>Code</th>
        <th>Name</th>
        <th>Email</th>
        <th>Major</th>
        <th>Created At</th>
      </tr>
      <% try { Connection conn = DBConnection.getConnection(); Statement stmt =
      conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM
      students"); while(rs.next()) { %>
      <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("student_code") %></td>
        <td><%= rs.getString("full_name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("major") %></td>
        <td><%= rs.getTimestamp("created_at") %></td>
      </tr>
      <% } rs.close(); stmt.close(); conn.close(); } catch(Exception e) {
      out.println("Error: " + e.getMessage()); } %>
    </table>
  </body>
</html>

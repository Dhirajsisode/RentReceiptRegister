<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>All Rent Receipts</title>
    <style>
        body { font-family: Arial; margin: 30px; }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }
        th { background: #eee; }
    </style>
</head>
<body>

<h2>All Rent Receipts</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Tenant</th>
        <th>Month</th>
        <th>Rent (Rs.)</th>
        <th>Paid On</th>
    </tr>

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    try (Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/rent_db", "root", "");
         PreparedStatement ps = con.prepareStatement(
            "SELECT id, tenant, rent_month, rent, paid_on FROM receipts ORDER BY id DESC");
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("tenant") %></td>
        <td><%= rs.getString("rent_month") %></td>
        <td><%= rs.getBigDecimal("rent") %></td>
        <td><%= rs.getDate("paid_on") %></td>
    </tr>
<%
        }
    }
} catch (Exception e) {
    application.log("Unable to display rent receipts", e);
%>
    <tr>
        <td colspan="5">Unable to load receipts. Check the database connection and Tomcat logs.</td>
    </tr>
<%
}
%>

</table>

<p><a href="result.jsp">Back to Register</a></p>

</body>
</html>
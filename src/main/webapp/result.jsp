<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String message = "";
String color = "red";

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String tenant = request.getParameter("tenant");
    String month = request.getParameter("rent_month");
    String rent = request.getParameter("rent");
    String paidOn = request.getParameter("paid_on");

    try {
        if (tenant == null || tenant.trim().isEmpty()
                || month == null || month.isEmpty()
                || rent == null || paidOn == null
                || rent.isEmpty() || paidOn.isEmpty()) {
            throw new IllegalArgumentException(
                "Please fill in all fields.");
        }

        BigDecimal amount = new BigDecimal(rent);

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException(
                "Rent must be greater than zero.");
        }

        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/rent_db",
                "root", "");
             PreparedStatement ps = con.prepareStatement(
                "INSERT INTO receipts " +
                "(tenant, rent_month, rent, paid_on) " +
                "VALUES (?, ?, ?, ?)")) {

            ps.setString(1, tenant.trim());
            ps.setString(2, month);
            ps.setBigDecimal(3, amount);
            ps.setDate(4, Date.valueOf(paidOn));

            int result = ps.executeUpdate();

            if (result > 0) {
                message = "Receipt saved successfully!";
                color = "green";
            }
        }

    } catch (Exception e) {
        application.log("Rent receipt save failed", e);
        message = "Save failed: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rent Receipt Register</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #fff;
        }

        form {
            width: 300px;
            margin: 40px auto;
            padding: 20px;
            border: 1px solid #ccc;
        }

        input, select {
            width: 100%;
            padding: 7px;
            margin: 6px 0;
            box-sizing: border-box;
        }

        button {
            display: block;
            margin: 12px auto;
            padding: 7px 20px;
            cursor: pointer;
        }

        .red { color: red; }
        .green { color: green; }
    </style>
</head>

<script>
document.querySelector("form").addEventListener("submit", function(e) {
    let tenant = document.querySelector('[name="tenant"]').value.trim();
    let month = document.querySelector('[name="rent_month"]').value;
    let rent = Number(document.querySelector('[name="rent"]').value);
    let date = document.querySelector('[name="paid_on"]').value;

    if (!tenant || !month || !date || rent <= 0) {
        e.preventDefault();
        alert("Please fill all fields correctly!");
    }
});
</script>

<body>

<form action="index.jsp" method="post">
    <h2>Rent Receipt Register</h2>

    <label for="tenant">Tenant:</label>
    <input type="text" id="tenant" name="tenant"
           maxlength="40" required>

    <label for="rent_month">Month:</label>
    <select id="rent_month" name="rent_month" required>
        <option value="">Select Month</option>
        <option value="Jan">Jan</option>
        <option value="Feb">Feb</option>
        <option value="Mar">Mar</option>
        <option value="Apr">Apr</option>
        <option value="May">May</option>
        <option value="Jun">Jun</option>
        <option value="Jul">Jul</option>
        <option value="Aug">Aug</option>
        <option value="Sep">Sep</option>
        <option value="Oct">Oct</option>
        <option value="Nov">Nov</option>
        <option value="Dec">Dec</option>
    </select>

    <label for="rent">Rent (Rs.):</label>
    <input type="number" id="rent" name="rent"
           min="0.01" step="0.01" required>

    <label for="paid_on">Paid On:</label>
    <input type="date" id="paid_on" name="paid_on"
           required>

    <button type="submit">Save</button>

    <a href="rent.jsp">View All Receipts</a>

    <% if (!message.isEmpty()) { %>
        <p class="<%= color %>">
            <%= message.replace("&", "&amp;")
                       .replace("<", "&lt;")
                       .replace(">", "&gt;")
                       .replace("\"", "&quot;")
                       .replace("'", "&#39;") %>
        </p>
    <% } %>
</form>

</body>
</html>

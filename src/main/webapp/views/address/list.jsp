<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Address"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Address Management</title>
</head>
<body>

<h1>Address Management</h1>

<a href="address?action=create">Create Address</a>

<br><br>

<table border="1" cellpadding="8">
    <tr>
        <th>ID</th>
        <th>Customer ID</th>
        <th>Street</th>
        <th>District</th>
        <th>City</th>
        <th>Country</th>
        <th>Default</th>
        <th>Action</th>
    </tr>

<%
List<Address> list = (List<Address>) request.getAttribute("addresses");

if (list != null) {
    for (Address a : list) {
%>

<tr>
    <td><%=a.getAddressID()%></td>
    <td><%=a.getCustomerID()%></td>
    <td><%=a.getStreet()%></td>
    <td><%=a.getDistrict()%></td>
    <td><%=a.getCity()%></td>
    <td><%=a.getCountry()%></td>
    <td><%=a.isDefault() ? "Yes" : "No"%></td>
    <td>
        <a href="address?action=edit&id=<%=a.getAddressID()%>">Edit</a>
        |
        <a href="address?action=delete&id=<%=a.getAddressID()%>"
           onclick="return confirm('Delete this address?')">Delete</a>
        |
        <a href="address?action=default&id=<%=a.getAddressID()%>&customerID=<%=a.getCustomerID()%>">
            Set Default
        </a>
    </td>
</tr>

<%
    }
}
%>

</table>

</body>
</html>
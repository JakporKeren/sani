<%-- 
    Document   : driver_home
    Created on : Apr 29, 2026, 8:28:56?PM
    Author     : User
--%>

<%@ page session="true" %>
<%
if(session.getAttribute("username")==null){
    response.sendRedirect("login.jsp");
}
%>

<h2>Driver Dashboard</h2>
Welcome: <%= session.getAttribute("username") %>

<br><br>
<a href="LogoutServlet">Logout</a>
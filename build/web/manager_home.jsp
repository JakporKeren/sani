<%@ page session="true" %>
<%
if(session.getAttribute("username")==null){
    response.sendRedirect("login.jsp");
}
%>

<h2>Manager Dashboard</h2>
Welcome: <%= session.getAttribute("username") %>

<br><br>
<a href="LogoutServlet">Logout</a>
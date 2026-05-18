<!DOCTYPE html>
<html>
    <head>
        <title>SANI SCHEDULING SYSTEM</title>
        <link rel="stylesheet" href="style.css">
    </head>
    <body>

        <%
            String msg = request.getParameter("msg");
            if (msg != null) {
        %>
        <script>
            <% if (msg.equals("fail")) { %>
            alert("Login failed!Please Try Again");
            <% } else if (msg.equals("registered")) { %>
            alert("Registration successful!");
            <% } %>

        </script>
        <% }%>

        <div class="container">
            <div class="card">

                <div class="left">
                    <div class="brand">
                        <span class="brand-name">SANIBUS</span>
                    </div>
                    <div class="welcome-text">
                        <h1>Welcome to Sani Scheduling Bus.</h1>
                        <p>Reliable transport for everyone.</p>
                    </div>
                </div>

                <!-- Bahagian Kanan -->
                <div class="right">
                    <h2>LOG IN </h2>
                    <p class="subtitle">PORTAL ACCESS</p>

                    <form action="LoginServlet" method="post">
                        <div class="input-group">
                            <label>USERNAME</label>
                            <input type="text" name="username" placeholder="Username" required>
                        </div>

                        <div class="input-group">
                            <label>PASSWORD</label>
                            <input type="password" name="password" placeholder="******" required>
                        </div>

                        <div class="input-group">
                            <label>ROLE</label>
                            <select name="role">
                                <!-- Tukar value="student" kepada value="passenger" -->
                                <option value="passenger">Passenger</option> 
                                <option value="driver">Driver</option>
                                <option value="admin">Admin</option>
                                <option value="manager">Manager</option>
                            </select>
                        </div>

                        <button type="submit" class="login-btn">Log in </button>
                    </form>

                    <div class="link">
                        New here? <a href="register.jsp">SIGN UP</a>
                        <div class="link" style="margin-top: 10px;">
                            Lupa kata laluan? <a href="forgot_password.jsp">RESET DI SINI</a>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </body>
</html>
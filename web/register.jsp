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
            alert("Login failed!Please Try Again");
        </script>
        <% }%>

        <div class="container">
            <div class="card">

                <div class="left">
                    <div class="brand">
                        <span class="brand-name">SANIBUS</span>
                    </div>
                    <div class="welcome-text">
                        <h1>Your Journey Starts Here.</h1>
                        <p>Join Sani smarter commute.</p>
                    </div>
                </div>

                <!-- Bahagian Kanan -->
                <div class="right">
                    <h2>REGISTER</h2>
                    <p class="subtitle">CREATE ACCOUNT</p>

                    <form action="RegisterServlet" method="post">
                        <div class="input-group">
                            <label>FULL NAME</label>
                            <input type="text" name="fullname" placeholder="Enter full name" required>
                        </div>

                        <div class="input-group">
                            <label>EMAIL</label>
                            <input type="email" name="email" placeholder="user@gmail.com" required>
                        </div>

                        <div class="input-group">
                            <label>USERNAME</label>
                            <input type="text" name="username" placeholder="Username" required>
                        </div>

                        <div class="input-group">
                            <label>PASSWORD</label>
                            <input type="password" name="password" placeholder="********" required>
                            <small>MUST CONTAIN A NUMBER AND LEAST OF 6 CHARACTERS</small>
                        </div>

                        <div class="input-group">
                            <label>ACCOUNT ROLE</label>
                            <div class="role-selector">
                                <label class="role-item">
                                    <!-- Tukar value dari "student" kepada "passenger" -->
                                    <input type="radio" name="role" value="passenger" checked>
                                    <span class="role-btn">PASSENGER</span>
                                </label>
                                <label class="role-item">
                                    <input type="radio" name="role" value="driver">
                                    <span class="role-btn">DRIVER</span>
                                </label>
                                <label class="role-item">
                                    <input type="radio" name="role" value="manager">
                                    <span class="role-btn">MANAGER</span>
                                </label>
                                <label class="role-item">
                                    <input type="radio" name="role" value="admin">
                                    <span class="role-btn">ADMIN</span>
                                </label>
                            </div>
                        </div>

                        <button type="submit" class="login-btn">Register</button>
                    </form>

                    <div class="link">
                        Already have an account? <a href="login.jsp">LOG IN</a>
                    </div>
                </div>

            </div>
        </div>

    </body>
</html>

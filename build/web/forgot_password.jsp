<%-- 
    Document   : forgot_password
    Created on : May 13, 2026, 1:19:19?AM
    Author     : User
--%>
<!DOCTYPE html>
<html>
<head>
    <title>RESET PASSWORD - SANI BUS</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <div class="card">
        <div class="right" style="width: 100%;">
            <h2>RESET PASSWORD</h2>
            <form action="ForgotPasswordServlet" method="post">
                <div class="input-group">
                    <label>USERNAME</label>
                    <input type="text" name="username" placeholder="Masukkan Username anda" required>
                </div>
                <div class="input-group">
                    <label>NEW PASSWORD</label>
                    <input type="password" name="new_password" placeholder="******" required>
                </div>
                <button type="submit" class="login-btn">UPDATE PASSWORD</button>
            </form>
            <div class="link">
                <a href="login.jsp">KEMBALI KE LOGIN</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
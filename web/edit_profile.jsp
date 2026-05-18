<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" import="java.sql.*" %>
<%
    // Pastikan pengguna sudah login
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Ambil data sedia ada dari database
    String email = "";
    String phone = "";
    int age = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/bus_system", "root", "");
        
        // Query ditambah untuk mengambil phone dan age
        PreparedStatement pst = conn.prepareStatement("SELECT email, phone, age FROM users WHERE username = ?");
        pst.setString(1, username);
        ResultSet rs = pst.executeQuery();
        
        if(rs.next()) { 
            email = rs.getString("email"); 
            phone = rs.getString("phone") != null ? rs.getString("phone") : "";
            age = rs.getInt("age");
        }
        conn.close();
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile - SANI BUS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #d8a19a; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .edit-card { background: #f5e1de; padding: 40px; border-radius: 30px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 380px; }
        h2 { color: #2b1c1a; text-align: center; margin-bottom: 25px; font-weight: 800; }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-size: 12px; font-weight: 600; color: #2b1c1a; margin-bottom: 5px; }
        input { width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #ddd; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        input:focus { outline: none; border-color: #2b1c1a; }
        .btn-save { width: 100%; padding: 14px; background: #2b1c1a; color: white; border: none; border-radius: 10px; font-weight: bold; cursor: pointer; margin-top: 15px; transition: 0.3s; }
        .btn-save:hover { background: #452d2a; }
        .back-link { display: block; text-align: center; margin-top: 15px; color: #2b1c1a; text-decoration: none; font-size: 13px; font-weight: 600; }
    </style>
</head>
<body>
    <div class="edit-card">
        <h2>Update Profile</h2>
        <form action="UpdateProfileServlet" method="POST">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="new_username" value="<%= username %>" required>
            </div>
            
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="new_email" value="<%= email %>" required>
            </div>

            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="new_phone" value="<%= phone %>" placeholder="e.g. 0123456789">
            </div>

            <div class="form-group">
                <label>Age</label>
                <input type="number" name="new_age" value="<%= age > 0 ? age : "" %>" min="1" max="100">
            </div>


            <button type="submit" class="btn-save">SAVE CHANGES</button>
            <a href="student_home.jsp" class="back-link"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
        </form>
    </div>
</body>
</html>
// LoginServlet.java Patch
package com.sani;

import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String sql = "SELECT * FROM users WHERE username=? AND password=? AND role=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);

                    // FIXED: Swapped comparison structure to avoid runtime null exceptions
                    if ("admin".equals(role)) {
                        response.sendRedirect("admin_home.jsp");
                    } else if ("driver".equals(role)) {
                        response.sendRedirect("driver_home.jsp");
                    } else if ("manager".equals(role)) {
                        response.sendRedirect("manager_home.jsp");
                    } else if ("passenger".equals(role)) { 
                        response.sendRedirect("student_home.jsp"); 
                    }
                } else {
                    response.sendRedirect("login.jsp?msg=fail");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?msg=error");
        }
    }
}
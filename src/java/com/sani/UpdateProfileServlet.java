package com.sani;

import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession();
        String currentUsername = (String) session.getAttribute("username");
        String userRole = (String) session.getAttribute("role");

        String newUsername = request.getParameter("new_username");
        String newEmail = request.getParameter("new_email");
        String newPhone = request.getParameter("new_phone");
        String newAgeStr = request.getParameter("new_age");
        int newAge = (newAgeStr != null && !newAgeStr.isEmpty()) ? Integer.parseInt(newAgeStr) : 0;

        String sql = "UPDATE users SET username=?, email=?, phone=?, age=? WHERE username=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newUsername);
            ps.setString(2, newEmail);
            ps.setString(3, newPhone);
            ps.setInt(4, newAge);
            ps.setString(5, currentUsername);

            int result = ps.executeUpdate();

            if (result > 0) {
                session.setAttribute("username", newUsername);
                
                // FIXED: Dynamically route the dashboard fallback using the user role
                if ("admin".equalsIgnoreCase(userRole)) {
                    response.sendRedirect("admin_home.jsp?msg=update_success");
                } else if ("driver".equalsIgnoreCase(userRole)) {
                    response.sendRedirect("driver_home.jsp?msg=update_success");
                } else if ("manager".equalsIgnoreCase(userRole)) {
                    response.sendRedirect("manager_home.jsp?msg=update_success");
                } else {
                    response.sendRedirect("student_home.jsp?msg=update_success");
                }
            } else {
                response.sendRedirect("edit_profile.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit_profile.jsp?msg=exception");
        }
    }
}
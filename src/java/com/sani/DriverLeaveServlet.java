package com.sani;

import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DriverLeaveServlet")
public class DriverLeaveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("submit".equals(action)) {
            String leaveType = request.getParameter("leaveType");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String reason = request.getParameter("reason");

            if ("Annual".equals(leaveType)) {
                reason = "";
            }

            String sql = "INSERT INTO driver_leaves (driver_username, leave_type, start_date, end_date, reason, status, created_at) " +
                         "VALUES (?, ?, ?, ?, ?, 'Pending', NOW())";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, username);
                ps.setString(2, leaveType);
                ps.setString(3, startDate);
                ps.setString(4, endDate);
                ps.setString(5, reason);
                ps.executeUpdate();

                response.sendRedirect("driver_home.jsp?tab=leave&msg=success");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("driver_home.jsp?tab=leave&msg=error");
            }
        }
    }
}

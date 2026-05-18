/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sani;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ambil data dari borang carian JSP
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String travelDate = request.getParameter("travelDate");

        // 2. Senarai untuk simpan hasil carian
        List<Map<String, Object>> searchResults = new ArrayList<>();

        // 3. Maklumat Database (Sila ubah mengikut database anda)
        String url = "jdbc:mysql://localhost:3307/bus_system";
        String user = "root";
        String password = "";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);

            // SQL untuk cari bas berdasarkan lokasi asal dan destinasi
            String sql = "SELECT * FROM bus_routes WHERE origin LIKE ? AND destination LIKE ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + origin + "%");
            ps.setString(2, "%" + destination + "%");

            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> route = new HashMap<>();
                route.put("bus_name", rs.getString("bus_name"));
                route.put("origin", rs.getString("origin"));
                route.put("destination", rs.getString("destination"));
                route.put("price", rs.getDouble("price"));
                route.put("departure", rs.getString("departure_time"));
                route.put("arrival", rs.getString("arrival_time"));
                route.put("duration", rs.getString("duration"));
                route.put("seats", rs.getInt("available_seats"));
                
                searchResults.add(route);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Tutup semua connection
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        // 4. Hantar hasil ke student_home.jsp
        request.setAttribute("searchResults", searchResults);
        request.getRequestDispatcher("student_home.jsp").forward(request, response);
    }
}
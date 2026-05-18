package com.sani;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ProcessBookingServlet")
public class ProcessBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String scheduleId = request.getParameter("schedule_id");
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String type = request.getParameter("type");
        String qtyStr = request.getParameter("qty");
        String insuranceStr = request.getParameter("insurance");
        String selectedSeats = request.getParameter("selected_seats");
        String basePriceStr = request.getParameter("price");
        
        int qty = (qtyStr != null) ? Integer.parseInt(qtyStr) : 1;
        double basePrice = (basePriceStr != null) ? Double.parseDouble(basePriceStr) : 45.00;
        boolean hasInsurance = Boolean.parseBoolean(insuranceStr);

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                response.sendRedirect("error.jsp");
                return;
            }
            conn.setAutoCommit(false);

            String updateScheduleSql = "UPDATE schedules SET available_seats = available_seats - ? WHERE id = ?";
            try (PreparedStatement pstUpdate = conn.prepareStatement(updateScheduleSql)) {
                pstUpdate.setInt(1, qty);
                pstUpdate.setString(2, scheduleId);
                pstUpdate.executeUpdate();
            }

            if (selectedSeats != null && !selectedSeats.trim().isEmpty()) {
                String[] seatsArray = selectedSeats.split(",");
                String insertSeatSql = "INSERT INTO booked_seats (schedule_id, seat_number) VALUES (?, ?)";
                try (PreparedStatement pstSeat = conn.prepareStatement(insertSeatSql)) {
                    for (String seat : seatsArray) {
                        pstSeat.setString(1, scheduleId);
                        pstSeat.setString(2, seat.trim());
                        pstSeat.addBatch();
                    }
                    pstSeat.executeBatch();
                }
            }

            conn.commit();

            double pricePerPax = "Premium".equalsIgnoreCase(type) ? (basePrice * 1.1) : basePrice;
            double insuranceTotal = hasInsurance ? (qty * 1.20) : 0.0;
            double totalPayable = (qty * pricePerPax) + insuranceTotal;

            HttpSession session = request.getSession();
            session.setAttribute("schedule_id", scheduleId); // FIXED: Critical data bind saved for PaymentServlet
            session.setAttribute("fromLocation", (origin != null) ? origin : "Unknown");
            session.setAttribute("toLocation", (destination != null) ? destination : "Unknown");
            session.setAttribute("bookingType", type);
            session.setAttribute("bookingQty", qty);
            session.setAttribute("seats", selectedSeats);
            session.setAttribute("totalAmount", String.format("%.2f", totalPayable));

            response.sendRedirect("paymentSelection.jsp");

       } catch (NumberFormatException nfe) {
            System.out.println("[PaymentServlet Error] Number parsing exception: " + nfe.getMessage());
            response.sendRedirect("paymentSelection.jsp?error=bad_data_format");
        } catch (Exception e) {
            // EXPLICIT DEBUGGING: Prints the real database issue straight to your web browser URL!
            e.printStackTrace(); 
            String realMessage = e.getMessage() != null ? e.getMessage() : "Unknown_Database_Error";
            // Clean up string spaces to prevent browser crash rendering
            realMessage = realMessage.replace(" ", "_"); 
            response.sendRedirect("paymentSelection.jsp?error=" + realMessage);
        }
    }
}
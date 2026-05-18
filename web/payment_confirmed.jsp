<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.sani.DBConnection" %>
<%
    // Fallback values to prevent 'null' display if session expires
    String amount = (session.getAttribute("totalAmount") != null) ? session.getAttribute("totalAmount").toString() : "0.00";
    
    // Read the transaction ID dynamically from the URL string parameters, or fall back to the session
    String txId = request.getParameter("id");
    if (txId == null || txId.trim().isEmpty()) {
        txId = (session.getAttribute("lastTransactionId") != null) ? session.getAttribute("lastTransactionId").toString() : "N/A";
    }
    
    // Retrieve seat numbers directly from the session backup structure safely
    String seatNumbers = (session.getAttribute("seats") != null) ? session.getAttribute("seats").toString() : "Assigned at Gate";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Confirmed - SANI</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; font-family: 'Poppins', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 20px; box-sizing: border-box; }
        .receipt-card { background: white; padding: 35px; border-radius: 25px; width: 480px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); text-align: center; border-top: 12px solid #2b1c1a; }
        .success-icon { font-size: 55px; color: #4CAF50; margin-bottom: 10px; }
        .section-title { font-size: 0.75rem; font-weight: 800; color: #888; text-transform: uppercase; text-align: left; margin: 18px 0 6px 0; letter-spacing: 1px; }
        .details-box { background: #f9f9f9; padding: 18px; border-radius: 15px; margin-bottom: 15px; text-align: left; font-size: 14px; border: 1px solid #f0f0f0; }
        .detail-row { display: flex; justify-content: space-between; margin-bottom: 8px; border-bottom: 1px dashed #eee; padding-bottom: 6px; }
        .detail-row:last-child { margin-bottom: 0; border-bottom: none; padding-bottom: 0; }
        .detail-row span { color: #666; }
        .detail-row strong { color: #2b1c1a; }
        .qr-section { margin: 20px 0; padding: 15px; border: 2px dashed #ddd; border-radius: 15px; background: #fff; }
        .qr-section h4 { margin: 0 0 10px 0; color: #2b1c1a; letter-spacing: 1px; }
        .btn-home { background: #2b1c1a; color: white; padding: 14px 30px; border-radius: 10px; text-decoration: none; font-weight: 700; display: inline-block; margin-top: 10px; width: 80%; box-sizing: border-box; transition: 0.3s; }
        .btn-home:hover { background: #402b28; }
        .print-btn { background:none; border:1px solid #ccc; padding:10px 20px; border-radius:8px; cursor:pointer; margin-bottom:10px; font-weight: 600; font-family: 'Poppins', sans-serif; transition: 0.3s; }
        .print-btn:hover { background: #eee; }
        @media print { .btn-home, .print-btn, .section-title:first-of-type { display: none; } body { background: white; } .receipt-card { box-shadow: none; border: none; padding: 0; width: 100%; } }
    </style>
</head>
<body>
    <div class="receipt-card">
        <i class="fa-solid fa-circle-check success-icon"></i>
        <h2 style="margin: 0; color: #2b1c1a;">Payment Successful!</h2>
        <p style="color: #666; font-size: 14px; margin-top: 5px;">Thank you for choosing SANI Express.</p>

        <%
            // Complex database lookups to aggregate complete relational information sets
            String sql = "SELECT p.*, s.origin, s.destination, s.travel_date, s.departure_time, s.bus_name, " +
                         "u.fullname, u.email, u.phone " +
                         "FROM payments p " +
                         "INNER JOIN schedules s ON p.schedule_id = s.id " +
                         "INNER JOIN users u ON p.user_id = u.id " +
                         "WHERE p.transaction_id = ?";

            try (Connection con = DBConnection.getConnection()) {
                if (con != null && !txId.equals("N/A")) {
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, txId);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
        %>
                                <div class="section-title">Passenger Details</div>
                                <div class="details-box">
                                    <div class="detail-row">
                                        <span>Passenger Name:</span>
                                        <strong><%= rs.getString("fullname") %></strong>
                                    </div>
                                    <div class="detail-row">
                                        <span>Email:</span>
                                        <strong><%= rs.getString("email") %></strong>
                                    </div>
                                    <div class="detail-row">
                                        <span>Phone:</span>
                                        <strong><%= rs.getString("phone") %></strong>
                                    </div>
                                </div>

                                <div class="section-title">Bus & Ticket Details</div>
                                <div class="details-box">
                                    <div class="detail-row">
                                        <span>Bus Service:</span>
                                        <strong>SANI EXPRESS (<%= rs.getString("bus_name") %>)</strong>
                                    </div>
                                    <div class="detail-row">
                                        <span>Route:</span>
                                        <strong style="text-transform: uppercase;"><%= rs.getString("origin") %> &rarr; <%= rs.getString("destination") %></strong>
                                    </div>
                                    <div class="detail-row">
                                        <span>Travel Date:</span>
                                        <strong><%= rs.getString("travel_date") %></strong>
                                    </div>
                                    <div class="detail-row">
                                        <span>Departure Time:</span>
                                        <strong><%= rs.getString("departure_time").substring(0, 5) %></strong>
                                    </div>
                                    <div class="detail-row">
                                        <span>Seat Number(s):</span>
                                        <strong style="color: #e32626; font-size: 15px;"><%= seatNumbers %></strong>
                                    </div>
                                </div>
        <%
                            }
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("[payment_confirmation.jsp Error] " + e.getMessage());
            }
        %>

        <div class="section-title">Transaction Summary</div>
        <div class="details-box">
            <div class="detail-row">
                <span>Transaction ID:</span>
                <strong style="font-family: monospace;"><%= txId %></strong>
            </div>
            <div class="detail-row">
                <span>Amount Paid:</span>
                <strong style="color: #2b1c1a;">RM <%= amount %></strong>
            </div>
            <div class="detail-row">
                <span>Status:</span>
                <span style="color: #4CAF50; font-weight: 700;">PAID</span>
            </div>
        </div>

        <div class="qr-section">
            <h4>BOARDING PASS QR</h4>
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=<%= txId %>" alt="Boarding Pass QR">
            <p style="font-size: 12px; color: #888; margin-top: 8px; margin-bottom: 0;">Scan this barcode at the terminal gate checkpoint</p>
        </div>

        <button class="print-btn" onclick="window.print()">
            <i class="fa-solid fa-print"></i> Print Ticket / Pass
        </button>

        <br>
        <a href="student_home.jsp" class="btn-home">BACK TO HOME</a>
    </div>
</body>
</html>
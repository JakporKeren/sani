<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.sani.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Boarding Pass & Receipt - SANI</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; font-family: 'Poppins', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 20px; box-sizing: border-box; }
        .pass-card { background: white; padding: 40px; border-radius: 30px; width: 450px; box-shadow: 0 20px 40px rgba(0,0,0,0.1); text-align: center; border-top: 15px solid #2b1c1a; position: relative; }
        .success-banner { background: #e6f4ea; color: #137333; padding: 15px; border-radius: 15px; font-weight: 600; margin-bottom: 25px; display: flex; align-items: center; justify-content: center; gap: 10px; font-size: 0.95rem; }
        .expired-overlay { color: #d9534f; }
        .section-title { font-size: 0.75rem; font-weight: 800; color: #888; text-transform: uppercase; text-align: left; margin: 15px 0 5px 0; letter-spacing: 1px; }
        .info-box { background: #f9f9f9; padding: 20px; border-radius: 20px; text-align: left; margin-bottom: 15px; border: 1px solid #f0f0f0; }
        .info-row { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; }
        .info-row:last-child { margin-bottom: 0; }
        .info-row strong { color: #2b1c1a; }
        .info-row span { color: #555; }
        .route-header { font-size: 1.3rem; font-weight: 800; color: #2b1c1a; margin: 10px 0; text-transform: uppercase; }
        .btn-nav { display: block; margin-top: 20px; background: #2b1c1a; color: white; padding: 15px; border-radius: 12px; text-decoration: none; font-weight: bold; font-size: 0.95rem; transition: 0.3s; }
        .btn-nav:hover { background: #402b28; }
        .qr-placeholder { margin: 15px 0; padding: 10px; background: white; display: inline-block; border: 1px solid #eee; border-radius: 15px; }
    </style>
</head>
<body>
    <div class="pass-card">
        <%
            String txId = request.getParameter("id");
            Timestamp now = new Timestamp(System.currentTimeMillis());

            // Expanded query to join payments, schedules, AND users tables for full metadata visibility
            String sql = "SELECT p.*, s.origin, s.destination, s.travel_date, s.departure_time, s.bus_name, " +
                         "u.fullname, u.email, u.phone " +
                         "FROM payments p " +
                         "INNER JOIN schedules s ON p.schedule_id = s.id " +
                         "INNER JOIN users u ON p.user_id = u.id " +
                         "WHERE p.transaction_id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                 
                ps.setString(1, txId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String travelDate = rs.getString("travel_date");
                        String depTime = rs.getString("departure_time");
                        
                        // Append seconds fallback safety check for timestamp evaluation
                        String cleanTime = (depTime.length() == 5) ? depTime + ":00" : depTime;
                        Timestamp fullDeparture = Timestamp.valueOf(travelDate + " " + cleanTime);
                        boolean isExpired = fullDeparture.before(now);

                        if (isExpired) {
        %>
                            <i class="fa-solid fa-circle-exclamation" style="font-size: 60px; color: #d9534f; margin-bottom: 20px;"></i>
                            <h2 class="expired-overlay">BOARDING PASS CLOSED</h2>
                            <p>The departure time for this trip (<strong><%= travelDate %></strong>) has already passed.</p>
        <%
                        } else {
                            // Retrieve seat numbers directly from the session backup structure safely
                            String seatNumbers = (session.getAttribute("seats") != null) ? (String) session.getAttribute("seats") : "Assigned at Gate";
        %>
                            <div class="success-banner">
                                <i class="fa-solid fa-circle-check" style="font-size: 20px;"></i>
                                <span>PAYMENT SUCCESSFUL</span>
                            </div>

                            <h2 style="margin: 0; color: #2b1c1a; letter-spacing: 2px;">BOARDING PASS</h2>
                            <p style="font-size: 0.8rem; color: #888; margin-top: 5px; font-weight: 600;">SANI EXPRESS — <%= rs.getString("bus_name") %></p>
                            
                            <div class="route-header">
                                <%= rs.getString("origin") %> 
                                <i class="fa-solid fa-arrow-right" style="font-size: 0.9rem; margin: 0 8px; color: #d8a19a;"></i> 
                                <%= rs.getString("destination") %>
                            </div>

                            <div class="section-title">Passenger Details</div>
                            <div class="info-box">
                                <div class="info-row">
                                    <span>Name:</span>
                                    <strong><%= rs.getString("fullname") %></strong>
                                </div>
                                <div class="info-row">
                                    <span>Contact Email:</span>
                                    <span><%= rs.getString("email") %></span>
                                </div>
                                <div class="info-row">
                                    <span>Phone Number:</span>
                                    <span><%= rs.getString("phone") %></span>
                                </div>
                            </div>

                            <div class="section-title">Trip Details</div>
                            <div class="info-box">
                                <div class="info-row">
                                    <span><i class="fa-solid fa-calendar-day" style="width:18px;"></i> Travel Date:</span>
                                    <strong><%= travelDate %></strong>
                                </div>
                                <div class="info-row">
                                    <span><i class="fa-solid fa-clock" style="width:18px;"></i> Departure:</span>
                                    <strong><%= depTime.substring(0,5) %></strong>
                                </div>
                                <div class="info-row">
                                    <span><i class="fa-solid fa-chair" style="width:18px;"></i> Seat Number(s):</span>
                                    <strong style="color: #e32626; font-size: 1.05rem;"><%= seatNumbers %></strong>
                                </div>
                            </div>

                            <div class="section-title">Payment Transaction</div>
                            <div class="info-box" style="background: #fffdfd;">
                                <div class="info-row">
                                    <span>Amount Paid:</span>
                                    <strong>RM <%= rs.getString("amount") %></strong>
                                </div>
                                <div class="info-row">
                                    <span>Payment Method:</span>
                                    <span style="text-transform: uppercase; font-weight: 600;"><%= rs.getString("payment_method") %></span>
                                </div>
                                <div class="info-row" style="font-size: 0.75rem; border-top: 1px dashed #eee; padding-top: 8px; margin-top: 8px;">
                                    <span>Transaction ID:</span>
                                    <span style="font-family: monospace;"><%= txId %></span>
                                </div>
                            </div>

                            <div class="qr-placeholder">
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=<%= txId %>" alt="Boarding QR Code">
                            </div>
                            <p style="font-size: 0.75rem; color: #999; margin: 0 0 10px 0;">Scan this barcode at the terminal gate checkpoint</p>
        <%
                        }
                    } else {
                        out.println("<div class='info-box'><h3>Error: Ticket or Payment confirmation record not found.</h3></div>");
                    }
                }
            } catch (Exception e) { 
                out.println("<div class='info-box'><h3>System Error: " + e.getMessage() + "</h3></div>"); 
            }
        %>
        
        <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
        <a href="my_tickets.jsp" class="btn-nav">VIEW ALL MY TICKETS</a>
        <a href="student_home.jsp" style="display:block; margin-top:15px; color:#2b1c1a; font-size:0.9rem; text-decoration:none; font-weight:600;">Go to Dashboard</a>
    </div>
</body>
</html>
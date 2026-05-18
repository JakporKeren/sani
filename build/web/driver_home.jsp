<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" import="java.sql.*, java.util.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    String tab = request.getParameter("tab");
    if (tab == null) tab = "schedule";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Panel - SANI BUS</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --pink-bg: #d8a19a;
            --dark-brown: #2b1c1a;
            --white: #ffffff;
            --card-bg: #f5e1de;
            --light-text: #8c7673;
            --border-light: #f0e8e6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--pink-bg);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        /* TOP NAVBAR */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 50px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .nav-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-left .bus-logo {
            background: #fff;
            padding: 5px 8px;
            border-radius: 8px;
            font-size: 18px;
        }

        .nav-left .brand-name {
            font-weight: 800;
            font-style: italic;
            font-size: 22px;
            color: var(--dark-brown);
            letter-spacing: -0.5px;
        }

        .nav-center {
            display: flex;
            gap: 10px;
        }

        .nav-btn {
            text-decoration: none;
            color: var(--dark-brown);
            font-weight: 700;
            font-size: 12px;
            padding: 10px 20px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
            letter-spacing: 0.5px;
            border: 1px solid rgba(43,28,26,0.15);
        }

        .nav-btn:hover {
            background: rgba(43,28,26,0.05);
        }

        .nav-btn.active {
            background: var(--dark-brown);
            color: white;
            border-color: var(--dark-brown);
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-icon-btn {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            border: 1px solid rgba(43,28,26,0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--dark-brown);
            font-size: 16px;
            cursor: pointer;
            background: none;
            position: relative;
            transition: 0.3s;
        }

        .nav-icon-btn:hover {
            background: rgba(255,255,255,0.3);
        }

        .nav-icon-btn .badge {
            position: absolute;
            top: -3px;
            right: -3px;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #e74c3c;
        }

        .lang-btn {
            font-weight: 800;
            font-size: 12px;
        }

        .user-meta {
            text-align: right;
            display: flex;
            flex-direction: column;
            margin-left: 8px;
        }

        .user-name {
            font-weight: 800;
            color: var(--dark-brown);
            font-size: 14px;
            line-height: 1.2;
        }

        .user-role {
            font-size: 9px;
            font-weight: 600;
            color: var(--light-text);
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .avatar-container {
            background: white;
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--dark-brown);
            font-size: 18px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .logout-btn {
            color: var(--dark-brown);
            font-size: 20px;
            opacity: 0.6;
            transition: 0.3s;
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        .logout-btn:hover {
            opacity: 1;
        }

        /* MAIN CONTENT */
        .main-content {
            max-width: 1100px;
            margin: 0 auto;
            padding: 30px 40px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 800;
            color: var(--dark-brown);
            margin: 0;
        }

        .page-header .subtitle {
            font-size: 13px;
            color: var(--light-text);
            margin-top: 4px;
        }

        .tab-buttons {
            display: flex;
            gap: 10px;
        }

        .tab-btn {
            padding: 10px 22px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 12px;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            border: 1px solid rgba(43,28,26,0.15);
            color: var(--dark-brown);
            background: none;
        }

        .tab-btn.active {
            background: var(--dark-brown);
            color: white;
            border-color: var(--dark-brown);
        }

        .tab-btn:hover:not(.active) {
            background: rgba(43,28,26,0.05);
        }

        /* SCHEDULE CARD */
        .schedule-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
            margin-bottom: 20px;
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 15px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-light);
            margin-bottom: 20px;
        }

        .bus-icon-box {
            background: #f5f0ee;
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: var(--dark-brown);
        }

        .card-header-text .booking-ref {
            font-size: 10px;
            font-weight: 600;
            color: var(--light-text);
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .card-header-text .operator-name {
            font-size: 18px;
            font-weight: 800;
            color: var(--dark-brown);
            margin-top: 2px;
        }

        .card-details {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr;
            gap: 20px;
            align-items: start;
        }

        .detail-group {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .detail-item .detail-label {
            font-size: 10px;
            font-weight: 600;
            color: var(--light-text);
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .detail-item .detail-label i {
            font-size: 13px;
            color: var(--light-text);
        }

        .detail-item .detail-value {
            font-size: 15px;
            font-weight: 700;
            color: var(--dark-brown);
        }

        .detail-item .detail-value.large {
            font-size: 20px;
            font-weight: 800;
        }

        .seats-list {
            display: flex;
            gap: 8px;
            margin-top: 4px;
        }

        .seat-badge {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: #f5f0ee;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
            color: var(--dark-brown);
            border: 1px solid var(--border-light);
        }

        .assigned-seats-section {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }

        .assigned-seats-section .detail-label {
            font-size: 10px;
            font-weight: 600;
            color: var(--light-text);
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        /* EMPTY STATE */
        .empty-state {
            background: rgba(255,255,255,0.3);
            border-radius: 20px;
            padding: 60px;
            text-align: center;
            color: var(--light-text);
        }

        .empty-state i {
            font-size: 40px;
            margin-bottom: 15px;
            opacity: 0.4;
        }

        .empty-state p {
            font-size: 14px;
        }

        /* EMERGENCY LEAVE PAGE */
        .cancel-btn-row {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
        }

        .cancel-btn {
            background: var(--dark-brown);
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
        }

        .cancel-btn:hover {
            background: #452d2a;
        }

        .leave-form-card {
            background: white;
            border-radius: 20px;
            padding: 35px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
            margin-bottom: 35px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-group label {
            font-size: 10px;
            font-weight: 700;
            color: var(--light-text);
            letter-spacing: 1px;
            text-transform: uppercase;
            display: block;
            margin-bottom: 8px;
        }

        .form-group select,
        .form-group input[type="date"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--border-light);
            border-radius: 12px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            color: var(--dark-brown);
            background: var(--white);
            outline: none;
            transition: 0.3s;
        }

        .form-group select:focus,
        .form-group input[type="date"]:focus,
        .form-group textarea:focus {
            border-color: var(--dark-brown);
            box-shadow: 0 0 5px rgba(43, 28, 26, 0.1);
        }

        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 1px solid var(--border-light);
            border-radius: 12px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            color: var(--dark-brown);
            resize: vertical;
            min-height: 100px;
            outline: none;
            transition: 0.3s;
        }

        .reason-group {
            margin-bottom: 25px;
        }

        .reason-group label {
            font-size: 10px;
            font-weight: 700;
            color: var(--light-text);
            letter-spacing: 1px;
            text-transform: uppercase;
            display: block;
            margin-bottom: 8px;
        }

        .submit-btn {
            background: var(--dark-brown);
            color: white;
            border: none;
            padding: 14px 30px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: 0.3s;
        }

        .submit-btn:hover {
            background: #452d2a;
            transform: translateY(-1px);
        }

        .leave-history-section h2 {
            font-size: 18px;
            font-weight: 700;
            color: var(--dark-brown);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .leave-history-empty {
            background: rgba(255,255,255,0.3);
            border-radius: 20px;
            padding: 50px;
            text-align: center;
            color: var(--light-text);
        }

        .leave-history-empty i {
            font-size: 36px;
            margin-bottom: 12px;
            opacity: 0.4;
        }

        /* Leave history table */
        .leave-history-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.04);
        }

        .leave-history-table thead th {
            background: #f9f6f5;
            padding: 12px 18px;
            text-align: left;
            font-size: 10px;
            font-weight: 700;
            color: var(--light-text);
            letter-spacing: 1px;
            text-transform: uppercase;
            border-bottom: 1px solid var(--border-light);
        }

        .leave-history-table tbody td {
            padding: 14px 18px;
            font-size: 13px;
            color: var(--dark-brown);
            border-bottom: 1px solid var(--border-light);
        }

        .leave-history-table tbody tr:last-child td {
            border-bottom: none;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 11px;
            font-weight: 600;
            display: inline-block;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }

        /* SUCCESS/ERROR MESSAGES */
        .alert {
            padding: 12px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>

    <!-- TOP NAVIGATION -->
    <nav class="top-nav">
        <div class="nav-left">
            <span class="bus-logo">🚌</span>
            <span class="brand-name">SANIBUS</span>
        </div>

        <div class="nav-center">
            <a href="manager_home.jsp" class="nav-btn">
                <i class="fa-solid fa-location-dot"></i> MANAGER PANEL
            </a>
            <a href="driver_home.jsp" class="nav-btn active">
                <i class="fa-solid fa-grid-2"></i> DRIVER PANEL
            </a>
        </div>

        <div class="nav-right">
            <button class="nav-icon-btn">
                <i class="fa-solid fa-bell"></i>
                <span class="badge"></span>
            </button>
            <button class="nav-icon-btn lang-btn">BM</button>

            <div class="user-meta">
                <span class="user-name"><%= username %></span>
                <span class="user-role">DRIVER</span>
            </div>
            <div class="avatar-container">
                <i class="fa-regular fa-user"></i>
            </div>
            <a href="LogoutServlet" class="logout-btn" title="Logout">
                <i class="fa-solid fa-arrow-right-from-bracket"></i>
            </a>
        </div>
    </nav>

    <div class="main-content">

        <% if ("schedule".equals(tab)) { %>
        <!-- ===== MY DRIVING SCHEDULE VIEW ===== -->
        <div class="page-header">
            <div>
                <h1>My Driving Schedule</h1>
                <p class="subtitle">View your assigned trips and routes</p>
            </div>
            <div class="tab-buttons">
                <a href="driver_home.jsp?tab=schedule" class="tab-btn active">MY DRIVING SCHEDULE</a>
                <a href="driver_home.jsp?tab=leave" class="tab-btn">EMERGENCY LEAVE</a>
            </div>
        </div>

        <%
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            boolean found = false;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/bus_system", "root", "");

                String sql = "SELECT ds.id as assignment_id, ds.booking_ref, ds.assigned_bus, " +
                             "s.id as schedule_id, s.bus_name, s.origin, s.destination, " +
                             "s.departure_time, s.arrival_time " +
                             "FROM driver_schedules ds " +
                             "JOIN schedules s ON ds.schedule_id = s.id " +
                             "WHERE ds.driver_username = ? " +
                             "ORDER BY s.departure_time ASC";

                pst = conn.prepareStatement(sql);
                pst.setString(1, username);
                rs = pst.executeQuery();

                while (rs.next()) {
                    found = true;
                    String bookingRef = rs.getString("booking_ref");
                    String busName = rs.getString("bus_name");
                    String origin = rs.getString("origin");
                    String destination = rs.getString("destination");
                    Time depTime = rs.getTime("departure_time");
                    Time arrTime = rs.getTime("arrival_time");
                    String assignedBus = rs.getString("assigned_bus");
                    int scheduleId = rs.getInt("schedule_id");

                    long diff = arrTime.getTime() - depTime.getTime();
                    if (diff < 0) diff += 24 * 60 * 60 * 1000;
                    long hours = diff / 3600000;
                    long mins = (diff % 3600000) / 60000;

                    // Get booked seats for this schedule
                    PreparedStatement seatPst = conn.prepareStatement(
                        "SELECT seat_number FROM booked_seats WHERE schedule_id = ? ORDER BY seat_number");
                    seatPst.setInt(1, scheduleId);
                    ResultSet seatRs = seatPst.executeQuery();
                    List<String> seats = new ArrayList<>();
                    while (seatRs.next()) {
                        seats.add(seatRs.getString("seat_number"));
                    }
                    seatRs.close();
                    seatPst.close();
                    int numPassengers = seats.size();
        %>
        <div class="schedule-card">
            <div class="card-header">
                <div class="bus-icon-box">
                    <i class="fa-solid fa-bus"></i>
                </div>
                <div class="card-header-text">
                    <div class="booking-ref">BOOKING REF: <%= bookingRef != null ? bookingRef : "N/A" %></div>
                    <div class="operator-name"><%= busName != null ? busName : "SANI EXPRESS" %></div>
                </div>
            </div>

            <div class="card-details">
                <div class="detail-group">
                    <div class="detail-item">
                        <div class="detail-label"><i class="fa-solid fa-location-dot"></i> TRIP DETAILS</div>
                        <div class="detail-value"><%= origin %> &#10132; <%= destination %></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label"><i class="fa-regular fa-clock"></i> DEPARTURE</div>
                        <div class="detail-value large"><%= depTime.toString().substring(0, 5) %> (<%= hours %>H <%= mins %>M)</div>
                    </div>
                </div>

                <div class="detail-group">
                    <div class="detail-item">
                        <div class="detail-label"><i class="fa-solid fa-bus"></i> ASSIGNED BUS</div>
                        <div class="detail-value"><%= assignedBus != null ? assignedBus : "N/A" %></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label"><i class="fa-solid fa-users"></i> PASSENGERS</div>
                        <div class="detail-value"><%= numPassengers %> Pax</div>
                    </div>
                </div>

                <div class="assigned-seats-section">
                    <div class="detail-label">ASSIGNED SEATS</div>
                    <div class="seats-list">
                        <% if (seats.isEmpty()) { %>
                            <span style="color: var(--light-text); font-size: 13px;">None</span>
                        <% } else {
                            for (String seat : seats) { %>
                                <div class="seat-badge"><%= seat %></div>
                        <%  }
                           } %>
                    </div>
                </div>
            </div>
        </div>
        <%
                }

                if (!found) {
        %>
        <div class="empty-state">
            <i class="fa-solid fa-calendar-xmark"></i>
            <p>No driving schedules assigned yet.</p>
        </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
        <div class="empty-state">
            <i class="fa-solid fa-circle-exclamation"></i>
            <p>Unable to load driving schedules.</p>
        </div>
        <%
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (pst != null) try { pst.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        %>

        <% } else if ("leave".equals(tab)) { %>
        <!-- ===== EMERGENCY LEAVE VIEW ===== -->
        <div class="page-header">
            <div>
                <h1>Emergency Leave</h1>
                <p class="subtitle">Manage your leave applications and status</p>
            </div>
            <div class="tab-buttons">
                <a href="driver_home.jsp?tab=schedule" class="tab-btn">MY DRIVING SCHEDULE</a>
                <a href="driver_home.jsp?tab=leave" class="tab-btn active">EMERGENCY LEAVE</a>
            </div>
        </div>

        <%
            String msg = request.getParameter("msg");
            if ("success".equals(msg)) {
        %>
        <div class="alert alert-success">
            <i class="fa-solid fa-check-circle"></i> Leave application submitted successfully!
        </div>
        <% } else if ("error".equals(msg)) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-exclamation-circle"></i> Failed to submit leave application. Please try again.
        </div>
        <% } else if ("cancelled".equals(msg)) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-check-circle"></i> Leave application cancelled successfully.
        </div>
        <% } %>

        <div class="cancel-btn-row">
            <a href="driver_home.jsp?tab=schedule" class="cancel-btn">
                <i class="fa-solid fa-circle-xmark"></i> Cancel
            </a>
        </div>

        <div class="leave-form-card">
            <form action="DriverLeaveServlet" method="POST" id="leaveForm">
                <input type="hidden" name="action" value="submit">
                <div class="form-row">
                    <div class="form-group">
                        <label>LEAVE TYPE</label>
                        <select name="leaveType" id="leaveType" onchange="toggleReason()">
                            <option value="Emergency">Emergency</option>
                            <option value="Annual">Annual</option>
                            <option value="Medical">Medical</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>START DATE</label>
                        <input type="date" name="startDate" required>
                    </div>
                    <div class="form-group">
                        <label>END DATE</label>
                        <input type="date" name="endDate" required>
                    </div>
                </div>

                <div class="reason-group" id="reasonGroup">
                    <label>REASON</label>
                    <textarea name="reason" placeholder="Please provide a detailed reason for your leave request"></textarea>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fa-solid fa-paper-plane"></i> Submit Application
                </button>
            </form>
        </div>

        <!-- LEAVE HISTORY -->
        <div class="leave-history-section">
            <h2><i class="fa-solid fa-calendar-days"></i> Leave History</h2>

            <%
                Connection leaveConn = null;
                PreparedStatement leavePst = null;
                ResultSet leaveRs = null;
                boolean hasLeaves = false;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    leaveConn = DriverManager.getConnection("jdbc:mysql://localhost:3307/bus_system", "root", "");

                    leavePst = leaveConn.prepareStatement(
                        "SELECT * FROM driver_leaves WHERE driver_username = ? ORDER BY created_at DESC");
                    leavePst.setString(1, username);
                    leaveRs = leavePst.executeQuery();

                    if (leaveRs.isBeforeFirst()) {
                        hasLeaves = true;
            %>
            <table class="leave-history-table">
                <thead>
                    <tr>
                        <th>Type</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Applied On</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (leaveRs.next()) {
                            String leaveType = leaveRs.getString("leave_type");
                            String startDate = leaveRs.getString("start_date");
                            String endDate = leaveRs.getString("end_date");
                            String reason = leaveRs.getString("reason");
                            String status = leaveRs.getString("status");
                            String createdAt = leaveRs.getString("created_at");

                            String statusClass = "status-pending";
                            if ("Approved".equalsIgnoreCase(status)) statusClass = "status-approved";
                            else if ("Rejected".equalsIgnoreCase(status)) statusClass = "status-rejected";
                    %>
                    <tr>
                        <td><strong><%= leaveType %></strong></td>
                        <td><%= startDate %></td>
                        <td><%= endDate %></td>
                        <td><%= reason != null && !reason.isEmpty() ? reason : "-" %></td>
                        <td><span class="status-badge <%= statusClass %>"><%= status %></span></td>
                        <td><%= createdAt != null ? createdAt.substring(0, 10) : "-" %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                    }

                    if (!hasLeaves) {
            %>
            <div class="leave-history-empty">
                <i class="fa-solid fa-circle-exclamation"></i>
                <p>No leave applications found.</p>
            </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
            <div class="leave-history-empty">
                <i class="fa-solid fa-circle-exclamation"></i>
                <p>No leave applications found.</p>
            </div>
            <%
                } finally {
                    if (leaveRs != null) try { leaveRs.close(); } catch (Exception e) {}
                    if (leavePst != null) try { leavePst.close(); } catch (Exception e) {}
                    if (leaveConn != null) try { leaveConn.close(); } catch (Exception e) {}
                }
            %>
        </div>

        <% } %>
    </div>

    <script>
        function toggleReason() {
            var leaveType = document.getElementById('leaveType').value;
            var reasonGroup = document.getElementById('reasonGroup');
            if (leaveType === 'Annual') {
                reasonGroup.style.display = 'none';
            } else {
                reasonGroup.style.display = 'block';
            }
        }
        // Initialize on page load
        if (document.getElementById('leaveType')) {
            toggleReason();
        }
    </script>

</body>
</html>

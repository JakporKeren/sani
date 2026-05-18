<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" import="java.sql.*, java.util.*" %>
<%
    String scheduleId = request.getParameter("id");
    if (scheduleId == null) {
        response.sendRedirect("student_home.jsp");
        return;
    }

    double dbPrice = 0.0;
    String dbOrigin = "", dbDest = "";
    Set<String> takenSeats = new HashSet<>();

    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/bus_system", "root", "");

        PreparedStatement pst = conn.prepareStatement("SELECT * FROM schedules WHERE id = ?");
        pst.setString(1, scheduleId);
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            dbPrice = rs.getDouble("price");
            dbOrigin = rs.getString("origin");
            dbDest = rs.getString("destination");
        }

        PreparedStatement pst2 = conn.prepareStatement("SELECT seat_number FROM booked_seats WHERE schedule_id = ?");
        pst2.setString(1, scheduleId);
        ResultSet rs2 = pst2.executeQuery();
        while (rs2.next()) {
            takenSeats.add(rs2.getString("seat_number"));
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (conn != null) {
            conn.close();
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Booking Details - SANI BUS</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">

        <style>
            :root {
                --pink-bg: #d8a19a;
                --dark-brown: #2b1c1a;
                --white: #ffffff;
                --card-bg: #f5e1de;
                --seat-green: #27ae60;
            }

            body {
                font-family: 'Poppins', sans-serif;
                background-color: var(--pink-bg);
                margin: 0;
                padding: 0;
            }

            /* UPDATED NAVIGATION STYLING BASED ON image_9d4f5f.png */
            .top-nav {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 50px;
                background: transparent;
                border-bottom: 1px solid rgba(0,0,0,0.05);
            }

            .nav-left span {
                font-weight: 800;
                font-style: italic;
                font-size: 24px;
                color: var(--dark-brown);
                letter-spacing: -0.5px;
            }

            .nav-center {
                display: flex;
                gap: 20px;
                background: rgba(255, 255, 255, 0.1);
                padding: 5px;
                border-radius: 15px;
            }

            .nav-btn {
                text-decoration: none;
                color: var(--dark-brown);
                font-weight: 800;
                font-size: 14px;
                padding: 12px 25px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                gap: 10px;
                transition: 0.3s;
            }

            .nav-btn.active {
                background: var(--dark-brown);
                color: white;
            }

            .nav-right {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .user-meta {
                text-align: right;
                display: flex;
                flex-direction: column;
            }

            .user-name {
                font-weight: 800;
                color: var(--dark-brown);
                font-size: 15px;
                line-height: 1.2;
            }

            .user-role {
                font-size: 10px;
                font-weight: 600;
                color: rgba(43, 28, 26, 0.6);
                letter-spacing: 1px;
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
            }

            .logout-btn {
                color: var(--dark-brown);
                font-size: 20px;
                opacity: 0.7;
                transition: 0.3s;
            }

            .logout-btn:hover {
                opacity: 1;
            }

            /* MAIN CONTENT STYLING */
            .container {
                max-width: 1200px;
                margin: 40px auto;
                display: flex;
                gap: 30px;
                padding: 0 20px;
            }

            .booking-main {
                flex: 2;
                background: var(--card-bg);
                border-radius: 40px;
                padding: 40px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            }

            .decks-wrapper {
                display: flex;
                justify-content: space-around;
                gap: 20px;
                background: white;
                padding: 30px;
                border-radius: 25px;
                margin-bottom: 20px;
            }

            .deck-box {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 20px;
                min-width: 220px;
            }

            .seat-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
            }

            .seat-group {
                display: flex;
                gap: 8px;
            }

            .seat-box {
                width: 42px;
                height: 42px;
                border: 2px solid var(--seat-green);
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: bold;
                cursor: pointer;
                background: white;
                color: var(--seat-green);
            }

            .seat-box.selected {
                background: var(--seat-green);
                color: white;
            }
            .seat-box.taken {
                background: white;
                color: #ccc;
                border-color: #eee;
                cursor: not-allowed;
                position: relative;
            }
            .seat-box.taken::after {
                content: 'X';
                position: absolute;
                font-size: 16px;
                color: #ddd;
            }

            .seat-guide {
                background: white;
                border-radius: 25px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .guide-table {
                width: 100%;
                border-collapse: collapse;
            }
            .guide-table th {
                text-align: left;
                padding-bottom: 10px;
                font-size: 14px;
                color: #888;
            }
            .guide-table td {
                padding: 8px 0;
                font-weight: 600;
                color: var(--dark-brown);
            }

            .extra-option-card {
                background: white;
                border-radius: 20px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .option-row {
                display: flex;
                align-items: center;
                justify-content: space-between;
                border: 1px solid #ddd;
                padding: 15px;
                border-radius: 15px;
                margin-top: 10px;
                cursor: pointer;
            }

            .option-row.active {
                border-color: var(--seat-green);
                background: #f0fff4;
            }

            .switch {
                position: relative;
                display: inline-block;
                width: 50px;
                height: 24px;
            }
            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }
            .slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: #ccc;
                transition: .4s;
                border-radius: 34px;
            }

            .slider:before {
                position: absolute;
                content: "";
                height: 16px;
                width: 16px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
            }

            input:checked + .slider {
                background-color: #ff4d4d;
            }
            input:checked + .slider:before {
                transform: translateX(26px);
            }

            .summary-sidebar {
                flex: 1;
                background: var(--dark-brown);
                color: white;
                border-radius: 40px;
                padding: 40px;
                height: fit-content;
                position: sticky;
                top: 40px;
            }

            .total-price {
                font-size: 36px;
                font-weight: 800;
                color: #ffcc00;
            }
            .btn-proceed {
                width: 100%;
                background: white;
                color: var(--dark-brown);
                border: none;
                padding: 18px;
                border-radius: 20px;
                font-weight: 800;
                cursor: pointer;
                margin-top: 20px;
            }
            
        </style>
    </head>
    <body>

        <!-- NAVIGATION BAR -->
        <nav class="top-nav">
            <div class="nav-left">
                <span>SANIBUS EXPRESS</span>
            </div>

            <div class="nav-center">
                <a href="student_home.jsp" class="nav-btn active"><i class="fa-solid fa-house"></i> DASHBOARD</a>
                <a href="my_tickets.jsp" class="nav-btn"><i class="fa-solid fa-ticket"></i> MY BOOKINGS</a>
            </div>

        <div class="nav-right">
    <!-- Pautan ke halaman kemas kini profil -->
    <a href="edit_profile.jsp" class="profile-link" style="text-decoration: none; display: flex; align-items: center; gap: 15px;">
        <div class="user-meta">
            <span class="user-name">
                <%= (session.getAttribute("username") != null) ? session.getAttribute("username") : "Guest" %>
            </span>
            <span class="user-role">PASSENGER</span>
        </div>
        <div class="avatar-container">
            <i class="fa-regular fa-user"></i>
        </div>
    </a>
    
    <a href="LogoutServlet" class="logout-btn" title="Logout">
        <i class="fa-solid fa-arrow-right-from-bracket"></i>
    </a>
</div>
        </nav>

        <div class="container">
            <div class="booking-main">
                <h2 style="margin-top:0;"><%= dbOrigin%> <i class="fa-solid fa-arrow-right"></i> <%= dbDest%></h2>

                <!-- SEAT SELECTION AREA -->
                <div class="decks-wrapper">
                    <!-- LOWER DECK -->
                    <div class="deck-box">
                        <div class="deck-header" style="margin-bottom:15px; font-weight:800;">Lower deck</div>
                        <% String[][] lowerGrid = {{"40", "41", "", "42"}, {"43", "44", "", "45"}, {"46", "47", "", "48"}, {"49", "50", "", "51"}, {"52", "53", "54", "55"}};
                            for (String[] row : lowerGrid) { %>
                        <div class="seat-row">
                            <div class="seat-group">
                                <% for (int j = 0; j < 2; j++) {%>
                                <div class="seat-box <%= takenSeats.contains(row[j]) ? "taken" : ""%>" onclick="toggleSeat(this, '<%=row[j]%>')"><%=row[j]%></div>
                                <% }%>
                            </div>
                            <div class="<%= row[2].equals("") ? "" : "seat-box"%> <%= takenSeats.contains(row[2]) ? "taken" : ""%>" style="width:40px; display:flex; align-items:center; justify-content:center;" onclick="<%= !row[2].equals("") ? "toggleSeat(this, '" + row[2] + "')" : ""%>"><%=row[2]%></div>
                            <div class="seat-box <%= takenSeats.contains(row[3]) ? "taken" : ""%>" onclick="toggleSeat(this, '<%=row[3]%>')"><%=row[3]%></div>
                        </div>
                        <% }%>
                    </div>

                    <!-- UPPER DECK -->
                    <div class="deck-box">
                        <div class="deck-header" style="margin-bottom:15px; font-weight:800;">Upper deck</div>
                        <% String[][] upperGrid = {{"01", "16", "17"}, {"02", "18", "19"}, {"03", "20", "21"}, {"04", "22", "23"}, {"05", "24", "25"}, {"06", "26", "27"}, {"07", "28", "29"}, {"08", "30", "31"}, {"09", "32", "33"}, {"10", "34", "35"}};
                            for (String[] row : upperGrid) {%>
                        <div class="seat-row">
                            <div class="seat-box <%= takenSeats.contains(row[0]) ? "taken" : ""%>" onclick="toggleSeat(this, '<%=row[0]%>')"><%=row[0]%></div>
                            <div style="width:40px;"></div>
                            <div class="seat-group">
                                <div class="seat-box <%= takenSeats.contains(row[1]) ? "taken" : ""%>" onclick="toggleSeat(this, '<%=row[1]%>')"><%=row[1]%></div>
                                <div class="seat-box <%= takenSeats.contains(row[2]) ? "taken" : ""%>" onclick="toggleSeat(this, '<%=row[2]%>')"><%=row[2]%></div>
                            </div>
                        </div>
                        <% }%>
                    </div>
                </div>

                <!-- SEAT GUIDE -->
                <div class="seat-guide">
                    <table class="guide-table">
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th style="text-align: right;">Seater</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Available</td>
                                <td style="text-align: right;"><div class="seat-box" style="display: inline-flex; cursor: default;"></div></td>
                            </tr>
                            <tr>
                                <td>Already booked</td>
                                <td style="text-align: right;"><div class="seat-box taken" style="display: inline-flex;"></div></td>
                            </tr>
                            <tr>
                                <td>Selected by you</td>
                                <td style="text-align: right;"><div class="seat-box selected" style="display: inline-flex; cursor: default;"></div></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- OPTIONS -->
                <div class="extra-option-card">
                    <h3>Travel insurance</h3>
                    <p style="font-size:13px; color:#666;">At just <span style="color:green; font-weight:bold;">RM 1</span> per passenger</p>     
                    <div class="option-row" onclick="setInsurance(true)" id="ins-yes">
                        <span>Yes, Protect my trip at RM 1 (per passenger)</span>
                        <input type="radio" name="ins_choice" id="ins-radio-yes">
                    </div>
                    <div class="option-row active" onclick="setInsurance(false)" id="ins-no">
                        <span>No, I would like to proceed without insurance</span>
                        <input type="radio" name="ins_choice" id="ins-radio-no" checked>
                    </div>
                </div>

                <div class="extra-option-card">
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <div>
                            <h3 style="margin:0;">Refund Guarantee</h3>
                            <p style="font-size:12px; color:#27ae60; margin:5px 0;"><i class="fa-solid fa-check"></i> Guaranteed 90% refund</p>
                            <span style="font-weight:bold; color:var(--seat-green);">RM 5.64 per passenger</span>
                        </div>
                        <label class="switch">
                            <input type="checkbox" id="refund-toggle" onchange="calculate()">
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
            </div>

            <!-- SUMMARY SIDEBAR -->
            <div class="summary-sidebar">
                <h3>SUMMARY</h3>
                <div style="display:flex; justify-content:space-between; margin-bottom:10px;"><span>Tickets Qty:</span> <span id="sum-qty">0</span></div>
                <div style="display:flex; justify-content:space-between; margin-bottom:10px;"><span>Insurance:</span> <span id="sum-ins">RM 0.00</span></div>
                <div style="display:flex; justify-content:space-between; margin-bottom:10px;"><span>Refund Fee:</span> <span id="sum-ref">RM 0.00</span></div>
                <hr style="border-color: rgba(255,255,255,0.1);">
                <div style="margin-top:20px;">
                    <span style="font-size:14px;">TOTAL PAYABLE</span>
                    <div class="total-price">RM <span id="sum-total">0.00</span></div>
                </div>

                <form action="ProcessBookingServlet" method="POST">
                    <input type="hidden" name="schedule_id" value="<%= scheduleId%>">
                    <input type="hidden" name="qty" id="form-qty" value="0">
                    <input type="hidden" name="insurance" id="form-ins" value="false">
                    <input type="hidden" name="refund_guarantee" id="form-refund" value="false">
                    <input type="hidden" name="selected_seats" id="form-seats" value="">
                    <input type="hidden" name="total_price" id="form-total" value="0">
                    <button type="submit" class="btn-proceed">PROCEED BOOKING</button>
                </form>
            </div>
        </div>

        <script>
            let qty = 0;
            let pricePerTicket = <%= dbPrice%>;
            let selectedSeats = [];
            let insuranceActive = false;
            let insurancePrice = 1.00;
            let refundPrice = 5.64;

            function toggleSeat(el, seatID) {
                if (!seatID || el.classList.contains('taken'))
                    return;
                if (el.classList.contains('selected')) {
                    el.classList.remove('selected');
                    selectedSeats = selectedSeats.filter(s => s !== seatID);
                } else {
                    el.classList.add('selected');
                    selectedSeats.push(seatID);
                }
                qty = selectedSeats.length;
                calculate();
            }

            function setInsurance(val) {
                insuranceActive = val;
                document.getElementById('ins-radio-yes').checked = val;
                document.getElementById('ins-radio-no').checked = !val;
                document.getElementById('ins-yes').classList.toggle('active', val);
                document.getElementById('ins-no').classList.toggle('active', !val);
                calculate();
            }

            function calculate() {
                let baseTotal = qty * pricePerTicket;
                let insTotal = insuranceActive ? (qty * insurancePrice) : 0;
                let refTotal = document.getElementById('refund-toggle').checked ? (qty * refundPrice) : 0;
                let final = baseTotal + insTotal + refTotal;

                document.getElementById('sum-qty').innerText = qty;
                document.getElementById('sum-ins').innerText = "RM " + insTotal.toFixed(2);
                document.getElementById('sum-ref').innerText = "RM " + refTotal.toFixed(2);
                document.getElementById('sum-total').innerText = final.toFixed(2);

                document.getElementById('form-qty').value = qty;
                document.getElementById('form-seats').value = selectedSeats.join(',');
                document.getElementById('form-ins').value = insuranceActive;
                document.getElementById('form-refund').value = document.getElementById('refund-toggle').checked;
                document.getElementById('form-total').value = final.toFixed(2);
            }
        </script>
    </body>
</html>
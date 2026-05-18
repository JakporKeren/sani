<%-- 
    Document   : student_home
    Created on : Apr 29, 2026, 8:28:36 PM
    Author     : Aisya Fazliyana Binti Azhar
--%>

<%@ page session="true" import="java.sql.*, java.util.*" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
    }

// Mengambil parameter carian daripada borang
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String travelDate = request.getParameter("travelDate");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SANI SCHEDULING SYSTEM</title>
        <!-- Fonts & Ikon -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            body {
                background-color: #d8a19a;
                margin: 0;
                padding: 0;
                font-family: 'Poppins', sans-serif;
                overflow-x: hidden;
            }

            /* TOP NAVBAR */
            .top-nav {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 40px;
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }

            .nav-center {
                display: flex;
                gap: 10px;
            }

            .nav-btn {
                background: none;
                border: none;
                padding: 10px 20px;
                font-weight: 600;
                cursor: pointer;
                border-radius: 12px;
                color: #2b1c1a;
                transition: 0.3s;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .nav-btn.active {
                background: #2b1c1a;
                color: white;
            }

            .nav-right {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .user-meta {
                text-align: right;
                line-height: 1.2;
            }

            .user-name {
                display: block;
                font-weight: 800;
                font-size: 16px;
                color: #2b1c1a;
            }

            .user-role {
                display: block;
                font-size: 10px;
                font-weight: 600;
                color: #8c7673;
                letter-spacing: 1px;
                text-transform: uppercase;
            }

            .avatar-container {
                background: white;
                width: 45px;
                height: 45px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }

            .avatar-container i {
                font-size: 20px;
                color: #2b1c1a;
            }

            .logout-btn {
                color: #8c7673;
                font-size: 22px;
                text-decoration: none;
                transition: 0.3s;
                margin-left: 5px;
                display: flex;
                align-items: center;
            }

            /* LAYOUT UTAMA */
            .main-layout {
                display: flex;
                padding: 25px 40px;
                gap: 30px;
            }

            /* SIDEBAR KIRI */
            .sidebar-left {
                width: 320px;
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .dark-card {
                background-color: #2b1c1a;
                color: white;
                padding: 30px;
                border-radius: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            }

            .search-card {
                background: white;
                border-radius: 30px;
                padding: 30px;
                box-shadow: 0 10px 20px rgba(0,0,0,0.05);
            }

            /* KAD PERJALANAN BUS */
            .bus-route-card {
                background: white;
                border-radius: 30px;
                padding: 30px;
                margin-bottom: 25px;
                border-left: 8px solid #e74c3c;
            }

            .input-row {
                background: #f9f9f9;
                padding: 12px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 8px;
                margin-bottom: 15px;
            }

            .input-row input {
                border: none;
                background: none;
                outline: none;
                width: 100%;
                font-family: 'Poppins', sans-serif;
            }

            .btn-primary {
                background: #2b1c1a;
                color: white;
                border: none;
                padding: 12px 25px;
                border-radius: 15px;
                font-weight: bold;
                cursor: pointer;
                width: 100%;
            }

            .route-timeline {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin: 30px 0;
                text-align: center;
            }

            .timeline-line {
                flex-grow: 1;
                height: 2px;
                background: #eee;
                margin: 0 20px;
                position: relative;
            }
        </style>
    </head>
    <body>

        <nav class="top-nav">
            <div class="nav-left">
                <span style="font-weight: 800; font-style: italic; font-size: 22px; color: #2b1c1a;">SANIBUS EXPRESS</span>
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
                            <%= (session.getAttribute("username") != null) ? session.getAttribute("username") : "Guest"%>
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

        <div class="main-layout">
            <aside class="sidebar-left">
                <!-- SANI Exclusive Routes -->
                <div class="info-card dark-card">
                    <small style="letter-spacing: 1px; color: #a38b88;">SANI EXPRESS</small>
                    <h2 style="font-style: italic; font-weight: 800; margin: 10px 0;">SANI EXCLUSIVE ROUTES</h2>
                    <div onclick="quickSearch('SANI HUB', 'AIRPORT')" 
                         style="background: rgba(255,255,255,0.05); padding: 12px; border-radius: 15px; margin-top: 15px; cursor: pointer;">
                        <small style="color: #e74c3c; font-weight: bold; font-size: 9px;">FAST ROUTE</small>
                        <p style="margin: 5px 0 0 0; font-size: 13px;"><i class="fa-solid fa-bolt"></i> SANI HUB - AIRPORT</p>
                    </div>
                </div>

                <!-- Borang Carian -->
                <div class="search-card">
                    <h3 style="margin-top: 0; font-size: 16px; color: #2b1c1a;">CARIAN BAS</h3>
                    <form action="student_home.jsp" method="GET" id="searchForm">
                        <label style="font-size: 10px; font-weight: bold; color: #b5a4a1;">DARI</label>
                        <div class="input-row">
                            <i class="fa-solid fa-location-dot" style="color: #d8a19a;"></i>
                            <input type="text" name="origin" id="originInput" placeholder="Lokasi Asal" value="<%= (origin != null) ? origin : ""%>">
                        </div>
                        <label style="font-size: 10px; font-weight: bold; color: #b5a4a1;">KE</label>
                        <div class="input-row">
                            <i class="fa-solid fa-map-pin" style="color: #d8a19a;"></i>
                            <input type="text" name="destination" id="destInput" placeholder="Destinasi" value="<%= (destination != null) ? destination : ""%>">
                        </div>
                        <label style="font-size: 10px; font-weight: bold; color: #b5a4a1;">TARIKH</label>
                        <div class="input-row">
                            <i class="fa-solid fa-calendar-day" style="color: #d8a19a;"></i>
                            <input type="date" name="travelDate" id="dateInput" value="<%= (travelDate != null) ? travelDate : ""%>">
                        </div>
                        <button type="submit" class="btn-primary">CARI BAS SEKARANG</button>
                    </form>
                </div>
            </aside>

            <main style="flex: 1;">
                <h1 style="font-weight: 800; font-size: 36px; margin: 0 0 30px 0; color: #2b1c1a;">ROUTES</h1>

                <%
                    Connection conn = null;
                    PreparedStatement pst = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/bus_system", "root", "");

                        StringBuilder sql = new StringBuilder("SELECT * FROM schedules WHERE 1=1");
                        if (origin != null && !origin.isEmpty()) {
                            sql.append(" AND origin LIKE ?");
                        }
                        if (destination != null && !destination.isEmpty()) {
                            sql.append(" AND destination LIKE ?");
                        }
                        if (travelDate != null && !travelDate.isEmpty()) {
                            sql.append(" AND travel_date = ?");
                        }

                        pst = conn.prepareStatement(sql.toString());
                        int idx = 1;
                        if (origin != null && !origin.isEmpty()) {
                            pst.setString(idx++, "%" + origin + "%");
                        }
                        if (destination != null && !destination.isEmpty()) {
                            pst.setString(idx++, "%" + destination + "%");
                        }
                        if (travelDate != null && !travelDate.isEmpty()) {
                            pst.setString(idx++, travelDate);
                        }

                        rs = pst.executeQuery();
                        boolean found = false;

                        while (rs.next()) {
                            found = true;
                            // Logik Pengiraan Durasi
                            Time dep = rs.getTime("departure_time");
                            Time arr = rs.getTime("arrival_time");
                            long diff = arr.getTime() - dep.getTime();
                            if (diff < 0) {
                                diff += 24 * 60 * 60 * 1000;
                            }
                            long h = diff / (3600000);
                            long m = (diff % 3600000) / 60000;
                %>
                <div class="bus-route-card">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div style="display: flex; gap: 15px; align-items: center;">
                            <div style="background: #f5f5f5; padding: 15px; border-radius: 15px;"><i class="fa-solid fa-bus-simple"></i></div>
                            <div>
                                <h3 style="margin: 0;"><%= rs.getString("bus_name")%></h3>
                                <small><%= rs.getString("travel_date")%></small>
                            </div>
                        </div>
                        <div style="text-align: right;">
                            <span style="font-size: 32px; font-weight: 800;">RM<%= String.format("%.2f", rs.getDouble("price"))%></span>
                        </div>
                    </div>

                    <div class="route-timeline">
                        <div><strong><%= rs.getString("departure_time").substring(0, 5)%></strong><br><small><%= rs.getString("origin")%></small></div>
                        <div class="timeline-line">
                            <span style="position: absolute; top: -12px; left: 50%; transform: translateX(-50%); font-size: 10px;"><%= h%>J <%= m%>M</span>
                        </div>
                        <div><strong><%= rs.getString("arrival_time").substring(0, 5)%></strong><br><small><%= rs.getString("destination")%></small></div>
                    </div>

                    <div style="display: flex; justify-content: space-between; border-top: 1px solid #eee; padding-top: 20px;">
                        <div style="color: #e74c3c; font-weight: 600;"><i class="fa-solid fa-user-group"></i> <%= rs.getInt("available_seats")%> KOSONG</div>
                        <!-- Pautan ditukar ke booking_details.jsp -->
                        <button class="btn-primary" style="width: auto;" onclick="location.href = 'booking_details.jsp?id=<%=rs.getInt("id")%>'">TEMPAH SEKARANG</button>
                    </div>
                </div>
                <%
                        }
                        if (!found) {
                            out.println("<p>Tiada bas ditemui.</p>");
                        }
                    } catch (Exception e) {
                        out.println("Error: " + e.getMessage());
                    } finally {
                        if (conn != null) {
                            conn.close();
                        }
                    }
                %>
            </main>
        </div>

        <script>
            function quickSearch(from, to) {
                document.getElementById('originInput').value = from;
                document.getElementById('destInput').value = to;
                document.getElementById('dateInput').value = new Date().toISOString().split('T')[0];
                document.getElementById('searchForm').submit();
            }
        </script>
    </body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Review Trip - SANI BUS</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --bg-pink: #d8a19a;
                --text-dark: #2b1c1a;
                --text-grey: #8c8c8c;
                --accent-yellow: #ffcc00;
                --white: #ffffff;
            }

            body {
                background-color: var(--bg-pink);
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                align-items: center;
                height: 100vh;
            }

            .top-nav {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 40px;
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(255,255,255,0.1);
                width: 100%;
                box-sizing: border-box;
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
                color: var(--text-dark);
                transition: 0.3s;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .nav-btn.active {
                background: var(--text-dark);
                color: white;
            }

            .nav-right {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .user-meta { text-align: right; line-height: 1.2; }
            .user-name { display: block; font-weight: 800; font-size: 16px; color: var(--text-dark); }
            .user-role { display: block; font-size: 10px; font-weight: 600; color: #8c7673; text-transform: uppercase; }

            .avatar-container {
                background: white;
                width: 45px;
                height: 45px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .main-content {
                flex: 1;
                display: flex;
                justify-content: center;
                align-items: center;
                width: 100%;
            }

            .review-modal {
                background: #f6f6f6;
                width: 420px;
                border-radius: 30px;
                padding: 35px;
                box-shadow: 0 20px 50px rgba(0,0,0,0.15);
                text-align: center;
            }

            .header-row {
                display: flex;
                align-items: center;
                gap: 15px;
                justify-content: center;
            }

            .info-icon {
                background: var(--accent-yellow);
                width: 35px;
                height: 35px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
            }

            .title { font-size: 24px; font-weight: 800; color: var(--text-dark); margin: 0; }
            .subtitle { font-size: 11px; color: var(--text-grey); font-weight: 600; margin-bottom: 30px; display: block; text-transform: uppercase; }

            .route-container {
                margin-bottom: 25px;
                padding: 20px;
                background: var(--white);
                border-radius: 20px;
            }

            .route-text {
                font-size: 18px;
                font-weight: 800;
                color: var(--text-dark);
                text-transform: uppercase;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 15px;
            }

            .blue-tag {
                font-size: 10px;
                font-weight: 800;
                color: #4a80ff;
                margin-top: 10px;
                display: block;
            }

            .details-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-bottom: 30px;
            }

            .info-box { background: var(--white); padding: 20px; border-radius: 20px; }
            .label-small { font-size: 10px; font-weight: 700; color: var(--text-grey); text-transform: uppercase; display: block; margin-bottom: 5px; }
            .val-text { font-size: 22px; font-weight: 800; color: var(--text-dark); }

            .btn-confirm {
                width: 100%;
                background: var(--text-dark);
                color: white;
                border: none;
                padding: 20px;
                border-radius: 22px;
                font-size: 18px;
                font-weight: 800;
                cursor: pointer;
                transition: 0.2s;
            }

            .btn-confirm:hover { transform: scale(0.98); }
            .logout-btn { color: #8c7673; font-size: 22px; text-decoration: none; margin-left: 5px; }
        </style>
    </head>
    <body>

        <nav class="top-nav">
            <div class="nav-left">
                <span style="font-weight: 800; font-style: italic; font-size: 22px; color: #2b1c1a;">SANIBUS EXPRESS</span>
            </div>

            <div class="nav-center">
                <a href="student_home.jsp" class="nav-btn"><i class="fa-solid fa-house"></i> DASHBOARD</a>
                <!-- FIXED: Pointed to registered my_bookings.jsp page directly -->
                <a href="my_bookings.jsp" class="nav-btn active"><i class="fa-solid fa-ticket"></i> MY BOOKINGS</a>
            </div>

            <div class="nav-right">
                <div class="user-meta">
                    <span class="user-name"><%= session.getAttribute("username") %></span>
                    <span class="user-role">PASSENGER</span>
                </div>
                <div class="avatar-container"><i class="fa-regular fa-user"></i></div>
                <a href="LogoutServlet" class="logout-btn"><i class="fa-solid fa-arrow-right-from-bracket"></i></a>
            </div>
        </nav>

        <div class="main-content">
            <div class="review-modal">
                <div class="header-row">
                    <div class="info-icon"><i class="fa-solid fa-info"></i></div>
                    <h1 class="title">REVIEW TRIP</h1>
                </div>
                <span class="subtitle">Verify selection before payment</span>

                <div class="route-container">
                    <div class="route-text">
                        <span><%= session.getAttribute("fromLocation") != null ? session.getAttribute("fromLocation") : "N/A" %></span>
                        <i class="fa-solid fa-arrow-right" style="color: #ccc; font-size: 14px;"></i>
                        <span><%= session.getAttribute("toLocation") != null ? session.getAttribute("toLocation") : "N/A" %></span>
                    </div>
                    <span class="blue-tag"><%= session.getAttribute("bookingType") != null ? session.getAttribute("bookingType") : "STANDARD" %> USER CHOICE</span>
                </div>

                <div class="details-grid">
                    <div class="info-box">
                        <span class="label-small">TICKETS</span>
                        <div class="val-text"><%= session.getAttribute("bookingQty") != null ? session.getAttribute("bookingQty") : "0" %></div>
                    </div>
                    <div class="info-box">
                        <span class="label-small">TOTAL</span>
                        <div class="val-text">RM <%= session.getAttribute("totalAmount") != null ? session.getAttribute("totalAmount") : "0.00" %></div>
                    </div>
                </div>

                <% if (session.getAttribute("seats") != null && !session.getAttribute("seats").toString().isEmpty()) { %>
                <div style="margin-bottom: 20px;">
                    <span class="label-small">SEAT(S)</span>
                    <strong style="color: var(--text-dark);"><%= session.getAttribute("seats") %></strong>
                </div>
                <% } %>

                <!-- FIXED: Converted simple alert button to HTML Form posting to transaction pipeline -->
                <form action="ProcessBookingServlet" method="POST">
                    <input type="hidden" name="schedule_id" value="<%= session.getAttribute("schedule_id") %>">
                    <input type="hidden" name="origin" value="<%= session.getAttribute("fromLocation") %>">
                    <input type="hidden" name="destination" value="<%= session.getAttribute("toLocation") %>">
                    <input type="hidden" name="type" value="<%= session.getAttribute("bookingType") %>">
                    <input type="hidden" name="qty" value="<%= session.getAttribute("bookingQty") %>">
                    <input type="hidden" name="selected_seats" value="<%= session.getAttribute("seats") %>">
                    <input type="hidden" name="price" value="<%= session.getAttribute("totalAmount") %>">
                    <button type="submit" class="btn-confirm">
                        Confirm & Pay
                    </button>
                </form>
            </div>
        </div>

    </body>
</html>
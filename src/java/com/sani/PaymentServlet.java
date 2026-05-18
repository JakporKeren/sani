package com.sani;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. Capture and normalise form radio values
        String method = request.getParameter("method");
        if (method == null || method.trim().isEmpty()) {
            method = "FPX"; // Safe fallback
        }
        
        // 2. Extract tracking attributes from HTTP Session context
        String amountStr = (String) session.getAttribute("totalAmount");
        String scheduleIdStr = (String) session.getAttribute("schedule_id");
        String username = (String) session.getAttribute("username");

        // 3. Early Interception Fallback: Check if session data dropped out
        if (username == null || scheduleIdStr == null || amountStr == null) {
            System.out.println("[PaymentServlet Error] Session components are empty!");
            response.sendRedirect("paymentSelection.jsp?error=Missing_Session_Variables");
            return;
        }

        // Generate tracking transaction ID string
        String transactionId = "SANI-" + System.currentTimeMillis();

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                response.sendRedirect("paymentSelection.jsp?error=Database_Connection_Failed");
                return;
            }
            
            // STEP A: Resolve the user ID directly first with a LIMIT 1 guardrail
            int userId = -1;
            String userSql = "SELECT id FROM users WHERE username = ? LIMIT 1";
            try (PreparedStatement userPs = con.prepareStatement(userSql)) {
                userPs.setString(1, username);
                try (ResultSet userRs = userPs.executeQuery()) {
                    if (userRs.next()) {
                        userId = userRs.getInt("id");
                    }
                }
            }
            
            // Validate that we actually found a valid user profile account record
            if (userId == -1) {
                response.sendRedirect("paymentSelection.jsp?error=User_Account_Not_Found");
                return;
            }
            
            // STEP B: Perform clean insert execution using the resolved structural primitive ID variables
            String sql = "INSERT INTO payments (user_id, schedule_id, amount, payment_method, transaction_id, status) " +
                         "VALUES (?, ?, ?, ?, ?, 'Success')";
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                
                // Safe parsing for structural numeric definitions 
                int scheduleId = Integer.parseInt(scheduleIdStr.trim());
                ps.setInt(2, scheduleId);
                
                double amount = Double.parseDouble(amountStr.trim());
                ps.setDouble(3, amount);
                
                // Bind remaining transaction tracking string data
                ps.setString(4, method);
                ps.setString(5, transactionId);
                
                int rowCount = ps.executeUpdate();

                if (rowCount > 0) {
                    session.setAttribute("lastTransactionId", transactionId);
                    // Success redirection target
                    response.sendRedirect("payment_confirmed.jsp?id=" + transactionId);
                } else {
                    response.sendRedirect("paymentSelection.jsp?error=Insert_Operation_Failed");
                }
            }
        } catch (NumberFormatException nfe) {
            System.out.println("[PaymentServlet] Numeric parsing fault: " + nfe.getMessage());
            response.sendRedirect("paymentSelection.jsp?error=Data_Format_Mismatch");
        } catch (SQLException sqle) {
            sqle.printStackTrace();
            String sqlMessage = sqle.getMessage() != null ? sqle.getMessage().replace(" ", "_") : "SQL_Fault";
            response.sendRedirect("paymentSelection.jsp?error=SQL_" + sqlMessage);
        } catch (Exception e) {
            e.printStackTrace();
            String generalMessage = e.getMessage() != null ? e.getMessage().replace(" ", "_") : "General_Exception";
            response.sendRedirect("paymentSelection.jsp?error=EX_" + generalMessage);
        }
    }
}
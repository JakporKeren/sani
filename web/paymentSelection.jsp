<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Selection - SANI</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        body { background-color: #d8a19a; font-family: 'Poppins', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .payment-card { background: white; padding: 40px; border-radius: 30px; width: 450px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .amount-display { text-align: center; margin-bottom: 30px; background: #fdf2f1; padding: 20px; border-radius: 20px; }
        .method-opt { 
            display: flex; align-items: center; gap: 15px; padding: 20px; 
            border: 2px solid #f0f0f0; border-radius: 15px; margin-bottom: 15px; 
            cursor: pointer; transition: 0.3s; position: relative;
        }
        .method-opt:hover { border-color: #2b1c1a; background: #fafafa; }
        .method-opt input[type="radio"] { position: absolute; right: 20px; }
        .method-opt i { font-size: 24px; color: #2b1c1a; width: 30px; }
        .btn-confirm { 
            width: 100%; padding: 18px; border-radius: 15px; border: none; 
            background: #2b1c1a; color: white; font-weight: 800; cursor: pointer; 
        }
    </style>
</head>
<body>
    <%
        // FIXED: Explicit structural safety filter added to capture raw direct page hits safely
        String displayAmt = (session != null && session.getAttribute("totalAmount") != null) ? (String) session.getAttribute("totalAmount") : "0.00";
    %>
    <div class="payment-card">
        <div class="amount-display">
            <small style="font-weight:600; color:#b5a4a1;">TOTAL PAYABLE</small>
            <h1 style="color: #e32626; margin: 5px 0;">RM <%= displayAmt %></h1>
        </div>

        <form action="PaymentServlet" method="POST">
            <label class="method-opt">
                <i class="fa-solid fa-building-columns"></i>
                <div><strong>FPX Online Banking</strong><br><small>Maybank, CIMB, PBE...</small></div>
                <input type="radio" name="method" value="FPX" required>
            </label>

            <label class="method-opt">
                <i class="fa-solid fa-wallet"></i>
                <div><strong>E-Wallet (TNG)</strong><br><small>Touch 'n Go / GrabPay</small></div>
                <input type="radio" name="method" value="EWALLET">
            </label>

            <label class="method-opt">
                <i class="fa-solid fa-credit-card"></i>
                <div><strong>Debit / Credit Card</strong><br><small>Visa / MasterCard</small></div>
                <input type="radio" name="method" value="CARD">
            </label>

            <button type="submit" class="btn-confirm">CONFIRM PAYMENT</button>
        </form>
    </div>
</body>
</html>
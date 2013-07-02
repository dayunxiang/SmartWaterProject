<%-- 
    Document   : homepage
    Created on : 1-lug-2013, 22.40.00
    Author     : pelldav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pagina di benvenuto</title> 
    </head>
    <body>
        <h1>Smart Leak Detection</h1>
        <div class="button" id="registrer" onclick="window.location.replace('https://'+window.location.host+'<%=request.getContextPath() %>/auth/auth.jsp')">
            <input type="submit" value="Register" />
        </div>
        <div class="button" id="login" onclick="window.location.replace('https://'+window.location.host+'<%=request.getContextPath() %>/login/login.jsp')">
            <input type="submit" value="Login" />
        </div>
    </body>
</html>

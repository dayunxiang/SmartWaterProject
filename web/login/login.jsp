<%@page contentType="text/html" pageEncoding="UTF-8"
        %><%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c' 
        %><c:if test="${pageContext.request.userPrincipal!=null}">
    <c:redirect url="/secure/index.jsp"/>
    <!-- this will redirect if user is already logged in -->
</c:if>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../css/formStyle.css" />
        <title>JSP Page</title>

        <script src="<%=request.getContextPath()%>/js/json2.js" type="text/javascript"></script>

        <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>        

        <script type="text/javascript">
            $(function() {
                "use strict";

                $(document.forms['loginForm']).submit(function(event) {

                    var data = {
                        email: this.email.value,
                        password: this.password.value
                    };
                    var destinationUrl = this.action;

                    $.ajax({
                        url: destinationUrl,
                        type: "POST",
                        data: data,
                        cache: false,
                        dataType: "json",
                        success: function(data, textStatus, jqXHR) {
                            //alert("success");
                            if (data.status == "SUCCESS") {
                                //redirect to secured page
                                window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/secure/index.jsp");
                            } else {
                                alert("failed");
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            alert("error - HTTP STATUS: " + jqXHR.status);
                        },
                        complete: function(jqXHR, textStatus) {
                            //alert("complete");
                        }
                    });

                    //event.preventDefault();
                    return false;
                });
            });
        </script>


    </head>
    <body>
        <h1>Login Page</h1>
        <a href="<%=request.getContextPath()%>/homepage.jsp" >go to homepage</a>
        <div class="login">
            <c:if test="false">
                <div class="authError">
                    Invalid User Name or Password. Please try again.
                </div>
            </c:if>

            <form id="loginForm" name="loginForm" action="<%=request.getContextPath()%>/services/auth/login" method="post">
                <fieldset>
                    <legend>Login</legend>

                    <div>
                        <label for="email">Email</label> 
                        <input type="text" id="email" name="email"/>
                    </div>
                    <div>
                        <label for="password">Password</label> 
                        <input type="password" id="password" name="password"/>
                    </div>

                    <div class="buttonRow">
                        <input type="submit" value="Login" />
                    </div>

                </fieldset>
            </form> 
        </div>
    </body>
</html>

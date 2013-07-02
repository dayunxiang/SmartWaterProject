<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
                       "http://www.w3.org/TR/html4/loose.dtd">
  
<html>
  <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Secured JSP Page</title>
         
        <!-- see https://github.com/douglascrockford/JSON-js -->
        <script src="<%=request.getContextPath() %>/js/json2.js" type="text/javascript"></script>
         
        <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>
         
        <script type="text/javascript">
        $(function(){
            "use strict";
            $('#logoutLink').click(function(){
                 
                var destinationUrl = this.href;
                 
                $.ajax({
                    url: destinationUrl,
                    type: "GET",
                    cache: false,
                    dataType: "json",
                         
                    success: function (data, textStatus, jqXHR){
                        //alert("success");
                        if (data.status == "SUCCESS" ){
                            //redirect to welcome page
                            window.location.replace("https://"+window.location.host+"<%=request.getContextPath() %>/");
                        }else{
                            alert("failed");
                        }
                    },
                         
                    error: function (jqXHR, textStatus, errorThrown){
                        alert("error - HTTP STATUS: "+jqXHR.status);
                    },
                         
                    complete: function(jqXHR, textStatus){
                        //alert("complete");
                    }                    
                });
                 
                return false;
            });
        });
         
        $(function(){
           $("#getTimeStampButton").click(function(){
               $.ajax({
                   url: "<%=request.getContextPath() %>/services/secure/timestamp/now",
                   type: "GET",
                   cache: false,
                   dataType: "json",
                        
                   success: function (data, textStatus, jqXHR){
                       //alert("success");
                       if (data.status == "SUCCESS" ){
                           $("#timeStampContent").html("Timestamp: "+data.data);
                       }else{
                           alert("failed");
                       }
                   },
                        
                   error: function (jqXHR, textStatus, errorThrown){
                       //alert("error - HTTP STATUS: "+jqXHR.status);
                       if (textStatus == "parsererror"){
                           alert("You session has timed out");
                           //forward to welcomde page
                           window.location.replace("https://"+window.location.host+"<%=request.getContextPath() %>/welcome.jsp");
                       }
                   },
                        
                   complete: function(jqXHR, textStatus){
                       //alert("complete");
                   }                    
               });
           }); 
        });
        </script>
         
  </head>
  <body>
    <h1>You are logged in.</h1>
    <a id="logoutLink" href="<%=request.getContextPath() %>/services/auth/logout" >logout</a>
    <br/><br/>
    <button id="getTimeStampButton">Get Server Time</button>
     
    <br/><br/>
    <div id="timeStampContent"></div>
    <%
      
    Principal p = request.getUserPrincipal();
    out.write("<br/><br/>");
    if (p == null){
        //if you get here the something is really wrong, because
        //you can only see that page if you have been authenticated 
        //and therefore there is a principal available
        out.write("<div>Principal = NULL</div>");
    }else{
        out.write("<div>Principal.getName()                 = "+p.getName()+"</div>");
        out.write("<div>request.getRemoteUser()             = "+request.getRemoteUser()+"</div>");
        out.write("<div>request.getAuthType()               = "+request.getAuthType()+"</div>");
        out.write("<div>request.isUserInRole(ADMINISTRATOR) = "+request.isUserInRole("ADMINISTRATOR") +"</div>");
        out.write("<div>request.isUserInRole(USER)          = "+request.isUserInRole("USER") +"</div>");
        out.write("<div>request.isUserInRole(DEFAULT)       = "+request.isUserInRole("DEFAULT") +"</div>");
        out.write("<div>request.isUserInRole(CUSTOMER)      = "+request.isUserInRole("CUSTOMER") +"</div>");
    }
          
    %>
  </body>
</html>
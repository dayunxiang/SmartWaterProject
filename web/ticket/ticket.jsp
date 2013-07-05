<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
                       "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="<%=request.getContextPath() %>/js/json2.js" type="text/javascript"></script>
         
        <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>

        <title>JSP Page</title>
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
                            window.location.replace("https://"+window.location.host+"<%=request.getContextPath() %>/homepage.jsp");
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
           $("#getTicketsList").click(function(){
               $.ajax({
                   url: "<%=request.getContextPath() %>/services/ticket/list",
                   type: "GET",
                   cache: false,
                   dataType: "json",
                        
                   success: function (data, textStatus, jqXHR){
                       //alert("success");
                       if (data.status == "SUCCESS" ){
                                var table = '<tr><td>'
                                        + 'ID'
                                        + '</td><td>'
                                        + 'Stato'
                                        + '</td><td>'
                                        + 'Info'
                                        + '</td></tr>';                                
                                
                                for (var key=0, size=data.data.length; key<size; key++) {
                                table += '<tr><td>'
                                        + data.data[key].id
                                        + '</td><td>'
                                        + data.data[key].stato
                                        + '</td><td>'
                                        + data.data[key].info
                                        + '</td></tr>';
                            }
                            $('#ticketsList').append(table);
                       }else{
                           alert("failed");
                       }
                   },
                        
                   error: function (jqXHR, textStatus, errorThrown){
                       //alert("error - HTTP STATUS: "+jqXHR.status);
                       if (textStatus == "parsererror"){
                           alert("You session has timed out");
                           //forward to welcomde page
                           window.location.replace("https://"+window.location.host+"<%=request.getContextPath() %>/homepage.jsp");
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
    <button id="getTicketsList">Get Ticket List</button>
    <br/><br/>
    <div id="ticketsList"></div>
    
  </body>

</html>

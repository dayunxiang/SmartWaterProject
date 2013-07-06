<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8; initial-scale=1.0; user-scalable=no">
        <title>Secured JSP Page</title>

        <!-- see https://github.com/douglascrockford/JSON-js -->
        <script src="<%=request.getContextPath()%>/js/json2.js" type="text/javascript"></script>
        <script src="<%=request.getContextPath()%>/js/geoxml3.js" type="text/javascript"></script>


        <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>
        <script type="text/javascript">
            function getUrlValue(VarSearch){
                    var SearchString = window.location.search.substring(1);
                    var VariableArray = SearchString.split('&');
                    for(var i = 0; i < VariableArray.length; i++){
                        var KeyValuePair = VariableArray[i].split('=');
                        if(KeyValuePair[0] == VarSearch){
                            return KeyValuePair[1];
                        }
                    }
                }
            $(function() {
                "use strict";
                $('#logoutLink').click(function() {

                    var destinationUrl = this.href;

                    $.ajax({
                        url: destinationUrl,
                        type: "GET",
                        cache: false,
                        dataType: "json",
                        success: function(data, textStatus, jqXHR) {
                            //alert("success");
                            if (data.status == "SUCCESS") {
                                //redirect to welcome page
                                window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/");
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

                    return false;
                });
            });
            $(function() {
                "use strict";
                $(document).ready( function(){
                    var data = {
                        noiselogger: getUrlValue("nl")
                    };
                    $.ajax({
                        url: "<%=request.getContextPath()%>/services/ticket/newticket",
                        type: "POST",
                        data: data,
                        cache: false,
                        dataType: "json",
                        success: function(data, textStatus, jqXHR) {
                            //alert("success");
                            if (data.status == "SUCCESS") {
                                //redirect to secured page
                                $("#info").html("Ticket added");
                            } else {
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            //alert("error - HTTP STATUS: "+jqXHR.status);
                            if (textStatus == "parsererror") {
                                alert("You session has timed out");
                                //forward to welcomde page
                                window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/homepage.jsp");
                            }
                        },
                        complete: function(jqXHR, textStatus) {
                            //alert("complete");
                        }

                    });
                    
                    return false;
                });
            });
        </script>

    </head>
    <body id="body">
        <h1>You are logged in.</h1>
        <a id="logoutLink" href="<%=request.getContextPath()%>/services/auth/logout" >logout</a>
        <a id="back" href="<%=request.getContextPath()%>/secure/index.jsp" >Go back</a>

        <br/><br/>

        <div id="info"></div>
       

    </body>
</html>
<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8; initial-scale=1.0; user-scalable=no">
        <style>
            html, body, #map-canvas {
                position: relative;
                margin-bottom: 10%;
                padding: 0;
                height: 80%;
                width: 80%;
            }
        </style>
        <title>Secured JSP Page</title>

        <!-- see https://github.com/douglascrockford/JSON-js -->
        <script src="<%=request.getContextPath()%>/js/json2.js" type="text/javascript"></script>
        <script src="<%=request.getContextPath()%>/js/geoxml3.js" type="text/javascript"></script>


        <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>
        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=true"></script>
        <script>
            var map;
            function initialize() {
                var myLatLng = new google.maps.LatLng(49.496675, -102.65625);
                var mapOptions = {
                    zoom: 1,
                    center: myLatLng,
                    mapTypeId: google.maps.MapTypeId.HYBRID,
                    streetViewControl: false
                };

                var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

                var myParser = new geoXML3.parser({map: map});
                myParser.parse("<%=request.getContextPath()%>/file/MappaIdrica.kml");
            }

            google.maps.event.addDomListener(window, 'load', initialize);

        </script>    
        <script type="text/javascript">
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
                $('#setNewTicket').click(function() {
                    var data = {
                        noiselogger: "1234567890"
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
    <body>
        <h1>You are logged in.</h1>
        <a id="logoutLink" href="<%=request.getContextPath()%>/services/auth/logout" >logout</a>
        <br/><br/>

        <div id="map-canvas" style="height: 100%"></div>
        <button id="setNewTicket">Set new ticket </button>
        <button id="getTicketsList" onclick='window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/ticket/ticket.jsp");'>Get list ticket</button>
        <button id="measure" onclick='window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/measure/measure.jsp");'>Measure page</button>
        <button id="test" onclick='window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/ticket/newTicket.jsp");'>Test</button>
        <div id="info"></div>
       

    </body>
</html>
<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8; initial-scale=1.0; user-scalable=no">

        <style type="text/css">
            html, body {
                height: 100%;
            }
            /*            #map-canvas {
                            width: 100%;
                            height: 80%;
                            border: 1px solid black;
                        }*/
            .olPopup p { margin:0px; font-size: .9em;}
            .olPopup h2 { font-size:1.2em; }
            #logo{
                height: 30px;
            }
        </style>
        <title>Secured JSP Page</title>

        <!-- see https://github.com/douglascrockford/JSON-js -->
        <script src="<%=request.getContextPath()%>/js/json2.js" type="text/javascript"></script>
        <script src="<%=request.getContextPath()%>/js/geoxml3.js" type="text/javascript"></script>

        <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
        <link href="<%=request.getContextPath()%>/css/top_menu.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript">
            var SubMenutimer;
            var last_o;
            $(".mainbar").ready(function() {
                $(".staticMenu dt a").click(function() {
                    $(this).parents(".staticMenu").find(".noti_bubble").hide();
                    $(".staticMenu dd ul").not($(this).parents(".staticMenu").find("ul")).hide();
                    $(".staticMenu dt a").not($(this)).removeClass("selected");
                    $(this).parents(".staticMenu").find("ul").toggle();
                    if ($(this).parents(".staticMenu").find("ul").css("display") == "none") {
                        $(this).removeClass("selected");
                    } else {
                        $(this).addClass("selected");
                    }
                });
                $(".staticMenu dd ul li a").click(function() {
                    var text = $(this).html();
                    $(".staticMenu dt a span").html(text);
                    $(".staticMenu dd ul").hide();
                });
                $(document).bind('click', function(e) {
                    var $clicked = $(e.target);
                    if (!$clicked.parents().hasClass("staticMenu")) {
                        $(".staticMenu dd ul").hide();
                        $(".staticMenu dt a").removeClass("selected");
                    }
                });
            });
            function openSubMenu(o) {
                cancelSubMenuClose();
                if (last_o)
                    $(last_o).parent().find("div").hide();
                last_o = o;
                $(o).parent().find("div").show();
            }

            function closeSubMenu() {
                SubMenutimer = setTimeout("close()", 500);
            }

            function cancelSubMenuClose() {
                clearTimeout(SubMenutimer);
            }

            function close() {
                $(last_o).parent().find("div").hide();
            }

            $(function() {
                "use strict";
                $(document).ready(function() {
                    if ("<%=request.getUserPrincipal()%>" != "") {

                        $('#sign-in').html("<%=request.getUserPrincipal()%>");
                        $('#sign').html("Logout");
                        $('#sign').attr("href", "<%=request.getContextPath()%>/services/auth/logout");
                        $('#ticket').attr("href", "<%=request.getContextPath()%>/secure/ticket/ticket.jsp");
                    }


                    return false;
                });
            });</script>



        <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>
        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=true"></script>

        <script>
            function initialize() {
                $.ajax({
                    url: "<%=request.getContextPath()%>/services/mapsdata/list",
                    type: "GET",
                    cache: false,
                    dataType: "json",
                    success: function(data, textStatus, jqXHR) {
                        //alert("success");
                        if (data.status == "SUCCESS") {
                            //redirect to welcome page
                            var content;

                            var map = new google.maps.Map(document.getElementById('map-canvas'), {
                                zoom: 10,
                                center: new google.maps.LatLng(38.102579, 12.441221),
                                mapTypeId: google.maps.MapTypeId.ROADMAP
                            });
                            var ctaLayer = new google.maps.KmlLayer({
                                url: 'http://caweb.elislab.elis.org/SmartWater/Pipe.kml'
                            });
                            ctaLayer.setMap(map);

                            var infowindow = new google.maps.InfoWindow();
//FIX-ME disegnare un cerchio quando il noiselogger è in stato di allarme
                            var marker, i;

                            for (var key = 0, size = data.data.length; key < size; key++) {
                                var image;
                                if (data.data[key].style == "#largeStyle")
                                    image = "http://labs.google.com/ridefinder/images/mm_20_purple.png";
                                else if (data.data[key].style == "#strictStyle")
                                    image = "http://labs.google.com/ridefinder/images/mm_20_white.png";
                                else if (data.data[key].style == "#alarmStyle")
                                    image = "http://labs.google.com/ridefinder/images/mm_20_red.png";
                                else if (data.data[key].style == "#errorStyle")
                                    image = "http://labs.google.com/ridefinder/images/mm_20_yellow.png";

                                marker = new google.maps.Marker({
                                    position: new google.maps.LatLng(data.data[key].latitude, data.data[key].longitude),
                                    map: map,
                                    icon: image
                                });
                                $('#info').append(window.location.host);
                                google.maps.event.addListener(marker, 'click', (function(marker, key) {
                                    return function() {
                                        newticketAction = "window.location.replace('https://" + window.location.host + "/SmartLeakDetection/secure/ticket/newTicket.jsp?nl=" + data.data[key].noiselogger + "');";
                                        storicoAction = "window.location.replace('https://" + window.location.host + "/SmartLeakDetection/secure/measure/measure.jsp?nl=" + data.data[key].noiselogger + "');";
                                        content = '<div class="geoxml3_infowindow"><h3>' + data.data[key].noiselogger +
                                                '</h3><br><h3>' + data.data[key].description + '</h3></div>' +
                                                '<button onclick="' + newticketAction + '">Manutenzione</button>' +
                                                '<button onclick="' + storicoAction + '">Storico</button>';
                                        infowindow.setContent(content);
                                        infowindow.open(map, marker);
                                    }
                                })(marker, key));
                            }
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

            }
            google.maps.event.addDomListener(window, 'load', initialize);

        </script>

        <script type="text/javascript">
            var noiselogger;
            $(function() {
                "use strict";
                $('#sign').click(function() {
                    if ("<%=request.getUserPrincipal()%>" == "") {
                        window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/auth/auth.jsp");
                        return false;
                    }
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
                $('#activate').click(function() {
                    var data = {
                        noiselogger: "1234567890"
                    };
                    $.ajax({
                        url: "<%=request.getContextPath()%>/services/auth/activate",
                        type: "POST",
                        data: data,
                        cache: false,
                        dataType: "json",
                        success: function(data, textStatus, jqXHR) {
                            //alert("success");
                            if (data.status == "SUCCESS") {
                                //redirect to secured page
                                $("#info").html("Maglia Attivata");
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
            $(function() {
                "use strict";
                $('#storico').click(function() {
                    window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/secure/measure/measure.jsp?nl=" + noiselogger);

                    return false;
                });
            });
            $(function() {
                "use strict";
                $('#newTicket').click(function() {
                    window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/secure/ticket/newTicket.jsp?nl=" + noiselogger);

                    return false;
                });
            });
        </script>

    </head>

    <body>
        <div style="clear:both; margin-top:20px;">&nbsp;</div>
        <div id="header"><!-- begin header -->

            <div class="mainbar" >
                <div>
                    <ul class="mainMenu" >
                        <!-- Using class="current" for the link of the current page -->
                        <li class="" style="float:left;">
                            <img id="logo" src="<%=request.getContextPath()%>/file/telecom.jpg">
                        </li>
                        <li class="" style="float:left;"><!-- for links with no dropdown -->
                            <a id="sign-in" target="_self" href="<%=request.getContextPath()%>/login/login.jsp">+You</a>
                        </li>
                        <li class="current" style="float:left;">
                            <a target="_self" href="<%=request.getContextPath()%>/secure/index.jsp">Mappa Idrica</a>
                        </li>
                        <li class="" style="float:left;">
                            <a id="ticket" target="_self" href="<%=request.getContextPath()%>/secure/index.jsp">Gestione Ticket</a>
                        </li>
                        <li class="" style="float:right; margin-right:3em;"><!-- for links with no dropdown -->
                            <a id="sign" target="_self" href="<%=request.getContextPath()%>/auth/auth.jsp">Sign-up</a>
                        </li>
                    </ul>             	
                </div>
            </div>
            <br/><br/>
        </div><!-- end header -->	

        <h1>Smart Leak Detection</h1>
        <h4>by Smart Team</h4>
        <br/><br/>

        <div id="map-canvas" style="height: 100%"></div>
        <div id="info"></div>
        <button id="activate">Activate</button>
        <!--        <button id="storico">Storico</button>
                <button id="newTicket">Manutenzione</button>-->


    </body>
</html>
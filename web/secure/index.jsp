<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8; initial-scale=1.0; user-scalable=no">
        <!--        <script>
                    ESPN_refresh = window.setTimeout(function() {window.location.href = window.location.href}, 10000);
                </script>   
            <noscript>   
                <meta http-equiv=”refresh” content=”10″ />   
            </noscript>-->
        <style type="text/css">
            #logo{
                height: 50px;
            }
            html, body {
                height: 100%;
            }
            #map-canvas {
                width: 99%;
                height: 68%;
                border: 1px solid black;
                padding-left: 0.5%;
                padding-right: 0.5%;
            }
            .olPopup p { margin:0px; font-size: .9em;}
            .olPopup h2 { font-size:1.2em; }
            #title{
                margin-left: 5px;
                font-size: large;
                font-weight: bold;
            }
        </style>
        <title>TI-LeD - Telecom Italia Leak Detection</title>

        <!-- see https://github.com/douglascrockford/JSON-js -->
        <script src="<%=request.getContextPath()%>/js/json2.js" type="text/javascript"></script>
<!--        <script src="<%=request.getContextPath()%>/js/geoxml3.js" type="text/javascript"></script>-->

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
                        $('#sign-in').attr("href", "<%=request.getContextPath()%>/secure/index.jsp");
                        $('#sign').html("Logout");
                        $('#sign').attr("href", "<%=request.getContextPath()%>/secure/logout.jsp");
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
                                url: 'http://caweb.elislab.elis.org/SmartWater/Turin_Pipe.kml',
//                                url: 'http://caweb.elislab.elis.org/SmartWater/San_Vito_Pipe.kml',
                                suppressInfoWindows: true
                            });
                            ctaLayer.setMap(map);
                            var infowindow = new google.maps.InfoWindow();
                            var marker, i;
                            for (var key = 0, size = data.data.length; key < size; key++) {
                                var image;
                                if (data.data[key].style == "#largeStyle")
                                    image = "<%=request.getContextPath()%>/file/iconeNL/Viola3.png";
                                else if (data.data[key].style == "#strictStyle")
                                    image = "<%=request.getContextPath()%>/file/iconeNL/Bianco3.png";
                                else if (data.data[key].style == "#measureStyle")
                                    image = "<%=request.getContextPath()%>/file/iconeNL/Blu3.png";
                                else if (data.data[key].style == "#alarmStyle") {
                                    image = "<%=request.getContextPath()%>/file/iconeNL/rosso3.png";
                                    //draw a circle in alarm area
                                    var centerCoordinate = new google.maps.LatLng(data.data[key].latitude, data.data[key].longitude);
                                    var alarmOptions = {
                                        strokeColor: '#FF0000',
                                        strokeOpacity: 0.8,
                                        strokeWeight: 2,
                                        fillColor: '#FF0000',
                                        fillOpacity: 0.35,
                                        map: map,
                                        center: centerCoordinate,
                                        radius: 150 //radius in meter
                                    };
                                    var alarmCircle = new google.maps.Circle(alarmOptions);
                                }
                                else if (data.data[key].style == "#errorStyle")
                                    image = "<%=request.getContextPath()%>/file/iconeNL/giallo3.png";
                                else if (data.data[key].style == "leak")
                                    image = "<%=request.getContextPath()%>/file/iconeNL/triangolo3.png";
                                marker = new google.maps.Marker({
                                    position: new google.maps.LatLng(data.data[key].latitude, data.data[key].longitude),
                                    map: map,
                                    icon: image,
                                    scaledSize: 0.1
                                });
                                google.maps.event.addListener(marker, 'click', (function(marker, key) {
                                    return function() {
                                        var styleButton = '';
                                        var addButton = '';
                                        var colorStatus;
                                        var colorBattery;
                                        if (data.data[key].status == "OK") {
                                            colorStatus = '<font color="green">';
                                            if (data.data[key].battery > 20) {
                                                styleButton = 'disabled="disabled"';
                                                colorBattery = '<font color="green">';
                                            } else {
                                                colorBattery = '<font color="red">';
                                            }
                                        } else {
                                            colorStatus = '<font color="red">';
                                            if (data.data[key].battery > 20) {
                                                colorBattery = '<font color="green">';
                                            } else {
                                                colorBattery = '<font color="red">';
                                            }
                                        }
                                        if (data.data[key].style == "#alarmStyle") {
                                            activateAction = "window.location.replace('https://" + window.location.host + "/TI-LeD/secure/measure/activate.jsp?nl=" + data.data[key].noiselogger + "');";
                                            addButton = '<button onclick="' + activateAction + '">Attiva maglia stretta</button>';
                                        }
                                        newticketAction = "window.location.replace('https://" + window.location.host + "/TI-LeD/secure/ticket/newTicket.jsp?nl=" + data.data[key].noiselogger + "');";
                                        storicoAction = "window.location.replace('https://" + window.location.host + "/TI-LeD/secure/measure/measure.jsp?nl=" + data.data[key].noiselogger + "');";
                                        content = '<div class="geoxml3_infowindow"><h3>Noise logger #' + data.data[key].noiselogger +
                                                '</h3><br><h3> Data: ' + data.data[key].timestamp +
                                                '<br>Livello soglia superata: ' + data.data[key].value +
                                                '<br>Batteria: ' + colorBattery + data.data[key].battery + '%</font>' +
                                                '<br>Stato: ' + colorStatus + data.data[key].status + '</font><br></h3></div>' +
                                                '<button onclick="' + newticketAction + '" ' + styleButton + '>Manutenzione</button><br>' +
                                                '<button onclick="' + storicoAction + '">Storico</button><br>' + addButton;
                                        if (data.data[key].style == "#strictStyle") {
                                            content = '<div class = "geoxml3_infowindow"> <h3> Noise logger #' + data.data[key].noiselogger +
                                                    '</h3><br><h3>Sensore non attivo</h3></div>';
//                                            '<br>Batteria: ' + colorBattery + data.data[key].battery + '%</font>' +
//                                                    '<br>Stato: ' + colorStatus + data.data[key].status + '</font><br></h3></div>';
                                        }
                                        if (data.data[key].style == "#measureStyle") {
                                            content = '<div class = "geoxml3_infowindow"> <h3> Noise logger #' + data.data[key].noiselogger +
                                                    '</h3><br><h3>Sensore attivato per la ricerca della perdita</h3></div>';
//                                            '<br>Batteria: ' + colorBattery + data.data[key].battery + '%</font>' +
//                                                    '<br>Stato: ' + colorStatus + data.data[key].status + '</font><br></h3></div>';
                                        }
                                        if (data.data[key].style == "leak") {
                                            content = '<div class = "geoxml3_infowindow"> <h3> Perdita' +
                                                    '</h3></div>';
                                        }

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
            google.maps.event.addDomListener(window, 'load', initialize);</script>

    </head>

    <body>
        <div style="clear:both; margin-top:40px;">&nbsp;</div>
        <div id="header"><!-- begin header -->

            <div class="mainbar" >
                <div>
                    <ul class="mainMenu" >
                        <!-- Using class="current" for the link of the current page -->
                        <li class="" style="float:left;">
                            <img id="logo" src="<%=request.getContextPath()%>/file/telecom.jpg">
                        </li>
                        <li class="" style="float:left;"><!-- for links with no dropdown -->
                            <a id="sign-in" target="_self" href="<%=request.getContextPath()%>/homepage.jsp">+You</a>
                        </li>
                        <li class="current" style="float:left;">
                            <a target="_self" href="<%=request.getContextPath()%>/secure/index.jsp">Mappa Idrica</a>
                        </li>
                        <li class="" style="float:left;">
                            <a id="ticket" target="_self" href="<%=request.getContextPath()%>/secure/ticket/ticket.jsp">Gestione Ticket</a>
                        </li>
                        <li class="" style="float:right;"><!-- for links with no dropdown -->
                            <a id="sign" target="_self" href="<%=request.getContextPath()%>/auth/auth.jsp">Registrati</a>
                        </li>
                        <li class="" style="float:right;"><!-- for links with no dropdown -->
                            <a id="reset" target="_self" href="<%=request.getContextPath()%>/reset.jsp">Reset Valori Mappa</a>
                        </li>
                        <!--                    <li class="" style="float:right;">
                        <a id="startcom" target="_self" href="<%=request.getContextPath()%>/startCom.jsp">Avvia Comunicazione</a>
                    </li>-->
                        <li class="" style="float:right;">
                            <a id="simul" target="_self" href="<%=request.getContextPath()%>/secure/simulation.jsp">Simulazione Dati</a>
                        </li>
                    </ul>             	
                </div>
            </div>
        </div><!-- end header -->	
        <div id="title_bar">
            <p id="title">
                TI LeD - Telecom Italia Leak Detection
                <img id="logo_tiled" style="height: 15%; width: 15%; padding-left:45%; align:middle;" src="<%=request.getContextPath()%>/file/LOGO_TI_LED.png" align="middle">                
            </p>
        </div>
        <!--        <h1>TI-LeD</h1>-->
        <br/><br/>

        <div id="map-canvas"></div>
        <div id="info"></div>
        
    </body>
</html>
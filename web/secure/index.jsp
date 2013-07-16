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
            #map-canvas {
                width: 100%;
                height: 80%;
                border: 1px solid black;
            }
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
            });
        </script>



        <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>
        <script src="https://maps.googleapis.com/maps/api/js?v=3&sensor=true"></script>
        <script>
            function initialize() {
                var myLatLng = new google.maps.LatLng(49.496675, -102.65625);
                var mapOptions = {
                    zoom: 1,
                    center: myLatLng,
                    mapTypeId: google.maps.MapTypeId.HYBRID,
                    streetViewControl: true
                };
                // To delete ballon on pipe
                var myKmlOptionsPipe = {
//                    preserveViewport: true,
                    suppressInfoWindows: true
                }

                var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
                var kmlLayer_1 = new google.maps.KmlLayer("http://caweb.elislab.elis.org/SmartWater/Noise_loggers_v4.kml");
                var kmlLayer_2 = new google.maps.KmlLayer("http://caweb.elislab.elis.org/SmartWater/Pipe.kml", myKmlOptionsPipe);
                //var kmlLayer_3 = new google.maps.KmlLayer("http://caweb.elislab.elis.org/SmartWater/Noise_loggers_Style_v3.kml");

                kmlLayer_1.setMap(map);
                kmlLayer_2.setMap(map);
                //kmlLayer_3.setMap(map);

                //                var myParser = new geoXML3.parser({map: map, processStyles: true});
                //                myParser.parse("<%=request.getContextPath()%>/file/Noise_loggers_copia.kml");
                //                myParser.parse("<%=request.getContextPath()%>/file/Noise_loggers_Style.kml");
                //                myParser.parse("<%=request.getContextPath()%>/file/Pipe.kml");
//                var nlLayer = new google.maps.KmlLayer({
//                    url: 'http://caweb.elislab.elis.org/SmartWater/Noise_loggers_copia.kml',
//                    map: map,
//                    option: myKmlOption
//                });
//                var styleLayer = new google.maps.KmlLayer({
//                    url: 'http://caweb.elislab.elis.org/SmartWater/Noise_loggers_Style.kml',
//                    map: map,
//                    option: myKmlOption
//                });
//                var pipeLayer = new google.maps.KmlLayer({
//                    url: 'http://caweb.elislab.elis.org/SmartWater/Pipe.kml',
//                    map: map,
//                    option: myKmlOption
//                });

            }

            google.maps.event.addDomListener(window, 'load', initialize);

        </script>    
        <!--    <script src="http://openlayers.org/api/OpenLayers.js"></script>
                <script type="text/javascript">
                    var map, baseLayer;
                    function init() {
                        map = new OpenLayers.Map('map');
        
                        baseLayer = new OpenLayers.Layer.WMS("OpenLayers WMS", "http://labs.metacarta.com/wms/vmap0", {layers: "basic"});
                        map.addLayer(baseLayer);
        
                        kml1 = new OpenLayers.Layer.Vector("KML", {
                            strategies: [new OpenLayers.Strategy.Fixed()],
                            protocol: new OpenLayers.Protocol.HTTP({
                                url: "../file/Noise_loggers.kml",
                                format: new OpenLayers.Format.KML({
                                    extractStyles: true,
                                    extractAttributes: true,
                                    maxDepth: 2
                                })
                            })
                        });
                        map.addLayer(kml1);
        
                        map.zoomToMaxExtent();
                    }
                </script>-->
        <script type="text/javascript">
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
                        <!--                    <li style="border-right:0;">
                                                <dl class="staticMenu">
                                                    <dt><a class="" href="settings" onClick="return false;">Account<span class="arrow"></span></a></dt>
                                                    <dd>
                                                        <ul class="mainMenuSub" style="right: -1px; left: auto; display: none;">
                                                            <li><a href="http://www.google.co.in/reader">Reader</a></li>
                                                            <li><a href="https://sites.google.com">Sites</a></li>
                                                            <li><a href="http://groups.google.co.in">Groups</a></li>
                                                            <li><a href="http://www.youtube.com">YouTube</a></li>
                                                            <li>
                                                                <div class="mid-line">
                                                                </div>
                                                            </li>
                                                            <li><a href="http://www.google.co.in/imghp?hl=en&tab=wi">Images</a></li>
                                                            <li><a href="http://maps.google.co.in/maps?hl=en&tab=wl">Maps</a></li>
                                                            <li><a href="http://translate.google.co.in/">Translate</a></li>
                                                            <li><a href="http://books.google.co.in">Books</a></li>
                                                            <li><a href="http://scholar.google.co.in/">Scholar</a></li>
                                                            <li><a href="http://blogsearch.google.co.in">Blogs</a></li>
                                                            <li>
                                                                <div class="mid-line">
                                                                </div>
                                                            </li>
                                                            <li><a href="http://www.google.co.in/intl/en/options/">even more >></a></li>
                                                            <li>
                                                                <div class="mid-line">
                                                                </div>
                                                            </li>
                                                        </ul>
                                                    </dd>
                                                </dl>
                                            </li>-->
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
        

    </body>
</html>
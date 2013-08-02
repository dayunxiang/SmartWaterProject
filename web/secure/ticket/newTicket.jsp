<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8; initial-scale=1.0; user-scalable=no">
        <script>
            ESPN_refresh = window.setTimeout(function() {
                window.location.href = "<%=request.getContextPath()%>/secure/index.jsp"
            }, 10000);
        </script>   
    <noscript>   
        <meta http-equiv=”refresh” content=”10″ />   
    </noscript>
    <style type="text/css">
        #logo{
            height: 50px;
        }
        #title{
            margin-left: 10px;
            font-size: large;
            font-weight: bold;
        }
        #subtitle{
            margin-left: 10px;
            font-size: small;
        }
    </style>
    <title>TI-LeD - Telecom Italia Leak Detection</title>

    <!-- see https://github.com/douglascrockford/JSON-js -->
    <script src="<%=request.getContextPath()%>/js/json2.js" type="text/javascript"></script>
    <script src="<%=request.getContextPath()%>/js/geoxml3.js" type="text/javascript"></script>


    <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>
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
                        $('#sign').attr("href", "<%=request.getContextPath()%>/services/auth/logout");
                    }


                    return false;
                });
            });
    </script>

    <script type="text/javascript">
        function getUrlValue(VarSearch) {
            var SearchString = window.location.search.substring(1);
            var VariableArray = SearchString.split('&');
            for (var i = 0; i < VariableArray.length; i++) {
                var KeyValuePair = VariableArray[i].split('=');
                if (KeyValuePair[0] == VarSearch) {
                    return KeyValuePair[1];
                }
            }
        }
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
            $(document).ready(function() {
                $('#title').html('Elaborazione in corso...Attendere');
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
                            $('#title').html('Inserito nuovo ticket #' + data.data.id);
                            $('#subtitle').html('Riceverai una email di avvenuta apertura ticket');

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
    <div style="clear:both; margin-top:40px;">&nbsp;</div>
    <div id="header"><!-- begin header -->

        <div class="mainbar" >
            <div>
                <ul class="mainMenu" >
                    <!-- Using class="current" for the link of the current page -->
                    <li class="" style="float:left;">
                        <img id="logo" src="<%=request.getContextPath()%>/file/Logo_TILab.jpg">
                    </li>
                    <li class="" style="float:left;"><!-- for links with no dropdown -->
                        <a id="sign-in" target="_self" href="<%=request.getContextPath()%>/homepage.jsp">+You</a>
                    </li>
                    <!-- Using class="current" for the link of the current page -->
                    <li class="" style="float:left;">
                        <a target="_self" href="<%=request.getContextPath()%>/secure/index.jsp">Mappa Idrica</a>
                    </li>
                    <li class="" style="float:left;">
                        <a id="ticket" target="_self" href="<%=request.getContextPath()%>/secure/ticket/ticket.jsp">Gestione Ticket</a>
                    </li>
                    <li class="current" style="float:left;">
                        <a id="newTicket" target="_self">Richiesta Manutenzione</a>
                    </li>
                    <li class="" style="float:right;"><!-- for links with no dropdown -->
                        <a id="sign" target="_self" href="<%=request.getContextPath()%>/auth/auth.jsp">Registrati</a>
                    </li>
                    <li class="" style="float:right;"><!-- for links with no dropdown -->
                        <a id="reset" target="_self" href="<%=request.getContextPath()%>/reset.jsp">Reset Valori Mappa</a>
                    </li>
                    <li class="" style="float:right;">
                        <a id="startcom" target="_self" href="<%=request.getContextPath()%>/startCom.jsp">Avvia Comunicazione</a>
                    </li>
                    <!--                    <li class="" style="float:right;"> for links with no dropdown 
                                            <a id="simul" target="_self" href="<%=request.getContextPath()%>/secure/simulation.jsp">Simulazione Dati</a>
                                        </li>-->
                </ul>             	
            </div>
        </div>
        <h1 id="title"></h1>
        <h2 id="subtitle"></h2>

        <br/><br/>

        <div id="info"></div>

</body>
</html>
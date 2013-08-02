<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8; initial-scale=1.0; user-scalable=no">
        <!--        <script>
                    ESPN_refresh = window.setTimeout(function() {
                        window.location.href = "<%=request.getContextPath()%>/secure/index.jsp"
                    }, 7000);
                </script>   
            <noscript>   
                <meta http-equiv=”refresh” content=”5″ />   
            </noscript>-->
        <style type="text/css">
            #logo{
                height: 50px;
            }
            #title{
                margin-left: 15px;
                font-size: large;
                font-weight: bold;
            }
            #subtitle{
                margin-left: 15px;
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
                    if ("<%=request.getUserPrincipal()%>" != "" && "<%=request.getUserPrincipal()%>" != "null") {

                        $('#sign-in').html("<%=request.getUserPrincipal()%>");
                        $('#sign').html("Logout");
                        $('#sign').attr("href", "<%=request.getContextPath()%>/services/auth/logout");
                    }


                    return false;
                });
            });
        </script>

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
            function addComunication() {
                var ip = this.ip.value;
                if (ip == "" || ip == null) {
                    ip = "localhost";
                }
                var data = {
                    ip: ip
                };
                var destinationUrl = "<%=request.getContextPath()%>/services/auth/startcom";
                $.ajax({
                    url: destinationUrl,
                    type: "POST",
                    data: data,
                    cache: false,
                    dataType: "json",
                    success: function(data, textStatus, jqXHR) {
                        if (data.status == "SUCCESS") {
                            //redirect to secured page
                            $('#title').html('Comunicazione con il gateway avviata con successo');
                            $('#subtitle').html('Adesso è possibile ricevere i dati dalla rete');

                        } else {
                        }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        $('#title').html('Problemi di comunicazione con il server');
                        $('#subtitle').html('Riprovare ad avviare la comunicazione');
                    },
                    complete: function(jqXHR, textStatus) {
                        //alert("complete");
                    }
                });


                return false;
            }
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
                        <li class="" style="float:right;"><!-- for links with no dropdown -->
                            <a id="sign" target="_self" href="<%=request.getContextPath()%>/auth/auth.jsp">Registrati</a>
                        </li>
                        <li class="" style="float:right;"><!-- for links with no dropdown -->
                            <a id="reset" target="_self" href="<%=request.getContextPath()%>/reset.jsp">Reset Valori Mappa</a>
                        </li>
                        <li class="current" style="float:right;"><!-- for links with no dropdown -->
                            <a id="startcom" target="_self" href="<%=request.getContextPath()%>/startCom.jsp">Avvia Comunicazione</a>
                        </li>
                    </ul>             	
                </div>
            </div>
            <div style="margin-left: 25px;">
                <p>         
                    <img id="logo_tiled" style="height: 30%; width: 30%; float: right; margin-right: 15%;" src="<%=request.getContextPath()%>/file/LOGO_TI_LED.png" align="middle">
                    <br><br><br><br>
                <table id="field">
                    <tr align="center">
                        <td>
                            <font size="2">Inserisci l'indirizzo IP pubblico del gateway; qualora fosse collegato via USB premi solamente il pulsante.</font>
                            <br><br>
                            <font size="3"><b>Indirizzo IP</b></font> 
                            <br>
                            <input size="50px" type="text" id="ip" name="ip"/>
                            <br>
                            <br>
                            <button id="addIp" onclick="addComunication()">Avvia Comunicazione</button>
                            <div style="clear:both; margin-top:20px;">&nbsp;</div>
                        </td>
                    </tr>
                </table>
                </p>
            </div>
            <br><br>
            <h1 id="title"></h1>
            <h2 id="subtitle"></h2>


    </body>
</html>
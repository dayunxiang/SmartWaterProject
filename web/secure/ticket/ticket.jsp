<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style type="text/css">
            table {
                width: 100%;
                border: 2px solid #000000;
                text-align: left; }
            th {
                font-weight: bold;
                color: white;
                background-color: #c40109;
                border-bottom: 1px solid;
                font-size: large;
            }
            td,th {
                padding: 4px 5px; }
            tr:nth-of-type(odd) {
                /*                background-color:#07abd8;*/
                background-color: #b9b9b9;
                alignment-adjust: central;
            }
            /*            .odd {
                            background-color: #def; }
                        .odd td {
                            border-bottom: 1px solid #cef; }  */
            #logo{
                height: 50px;
            }
            #ticketsList{
                margin-left: 5px;
                margin-right: 5px;
            }
            #title{
                margin-left: 5px;
                font-size: large;
                font-weight: bold;
            }
        </style>
        <script src="<%=request.getContextPath()%>/js/json2.js" type="text/javascript"></script>

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
                    $('#title').append('Lista Ticket' +
                            '<img id="logo_tiled" style="height: 15%; width: 15%; padding-left:65%; align:middle;" src="<%=request.getContextPath()%>/file/LOGO_TI_LED.png" align="middle">');
                    if ("<%=request.getUserPrincipal()%>" != "") {

                        $('#sign-in').html("<%=request.getUserPrincipal()%>");
                        $('#sign').html("Logout");
                        $('#sign').attr("href", "<%=request.getContextPath()%>/services/auth/logout");
                    }
                    $.ajax({
                        url: "<%=request.getContextPath()%>/services/ticket/list",
                        type: "GET",
                        cache: false,
                        dataType: "json",
                        success: function(data, textStatus, jqXHR) {
                            //alert("success");
                            var table;
                            if (data.status == "SUCCESS") {

                                for (var key = 0, size = data.data.length; key < size; key++) {
                                    table += '<tr><td>'
                                            + data.data[key].noiselogger
                                            + '</td><td>'
                                            + data.data[key].stato
                                            + '</td><td>'
                                            + data.data[key].info
                                            + '</td></tr>';
                                }
                                $('#table_content').html(table);
                            } else {
                                alert("failed");
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
                });

                return false;
            });
        </script>

        <title>TI-LeD - Telecom Italia Leak Detection</title>
    </head>
    <body>
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
                        <li class="current" style="float:left;">
                            <a id="ticket" target="_self" href="<%=request.getContextPath()%>/secure/ticket/ticket.jsp">Gestione Ticket</a>
                        </li>
                        <li class="" style="float:right;"><!-- for links with no dropdown -->
                            <a id="sign" target="_self" href="<%=request.getContextPath()%>/auth/auth.jsp">Registrati</a>
                        </li>
                        <li class="" style="float:right;"><!-- for links with no dropdown -->
                            <a id="reset" target="_self" href="<%=request.getContextPath()%>/reset.jsp">Reset Valori Mappa</a>
                        </li>
<!--                        <li class="" style="float:right;">
                            <a id="startcom" target="_self" href="<%=request.getContextPath()%>/startCom.jsp">Avvia Comunicazione</a>
                        </li>-->
                        <li class="" style="float:right;">
                            <a id="simul" target="_self" href="<%=request.getContextPath()%>/secure/simulation.jsp">Simulazione Dati</a>
                        </li>
                    </ul>             	
                </div>
            </div>
            <div id="title_bar">
                <p id="title">
<!--                    <img id="logo_tiled" src="<%=request.getContextPath()%>/file/LOGO_TI_LED.png" align="middle">-->
                </p>
            </div>
            <br/><br/>
            <div id="ticketsList">
                <table id="TicketTable">
                    <thead>
                        <tr><th>Noise Logger</th><th>Stato</th><th>Info</th></tr>
                    </thead>
                    <tbody id="table_content">

                    </tbody>
            </div>

    </body>

</html>

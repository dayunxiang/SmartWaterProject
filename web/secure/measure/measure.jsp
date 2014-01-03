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
                            background-color: #3399ff; }
                        .odd td {
                            border-bottom: 1px solid #3399ff; }  */
            #logo{
                height: 50px;
            }
            #measureList{
                margin-left: 5px;
                margin-right: 5px;
            }
            #title{
                margin-left: 5px;
                font-size: large;
                font-weight: bold;
            }
            /*            #logo_tiled{
                            height: 7%;
                            width: 7%;
                            padding-left: 200px;
                        }*/
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
                    $('#title').append('Storico Noise logger #' + getUrlValue("nl") +
                            '<img id="logo_tiled" style="height: 15%; width: 15%; padding-left:65%; align:middle;" src="<%=request.getContextPath()%>/file/LOGO_TI_LED.png" align="middle">');
                    if ("<%=request.getUserPrincipal()%>" != "") {

                        $('#sign-in').html("<%=request.getUserPrincipal()%>");
                        $('#sign-in').attr("href", "<%=request.getContextPath()%>/secure/index.jsp");
                        $('#sign').html("Logout");
                        $('#sign').attr("href", "<%=request.getContextPath()%>/secure/logout.jsp");
                        $('#storico').attr("href", document.URL);
                    }


                    return false;
                });
            });
        </script>

        <title>TI-LeD - Telecom Italia Leak Detection</title>
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
                $(document).ready(function() {
                    $('#title').html('Elaborazione in corso...Attendere');

                    var data = {
                        noiselogger: getUrlValue("nl")
                    };
                    $.ajax({
                        url: "<%=request.getContextPath()%>/services/measure/list",
                        type: "POST",
                        data: data,
                        cache: false,
                        dataType: "json",
                        success: function(data, textStatus, jqXHR) {
                            //alert("success");
                            var table;
                            if (data.status == "SUCCESS") {

                                for (var key = 0, size = data.data.length; key < size; key++) {
                                    table += '<tr><td>#'
                                            + data.data[key].noiselogger
                                            + '</td><td>'
                                            + data.data[key].timestamp
                                            + '</td><td>'
                                            + data.data[key].value
                                            + '</td><td>'
                                            + data.data[key].battery
                                            + '%</td></tr>';
                                }
                                $('#table_content').html(table);
                                $('#title').html('Elenco delle ultime misure effettuate - Noise Logger #' + data.data[key - 1].noiselogger);
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
            });
            $(function() {
                "use strict";
                $('#setNewMeasure').click(function() {
                    var data = {
                        noiselogger: getUrlValue("nl")
                    };
                    $.ajax({
                        url: "<%=request.getContextPath()%>/services/measure/newmeasure",
                        type: "POST",
                        data: data,
                        cache: false,
                        dataType: "json",
                        success: function(data, textStatus, jqXHR) {
                            //alert("success");
                            if (data.status == "SUCCESS") {
                                //redirect to secured page
                                $("#info").html("Measure added");
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
        <div style="clear:both; margin-top:40px;">&nbsp;</div>
        <div id="header"><!-- begin header -->

            <div class="mainbar" >
                <div>
                    <ul class="mainMenu" >
                        <!--                         Using class="current" for the link of the current page -->
                        <li class="" style="float:left;">
                            <img id="logo" src="<%=request.getContextPath()%>/file/telecom.jpg">
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
                        <li class="current" style="float:left;" >
                            <a id="storico" target="_self">Storico Noise Logger</a>
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
<!--                        <li class="" style="float:right;">
                            <a id="simul" target="_self" href="<%=request.getContextPath()%>/secure/simulation.jsp">Simulazione Dati</a>
                        </li>-->
                    </ul>             	
                </div>
            </div>
            <!--            <br/><br/>-->
            <div id="title_bar">
                <p id="title">
<!--                    <img id="logo_tiled" src="<%=request.getContextPath()%>/file/LOGO_TI_LED.png" align="middle">-->
                </p>
            </div>
            <!--            <button id="setNewMeasure">Set New Measure</button>-->
<!--                <img id="logo_tiled" src="<%=request.getContextPath()%>/file/LOGO_TI_LED.png"/></div>-->
            <br/><br/>
            <div id="measureList">
                <table id="MeasureTable">
                    <thead>
                        <tr><th>Noise Logger</th><th>Timestamp</th><th>Value</th><th>Battery</th></tr>
                    </thead>
                    <tbody id="table_content">

                    </tbody>
            </div>
            <div id="info"></div>

    </body>

</html>

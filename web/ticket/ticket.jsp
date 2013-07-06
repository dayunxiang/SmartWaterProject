<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
                    if ("<%=request.getUserPrincipal()%>" != "") {

                        $('#sign-in').html("<%=request.getUserPrincipal()%>");
                        $('#sign').html("Logout");
                        $('#sign').attr("href", "<%=request.getContextPath()%>/services/auth/logout");
                    }


                    return false;
                });
            });
        </script>

        <title>JSP Page</title>
        <script type="text/javascript">
            $(function() {
                "use strict";
                $('#sign').click(function() {
                    if ("<%=request.getUserPrincipal()%>" == "") {
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
                                window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/homepage.jsp");
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
                $("#getTicketsList").click(function() {
                    $.ajax({
                        url: "<%=request.getContextPath()%>/services/ticket/list",
                        type: "GET",
                        cache: false,
                        dataType: "json",
                        success: function(data, textStatus, jqXHR) {
                            //alert("success");
                            if (data.status == "SUCCESS") {
                                var table = '<tr><td>'
                                        + 'ID'
                                        + '</td><td>'
                                        + 'Noise Logger'
                                        + '</td><td>'
                                        + 'Stato'
                                        + '</td><td>'
                                        + 'Info'
                                        + '</td></tr>';

                                for (var key = 0, size = data.data.length; key < size; key++) {
                                    table += '<tr><td>'
                                            + data.data[key].id
                                            + '</td><td>'
                                            + data.data[key].noiselogger
                                            + '</td><td>'
                                            + data.data[key].stato
                                            + '</td><td>'
                                            + data.data[key].info
                                            + '</td></tr>';
                                }
                                $('#ticketsList').html(table);
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
        </script>

    </head>
    <body>
        <div style="clear:both; margin-top:20px;">&nbsp;</div>
        <div id="header"><!-- begin header -->

            <div class="mainbar" >
                <div>
                    <ul class="mainMenu" >
                        <!-- Using class="current" for the link of the current page -->
                        <li class="current" style="float:left;"><!-- for links with no dropdown -->
                            <a id="sign-in" target="_self" href="<%=request.getContextPath()%>/login/login.jsp">+You</a>
                        </li>
                        <li class="" style="float:left;">
                            <a target="_self" href="<%=request.getContextPath()%>/homepage.jsp">Home</a>
                        </li>
                        <li class="" style="float:right; margin-right:3em;"><!-- for links with no dropdown -->
                            <a id="sign" target="_self" href="<%=request.getContextPath()%>/auth/auth.jsp">Sing-up</a>
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
            <h1>You are logged in.</h1>
            <button id="getTicketsList">Get Ticket List</button>
            <br/><br/>
            <div id="ticketsList"></div>

    </body>

</html>

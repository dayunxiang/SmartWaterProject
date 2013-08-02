<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style type="text/css">
            #logo{
                height: 50px;
                margin-left: 0px;
            }
            #logo_tiled{
                padding-top: 1em;
            }
            #title{
                text-align: center;
            }
            #sub_title{
                text-align: center;
            }
            #field{
                margin-left: 150px;
                padding-top: 1em;
                padding-bottom: 1em;
                border: 1px solid;
                width: 400px;
                height: 300px;
            }
            /*            #login #buttonRow,#register #buttonRow{
                            text-align: left;
                        }
                        #buttonRow{
                            margin-left: 10em;
                            padding-right: 10px;
                        }
                        #login input[type=submit],#register input[type=submit]{
                            color: #fff;
                            border: 2px outset;
                        }
                        #login{
                            margin-left: 30%;
                        }*/
        </style>
        <!--        <link rel="stylesheet" type="text/css" href="css/formStyle.css" />-->
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
                    if (<%=request.getUserPrincipal()%> != null) {
                        $('#sign-in').html("<%=request.getUserPrincipal()%>");
                        $('#sign-in').attr("href", "<%=request.getContextPath()%>/secure/index.jsp");
                        $('#sign').html("Logout");
                        $('#sign').attr("href", "<%=request.getContextPath()%>/services/auth/logout");
                    }
                    return false;
                });
            });
            $(function() {
                "use strict";

                $('#sign').click(function() {
                    if (<%=request.getUserPrincipal()%> == null) {
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

                $(document.forms['loginForm']).submit(function(event) {

                    var data = {
                        email: this.email.value,
                        password: this.password.value
                    };

                    //only for test --- to remove and delete comment above
//                    var data = {
//                        email: "pelldav@gmail.com",
//                        password: "davide"
//                    };

                    var destinationUrl = this.action;

                    $.ajax({
                        url: destinationUrl,
                        type: "POST",
                        data: data,
                        cache: false,
                        dataType: "json",
                        success: function(data, textStatus, jqXHR) {
                            //alert("success");
                            if (data.status == "SUCCESS") {
                                //redirect to secured page
                                window.location.replace("https://" + window.location.host + "<%=request.getContextPath()%>/secure/index.jsp");
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

                    //event.preventDefault();
                    return false;
                });
            });
        </script>       

        <title>TI-LeD - Telecom Italia Leak Detection</title> 
    </head>
    <div style="clear:both; margin-top:40px;">&nbsp;</div>
    <div id="header"><!-- begin header -->

        <div class="mainbar" >
            <div>
                <ul class="mainMenu" >
                    <li class="" style="float:left;">
                        <img id="logo" src="<%=request.getContextPath()%>/file/Logo_TILab.jpg">
                    </li>
                    <li class="current" style="float:left;"><!-- for links with no dropdown -->
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
                    <li class="" style="float:right;">
                        <a id="startcom" target="_self" href="<%=request.getContextPath()%>/startCom.jsp">Avvia Comunicazione</a>
                    </li>
                </ul>             	
            </div>
        </div>
        <br/><br/>
    </div><!-- end header -->	
    <body>
        <div style="text-align: center">
            <br><br>
            <h1 id="title">TI-LeD</h1>
            <h2 id="sub_title">Servizio di Smart Leak Detection</h2>
            <br><br><br>
        </div>
        <!--        <div id="login">
                    <form id="loginForm" name="loginForm" action="<%=request.getContextPath()%>/services/auth/login" method="post">
                        <fieldset>
                            <legend>Login</legend>
        
                            <div>
                                <label for="email">Email</label> 
                                <input type="text" id="email" name="email"/>
                                <label for="password">Password</label> 
                                <input type="password" id="password" name="password"/>
                            </div>
                                                <div>
                                                    <label for="password">Password</label> 
                                                    <input type="password" id="password" name="password"/>
                                                </div>
        
                            <div class="buttonRow">
                                <input type="submit" value="Login" />
        
                                <a href="<%=request.getContextPath()%>/auth/auth.jsp"> Registrati!</a>
                            </div>
                        </fieldset>
                    </form> 
                </div>-->
        <!--        <fieldset id="field" style="align: center;">-->
        <div>
            <p>         
                <img id="logo_tiled" style="height: 30%; width: 30%; float: right; margin-right: 15%;" src="<%=request.getContextPath()%>/file/LOGO_TI_LED.png" align="middle">
            <table id="field">
                <tr align="center">
                    <td>
                        <form id="loginForm" name="loginForm" action="<%=request.getContextPath()%>/services/auth/login" method="post">
                            <font size="3"><b>Email</b></font> 
                            <br>
                            <input size="50px" type="text" id="email" name="email"/>
                            <br>
                            <br>
                            <font size="3"><b>Password</b></font>
                            <br>
                            <input size="50px" type="password" id="password" name="password"/>
                            <br>
                            <br>
                            <br>
                            <input type="submit" value="Login"  size="3"/>
                            <div style="clear:both; margin-top:20px;">&nbsp;</div>
                            <a href="<%=request.getContextPath()%>/auth/auth.jsp"><font size="3"> Registrati!</font></a>
                        </form>
                    </td>
                </tr>
            </table>
        </p>
    </div>
    <!--        </fieldset>-->

</body>
</html>

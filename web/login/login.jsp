<%@page contentType="text/html" pageEncoding="UTF-8"
        %><%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c' 
        %><c:if test="${pageContext.request.userPrincipal!=null}">
    <c:redirect url="/secure/index.jsp"/>
    <!-- this will redirect if user is already logged in -->
</c:if>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../css/formStyle.css" />
        <title>JSP Page</title>

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
        </script>


        <script type="text/javascript">
            $(function() {
                "use strict";

                $(document.forms['loginForm']).submit(function(event) {

//                    var data = {
//                        email: this.email.value,
//                        password: this.password.value
//                    };

                    //only for test --- to remove and delete comment above
                    var data = {
                        email: "pelldav@gmail.com",
                        password: "davide"
                    };

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


        <title>Smart Leak Detection - Homepage</title> 
    </head>
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
        <br/><br/>
    </div><!-- end header -->	


</head>
<body>
    <h1>Login Page</h1>
    <a href="<%=request.getContextPath()%>/homepage.jsp" >go to homepage</a>
    <div class="login">
        <c:if test="false">
            <div class="authError">
                Invalid User Name or Password. Please try again.
            </div>
        </c:if>

        <form id="loginForm" name="loginForm" action="<%=request.getContextPath()%>/services/auth/login" method="post">
            <fieldset>
                <legend>Login</legend>

                <div>
                    <label for="email">Email</label> 
                    <input type="text" id="email" name="email"/>
                </div>
                <div>
                    <label for="password">Password</label> 
                    <input type="password" id="password" name="password"/>
                </div>

                <div class="buttonRow">
                    <input type="submit" value="Login" />
                </div>

            </fieldset>
        </form> 
    </div>
</body>
</html>

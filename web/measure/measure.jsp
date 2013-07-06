<%@page import="java.security.Principal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="<%=request.getContextPath()%>/js/json2.js" type="text/javascript"></script>

        <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>

        <title>JSP Page</title>
        <script type="text/javascript">
            $(function() {
                "use strict";
                $('#logoutLink').click(function() {

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
                $("#getMeasureList").click(function() {
                    $.ajax({
                        url: "<%=request.getContextPath()%>/services/measure/list",
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
                                        + 'Timestamp'
                                        + '</td><td>'
                                        + 'Value'
                                        + '</td><td>'
                                        + 'Battery'
                                        + '</td></tr>';

                                for (var key = 0, size = data.data.length; key < size; key++) {
                                    table += '<tr><td>'
                                            + data.data[key].id
                                            + '</td><td>'
                                            + data.data[key].noiselogger
                                            + '</td><td>'
                                            + data.data[key].timestamp
                                            + '</td><td>'
                                            + data.data[key].value
                                            + '</td><td>'
                                            + data.data[key].battery
                                            + '</td></tr>';
                                }
                                $('#measureList').html(table);
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
                        noiselogger: "1234567890"
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
        <h1>You are logged in.</h1>
        <a id="logoutLink" href="<%=request.getContextPath()%>/services/auth/logout" >logout</a>
        <button id="getMeasureList">Get Measure List</button>
        <button id="setNewMeasure">Set New Measure</button>

        <br/><br/>
        <div id="measureList"></div>
        <div id="info"></div>

    </body>

</html>

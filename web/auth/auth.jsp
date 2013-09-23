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
        <link rel="stylesheet" type="text/css" href="../css/formStyle.css" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>TI-LeD - Telecom Italia Leak Detection</title>

        <!-- see https://github.com/douglascrockford/JSON-js -->
        <!-- alternative: http://code.google.com/p/jquery-json/ -->
        <!-- 
        John Resig (author of jQuery) said: 
          "In the meantime PLEASE start migrating your JSON-using applications over to Crockford's json2.js"
        see here: http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/ 
        -->
        <script src="<%=request.getContextPath()%>/js/json2.js" type="text/javascript"></script>

        <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>

        <style type="text/css">
            #logo{
                height: 50px;
            }
            #title{
                margin-left: 5px;
                font-size: large;
                font-weight: bold;
                margin-left: 150px;
            }
            #sub_title{
                margin-left: 5px;
                font-size: medium;
                margin-left: 120px;
            }
            #field{
                margin-left: 150px;
                padding-top: 1em;
                padding-bottom: 1em;
                border: 1px solid;
                width: 300px;
            }
            #auth_error{
                margin-left: 150px;
            }
        </style>


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
                        $('#sign').attr("href", "<%=request.getContextPath()%>/secure/logout.jsp");
                    }


                    return false;
                });
            });
        </script>


        <script type="text/javascript">
            var okCheck = false;
            var minYear = 1902;
            var maxYear = (new Date()).getFullYear();

            function check() {
                var dateFormat = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;
                var emailFormat = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                var errorMsg = "";
                var isBlank = false;
                //check nome
                document.getElementById("fname_div").setAttribute("style", "color: black");
                if (this.fname.value == "" || this.fname.value == null) {
                    document.getElementById("fname_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check cognome
                document.getElementById("lname_div").setAttribute("style", "color: black");
                if (this.lname.value == "" || this.lname.value == null) {
                    document.getElementById("lname_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check password
                document.getElementById("password1_div").setAttribute("style", "color: black");
                if (this.password1.value == "" || this.password1.value == null) {
                    document.getElementById("password1_div").setAttribute("style", "color: red");
                    isBlank = true;
                }
                document.getElementById("password2_div").setAttribute("style", "color: black");
                if (this.password2.value == "" || this.password2.value == null) {
                    document.getElementById("password2_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                if (this.password2.value != "" && this.password1.value != this.password2.value) {
                    errorMsg += "- Le password inserite devono essere uguali<br>";
                    this.password2.value = "";
                    document.getElementById("password2_div").setAttribute("style", "color: red");
                }

                //check utility key
                document.getElementById("utilityKey_div").setAttribute("style", "color: black");
                if (this.utilityKey.value == "" || this.utilityKey.value == null) {
                    document.getElementById("utilityKey_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check place
                document.getElementById("place_div").setAttribute("style", "color: black");
                if (this.place.value == "" || this.place.value == null) {
                    document.getElementById("place_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check birth date
                document.getElementById("birth_div").setAttribute("style", "color: black");
                if (this.birth.value == "" || this.birth.value == null) {
                    document.getElementById("birth_div").setAttribute("style", "color: red");
                    isBlank = true;
                }
                if (this.birth.value != '') {
                    if (regs = this.birth.value.match(dateFormat)) {
                        if (regs[1] < 1 || regs[1] > 31) {
                            errorMsg += "- Valore non corretto per il giorno: " + regs[1] + "<br>";
                            document.getElementById("birth_div").setAttribute("style", "color: red");
                        } else if (regs[2] < 1 || regs[2] > 12) {
                            errorMsg += "- Valore non corretto per il mese: " + regs[2] + "<br>";
                            document.getElementById("birth_div").setAttribute("style", "color: red");
                        } else if (regs[3] < minYear || regs[3] > maxYear) {
                            errorMsg += "- Valore non corretto per l'anno: " + regs[3] + " - Deve essere compreso tra " + minYear + " e " + maxYear + "<br>";
                            document.getElementById("birth_div").setAttribute("style", "color: red");
                        }
                    } else {
                        errorMsg += "- Formato Data di nascita non corretto<br>";
                        document.getElementById("birth_div").setAttribute("style", "color: red");
                    }
                }

                //check via
                document.getElementById("way_div").setAttribute("style", "color: black");
                if (this.way.value == "" || this.way.value == null) {
                    document.getElementById("way_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check Codice fiscale
                document.getElementById("codFiscale_div").setAttribute("style", "color: black");
                if (this.codFiscale.value == "" || this.codFiscale.value == null) {
                    document.getElementById("codFiscale_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

//                if (this.codFiscale.value != "") {
//                    var cf = codFiscaleCheck(this.codFiscale.value);
//                    if (cf != "") {
//                        document.getElementById("codFiscale_div").setAttribute("style", "color: red");
//                        errorMsg += cf;
//                    }
//                }

                //check cellulare
                document.getElementById("cellular_div").setAttribute("style", "color: black");
                if (this.cellular.value == "" || this.cellular.value == null) {
                    document.getElementById("cellular_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check azienda
                document.getElementById("company_div").setAttribute("style", "color: black");
                if (this.company.value == "" || this.company.value == null) {
                    document.getElementById("company_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check ruolo
                document.getElementById("job_div").setAttribute("style", "color: black");
                if (this.job.value == "" || this.job.value == null) {
                    document.getElementById("job_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check domanda segreta
                document.getElementById("secretQ_div").setAttribute("style", "color: black");
                if (this.secretQ.value == "" || this.secretQ.value == null) {
                    document.getElementById("secretQ_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check risposta segreta
                document.getElementById("secretR_div").setAttribute("style", "color: black");
                if (this.secretR.value == "" || this.secretR.value == null) {
                    document.getElementById("secretR_div").setAttribute("style", "color: red");
                    isBlank = true;
                }

                //check email
                document.getElementById("email_div").setAttribute("style", "color: black");
                if (this.email.value == "" || this.email.value == null) {
                    document.getElementById("email_div").setAttribute("style", "color: red");
                    isBlank = true;
                }
                if (this.email.value != "" && !emailFormat.test(this.email.value)) {
                    errorMsg += "- Email inserita in un formato errato<br>";
                    document.getElementById("email_div").setAttribute("style", "color: red");
                }


                if (errorMsg == "" && !isBlank) {
                    okCheck = true;
                }
                else {
                    if (isBlank) {
                        errorMsg += "- Inserire i campi mancanti";
                    }
                    document.getElementById("auth_error").innerHTML = errorMsg;
                }

            }

            function codFiscaleCheck(cf) {
                var validi, i, s, set1, set2, setpari, setdisp;
                cf = cf.toUpperCase();
                if (cf.length != 16)
                    return "La lunghezza del codice fiscale non è corretta: il codice fiscale dovrebbe essere lungo esattamente 16 caratteri.\n";
                validi = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                for (i = 0; i < 16; i++) {
                    if (validi.indexOf(cf.charAt(i)) == -1)
                        return "Il codice fiscale contiene un carattere non valido `" + cf.charAt(i) + "'.\nI caratteri validi sono le lettere e le cifre.\n";
                }
                set1 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                set2 = "ABCDEFGHIJABCDEFGHIJKLMNOPQRSTUVWXYZ";
                setpari = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                setdisp = "BAKPLCQDREVOSFTGUHMINJWZYX";
                s = 0;
                for (i = 1; i <= 13; i += 2)
                    s += setpari.indexOf(set2.charAt(set1.indexOf(cf.charAt(i))));
                for (i = 0; i <= 14; i += 2)
                    s += setdisp.indexOf(set2.charAt(set1.indexOf(cf.charAt(i))));
                if (s % 26 != cf.charCodeAt(15) - 'A'.charCodeAt(0))
                    return "Il codice fiscale non è corretto: il codice di controllo non corrisponde.\n";
                return "";
            }
            $(function() {
                "use strict";

                $(document.forms['registerForm']).submit(function(event) {
                    document.getElementById("auth_error").innerHTML = "";
                    check();
                    if (okCheck == true) {
                        var data = {
                            fname: this.fname.value,
                            lname: this.lname.value,
                            email: this.email.value,
                            password1: this.password1.value,
                            password2: this.password2.value,
                            place: this.place.value,
                            birth: this.birth.value,
                            way: this.way.value,
                            codFiscale: this.codFiscale.value,
                            cellular: this.cellular.value,
                            company: this.company.value,
                            job: this.job.value,
                            secretQ: this.secretQ.value,
                            secretR: this.secretR.value,
                            utilityKey: this.utilityKey.value
                        };

                        var destinationUrl = this.action;

                        $.ajax({
                            url: destinationUrl,
                            type: "POST",
                            //data: data,
                            data: JSON.stringify(data),
                            contentType: "application/json",
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
                                //i.e. hide loading spinner
                            },
                            statusCode: {
                                404: function() {
                                    alert("page not found");
                                }
                            }
                        });
                    }
                    //event.preventDefault();
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
            <br/><br/>
        </div><!-- end header -->	
        <div>
            <br><br>
            <h1 id="title">Benvenuto nel servizio TI-LeD</h1>
            <h2 id="sub_title">Inserisci i dati per effettuare la registrazione</h2>
            <br><br><br>        
            <p>         
                <img id="logo_tiled" style="height: 30%; width: 30%; float: right; margin-right: 15%" src="<%=request.getContextPath()%>/file/LOGO_TI_LED.png" align="middle">
            <table id="field">
                <form id="registerForm" name="registerForm" action="<%=request.getContextPath()%>/services/auth/register" method="post">
                    <tr align="center">
                        <td>
                            *Tutti i campi sono obbligatori
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="fname_div">
                            <label for="fname">Nome</label> 
                        </td>
                        <td>
                            <input type="text" id="fname" name="fname"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="lname_div">
                            <label for="lname">Cognome</label> 
                        </td>
                        <td>
                            <input type="text" id="lname" name="lname"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="email_div">
                            <label for="email">Email</label> 
                        </td>
                        <td>
                            <input type="text" id="email" name="email"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="password1_div">
                            <label for="password1">Password</label> 
                        </td>
                        <td>
                            <input type="password" id="password1" name="password1"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="password2_div">
                            <label for="password2">Conferma Password</label> 
                        </td>
                        <td>
                            <input type="password" id="password2" name="password2"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="utilityKey_div">
                            <label for="utilityKey">Inserisci la chiave dell'Utility</label> 
                        </td>
                        <td>
                            <input type="text" id="utilityKey" name="utilityKey"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="place_div">
                            <label for="place">Luogo di nascita</label> 
                        </td>
                        <td>
                            <input type="text" id="place" name="place"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="birth_div">
                            <label for="birth">Data di nascita (dd/mm/yyyy)</label> 
                        </td>
                        <td>
                            <input type="text" id="birth" name="birth"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="way_div">
                            <label for="way">Via</label> 
                        </td>
                        <td>
                            <input type="text" id="way" name="way"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="codFiscale_div">
                            <label for="codFiscale">Codice Fiscale</label> 
                        </td>
                        <td>
                            <input type="text" id="codFiscale" name="codFiscale"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="cellular_div">
                            <label for="cellular">Numero di cellulare</label> 
                        </td>
                        <td>
                            <input type="text" id="cellular" name="cellular"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="company_div">
                            <label for="company">Azienda</label> 
                        </td>
                        <td>
                            <input type="text" id="company" name="company"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="job_div">
                            <label for="job">Ruolo</label> 
                        </td>
                        <td>
                            <input type="text" id="job" name="job"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="secretQ_div">
                            <label for="secretQ">Domanda segreta</label> 
                        </td>
                        <td>
                            <input type="text" id="secretQ" name="secretQ"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td id="secretR_div">
                            <label for="secretR">Risposta segreta</label> 
                        </td>
                        <td>
                            <input type="text" id="secretR" name="secretR"/>
                        </td>
                    </tr>
                    <tr align="center">
                        <td style="color: red">
                        </td>
                        <td>
                            <input type="submit" value="Register" />
                        </td>
                    </tr>


            </table>
        </p>
    </div>
    <div id="auth_error" style="color: red">

        <!--        <table id="register">
                    <form id="registerForm" name="registerForm" action="<%=request.getContextPath()%>/services/auth/register" method="post">
                        <fieldset>
                            <div id="info">*Tutti i campi sono obbligatori</div>
                            <div id="fname_div">
                                <label for="fname">Nome</label> 
                                <input type="text" id="fname" name="fname"/>
                            </div>
                            <div id="lname_div">
                                <label for="lname">Cognome</label> 
                                <input type="text" id="lname" name="lname"/>
                            </div>              
                            <div id="email_div">
                                <label for="email">Email</label> 
                                <input type="text" id="email" name="email"/>
                            </div>
                            <div id="password1_div">
                                <label for="password1">Password</label> 
                                <input type="password" id="password1" name="password1"/>
                            </div>
                            <div id="password2_div">
                                <label for="password2">Conferma Password</label> 
                                <input type="password" id="password2" name="password2"/>
                            </div>
                            <div id="utilityKey_div">
                                <label for="utilityKey">Inserisci la chiave dell'Utility</label> 
                                <input type="text" id="utilityKey" name="utilityKey"/>
                            </div>
                            <div id="place_div">
                                <label for="place">Luogo di nascita</label> 
                                <input type="text" id="place" name="place"/>
                            </div>  
                            <div id="birth_div">
                                <label for="birth">Data di nascita (dd/mm/yyyy)</label> 
                                <input type="text" id="birth" name="birth"/>
                            </div>
                            <div id="way_div">
                                <label for="way">Via</label> 
                                <input type="text" id="way" name="way"/>
                            </div>
                            <div id="codFiscale_div">
                                <label for="codFiscale">Codice Fiscale</label> 
                                <input type="text" id="codFiscale" name="codFiscale"/>
                            </div>
                            <div id="cellular_div">
                                <label for="cellular">Numero di cellulare</label> 
                                <input type="text" id="cellular" name="cellular"/>
                            </div>
                            <div id="company_div">
                                <label for="company">Azienda</label> 
                                <input type="text" id="company" name="company"/>
                            </div>
                            <div id="job_div">
                                <label for="job">Ruolo</label> 
                                <input type="text" id="job" name="job"/>
                            </div>
                            <div id="secretQ_div">
                                <label for="secretQ">Domanda segreta</label> 
                                <input type="text" id="secretQ" name="secretQ"/>
                            </div>
                            <div id="secretR_div">
                                <label for="secretR">Risposta segreta</label> 
                                <input type="text" id="secretR" name="secretR"/>
                            </div>
                            <div id="auth_error" style="color: red">
                            </div>
        
                            <div class="buttonRow">
                                <input type="submit" value="Register" />
                            </div>
        
                        </fieldset>
                    </form> 
                </table>-->

</body>

</html>
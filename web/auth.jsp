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
    <link rel="stylesheet" type="text/css" href="./css/auth.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Welcome Page</title>
     
    <!-- see https://github.com/douglascrockford/JSON-js -->
    <!-- alternative: http://code.google.com/p/jquery-json/ -->
    <!-- 
    John Resig (author of jQuery) said: 
      "In the meantime PLEASE start migrating your JSON-using applications over to Crockford's json2.js"
    see here: http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/ 
    -->
    <script src="<%=request.getContextPath() %>/js/json2.js" type="text/javascript"></script>
     
    <%@ include file="/WEB-INF/includes/head/jquery.jsp" %>
     
    <script type="text/javascript">
        var okCheck = false;
        var minYear = 1902;      
        var maxYear = (new Date()).getFullYear();
        
        function check(){        
            var dateFormat = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;
            var emailFormat = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            var errorMsg = "";
            var isBlank = false;
            //check nome
            if(this.fname.value == "") {
                document.getElementById("fname_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            //check cognome
            if(this.lname.value == "") {
                document.getElementById("lname_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            //check password
            if(this.password1.value == "") {
                document.getElementById("password1_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            if(this.password2.value == "") {
                document.getElementById("password2_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            if(this.password2.value!="" ||  this.password1.value != this.password2.value ){
                    errorMsg += "-Le password inserite devono essere uguali" + "\n";
                    this.password2.value ="";
                    document.getElementById("password2_div").setAttribute("style", "color: red");
                }
            
            //check place
            if(this.place.value == "") {
                document.getElementById("place_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            //check birth date
            if (this.birth.value == "") {
                 document.getElementById("birth_div").setAttribute("style", "color: red");
                 isBlank = true;
             }                     
             if(this.birth.value != '') {
              if(regs = this.birth.value.match(dateFormat)) {
                if(regs[1] < 1 || regs[1] > 31) {
                    errorMsg += "-Valore non corretto per il giorno: " + regs[1] + "\n";
                    document.getElementById("birth_div").setAttribute("style", "color: red");
                } else if(regs[2] < 1 || regs[2] > 12) {
                    errorMsg += "-Valore non corretto per il mese: " + regs[2] + "\n";
                    document.getElementById("birth_div").setAttribute("style", "color: red");
                 } else if(regs[3] < minYear || regs[3] > maxYear) {
                    errorMsg += "-Valore non corretto per l'anno: " + regs[3] + " - Deve essere compreso tra " + minYear + " e " + maxYear + "\n";
                    document.getElementById("birth_div").setAttribute("style", "color: red");
                }
              } else {
                errorMsg += "-Formato Data di nascita non corretto\n";                    
                document.getElementById("birth_div").setAttribute("style", "color: red");
              }
            } 
            
            //check via
            if(this.way.value == "") {
                document.getElementById("way_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            //check Codice fiscale
            if(this.codFiscale.value == "") {
                document.getElementById("codFiscale_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            if(this.codFiscale.value != ""){
                var cf = codFiscaleCheck(this.codFiscale.value);
                if(cf != ""){
                    document.getElementById("codFiscale_div").setAttribute("style", "color: red");
                    errorMsg += cf;
                }
            }
            
            //check cellulare
            if(this.cellular.value == "") {
                document.getElementById("cellular_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            //check azienda
            if(this.company.value == "") {
                document.getElementById("company_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            //check ruolo
            if(this.job.value == "") {
                document.getElementById("job_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            //check domanda segreta
            if(this.secretQ.value == "") {
                document.getElementById("secretQ_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            //check risposta segreta
            if(this.secretR.value == "") {
                document.getElementById("secretR_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            
            //check email
            if(this.email.value == ""){
                document.getElementById("email_div").setAttribute("style", "color: red");
                isBlank = true;
            }
            //if(this.email.value != "" && !emailFormat(this.email.value)){
            //    errorMsg += "Email inserita in un formato errato\n";
            //}
            
            
            
            if(errorMsg == "" && !isBlank) {
                okCheck = true;
            }
            else {
                if(isBlank) {
                    errorMsg += "\n" + "- Inserire i campi mancanti";
                }
                document.getElementById("auth_error").innerHTML = errorMsg;
            }
           
        }
        
        function codFiscaleCheck(cf){
            var validi, i, s, set1, set2, setpari, setdisp;
            cf = cf.toUpperCase();
            if( cf.length != 16 )
		return "La lunghezza del codice fiscale non è corretta: il codice fiscale dovrebbe essere lungo esattamente 16 caratteri.\n";
            validi = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            for( i = 0; i < 16; i++ ){
		if( validi.indexOf( cf.charAt(i) ) == -1 )
			return "Il codice fiscale contiene un carattere non valido `" + cf.charAt(i) + "'.\nI caratteri validi sono le lettere e le cifre.\n";
            }
            set1 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            set2 = "ABCDEFGHIJABCDEFGHIJKLMNOPQRSTUVWXYZ";
            setpari = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            setdisp = "BAKPLCQDREVOSFTGUHMINJWZYX";
            s = 0;
            for( i = 1; i <= 13; i += 2 )
		s += setpari.indexOf( set2.charAt( set1.indexOf( cf.charAt(i) )));
            for( i = 0; i <= 14; i += 2 )
		s += setdisp.indexOf( set2.charAt( set1.indexOf( cf.charAt(i) )));
            if( s%26 != cf.charCodeAt(15)-'A'.charCodeAt(0) )
		return "Il codice fiscale non è corretto: il codice di controllo non corrisponde.\n";
            return "";
        }
        $(function(){
            "use strict";
             
            $(document.forms['registerForm']).submit(function(event){
                check();
                if(okCheck == true){
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
                    secretR: this.secretR.value
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
                     
                    success: function (data, textStatus, jqXHR){
                        //alert("success");
                        if (data.status == "SUCCESS" ){
                           //redirect to secured page
                           window.location.replace("https://"+window.location.host+"<%=request.getContextPath() %>/secure/index.jsp");
                        }else{
                            alert("failed");
                        }
                    },
                     
                    error: function (jqXHR, textStatus, errorThrown){
                        alert("error - HTTP STATUS: "+jqXHR.status);
                         
                    },
                     
                    complete: function(jqXHR, textStatus){
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
             
            $(document.forms['loginForm']).submit(function(event){
                 
                var data = {
                    email: this.email.value,
                    password: this.password.value
                }; 
                var destinationUrl = this.action;
                     
                $.ajax({
                    url: destinationUrl,
                    type: "POST",
                    data: data,
                    cache: false,
                    dataType: "json",
                         
                    success: function (data, textStatus, jqXHR){
                        //alert("success");
                        if (data.status == "SUCCESS" ){
                            //redirect to secured page
                            window.location.replace("https://"+window.location.host+"<%=request.getContextPath() %>/secure/index.jsp");
                        }else{
                            alert("failed");
                        }
                    },
                         
                    error: function (jqXHR, textStatus, errorThrown){
                        alert("error - HTTP STATUS: "+jqXHR.status);
                    },
                         
                    complete: function(jqXHR, textStatus){
                        //alert("complete");
                    }                    
                });
                 
                //event.preventDefault();
                return false;
            });
        });
    </script>
     
  </head>
  <body>
    
    <h1>Welcome to our secured Web Application</h1>
    <a href="<%=request.getContextPath() %>/secure/index.jsp" >go to secured page</a>
    <br/><br/><br/>
      
    <div class="register">
      <form id="registerForm" name="registerForm" action="<%=request.getContextPath() %>/services/auth/register" method="post">
        <fieldset>
          <legend>Registration</legend>
              
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
            <input type="submit" value="Register and Login" />
          </div>
            
        </fieldset>
      </form> 
    </div>
       
    <br/><br/><br/>
     
    <div class="login">
      <form id="loginForm" name="loginForm" action="<%=request.getContextPath() %>/services/auth/login" method="post">
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
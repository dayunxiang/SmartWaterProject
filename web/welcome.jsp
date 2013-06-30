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
        $(function(){
            "use strict";
             
            $(document.forms['registerForm']).submit(function(event){
                var data = {
                    fname: this.fname.value,
                    lname: this.lname.value,
                    email: this.email.value,
                    password1: this.password1.value,
                    password2: this.password2.value
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
                        },
                    }
                     
                 
                });
                 
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
              
          <div>
            <label for="fname">First Name</label> 
            <input type="text" id="fname" name="fname"/>
          </div>
          <div>
            <label for="lname">Last Name</label> 
            <input type="text" id="lname" name="lname"/>
          </div>
              
          <div>
            <label for="email">Email</label> 
            <input type="text" id="email" name="email"/>
          </div>
          <div>
            <label for="password1">Password</label> 
            <input type="password" id="password1" name="password1"/>
          </div>
          <div>
            <label for="password2">Password (repeat)</label> 
            <input type="password" id="password2" name="password2"/>
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
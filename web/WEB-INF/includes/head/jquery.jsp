<%@page contentType="text/html" pageEncoding="UTF-8"%>
     
<!-- jq integration from google cdn (content delivery network) -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js" type="text/javascript"></script>
<!-- <script src="//ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js" type="text/javascript"></script> -->
        
<script type="text/javascript">
    //make sure jq is really loaded from google, else load it from our local server
    if (!window.jQuery){
        document.write(unescape("%3Cscript src='<%=request.getContextPath() %>/js/jquery/jquery-1.7.2.js' type='text/javascript'%3E%3C/script%3E"));
    }
</script>
     
<!-- jq-ui integration from google cdn (content delivery network) -->
<!-- you could do it this way, but we don't really need it for our tutorial-->
<!--
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.js" type="text/javascript"></script>
<link href="//ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
-->
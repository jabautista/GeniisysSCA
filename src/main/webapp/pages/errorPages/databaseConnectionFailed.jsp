<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="overflow-x: auto; overflow-y: auto;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Geniisys - General Insurance Information System</title>
</head>
<script type="text/javascript">
	function startTimer() {
		var t = setTimeout("refresh()", 20000);
	}
	
	function refresh() {
		window.location.reload();
	}
</script>
<body onload="startTimer()">
	<div id="errorMessageMainDiv" style="color: #505050; border: 1px solid #E0E0E0; padding: 35px; -moz-border-radius: 5px; width: 820px; margin-left: auto; margin-right: auto ; height: auto;">
		<div id="left" style="">
			<h1 style="font-size: 50px; font-family: arial; margin: 0; padding: 0;">GENIISYS</h1>
			<h5 style="font-family: arial; margin: 0;">General Insurance Information System</h5>
		</div>
		<div id="right" style="margin-top: 50px; margin-left: 160px;">
			<div id="messageHeader" style="margin: 0;">
				<h3 style="margin: 0;">Technical Difficulties</h3>
			</div>			
			<div id="messageContent" style="margin: 0;">				
				<p>The application was not able to connect to the database and will be temporarily unavailable at the moment. 
					We'll be back up and running again before long.</p>			
			</div>
		</div>		
	</div>
</body>
</html>
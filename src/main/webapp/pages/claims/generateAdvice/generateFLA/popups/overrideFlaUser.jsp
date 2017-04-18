<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="overideUserMainDiv" class="sectionDiv" style="width: 307px; margin: 5px 10px; margin-bottom: 10px;" align="center">
	<table border="0" align="center" style="margin-top: 10px; margin-bottom: 10px; width:100%;" >
		<tr>
			<td class="rightAligned" style="width:32%;">Username</td>
			<td class="leftAligned" style="width:68%;"><input type="text" id="overideUserName" tabindex="1" style="width: 150px;" value="" class="required"/></td>
		</tr>
		<tr>
			<td class="rightAligned" >Password</td>
			<td class="leftAligned"><input type="password" id="overidePassWord" style="width: 150px;" tabindex="2" value="" class="required"/></td>	
		</tr>
	</table>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 10px;">
	<input type="button" class="button" id="btnOverideOk" value="Ok" />
	<input type="button" class="button" id="btnOverideCancel" value="Cancel" />
</div>

<script type="text/javascript">
	$("overideUserName").focus();

	$("overideUserName").observe("keyup",function(){
		$("overideUserName").value = $("overideUserName").value.toUpperCase();
	});

	$("btnOverideOk").observe("click", function (){
		if ($("overideUserName").value == "" || $("overidePassWord").value == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){$("overideUserName").focus();});
		}
	});
	
	$("btnOverideCancel").observe("click", function(){
		overrideWindow.close();
	});
</script>
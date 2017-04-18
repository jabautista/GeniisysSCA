<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="overideUserMainDiv" class="sectionDiv" style="width: 380px; margin: 5px 10px;" align="center">
	<table border="0" align="center" style="margin-top: 10px; width:100%;" >
		<tr>
			<td class="rightAligned" style="width:32%;">Username</td>
			<td class="leftAligned" style="width:68%;"><input type="text" id="overideUserName" tabindex="1" style="width: 150px;" value="" /></td>
		</tr>	
		<tr>
			<td class="rightAligned" >Password</td>
			<td class="leftAligned"><input type="password" id="overidePassWord" style="width: 150px;" tabindex="2" value="" /></td>	
		</tr>
	</table>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 10px;">
	<input type="button" class="button" id="btnOverideOk" value="Ok" />
	<input type="button" class="button" id="btnOverideCancel" value="Cancel" />
</div>

<script type="text/javascript">
	$("btnOverideCancel").observe("click", function(){
		genericObjOverlay.close();
	});
	
	$("overideUserName").observe("keyup",function(){
		$("overideUserName").value = $("overideUserName").value.toUpperCase();
	});
	$("overidePassWord").observe("keyup",function(){
		$("overidePassWord").value = $("overidePassWord").value;//.toUpperCase(); // comment out 'toUpperCase' by andrew - 03.30.2011 - password is case sensitive
	});
	
	$("btnOverideOk").observe("click", function (){
		if ($("overideUserName").value == "" || $("overidePassWord").value == ""){
			showWaitingMessageBox("Username/Password cannot be null.", imgMessage.ERROR, function(){$("overideUserName").focus();});
			return;
		}
		new Ajax.Request(contextPath+"/GICLMcEvaluationController?action=validateOverride" , {
				method: "GET",
				parameters: {
					userName: $F("overideUserName"),
					password: $F("overidePassWord"),
					issCd: mcMainObj,
					vOverrideProc: variablesObj.vOverrideProc,
					resAmt: variablesObj.resAmt
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response) {
					var result = response.responseText.toQueryParams();
					if(result.message == "TRUE"){
						genericObjOverlay.close();
						postEvalReport(selectedMcEvalObj);
					}else if(result.message == "FALSE") {
						showWaitingMessageBox($F("overideUserName")+" is not allowed to override.", "I",function(){
							genericObjOverlay.close();
						});
					}else{
						showWaitingMessageBox(result.message, imgMessage.ERROR, function(){
							$("overideUserName").value = ""; // added by irwin. Applied universal standard when the username or password is invalid. -- 8.22.2012
							$("overidePassWord").value ="";
							//$("overidePassWord").focus();
							$("overideUserName").focus();
						});
					}	
				}	
		});
								
	});
</script>
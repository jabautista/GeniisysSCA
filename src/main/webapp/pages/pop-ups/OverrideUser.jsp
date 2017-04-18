<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="overideUserMainDiv" class="sectionDiv" style="width: 307px; margin: 5px 10px;" align="center">
	<table border="0" align="center" style="margin-top: 10px; width:100%;" >
		<tr>
			<td class="rightAligned" style="width:32%;">Username</td>
			<td class="leftAligned" style="width:68%;"><input type="text" id="overideUserName" tabindex="901" style="width: 150px;" value="" maxLength="8" /></td>
		</tr>	
		<tr>
			<td class="rightAligned" >Password</td>
			<td class="leftAligned"><input type="password" id="overidePassWord" style="width: 150px;" tabindex="902" value="" maxLength="50" /></td>	
		</tr>
	</table>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 10px;">
	<input type="button" class="button" id="btnOverideOk" value="Ok" />
	<input type="button" class="button" id="btnOverideCancel" value="Cancel" />
</div>
<script>
	$("overideUserName").focus();

	$("overideUserName").observe("keyup",function(){
		$("overideUserName").value = $("overideUserName").value.toUpperCase();
	});
	$("overidePassWord").observe("keyup",function(){
		$("overidePassWord").value = $("overidePassWord").value;//.toUpperCase(); // comment out 'toUpperCase' by andrew - 03.30.2011 - password is case sensitive
	});

	$("btnOverideOk").observe("click", function (){
		if ($("overideUserName").value == "" || $("overidePassWord").value == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){$("overideUserName").focus();});
			return;
		}
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=validateOverideUserDtls" , {
				method: "GET",	
				parameters: {
					userName: $F("overideUserName"),
					password: $F("overidePassWord"),
					funcCode: objAC.funcCode,
					moduleName: objACGlobal.calledForm
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response) {
					var result = response.responseText.toQueryParams();
					if(result.message == "TRUE"){
						if (commonOverrideOptionalParam == undefined || commonOverrideOptionalParam == null) { 
					 		if (commonOverrideOkFunc) {
						 		commonOverrideOkFunc();
					 		}
						} else {
							if (commonOverrideOkFunc) {
								commonOverrideOkFunc(commonOverrideOptionalParam);
							}
						}
							//commonOverrideAccessed.splice(commonOverrideAccessed.length,0,objACGlobal.calledForm+"-"+objAC.funcCode);
							hideOverlay();
					}else if(result.message == "FALSE") {
						if (commonOverrideOptionalParam2 == undefined || commonOverrideOptionalParam2 == null) { 
							commonOverrideNotOkFunc();
						} else {
							commonOverrideNotOkFunc(commonOverrideOptionalParam2);
						}
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

	$("btnOverideCancel").observe("click", function () {
		hideOverlay(); //alfie
		if (objAC.isIncluded) {
			searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('isIncluded'), searchTableGrid.getCurrentPosition()[1]);
		}
		if (commonOverrideCancelFunc) { //nok 09.09.11
			commonOverrideCancelFunc();
 		}
	});
	
	$("close").observe("click", function () {
		if (objAC.isIncluded) {
			searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('isIncluded'), searchTableGrid.getCurrentPosition()[1]);
		}
		if (commonOverrideCancelFunc) { //nok 09.09.11
			commonOverrideCancelFunc();
 		}
	});
 	
 	$$("input[type='text'], input[type='password']").each(function (input) { //nok 09.09.11
		input.observe("keypress", function (event) {
			if (event.keyCode == 13) fireEvent($("btnOverideOk"), "click");
		});
	});
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>

<div id="overideUserMainDiv" class="sectionDiv" style="text-align: center; width: 99.4%; margin-bottom: 10px;">
	<div class="tableContainer" style="font-size:12px;">
		<!--  
		<div class="tableHeader">
			<label style="width: 30px; margin-left: 13px;">Line</label>
		</div>
		-->
		<div style="border: 1px gray;">
			<table border="0" align="center" style="margin-top: 20px; margin-bottom: 20px;">
				<tr>
					<td><label>Username</label></td>
					<td><input type="text" id="overideUserName" style="width: 150px; text-transform: uppercase;" class="required" value="" /></td>
				</tr>	
				<tr>
					<td><label>Password</label></td>
					<td><input type="password" id="overidePassWord" style="width: 150px;" class="required" value="" /></td>	
				</tr>
			</table>
		</div>	
	</div>	
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 20px;">
	<input type="button" class="button" id="btnOverideOk" value="Ok" />
	<input type="button" class="button" id="btnOverideCancel" value="Cancel" />
</div>
<script>
	$("btnOverideOk").observe("click", function (){
		validateOverrideLogin();
	});
	
	$$("input[type='text'], input[type='password']").each(function (input) {
		input.observe("keyup", function (event) {
			onEnterEvent(event, function() {
				validateOverrideLogin($F("overideUserName"), $F("overidePassWord"));
			});
		});
	});	
	
	//by bonok: 01.04.2012 testcase
	function validateOverrideLogin() {
		var overideSw = 'Y';
		var assdNo = overideAssdNo;
		if($("overideUserName").value == "" || $("overidePassWord").value == ""){
			showWaitingMessageBox("Required fields must be entered.", imgMessage.ERROR, function(){
																							$("overideUserName").focus();
																						 });
			return;
		}
		//new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=validateOverideUserDtls" , {
			new Ajax.Request(contextPath+"/GIISUserMaintenanceController?action=verifyOverrideUser" , {
				method: "GET",
				parameters: {
					userName: $F("overideUserName"),
					password: $F("overidePassWord").toUpperCase()
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response){
					if (checkErrorOnResponse(response)){
						if (response.responseText == "FALSE"){
							if(checkIfOverrideAllowed()){
								//showMessageForPolicyChecking();  -- rmanalad test-case 4.12.2011
								showMessageForPolicyCheckingTG(overideSw, assdNo);
								//maintainAssured("assuredListingMainDiv", $F("assuredNo"));
								maintainAssuredTG("assuredListingTGMainDiv", assdNo);
								hideOverlay();
							} else {
								showWaitingMessageBox($F("overideUserName").toUpperCase() + " does not have an overriding function for this module.", imgMessage.ERROR, function(){
																																											$("overideUserName").value = "";
																																											$("overidePassWord").value = "";
																																										});
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				}
			});
	}
		
	function checkIfOverrideAllowed(){
		var isAllowed = false;	
		//this function is created for checking if user is allowed to edit a record
		new Ajax.Request(contextPath+"/GIISUserMaintenanceController?action=checkIfUserAllowedForEdit", {
				method: "POST",
				parameters: {
					//userId: getUserIdParameter(), --rmanalad 4.12.2011
					userId: $F("overideUserName").toUpperCase(), // ++ rmanalad 4.12.2011
					moduleName: "GIISS006B"
				},
				evalScripts: true,
				asynchronous: false,
				onSuccess: function (response){
					if (checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							isAllowed = true;
						} 
					}
				}
		});
		return isAllowed;
	}
		
	/* function validateOverrideLogin(){
	try{
		var overideSw = 'Y'; //-- rmanalad 4.8.2011
		var assdNo = overideAssdNo;
		if ($F("overideUserName").blank()){
			showMessageBox("Please enter the username.");
			return false;
		} else if ($F("overidePassWord").blank()){
			showMessageBox("Please enter the password.");
		} else {
			new Ajax.Request(contextPath+"/GIISUserMaintenanceController?action=verifyUser&overideSw="+overideSw, {
				method: "POST",
				parameters: {
					username: $F("overideUserName"),	        
					password: $F("overidePassWord")
				},
				evalScripts: true,
				asynchronous: false,
				onSuccess: function (response){
					if (checkErrorOnResponse(response)){
						if (response.responseText == "OK"){
							//showMessageForPolicyChecking();  -- rmanalad test-case 4.12.2011
							showMessageForPolicyCheckingTG(overideSw, assdNo);
							//maintainAssured("assuredListingMainDiv", $F("assuredNo"));
							maintainAssuredTG("assuredListingTGMainDiv", assdNo);
							hideOverlay();
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				}
			});
		}
	}catch (e){
		showErrorMessage("validateOverrideLogin", e);
	}
} */
		
	//by bonok - 01.03.2012 ok button for old assured listing (assuredListing.jsp)
	/* $("btnOverideOk").observe("click", function (){
		var overideSw = 'Y'; //-- rmanalad 4.8.2011
		if ($F("overideUserName").blank()){
			showMessageBox("Please enter the username.");
			return false;
		} else if ($F("overidePassWord").blank()){
			showMessageBox("Please enter the password.");
		} else {
			new Ajax.Request(contextPath+"/GIISUserMaintenanceController?action=verifyUser&overideSw="+overideSw, {
				method: "POST",
				parameters: {
					username: $F("overideUserName"),	        
					password: $F("overidePassWord")
				},
				evalScripts: true,
				asynchronous: false,
				onSuccess: function (response){
					if (checkErrorOnResponse(response)){
						if (response.responseText == "OK"){
							//showMessageForPolicyChecking();  -- rmanalad test-case 4.12.2011
							showMessageForPolicyChecking(overideSw);
							maintainAssured("assuredListingMainDiv", $F("assuredNo"));
							hideOverlay();
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				}
			});
		}
	}); */

	$("btnOverideCancel").observe("click", function (){
		hideOverlay();
	});
</script>
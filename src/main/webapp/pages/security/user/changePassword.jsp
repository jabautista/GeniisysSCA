<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<div id="changePasswordDiv" name="changePasswordDiv" style="width: 95%; font-size: 11px;">
	<div class="sectionDiv" style="margin: 10px;">
		<form id="changePasswordForm" name="changePasswordForm" style="margin: 10px;">
			<input type="hidden" id="action" name="action" value="${action}" />
			<input type="hidden" id="userId" name="userId" value="${userId}" />
			<label id="messagePassword" style="border-bottom: 1px solid #e8e8e8; padding-bottom: 10px; margin-bottom: 10px; width: 380px;">Set your password here.</label> <br /><br />
			<c:if test="${action ne 'setNoPassword'}">
				<div style="width: 370px;">
					<label style="width: 120px;">Old Password: </label> <input type="password" class="text required" id="oldPassword" name="oldPassword" maxlength="20" style="width: 200px;" tabindex="1" />
				</div>
			</c:if>			
			<div style="width: 370px;">
				<label style="width: 120px;">New Password: </label> <input type="password" class="text required" id="newPassword" name="newPassword" maxlength="20" style="width: 200px;" tabindex="2" /> <span style="marginleft: 10px;" id="passwordMeterIndicator">0%</span>
			</div>
			<div style="width: 370px;">
				<label style="width: 120px;">Repeat Password: </label> <input type="password" class="text required" id="repeatPassword" name="repeatPassword" maxlength="20" style="width: 200px;" tabindex="3" /> <br />
			</div> 
			<!-- <input type="button" class="button" style="margin-left: 120px; margin-top: 10px;" id="submit" name="submit" value="Submit" /> -->
		</form>
		<!-- <div style="float: left; width: 209px; margin-bottom: 5px; margin-left: 120px;">
			<label style="background: green; height: 3px;" id="passwordMeterIndicator"></label> <br />
			<label id="passwordMeterIndicatorStr"></label>
		</div>-->
	</div>
	<div style="float: left; width: 100%; text-align: center;">
		<!-- <input type="button" class="button" style="margin: 5px; width : 80px;" id="submit" name="submit" value="Submit"/> -->
		<input type="button" class="button" style="margin: 5px; width : 80px;" id="submit" name="submit" value="Ok"/>
		<input type="button" class="button" style="width : 80px;" id="cancel" name="cancel" value="Cancel"/>
	</div>	
</div>
<script type="text/JavaScript">
	initializeAll();
	if($("oldPassword")){
		$("oldPassword").focus();
	} else {
		$("newPassword").focus();
	}
	
	$("newPassword").observe("keyup", function (o) {
		testPassword($F("newPassword"));
	});

	$("submit").observe("click", function () {
		submitChangePassword();
	});

	function submitChangePassword() {
		if ($F("newPassword").blank()) {
			$("messagePassword").update("Please enter your new password.");
			$("newPassword").focus();
			return false;		
		} else if ($F("repeatPassword").blank()){
			$("messagePassword").update("Please re-enter your new password.");
			$("repeatPassword").focus();
			return false;
		} else if ($F("newPassword") != $F("repeatPassword")) {
			$("messagePassword").update("New passwords did not match.");
			$("newPassword").focus();
			return false;
		} else if ($F("newPassword") == $F("userId")) {
			$("messagePassword").update("Password should not be the same with username.");
			$("newPassword").focus();
			return false;
		} else {
			new Ajax.Request(contextPath+"/GIISUserMaintenanceController", {
				method: "POST",
				postBody: Form.serialize("changePasswordForm"),
				asynchronous: true,
				evalScripts: true,
				onCreate: function () {
					$("messagePassword").update("Updating password, please wait...");
				},
				onComplete: function (response) {
					var result = response.responseText.split(":");
					if (result[0].trim() == "PasswordError" || result[0].trim() == "passworderror"){
						showWaitingMessageBox(result[1], imgMessage.INFO, function() {$("newPassword").focus();});
						$("messagePassword").update("Set your password here.");
					} else if (checkErrorOnResponse(response)) {
						$("messagePassword").update(response.responseText);
						if (response.responseText.include("SUCCESS")) {
							newUserTag = 0;
							//hideOverlay();							
							var message = ($F("action") == "setNoPassword" ? "Set password successful." : "Change password successful.");								
							showWaitingMessageBox(message, imgMessage.SUCCESS, function(){							
								if($F("action") == "changePassword"){
									deselectRows("userListTable", "row");
									overlayChangePassword.close();
									delete overlayChangePassword;							
								} else if($F("action") == "firstLoginChangePassword" || $F("action") == "setNoPassword"){ // andrew - 02.07.2011 - added this line to automatically do login after successfully changing password.
									$("timesFailed").value = 1;
									validateLoginForm($F("userId"), $F("newPassword"));
									overlayChangePassword.close();
									delete overlayChangePassword;						
								} else if ($F("action") == "changePasswordForExpiry"){
									//
									overlayChangePassword.close();
									delete overlayChangePassword;
								}
							});							
						}
					}
				}
			});
		}
	}

	$$("input[type='text'], input[type='password']").each(function (input) {
		input.observe("keypress", function (event) {
			onEnterEvent(event, submitChangePassword);
		});
	});
	
	$("cancel").observe("click", function(){
		overlayChangePassword.close();
		delete overlayChangePassword;
	});
</script>
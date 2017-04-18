<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<span style="float: right; font-size: 10px; margin: 5px;"><label id="close" style="cursor: pointer;">Close</label></span>
<div id="resetPasswordDiv" name="resetPasswordDiv" style="width: 430px;">
	<form id="resetPasswordForm" name="resetPasswordForm" style="margin: 30px;">
		<input type="hidden" id="action" name="action" value="resetPassword" />
		<label id="messagePassword" style="border-bottom: 1px solid #e8e8e8; padding-bottom: 10px; margin-bottom: 10px; width: 370px;">Password should not be the same as your old password.</label> <br /><br />
		<label style="width: 120px;">Old Password: </label> <input type="password" class="text" id="oldPassword" name="oldPassword" maxlength="20" style="width: 200px;" /> <br />
		<div style="border-bottom: 1px solid #e8e8e8; padding-bottom: 10px; margin-bottom: 10px; width: 330px;">
		
		</div>
		<label style="width: 120px;">New Password: </label> <input type="password" class="text" id="newPassword" name="newPassword" maxlength="20" style="width: 200px;" /> <br />
		<label style="width: 120px;">Repeat Password: </label> <input type="password" class="text" id="repeatPassword" name="repeatPassword" maxlength="20" style="width: 200px;" /> <br /> 
		<input type="button" class="button" style="margin-left: 120px; margin-top: 10px;" id="submit" name="submit" value="Submit" />
	</form>
</div>
<script type="text/JavaScript">
	initializeAll();
	$("oldPassword").focus();
	
	$("close").observe("click", function () {
		$("oldPassword").clear();
		$("newPassword").clear();
		$("repeatPassword").clear();
		hideOverlay();
	});

	$("submit").observe("click", function () {
		submitResetPassword();
	});

	function submitResetPassword() {
		if ($F("newPassword") == $F("oldPassword")) {
			$("messagePassword").update("Old and new password cannot be the same!");
			return false;
		} else if ($F("newPassword") != $F("repeatPassword")) {
			$("messagePassword").update("New passwords did not matched!");
			return false;
		} else {
			new Ajax.Request(contextPath+"/GIISUserController", {
				method: "POST",
				postBody: Form.serialize("resetPasswordForm"),
				asynchronous: true,
				evalScripts: true,
				onCreate: function () {
					$("messagePassword").update("Updating password, please wait...");
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						$("messagePassword").update(response.responseText);
						if (response.responseText.include("SUCCESS")) {
							hideOverlay();
							$$(".dialog").first().remove();
							$("overlay_modal").remove();
							showMessageBox(response.responseText + " - Your password has been reset!");
						}
					}
				}
			});
		}
	}

	$$("input[type='text'], input[type='password']").each(function (input) {
		input.observe("keypress", function (event) {
			onEnterEvent(event, submitResetPassword);
		});
	});
</script>
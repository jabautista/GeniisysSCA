<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="forgotPasswordDiv" name="forgotPasswordDiv" class="sectionDiv" style="width: 94%; margin: 10px; font-size: 11px;">
	<form id="forgotPasswordForm" name="forgotPasswordForm" style="margin: 10px;">
		<input type="hidden" id="action" name="action" value="forgotPassword" />
		<label id="messagePassword" style="border-bottom: 1px solid #e8e8e8; padding-bottom: 10px; margin-bottom: 10px; width: 290px;">Your password will be sent to your email.</label> <br /><br />
		<label style="width: 80px; text-align: right; margin-right: 10px;">Username: </label> <input type="text" class="text required" id="username" name="username" maxlength="20" style="width: 190px; text-transform: uppercase;"/> <br />
		<label style="width: 80px; text-align: right; margin-right: 10px;">Email: </label> <input type="text" class="text required" id="emailAddress" name="emailAddress" maxlength="100" style="width: 190px;" /> <br /> 
		<input type="button" class="button" style="margin-left: 90px; margin-top: 10px;" id="submit" name="submit" value="Submit" />
	</form>
</div>
<script type="text/JavaScript">
	initializeAll();
	$("username").focus();

	$("submit").observe("click", function () {
		submitForgotPassword();
	});

/* 	function submitForgotPassword() {
		if ($F("username").blank() || $F("emailAddress").blank()) {
			showMessageBox("Please complete required fields.", imgMessage.ERROR);
			return false;
		} else {
			new Ajax.Request(contextPath+"/GIISUserController?action=forgotPassword", {
				method: "POST",
				postBody: Form.serialize("forgotPasswordForm"),
				asynchronous: true,
				evalScripts: true,
				onCreate: function () {
					showNotice("Retrieving password, please wait...");
					//$("messagePassword").update("Retrieving password, please wait...");
				},
				onLoaded: function () {
					$("messagePassword").update("Sending password to " + $F("emailAddress"));
				},
				onComplete: function (response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						$("messagePassword").update(response.responseText);
						if (response.responseText.include("sent")) {
							hideOverlay();
							showMessageBox(response.responseText, imgMessage.SUCCESS);
						} else {
							bad("messagePassword");
						}
					}
				}
			});
		}
	} */

	$$("input[type='text'], input[type='password']").each(function (input) {
		input.observe("keypress", function (event) {
			onEnterEvent(event, submitForgotPassword);
		});
	});
</script>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${locale != null}">
	<fmt:setLocale value="${locale}" scope="session" />
</c:if>

<fmt:setBundle basename="com.geniisys.localization.locale" var="linkText" scope="session"/>

<div id="mainNavigation" name="mainNavigation">
	<jsp:include page="mainMenu.jsp"></jsp:include>
</div>
<div id="mainContents" name="mainContents">
	<div id="loginDiv" name="loginDiv" style="height: auto; float: left;">
		<label id="loginHeader" name="loginHeader" style="width: 100%; float: left;"><fmt:message key="h.login.login" bundle="${linkText}"/></label>
		<!-- <span id="loginMessage" name="loginMessage" style="float: left;"></span>-->
		<div id="outerDiv" name="outerDiv" style="width: 308px; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv" style="float: left; width: 298px; height: auto;">
				<label id="message" name="message" style="float: left;"><fmt:message key="m.login.login" bundle="${linkText}"/></label>
			</div>
		</div>

		<div style="float: left; border: 1px solid #e8e8e8; padding: 5px;">
			<form id="loginForm" name="loginForm" action="j_spring_security_check" style="padding: 0;">
				<input type="hidden" id="timesFailed" name="timesFailed" value="1" />

				<label class="rightAligned" style="width: 80px; padding-top: 5px;"><fmt:message key="l.login.username" bundle="${linkText}"/></label> <input type="text" id="userId" name="userId" style="text-transform: uppercase; width: 190px; margin-left: 10px;" value="" class="required" maxlength="8"/>
				<label class="rightAligned" style="width: 80px; padding-top: 5px;"><fmt:message key="l.login.password" bundle="${linkText}"/></label> <input type="password" id="password" name="password" class="text required" style="width: 190px; margin-left: 10px;" value="" />

				<input type="hidden" id="j_username" name="j_username"/>
				<input type="hidden" id="j_password" name="j_password"/>
			
				<input title="Submit" type="button" id="loginButton" name="loginButton" class="button" style="float: right; margin: 5px 10px 5px 0;" value="<fmt:message key="b.login.submit" bundle="${linkText}"/>" />
			</form>
		</div>

		<span style="float: right; font-size: 10px; margin-top: 10px;" title="Forgot Password">
			<label title="Forgot Password" title="Forgot Password">Forgot Password? </label><a id="forgotPassword" style="cursor: pointer;" title="Forgot Password"><emp> Click here</emp></a>
		</span>
		
		<form id="indexForm" action="GIISController">
			<input type="hidden" name="action" value="goHome" />
		</form>
	</div>
</div>
<script>
 	function submitForgotPassword() {
		if ($F("userId").blank()) {
			showMessageBox("Please enter your username.", imgMessage.ERROR);
			return false;
		} else {
			/* benjo 02.01.2016 GENQA-SR-4941 */
			new Ajax.Request(contextPath+"/GIISUserController?action=forgotPassword", {
					parameters: {
						username : $F("userId"),
						validate : "Y"
					},
					asynchronous: true,
					evalScripts: true,
					onComplete: function (response) {
						if (checkErrorOnResponse(response)) {
							if (response.responseText.include("SUCCESS")) {
								showWaitingMessageBox("Your password will be sent to the specified email.", imgMessage.INFO, function(){
									new Ajax.Request(contextPath+"/GIISUserController?action=forgotPassword", {
										method: "POST",
										parameters: {
											username : $F("userId"),
											validate : "N"
										},
										asynchronous: true,
										evalScripts: true,
										onCreate: function () {
											showNotice("Processing, please wait...");
										},
										onComplete: function (response) {
											hideNotice();
											if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
												if (response.responseText.include("sent")) {
													showMessageBox(response.responseText, imgMessage.SUCCESS);
												} else {
													bad("messagePassword");
												}
											}
										}
									});				
								});
							} else {
								showMessageBox(response.responseText, imgMessage.ERROR);
							}
						}
					}
				});
		}
	}

	$("loginButton").observe("click", function() {
		validateLoginForm($F("userId"), $F("password"));
	});
	$("forgotPassword").observe("click", function () {
		submitForgotPassword();
	});
	$$("input[type='text'], input[type='password']").each(function (input) {
		input.observe("keyup", function (event) {
			onEnterEvent(event, function() {
				validateLoginForm($F("userId"), $F("password"));
			});
		});
	});
</script>
<jsp:include page="/pages/flags.jsp"></jsp:include>
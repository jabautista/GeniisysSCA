<%@page import="com.geniisys.framework.util.ContextParameters"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	
	ApplicationContext appCon = ApplicationContextReader.getServletContext(this.getServletContext());
	ApplicationWideParameters params = (ApplicationWideParameters) appCon.getBean("appWideParams");
	request.setAttribute("defaultColor", ContextParameters.DEFAULT_COLOR);
	request.setAttribute("clientBanner", ContextParameters.CLIENT_BANNER);
	request.setAttribute("textEditorFont", ContextParameters.TEXT_EDITOR_FONT);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="com.seer.framework.util.ApplicationContextReader"%>
<%@page import="com.geniisys.framework.util.ApplicationWideParameters"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GENIISYS - General Insurance Information System - Home</title>

<c:if test="${locale != null}">
	<fmt:setLocale value="${locale}" scope="session" />
</c:if>

<fmt:setBundle basename="com.geniisys.localization.locale" var="linkText" scope="session"/>
<jsp:include page="head.jsp"></jsp:include>
<script type="text/javascript">
	function validateLoginForm(userId, password){
		//For Spring Security
		$("j_username").value = userId;
		$("j_password").value = password.toUpperCase();		
		//end of spring security variables
		
		try	{
			if(userId.trim() == "" || userId == null){ // || password.trim() == "" || password == null)	{ // || $F("database") == ""
				$("message").update('<js:toJavaScript><fmt:message key="m.login.login" bundle="${linkText}"/></js:toJavaScript>');
				bad("outerDiv");
			} else	{
				new Ajax.Request("j_spring_security_check",{
					method: "POST",
					postBody: Form.serialize("loginForm"),
					asynchronous: true,
					evalScripts: true,
					onCreate: function() {
						$("message").update('<fmt:message key="m.login.validating" bundle="${linkText}"/>');
						$("loginButton").disable();
					},
					onComplete: function(response){
						new Ajax.Updater("message", "GIISUserController?action=login", {
							method: "POST",
							asynchronous: true,
							evalScripts: true,
							parameters: {userId : userId,
										 password : password,
										 timesFailed : $F("timesFailed")},
							//postBody: Form.serialize("loginForm"),
							onCreate: function(){
								//$("message").update('<fmt:message key="m.login.validating" bundle="${linkText}"/>');
								new Effect.Highlight("outerDiv", {duration: 1});
								$("loginForm").disable();
							},
							onComplete: function (response){
								$("loginForm").enable();							
								$("loginButton").enable();
								if (response.responseText.include("occur")) {
									$("message").update('<fmt:message key="m.login.login" bundle="${linkText}"/>');
									showMessageBox(response.responseText, imgMessage.ERROR);
								}
							}
						});
				}
				});	
				
			}
		} catch (e)	{
			showErrorMessage("validateLoginForm", e);
		}
	}
	
	// check the login response if success
	function checkProceed(response){
		if(response == "success"){						
			good("outerDiv");
			$("message").update("SUCCESS: Redirecting, please wait...");
			goToModule("/GIISUserController?action=goToHome", "Home", checkIfNewUser);
		}else{
			new Ajax.Request("j_spring_security_logout",{
				method: "POST",
				postBody: Form.serialize("loginForm"),
				asynchronous: true,
				evalScripts: true
			});
			showMessageBox('<fmt:message key="m.login.wrong" bundle="${linkText}"/>', imgMessage.ERROR);
		}
	}
	
	//show login validation response
	function showMessage(type){
		var msgArea = $("message");
		
		if("iperror"==type){
			msgArea.update('<fmt:message key="m.login.iperror" bundle="${linkText}"/>');
		} else if("dberror"==type){
			msgArea.update('<fmt:message key="m.login.dberror" bundle="${linkText}"/>');	
		} else if("connectionerror"==type){
			msgArea.update('<fmt:message key="m.login.connectionerror" bundle="${linkText}"/>');
		} else if("expiredpassword"==type){
			msgArea.update('<fmt:message key="m.login.expiredpassword" bundle="${linkText}"/>');			
		} else if("inactive"==type){
			msgArea.update('<fmt:message key="m.login.inactive" bundle="${linkText}"/>');
		} else if("temporary"==type){
			msgArea.update('<fmt:message key="m.login.temporary" bundle="${linkText}"/>');			
		} else if("locked"==type){
			msgArea.update('<fmt:message key="m.login.locked" bundle="${linkText}"/>');
		} else if("nopassworderror"==type){
			msgArea.update('<fmt:message key="m.login.nopassworderror" bundle="${linkText}"/>');			
		} else if("passworderror"==type){
			msgArea.update('<fmt:message key="m.login.passworderror" bundle="${linkText}"/>');			
		} else if("nolastloginerror"==type){
			msgArea.update('<fmt:message key="m.login.nolastloginerror" bundle="${linkText}"/>');
		} else if("applogerror"==type){
			msgArea.update('<fmt:message key="m.login.applogerror" bundle="${linkText}"/>');
		} else { //invalid
			msgArea.update('<fmt:message key="m.login.invalid" bundle="${linkText}"/>');
		}
		
		bad("outerDiv");
		$("loginForm").enable();
	}

	document.observe("keyup", function(k){
		if(k.keyCode == 27){
			if(geniisys.activeWindows != null && geniisys.activeWindows != undefined){
				if(geniisys.activeWindows[geniisys.activeWindows.length-1] != null){
					geniisys.activeWindows[geniisys.activeWindows.length-1].onEscape();
					geniisys.activeWindows[geniisys.activeWindows.length-1].close();					
				}
			}
		}
	});
</script>
</head>
<body oncontextmenu="return false;" id="mainBody">
	<noscript>A browser with JavaScript enabled is required for this page to operate properly.</noscript>	
	<input type="hidden" name="modulesHidden" id="modulesHidden" value="${modules}" />
	
	<!-- NOTICE 'TO FOR LOADING - whofeih 07.07.2010-->
	<div style="float: left; height: 100%; width: 100%; background-color: #000; margin: 0; position: fixed; left: 0; top: 0; opacity: 0.4; z-index: 90000000; display: none;" id="noticeOverlay"></div>
	<div id="notice" name="notice" style="color: gray; position: fixed; font-size: 11px; padding: 5px; width: 30%; -moz-border-radius: 5px; -webkit-border-radius: 3px;	border-radius: 3px; float: left; margin: 200px 30%; z-index: 90000001; padding: 20px 0; border: 3px solid #fff; background-color: #e8e8e8; opacity: 0.8; display: none;">
		<table align="center">
			<tr id="noticeLoadingImg">
				<td style="text-align: center;">
					<img src="${contextPath}/images/misc/loading3.gif" />
				</td>
			</tr>
			<tr>
				<td style="text-align: center; font-size: 11px;"><label id="noticeMessage" style="width: 100%; text-align: center;"></label></td>
			</tr>
		</table>
	</div>
	<!-- <object></object> -->
	<!-- END OF NOTICE FOR LOADING -->
	
	<!-- START OF MAIN DIV-->
	<div id="mainContainerDiv" name="mainContainerDiv">	
		
		<div id="topDiv">
			<jsp:include page="/pages/top.jsp" />
		</div>
		
		<div id="dynamicDiv" name="dynamicDiv">
			
		</div>
		
		<div id="footer">
			<jsp:include page="/pages/footer.jsp"></jsp:include>
		</div>
	</div>
	<!-- END OF MAIN DIV -->
	
	<!-- common overlay -->
	<div id="opaqueOverlay" style="position: fixed;"></div>
	<div id="contentHolder" name="contentHolder" src=""></div>
	
	<!-- overlay especially made for textarea editors -->
	<div id="textareaOpaqueOverlay" style="position: fixed;" class="opaqueOverlay">
	</div>
	<div id="textareaContentHolder" name="textareaContentHolder" src="" class="contentHolder">
	</div>

	<!-- dummy testers for made for textarea editors -->
	<!-- <textarea id="sampleText" style="height: 13px; display: block;"></textarea>
	<input type="button" onclick="showEditor('sampleText', 5);" style="display: block;" value="Show Editor" /> -->
	
	<!-- the texteditor -->
	<div id="textareaDiv" style="display: none;">
		<jsp:include page="/pages/common/utils/overlayTextEditorHeader.jsp"></jsp:include>
		<div style="width: 590px; float: left; background-color: #fff; margin: 10px;">
			<textarea id="textarea1" name="textarea1" style="width: 572px; height: 180px;"></textarea>
			<div class="buttonsDivPopup" style="margin: 5px;">
				<input type="button" id="btnSubmitText" class="button" value="Ok" style="width: 60px;" />
				<input type="button" id="btnCancelText" class="button" value="Cancel" style="width: 60px;" />
			</div>
		</div>
	</div>
	<!-- end of the text editor -->
</body>
<script>   
	<c:if test="${empty PARAMETERS}">
		showLogin();
	</c:if>
	<c:if test="${not empty PARAMETERS}">
		goToModule("/GIISUserController?action=goToHome", "Home", "geniisysFirstDiv");
	</c:if>

	modules = $F("modulesHidden").length > 0 ? $F("modulesHidden").split(",") : null;
	
	document.observe("keydown", function (evt) {
		if (evt.keyCode == 116) evt.preventDefault();
	});

	window.onbeforeunload = function (evt) {
		if(changeTag == 1){
			return "GENIISYS:\nYou have not saved your changes yet. If you continue, your work will not be saved.";
		}
	};
	
	if (isMS()) {
		showMessageBox("The application might not work properly with MSIE.", imgMessage.WARNING);
	}
</script>
</html>
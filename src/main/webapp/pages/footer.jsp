<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<c:if test="${locale != null}">
	<fmt:setLocale value="${locale}" scope="session" />
</c:if>

<fmt:setBundle basename="com.geniisys.localization.locale" var="linkText" scope="session"/>

<div>
	<span>
		<a href="#"><fmt:message key="l.login.copyright" bundle="${linkText}"/></a>
	</span> 
	<span style="float: right; margin: 5px;" id="rightPart">
		<a href="#" id="footerHome" name="footerHome"><fmt:message key="l.main.home" bundle="${linkText}"/></a> 
		<a href="#"><fmt:message key="l.main.map" bundle="${linkText}"/></a> 
		<a href="#"><fmt:message key="l.main.contact" bundle="${linkText}"/></a> 
		<a href="#"><fmt:message key="l.main.help" bundle="${linkText}"/></a>
	</span>
</div>
<script>
	$("footerHome").observe("click", function () {
		goToModule("/GIISUserController?action=goToHome", "Home");
	});
</script>
<script> 
	/**
	 * Deploys the applets
	 * @author - andrew robes
	 * @date - 05.30.2011
	 */	
	var maintenanceMode = "${maintenanceMode}";

	var attributes = {
			id : "geniisysAppletUtil",
			code : 'util.GeniisysAppletUtil',
			width : 1,
			height : 1
		};

		var parameters = {
			jnlp_href : contextPath + '/applet/geniisys-applet-util-5.jnlp'			
		};
		if(maintenanceMode != "On") {
			if(deployJava.versionCheck("1.6+")) {
				deployJava.runApplet(attributes, parameters, '1.6');
			}
		}

		function printBatchToLocalPrinter(url, printerName) {
			try {
				if(maintenanceMode == "On"){
					showMessageBox("Local printer applet is not available during maintenance mode.", imgMessage.INFO);
					return;
				}
				var result = false;
				if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").printBatchJRPrintFileToPrinter == undefined){
					showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
				} else {					
					var message = $("geniisysAppletUtil").printBatchJRPrintFileToPrinter(url, printerName);
					if (message != "SUCCESS") {
						showMessageBox(message, imgMessage.ERROR);
					} else {
						result = true;
					}
					new Ajax.Request(contextPath + "/GIISController", {
						parameters : {
							action : "deletePrintedReport",
							url : url
						}
					});
				}
				
				return result;
			} catch (e){
				showErrorMessage("printBatchToLocalPrinter", e);
			}
		}		
		
		function printToLocalPrinter(url) {
			try {
				if(maintenanceMode == "On"){
					showMessageBox("Local printer applet is not available during maintenance mode.", imgMessage.INFO);
					return;
				}
				var result = null; //replaced from 'false' to 'null' - Halley 11.15.13
				if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").printJRPrintFileToPrinter == undefined){
					showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
				} else {					
					var message = $("geniisysAppletUtil").printJRPrintFileToPrinter(url);	
					if (message != "SUCCESS") {
						showMessageBox(message, imgMessage.ERROR);
					} else {
						result = message; //replaced to 'message' from 'true' - Halley 11.15.13
					}
					new Ajax.Request(contextPath + "/GIISController", {
						parameters : {
							action : "deletePrintedReport",
							url : url
						}
					});
				}
				return result;
			} catch (e){
				showErrorMessage("printToLocalPrinter", e);
			}
		}
</script>
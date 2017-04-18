<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<c:choose>
			<c:when test="${not empty PARAMETERS['USER']}">
				<ul>
					<li title="Home"><a id="home" class="menuHome" name="home" style="opacity: 0.8; width: 10px; background: url(${pageContext.request.contextPath}/images/main/home.png) center center no-repeat;"></a></li>
<%-- 					<li><a id="marketing" name="marketing"><fmt:message key="h.menu.marketing" bundle="${linkText}"/></a></li>
					<li><a id="underwriting" name="underwriting"><fmt:message key="h.menu.underwriting" bundle="${linkText}"/></a></li>
					<li><a id="accounting" name="accounting"><fmt:message key="h.menu.accounting" bundle="${linkText}"/></a></li>
					<li><a id="claims" name="claims"><fmt:message key="h.menu.claims" bundle="${linkText}"/></a></li>
					<li><a id="security" name="security"><fmt:message key="h.menu.security" bundle="${linkText}"/></a></li>
					<li><a id="workflow" name="workflow"><fmt:message key="h.menu.workflow" bundle="${linkText}"/></a></li>
					<li><a id="adHocReports" name="adHocReports" href="${adHocUrl}/GeniisysAdHocReports"><fmt:message key="h.menu.adhocreports" bundle="${linkText}"/></a></li>
 --%>					<!-- <li><a id="changePassword" name="changePassword">Change Password</a></li> -->
					<li><a id="options" name="options">Options</a>
						<ul style="width: 120px;">
							<li><a id="changePassword" name="changePassword">Change Password</a></li>
							<li><a id="menuColorTheme" name="menuColorTheme">Color Theme</a></li>										
							<c:if test="${PARAMETERS['USER'].misSw eq 'Y'}">				
								<c:choose>
									<c:when test="${maintenanceMode eq 'On'}">
										<li><a id="appMaintenance" name="appMaintenance">Turn Off Maintenance</a></li>
									</c:when>
									<c:otherwise>
										<li><a id="appMaintenance" name="appMaintenance">Turn On Maintenance</a></li>
									</c:otherwise>
								</c:choose>
							</c:if>
						</ul>
					</li>
					<li><a id="help" name="help">Help</a>
						<ul style="width: 125px;">
							<!-- <li><a id="menuKeyboardShortcuts" name="menuKeyboardShortcuts">Keyboard Shortcuts</a></li> -->
							<li><a id="menuAboutGeniisys" name="menuAboutGeniisys">About Geniisys</a></li>
						</ul>
					</li>
				</ul>
				<script type="text/JavaScript">
					if (checkUserModule("GENIISYS")){

						$("home").observe("mouseover", function(){
							new Effect.Opacity("home", {
									duration : 0.2,
									to : 1
								});
						});
						
						$("home").observe("mouseout", function(){
							new Effect.Opacity("home", {
									duration : 0.2,
									to : 0.8
								});
						});
						
 						$("home").observe("click", function () {
							goToModule("/GIISUserController?action=goToHome", "Home");
						});
						/*
						observeAccessibleModule(accessType.MENU, "GIIMM000", "marketing", function () {
							goToModule("/GIISUserController?action=goToMarketing", "Marketing Main", null);
						});
	
						observeAccessibleModule(accessType.MENU, "GIPIS000", "underwriting", function () {
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						});
	
						observeAccessibleModule(accessType.MENU, "GENS002", "security", function () {
							goToModule("/GIISUserController?action=goToSecurity", "Security Main", null); 
						});
	
						observeAccessibleModule(accessType.MENU, "GIACS000", "accounting", function () {
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						});

						observeAccessibleModule(accessType.MENU, "WORKFLOW", "workflow", function () {
							objWorkflow = {};
							objWorkflow.callingForm = "GENIISYS";
							goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);
						});

						observeAccessibleModule(accessType.MENU, "GICLS001", "claims", function () {
							goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
						});
						
						observeAccessibleModule(accessType.MENU, "GENS001", "adHocReports", function () {
							
						}); */
						
						$("changePassword").observe("click", function () {
							overlayChangePassword = Overlay.show(contextPath+"/GIISUserMaintenanceController", {
								urlContent : true,
								urlParameters: {action : "changePasswordFromMenu"},
							    title: "Change Password",
							    height: 188,
							    width: 430,
							    draggable: true,
							    closable : true
							});
							
							//showOverlayContent(contextPath+"/GIISUserMaintenanceController?action=changePasswordFromMenu", "Change Password", "", $$("body").first().getWidth()/2-220, $$("body").first().getHeight()/2+150, 190);
						});
						
						if($("appMaintenance") != null){
							$("appMaintenance").observe("click", function () {
								var mode = ($("appMaintenance").innerHTML.trim() == "Turn On Maintenance" ? "On" : "Off");
								new Ajax.Request(contextPath + "/GIISUserController", {
									parameters: {action : "turnMaintenanceMode",
												 mode : mode},
									onComplete : function(){
										window.location.reload();
										//$("appMaintenance").innerHTML = (mode == "On" ? "Turn Off Maintenance" : "Turn On Maintenance");
									}
								});
							});
						}						
					} else {
						$$("div#smoothmenu1 a").each(function(a){
							disableMenu(a.id);
						});
					}
					/*
					$("marketing").observe("click", function () {
						goToModule("/GIISUserController?action=goToMarketing", "Marketing Main", null);
						//$("dynamicDiv").update($("marketingFirstDiv").innerHTML);
					});
					
					$("underwriting").observe("click", function () {
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						//$("dynamicDiv").update($("underwritingFirstDiv").innerHTML);
					});

					$("security").observe("click", function () {
						goToModule("/GIISUserController?action=goToSecurity", "Security Main", null);
						//$("dynamicDiv").update($("securityFirstDiv").innerHTML); 
					});
					
					$("accounting").observe("click", function () {
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						//$("dynamicDiv").update($("accountingFirstDiv").innerHTML);
					});*/

					new Ajax.Updater("welcomeUserDiv", contextPath+"/pages/welcomeUser.jsp", {
						evalScripts: true,
						asynchronous: true
					});
					
					// detect accessible modules
					/*
					if (modules.all(function (mod) {return mod != 'GIIMM000';})) {
						$("marketing").up("li", 0).hide();
					}*/
					enableMenu("changePassword");

					$("menuAboutGeniisys").observe("click", showAbout);	

					$("menuColorTheme").observe("click", function () {
						ovlColorTheme = Overlay.show(contextPath+"/GIISController", {
							urlContent : true,
							urlParameters: {action : "showColorTheme"},
						    title: "Color Theme",
						    height: 137,
						    width: 348,
						    draggable: true
						});
					});	

/* 					$("menuKeyboardShortcuts").observe("click", function () {
						ovlKeyboardShortcuts = Overlay.show(contextPath+"/GIISController", {
							urlContent : true,
							urlParameters: {action : "showKeyboardShortcuts"},
						    title: "Keyboard Shortcuts",
						    height: 400,
						    width: 550,
						    draggable: true
						});
					});	 */				
				</script>
			</c:when>
			<c:otherwise>
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu" style="height: 25px;"></div>
			</c:otherwise>
		</c:choose>
	</div>
</div>
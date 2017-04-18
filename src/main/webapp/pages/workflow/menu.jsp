<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<c:choose>
			<c:when test="${not empty PARAMETERS['USER']}">
				<ul>
					<li title="Home"><a id="home" class="menuHome" name="home" style="opacity: 0.8; width: 10px; background: url(${pageContext.request.contextPath}/images/main/home.png) center center no-repeat;"></a></li>
					<li><a id="workflow" name="workflow">Workflow</a></li>
					<li><a id="sentTransaction" name="reminder">Sent Transaction</a></li>
					<li><a id="reminder" name="reminder">Reminder</a></li>
					<li><a id="maintenance" name="maintenance">Maintenance</a>
						<ul style="width: 200px;">
							<li><a id="eventsMaintenance" name="eventsMaintenance">Events Maintenance</a></li>
							<li><a id="displayColumns" name="displayColumns">Display Columns</a></li>
							<li><a id="userEventsMaintenance" name="userEventsMaintenance">User Events Maintenance</a>
						</ul>
					</li>
					<li><a id="workflowExit" name="workflowExit">Exit</a></li>
				</ul>
				
				<script type="text/JavaScript">
					setModuleId();
					
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
					
					observeAccessibleModule(accessType.MENU, "GENIISYS", "home", function(){
						releaseWorkflowTableGridKeys();
						goToModule("/GIISUserController?action=goToHome", "Home");
					});

					observeAccessibleModule(accessType.MENU, "WOFLO001", "workflow", showWorkflow);
					observeAccessibleModule(accessType.MENU, "WOFLO001", "sentTransaction", showSentTransactions);					
					observeAccessibleModule(accessType.MENU, "WOFLO001", "reminder", function (){ 					 
						showReminder("${PARAMETERS['USER'].userId}");
					});

					observeAccessibleModule(accessType.MENU, "GIISS166", "eventsMaintenance", showEventsMaintenance);
					observeAccessibleModule(accessType.MENU, "GIISS167", "displayColumns", showDisplayColumns);
					observeAccessibleModule(accessType.MENU, "GIISS168", "userEventsMaintenance", showGiiss168);
				
					$("workflowExit").observe("click", function(){
						if(objWorkflow != undefined && objWorkflow != null){
							releaseWorkflowTableGridKeys();
							if(objWorkflow.callingForm == "GENIISYS"){							
								goToModule("/GIISUserController?action=goToHome", "Home");
							} else if(objWorkflow.callingForm == "GIIMM000"){
								goToModule("/GIISUserController?action=goToMarketing", "Marketing Main", null);
							} else if(objWorkflow.callingForm == "GIPIS000"){
								goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
							}
						}
					});
					
					if(objWorkflow != undefined && objWorkflow != null && objWorkflow.callingForm != "GENIISYS"){
						fireEvent($("workflow"), "click");
					}
				</script>
			</c:when>
			<c:otherwise>
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu" style="height: 25px;"></div>
			</c:otherwise>
		</c:choose>
	</div>
</div>

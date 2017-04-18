<jsp:include page="mainMenu.jsp"></jsp:include>
<div id="mainContents" name="mainContents">
	<input type="hidden" id="lastLogin" value="${PARAMETERS.USER.lastLogin}" />
	<!-- <div id="dashBoard" style="margin-top: 35px; margin-left: 10px;"> -->
	<div id="dashBoard" style="margin-top: 35px; margin-left: 120px;"> <!-- benjo 01.12.2016 AFPGEN-SR-20901 -->
		<div style="float: left; width: 120px; height: 145px; margin: 30px 53px;">
			<div id="iconMarketing" name="widget" style="width: 120px; height: 120px; opacity: 0.5;" class="mk_icon" title="Marketing">
			</div>
			<label style="float: left; width: 100%; text-align: center; margin-top: 3px;">Marketing</label>			
		</div>
		<div style="float: left; width: 120px; height: 145px; margin: 30px 53px;">
			<div id="iconUnderwriting" name="widget" style="width: 120px; height: 120px; opacity: 0.5;" class="uw_icon" title="Underwriting">
			</div>
			<label style="float: left; width: 100%; text-align: center; margin-top: 3px;">Underwriting</label>			
		</div>
		<div style="float: left; width: 120px; height: 145px; margin: 30px 53px;">
			<div id="iconAccounting" name="widget" style="width: 120px; height: 120px; opacity: 0.5;" class="ac_icon" title="Accounting">
			</div>	
			<label style="float: left; width: 100%; text-align: center; margin-top: 3px;">Accounting</label>
		</div>
		<div style="float: left; width: 120px; height: 145px; margin: 30px 53px;">
			<div id="iconClaims" name="widget" style="width: 120px; height: 120px; opacity: 0.5;" class="cl_icon" title="Claims">
			</div>		
			<label style="float: left; width: 100%; text-align: center; margin-top: 3px;">Claims</label>
		</div>
		<div style="float: left; width: 120px; height: 145px; margin: 30px 53px;">
			<div id="iconSecurity" name="widget" style="width: 120px; height: 120px; opacity: 0.5;" class="security_icon" title="Security">
			</div>		
			<label style="float: left; width: 100%; text-align: center; margin-top: 3px;">Security</label>
		</div>
		<!-- <div style="float: left; width: 120px; height: 145px; margin: 30px 53px;">
			<div id="iconWorkflow" name="widget" style="width: 120px; height: 120px; opacity: 0.5;" class="workflow_icon" title="Workflow">
			</div>		
			<label style="float: left; width: 100%; text-align: center; margin-top: 3px;">Workflow</label>
		</div> -->	
		<!-- <div style="float: left; width: 120px; height: 145px; margin: 30px 53px;">
			<div id="iconSMS" name="widget" style="width: 120px; height: 120px; opacity: 0.5;" class="sms_icon" title="SMS">
			</div>		
			<label style="float: left; width: 100%; text-align: center; margin-top: 3px;">SMS</label>
		</div> -->	
		<div style="float: left; width: 120px; height: 145px; margin: 30px 53px;">
			<div id="iconAdHocReports" name="widget" style="width: 120px; height: 120px; opacity: 0.5;" class="adhoc_icon" title="Ad Hoc Reports">
			</div>		
			<label style="float: left; width: 100%; text-align: center; margin-top: 3px;">Ad Hoc Reports</label>
		</div>
				<script type="text/JavaScript">
					if (checkUserModule("GENIISYS")){						
						observeAccessibleModule(accessType.WIDGET, "GIIMM000", "iconMarketing", function () {
							goToModule("/GIISUserController?action=goToMarketing", "Marketing Main", null);
						});
	
						observeAccessibleModule(accessType.WIDGET, "GIPIS000", "iconUnderwriting", function () {
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						});
	
						observeAccessibleModule(accessType.WIDGET, "GENS002", "iconSecurity", function () {
							goToModule("/GIISUserController?action=goToSecurity", "Security Main", null); 
						});
	
						observeAccessibleModule(accessType.WIDGET, "GIACS000", "iconAccounting", function () {
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						});

						/* observeAccessibleModule(accessType.WIDGET, "WORKFLOW", "iconWorkflow", function () {
							objWorkflow = {};
							objWorkflow.callingForm = "GENIISYS";
							goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);
						}); */

						observeAccessibleModule(accessType.WIDGET, "GICLS001", "iconClaims", function () {
							goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
						});
						
						observeAccessibleModule(accessType.WIDGET, "GENS001", "iconAdHocReports", function () {
							new Ajax.Request(contextPath+"/GIISUserController",{
								parameters:{
									action: "goToAdhoc"
								},
								onCreate: showNotice("Processing, please wait..."),
								onComplete: function(response){
									hideNotice();
									if(checkErrorOnResponse(response)){
										window.open("${adHocUrl}");
									}
								}
							});
						});
						
						/* observeAccessibleModule(accessType.WIDGET, "GISMS000", "iconSMS", function(){
							goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
						}); */

						$$("div [name='widget']").each(function(w){
							if(!w.getAttribute("class").contains("2")) {
								w.observe("mouseover", function(){
									new Effect.Opacity(w.id, {
											duration : 0.3,
											to : 1
										});
								});
							}
						});				

						$$("div [name='widget']").each(function(w){
							if(!w.getAttribute("class").contains("2")) {
								w.observe("mouseout", function(){
									new Effect.Opacity(w.id, {
											duration : 0.3,
											to : 0.5
										});
								});
							}
						});		
					} else {
						observeAccessibleModule(accessType.WIDGET, "GENIISYS", "iconMarketing", function () {
							goToModule("/GIISUserController?action=goToMarketing", "Marketing Main", null);
						});
	
						observeAccessibleModule(accessType.WIDGET, "GENIISYS", "iconUnderwriting", function () {
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						});
	
						observeAccessibleModule(accessType.WIDGET, "GENIISYS", "iconSecurity", function () {
							goToModule("/GIISUserController?action=goToSecurity", "Security Main", null); 
						});
	
						observeAccessibleModule(accessType.WIDGET, "GENIISYS", "iconAccounting", function () {
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						});

						/* observeAccessibleModule(accessType.WIDGET, "GENIISYS", "iconWorkflow", function () {
							objWorkflow = {};
							objWorkflow.callingForm = "GENIISYS";
							goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);
						}); */

						observeAccessibleModule(accessType.WIDGET, "GENIISYS", "iconClaims", function () {
							goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
						});
						
						observeAccessibleModule(accessType.WIDGET, "GENIISYS", "iconAdHocReports", function () {
						
						});
						
						/* observeAccessibleModule(accessType.WIDGET, "GENIISYS", "iconSMS", function(){
							goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
						});	 */					
					}
				</script>
	</div> 
</div>

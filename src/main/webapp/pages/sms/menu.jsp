<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<c:choose>
			<c:when test="${not empty PARAMETERS['USER']}">
				<ul>
					<li title="Home"><a id="smsHome" class="menuHome" name="smsHome" style="opacity: 0.8; width: 10px; background: url(${pageContext.request.contextPath}/images/main/home.png) center center no-repeat;"></a></li>
					<li><a id="aSendMessage" name="aSendMessage">Send Message</a>
						<ul style="width: 160px;">
							<li><a id="menuCreateSendTextMessages" name="menuCreateSendTextMessages">Create/Send Text Messages</a></li>
							<li><a id="menuSendMessageForRenewal" name="menuSendMessageForRenewal">Send Message For Renewal</a></li>
						</ul>
					</li>
					<li><a id="aInquiry" name="aInquiry">Inquiry</a>
						<ul style="width: 125px;">
							<li><a id="menuMessageSent" name="menuMessageSent">Message Sent</a></li>
							<li><a id="menuMessageReceived" name="menuMessageReceived">Message Received</a></li>
							<li><a id="menuErrorLog" name="menuErrorLog">Error Log</a></li>
						</ul>
					</li>
					<li><a id="aTableMaintenance" name="aTableMaintenance">Table Maintenance</a>
						<ul style="width: 160px;">
							<li><a id="menuMessageTemplate" name="menuMessageTemplate">Message Template</a></li>
							<li><a id="menuSmsUserGroup" name="menuSmsUserGroup">SMS User Groups</a></li>
							<li><a id="menuSmsKeywordMaintenance" name="menuSmsKeywordMaintenance">SMS Keyword Maintenance</a></li>
							<li><a id="menuSmsParameterMaintenance" name="menuSmsParameterMaintenance">SMS Parameter Maintenance</a></li>
						</ul>
					</li>
					<li><a id="aReports" name="aReports">Reports</a>
						<ul style="width: 140px;">
							<li><a id="menuSmsReportPrinting" name="menuSmsReportPrinting">SMS Report Printing</a></li>
						</ul>
					</li>
					<li><a id="menuUploadMessage" name="menuUploadMessage">Upload Message</a></li>
					<li><a id="aConnection" name="aConnection">Connection</a>
						<ul style="width: 100px;">
							<li><a id="menuConnect" name="menuConnect">Connect</a></li>
							<li><a id="menuDisconnect" name="menuDisconnect">Disconnect</a></li>
						</ul>
					</li>
				</ul>
			</c:when>
			<c:otherwise>
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu" style="height: 25px;"></div>
			</c:otherwise>
		</c:choose>
	</div>
</div>

<script type="text/javascript">
	setModuleId();
	function showSMSRenewal(){
		try{
			new Ajax.Updater("mainContents", contextPath+"/GIEXExpiryController?action=showSMSRenewal",{
				method: "GET",
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Loading SMS Renewal, please wait..."),
				onComplete: function() {
					hideNotice("");
					$("mainNav").hide();
					Effect.Appear($("mainContents").down("div", 0), {duration: .001});
				}
			});
		}catch(e){
			showErrorMessage("showSMSRenewal",e);
		}
	}
	
	function showMessagesSent(){
		try{
			new Ajax.Updater("mainContents", contextPath+"/GISMMessagesSentController?action=showMessagesSent",{
				method: "GET",
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Loading Page, please wait..."),
				onComplete: function() {
					hideNotice("");
					$("mainNav").hide();
					Effect.Appear($("mainContents").down("div", 0), {duration: .001});
				}
			});
		}catch(e){
			showErrorMessage("showMessagesSent",e);
		}
	}
	
	function showCreateSendMessages(){
		try{
			new Ajax.Updater("mainContents", contextPath+"/GISMMessagesSentController?action=showCreateSendMessages",{
				method: "GET",
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Loading Page, please wait..."),
				onComplete: function() {
					hideNotice("");
					$("mainNav").hide();
					Effect.Appear($("mainContents").down("div", 0), {duration: .001});
				}
			});
		}catch(e){
			showErrorMessage("showCreateSendMessages",e);
		}
	}
	
	function showMessagesReceived(){
		try{
			new Ajax.Updater("mainContents", contextPath+"/GISMMessagesReceivedController?action=showMessagesReceived",{
				method: "GET",
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Loading Page, please wait..."),
				onComplete: function() {
					hideNotice("");
					$("mainNav").hide();
					Effect.Appear($("mainContents").down("div", 0), {duration: .001});
				}
			});
		}catch(e){
			showErrorMessage("showMessagesReceived",e);
		}
	}
	
	function showSmsReportPrinting(){
		new Ajax.Request(contextPath + "/GISMSmsReportController", {
			method : "POST",
			parameters : {
							action 	: "showSmsReportPrinting"
						 },
	        onCreate   : showNotice("Loading SMS Reporting Printing, please wait..."),
	        onComplete : function(response){
	        	hideNotice();
	        	try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch (e) {
					showErrorMessage("showSmsReportPrinting - onComplete : ", e);
				}
	        }
		});
	}
	
	function showSMSErrorLog(){
		try{
			new Ajax.Request(contextPath + "/GISMMessagesReceivedController", {
				parameters : {
					action : "showSMSErrorLog"
				},
				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						
					}
				}
			});
		}catch(e){
			showErrorMessage("showSMSErrorLog",e);
		}
	}	
	
	function showGisms002() {
		try {
			new Ajax.Request(contextPath + "/GISMMessageTemplateController", {
					parameters : {action : "showGisms002"},
					onCreate : showNotice("Retrieving Message Template Maintenance, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
		} catch(e){
			showErrorMessage("showGisms002", e);
		}
	}
	
	function showGisms003() {
		try {
			new Ajax.Request(contextPath + "/GISMRecipientGroupController", {
					parameters : {action : "showGisms003"},
					onCreate : showNotice("Retrieving SMS User Group Maintenance, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
		} catch(e){
			showErrorMessage("showGisms003", e);
		}
	}	
	
	function showGisms010(){
		try{ 
			new Ajax.Request(contextPath+"/GISMUserRouteController", {
				method: "GET",
				parameters: {
					action : "showGisms010"
				},
				evalScripts:true,
				asynchronous: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function (response)	{
					hideNotice("");
					$("mainContents").update(response.responseText);
					Effect.Appear($("mainContents").down("div", 0), {
						duration: .001
					});
				}
			});		
		}catch(e){
			showErrorMessage("showGisms010",e);
		}	
	}
	
	function showGisms011(){
		try{ 
			new Ajax.Request(contextPath+"/GIISParameterController", {
				method: "GET",
				parameters: {
					action : "showGisms011"
				},
				evalScripts:true,
				asynchronous: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function (response)	{
					hideNotice("");
					$("mainContents").update(response.responseText);
					Effect.Appear($("mainContents").down("div", 0), {
						duration: .001
					});
				}
			});		
		}catch(e){
			showErrorMessage("showGisms011",e);
		}	
	}
	
	try{
		$("smsHome").observe("mouseover", function(){
			new Effect.Opacity("smsHome", {
					duration : 0.2,
					to : 1
				});
		});
		
		$("smsHome").observe("mouseout", function(){
			new Effect.Opacity("smsHome", {
					duration : 0.2,
					to : 0.8
				});
		});	
		
		$("smsHome").observe("click", function (){
			goToModule("/GIISUserController?action=goToHome", "Home");
		});

		observeAccessibleModule(accessType.MENU, "GISMS002", "menuMessageTemplate", showGisms002);
		observeAccessibleModule(accessType.MENU, "GISMS003", "menuSmsUserGroup", showGisms003);
		observeAccessibleModule(accessType.MENU, "GISMS004", "menuCreateSendTextMessages", showCreateSendMessages);
		observeAccessibleModule(accessType.MENU, "GISMS005", "menuMessageSent", showMessagesSent);
		observeAccessibleModule(accessType.MENU, "GISMS007", "menuSendMessageForRenewal", showSMSRenewal);
		observeAccessibleModule(accessType.MENU, "GISMS012", "menuSmsReportPrinting", showSmsReportPrinting);
		observeAccessibleModule(accessType.MENU, "GISMS009", "menuMessageReceived", showMessagesReceived);		
		observeAccessibleModule(accessType.MENU, "GISMS008", "menuErrorLog", showSMSErrorLog);	
		observeAccessibleModule(accessType.MENU, "GISMS010", "menuSmsKeywordMaintenance", showGisms010);
		observeAccessibleModule(accessType.MENU, "GISMS011", "menuSmsParameterMaintenance", showGisms011);
	}catch(e){
		showErrorMessage("SMS Menu");
	}
</script>
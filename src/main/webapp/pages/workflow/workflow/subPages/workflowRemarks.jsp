<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="remarksMainDiv" style="margin-top: 10px; margin-bottom: 10px; float: left; width: 99%;">
	<div id="remarksDiv" class="sectionDiv">
		<table style="margin: 10px;">
			<tr>
				<td class="rightAligned" width="40">Status</td>
				<td class="leftAligned">
					<select id="selStatus" name="selStatus" style="width: 160px;">
						<option></option>
						<c:forEach var="status" items="${status}">
							<option value="${status.rvLowValue}"> ${status.rvMeaning}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" width="185">Date Due</td>
				<td class="leftAligned">					
					<div id="dateDueDiv" name="dateDueDiv" style="float:left; border: solid 1px gray; width: 160px; height: 20px; margin-right:3px;">
				    	<input style="width: 132px; border: none; height: 11px; margin: 0;" id="txtDateDue" name="txtDateDue" type="text" value="" readonly="readonly" />
				    	<img id="hrefDateDue" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"	alt="Date Due" onClick="scwShow($('txtDateDue'),this, null);" class="hover"/>				    			    
					</div>
				</td>
			</tr>
			<tr>
				<td class="leftAligned" colspan="4">
					<textarea id="txtRemarks" name="txtRemarks" style="margin-top: 5px; height: 250px; width: 98%;" rows="" cols=""></textarea>
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="buttonsDiv" style="float: left; width: 100%;">
	<table align="center">
		<tr>
			<td>
				<input type="button" class="button" style="width: 90px;" id="btnAttach" name="btnAttach" value="Attachments" />
				<input type="button" class="button" style="width: 90px;" id="btnOk" name="btnOk" value="Ok" />
				<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
			</td>
		</tr>
	</table>
</div>	
<script type="text/javascript">
	initializeAll();
	var mode = '${mode}';
	var popupDir = "${popupDir}";
	var workflowMsgr = "${workflowMsgr}";
	
	function saveCreatedEvent(users, event){
		try {
			if (workflowMsgr == "1" || workflowMsgr == "2") {				
				var message = userId + " assigned a new transaction. - " + event.eventDesc;
				for(var i=0; i<users.length; i++){
					var recipient = users[i].userId;
					if(objTranDtls != undefined && objTranDtls.length > 0){
						for(var k=0; k<objTranDtls.length; k++){
							$("geniisysAppletUtil").sendMessage(popupDir, recipient, message + " " + objTranDtls[k].tranDtl);
						}
					} else {
						$("geniisysAppletUtil").sendMessage(popupDir, recipient, message);
					}					
				}
			}
			
			var statusDesc = $("selStatus").options[$("selStatus").selectedIndex].text;
			new Ajax.Request(contextPath+"/GIPIUserEventController", {
					method: "POST",
					parameters : {action: "saveCreatedEvent",
							      users: prepareJsonAsParameter(users),
							      event: prepareJsonAsParameter(event),
							      attachments : prepareJsonAsParameter(objGUEAttach),
							      tranDtls : (objTranDtls != null && objTranDtls != undefined ? prepareJsonAsParameter(objTranDtls) : []),
								  createTag : objWorkflowForm.variables.createTag,
								  remarks: $F("txtRemarks"),
								  dateDue: $F("txtDateDue"),
								  status: $F("selStatus"),
								  statusDesc : statusDesc,
								  workflowMsgr : workflowMsgr},
					onCreate : function() {
						showNotice("Working, please wait...");
						/* overlayWorkflowRemarks.hide();
						overlayWorkflowUserList.hide(); */
					},
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							clearObjectValues(objSelectedUsers);
							clearObjectValues(objCurrGIISEvent);							
							objTranDtls = null;
							var result = response.responseText.split(resultMessageDelimiter);
							showMessageBox(result[1]);
							overlayWorkflowRemarks.close();
							overlayWorkflowUserList.close();
							tbgUserEvent.refresh();
						}
					} 
				});	
		} catch (e){
			showErrorMessage("saveCreatedEvent", e);
		}
	}
	
	function transferEvents(){
		try {		
			if(workflowMsgr == "1" || workflowMsgr == "2") {
				var message = userId + " assigned a new transaction. - " + objCurrEvent.eventDesc;
				for(var k=0; k<objSelectedEventDtls.length; k++){
					for(var i=0; i<objSelectedUsers.length; i++){	
						if(objSelectedUsers[i].tranId == objSelectedEventDtls[k].tranId 
								&& objSelectedUsers[i].eventUserMod == objSelectedEventDtls[k].eventUserMod
								&& objSelectedUsers[i].eventColCd == objSelectedEventDtls[k].eventColCd) {
							var recipient = objSelectedUsers[i].userId;
							$("geniisysAppletUtil").sendMessage(popupDir, recipient, message + (objSelectedEventDtls[k].tranDtl == null ? "" : " " + objSelectedEventDtls[k].tranDtl));
						}
					}
				}
			} 
			
			var statusDesc = $("selStatus").options[$("selStatus").selectedIndex].text;
			new Ajax.Request(contextPath+"/GIPIUserEventController", {
					method: "POST",
					parameters : {action: "transferEvents",
								  users : prepareJsonAsParameter(objSelectedUsers),
							      userEvents: prepareJsonAsParameter(objSelectedEventDtls),
							      event: prepareJsonAsParameter(objCurrEvent),
								  remarks: $F("txtRemarks"),
								  dateDue: $F("txtDateDue"),
								  status: $F("selStatus"),
								  statusDesc : statusDesc,
								  workflowMsgr : workflowMsgr},
					onCreate : showNotice("Working, please wait..."),
					onComplete : function(response){
						try {
							if(checkErrorOnResponse(response)){
								tbgUserEventDetail._refreshList();
								objSelectedEventDtls = new Array();
								clearObjectValues(objSelectedUsers);
								var result = response.responseText.split(resultMessageDelimiter);
								showMessageBox(result[1]);
								overlayWorkflowRemarks.close();
								overlayWorkflowUserList.close();
							}
						} catch(e){
							showErrorMessage("transferEvents - onComplete", e);
						}
					} 
				});				
		} catch (e){
			showErrorMessage("transferEvents", e);
		}
	}
	
	function getSelectedEventUsers(){
		var selectedRows = new Array();
		for(var i=0; i<objSelectedEventDtls.length; i++){
			var users = objSelectedEventDtls[i].selectedUsers;
			for(var j =0; j<users.length; j++){				
				users[j].tranId = objSelectedEventDtls[i].tranId;
				users[j].eventUserMod = objSelectedEventDtls[i].eventUserMod;
				users[j].eventColCd = objSelectedEventDtls[i].eventColCd;
			}			
			selectedRows = selectedRows.concat(users);
		}
		return selectedRows;
	}
	
	$("btnCancel").observe("click", function(){
		overlayWorkflowRemarks.close();
		tbgWorkflowUserList.keys.releaseKeys();
		overlayWorkflowUserList.close();
	});
	
	$("btnOk").observe("click", function(){
		if(mode == 0){
			saveCreatedEvent(objSelectedUsers, objCurrGIISEvent);
		} else {
			objSelectedUsers = getSelectedEventUsers();
			transferEvents();
		}
	});
	
	if(mode == 1){
		$("btnAttach").hide();
	} else {
		$("btnAttach").observe("click", function(){
			objAttachment = {};
			objAttachment.onAttach = function(files){
				showMessageBox("Attachment finished.", imgMessage.INFO);
			};
			showWorkflowAttachmentList();
		});
	}
</script>
var objCurrEvent = null;
var objCurrEventDtl = null;
var objGUEAttach;
var objCurrGIISEvent; // for events lov
var objCurrAttachment;
var objWorkflow;
var objSelectedUsers;
var overlayWorkflowRemarks;
var overlayWorkflowUserList;
var overlayWorkflowTranList;
var overlayAttachmentList;
var objTranDtls; // for selected transactions
var objWorkflowForm;


/**
 * @author andrew robes
 * @date January 12, 2011
 * @description Shows the workflow screen.
 * @param userId - id of user
 * @return
 */
function showWorkflow(){
	try {		
		new Ajax.Request(contextPath+"/GIPIUserEventController", {
			method: "GET",
			evalScripts: true,
			parameters: {action : "showWorkflow"},
			onCreate: showNotice("Getting Workflow Events, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("workflowMainPageDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {		
		showErrorMessage("showWorkflow", e);
	}
}

/**
 * @author andrew robes
 * @date January 12, 2011
 * @description Shows the reminder screen.
 * @param userId - id of user
 * @return
 */
function showReminder(){
	try {
		new Ajax.Request(contextPath+"/GIPIReminderController?action=getGIPIReminderListing", {
			method: "GET",
			evalScripts: true,
			onCreate: showNotice("Getting Mini - Reminders, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("workflowMainPageDiv").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showReminder", e);
	}
}

/**
 * @author andrew robes
 * @date January 13, 2011
 * @description Shows the events maintenance screen.
 */
function showEventsMaintenance(){
	try {
		new Ajax.Request(contextPath+"/GIISEventController", {
			method: "GET",
			evalScripts: true,
			parameters: {action: "getGIISEventListing",
						 userId : userId},
			onCreate: showNotice("Getting Event Maintenance, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showEventsMaintenance", e);
	}
}

/**
 * @author J. Diago
 * @date January 02, 2014
 * @description Shows the display columns screen.
 */
function showDisplayColumns(){
	try {
		new Ajax.Request(contextPath+"/GIISDspColumnController", {
			method: "GET",
			evalScripts: true,
			parameters: {
				action: "showDisplayColumns"
			},
			onCreate: showNotice("Getting Event Maintenance, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("workflowMainPageDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showDisplayColumns", e);
	}
}


function showEventDetailListing(objCurrEvent, userId){
	try {
		new Ajax.Updater("userEventsDetailsDiv", contextPath+"/GIPIUserEventController?action=getGIPIUserEventDetailListing",{
			method:"POST",
			evalScripts: true,
			parameters: {eventCd : (objCurrEvent == null ? "" : objCurrEvent.eventCd),
						 userId  : userId},
			onCreate: function(){
				//$("eventDetailsButtonsDiv").hide();
				showNotice("Getting Event Listing, please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				if(checkErrorOnResponse(response)) {
					//$("eventDetailsButtonsDiv").show();
				}
			}
		});
	} catch(e){
		showErrorMessage("showEventDetailListing", e);
	}
}

/** 
 * @author 		andrew robes
 * @date 		02.08.2011
 * @description	Executes the necessary functions when a row is selected * 
 * @param 		rowIndex - index of selected row
 * 				element - the selected row
 */
function doEventCellFocus(element, rowIndex){
	try {
		if(element.hasClassName("selectedRow")){
			objCurrEvent = tbgUserEvent.getRow(rowIndex);
			$("lblEventList").innerHTML = "Event List ("+objCurrEvent.eventDesc+")";
			if($("lblShowEventList").innerHTML == "Hide") {				
				showEventDetailListing(objCurrEvent);
				//setEventDetailButtons(objCurrEvent.eventType);
			}
		} else {
			$("lblEventList").innerHTML = "Event List";
			if(tbgUserEventDetail) {
				tbgUserEventDetail.clear();
			}
		}
	} catch (e){
		showErrorMessage("doEventCellFocus", e);
	}
}

/**
 * @author andrew robes
 * @date 02.15.2011
 * @param eventType - type of event to be used in setting button visibility
 * @return
 */
function setEventDetailButtons(eventType){
	try {
		if(eventType == 2){
			disableButton("btnUserId");
			disableButton("btnTransfer");
			enableButton("btnDelete");
		} else if (eventType == 3){
			enableButton("btnUserId");
			enableButton("btnTransfer");
			disableButton("btnDelete");
		} else if (eventType == 4 || eventType == 5){
			enableButton("btnUserId");
			enableButton("btnTransfer");
			enableButton("btnDelete");
		} else {
			disableButton("btnUserId");
			disableButton("btnTransfer");
			disableButton("btnDelete");		
		}		
	} catch(e){
		showErrorMessage("setEventDetailButtons", e);
	}	
}

/**
 * Shows the listing of events
 * @author andrew robes
 * @date 07.06.2011
 * 
 */
function showEventLOV(){
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action : "getGIISEventLOV",
						page : 1},
		title: "Select an Event to create",
		width: 480,
		height: 300,
		columnModel : [	{	id : "eventCd",
							title: "Event Code",
							width: '80px',
							type: 'number'
						},
						{	id : "eventDesc",
							title: "Event Description",
							width: '350px'
						}
					],
		draggable: true,
		onSelect: function(row){
			objCurrGIISEvent = row;			
			if(row.eventType == 5){
				showWorkflowUserList(objCurrGIISEvent, 0, null);
			} else {
				overlayWorkflowTranList = Overlay.show(contextPath+"/GIPIUserEventController", {
					urlContent: true,
					urlParameters: {action : "getWorkflowTranList",
									eventCd : row.eventCd,								
									ajax : "1"},
				    title: "List of Transaction - " + row.eventDesc,
				    height: 350,
				    width: 650,
				    draggable: true
				});
			}
		}
	  });
}

/**
 * @author andrew robes
 * @date August 17, 2011
 * @description Shows the workflow users list.
 * @param row - selected event
 * 		  mode - 0 for create use
 * 			     1 for event list use
 */
function showWorkflowUserList(row, mode, recipient){
	try{
		overlayWorkflowUserList = Overlay.show(contextPath+"/GIISUserController", {
			urlContent: true,
			urlParameters: {action : "getWorkflowUserList",
							eventCd : row.eventCd,
							eventType : row.eventType,
							recipient : nvl(recipient, null),
							createSw : (parseInt(mode) == 0 ? "Y" : "N"),
							tranId : row.tranId,
							eventColCd : row.eventColCd,
							eventModCd : row.eventModCd,
							mode : mode,
							ajax : "1"},
		    title: "User List",
		    height: 350,
		    width: 380,
		    draggable: true
		});
	} catch(e){
		showErrorMessage("showWorkflowUserList", e);
	}
}

/**
 * Shows history window
 * @author andrew robes
 * @date 09.06.2011
 */
function showHistory(tranId){
	try{
		overlayWorkflowHistory = Overlay.show(contextPath+"/GIPIUserEventHistController", {
			urlContent: true,
			urlParameters: {action : "getGIPIUserEventHistList",
							tranId : tranId,							
							ajax : "1"},
		    title: "History",
		    height: 350,
		    width: 600,
		    draggable: true
		});
	} catch(e){
		showErrorMessage("showHistory", e);
	}
}

/**
 * @author andrew robes
 * @date January 13, 2011
 * @description Shows the events maintenance screen.
 */
function showGiiss168(){
	try {
		new Ajax.Request(contextPath+"/GIISEventModuleController", {
			method: "GET",
			evalScripts: true,
			parameters: {action: "showGiiss168"},
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showUserEventsMaintenance", e);
	}
}

/**
 * Shows the workflow attachment dialog
 * @author andrew robes
 * @date 08.19.2011
 * 
 */
function showWorkflowAttachmentList(){
	try{
		overlayAttachmentList = Overlay.show(contextPath+"/GUEAttachController", {
			urlContent: true,
			urlParameters: {action : "getWorkflowAttachmentList",						
							ajax : "1"},
		    title: "Attachment",
		    height: 350,
		    width: 600,
		    draggable: true
		});
	}catch(e){
		showErrorMessage("showWorkflowAttachmentList", e);
	}
}

function checkMultipleAssignSw(mode){
	var result = false;
	
	try {
		var sw = (mode == 0 ? objCurrGIISEvent.multipleAssignSw : objCurrEvent.multipleAssignSw);
		if(objSelectedUsers.length > 1 && sw == "N"){
			showMessageBox("Event does not allow transfer to multiple users.", imgMessage.ERROR);
		} else {		
			result = true;
		}
	} catch(e){
		showErrorMessage("checkMultipleAssignSw", e);
	} finally {
		return result;
	}
}

/**
 * Shows the remarks window
 * @author andrew robes
 * @date 09.06.2011
 * 
 */
function showRemarks(mode){
	try {
		//if(checkMultipleAssignSw(mode)){
			//if(objWorkflowForm.variables.createTag == "Y"){
				// checkPassingUser
				overlayWorkflowRemarks = Overlay.show(contextPath+"/GIPIUserEventController", {
					urlContent : true,
					urlParameters: {action : "showWorkflowRemarks",
									mode : mode,
									ajax : "1"},
				    title: "Remarks",
				    height: 370,
				    width: 580
				});
			//}
		//}
	} catch(e){
		showErrorMessage("showRemarks", e);
	}
}

/**
 * Shows the sent transactions module
 * @author andrew robes
 * @date 09.22.2011
 * 
 */
function showSentTransactions(){
	try {
		new Ajax.Request(contextPath + "/GIPIUserEventController", {
			method: "GET",
			parameters: {action : "getEventsByDateSent",
					     date : dateFormat(new Date(),"mm-dd-yyyy")},
			onCreate: showNotice("Getting Sent Transactions, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("workflowMainPageDiv").update(response.responseText);
				}
			}
		});
	} catch (e){
		showErrorMessage("showSentTransactions", e);
	}
}

function releaseWorkflowTableGridKeys(){
	try {
		// release table grid captured keys							
		if(typeof tbgUserEvent != "undefined") delete tbgUserEvent;
		if(typeof tbgUserEventDetail != "undefined") delete tbgUserEventDetail;
		if(typeof tbgUserEventHistDetail != "undefined") delete tbgUserEventHistDetail;
		if(typeof tbgReminder != "undefined") delete tbgReminder;
	} catch(e){
		showErrorMessage("releaseWorkflowTableGridKeys", e);
	}
}
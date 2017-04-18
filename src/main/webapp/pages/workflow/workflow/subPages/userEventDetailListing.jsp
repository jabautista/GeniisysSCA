<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- <div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label id="lblEventList">Event List</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label id="lblShowEventList" name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div> -->
<div class="sectionDiv">
	<div id="userEventsDetailsListingDiv">		
		<div id="userEventDetailTableDiv" style="padding: 10px 0 10px 20px; float: left;">
			<div id="userEventDetailTable" style="width: 900px; height: 250px"></div>
		</div>
		<div id="eventDetailsButtonsDiv" name="eventDetailsButtonsDiv" style="margin-bottom: 10px; float: left; width: 100%;" align="center">
			<input type="button" class="button" id="btnUserId" name="btnUserId" value="User Id" >			
			<input type="button" class="button" id="btnTransfer" name="btnTransfer" value="Transfer">
			<input type="button" class="button" id="btnDelete" name="btnDelete" value="Delete">
		</div>			
   	</div>		
</div>	
<script type="text/javascript" defer="defer">
	setEventDetailButtons(objCurrEvent.eventType);
	var objTGUserEventDetail = JSON.parse('${userEventDetailTableGrid}');
	var objStatus = JSON.parse('${status}');
	objCurrEventDtl = null;
	var objModifiedCurrEventDtls = [];
	
	var statusList = new Array();
	statusList.push({value: '', text: ''});	
	for(var i=0; i<objStatus.length; i++){
		statusList.push({value: objStatus[i].rvLowValue, text: objStatus[i].rvMeaning});
	}
	
	function getSelectedUserEventsDtls(){
		var tempRows = tbgUserEventDetail.geniisysRows;
		var selectedRows = new Array();
		
		for(var i=0; i<tempRows.length; i++){
			if(tempRows[i].selected == "Y"){
				selectedRows.push(tempRows[i]);
			}
		}
		return selectedRows;
	}
	
	function saveUserEventDetails(){
		try{
			if(changeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			} else {
				new Ajax.Request(contextPath+"/GIPIUserEventController", {
					method: "POST",
					parameters: {action : "saveUserEventDetails",
								 setRows : prepareJsonAsParameter(objModifiedCurrEventDtls)},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							changeTag = 0;
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							tbgUserEventDetail._refreshList();
							lastAction();
							lastAction = "";
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("saveUserEventDetails", e);
		}
	}
	
	function deleteEvents(){
		try {
			new Ajax.Request(contextPath+"/GIPIUserEventController", {
				method: "POST",
				parameters: {action : "deleteEvents",
						     userEvents: prepareJsonAsParameter(objSelectedEventDtls)},
				onComplete : function(response){
				 	if(checkErrorOnResponse(response)){
				 		showMessageBox("Transaction completed");
				 		objCurrEvent = null;
				 		tbgUserEvent._refreshList();
				 		tbgUserEventDetail.url = contextPath+"/GIPIUserEventController?action=getGIPIUserEventDetailListing&refresh=1&eventCd=";
				 		tbgUserEventDetail._refreshList();
				 	}
				}
			});
		} catch (e){
			showErrorMessage("deleteEvents", e);
		}
	}
	
	function saveAttachments(){
		new Ajax.Request(contextPath + "/GUEAttachController", {
			method : "POST",
			parameters : {action : "saveGUEAttachments",
						  tranId : objCurrEventDtl.tranId,
						  setAttachRows : prepareJsonAsParameter(setAttachRows),
						  delAttachRows : prepareJsonAsParameter(delAttachRows)},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					showMessageBox("Attachment finished.", imgMessage.INFO);
					tbgUserEventDetail._refreshList();
				}
			}
		});
	}
	
	function writeFilesToServer(){
		new Ajax.Request(contextPath+"/GUEAttachController", {
			method: "POST",
			parameters : {action : "writeFilesToServer",
						  files : prepareJsonAsParameter(objCurrEventDtl.gueAttachList)},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					objGUEAttach = objCurrEventDtl.gueAttachList;
					objAttachment = {};
					objAttachment.onAttach = function(files){ // function will be called upon attach button click
						setAttachRows = getAddedAndModifiedJSONObjects(files);
						delAttachRows = getDeletedJSONObjects(files);
						saveAttachments();
					};							
					showWorkflowAttachmentList();
				}
			}
		});
	}
	
	$("btnUserId").observe("click", function(){
		tbgUserEventDetail.keys.removeFocus(tbgUserEventDetail.keys._nCurrentFocus, true);
		tbgUserEventDetail.keys.releaseKeys();
		tbgUserEvent.keys.removeFocus(tbgUserEvent.keys._nCurrentFocus, true);
		tbgUserEvent.keys.releaseKeys();
		if(objCurrEventDtl == null){
			showMessageBox("Please select a record first.", imgMessage.INFO);
		} else if(objCurrEventDtl.selected == "Y"){
			objCurrEventDtl.viewSw = true;
			showWorkflowUserList(objCurrEvent, 1, objCurrEventDtl.recipient);			
		} else {
			showMessageBox("Record has no list of users.", imgMessage.ERROR);
		}
	});
	
	objSelectedEventDtls = new Array();
	$("btnTransfer").observe("click", function(){
		if(changeTag == 1){
			showMessageBox("Please save your changes first.", imgMessage.INFO);
		} else {
			tbgUserEventDetail.keys.removeFocus(tbgUserEventDetail.keys._nCurrentFocus, true);
			tbgUserEventDetail.keys.releaseKeys();
			tbgUserEvent.keys.removeFocus(tbgUserEvent.keys._nCurrentFocus, true);
			tbgUserEvent.keys.releaseKeys();
			objSelectedEventDtls = getSelectedUserEventsDtls();
			if(objSelectedEventDtls.length == 0){
				showMessageBox("Please tag the record for reassignment.", imgMessage.ERROR);
			} else {
				objWorkflowForm.variables.createTag = "N";
				showRemarks(1);
			}
		}
	});	
	
	$("btnDelete").observe("click", function(){
		if(changeTag == 1){
			showMessageBox("Please save your changes first.", imgMessage.INFO);
		} else {
			tbgUserEventDetail.keys.removeFocus(tbgUserEventDetail.keys._nCurrentFocus, true);
			tbgUserEventDetail.keys.releaseKeys();
			objSelectedEventDtls = getSelectedUserEventsDtls();
			if(objSelectedEventDtls.length == 0){
				showMessageBox("Please tag the records for deletion.", imgMessage.ERROR);
			} else {
				deleteEvents();
			}
		}
	});	
	
	$("lblShowEventList").observe("click", function(){
		if ($("myTableGrid2") == null) {
			showEventDetailListing(objCurrEvent);
		}
	});
	var userEventDetailTable = {
			url: contextPath+"/GIPIUserEventController?action=getGIPIUserEventDetailListing&refresh=1&eventCd="+(objCurrEvent == null ? "" : objCurrEvent.eventCd),
			options: {
				title: '',
				width: '885px',
				pager: {
				},
				toolbar: {
					elements: [MyTableGrid.ATTACHMENT_BTN, MyTableGrid.HISTORY_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.SAVE_BTN],
					onHistory: function(){
						if(objCurrEventDtl == null){
							showMessageBox("Please select a record first.", imgMessage.INFO);
						} else {
							showHistory(objCurrEventDtl.tranId);
						}
					},
					onSave: function(){
						saveUserEventDetails();
					},
					onAttachment: function(){
						if(changeTag == 1){
							showMessageBox("Please save your changes first.", imgMessage.INFO);
						} else {
							if(objCurrEventDtl == null){
								showMessageBox("Please select a record first.", imgMessage.INFO);
							} else {
								writeFilesToServer();											
							}
						}
					},
					onRefresh: function(){
						objCurrEventDtl = null;
						changeTag = 0;
					}
				},
				beforeFilter: function(){
					if(changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
							function() {
								saveUserEventDetails();
								return true;
							},
							function(){
								return true;
							}, "");
					} else {
						return true;
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgUserEventDetail._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						objCurrEventDtl = tbgUserEventDetail.geniisysRows[y];
						objCurrEventDtl.rowIndex = y;
					}									
				},
				onRemoveRowFocus : function(element, value, x, y, id){	
					objCurrEventDtl = null;
				}
			},
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false		    
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},		
				{
					id : "selected",
					title: "",					
					altTitle: "Select",
					width: 25,
			        maxlength: 1,
			        editable: true,
		            editor: new MyTableGrid.CellCheckbox({
		            	onClick: function(value, checked){
		            		if(checked){
								objCurrEventDtl.selected = "Y";
								if(objCurrEvent.eventType == 3 || objCurrEvent.eventType == 4 || objCurrEvent.eventType == 5){
									objCurrEvent.tranId = objCurrEventDtl.tranId;
									objCurrEvent.eventModCd = objCurrEventDtl.eventModCd;
									objCurrEvent.eventColCd = objCurrEventDtl.eventColCd;									
									objCurrEventDtl.viewSw = false;
									showWorkflowUserList(objCurrEvent, 1, objCurrEventDtl.recipient);			
								}
							} else {
								objCurrEventDtl.selected = "N";
								objCurrEventDtl.selectedUsers = [];
							}
		            	},
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	}		            	
			        })
				},				
				{
					id : "tranDtl",
					title: "Transaction",
					type: "string",
					width: '220px',
					filterOption: true
				},			
				{
					id : "sender",
					title: "Sender",
					width: '80px',
					filterOption: true
				},
				{	
					id : "recipient",
					title: "Recipient",
					width: '80px',
					filterOption: true
				},
				{	
					id : "dateReceived",
					title: "Date Received",
					titleAlign: 'center',
					align: 'center',
					width: '100px',
					type: 'date',
					filterOption: true,
					type:'date',
					format: 'mm-dd-yyyy'
					/* renderer: function(value){
						return (value == null || value == "" ? "" : dateFormat(value, 'mm-dd-yyyy'));
					} */
				},
				{	
					id : "remarks",
					title: "Remarks",
					width: '200px',
					filterOption: true								
				},
				{	
					id : "tranId",
					title: "Tran ID",
					width: '80px',
					type: 'number',
					filterOption: true
				},
		        {
		            id: 'status',
		            title: 'Status',
		            width: '150px',
		            editable: true,
		            filterOption: true,
		            editor: new MyTableGrid.SelectBox({
		                onChange: function(value, input){
		                	var y = input.id.substring(input.id.length-1, input.id.length);
		                	var obj = {};
		                	obj.eventUserMod = tbgUserEventDetail.geniisysRows[y].eventUserMod;
		                	obj.eventColCd = tbgUserEventDetail.geniisysRows[y].eventColCd;
		                	obj.tranId = tbgUserEventDetail.geniisysRows[y].tranId;
		                	obj.status = tbgUserEventDetail.geniisysRows[y].status = value;		                	
		                	objModifiedCurrEventDtls.push(obj);
		                	changeTag = 1;
	            		},		
		                list: statusList
		            })
	        	},
				{	
					id : "dateDue",
					title: "Due Date",
					titleAlign: 'center',
					align: 'center',
					width: '100px',
					filterOption: true,
					type:'date',
					format: 'mm-dd-yyyy'
					/* renderer: function(value){
						return (value == null || value == "" ? "" : dateFormat(value, 'mm-dd-yyyy'));
					} */
				},
				{
					id : "selectedUsers",
					title: "",
					width: '0',
					visible: false
				}
			],
			rows: objTGUserEventDetail.rows
		};
	
	tbgUserEventDetail = new MyTableGrid(userEventDetailTable);
	tbgUserEventDetail.pager = objTGUserEventDetail;
	tbgUserEventDetail.render('userEventDetailTable');
	changeTag = 0;
	initializeChangeTagBehavior(saveUserEventDetails);
</script>
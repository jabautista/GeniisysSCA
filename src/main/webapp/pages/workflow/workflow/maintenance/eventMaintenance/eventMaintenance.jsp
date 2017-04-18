<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giiss166Div">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="giiss166Exit">Exit</a></li>
			</ul>
		</div>
	</div>
</div>
<div id="eventMaintenanceMainDiv" style="margin-bottom: 50px; float: left; width: 100%;">
	<div id="eventMaintenanceDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Event Maintenance</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label id="reloadForm" name="reloadForm">Reload Form</label>
		   		</span>
		   	</div>
		</div>
		<div class="sectionDiv" id="eventMaintenanceSectionDiv">
			<div id="eventMaintenanceTableDiv" style="padding: 10px;">
				<div id="eventMaintenanceTable" style="height: 340px;  margin-left: 115px;"></div>
			</div>	   		
			<div id="eventMaintenanceForm" style="width: 100%;">
				<table align="center">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" colspan="3">
							<input type="text" id="txtEventCd" readonly="readonly" style="text-align: right; width: 74px;" class="readOnly" tabindex="101">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3"><input type="text" id="txtEventDesc" style="width: 533px;" maxlength="40" class="required" tabindex="102"></td>
					</tr>
					<tr>
						<td class="rightAligned">Type</td>
						<td class="leftAligned" colspan="3">	
							<span class="required lovSpan" style="width: 80px;">
								<input lastValidValue="" type="text" id="txtEventType" name="txtEventType" style="text-align: right; width: 55px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="103"></input>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchEventType" name="searchEventType" alt="Go" style="float: right;" tabindex="104"/>
							</span>
							<input type="text" id="txtEventTypeDesc" readonly="readonly" style="margin:0 0 0 3px; width: 448px;" class="readOnly" tabindex="105">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Receiver Tag</td>
						<td class="leftAligned" colspan="3"> 
							<span class="required lovSpan" style="width: 80px;">
								<input lastValidValue=""  type="text" id="txtReceiverTag" name="txtReceiverTag" style="width: 55px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="106"></input>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchReceiverTag" name="searchReceiverTag" alt="Go" style="float: right;" tabindex="107"/>
							</span>
							<input type="text" id="txtReceiverTagDesc" readonly="readonly" style="margin:0 0 0 3px; width: 448px;" class="readOnly" tabindex="108">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="109"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="110"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="111"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="112"></td>
					</tr>						
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" enValue="Add" tabindex="113"/>
				<input type="button" class="button" id="btnDelete" name="btnDelete" value="Delete" enValue="Delete" tabindex="114"/>
			</div>
			<div class="sectionDiv" style="margin-left:20px; width:880px; border-bottom: none; border-left: none; border-right: none;" align="center">
				<input type="button" class="button" style="margin: 10px 0 10px 0;" id="btnColumnParameter" name="btnColumnParameter" value="Column Parameters" tabindex="115"/>
			</div>
	   	</div>
	</div>
	<div class="buttonsDiv" id="buttonsDiv">
		<table align="center">
			<tr>
				<td>
					<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" tabindex="116"/>
					<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" tabindex="117"/>
				</td>
			</tr>
		</table>
	</div>	
</div>
<script type="text/javascript">
	setModuleId("GIISS166");
	initializeAll();
	setDocumentTitle("Workflow - Events Maintenance");	
	var objGIISS166 = {};
	objGIISS166.exitPage = null;
	changeTag = 0;
	disableButton("btnDelete");
	disableButton("btnColumnParameter");
	var rowIndex = null;
	var objCurrEvent;
	var objTGEvent = JSON.parse('${eventTableGrid}'.replace(/\\/g, "\\\\"));
	var eventMaintenanceTable = {
			url: contextPath+"/GIISEventController?action=getGIISEventListing&refresh=1",
			options: {
				width: '700px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrEvent = tbgEventMaintenance.geniisysRows[y];
					setFieldValues(objCurrEvent);
					tbgEventMaintenance.keys.removeFocus(tbgEventMaintenance.keys._nCurrentFocus, true);
					tbgEventMaintenance.keys.releaseKeys();
					$("txtEventCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEventMaintenance.keys.removeFocus(tbgEventMaintenance.keys._nCurrentFocus, true);
					tbgEventMaintenance.keys.releaseKeys();
					$("txtEventCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgEventMaintenance.keys.removeFocus(tbgEventMaintenance.keys._nCurrentFocus, true);
						tbgEventMaintenance.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEventMaintenance.keys.removeFocus(tbgEventMaintenance.keys._nCurrentFocus, true);
					tbgEventMaintenance.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEventMaintenance.keys.removeFocus(tbgEventMaintenance.keys._nCurrentFocus, true);
					tbgEventMaintenance.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgEventMaintenance.keys.removeFocus(tbgEventMaintenance.keys._nCurrentFocus, true);
					tbgEventMaintenance.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
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
					id : "eventCd",
					title: "Code",
					width: '70px',
					align : 'right',
					filterOption: true
				},
				{
					id : "eventDesc",
					title: "Description",
					type: "string",
					width: '520px',
					filterOption: true
				},
				{
					id : "eventTypeDesc",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "eventType",
					title: "T",
					width: '30px'
				},
				{	
					id : "receiverTag",
					title: "R",
					width: '30px',
					altTitle: "Receiver Tag"
				},
				{	
					id : "receiverTagDesc",
					title: "",
					width: '0',
					visible: false
				}
			],
			rows: objTGEvent.rows
		};

	tbgEventMaintenance = new MyTableGrid(eventMaintenanceTable);
	tbgEventMaintenance.pager = objTGEvent;
	tbgEventMaintenance.render('eventMaintenanceTable');
	
 	function enableDisableFields(divArray,toDo){
		try{
			if (divArray!= null){
				for ( var i = 0; i < divArray.length; i++) {
					$$("div#"+divArray[i]+" input[type='text'], div#"+divArray[i]+" textarea, div#"+divArray[i]+" input[type='hidden']").each(function (b) {
						if (!($(b).hasClassName("readOnly"))) {
							toDo == "enable" ?  $(b).readOnly= false : $(b).readOnly= true;
						}
					});
					$$("div#"+divArray[i]+" img").each(function (img) {
						var src = img.src;
						if(nvl(img, null) != null){
							if(src.include("searchIcon.png")){
								toDo == "enable" ? enableSearch(img) : disableSearch(img);
							}
						}
					});
				}
			}
		}catch(e){
			showErrorMessage("enableDisableFields", e);
		}
	}
	
	function setFieldValues(rec){
		try {
			$("txtEventCd").value = rec == null ? "" : rec.eventCd;
			$("txtEventDesc").value = rec == null ? "" : unescapeHTML2(rec.eventDesc);
			$("txtEventType").value = rec == null ? "" : rec.eventType;
			$("txtEventType").setAttribute("lastValidValue", (rec == null ? "" : rec.eventType));
			$("txtEventTypeDesc").value = rec == null ? "" : unescapeHTML2(rec.eventTypeDesc);
			$("txtReceiverTag").value = rec == null ? "" : unescapeHTML2(rec.receiverTag);
			$("txtReceiverTag").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.receiverTag)));
			$("txtReceiverTagDesc").value = rec == null ? "" : unescapeHTML2(rec.receiverTagDesc);
			$("txtRemarks").value = rec == null ? "" : unescapeHTML2(rec.remarks);
			
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtEventCd").readOnly = false : $("txtEventCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnColumnParameter") : enableButton("btnColumnParameter");
			if (rec == null) {
				enableButton("btnAdd");
				enableDisableFields(["eventMaintenanceForm"], "enable");
			} else {
				if (rec.recordStatus !== "") {
					enableButton("btnAdd");
					enableDisableFields(["eventMaintenanceForm"], "enable");
				} else {
					disableButton("btnAdd");
					enableDisableFields(["eventMaintenanceForm"], "disable");
				}
			}
			objCurrEvent = rec;
		} catch (e){
			showErrorMessage("setFieldValues", e);
		}
	}

	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.eventCd = $F("txtEventCd");
			obj.eventDesc = escapeHTML2($F("txtEventDesc"));
			obj.eventType = $F("txtEventType");
			obj.eventTypeDesc = escapeHTML2($F("txtEventTypeDesc"));
			obj.receiverTag = escapeHTML2($F("txtReceiverTag"));
			obj.receiverTagDesc = escapeHTML2($F("txtReceiverTagDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			return obj;
		} catch (e){
			showErrorMessage("setRec", e);
		}			
	}
	
	function addRec(){
		try {
			if(checkAllRequiredFieldsInDiv("eventMaintenanceForm")){
				changeTagFunc = saveGiiss166;
				var event = setRec(objCurrEvent);
				if($F("btnAdd") == "Add"){			
					tbgEventMaintenance.addBottomRow(event);			
				} else {
					tbgEventMaintenance.updateVisibleRowOnly(event, rowIndex);
				}
				changeTag = 1;
				setFieldValues(null);
				tbgEventMaintenance.keys.removeFocus(tbgEventMaintenance.keys._nCurrentFocus, true);
				tbgEventMaintenance.keys.releaseKeys();
			}
		} catch (e){
			showErrorMessage("addRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss166;
		objCurrEvent.recordStatus = -1;
		tbgEventMaintenance.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISEventController", {
				parameters : {action : "valDeleteGIISEvents",
							  eventCd : $F("txtEventCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function saveGiiss166(){
		try {
			if(changeTag == 0) {
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
				return;
			}
			var setRows = getAddedAndModifiedJSONObjects(tbgEventMaintenance.geniisysRows);
			var delRows = getDeletedJSONObjects(tbgEventMaintenance.geniisysRows);
			
			new Ajax.Request(contextPath+"/GIISEventController", {
				method : "POST",
				parameters : {action : "saveGIISEvents",
							  setRows : prepareJsonAsParameter(setRows),
							  delRows : prepareJsonAsParameter(delRows)},
				onComplete : function (response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIISS166.exitPage != null) {
								objGIISS166.exitPage();
							} else {
								tbgEventMaintenance._refreshList();
							}
						});
						changeTag = 0;
					}
				}
			});
			
		} catch (e){
			showErrorMessage("saveGiiss166", e);
		}
	} 
	
	function exitPage(){ 
		goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);	
	}	
	
	function cancelGiiss166(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS166.exitPage = exitPage;
						saveGiiss166();
					}, function(){
						goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);	
		}
	}
	
	function showGIISS166ReceiverTagLOV() {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getCgRefCodeLOV",
					domain : "GIIS_EVENTS.RECEIVER_TAG",
					filterText : ($("txtReceiverTag").readAttribute("lastValidValue").trim() != $F("txtReceiverTag").trim() ? $F("txtReceiverTag").trim() : ""),
					page : 1
				},
				title : "Receiver Tag",
				width : 500,
				height : 400,
				columnModel : [ {
					id : "rvLowValue",
					title : "Receiver Tag",
					width : '100px'
				}, {
					id : "rvMeaning",
					title : "Description",
					width : '380px'
				} ],
				autoSelectOneRecord: true,
				filterText : ($("txtReceiverTag").readAttribute("lastValidValue").trim() != $F("txtReceiverTag").trim() ? $F("txtReceiverTag").trim() : ""),
				onSelect : function(row) {
					$("txtReceiverTag").value = row.rvLowValue;
					$("txtReceiverTagDesc").value = unescapeHTML2(row.rvMeaning);
					$("txtReceiverTag").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
				},
				onCancel: function (){
					$("txtReceiverTag").value = escapeHTML2($("txtReceiverTag").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtReceiverTag").value = escapeHTML2($("txtReceiverTag").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		} catch (e) {
			showErrorMessage("showGIISS166ReceiverTagLOV", e);
		}
	}
	
	function showGIISS166EventTypeLOV() {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getCgRefCodeLOV",
					domain : "GIIS_EVENTS.EVENT_TYPE",
					filterText : ($("txtEventType").readAttribute("lastValidValue").trim() != $F("txtEventType").trim() ? $F("txtEventType").trim() : ""),
					page : 1
				},
				title : "Event Type",
				width : 500,
				height : 400,
				columnModel : [ {
					id : "rvLowValue",
					title : "Type",
					width : '100px'
				}, {
					id : "rvMeaning",
					title : "Meaning",
					width : '380px'
				} ],
				autoSelectOneRecord: true,
				filterText : ($("txtEventType").readAttribute("lastValidValue").trim() != $F("txtEventType").trim() ? $F("txtEventType").trim() : ""),
				onSelect : function(row) {
					$("txtEventType").value = row.rvLowValue;
					$("txtEventTypeDesc").value = unescapeHTML2(row.rvMeaning);
					$("txtEventType").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
				},
				onCancel: function (){
					$("txtEventType").value = escapeHTML2($("txtEventType").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtEventType").value = escapeHTML2($("txtEventType").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		} catch (e) {
			showErrorMessage("showGIISS166EventTypeLOV", e);
		}
	}
	
	function showGIISS166DisplayColumnLOV() {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getCgRefCodeLOV",
					domain : "GIIS_DSP_COLUMN.DSP_COL_ID",
					filterText : ($("txtEventType").readAttribute("lastValidValue").trim() != $F("txtEventType").trim() ? $F("txtEventType").trim() : ""),
					page : 1
				},
				title : "Event Type",
				width : 500,
				height : 400,
				columnModel : [ {
					id : "rvLowValue",
					title : "Type",
					width : '100px'
				}, {
					id : "rvMeaning",
					title : "Meaning",
					width : '380px'
				} ],
				autoSelectOneRecord: true,
				filterText : ($("txtEventType").readAttribute("lastValidValue").trim() != $F("txtEventType").trim() ? $F("txtEventType").trim() : ""),
				onSelect : function(row) {
					$("txtEventType").value = row.rvLowValue;
					$("txtEventTypeDesc").value = unescapeHTML2(row.rvMeaning);
					$("txtEventType").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
				},
				onCancel: function (){
					$("txtEventType").value = escapeHTML2($("txtEventType").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtEventType").value = escapeHTML2($("txtEventType").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		} catch (e) {
			showErrorMessage("showGIISS166DisplayColumnLOV", e);
		}
	}
	
	$("searchEventType").observe("click", showGIISS166EventTypeLOV);
	$("searchReceiverTag").observe("click", showGIISS166ReceiverTagLOV);
	
	$("txtEventType").observe("change", function() {
		if($F("txtEventType").trim() == "") {
			$("txtEventType").clear();
			$("txtEventTypeDesc").clear();
			$("txtEventType").setAttribute("lastValidValue", "");
		} else {
			if($F("txtEventType").trim() != "" && $F("txtEventType") != unescapeHTML2($("txtEventType").readAttribute("lastValidValue"))) {
				showGIISS166EventTypeLOV();
			}
		}
	});
	
	$("txtReceiverTag").observe("change", function() {
		if($F("txtReceiverTag").trim() == "") {
			$("txtReceiverTag").clear();
			$("txtReceiverTagDesc").clear();
			$("txtReceiverTag").setAttribute("lastValidValue", "");
		} else {
			if($F("txtReceiverTag").trim() != "" && $F("txtReceiverTag") != unescapeHTML2($("txtReceiverTag").readAttribute("lastValidValue"))) {
				showGIISS166ReceiverTagLOV();
			}
		}
	});
	
	$("btnColumnParameter").observe("click",function(){
		if (objCurrEvent.eventModuleCond == "N") {
			showMessageBox("No data in Event Module Maintenance.","I");
		} else {
			try {
				overlayColumnList  = 
					Overlay.show(contextPath+"/GIISEventController", {
						urlContent: true,
						urlParameters: {
							action : "getGIISEventColumn",
							eventCd : $F("txtEventCd"),
						},
					    title: "List of Columns",
					    height: 550,
					    width: 675,
					    draggable: true
					});
				} catch (e) {
					showErrorMessage("btnColumnParameter - overlayColumnList" , e);
				}		
		}
	});
	
	$("btnDelete").observe("click", valDeleteRec);
	$("btnAdd").observe("click", addRec);
	observeSaveForm("btnSave", saveGiiss166);
	$("btnCancel").observe("click", cancelGiiss166);
	observeReloadForm("reloadForm", showEventsMaintenance);
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("giiss166Exit").stopObserving("click");
	$("giiss166Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtEventCd").focus();
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss168MainDiv" name="giiss168MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>User Events Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div class="sectionDiv">
		<table align="center" style="margin: 15px auto;">
			<tr>
				<td class="rightAligned">Event</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 100px; margin: 0; height: 21px;">
						<input type="text" id="txtEventCd" class="required integerNoNegativeUnformatted" ignoreDelKey="true" style="text-align: right; width: 75px; float: left; border: none; height: 14px; margin: 0;" lastValidValue=""/> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgEvent" alt="Go" style="float: right;"/>
					</span>
					<input id="txtEventDesc" type="text" style="width: 434px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<div id="eventModuleTableDiv" style="padding-top: 10px;">
			<div id="eventModuleTable" style="height: 348px; margin-left: 115px;"></div>
		</div>
		<div align="center" id="eventModuleFormDiv">
			<table style="margin-top: 5px;">
				<tr>
					<td class="rightAligned">Code</td>
					<td class="leftAligned">
						<input id="txtEventModCd" type="text" class="integerNoNegativeUnformatted" readonly="readonly" style="margin: 0; width: 200px; text-align: right;" tabindex="201" maxlength="4">
					</td>
				</tr>				
				<tr>
					<td class="rightAligned">Module</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="width: 100px; margin: 0; height: 21px;">
							<input type="text" id="txtModuleId" class="required" ignoreDelKey="true" style="width: 75px; float: left; border: none; height: 14px; margin: 0;" lastValidValue=""/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgModule" alt="Go" style="float: right;"/>
						</span>
						<input id="txtModuleDesc" type="text" style="width: 427px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Accept Module</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="width: 100px; margin: 0; height: 21px;">
							<input type="text" id="txtAccptModId" class="required" ignoreDelKey="true" style="width: 75px; float: left; border: none; height: 14px; margin: 0;" lastValidValue=""/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgAccptMod" alt="Go" style="float: right;"/>
						</span>
						<input id="txtAccptModDesc" type="text" style="width: 427px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
					</td>
				</tr>
				<tr>
					<td width="" class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned"><input id="txtUserId" type="text" class="" style="margin:0 ; width: 200px;" readonly="readonly" tabindex="206"></td>
					<td width="113px" class="rightAligned">Last Update</td>
					<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="margin:0 ; width: 200px;" readonly="readonly" tabindex="207"></td>
				</tr>			
			</table>
		</div>
		<div style="margin: 10px; text-align: center;">
			<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
			<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
			<div class="sectionDiv" style="float: none; border-bottom: none; margin: 5px auto;"></div>
			<input type="button" class="button" id="btnUserList" value="User List" tabindex="208" style="width: 100px;">
		</div>
	</div>	
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	//$("btnDelete").hide();
	setModuleId("GIISS168");
	setDocumentTitle("User Events Maintenance");
	initializeAll();
	initializeAccordion();
	$("mainNav").hide();
	disableButton("btnAdd");
	disableButton("btnDelete");
	disableButton("btnUserList");
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	observeSaveForm("btnToolbarSave", saveGiiss168);
	changeTag = 0;
	var rowIndex = -1;
	
	observeReloadForm("btnToolbarEnterQuery", showGiiss168);
	
	function saveGiiss168(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRowsEventModules = getAddedAndModifiedJSONObjects(tbgEventModule.geniisysRows);
		//var delRowsEventModules = getDeletedJSONObjects(tbgEventModule.geniisysRows);
		new Ajax.Request(contextPath+"/GIISEventModuleController", {
			method: "POST",
			parameters : {
				action : "saveGiiss168",
				setRowsEventModules : prepareJsonAsParameter(setRowsEventModules)/* ,
				delRowsEventModules : prepareJsonAsParameter(delRowsEventModules) */
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss168.exitPage != null) {
							objGiiss168.exitPage();
						} else {
							tbgEventModule._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss168);
	
	function getSelectedModules(){
		var selectedModules = new Array();
		new Ajax.Request(contextPath + "/GIISEventModuleController",{
			method: "POST",
			parameters: {
				action : "getGiiss168SelectedModules",
			    eventCd : removeLeadingZero($F("txtEventCd"))
			},
			asynchronous: false,
			onCreate : showNotice("Getting selected modules, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var temp = trim(response.responseText);
					temp = temp.substring(0, temp.length - 1);
					selectedModules = temp.split(",");
				}
			}
		});
		
		return selectedModules;
	}
	
	objGiiss168 = new Object();
	var objEventModule = null;
	objGiiss168.eventModuleList = [];//JSON.parse('${jsonEventModule}');
	objGiiss168.exitPage = null;
	
	var eventModuleTable = {
			url : contextPath + "/GIISEventModuleController?action=getGiiss168EventModules&refresh=1&eventCd=" + removeLeadingZero($F("txtEventCd")),
			options : {
				width : 700,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objEventModule = tbgEventModule.geniisysRows[y];
					setFieldValues(objEventModule);
					tbgEventModule.keys.removeFocus(tbgEventModule.keys._nCurrentFocus, true);
					tbgEventModule.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEventModule.keys.removeFocus(tbgEventModule.keys._nCurrentFocus, true);
					tbgEventModule.keys.releaseKeys();
					$("txtEventModCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgEventModule.keys.removeFocus(tbgEventModule.keys._nCurrentFocus, true);
						tbgEventModule.keys.releaseKeys();
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
					tbgEventModule.keys.removeFocus(tbgEventModule.keys._nCurrentFocus, true);
					tbgEventModule.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEventModule.keys.removeFocus(tbgEventModule.keys._nCurrentFocus, true);
					tbgEventModule.keys.releaseKeys();
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
					tbgEventModule.keys.removeFocus(tbgEventModule.keys._nCurrentFocus, true);
					tbgEventModule.keys.releaseKeys();
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
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "moduleId",
					title : "Module ID",
					filterOption : true,
					width : 100
				},	
				{
					id : "moduleDesc",
					title : "Module Name",
					filterOption : true,
					width : 300,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				},	
				{
					id : "accptModId",
					title : "Accept Mod ID",
					filterOption : true,
					width : 100
				},	
				{
					id : "accptModDesc",
					title : "Accept Module Name",
					filterOption : true,
					width : 300,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				}
			],
			rows : []//objGiiss168.eventModuleList.rows
		};

		tbgEventModule = new MyTableGrid(eventModuleTable);
		tbgEventModule.pager = [];//objGiiss168.eventModuleList;
		tbgEventModule.render("eventModuleTable");
		tbgEventModule.afterRender = function(){
			if(tbgEventModule.geniisysRows.length > 0){
				objGiiss168.selectedModules = getSelectedModules();
			} else {
				objGiiss168.selectedModules = new Array();
			}
		};
	
	function setFieldValues(rec){
		try{
			$("txtEventModCd").value = (rec == null ? "" : rec.eventModCd != "" ? formatNumberDigits(rec.eventModCd, 4) : "");
			$("txtModuleId").value = (rec == null ? "" : rec.moduleId);
			$("txtModuleId").setAttribute("lastValidValue", $F("txtModuleId"));
			$("txtModuleDesc").value = (rec == null ? "" : unescapeHTML2(rec.moduleDesc));
			$("txtModuleDesc").setAttribute("lastValidValue", $F("txtModuleDesc"));
			$("txtAccptModId").value = (rec == null ? "" : rec.accptModId);
			$("txtAccptModId").setAttribute("lastValidValue", $F("txtAccptModId"));
			$("txtAccptModDesc").value = (rec == null ? "" : unescapeHTML2(rec.accptModDesc));
			$("txtAccptModDesc").setAttribute("lastValidValue", $F("txtAccptModDesc"));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			//rec == null ? $("txtEventModCd").readOnly = false : $("txtEventModCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnUserList") : enableButton("btnUserList");
			objEventModule = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.eventModCd = $F("txtEventModCd") == "" ? 0 : $F("txtEventModCd"); 
			obj.eventCd = removeLeadingZero($F("txtEventCd"));
			obj.moduleId = $F("txtModuleId");
			obj.moduleDesc = escapeHTML2($F("txtModuleDesc"));
			obj.accptModId = $F("txtAccptModId");
			obj.accptModDesc = escapeHTML2($F("txtAccptModDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss168;
			
			if($F("btnAdd") == "Add")
				objGiiss168.selectedModules.push($F("txtModuleId"));
			else {
				for (i = 0; i < objGiiss168.selectedModules.length; i++){
					if(tbgEventModule.geniisysRows[rowIndex].moduleId == objGiiss168.selectedModules[i])
						objGiiss168.selectedModules.splice(i, 1);
				}
				
				objGiiss168.selectedModules.push($F("txtModuleId"));					
			}
			
			var dept = setRec(objEventModule);
			if($F("btnAdd") == "Add"){
				tbgEventModule.addBottomRow(dept);
			} else {
				tbgEventModule.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgEventModule.keys.removeFocus(tbgEventModule.keys._nCurrentFocus, true);
			tbgEventModule.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("eventModuleFormDiv")){
				if($F("btnAdd") == "Add") {
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgEventModule.geniisysRows.length; i++){
						
						if(tbgEventModule.geniisysRows[i].recordStatus == 0 || tbgEventModule.geniisysRows[i].recordStatus == 1){
							
							if(tbgEventModule.geniisysRows[i].groupCd == $F("txtEventModCd")){
								addedSameExists = true;	
							}	
							
						} else if(tbgEventModule.geniisysRows[i].recordStatus == -1){
							
							if(tbgEventModule.geniisysRows[i].groupCd == $F("txtEventModCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same class_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISEventModuleController", {
						parameters : {action : "valAddRec",
									  groupCd : $F("txtEventModCd")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
					
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		for(var x = 0; x < objGiiss168.selectedModules.size(); x++){
			if(objGiiss168.selectedModules[x] == $F("txtEventModCd"))
				objGiiss168.selectedModules.splice(x, 1);
		}
		changeTagFunc = saveGiiss168;
		objEventModule.recordStatus = -1;
		tbgEventModule.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			if($F("txtEventModCd") == "")
				deleteRec();
			else {
				showMessageBox("You cannot delete this record.", "E");
			}
				
			/* new Ajax.Request(contextPath + "/GIISEventModuleController", {
				parameters : {action : "valDeleteRec",
							  groupCd : $F("txtEventModCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			}); */
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);
	}	
	
	function cancelGiiss168(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss168.exitPage = exitPage;
						saveGiiss168();
					}, function(){
						goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtEventModCd").observe("keyup", function(){
		$("txtEventModCd").value = $F("txtEventModCd").toUpperCase();
	});
	
	observeSaveForm("btnSave", saveGiiss168);
	$("btnCancel").observe("click", cancelGiiss168);
	$("btnAdd").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("eventModuleFormDiv"))
			addRec();
	});
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtEventModCd").focus();
	
	function getEventsLov() {
		LOV.show({
			controller : "WorkflowLOVController",
			urlParameters : {
				action : "getGiiss168EventsLov",
				filterText : ($F("txtEventCd") == $("txtEventCd").readAttribute("lastValidValue") ? "" : $F("txtEventCd")),
				page : 1
			},
			title : "",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "eventCd",
				title : "Code",
				width : '120px',
			}, {
				id : "eventDesc",
				title : "Description",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($F("txtEventCd") == $("txtEventCd").readAttribute("lastValidValue") ? "" : $F("txtEventCd")),
			onSelect : function(row) {
				$("txtEventCd").value = formatNumberDigits(row.eventCd, 4);
				$("txtEventDesc").value = unescapeHTML2(row.eventDesc);
				$("txtEventCd").setAttribute("lastValidValue", $F("txtEventCd"));
				$("txtEventDesc").setAttribute("lastValidValue", $F("txtEventDesc"));
				objGiiss168.receiverTag = row.receiverTag;
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
			},
			onCancel : function () {
				$("txtEventCd").value = $("txtEventCd").readAttribute("lastValidValue");
				$("txtEventDesc").value = $("txtEventDesc").readAttribute("lastValidValue");
				$("txtEventCd").focus();
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", imgMessage.INFO);
				$("txtEventCd").value = $("txtEventCd").readAttribute("lastValidValue");
				$("txtEventDesc").value = $("txtEventDesc").readAttribute("lastValidValue");
				$("txtEventCd").focus();			
			}
		});
	}
	
	$("imgEvent").observe("click", getEventsLov);
	
	$("txtEventCd").observe("change", function(){
		if(this.value.trim() == "") {
			this.clear();
			$("txtEventDesc").clear();
			$("txtEventCd").setAttribute("lastValidValue", "");
			$("txtEventDesc").setAttribute("lastValidValue", "");
			return;
		}
		getEventsLov();
	});
	
	$("txtEventCd").observe("keyup", function(){
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
	});
	
	function executeQuery(){
		tbgEventModule.url = contextPath+"/GIISEventModuleController?action=getGiiss168EventModules&eventCd=" + removeLeadingZero($F("txtEventCd"));		
		tbgEventModule._refreshList();
		disableToolbarButton("btnToolbarExecuteQuery");
		enableButton("btnAdd");
		$("txtModuleId").readOnly = false;
		$("txtAccptModId").readOnly = false;
		enableSearch("imgModule");
		enableSearch("imgAccptMod");
		$("txtEventCd").readOnly = true;
		disableSearch("imgEvent");
	}
	
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	
	$("btnUserList").observe("click", function(){
		try {
			
			if(changeTag != 0){
				showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
					$("btnSave").focus();
				});
				return;
			}
			objGiiss168.exitUserList = null;
			showNotice("Loading, please wait...");
			objGiiss168.eventModCd = removeLeadingZero($F("txtEventModCd"));
			overlayUserList  = 
				Overlay.show(contextPath+"/GIISEventModuleController", {
					urlContent: true,
					urlParameters: {
						action : "showGiiss168UserList",
						eventModCd : objGiiss168.eventModCd,
						ajax : "1"
					},
				    title: "User List",
				    height: 525,
				    width: 655,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("btnUserList" , e);
			}		
	});
	
	function getModuleLov(caller, strSelectedModules) {
		var filterText;
		if(caller == "module")
			filterText = ($F("txtModuleId") == $("txtModuleId").readAttribute("lastValidValue") ? "" : $F("txtModuleId"));
		else
			filterText = ($F("txtAccptModId") == $("txtAccptModId").readAttribute("lastValidValue") ? "" : $F("txtAccptModId"));
		
		LOV.show({
			controller : "WorkflowLOVController",
			urlParameters : {
				action : "getGiis168ModuleLov",
				filterText : filterText,
				selectedModules : strSelectedModules,
				page : 1
			},
			title : "",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "moduleId",
				title : "Code",
				width : '120px',
			}, {
				id : "moduleDesc",
				title : "Description",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : filterText,
			onSelect : function(row) {
				if(caller == "module"){
					$("txtModuleId").value = row.moduleId, 4;
					$("txtModuleDesc").value = unescapeHTML2(row.moduleDesc);
					$("txtModuleId").setAttribute("lastValidValue", $F("txtModuleId"));
					$("txtModuleDesc").setAttribute("lastValidValue", $F("txtModuleDesc"));	
				} else {
					$("txtAccptModId").value = row.moduleId, 4;
					$("txtAccptModDesc").value = unescapeHTML2(row.moduleDesc);
					$("txtAccptModId").setAttribute("lastValidValue", $F("txtAccptModId"));
					$("txtAccptModDesc").setAttribute("lastValidValue", $F("txtAccptModDesc"));
				}
			},
			onCancel : function () {
				if(caller == "module"){
					$("txtModuleId").value = $("txtModuleId").readAttribute("lastValidValue");
					$("txtModuleDesc").value = $("txtModuleDesc").readAttribute("lastValidValue");
					$("txtModuleId").focus();
				} else {
					$("txtAccptModId").value = $("txtAccptModId").readAttribute("lastValidValue");
					$("txtAccptModDesc").value = $("txtAccptModDesc").readAttribute("lastValidValue");
					$("txtAccptModId").focus();
				}
				
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", imgMessage.INFO);
				if(caller == "module"){
					$("txtModuleId").value = $("txtModuleId").readAttribute("lastValidValue");
					$("txtModuleDesc").value = $("txtModuleDesc").readAttribute("lastValidValue");
					$("txtModuleId").focus();
				} else {
					$("txtAccptModId").value = $("txtAccptModId").readAttribute("lastValidValue");
					$("txtAccptModDesc").value = $("txtAccptModDesc").readAttribute("lastValidValue");
					$("txtAccptModId").focus();
				}			
			}
		});
	}
	
	$("imgModule").observe("click", function(){
		var strSelectedModules = "";
		var selectedModules = objGiiss168.selectedModules;  
		
		for(i = 0; i < selectedModules.length; i++){
			strSelectedModules += "'" + selectedModules[i] + "',";
		}
		
		strSelectedModules = "'12345678901'," + strSelectedModules;
		strSelectedModules = "(" + strSelectedModules.substr(0, strSelectedModules.length - 1) + ")";
		getModuleLov("module", strSelectedModules);
	});
	
	$("imgAccptMod").observe("click", function(){
		getModuleLov("accptMod", "");
	});
	
	$("txtModuleId").readOnly = true;
	$("txtAccptModId").readOnly = true;
	disableSearch("imgModule");
	disableSearch("imgAccptMod");
		
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs314MainDiv" name="giacs314MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="acExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Accounting Function Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs314" name="giacs314">		
		<div class="sectionDiv">
			<div id="accountingFunctionTableDiv" style="padding-top: 10px;">
				<div id="accountingFunctionsTable" style="height: 331px; padding-left: 165px;"></div>
			</div>
			<div align="center" id="accountingFunctionsFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">
							<input type="checkbox" name="chkOverride" id="chkOverride" value=""/>
						</td>
						<td><label for="chkOverride" style="float: left;">Override</label></td>
					</tr>
					<tr>
						<td class="rightAligned">Module Name</td>
						<td class="leftAligned">
							<span class="lovSpan" style="width: 200px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" id="txtModuleId" name="txtModuleId" style="width: 173px; float: left; border: none; height: 13px;" ignoreDelKey="1" class="allCaps required" maxlength="15" tabindex="201" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchModule" name="searchModule" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned">Function Code</td>
						<td class="leftAligned">
							<input id="txtFunctionCd" type="text" class="required allCaps" style="width: 232px; margin-bottom: 0px;" tabindex="203" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Function Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtFunctionName" type="text" class="required allCaps" style="width: 533px; text-align: left; margin-bottom: 0px; margin-top: 0px;" tabindex="204" maxlength="100">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtFunctionDesc" type="text" class="required" style="width: 533px; text-align: left;  margin-bottom: 0px; margin-top: 0px;" tabindex="205" maxlength="500">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px; margin-bottom: 0px; margin-top: 0px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="206"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="207"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px; margin-top: 0px;" readonly="readonly" tabindex="208"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 232px; margin-top: 0px;" readonly="readonly" tabindex="209"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="210">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="211">
			</div>
			<div align="center" style="padding: 5px 0 5px 0;">
				<div align="center" style="padding: 10px 0 10px 0; border-top: 1px solid #E0E0E0; width: 800px;">
					<input type="button" class="button" id="btnUserPerFunction" value="User per Function" tabindex="213" style="width: ;">
					<input type="button" class="button" id="btnFunctionCol" value="Function Column" tabindex="212" style="width: ; ">
					<input type="button" class="button" id="btnFunctionDisplay" value="Function Display" tabindex="213" style="width: ;">
				</div>
			</div>
		</div>
	</div>	
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="214">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="215">
	</div>
</div>

<div id="userPerFunctionDiv">

</div>

<script type="text/javascript">	
	setModuleId("GIACS314");
	setDocumentTitle("Accounting Function Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	accessible = 1;
	observeAccessibleModule(accessType.BUTTON, "GIACS315", "btnUserPerFunction", showGiacs315);
	if($("btnUserPerFunction").disabled == true){
		accessible = 0;
	}
	disableButton("btnUserPerFunction");
	disableButton("btnFunctionCol");
	disableButton("btnFunctionDisplay");
	
	function saveGiacs314(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAccountingFunctions.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgAccountingFunctions.geniisysRows);
		new Ajax.Request(contextPath+"/GIACFunctionController", {
			method: "POST",
			parameters : {action : "saveGiacs314",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS314.exitPage != null) {
							objGIACS314.exitPage();
						} else {
							tbgAccountingFunctions._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs314);
	
	var objGIACS314 = {};
	var objCurrAccountingFunctions = null;
	objGIACS314.accountingFunctionList = JSON.parse('${jsonAccountingFunctions}');
	objGIACS314.exitPage = null;
	objGIACS314.moduleId = null;
	objGIACS314.functionColumn = null;
	objGIACS314.functionDisplay = null;
	
	var accountingFunctionsTable = {
			url : contextPath + "/GIACFunctionController?action=showGiacs314&refresh=1",
			options : {
				width : '600px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrAccountingFunctions = tbgAccountingFunctions.geniisysRows[y];
					setFieldValues(objCurrAccountingFunctions);
					tbgAccountingFunctions.keys.removeFocus(tbgAccountingFunctions.keys._nCurrentFocus, true);
					tbgAccountingFunctions.keys.releaseKeys();
					$("txtFunctionName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAccountingFunctions.keys.removeFocus(tbgAccountingFunctions.keys._nCurrentFocus, true);
					tbgAccountingFunctions.keys.releaseKeys();
					$("txtModuleId").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAccountingFunctions.keys.removeFocus(tbgAccountingFunctions.keys._nCurrentFocus, true);
						tbgAccountingFunctions.keys.releaseKeys();
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
					tbgAccountingFunctions.keys.removeFocus(tbgAccountingFunctions.keys._nCurrentFocus, true);
					tbgAccountingFunctions.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAccountingFunctions.keys.removeFocus(tbgAccountingFunctions.keys._nCurrentFocus, true);
					tbgAccountingFunctions.keys.releaseKeys();
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
					tbgAccountingFunctions.keys.removeFocus(tbgAccountingFunctions.keys._nCurrentFocus, true);
					tbgAccountingFunctions.keys.releaseKeys();
				},
				onRowDoubleClick: function(y){
					if(accessible == 0) {
						showMessageBox(objCommonMessage.NO_MODULE_ACCESS, "I");
						return false;
					}
					objCurrAccountingFunctions = tbgAccountingFunctions.geniisysRows[y];
					setFieldValues(objCurrAccountingFunctions);
					if (changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									objGIACS314.exitPage = function(){
										goToGiacs315(); //showGiacs315(); edited by shan 03.19.2014
									};
									saveGiacs314();
								}, 
								function(){
									goToGiacs315(); //showGiacs315(); edited by shan 03.19.2014
									changeTag = 0;
								}, "");
					}else{
						changeTag = 0;
						goToGiacs315(); //showGiacs315(); edited by shan 03.19.2014
					}
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
					id : 'moduleId',
					title : "Module Id",
					visible: false	
				},
				{
					id: 'overrideSw',
					title: 'O',
					altTitle: "Override",
					titleAlign: 'center',
				    width: '20px',
				    visible: true,
				    filterOption: false,
				    defaultValue: false,
					otherValue: false,
					sortable : false,
				    editor: new MyTableGrid.CellCheckbox({
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
					id : 'moduleName',
					filterOption : true,
					title : 'Module Name',
					width : '80px'				
				},
				{
					id : 'functionCode',
					filterOption : true,
					title : 'Function Code',
					width : '100px'				
				},
				{
					id : 'functionName',
					width : '0',
					filterOption : true,
					title : 'Function Name',
					width : '250px'
					
				},				
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIACS314.accountingFunctionList.rows
		};

		tbgAccountingFunctions = new MyTableGrid(accountingFunctionsTable);
		tbgAccountingFunctions.pager = objGIACS314.accountingFunctionList;
		tbgAccountingFunctions.render("accountingFunctionsTable");
	
	function setFieldValues(rec){
		try{
			objACGlobal.objGIACS314.moduleId = (rec == null ? "" : rec.moduleId);		
			objACGlobal.objGIACS314.functionCode = (rec == null ? "" : unescapeHTML2(rec.functionCode));	
			objACGlobal.objGIACS314.moduleName = (rec == null ? "" : unescapeHTML2(rec.moduleName));		
			objACGlobal.objGIACS314.functionName = (rec == null ? "" : unescapeHTML2(rec.functionName));
			objACGlobal.objGIACS314.functionDesc = (rec == null ? "" : unescapeHTML2(rec.functionDesc));	
			objGIACS314.moduleId = (rec == null ? "" : rec.moduleId);
			$("txtModuleId").value = (rec == null ? "" : unescapeHTML2(rec.moduleName));
			$("txtModuleId").setAttribute("lastValidValue", (rec == null ? "" : rec.moduleName));
			$("txtFunctionCd").value = (rec == null ? "" : unescapeHTML2(rec.functionCode));
			$("txtFunctionName").value = (rec == null ? "" : unescapeHTML2(rec.functionName));
			$("txtFunctionDesc").value = (rec == null ? "" : unescapeHTML2(rec.functionDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("chkOverride").checked = (rec == null ? false : (rec.overrideSw == "Y" ? true : false));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtModuleId").readOnly = false : $("txtModuleId").readOnly = true;
			rec == null ? enableSearch("searchModule") : disableSearch("searchModule");
			rec == null ? $("txtFunctionCd").readOnly = false : $("txtFunctionCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnUserPerFunction") : (accessible == 1 ? enableButton("btnUserPerFunction") : disableButton("btnUserPerFunction"));
			rec == null ? disableButton("btnFunctionCol") : enableButton("btnFunctionCol");
			rec == null ? disableButton("btnFunctionDisplay") : enableButton("btnFunctionDisplay");
			objCurrAccountingFunctions = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.moduleId = objGIACS314.moduleId;
			obj.moduleName = escapeHTML2($F("txtModuleId"));
			obj.overrideSw = $("chkOverride").checked ? "Y" : "N";
			obj.functionCode = $F("txtFunctionCd");
			obj.functionName = escapeHTML2($F("txtFunctionName"));
			obj.functionDesc = escapeHTML2($F("txtFunctionDesc"));
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
			changeTagFunc = saveGiacs314;
			var dept = setRec(objCurrAccountingFunctions);
			if($F("btnAdd") == "Add"){
				tbgAccountingFunctions.addBottomRow(dept);
			} else {
				tbgAccountingFunctions.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgAccountingFunctions.keys.removeFocus(tbgAccountingFunctions.keys._nCurrentFocus, true);
			tbgAccountingFunctions.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("accountingFunctionsFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgAccountingFunctions.geniisysRows.length; i++) {
						if (tbgAccountingFunctions.geniisysRows[i].recordStatus == 0 || tbgAccountingFunctions.geniisysRows[i].recordStatus == 1) {
							if (tbgAccountingFunctions.geniisysRows[i].moduleId == objGIACS314.moduleId && tbgAccountingFunctions.geniisysRows[i].functionCode == $F("txtFunctionCd")) {
								addedSameExists = true;
							}
						} else if (tbgAccountingFunctions.geniisysRows[i].recordStatus == -1) {
							if (tbgAccountingFunctions.geniisysRows[i].moduleId == objGIACS314.moduleId && tbgAccountingFunctions.geniisysRows[i].functionCode == $F("txtFunctionCd")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same module_id and function_code.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACFunctionController", {
						parameters : {
							action : "valAddRec",
							moduleId : objGIACS314.moduleId,
							functionCode :$F("txtFunctionCd")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)
									&& checkCustomErrorOnResponse(response)) {
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveGiacs314;
		objCurrAccountingFunctions.recordStatus = -1;
		tbgAccountingFunctions.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIACFunctionController", {
				parameters : {
					action : "valDeleteRec",
					moduleId : objGIACS314.moduleId,
					functionCode :$F("txtFunctionCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if(response.responseText != "N"){
						showMessageBox("Cannot delete record from GIAC_FUNCTIONS while dependent record(s) in "+response.responseText +" exists.", imgMessage.ERROR);
					} else{
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							deleteRec();
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		objACGlobal.callingForm = null;
		objACGlobal.objGIACS314.moduleId = "";		
		objACGlobal.objGIACS314.functionCode = "";	
		objACGlobal.objGIACS314.moduleName = "";		
		objACGlobal.objGIACS314.functionName = "";
		objACGlobal.objGIACS314.functionDesc = "";	
		
		goToModule("/GIISUserController?action=goToAccounting",
				"Accounting Main", null);
	}

	function cancelGiacs314() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIACS314.exitPage = exitPage;
						saveGiacs314();
					}, function() {
						/* goToModule(
								"/GIISUserController?action=goToAccounting",
								"Accounting Main", null); */
						exitPage();
					}, "");
		} else {
			/* goToModule("/GIISUserController?action=goToAccounting",
					"Accounting Main", null); */
			exitPage();
		}
	}

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveGiacs314);
	$("btnCancel").observe("click", cancelGiacs314);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtModuleId").focus();
	
	function showModuleLOV(x){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs314ModuleLOV",
					  search : x,
						page : 1
				},
				title: "List of Module Names",
				width: 450,
				height: 400,
				columnModel: [
		 			{
						id : 'moduleName',
						title: 'Module Name',
						width : '100px',
						align: 'left'
					},
					{
						id : 'scrnRepName',
						title: 'Scrn Rep Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtModuleId").value = unescapeHTML2(row.moduleName);
						objGIACS314.moduleId = unescapeHTML2(row.moduleId);
						$("txtModuleId").setAttribute("lastValidValue",  unescapeHTML2(row.moduleName));
					}
				},
				onCancel: function(){
					$("txtModuleId").focus();
					$("txtModuleId").value = $("txtModuleId").getAttribute("lastValidValue");
			  	},
			  	onUndefinedRow: function(){
		  			$("txtModuleId").value = $("txtModuleId").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtModuleId");
		  		}
			});
		}catch(e){
			showErrorMessage("showModuleLOV",e);
		}
	}
	
	$("searchModule").observe("click", function(){
		showModuleLOV("%");	
	});
	
	$("txtModuleId").observe("change",function(){
		if($("txtModuleId").value == ""){
			objGIACS314.moduleId = "";
			$("txtModuleId").setAttribute("lastValidValue",  "");
		} else {
			validateModule();
		}
	});
	
	function validateModule(){
		new Ajax.Request(contextPath+"/GIACFunctionController", {
			method: "POST",
			parameters: {
				action: "validateGiacs314Module",
				moduleName: $("txtModuleId").value
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.moduleId, "") == ""){
						/* showWaitingMessageBox("No record found.", "I", function(){
							$("txtModuleId").focus();
							$("txtModuleId").value = "";
							objGIACS314.moduleId = "";
						}); */
						showModuleLOV(($("txtModuleId").value));	
					} else if (obj.moduleId == "---") {
						showModuleLOV(($("txtModuleId").value));		
					} else {
						$("txtModuleId").value = unescapeHTML2(obj.moduleName);
						$("txtModuleId").setAttribute("lastValidValue",  unescapeHTML2(obj.moduleName));
						objGIACS314.moduleId = obj.moduleId;
					}
				}
			}
		});
	}
	
	$("btnFunctionCol").observe("click",function(){
		//showFunctionColumn();
		if (changeTag == 1) {
			/* showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						saveGiacs314();
					}, showFunctionColumn() , ""); */
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showFunctionColumn();
		} 
	});
	
	function showFunctionColumn() {
		try {
			overlayFunctionColumn = Overlay.show(contextPath
					+ "/GIACFunctionController", {
				urlContent : true,
				urlParameters : {
					action : "showFunctionColumn",
					ajax : "1",
					moduleId : objCurrAccountingFunctions.moduleId, 
					functionCode : objCurrAccountingFunctions.functionCode
					},
				title : "List of Columns",
				height: 475,
				width: 525,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showFunctionColumn", e);
		}
	}
	
	$("btnFunctionDisplay").observe("click",function(){
		//showFunctionDisplay();
		if (changeTag == 1) {
			/* showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIACS314.exitPage = showFunctionDisplay;
						saveGiacs314();
					}, showFunctionDisplay() , ""); */
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showFunctionDisplay();
		} 
	});
	
	function showFunctionDisplay() {
		try {
			overlayFunctionDisplay = Overlay.show(contextPath
					+ "/GIACFunctionController", {
				urlContent : true,
				urlParameters : {
					action : "showFunctionDisplay",
					ajax : "1",
					moduleId : objCurrAccountingFunctions.moduleId, 
					functionCode : objCurrAccountingFunctions.functionCode
					},
				title : "Display Columns",
				height: 425,
				width: 545,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showFunctionDisplay", e);
		}
	}
	
	function goToGiacs315(){
		objACGlobal.callingForm = "GIACS314";
		$("giacs314MainDiv").hide();
		$("userPerFunctionDiv").show();
		showGiacs315();	
	}
	
	$("btnUserPerFunction").stopObserving("click");
	$("btnUserPerFunction").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS314.exitPage = function(){
							goToGiacs315(); //showGiacs315(); edited by shan 03.19.2014 
						};
						saveGiacs314();
					}, 
					function(){
						goToGiacs315(); //showGiacs315(); edited by shan 03.19.2014
						changeTag = 0;
					}, "");
		}else{
			changeTag = 0;
			goToGiacs315(); //showGiacs315(); edited by shan 03.19.2014
		}
	});
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs317MainDiv" name="giacs317MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="acExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Module Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs317" name="giacs317">		
		<div class="sectionDiv">
			<div id="moduleTableDiv" style="padding-top: 10px;">
				<div id="moduleTable" style="height: 331px; padding-left: 165px;"></div>
			</div>
			<div align="center" id="moduleFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned"></td>
						<td class="leftAligned">
						</td>
						<td class="rightAligned">
							<input type="checkbox" name="chkModEntries" id="chkModEntries" value=""/>
						</td>
						<td class="leftAligned">
							<label for="chkModEntries" style="float: ;">Mod Entries Tag</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Module Name</td>
						<td class="leftAligned">
							<input id="txtModuleName" type="text" class="required allCaps" style="width: 223px; text-align: left;" tabindex="201" maxlength="15">
						</td>
						<!-- <td></td> -->
						<td class="rightAligned">
							<input type="checkbox" name="chkFunction" id="chkFunction" value=""/>
						</td>
						<td class="leftAligned">
							<label for="chkFunction" style="float: ;">Functions Tag</label>
						</td>
						<!-- <td>
							<table cellspacing="0" cellpadding="0">
								<tr>
									<td class="rightAligned">
										<input type="checkbox" name="chkOverride" id="chkOverride" value=""/>
									</td>
									<td class="leftAligned">
										<label for="chkOverride" style="float: ;">Mod Entries Tag</label>
									</td>
									<td class="rightAligned">
										<input type="checkbox" name="chkOverride2" id="chkOverride2" value=""/>
									</td>
									<td class="leftAligned">
										<label for="chkOverride2" style="float: right;">Functions Tag</label>
									</td>
								</tr>
							</table>
						</td> -->
					</tr>
					<tr>
						<td class="rightAligned">Report Tag</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 230px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" id="txtReportTag" name="txtReportTag" style="width: 198px; float: left; border: none; height: 13px;" class="required allCaps" maxlength="100" tabindex="202" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchReportTag" name="searchReportTag" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned">Generation Type</td>
						<td class="leftAligned">
							<input id="txtGenType" type="text" class="allCaps" style="width: 200px; text-align: left;" tabindex="201" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Report Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtReportName" type="text" class="required allCaps" style="width: 542px;" tabindex="203" maxlength="50">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 548px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 520px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 223px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GIACS317");
	setDocumentTitle("Module Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs317(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgModule.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgModule.geniisysRows);
		new Ajax.Request(contextPath+"/GIACModuleController", {
			method: "POST",
			parameters : {action : "saveGiacs317",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS317.exitPage != null) {
							objGIACS317.exitPage();
						} else {
							tbgModule._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs317);
	
	var objGIACS317 = {};
	var objCurrModule = null;
	objGIACS317.moduleList = JSON.parse('${jsonModule}');
	objGIACS317.exitPage = null;
	objGIACS317.moduleId = null;
	objGIACS317.scrnRepTag = null;
	
	var moduleTable = {
			url : contextPath + "/GIACModuleController?action=showGiacs317&refresh=1",
			options : {
				width : '600px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrModule = tbgModule.geniisysRows[y];
					setFieldValues(objCurrModule);
					tbgModule.keys.removeFocus(tbgModule.keys._nCurrentFocus, true);
					tbgModule.keys.releaseKeys();
					$("txtReportName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgModule.keys.removeFocus(tbgModule.keys._nCurrentFocus, true);
					tbgModule.keys.releaseKeys();
					$("txtModuleName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgModule.keys.removeFocus(tbgModule.keys._nCurrentFocus, true);
						tbgModule.keys.releaseKeys();
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
					tbgModule.keys.removeFocus(tbgModule.keys._nCurrentFocus, true);
					tbgModule.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgModule.keys.removeFocus(tbgModule.keys._nCurrentFocus, true);
					tbgModule.keys.releaseKeys();
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
					tbgModule.keys.removeFocus(tbgModule.keys._nCurrentFocus, true);
					tbgModule.keys.releaseKeys();
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
					id : 'moduleName',
					title : "Module Name",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'scrnRepName',
					filterOption : true,
					title : 'Screen/Report Name',
					width : '250px'				
				},
				{
					id : 'scrnRepTagName',
					filterOption : true,
					title : 'Screen/Report Tag',
					width : '130px'				
				},
				{
					id : 'genType',
					filterOption : true,
					title : 'Generation Type',
					width : '100px'				
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
			rows : objGIACS317.moduleList.rows
		};

		tbgModule = new MyTableGrid(moduleTable);
		tbgModule.pager = objGIACS317.moduleList;
		tbgModule.render("moduleTable");
	
	function setFieldValues(rec){
		try{
			$("chkModEntries").checked = (rec == null ? false : (rec.modEntTag == "Y" ? true : false));
			$("chkFunction").checked = (rec == null ? false : (rec.funcTag == "Y" ? true : false));
			objGIACS317.scrnRepTag =  (rec == null ? "" : rec.scrnRepTag);
			objGIACS317.moduleId = (rec == null ? "" : rec.moduleId);
			$("txtModuleName").value = (rec == null ? "" : unescapeHTML2(rec.moduleName));
			$("txtGenType").value = (rec == null ? "" : unescapeHTML2(rec.genType));
			$("txtModuleName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.moduleName)));
			$("txtReportTag").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.scrnRepTagName)));
			$("txtReportName").value = (rec == null ? "" : unescapeHTML2(rec.scrnRepName));
			$("txtReportTag").value = (rec == null ? "" : unescapeHTML2(rec.scrnRepTagName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtLastUpdate").value = (rec == null ? "" : dateFormat(rec.lastUpdate, 'mm-dd-yyyy hh:MM:ss TT'));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtModuleName").readOnly = false : $("txtModuleName").readOnly = true;
			//rec == null ? $("txtGenType").readOnly = false : $("txtGenType").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrModule = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.genType = escapeHTML2($("txtGenType").value);
			obj.scrnRepTag = objGIACS317.scrnRepTag;
			obj.moduleId = objGIACS317.moduleId;
			obj.moduleName = escapeHTML2($F("txtModuleName"));
			obj.scrnRepTagName = escapeHTML2($F("txtReportTag"));
			obj.scrnRepName = escapeHTML2($F("txtReportName"));
			obj.modEntTag = $("chkModEntries").checked ? "Y" : "N";
			obj.funcTag = $("chkFunction").checked ? "Y" : "N";
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
			changeTagFunc = saveGiacs317;
			var dept = setRec(objCurrModule);
			if($F("btnAdd") == "Add"){
				tbgModule.addBottomRow(dept);
			} else {
				tbgModule.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgModule.keys.removeFocus(tbgModule.keys._nCurrentFocus, true);
			tbgModule.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("moduleFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgModule.geniisysRows.length; i++) {
						if (tbgModule.geniisysRows[i].recordStatus == 0 || tbgModule.geniisysRows[i].recordStatus == 1) {
							if (tbgModule.geniisysRows[i].moduleName == $F("txtModuleName") || tbgModule.geniisysRows[i].genType == $F("txtGenType")) {
								addedSameExists = true;
							}
						} else if (tbgModule.geniisysRows[i].recordStatus == -1) {
							if (tbgModule.geniisysRows[i].moduleName == $F("txtModuleName") || tbgModule.geniisysRows[i].genType == $F("txtGenType")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same module_name.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACModuleController", {
						parameters : {
							action : "valAddRec",
							moduleName : $F("txtModuleName"),
							genType : $F("txtGenType")
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
		changeTagFunc = saveGiacs317;
		objCurrModule.recordStatus = -1;
		tbgModule.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			if(objGIACS317.moduleId == ""){
				deleteRec();
			} else {
				new Ajax.Request(contextPath + "/GIACModuleController", {
					parameters : {
						action : "valDeleteRec",
						moduleId : objGIACS317.moduleId
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if(response.responseText == "Y1"){
							showMessageBox("Cannot delete record from GIAC_MODULES while dependent record(s) in GIAC_FUNCTIONS exists.", imgMessage.ERROR);
						} else if(response.responseText == "Y2"){
							showMessageBox("Cannot delete record from GIAC_MODULES while dependent record(s) in GIAC_JE_PARAMETERS exists.", imgMessage.ERROR);
						} else if(response.responseText == "Y3"){
							showMessageBox("Cannot delete record from GIAC_MODULES while dependent record(s) in GIAC_MODULE_ENTRIES exists.", imgMessage.ERROR);
						}else{
							if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
								deleteRec();
							}
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToAccounting",
				"Accounting Main", null);
	}

	function cancelGiacs317() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIACS317.exitPage = exitPage;
						saveGiacs317();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToAccounting",
								"Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting",
					"Accounting Main", null);
		}
	}

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveGiacs317);
	$("btnCancel").observe("click", cancelGiacs317);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtModuleName").focus();
	
	$("txtReportTag").observe("change", function(){
		if($("txtReportTag").value != ""){
			validateScrnRepTag();
		} else {
			$("txtReportTag").value = "";
			objGIACS317.scrnRepTag = "";
		}
	});
	
	function validateScrnRepTag(){
		new Ajax.Request(contextPath+"/GIACModuleController", {
			method: "POST",
			parameters: {
				action: "validateGiacs317ScreenRepTag",
				scrnRepTagName: $F("txtReportTag")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.scrnRepTagName, "") == ""){
						showScrnRepTagLOV();
						/* showWaitingMessageBox("No record found.", "I", function(){
							$("txtReportTag").focus();
							$("txtReportTag").value = $("txtReportTag").readAttribute("lastValidValue");
						}); */
					} else if(obj.scrnRepTagName == "---"){
						showScrnRepTagLOV();
					} else{
						$("txtReportTag").value = unescapeHTML2(obj.scrnRepTagName);
						$("txtReportTag").setAttribute("lastValidValue", unescapeHTML2(obj.scrnRepTagName));
						objGIACS317.scrnRepTag = unescapeHTML2(obj.scrnRepTag);
					}
				}
			}
		});
	}
	
	$("searchReportTag").observe("click", showScrnRepTagLOV);
	
	function showScrnRepTagLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs317ScrnRepTagLOV",
				   filterText: $F("txtReportTag") != $("txtReportTag").getAttribute("lastValidValue") ? nvl($F("txtReportTag"), "%") : "%",  
						page : 1
				},
				title: "List of Report Tag",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'rvLowValue',
						title: 'Screen/Report Tag',
						width : '100px',
						align: 'left'
					},
					{
						id : 'rvMeaning',
						title: 'Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: $F("txtReportTag") != $("txtReportTag").getAttribute("lastValidValue") ? nvl($F("txtReportTag"), "%") : "%", 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtReportTag").value = unescapeHTML2(row.rvMeaning);
						objGIACS317.scrnRepTag = unescapeHTML2(row.rvLowValue);
						$("txtReportTag").setAttribute("lastValidValue", unescapeHTML2(row.rvMeaning));
					}
				},
				onCancel: function(){
					$("txtReportTag").focus();
					$("txtReportTag").value = $("txtReportTag").readAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			showWaitingMessageBox("No record found.", "I", function(){
		  				$("txtReportTag").value = $("txtReportTag").readAttribute("lastValidValue");
					});
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showScrnRepTagLOV",e);
		}
	}
</script>
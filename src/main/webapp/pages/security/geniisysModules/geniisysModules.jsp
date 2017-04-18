<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss081MainDiv" name="giiss081MainDiv">
	<div id="giiss081MenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Maintain GenIISys Modules</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giiss081" name="giiss081">
		<div class="sectionDiv">
			<div id="giisModulesTableDiv" style="padding-top: 10px;">
				<div id="giisModulesTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giisModulesFormDiv" style="margin-right: 50px;">
				<table style="margin-top: 5px;">
					<tr>
						<td align="right">Module ID</td>
						<td>
							<input id="txtModuleId" class="required" type="text" style="width: 200px; margin-bottom: 0" maxlength="10" tabindex="201">
						</td>		
						<td align="right" style="width: 100px;">Type</td>
						<td>
							<span class="lovSpan required" style="width: 100px; height: 19px; margin-top: 2px; margin-bottom: 0px">
								<input id="txtModuleType" class="required" maxlength="1" type="text" style="width:75px; height: 13px; border: 0; margin: 0" tabindex="202" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchModuleType" class="required" alt="Go" style="float: right; margin-top: 2px;" tabindex="203"/>
							</span>	
						</td>
						<td><input id="txtDspModuleTypeDesc" readonly="readonly" type="text" style="width:200px; margin-bottom: 0px" tabindex="204"></td>		
					</tr>
					<tr>
						<td align="right">Module Description</td>
						<td colspan="4">
							<input id="txtModuleDesc" type="text" class="required" style="width: 622px;" maxlength="100" tabindex="205">
						</td>
					</tr>
					<tr>
						<td align="right">Remarks</td>
						<td colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 628px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 602px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="206"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="207"/>
							</div>
						</td>
					</tr>
					<tr>
						<td align="right">User ID</td>
						<td><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
						<td align="right" colspan="2">Last Update</td>
						<td><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="209"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="210">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="211">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnTransaction" value="Transaction" style="width: 150px;">
				<input type="button" class="button" id="btnUserWAccess" value="User w/ Access" style="width: 150px;">
				<input type="button" class="button" id="btnUserGroupAccess" value="User Group w/ Access" style="width: 150px;">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">
	setModuleId("GIISS081");
	setDocumentTitle("Maintain GenIISys Modules");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	var objGIISS081 = {};
	var objCurrGeniisysModule= null;
	objGIISS081.geniisysModuleList = JSON.parse('${jsonGeniisysModulesList}');
	objGIISS081.exitPage = null;
	
	var giisModuleTable = {
			url : contextPath + "/GIISModuleController?action=showGiiss081&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGeniisysModule = tbgGiisModule.geniisysRows[y];
					setFieldValues(objCurrGeniisysModule);
					tbgGiisModule.keys.removeFocus(tbgGiisModule.keys._nCurrentFocus, true);
					tbgGiisModule.keys.releaseKeys();
					$("txtModuleId").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiisModule.keys.removeFocus(tbgGiisModule.keys._nCurrentFocus, true);
					tbgGiisModule.keys.releaseKeys();
					$("txtModuleId").focus();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGiisModule.keys.removeFocus(tbgGiisModule.keys._nCurrentFocus, true);
						tbgGiisModule.keys.releaseKeys();
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
					tbgGiisModule.keys.removeFocus(tbgGiisModule.keys._nCurrentFocus, true);
					tbgGiisModule.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiisModule.keys.removeFocus(tbgGiisModule.keys._nCurrentFocus, true);
					tbgGiisModule.keys.releaseKeys();
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
					tbgGiisModule.keys.removeFocus(tbgGiisModule.keys._nCurrentFocus, true);
					tbgGiisModule.keys.releaseKeys();
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
					width : '80px'
				},
				{
					id : 'moduleDesc',
					filterOption : true,
					title : 'Module Description',
					width : '500px'				
				},
				{
					id : "moduleType",
					title : "Type",
					filterOption : true,
					width : '60px'
				},
				{
					id : 'moduleGrp',
					width : '0',
					visible: false				
				},
				{
					id : 'modAccessTag',
					width : '0',
					visible: false				
				},
				{
					id : 'webEnabled',
					width : '0',
					visible: false				
				},
				{
					id : 'dspModuleTypeDesc',
					width : '0',
					visible: false				
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
			rows : objGIISS081.geniisysModuleList.rows
	};
	tbgGiisModule = new MyTableGrid(giisModuleTable);
	tbgGiisModule.pager = objGIISS081.geniisysModuleList;
	tbgGiisModule.render("giisModulesTable");
	
	function setFieldValues(rec){
		try{
			$("txtModuleId").value = (rec == null ? "" : unescapeHTML2(rec.moduleId));
			$("txtModuleDesc").value = (rec == null ? "" : unescapeHTML2(rec.moduleDesc));
			$("txtModuleType").value = (rec == null ? "" : rec.moduleType);
			$("txtModuleType").setAttribute("lastValidValue", (rec == null ? "" : rec.moduleType));
			$("txtDspModuleTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.dspModuleTypeDesc));
			$("txtDspModuleTypeDesc").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspModuleTypeDesc)));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtModuleId").readOnly = false : $("txtModuleId").readOnly = true;
			rec == null ? $("txtModuleDesc").readOnly = false : $("txtModuleDesc").readOnly = true;
			rec == null ? $("txtModuleType").readOnly = false : $("txtModuleType").readOnly = true;
			rec == null ? enableSearch("imgSearchModuleType") : disableSearch("imgSearchModuleType");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			rec == null ? disableButton("btnTransaction") : enableButton("btnTransaction");
			rec == null ? disableButton("btnUserWAccess") : enableButton("btnUserWAccess");
			rec == null ? disableButton("btnUserGroupAccess") : enableButton("btnUserGroupAccess");
			
			objCurrGeniisysModule = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisModulesFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgGiisModule.geniisysRows.length; i++){
						if(tbgGiisModule.geniisysRows[i].recordStatus == 0 || tbgGiisModule.geniisysRows[i].recordStatus == 1){								
							if(tbgGiisModule.geniisysRows[i].moduleId == $F("txtModuleId")){
								addedSameExists = true;								
							}							
						} else if(tbgGiisModule.geniisysRows[i].recordStatus == -1){
							if(tbgGiisModule.geniisysRows[i].moduleId == $F("txtModuleId")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same module_id.", "E");
						return false;
					} else if(deletedSameExists && !addedSameExists){
						addedSameExists = false;
						deletedSameExists = false;	
						
						for(var i=0; i<tbgGiisModule.geniisysRows.length; i++){
							if(tbgGiisModule.geniisysRows[i].recordStatus == 0 || tbgGiisModule.geniisysRows[i].recordStatus == 1){								
								if(tbgGiisModule.geniisysRows[i].moduleDesc == $F("txtModuleDesc")){
									addedSameExists = true;								
								}							
							} else if(tbgGiisModule.geniisysRows[i].recordStatus == -1){
								if(tbgGiisModule.geniisysRows[i].moduleDesc == $F("txtModuleDesc")){
									deletedSameExists = true;
								}
							}
						}
						
						if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
							showMessageBox("Record already exists with the same module_desc.", "E");
							return false;
						} else if(deletedSameExists && !addedSameExists){
							addRec();
							return;
						}
					}
					
					new Ajax.Request(contextPath + "/GIISModuleController", {
						parameters : {action : "valAddRec",
									  moduleId : $F("txtModuleId"),
									  moduleDesc : $F("txtModuleDesc")
						},
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
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss081;
			var geniisysModule = setRec(objCurrGeniisysModule);
			if($F("btnAdd") == "Add"){
				tbgGiisModule.addBottomRow(geniisysModule);
			} else {
				tbgGiisModule.updateVisibleRowOnly(geniisysModule, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgGiisModule.keys.removeFocus(tbgGiisModule.keys._nCurrentFocus, true);
			tbgGiisModule.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.moduleId = escapeHTML2($F("txtModuleId"));
			obj.moduleDesc = escapeHTML2($F("txtModuleDesc"));
			obj.moduleType = $F("txtModuleType");
			obj.dspModuleTypeDesc = escapeHTML2($F("txtDspModuleTypeDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISModuleController", {
				parameters : {
					action : "valDeleteRec",
				    moduleId : $F("txtModuleId"),
				},
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
	
	function deleteRec(){
		changeTagFunc = saveGiiss081;
		objCurrGeniisysModule.recordStatus = -1;
		tbgGiisModule.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToSecurity", "Security Main", null);
	}	
	
	function cancelGiiss081(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS081.exitPage = exitPage;
						saveGiiss081();
					}, function(){
						goToModule("/GIISUserController?action=goToSecurity", "Security Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToSecurity", "Security Main", null);
		}
	}
	
	function saveGiiss081(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGiisModule.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGiisModule.geniisysRows);

		new Ajax.Request(contextPath+"/GIISModuleController", {
			method: "POST",
			parameters : {
				action : "saveGiiss081",
		 	  	setRows : prepareJsonAsParameter(setRows),
		 	 	delRows : prepareJsonAsParameter(delRows)
		 	 },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS081.exitPage != null) {
							objGIISS081.exitPage();
						} else {
							tbgGiisModule._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function showGeniisysModuleTran(){
		try {
			overlayGeniisysModuleTran = 
				Overlay.show(contextPath+"/GIISModuleController", {
					urlContent: true,
					urlParameters: {
						action : "showGeniisysModuleTran",																
						moduleId : $F("txtModuleId"),
					},
				    title: "Transactions Per Module",
				    height: 400,
				    width: 600,
				    draggable: true
				});
		} catch (e) {
			showErrorMessage("Transactions Per Module Error :" , e);
		}
	}
	
	function showGeniisysUsersWAccess(){
		try {
			overlayGeniisysUserWAccess = 
				Overlay.show(contextPath+"/GIISModuleController", {
					urlContent: true,
					urlParameters: {
						action : "showGeniisysUsersWAccess",																
						moduleId : $F("txtModuleId"),
						moduleDesc : $F("txtModuleDesc")
					},
				    title: "Users With Access",
				    height: 500,
				    width: 700,
				    draggable: true
				});
		} catch (e) {
			showErrorMessage("Users With Access Error :" , e);
		}
	}
	
	function showGeniisysUserGrpWAccess(){
		try {
			overlayGeniisysUserGrpWAccess = 
				Overlay.show(contextPath+"/GIISModuleController", {
					urlContent: true,
					urlParameters: {
						action : "showGeniisysUserGrpWAccess",																
						moduleId : $F("txtModuleId"),
						moduleDesc : $F("txtModuleDesc")
					},
				    title: "User Groups With Access",
				    height: 500,
				    width: 700,
				    draggable: true
				});
		} catch (e) {
			showErrorMessage("User Groups With Access Error :" , e);
		}
	}
	
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnCancel").observe("click", cancelGiiss081);
	observeSaveForm("btnSave", saveGiiss081);
	
	$("btnTransaction").observe("click", showGeniisysModuleTran);
	$("btnUserWAccess").observe("click", showGeniisysUsersWAccess);
	$("btnUserGroupAccess").observe("click", showGeniisysUserGrpWAccess);
	
	$("txtModuleType").setAttribute("lastValidValue", "");
	$("imgSearchModuleType").observe("click", showGiiss081ModuleTypeLov);
	$("txtModuleType").observe("change", function() {		
		if($F("txtModuleType").trim() == "") {
			$("txtModuleType").value = "";
			$("txtModuleType").setAttribute("lastValidValue", "");
			$("txtDspModuleTypeDesc").value = "";
			$("txtDspModuleTypeDesc").setAttribute("lastValidValue", "");
		} else {
			if($F("txtModuleType").trim() != "" && $F("txtModuleType") != $("txtModuleType").readAttribute("lastValidValue")) {
				showGiiss081ModuleTypeLov();
			}
		}
	});
	
	function showGiiss081ModuleTypeLov(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss081ModuleType",
				filterText : ($("txtModuleType").readAttribute("lastValidValue").trim() != $F("txtModuleType").trim() ? $F("txtModuleType").trim() : ""),
				page : 1
			},
			title: "List of Module Types",
			width: 450,
			height: 400,
			columnModel : [
					{
						id : "moduleType",
						title: "Module Type",
						width: '100px',
						filterOption: true
					},
					{
						id : "moduleTypeDesc",
						title: "Module Type Desc.",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtModuleType").readAttribute("lastValidValue").trim() != $F("txtModuleType").trim() ? $F("txtModuleType").trim() : ""),
			onSelect: function(row) {
				$("txtModuleType").value = row.moduleType;
				$("txtModuleType").setAttribute("lastValidValue", row.moduleType);	
				$("txtDspModuleTypeDesc").value = unescapeHTML2(row.moduleTypeDesc);
				$("txtDspModuleTypeDesc").setAttribute("lastValidValue", unescapeHTML2(row.moduleTypeDesc));
			},
			onCancel: function (){
				$("txtModuleType").value = $("txtModuleType").readAttribute("lastValidValue");
				$("txtDspModuleTypeDesc").value = unescapeHTML2($("txtDspModuleTypeDesc").readAttribute("lastValidValue"));
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtModuleType").value = $("txtModuleType").readAttribute("lastValidValue");
				$("txtDspModuleTypeDesc").value = unescapeHTML2($("txtDspModuleTypeDesc").readAttribute("lastValidValue"));
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	$("txtModuleId").observe("keyup", function(){
		$("txtModuleId").value = $F("txtModuleId").toUpperCase();
	});
	
	$("txtModuleDesc").observe("keyup", function(){
		$("txtModuleDesc").value = $F("txtModuleDesc").toUpperCase();
	});
	
	$("txtModuleType").observe("keyup", function(){
		$("txtModuleType").value = $F("txtModuleType").toUpperCase();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	observeReloadForm("reloadForm", showGiiss081);
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	disableButton("btnDelete");
	disableButton("btnTransaction");
	disableButton("btnUserWAccess");
	disableButton("btnUserGroupAccess");
	$("txtModuleId").focus();	
</script>
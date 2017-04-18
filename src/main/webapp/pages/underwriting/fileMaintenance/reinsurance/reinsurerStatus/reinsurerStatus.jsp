<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss073MainDiv" name="giiss073MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="riStatusMaintenance">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Reinsurer Status Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss073" name="giiss073">		
		<div class="sectionDiv">
			<div id="reinsurerStatusTableDiv" style="padding-top: 10px;">
				<div id="reinsurerStatusTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="reinsurerStatusFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtStatusCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="201" maxlength="2">
						</td>						
					</tr>	
					<tr>
						<td width="" class="rightAligned">Status Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtStatusDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="20">
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
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="110px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv" style="margin-left:10px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GIISS073");
	setDocumentTitle("Reinsurer Status Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss073(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgReinsurerStatus.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgReinsurerStatus.geniisysRows);
		new Ajax.Request(contextPath+"/GIISRiStatusController", {
			method: "POST",
			parameters : {action : "saveGiiss073",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS073.exitPage != null) {
							objGIISS073.exitPage();
						} else {
							tbgReinsurerStatus._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss073);
	
	var objGIISS073 = {};
	var objCurrRiStatus = null;
	objGIISS073.riStatusList = JSON.parse('${jsonRiStatusList}');
	objGIISS073.exitPage = null;
	
	var reinsurerStatusTable = {
			url : contextPath + "/GIISRiStatusController?action=showGiiss073&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRiStatus = tbgReinsurerStatus.geniisysRows[y];
					setFieldValues(objCurrRiStatus);
					tbgReinsurerStatus.keys.removeFocus(tbgReinsurerStatus.keys._nCurrentFocus, true);
					tbgReinsurerStatus.keys.releaseKeys();
					$("txtStatusDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReinsurerStatus.keys.removeFocus(tbgReinsurerStatus.keys._nCurrentFocus, true);
					tbgReinsurerStatus.keys.releaseKeys();
					$("txtStatusCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgReinsurerStatus.keys.removeFocus(tbgReinsurerStatus.keys._nCurrentFocus, true);
						tbgReinsurerStatus.keys.releaseKeys();
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
					tbgReinsurerStatus.keys.removeFocus(tbgReinsurerStatus.keys._nCurrentFocus, true);
					tbgReinsurerStatus.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReinsurerStatus.keys.removeFocus(tbgReinsurerStatus.keys._nCurrentFocus, true);
					tbgReinsurerStatus.keys.releaseKeys();
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
					tbgReinsurerStatus.keys.removeFocus(tbgReinsurerStatus.keys._nCurrentFocus, true);
					tbgReinsurerStatus.keys.releaseKeys();
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
					id : "statusCd",
					title : "Code",
					titleAlign: 'right',
					align: 'right',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					width : '100px'
				},
				{
					id : 'statusDesc',
					filterOption : true,
					title : 'Status Description',
					width : '560px'				
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
			rows : objGIISS073.riStatusList.rows
		};

		tbgReinsurerStatus = new MyTableGrid(reinsurerStatusTable);
		tbgReinsurerStatus.pager = objGIISS073.riStatusList;
		tbgReinsurerStatus.render("reinsurerStatusTable");
	
	function setFieldValues(rec){
		try{
			$("txtStatusCd").value = (rec == null ? "" : rec.statusCd);
			$("txtStatusCd").setAttribute("lastValidValue", (rec == null ? "" : rec.statusCd));
			$("txtStatusDesc").value = (rec == null ? "" : unescapeHTML2(rec.statusDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtStatusCd").readOnly = false : $("txtStatusCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrRiStatus = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.statusCd = $F("txtStatusCd");
			obj.statusDesc = escapeHTML2($F("txtStatusDesc"));
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
			changeTagFunc = saveGiiss073;
			var dept = setRec(objCurrRiStatus);
			if($F("btnAdd") == "Add"){
				tbgReinsurerStatus.addBottomRow(dept);
			} else {
				tbgReinsurerStatus.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgReinsurerStatus.keys.removeFocus(tbgReinsurerStatus.keys._nCurrentFocus, true);
			tbgReinsurerStatus.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("reinsurerStatusFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					var fieldItem = "";
					
					for(var i=0; i<tbgReinsurerStatus.geniisysRows.length; i++){
						if(tbgReinsurerStatus.geniisysRows[i].recordStatus == 0 || tbgReinsurerStatus.geniisysRows[i].recordStatus == 1){								
							if(tbgReinsurerStatus.geniisysRows[i].statusCd == $F("txtStatusCd")){
								addedSameExists = true;
								fieldItem = "status_cd"; // Kris 10.24.2013
							}	
							// added for status_desc Kris 10.24.2013
							else if(tbgReinsurerStatus.geniisysRows[i].statusDesc.toUpperCase() == $F("txtStatusDesc").toUpperCase()){
								addedSameExists = true;
								fieldItem = "status_desc";
							}
						} else if(tbgReinsurerStatus.geniisysRows[i].recordStatus == -1){
							if(tbgReinsurerStatus.geniisysRows[i].statusCd == $F("txtStatusCd")){
								deletedSameExists = true;
								fieldItem = "status_cd"; // Kris 10.24.2013
							}// added for status_desc Kris 10.24.2013
							else if(tbgReinsurerStatus.geniisysRows[i].statusDesc.toUpperCase() == $F("txtStatusDesc").toUpperCase()){
								deletedSameExists = true;
								fieldItem = "status_desc";
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same "+fieldItem+".", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISRiStatusController", {
						parameters : {action : "valAddRec",
									  statusCd : $F("txtStatusCd"),
									  statusDesc: $F("txtStatusDesc")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					//addRec(); commented out and replaced with the block below. needs to validate duplicate status_desc upon update
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					var ignoreThis = false;
					var fieldItem = "";
					
					for(var i=0; i<tbgReinsurerStatus.geniisysRows.length; i++){
						if(tbgReinsurerStatus.geniisysRows[i].recordStatus == 0 || tbgReinsurerStatus.geniisysRows[i].recordStatus == 1){								
							if(tbgReinsurerStatus.geniisysRows[i].statusCd != $F("txtStatusCd") &&
									tbgReinsurerStatus.geniisysRows[i].statusDesc.toUpperCase() == $F("txtStatusDesc").toUpperCase()){
								addedSameExists = true;
								fieldItem = "status_desc";
							}
							if(tbgReinsurerStatus.geniisysRows[i].statusCd == $F("txtStatusCd") &&
									tbgReinsurerStatus.geniisysRows[i].statusDesc.toUpperCase() == $F("txtStatusDesc").toUpperCase()){
								ignoreThis = true;
							}
						} else if(tbgReinsurerStatus.geniisysRows[i].recordStatus == -1){
							if(tbgReinsurerStatus.geniisysRows[i].statusCd != $F("txtStatusCd") &&
									tbgReinsurerStatus.geniisysRows[i].statusDesc.toUpperCase() == $F("txtStatusDesc").toUpperCase()){
								deletedSameExists = true;
								fieldItem = "status_desc";
							}
							if(tbgReinsurerStatus.geniisysRows[i].statusCd == $F("txtStatusCd") &&
									tbgReinsurerStatus.geniisysRows[i].statusDesc.toUpperCase() == $F("txtStatusDesc").toUpperCase()){
								ignoreThis = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						//showMessageBox("Record already exists with the same status_desc.", "E");
						showMessageBox("Record already exists with the same "+fieldItem+".", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					if(!addedSameExists && !deletedSameExists && ignoreThis){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISRiStatusController", {
						parameters : {action : "valAddRec",
									  statusCd : null,
									  statusDesc: $F("txtStatusDesc")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss073;
		objCurrRiStatus.recordStatus = -1;
		tbgReinsurerStatus.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISRiStatusController", {
				parameters : {action : "valDeleteRec",
							  statusCd : $F("txtStatusCd")},
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
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss073(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS073.exitPage = exitPage;
						saveGiiss073();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtStatusDesc").observe("keyup", function(){
		$("txtStatusDesc").value = $F("txtStatusDesc").toUpperCase();
	});
	
	$("txtStatusCd").observe("keyup", function(){
		$("txtStatusCd").value = $F("txtStatusCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss073);
	$("btnCancel").observe("click", cancelGiiss073);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("riStatusMaintenance").stopObserving("click");
	$("riStatusMaintenance").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtStatusCd").focus();	
</script>
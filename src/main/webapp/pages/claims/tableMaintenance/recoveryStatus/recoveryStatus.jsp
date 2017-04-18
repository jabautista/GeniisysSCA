<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls100MainDiv" name="gicls100MainDiv" style="">
	<div id="gicls100Div">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="gicls100Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Recovery Status Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls100" name="gicls100">		
		<div class="sectionDiv">
			<div id="giisRecoveryStatusTableDiv" style="padding-top: 10px;">
				<div id="giisRecoveryStatusTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giisRecoveryStatusFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Status Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRecStatCd" type="text" class="required" style="width: 200px;" tabindex="101" maxlength="5">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Status Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRecStatDesc" type="text" class="required" style="width: 533px;" tabindex="102" maxlength="50">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="103"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="105"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="106"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="108">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="109">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="110">
</div>
<script type="text/javascript">	
	setModuleId("GICLS100");
	setDocumentTitle("Recovery Status Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls100(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGIISRecoveryStatus.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGIISRecoveryStatus.geniisysRows);
		new Ajax.Request(contextPath+"/GIISRecoveryStatusController", {
			method: "POST",
			parameters : {action : "saveGicls100",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS100.exitPage != null) {
							objGICLS100.exitPage();
						} else {
							tbgGIISRecoveryStatus._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGicls100);
	
	var origRecStatDesc = null;
	var objGICLS100 = {};
	var objCurrGIISRecoveryStatus = null;
	objGICLS100.giisRecoveryStatusList = JSON.parse('${jsonGIISRecoveryStatus}');
	objGICLS100.exitPage = null;
	
	var giisRecoveryStatusTable = {
			url : contextPath + "/GIISRecoveryStatusController?action=showGicls100&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGIISRecoveryStatus = tbgGIISRecoveryStatus.geniisysRows[y];
					setFieldValues(objCurrGIISRecoveryStatus);
					tbgGIISRecoveryStatus.keys.removeFocus(tbgGIISRecoveryStatus.keys._nCurrentFocus, true);
					tbgGIISRecoveryStatus.keys.releaseKeys();
					$("txtRecStatDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISRecoveryStatus.keys.removeFocus(tbgGIISRecoveryStatus.keys._nCurrentFocus, true);
					tbgGIISRecoveryStatus.keys.releaseKeys();
					$("txtRecStatCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGIISRecoveryStatus.keys.removeFocus(tbgGIISRecoveryStatus.keys._nCurrentFocus, true);
						tbgGIISRecoveryStatus.keys.releaseKeys();
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
					tbgGIISRecoveryStatus.keys.removeFocus(tbgGIISRecoveryStatus.keys._nCurrentFocus, true);
					tbgGIISRecoveryStatus.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISRecoveryStatus.keys.removeFocus(tbgGIISRecoveryStatus.keys._nCurrentFocus, true);
					tbgGIISRecoveryStatus.keys.releaseKeys();
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
					tbgGIISRecoveryStatus.keys.removeFocus(tbgGIISRecoveryStatus.keys._nCurrentFocus, true);
					tbgGIISRecoveryStatus.keys.releaseKeys();
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
					id : "recStatCd",
					title : "Status Code",
					filterOption : true,
					width : '150px'
				},
				{
					id : 'recStatDesc',
					title : 'Status Description',
					filterOption : true,
					width : '500px'				
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
			rows : objGICLS100.giisRecoveryStatusList.rows
		};

		tbgGIISRecoveryStatus = new MyTableGrid(giisRecoveryStatusTable);
		tbgGIISRecoveryStatus.pager = objGICLS100.giisRecoveryStatusList;
		tbgGIISRecoveryStatus.render("giisRecoveryStatusTable");
	
	function setFieldValues(rec){
		try{
			$("txtRecStatCd").value = (rec == null ? "" : unescapeHTML2(rec.recStatCd));
			$("txtRecStatCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.recStatCd)));
			$("txtRecStatDesc").value = (rec == null ? "" : unescapeHTML2(rec.recStatDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			origRecStatDesc = (rec == null ? "" : unescapeHTML2(rec.recStatDesc));
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtRecStatCd").readOnly = false : $("txtRecStatCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrGIISRecoveryStatus = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.recStatCd = escapeHTML2($F("txtRecStatCd"));
			obj.recStatDesc = escapeHTML2($F("txtRecStatDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			obj.origRecStatDesc = escapeHTML2(origRecStatDesc == null ? $F("txtRecStatDesc") : origRecStatDesc);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGicls100;
			var dept = setRec(objCurrGIISRecoveryStatus);
			if($F("btnAdd") == "Add"){
				tbgGIISRecoveryStatus.addBottomRow(dept);
			} else {
				tbgGIISRecoveryStatus.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgGIISRecoveryStatus.keys.removeFocus(tbgGIISRecoveryStatus.keys._nCurrentFocus, true);
			tbgGIISRecoveryStatus.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddUpdateRec(mode) {
		try {
			var addedSameExists = false;
			var deletedSameExists = false;	
			var addedSameExists2 = false;
			var deletedSameExists2 = false;
			var updatedSameExists2 = false;
			var deletedSameExists3 = false;
			for(var i=0; i<tbgGIISRecoveryStatus.geniisysRows.length; i++){
				if(tbgGIISRecoveryStatus.geniisysRows[i].recordStatus == 0 || tbgGIISRecoveryStatus.geniisysRows[i].recordStatus == 1){	
					if(mode == "add" && unescapeHTML2(tbgGIISRecoveryStatus.geniisysRows[i].recStatCd) == $F("txtRecStatCd")){
						addedSameExists = true;								
					}	
					if(origRecStatDesc != $F("txtRecStatDesc") && unescapeHTML2(tbgGIISRecoveryStatus.geniisysRows[i].recStatDesc) == $F("txtRecStatDesc")){
						addedSameExists2 = true;								
					}	
					if(origRecStatDesc != $F("txtRecStatDesc") && unescapeHTML2(tbgGIISRecoveryStatus.geniisysRows[i].origRecStatDesc) == $F("txtRecStatDesc")){
						updatedSameExists2 = true;								
					}
				} else if(tbgGIISRecoveryStatus.geniisysRows[i].recordStatus == -1){
					if(mode == "add" && unescapeHTML2(tbgGIISRecoveryStatus.geniisysRows[i].recStatCd) == $F("txtRecStatCd")){
						deletedSameExists = true;
					}
					if(origRecStatDesc != $F("txtRecStatDesc") && unescapeHTML2(tbgGIISRecoveryStatus.geniisysRows[i].recStatDesc) == $F("txtRecStatDesc")){
						deletedSameExists2 = true;								
					}
					if(mode == "add" && (unescapeHTML2(tbgGIISRecoveryStatus.geniisysRows[i].recStatDesc) == $F("txtRecStatDesc"))){
						deletedSameExists3 = true;								
					}	
				}
			}
			if(mode == "add" && (addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
				showMessageBox("Record already exists with the same rec_stat_cd.", "E");
				return;
			}else if((addedSameExists2 && !deletedSameExists2) || (deletedSameExists2 && addedSameExists2)){
				showMessageBox("Record already exists with the same rec_stat_desc.", "E");
				return;
// 			}else if((deletedSameExists || updatedSameExists2) && !addedSameExists && (deletedSameExists2 || updatedSameExists2) && !addedSameExists2){
// 				addRec();
// 				return;
			}else if(mode == "update" && (deletedSameExists2 || updatedSameExists2) && !addedSameExists2){
				addRec();
				return;
			}else if(mode == "add" && (deletedSameExists && !addedSameExists)){
				addRec();
				return;
			}else if(mode == "add" && (deletedSameExists3 && !addedSameExists2)){
				addRec();
				return;
			}
			
			new Ajax.Request(contextPath + "/GIISRecoveryStatusController", {
				parameters : {action : "valAddRec",
							  recStatCd : mode == "add" ? $F("txtRecStatCd") : null,
							  recStatDesc : origRecStatDesc != $F("txtRecStatDesc") ? $F("txtRecStatDesc") : null},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						addRec();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valAddUpdateRec",e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisRecoveryStatusFormDiv")){
				if($F("btnAdd") == "Add") {
					valAddUpdateRec("add");
				} else {
					valAddUpdateRec("update");
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGicls100;
		objCurrGIISRecoveryStatus.recordStatus = -1;
		tbgGIISRecoveryStatus.deleteRow(rowIndex);
		tbgGIISRecoveryStatus.geniisysRows[rowIndex].recStatCd = escapeHTML2($F("txtRecStatCd"));
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISRecoveryStatusController", {
				parameters : {action : "valDeleteRec",
							  recStatCd : $F("txtRecStatCd")},
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
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
	}	
	
	function cancelGicls100(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS100.exitPage = exitPage;
						saveGicls100();
					}, function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtRecStatDesc").observe("keyup", function(){
		$("txtRecStatDesc").value = $F("txtRecStatDesc").toUpperCase();
	});
	
	$("txtRecStatCd").observe("keyup", function(){
		$("txtRecStatCd").value = $F("txtRecStatCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGicls100);
	$("btnCancel").observe("click", cancelGicls100);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("gicls100Exit").stopObserving("click");
	$("gicls100Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtRecStatCd").focus();	
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls060MainDiv" name="gicls060MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="acExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Loss/Expense Settlement Status Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls060" name="gicls060">		
		<div class="sectionDiv">
			<div id="lossExpSettlementTableDiv" style="padding-top: 10px;">
				<div id="lossExpSettlementTable" style="height: 331px; padding-left: 180px;"></div>
			</div>
			<div align="center" id="lossExpSettlementFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtLeStatCd" type="text" class="required" style="width: 200px; text-align: left;" tabindex="201" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Status Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtLeStatDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="30">
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
						<td width="113px" class="rightAligned">Last Update</td>
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
	setModuleId("GICLS060");
	setDocumentTitle("Loss/Expense Settlement Status Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls060(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbglossExpSettlement.geniisysRows);
		var delRows = getDeletedJSONObjects(tbglossExpSettlement.geniisysRows);
		new Ajax.Request(contextPath+"/GICLLossExpSettlementController", {
			method: "POST",
			parameters : {action : "saveGicls060",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS060.exitPage != null) {
							objGICLS060.exitPage();
						} else {
							tbglossExpSettlement._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showLossExpSettlementMaintenance);
	
	var objGICLS060 = {};
	var objCurrLossExpSettlement = null;
	objGICLS060.lossExpSettlementStatus = JSON.parse('${jsonLossExpSettlementStatus}');
	objGICLS060.exitPage = null;
	
	var lossExpSettlementTable = {
			url : contextPath + "/GICLLossExpSettlementController?action=showGICLS060&refresh=1",
			options : {
				width : '600px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrLossExpSettlement = tbglossExpSettlement.geniisysRows[y];
					setFieldValues(objCurrLossExpSettlement);
					tbglossExpSettlement.keys.removeFocus(tbglossExpSettlement.keys._nCurrentFocus, true);
					tbglossExpSettlement.keys.releaseKeys();
					$("txtLeStatDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbglossExpSettlement.keys.removeFocus(tbglossExpSettlement.keys._nCurrentFocus, true);
					tbglossExpSettlement.keys.releaseKeys();
					$("txtLeStatCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbglossExpSettlement.keys.removeFocus(tbglossExpSettlement.keys._nCurrentFocus, true);
						tbglossExpSettlement.keys.releaseKeys();
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
					tbglossExpSettlement.keys.removeFocus(tbglossExpSettlement.keys._nCurrentFocus, true);
					tbglossExpSettlement.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbglossExpSettlement.keys.removeFocus(tbglossExpSettlement.keys._nCurrentFocus, true);
					tbglossExpSettlement.keys.releaseKeys();
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
					tbglossExpSettlement.keys.removeFocus(tbglossExpSettlement.keys._nCurrentFocus, true);
					tbglossExpSettlement.keys.releaseKeys();
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
					id : 'leStatCd',
					title : "Code",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'leStatDesc',
					filterOption : true,
					title : 'Status Description',
					width : '480px'				
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
			rows : objGICLS060.lossExpSettlementStatus.rows
		};

		tbglossExpSettlement = new MyTableGrid(lossExpSettlementTable);
		tbglossExpSettlement.pager = objGICLS060.lossExpSettlementStatus;
		tbglossExpSettlement.render("lossExpSettlementTable");
	
	function setFieldValues(rec){
		try{
			$("txtLeStatCd").value = (rec == null ? "" : unescapeHTML2(rec.leStatCd));
			$("txtLeStatCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.leStatCd)));
			$("txtLeStatDesc").value = (rec == null ? "" : unescapeHTML2(rec.leStatDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtLeStatCd").readOnly = false : $("txtLeStatCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrLossExpSettlement = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.leStatCd = escapeHTML2($F("txtLeStatCd"));
			obj.leStatDesc = escapeHTML2($F("txtLeStatDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGicls060;
			var dept = setRec(objCurrLossExpSettlement);
			if($F("btnAdd") == "Add"){
				tbglossExpSettlement.addBottomRow(dept);
			} else {
				tbglossExpSettlement.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbglossExpSettlement.keys.removeFocus(tbglossExpSettlement.keys._nCurrentFocus, true);
			tbglossExpSettlement.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("lossExpSettlementFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbglossExpSettlement.geniisysRows.length; i++) {
						if (tbglossExpSettlement.geniisysRows[i].recordStatus == 0 || tbglossExpSettlement.geniisysRows[i].recordStatus == 1) {
							if (tbglossExpSettlement.geniisysRows[i].leStatCd == escapeHTML2($F("txtLeStatCd"))) {
								addedSameExists = true;
							}
						} else if (tbglossExpSettlement.geniisysRows[i].recordStatus == -1) {
							if (tbglossExpSettlement.geniisysRows[i].leStatCd == $F("txtLeStatCd") || unescapeHTML2(unescapeHTML2(tbglossExpSettlement.geniisysRows[i].leStatCd)) == $F("txtLeStatCd")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same le_stat_cd.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GICLLossExpSettlementController", {
						parameters : {
							action : "valAddRec",
							leStatCd : $F("txtLeStatCd")
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
		changeTagFunc = saveGicls060;
		objCurrLossExpSettlement.recordStatus = -1;
		objCurrLossExpSettlement.leStatCd = escapeHTML2(objCurrLossExpSettlement.leStatCd);
		tbglossExpSettlement.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GICLLossExpSettlementController", {
				parameters : {
					action : "valDeleteRec",
					leStatCd : $F("txtLeStatCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if(response.responseText == "Y"){
						showMessageBox("Cannot delete record from GICL_LE_STAT while dependent record(s) in GICL_CLM_LOSS_EXP exists.", imgMessage.ERROR);
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
		goToModule("/GIISUserController?action=goToClaims",
				"Claims Main", null);
	}

	function cancelGicls060() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGICLS060.exitPage = exitPage;
						saveGicls060();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToClaims",
								"Claims Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims",
					"Claims Main", null);
		}
	}

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	$("txtLeStatDesc").observe("keyup", function() {
		$("txtLeStatDesc").value = $F("txtLeStatDesc").toUpperCase();
	});

	$("txtLeStatCd").observe("keyup", function() {
		$("txtLeStatCd").value = $F("txtLeStatCd").toUpperCase();
	});

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveGicls060);
	$("btnCancel").observe("click", cancelGicls060);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtLeStatCd").focus();
</script>
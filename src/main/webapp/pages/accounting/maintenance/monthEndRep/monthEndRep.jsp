<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs351Div" name="giacs351Div"></div>
<div id="giacs350MainDiv" name="giacs350MainDiv">
	<div id="giacs350MenuDiv">
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
	   		<label>Month-end Report Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs350" name="giacs350">
		<div class="sectionDiv">
			<div id="giacs350TableDiv" style="padding-top: 10px;">
				<div id="giacs350Table" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giacs350FormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Report Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtGIACS350RepCd" type="text" class="required" style="width: 200px; text-align: left: ;" tabindex="201" maxlength="12">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Report Title</td>
						<td class="leftAligned" colspan="3">
							<input id="txtGIACS350RepTitle" type="text" class="required" style="width: 533px;" tabindex="202" maxlength="200">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="giacs350RemarksDiv" name="giacs350RemarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtGIACS350Remarks" name="txtGIACS350Remarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="203"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="204"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtGIACS350UserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="205"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtGIACS350LastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="207">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="208">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="monthEndReportDetails" value="Month-End Report Details" tabindex="209">
			</div>
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIACS350");
	setDocumentTitle("Month-end Report Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	var objGIACS350 = {};
	var objCurrEomRep = null;
	objGIACS350.eomRepList = JSON.parse('${jsonEomRepList}');
	objGIACS350.exitPage = null;
	
	var eomRepTable = {
			id : 101,
			url : contextPath + "/GIACEomRepController?action=showGiacs350&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrEomRep = tbgEomRep.geniisysRows[y];
					setFieldValues(objCurrEomRep);
					objGiacs351.repCd = (objCurrEomRep.repCd);
					objGiacs351.repTitle = objCurrEomRep.repTitle;
					tbgEomRep.keys.removeFocus(tbgEomRep.keys._nCurrentFocus, true);
					tbgEomRep.keys.releaseKeys();
					$("txtGIACS350RepCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEomRep.keys.removeFocus(tbgEomRep.keys._nCurrentFocus, true);
					tbgEomRep.keys.releaseKeys();
					$("txtGIACS350RepCd").focus();
				},
				onRowDoubleClick: function(y){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = y;
					objCurrEomRep = tbgEomRep.geniisysRows[y];
					setFieldValues(objCurrEomRep);
					objGiacs351.repCd = (objCurrEomRep.repCd);
					objGiacs351.repTitle = objCurrEomRep.repTitle;
					goToGiacs351("GIACS350", unescapeHTML2(objCurrEomRep.repCd));
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgEomRep.keys.removeFocus(tbgEomRep.keys._nCurrentFocus, true);
						tbgEomRep.keys.releaseKeys();
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
					tbgEomRep.keys.removeFocus(tbgEomRep.keys._nCurrentFocus, true);
					tbgEomRep.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEomRep.keys.removeFocus(tbgEomRep.keys._nCurrentFocus, true);
					tbgEomRep.keys.releaseKeys();
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
					tbgEomRep.keys.removeFocus(tbgEomRep.keys._nCurrentFocus, true);
					tbgEomRep.keys.releaseKeys();
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
					id : "repCd",
					title : "Report Code",
					filterOption : true,
					width : '120px'
				},
				{
					id : 'repTitle',
					filterOption : true,
					title : 'Report Title',
					width : '530px'				
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
			rows : objGIACS350.eomRepList.rows
	};
	tbgEomRep = new MyTableGrid(eomRepTable);
	tbgEomRep.pager = objGIACS350.eomRepList;
	tbgEomRep.render("giacs350Table");
	
	function setFieldValues(rec){
		try{
			$("txtGIACS350RepCd").value = (rec == null ? "" : unescapeHTML2(rec.repCd));
			$("txtGIACS350RepTitle").value = (rec == null ? "" : unescapeHTML2(rec.repTitle));
			$("txtGIACS350Remarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtGIACS350UserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtGIACS350LastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtGIACS350RepCd").readOnly = false : $("txtGIACS350RepCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("monthEndReportDetails") : enableButton("monthEndReportDetails");
			
			objCurrEomRep = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function cancelGiacs350(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS350.exitPage = exitPage;
						saveGiacs350();
					}, function(){
						objGiacs351.repCd = null;
						objGiacs351.repTitle = null;
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			objGiacs351.repCd = null;
			objGiacs351.repTitle = null;
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function exitPage(){
		objGiacs351.repCd = null;
		objGiacs351.repTitle = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giacs350FormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgEomRep.geniisysRows.length; i++){
						if(tbgEomRep.geniisysRows[i].recordStatus == 0 || tbgEomRep.geniisysRows[i].recordStatus == 1){								
							if(tbgEomRep.geniisysRows[i].repCd == $F("txtGIACS350RepCd")){
								addedSameExists = true;								
							}							
						} else if(tbgEomRep.geniisysRows[i].recordStatus == -1){
							if(tbgEomRep.geniisysRows[i].repCd == $F("txtGIACS350RepCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same rep_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACEomRepController", {
						parameters : {action : "valAddRec",
									  repCd : $F("txtGIACS350RepCd")
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
			changeTagFunc = saveGiacs350;
			var eomRep = setRec(objCurrEomRep);
			if($F("btnAdd") == "Add"){
				tbgEomRep.addBottomRow(eomRep);
			} else {
				tbgEomRep.updateVisibleRowOnly(eomRep, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgEomRep.keys.removeFocus(tbgEomRep.keys._nCurrentFocus, true);
			tbgEomRep.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.repCd = escapeHTML2($F("txtGIACS350RepCd"));
			obj.repTitle = escapeHTML2($F("txtGIACS350RepTitle"));
			obj.remarks = escapeHTML2($F("txtGIACS350Remarks"));
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
			new Ajax.Request(contextPath + "/GIACEomRepController", {
				parameters : {action : "valDeleteRec",
							  repCd : $F("txtGIACS350RepCd")
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
		changeTagFunc = saveGiacs350;
		objCurrEomRep.recordStatus = -1;
		tbgEomRep.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiacs350(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgEomRep.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgEomRep.geniisysRows);

		new Ajax.Request(contextPath+"/GIACEomRepController", {
			method: "POST",
			parameters : {action : "saveGiacs350",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS350.exitPage != null) {
							objGIACS350.exitPage();
						} else {
							tbgEomRep._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	$("btnCancel").observe("click", cancelGiacs350);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	observeSaveForm("btnSave", saveGiacs350);
	
	$("txtGIACS350RepCd").observe("keyup", function(){
		$("txtGIACS350RepCd").value = $F("txtGIACS350RepCd").toUpperCase();
	});
	
	$("txtGIACS350RepTitle").observe("keyup", function(){
		$("txtGIACS350RepTitle").value = $F("txtGIACS350RepTitle").toUpperCase();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtGIACS350Remarks", 4000, $("txtGIACS350Remarks").hasAttribute("readonly"));
	});
	
	$("monthEndReportDetails").observe("click", function(){
		/* if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS350.exitPage = callGiacs351;
						saveGiacs350();
					}, function(){
						showGiacs350();
					}, "");
		} else {
			callGiacs351();
		} */
		if(changeTag == 1){
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				$("btnSave").focus();
			});
			return false;
		} else {
			callGiacs351();
		}
	});
	
	function callGiacs351(){
		objGIACS350.exitPage = goToGiacs351("GIACS350", unescapeHTML2(objCurrEomRep.repCd));
	}
	
	function goToGiacs351(callFrom, repCd){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS351"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							
						});  
					} else {
						showGiacs351("GIACS350", unescapeHTML2(objCurrEomRep.repCd));
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	observeReloadForm("reloadForm", showGiacs350);
	disableButton("btnDelete");
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		cancelGiacs350();
	});
	
	disableButton("monthEndReportDetails");
	$("txtGIACS350RepCd").focus();
</script>
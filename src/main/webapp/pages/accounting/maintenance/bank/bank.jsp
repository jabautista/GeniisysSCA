<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs307MainDiv" name="giacs307MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Bank Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs307" name="giacs307">		
		<div class="sectionDiv">
			<div id="bankTableDiv" style="padding-top: 10px;">
				<div id="bankTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="bankFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Bank Code</td>
						<td class="leftAligned">
							<input id="txtBankCd" type="text" style="width: 200px; text-align: right;" tabindex="201" maxlength="3" readonly="readonly">
						</td>
						<td class="rightAligned" width="113px">Short Name</td>
						<td class="leftAligned">
							<input id="txtBankSname" type="text" class="required" style="width: 200px;" tabindex="202" maxlength="10">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Bank Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtBankName" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="100">
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
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;">
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
	setModuleId("GIACS307");
	setDocumentTitle("Bank Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs307(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgBank.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBank.geniisysRows);
		new Ajax.Request(contextPath+"/GIACBankController", {
			method: "POST",
			parameters : {action : "saveGiacs307",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS307.exitPage != null) {
							objGIACS307.exitPage();
						} else {
							tbgBank._refreshList();
						}
					});
					changeTag = 0;					
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs307);
	
	var objGIACS307 = {};
	var objCurrBank = null;
	objGIACS307.bankList = JSON.parse('${jsonBankList}');
	objGIACS307.exitPage = null;
	
	var bankTable = {
			url : contextPath + "/GIACBankController?action=showGiacs307&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrBank = tbgBank.geniisysRows[y];
					setFieldValues(objCurrBank);
					tbgBank.keys.removeFocus(tbgBank.keys._nCurrentFocus, true);
					tbgBank.keys.releaseKeys();
					$("txtBankSname").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBank.keys.removeFocus(tbgBank.keys._nCurrentFocus, true);
					tbgBank.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgBank.keys.removeFocus(tbgBank.keys._nCurrentFocus, true);
						tbgBank.keys.releaseKeys();
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
					tbgBank.keys.removeFocus(tbgBank.keys._nCurrentFocus, true);
					tbgBank.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBank.keys.removeFocus(tbgBank.keys._nCurrentFocus, true);
					tbgBank.keys.releaseKeys();
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
					tbgBank.keys.removeFocus(tbgBank.keys._nCurrentFocus, true);
					tbgBank.keys.releaseKeys();
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
					id : "bankCd",
					title : "Bank Code",
					titleAlign : 'right',
					align : 'right',
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					width : '80px'
				},
				{
					id : 'bankSname',
					filterOption : true,
					title : 'Short Name',
					width : '100px'				
				},
				{
					id : 'bankName',
					filterOption : true,
					title : 'Bank Name',
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
			rows : objGIACS307.bankList.rows
		};

		tbgBank = new MyTableGrid(bankTable);
		tbgBank.pager = objGIACS307.bankList;
		tbgBank.render("bankTable");
	
	function setFieldValues(rec){
		try{
			$("txtBankCd").value = (rec == null ? "" : rec.bankCd);
			$("txtBankCd").setAttribute("lastValidValue", (rec == null ? "" : rec.bankCd));
			$("txtBankName").value = (rec == null ? "" : unescapeHTML2(rec.bankName));
			$("txtBankSname").value = (rec == null ? "" : unescapeHTML2(rec.bankSname));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrBank = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.bankCd = $F("txtBankCd");
			obj.bankName = escapeHTML2($F("txtBankName"));
			obj.bankSname = escapeHTML2($F("txtBankSname"));
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
			changeTagFunc = saveGiacs307;
			var dept = setRec(objCurrBank);
			if($F("btnAdd") == "Add"){
				tbgBank.addBottomRow(dept);
			} else {
				tbgBank.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgBank.keys.removeFocus(tbgBank.keys._nCurrentFocus, true);
			tbgBank.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("bankFormDiv")){
				addRec();
// 				if($F("btnAdd") == "Add") {
// 					new Ajax.Request(contextPath + "/GIACBankController", {
// 						parameters : {action : "valAddRec",
// 									  bankCd : $F("txtBankCd")},
// 						onCreate : showNotice("Processing, please wait..."),
// 						onComplete : function(response){
// 							hideNotice();
// 							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
// 								addRec();
// 							}
// 						}
// 					});
// 				} else {
// 					addRec();
// 				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiacs307;
		objCurrBank.recordStatus = -1;
		tbgBank.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACBankController", {
				parameters : {action : "valDeleteRec",
							  bankCd : $F("txtBankCd")},
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
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	function cancelGiacs307(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS307.exitPage = exitPage;
						saveGiacs307();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtBankSname").observe("keyup", function(){
		$("txtBankSname").value = $F("txtBankSname").toUpperCase();
	});
	
	$("txtBankName").observe("keyup", function(){
		$("txtBankName").value = $F("txtBankName").toUpperCase();
	});
	
	disableButton("btnDelete");	
	observeSaveForm("btnSave", saveGiacs307);
	$("btnCancel").observe("click", cancelGiacs307);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtBankSname").focus();	
</script>
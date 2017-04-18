<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs340MainDiv" name="giacs340MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="acExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>General Ledger Control Account Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs340" name="giacs340">		
		<div class="sectionDiv">
			<div id="glAcctTypesDiv" style="padding-top: 10px;">
				<div id="glAccountTypesTable" style="height: 340px; margin-left: 80px;"></div>
			</div>
			<div align="" id="glAcctTypesFormDiv" style="margin-left: 80px;">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Ledger Code</td>
						<td class="leftAligned">
							<input id="txtLedgerCd" type="text" class="required" origValue="" style="width: 200px; text-align: left;" tabindex="201" maxlength="10">
						</td>
						<td class="rightAligned" width="160px">Active Tag</td>
						<td class="leftAligned">
							<select id="selActiveTag" style="width: 207px; height: 24px;" class="required" tabindex="202">
								<c:forEach var="activeTag" items="${activeTagLOV}">
									<option value="${activeTag.rvLowValue}">${activeTag.rvMeaning}</option>
								</c:forEach>
							</select>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Ledger Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtLedgerDesc" type="text" class="required" style="width: 580px;" tabindex="203" maxlength="50">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 586px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 560px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="160px;" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" style="width: 85px;" tabindex="208">
				<input type="button" class="button" id="btnDelete" value="Delete" style="width: 85px;" tabindex="209">
				<input type="button" class="button" id="btnViewSubAccount" value="View Details" style="width: 100px;" tabindex="210">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 85px;" tabindex="301">
	<input type="button" class="button" id="btnSave" value="Save" style="width: 85px;" tabindex="302">
</div>
<div id="giacs341MainDiv" name="giacs341MainDiv" style=""></div>
<script type="text/javascript">	
	setModuleId("GIACS340");
	setDocumentTitle("General Ledger Control Account Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var btnVal = null;
	var origLedgerCd = null;
	
	function saveGiacs340(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGlAccountTypes.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGlAccountTypes.geniisysRows);
		new Ajax.Request(contextPath+"/GIACGlAccountTypesController", {
			method: "POST",
			parameters : {action : "saveGiacs340",
					origLedgerCd : origLedgerCd,
				          btnVal : btnVal,
				     	 setRows : prepareJsonAsParameter(setRows),
					 	 delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS340.exitPage != null) {
							objGIACS340.exitPage();
						} else {
							tbgGlAccountTypes._refreshList();
						}
					});
					changeTag = 0;
					origLedgerCd = null;
				}
			}
		});
	}
	
	function checkGiacUserAccess(){
		var isAccessible = false;
		new Ajax.Request(contextPath+"/GIISUserController",{
			parameters: {
				action : "checkUserAccessGiacs",
				moduleId : "GIACS341"
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response) {				
				if(response.responseText == "1"){
					isAccessible = true;
				}
			}
		});
		
		return isAccessible;
	}	
	
	function checkGlAcctTypeChanges(ledgerCd, ledgerDesc) {
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						exitPage = function(){
							if (checkGiacUserAccess()){
								showGiacs341(ledgerCd, ledgerDesc);
							}else{
								showWaitingMessageBox("You do not have access to General Ledger Control Sub-Account Types module.", "E", function() {
									tbgGlAccountTypes.unselectRows();
									setFieldValues(null);
								});
								return false;
							}
						};
						saveGiacs340();
					}, 
					function(){
						if (checkGiacUserAccess()){
							showGiacs341(ledgerCd, ledgerDesc);
						}else{
							showWaitingMessageBox("You do not have access to General Ledger Control Sub-Account Types module.", "E", function() {
								tbgGlAccountTypes.unselectRows();
								setFieldValues(null);
							});
							return false;
						}
						changeTag = 0;
					}, "");
		}else{
			changeTag = 0;
			if (checkGiacUserAccess()){
				showGiacs341(ledgerCd, ledgerDesc);
			}else{
				showWaitingMessageBox("You are not allowed to access this module.", "E", function() {
					tbgGlAccountTypes.unselectRows();
					setFieldValues(null);
				});
				return false;
			}
		}
	}
	
	observeReloadForm("reloadForm", showGiacs340);
	
	var objGIACS340 = {};
	var objCurrGlAcctTypes = null;
	objGIACS340.glAccountTypesList = JSON.parse('${jsonGlAccountTypes}');
	objGIACS340.exitPage = null;
	
	var glAccountTypesTable = {
			url : contextPath + "/GIACGlAccountTypesController?action=showGiacs340&refresh=1",
			options : {
				width : '750px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGlAcctTypes = tbgGlAccountTypes.geniisysRows[y];
					setFieldValues(objCurrGlAcctTypes);
					tbgGlAccountTypes.keys.removeFocus(tbgGlAccountTypes.keys._nCurrentFocus, true);
					tbgGlAccountTypes.keys.releaseKeys();
					$("txtLedgerDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGlAccountTypes.keys.removeFocus(tbgGlAccountTypes.keys._nCurrentFocus, true);
					tbgGlAccountTypes.keys.releaseKeys();
					$("txtLedgerCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGlAccountTypes.keys.removeFocus(tbgGlAccountTypes.keys._nCurrentFocus, true);
						tbgGlAccountTypes.keys.releaseKeys();
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
					tbgGlAccountTypes.keys.removeFocus(tbgGlAccountTypes.keys._nCurrentFocus, true);
					tbgGlAccountTypes.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGlAccountTypes.keys.removeFocus(tbgGlAccountTypes.keys._nCurrentFocus, true);
					tbgGlAccountTypes.keys.releaseKeys();
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
					tbgGlAccountTypes.keys.removeFocus(tbgGlAccountTypes.keys._nCurrentFocus, true);
					tbgGlAccountTypes.keys.releaseKeys();
				},
				onRowDoubleClick: function(y){
					tbgGlAccountTypes.keys.releaseKeys();
					observeChangeTagInTableGrid(tbgGlAccountTypes);
					var row = tbgGlAccountTypes.geniisysRows[y];
					checkGlAcctTypeChanges(row.ledgerCd, row.ledgerDesc);
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
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "ledgerCd",
					title : "Ledger Code",
					filterOption : true,
					width : '130px'
				},
				{
					id : 'ledgerDesc',
					filterOption : true,
					title : 'Ledger Description',
					width : '310px'				
				},	
				{
					id : "dspActiveTag",
					title : "Active",
					filterOption : true,
					width : '70px'
				},
				{
					id : 'remarks',
					title : "Remarks",
					width : '200',
					filterOption : false,
					sortable : false
				},
				{
					id : 'activeTag',
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
			rows : objGIACS340.glAccountTypesList.rows
		};

		tbgGlAccountTypes = new MyTableGrid(glAccountTypesTable);
		tbgGlAccountTypes.pager = objGIACS340.glAccountTypesList;
		tbgGlAccountTypes.render("glAccountTypesTable");
	
	function setFieldValues(rec){
		try{
			$("txtLedgerCd").value 		= (rec == null ? "" : unescapeHTML2(rec.ledgerCd));
			$("txtLedgerDesc").value 	= (rec == null ? "" : unescapeHTML2(rec.ledgerDesc));
			$("selActiveTag").value 	= (rec == null ? "Y": rec.activeTag);
			$("txtRemarks").value 		= (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value 		= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 	= (rec == null ? "" : rec.lastUpdate);
			
			$("txtLedgerCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.ledgerCd)));
			$("txtLedgerCd").setAttribute("origValue", (rec == null ? "" : unescapeHTML2(rec.ledgerCd)));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnViewSubAccount") : enableButton("btnViewSubAccount");
			objCurrGlAcctTypes = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.ledgerCd 	 = escapeHTML2($F("txtLedgerCd"));
			obj.ledgerDesc 	 = escapeHTML2($F("txtLedgerDesc"));
			obj.activeTag 	 = $F("selActiveTag");
			obj.dspActiveTag = $("selActiveTag").options[$("selActiveTag").selectedIndex].text;
			obj.remarks 	 = escapeHTML2($F("txtRemarks"));
			obj.userId 		 = userId;
			var lastUpdate 	 = new Date();
			obj.lastUpdate 	 = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs340;
			var rec = setRec(objCurrGlAcctTypes);
			if($F("btnAdd") == "Add"){
				tbgGlAccountTypes.addBottomRow(rec);
				btnVal = "Add";
			} else {
				tbgGlAccountTypes.updateVisibleRowOnly(rec, rowIndex, false);
				btnVal = "Update";
			}
			changeTag = 1;
			origLedgerCd = $("txtLedgerCd").getAttribute("origValue");
			setFieldValues(null);
			tbgGlAccountTypes.keys.removeFocus(tbgGlAccountTypes.keys._nCurrentFocus, true);
			tbgGlAccountTypes.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valGlSubAcctRec() {
		var isRecValid = true;
		new Ajax.Request(contextPath + "/GIACGlAccountTypesController", {
			parameters : {action : "valAddGlAcctType",
						  btnVal : "Update",
					origLedgerCd : $("txtLedgerCd").getAttribute("origValue")
			},
		    asynchronous: false,		
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if (response.responseText.include("Geniisys Exception")){
						var message = response.responseText.split("#"); 
						showMessageBox(message[2], message[1]);
						isRecValid =  false;
					} 
				}
			}
		});	
		return isRecValid;
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("glAcctTypesFormDiv")){
				var addedSameExists = false;
				var deletedSameExists = false;			
				if($F("btnAdd") == "Add") {
					for(var i=0; i<tbgGlAccountTypes.geniisysRows.length; i++){
						if(tbgGlAccountTypes.geniisysRows[i].recordStatus == 0 || tbgGlAccountTypes.geniisysRows[i].recordStatus == 1){								
							if(tbgGlAccountTypes.geniisysRows[i].ledgerCd == $F("txtLedgerCd")){
								addedSameExists = true;		
							}							
						} else if(tbgGlAccountTypes.geniisysRows[i].recordStatus == -1){
							if(tbgGlAccountTypes.geniisysRows[i].ledgerCd == $F("txtLedgerCd")){
								deletedSameExists = true;
							}
						}
					}

					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox($F("txtLedgerCd")+" already exists.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACGlAccountTypesController", {
						parameters : {action : "valAddGlAcctType",
									  btnVal : "Add",
								origLedgerCd : $F("txtLedgerCd")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					/*--check child records--*/
					if (!valGlSubAcctRec()) return false;
					
					/*--check records in tabledgrid*/
					for(var i=0; i<tbgGlAccountTypes.geniisysRows.length; i++){
						if(tbgGlAccountTypes.geniisysRows[i].recordStatus == 0 || tbgGlAccountTypes.geniisysRows[i].recordStatus == 1){								
							if(tbgGlAccountTypes.geniisysRows[i].ledgerCd == $F("txtLedgerCd")){
								if ($F("txtLedgerCd") != $("txtLedgerCd").getAttribute("origValue")) {
									addedSameExists = true;
								}
							}							
						} else if(tbgGlAccountTypes.geniisysRows[i].recordStatus == -1){
							if(tbgGlAccountTypes.geniisysRows[i].ledgerCd == $F("txtLedgerCd")){
								deletedSameExists = true;
							}
						}
					}

					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox($F("txtLedgerCd")+" already exists.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					} else if(!deletedSameExists && !addedSameExists){
						if ($F("txtLedgerCd") != $("txtLedgerCd").getAttribute("origValue")) {
							new Ajax.Request(contextPath + "/GIACGlAccountTypesController", {
								parameters : {action : "valUpdGlAcctType",
										currLedgerCd : $F("txtLedgerCd")},
								onCreate : showNotice("Processing, please wait..."),
								onComplete : function(response){
									hideNotice();
									if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
										addRec();
									}
								}
							});
						}else {
							addRec();
						}
					}
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiacs340;
		objCurrGlAcctTypes.recordStatus = -1;
		tbgGlAccountTypes.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACGlAccountTypesController", {
				parameters : {action : "valDelGlAcctType",
							  ledgerCd : $F("txtLedgerCd")},
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
	
	function cancelGiacs340(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS340.exitPage = exitPage;
						saveGiacs340();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	$("txtLedgerCd").observe("keyup", function(){
		$("txtLedgerCd").value = $F("txtLedgerCd").toUpperCase();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	disableButton("btnDelete");
	disableButton("btnViewSubAccount");
	$("selActiveTag").value = "Y";
	
	observeSaveForm("btnSave", saveGiacs340);
	$("btnCancel").observe("click", cancelGiacs340);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnViewSubAccount").observe("click", function() {
		checkGlAcctTypeChanges($F("txtLedgerCd"),$F("txtLedgerDesc"));
	});

	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtLedgerCd").focus();	
</script>
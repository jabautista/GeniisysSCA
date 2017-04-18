<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="glTransactionTypesMainDiv" name="glTransactionTypesMainDiv" style="height: 410px;">
	<div id="glTransactionTypes" name="glTransactionTypes" style="height: 410px;">		
		<div class="sectionDiv" style="padding-top: 10px; width: 720px">
			<div id="glTransactionTypesDiv" style="padding-top: 10px; width: 720px">
				<div id="glTransactionTypesTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="" id="glTransactionTypesFormDiv" style="margin-left: 10px;">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned" style="width: 100px; padding-right: 5px;">Transaction Code</td>
						<td class="leftAligned">
							<input id="txtTransactionCd" type="text" class="required" origValue="" style="width: 200px; text-align: left;" tabindex="501" maxlength="10"/>
						</td>
						<td class="rightAligned" width="150px"  style="padding-right: 5px;">Active Tag</td>
						<td class="leftAligned">
							<select id="selActiveTag" style="width: 208px; height: 24px;" class="required" tabindex="502">
								<c:forEach var="activeTag" items="${activeTagLOV}">
									<option value="${activeTag.rvLowValue}">${activeTag.rvMeaning}</option>
								</c:forEach>
							</select>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned"  style="width: 100px; padding-right: 5px;">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtTransactionDesc" type="text" class="required" style="width: 567px;" maxlength="100" tabindex="503"/>
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned"  style="width: 100px; padding-right: 5px;">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 573px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 545px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="504"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="505"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned"  style="width: 100px; padding-right: 5px;">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="506"></td>
						<td width="150px;" class="rightAligned"  style="padding-right: 5px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="507"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" style="width: 85px;" tabindex="508">
				<input type="button" class="button" id="btnDelete" value="Delete" style="width: 85px;" tabindex="509">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv" style="width: 720px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 85px;" tabindex="601">
	<input type="button" class="button" id="btnSave" value="Save" style="width: 85px;" tabindex="602">
</div>
<script type="text/javascript">	
	initializeAccordion();
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	var btnVal = null;
	var origTransactionCd = null;
	var parentLedgerCd = '${ledgerCd}';
	var parentSubLedgerCd = '${subLedgerCd}';
	
	function saveGlTransactionType(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGlTransactionTypes.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGlTransactionTypes.geniisysRows);
		new Ajax.Request(contextPath+"/GIACGlSubAccountTypesController", {
			method: "POST",
			parameters : {action : "saveGlTransactionType",
			   origTransactionCd : origTransactionCd,
				          btnVal : btnVal,
				     	 setRows : prepareJsonAsParameter(setRows),
					 	 delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGlTransactionTypes.exitPage != null) {
							objGlTransactionTypes.exitPage();
						} else {
							tbgGlTransactionTypes._refreshList();
						}
					});
					changeTag = 0;
					origTransactionCd = null;
				}
			}
		});
	}
	
	var objGlTransactionTypes = {};
	var objCurrGlTransactionTypes = null;
	objGlTransactionTypes.glTransactionTypesList = JSON.parse('${jsonGlTransactionTypes}');
	objGlTransactionTypes.exitPage = null;
	
	var glTransactionTypesTable = {
			url : contextPath + "/GIACGlSubAccountTypesController?action=showTransactionTypes&refresh=1&ledgerCd="+unescapeHTML2(parentLedgerCd)+"&subLedgerCd="+unescapeHTML2(parentSubLedgerCd),
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGlTransactionTypes = tbgGlTransactionTypes.geniisysRows[y];
					setFieldValues(objCurrGlTransactionTypes);
					tbgGlTransactionTypes.keys.removeFocus(tbgGlTransactionTypes.keys._nCurrentFocus, true);
					tbgGlTransactionTypes.keys.releaseKeys();
					$("txtTransactionDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGlTransactionTypes.keys.removeFocus(tbgGlTransactionTypes.keys._nCurrentFocus, true);
					tbgGlTransactionTypes.keys.releaseKeys();
					$("txtTransactionCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGlTransactionTypes.keys.removeFocus(tbgGlTransactionTypes.keys._nCurrentFocus, true);
						tbgGlTransactionTypes.keys.releaseKeys();
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
					tbgGlTransactionTypes.keys.removeFocus(tbgGlTransactionTypes.keys._nCurrentFocus, true);
					tbgGlTransactionTypes.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGlTransactionTypes.keys.removeFocus(tbgGlTransactionTypes.keys._nCurrentFocus, true);
					tbgGlTransactionTypes.keys.releaseKeys();
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
					tbgGlTransactionTypes.keys.removeFocus(tbgGlTransactionTypes.keys._nCurrentFocus, true);
					tbgGlTransactionTypes.keys.releaseKeys();
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
					id : "transactionCd",
					title : "Transaction Code",
					filterOption : true,
					width : '170px'
				},
				{
					id : 'transactionDesc',
					filterOption : true,
					title : 'Description',
					width : '400px'				
				},	
				{
					id : "dspActiveTag",
					title : "Active",
					filterOption : true,
					width : '90px'
				},
				{
					id : 'remarks',
					width : '0',
					visible: false
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
			rows : objGlTransactionTypes.glTransactionTypesList.rows
		};

		tbgGlTransactionTypes = new MyTableGrid(glTransactionTypesTable);
		tbgGlTransactionTypes.pager = objGlTransactionTypes.glTransactionTypesList;
		tbgGlTransactionTypes.render("glTransactionTypesTable");
	
	function setFieldValues(rec){
		try{
			$("txtTransactionCd").value 	= (rec == null ? "" : unescapeHTML2(rec.transactionCd));
			$("txtTransactionDesc").value 	= (rec == null ? "" : unescapeHTML2(rec.transactionDesc));
			$("selActiveTag").value 		= (rec == null ? "Y": rec.activeTag);
			$("txtRemarks").value 			= (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value 			= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 		= (rec == null ? "" : rec.lastUpdate);
			
			$("txtTransactionCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.transactionCd)));
			$("txtTransactionCd").setAttribute("origValue", (rec == null ? "" : unescapeHTML2(rec.transactionCd)));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrGlTransactionTypes = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.ledgerCd			= parentLedgerCd;
			obj.subLedgerCd			= parentSubLedgerCd;
			obj.transactionCd 	 	= escapeHTML2($F("txtTransactionCd"));
			obj.transactionDesc 	= escapeHTML2($F("txtTransactionDesc"));
			obj.activeTag 	 		= $F("selActiveTag");
			obj.dspActiveTag 		= $("selActiveTag").options[$("selActiveTag").selectedIndex].text;
			obj.remarks 	 		= escapeHTML2($F("txtRemarks"));
			obj.userId 		 		= userId;
			var lastUpdate 	 		= new Date();
			obj.lastUpdate 	 		= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGlTransactionType;
			var rec = setRec(objCurrGlTransactionTypes);
			if($F("btnAdd") == "Add"){
				tbgGlTransactionTypes.addBottomRow(rec);
				btnVal = "Add";
			} else {
				tbgGlTransactionTypes.updateVisibleRowOnly(rec, rowIndex, false);
				btnVal = "Update";
			}
			changeTag = 1;
			origTransactionCd = $("txtTransactionCd").getAttribute("origValue");
			setFieldValues(null);
			tbgGlTransactionTypes.keys.removeFocus(tbgGlTransactionTypes.keys._nCurrentFocus, true);
			tbgGlTransactionTypes.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		

	function valGlAcctRefNo() {
		var isRecValid = true;
		new Ajax.Request(contextPath + "/GIACGlSubAccountTypesController", {
			parameters : {action : "valAddGlTransactionType",
						  btnVal : "Update",
					    ledgerCd : parentLedgerCd,
					 subLedgerCd : parentSubLedgerCd,
				   transactionCd : $("txtTransactionCd").getAttribute("origValue")
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
			if(checkAllRequiredFieldsInDiv("glTransactionTypesFormDiv")){
				var addedSameExists = false;
				var deletedSameExists = false;	
				
				if($F("btnAdd") == "Add") {
					for(var i=0; i<tbgGlTransactionTypes.geniisysRows.length; i++){
						if(tbgGlTransactionTypes.geniisysRows[i].recordStatus == 0 || tbgGlTransactionTypes.geniisysRows[i].recordStatus == 1){								
							if(tbgGlTransactionTypes.geniisysRows[i].transactionCd == $F("txtTransactionCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGlTransactionTypes.geniisysRows[i].recordStatus == -1){
							if(tbgGlTransactionTypes.geniisysRows[i].transactionCd == $F("txtTransactionCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox($F("txtTransactionCd") + " already exists.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACGlSubAccountTypesController", {
						parameters : {action : "valAddGlTransactionType",
							          btnVal : "Add", 
								  ledgerCd   : parentLedgerCd,
							     subLedgerCd : parentSubLedgerCd,
						 	   transactionCd : $F("txtTransactionCd")
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
					/*--check child records--*/
					if (!valGlAcctRefNo()) return false;
					
					/*--check records in tabledgrid*/
					for(var i=0; i<tbgGlTransactionTypes.geniisysRows.length; i++){
						if(tbgGlTransactionTypes.geniisysRows[i].recordStatus == 0 || tbgGlTransactionTypes.geniisysRows[i].recordStatus == 1){								
							if(tbgGlTransactionTypes.geniisysRows[i].transactionCd == $F("txtTransactionCd")){
								if ($F("txtTransactionCd") != $("txtTransactionCd").getAttribute("origValue")) {
									addedSameExists = true;
								}
							}							
						} else if(tbgGlTransactionTypes.geniisysRows[i].recordStatus == -1){
							if(tbgGlTransactionTypes.geniisysRows[i].subLedgerCd == $F("txtTransactionCd")){
								deletedSameExists = true;
							}
						}
					}

					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox($F("txtTransactionCd")+" already exists.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					} else if(!deletedSameExists && !addedSameExists){
						if ($F("txtTransactionCd") != $("txtTransactionCd").getAttribute("origValue")) {
							new Ajax.Request(contextPath + "/GIACGlSubAccountTypesController", {
								parameters : {action : "valUpdGlTransactionType",
											ledgerCd : parentLedgerCd,
									     subLedgerCd : parentSubLedgerCd,
									newTransactionCd : $("txtTransactionCd")
								},
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
		changeTagFunc = saveGlTransactionType;
		objCurrGlTransactionTypes.recordStatus = -1;
		tbgGlTransactionTypes.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACGlSubAccountTypesController", {
				parameters : {action : "valDelGlTransactionType",
					      ledgerCd   : parentLedgerCd,
					     subLedgerCd : parentSubLedgerCd,
					   transactionCd : $F("txtTransactionCd")},
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
		overlayGlTranTypes.close();
	}	
	
	function cancelGlTransactionType(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGlTransactionTypes.exitPage = exitPage;
						saveGlTransactionType();
					}, function(){
						changeTag = 0;
						overlayGlTranTypes.close();
					}, "");
		} else {
			overlayGlTranTypes.close();
		}
	}
	
	$("txtTransactionCd").observe("keyup", function(){
		$("txtTransactionCd").value = $F("txtTransactionCd").toUpperCase();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	disableButton("btnDelete");
	$("selActiveTag").value = "Y";
	
	observeSaveForm("btnSave", saveGlTransactionType);
	$("btnCancel").observe("click", cancelGlTransactionType);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("txtTransactionCd").focus();	
</script>
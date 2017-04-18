<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls140MainDiv" name="gicls140MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Payee Class Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls140" name="gicls140">		
		<div class="sectionDiv">
			<div id="payeeClassDiv" style="padding-top: 10px;">
				<div id="payeeClassTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="" id="payeeClassFormDiv" style="margin-left: 30px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Payee Class Code</td>
						<td class="leftAligned">
							<input id="txtPayeeClassCd" type="text" class="required integerNoNegativeUnformattedNoComma rightAligned" style="width: 200px;" tabindex="201" maxlength="2">
						</td>
						<td class="rightAligned" width="113px">Payee Class Tag</td>
						<td class="leftAligned" colspan="">
							<select id="selPcTag" style="width: 207px; height: 24px;" class="required upper" tabindex="202">
								<option value=""></option>
								<c:forEach var="pcTag" items="${payeeClassTag}">
									<option value="${pcTag.rvLowValue}">${(pcTag.rvMeaning)}</option>
								</c:forEach>
							</select>
						</td>						
					</tr>	
					<tr>
						<td width="190px;" class="rightAligned">Payee Class Description</td>
						<td class="leftAligned" colspan="5">
							<input id="txtClassDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="30">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">SL Code</td>
						<td class="leftAligned" colspan="2">
							<input id="txtSlTypeCd" type="text" class="rightAligned" style="width: 200px;" tabindex="204" maxlength="2" readonly="readonly">
						</td>	
						<td>	
							<input id="chkSlTypeTag" type="checkbox" style="float: left; margin: 0 3px 5px 5px;" tabindex="205">
							<label for="chkSlTypeTag" style="margin: 0 3px 5px 2px;">SL Tag</label>
						</td>	
					</tr>
					<tr>
						<td class="rightAligned">Master Payee Class Code</td>
						<td class="leftAligned" colspan="2">
							<input id="txtMasterPayeeClassCd" type="text" class="" style="width: 200px; text-align: left;" tabindex="206" maxlength="2">
						</td>
						<td colspan="">	
							<input id="chkEvalSw" type="checkbox" style="float: left; margin: 0 3px 5px 5px;" tabindex="207">
							<label for="chkEvalSw" style="margin: 0 3px 5px 2px;">MC Evaluation Tag</label>
						</td>				
					</tr>	
					<tr>
						<td class="rightAligned">VAT Code</td>
						<td class="leftAligned" colspan="2">
							<input id="txtClmVatCd" type="text" class="rightAligned integerNoNegativeUnformattedNoComma" style="width: 200px;" tabindex="208" maxlength="5">
						</td>
						<td colspan=""> 	
							<input id="chkLoaSw" type="checkbox" style="float: left; margin: 0 3px 5px 5px;" tabindex="209">
							<label for="chkLoaSw" style="margin: 0 3px 5px 2px;">Payee Class for LOA Generation</label>
						</td>				
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="5">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="210"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="211"></td>
						<td width="110px;" class="rightAligned">Last Update</td>
						<td class="leftAligned" colspan="2"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="212"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="213">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="214">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnClaimPayee" value="Claim Payee Maintenance" style="width: 190px;" tabindex="215">
			</div>	
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="216">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="217">
	</div>
</div>
<div id="claimPayeeDiv">
</div>
<script type="text/javascript">	
	setModuleId("GICLS140");
	setDocumentTitle("Payee Class Maintenance");
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls140(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgPayeeClass.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgPayeeClass.geniisysRows);
		new Ajax.Request(contextPath+"/GIISPayeeClassController", {
			method: "POST",
			parameters : {action : "saveGicls140",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS140.exitPage != null && objGICLS140.exitPage != 1) {
							objGICLS140.exitPage();
						}else if (objGICLS140.exitPage == 1) {
							objCLMGlobal.callingForm = "GICLS140";
							showMenuClaimPayeeClass(tbgPayeeClass.geniisysRows[rowIndex].payeeClassCd, tbgPayeeClass.geniisysRows[rowIndex].classDesc);	
						} else {
							tbgPayeeClass._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGICLS140);
	
	var objGICLS140 = {};
	var objCurrPayeeClass = null;
	objGICLS140.payeeClassList = JSON.parse('${jsonPayeeClassList}');
	objGICLS140.exitPage = null;
	
	var payeeClassTable = {
			url : contextPath + "/GIISPayeeClassController?action=showGicls140&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrPayeeClass = tbgPayeeClass.geniisysRows[y];
					setFieldValues(objCurrPayeeClass);
					tbgPayeeClass.keys.removeFocus(tbgPayeeClass.keys._nCurrentFocus, true);
					tbgPayeeClass.keys.releaseKeys();
					$("txtClassDesc").focus();
					$("selPcTag").disabled = true;
					if (tbgPayeeClass.geniisysRows[y].slTypeTag == "Y") {
						$("chkSlTypeTag").disabled = true;
					}else {
						$("chkSlTypeTag").disabled = false;
					}
// 					observeAccessibleModule(accessType.BUTTON, "GICLS150", "btnClaimPayee", "");
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPayeeClass.keys.removeFocus(tbgPayeeClass.keys._nCurrentFocus, true);
					tbgPayeeClass.keys.releaseKeys();
					$("txtPayeeClassCd").focus();
					$("selPcTag").disabled = false;
					$("chkSlTypeTag").disabled = false;
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgPayeeClass.keys.removeFocus(tbgPayeeClass.keys._nCurrentFocus, true);
						tbgPayeeClass.keys.releaseKeys();
						$("selPcTag").disabled = false;
						$("chkSlTypeTag").disabled = false;
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
					tbgPayeeClass.keys.removeFocus(tbgPayeeClass.keys._nCurrentFocus, true);
					tbgPayeeClass.keys.releaseKeys();
					$("selPcTag").disabled = false;
					$("chkSlTypeTag").disabled = false;
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPayeeClass.keys.removeFocus(tbgPayeeClass.keys._nCurrentFocus, true);
					tbgPayeeClass.keys.releaseKeys();
					$("selPcTag").disabled = false;
					$("chkSlTypeTag").disabled = false;
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
					tbgPayeeClass.keys.removeFocus(tbgPayeeClass.keys._nCurrentFocus, true);
					tbgPayeeClass.keys.releaseKeys();
					$("selPcTag").disabled = false;
					$("chkSlTypeTag").disabled = false;
				},
				onRowDoubleClick: function(y){
					rowIndex = y;
					if (changeTag == 1) {
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									objGICLS140.exitPage = 1;
									saveGicls140();
								}, function(){
// 									observeAccessibleModule(accessType.NONE, "GICLS150", "", function(){
// 										objCLMGlobal.callingForm = "GICLS140";
// 										showMenuClaimPayeeClass(tbgPayeeClass.geniisysRows[y].payeeClassCd, tbgPayeeClass.geniisysRows[y].classDesc);
// 									});
									goToGicls150(tbgPayeeClass.geniisysRows[y].payeeClassCd, tbgPayeeClass.geniisysRows[y].classDesc);
								}, "");
					}else {
// 						observeAccessibleModule(accessType.NONE, "GICLS150", "", function(){
// 							objCLMGlobal.callingForm = "GICLS140";
// 							showMenuClaimPayeeClass(tbgPayeeClass.geniisysRows[y].payeeClassCd, tbgPayeeClass.geniisysRows[y].classDesc);
// 						});
						goToGicls150(tbgPayeeClass.geniisysRows[y].payeeClassCd, tbgPayeeClass.geniisysRows[y].classDesc);
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
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{	id: 'evalSw',
					title: "&nbsp;&nbsp;&nbsp;E",
					titleAlign: 'center',
					align: 'center',
					altTitle: 'MC Evaluation Tag',
					filterOption : true,
					filterOptionType : 'checkbox',
					width: '30px',
					visible: true,
					editable: false,
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
				{	id: 'loaSw',
					title: "&nbsp;&nbsp;&nbsp;L",
					titleAlign: 'center',
					align: 'center',
					altTitle: 'Payee Class for LOA Generation',
					filterOption : true,
					filterOptionType : 'checkbox',
					width: '30px',
					visible: true,
					editable: false,
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
					id : "payeeClassCd",
					title : "Code",
					titleAlign: 'right',
					align: 'right',
					filterOption : true,
					width : '90px'
				},
				{
					id : 'classDesc',
					filterOption : true,
					title : 'Payee Class Description',
					width : '250px'				
				},
				{
					id : 'payeeClassTag',
					width : '0',
					visible: false				
				},
				{
					id : "dspPcTagDesc",
					title : "PC Tag",
					filterOption : true,
					width : '120px'
				},
				{
					id : "masterPayeeClassCd",
					title : "Master PC",
					filterOption : true,
					width : '100px'
				},
				{	id: 'slTypeTag',
					title: "Tag",
					titleAlign: 'center',
					align: 'center',
					altTitle: 'SL Tag',
					filterOption : true,
					filterOptionType : 'checkbox',
					width: '30px',
					visible: true,
					editable: false,
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
					id : "slTypeCd",
					title : "SL Code",
					filterOption : true,
					titleAlign: 'right',
					filterOptionType : 'integerNoNegative',
					align: 'right',
					width : '100px'
				},
				{
					id : "clmVatCd",
					title : "VAT Code",
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					titleAlign: 'right',
					align: 'right',
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
			rows : objGICLS140.payeeClassList.rows
		};

		tbgPayeeClass = new MyTableGrid(payeeClassTable);
		tbgPayeeClass.pager = objGICLS140.payeeClassList;
		tbgPayeeClass.render("payeeClassTable");
	
	function setFieldValues(rec){
		try{
			$("txtPayeeClassCd").value	 	 = (rec == null ? "" : unescapeHTML2(rec.payeeClassCd));
			$("txtPayeeClassCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.payeeClassCd)));
			$("txtClassDesc").value 		 = (rec == null ? "" : unescapeHTML2(rec.classDesc));
			$("chkEvalSw").checked 			 = (rec == null ? false : rec.evalSw == "Y" ? true : false);
			$("chkLoaSw").checked 			 = (rec == null ? false : rec.loaSw == "Y" ? true : false);
 			$("selPcTag").value				 = (rec == null ? "" : rec.payeeClassTag);
 			$("txtMasterPayeeClassCd").value = (rec == null ? "" : unescapeHTML2(rec.masterPayeeClassCd));
 			$("chkSlTypeTag").checked		 = (rec == null ? false : rec.slTypeTag == "Y" ? true : false);
			$("txtSlTypeCd").value			 = (rec == null ? "" : unescapeHTML2(rec.slTypeCd));
			$("txtClmVatCd").value			 = (rec == null ? "" : rec.clmVatCd);
			$("txtUserId").value 		 	 = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 	 	 = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value 		 	 = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtPayeeClassCd").readOnly = false : $("txtPayeeClassCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnClaimPayee") : enableButton("btnClaimPayee");
			objCurrPayeeClass = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.payeeClassCd 		= escapeHTML2($F("txtPayeeClassCd"));
			obj.classDesc 			= escapeHTML2($F("txtClassDesc"));
			obj.evalSw				= $("chkEvalSw").checked ? "Y" : "N";
			obj.loaSw				= $("chkLoaSw").checked ? "Y" : "N";
			obj.payeeClassTag 		= $F("selPcTag");
			obj.dspPcTagDesc 		= $("selPcTag").options[$("selPcTag").selectedIndex].text;
			obj.masterPayeeClassCd  = escapeHTML2($F("txtMasterPayeeClassCd"));
			obj.slTypeTag		    = $("chkSlTypeTag").checked ? "Y" : "N";
			obj.slTypeCd 			= escapeHTML2($F("txtSlTypeCd"));
			obj.clmVatCd	 		= $F("txtClmVatCd");
			obj.remarks 			= escapeHTML2($F("txtRemarks"));
			obj.userId 				= userId;
			var lastUpdate 			= new Date();
			obj.lastUpdate 			= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGicls140;
			var dept = setRec(objCurrPayeeClass);
			if($F("btnAdd") == "Add"){
				tbgPayeeClass.addBottomRow(dept);
			} else {
				tbgPayeeClass.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgPayeeClass.keys.removeFocus(tbgPayeeClass.keys._nCurrentFocus, true);
			tbgPayeeClass.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("payeeClassFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgPayeeClass.geniisysRows.length; i++){
						if(tbgPayeeClass.geniisysRows[i].recordStatus == 0 || tbgPayeeClass.geniisysRows[i].recordStatus == 1){								
							if(tbgPayeeClass.geniisysRows[i].payeeClassCd == $F("txtPayeeClassCd")){
								addedSameExists = true;								
							}							
						} else if(tbgPayeeClass.geniisysRows[i].recordStatus == -1){
							if(tbgPayeeClass.geniisysRows[i].payeeClassCd == $F("txtPayeeClassCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same payee_class_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISPayeeClassController", {
						parameters : {action : "valAddRec",
									  payeeClassCd : $F("txtPayeeClassCd")},
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
	
	function deleteRec(){
		changeTagFunc = saveGicls140;
		objCurrPayeeClass.recordStatus = -1;
		tbgPayeeClass.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
		$("selPcTag").disabled = false;
		$("chkSlTypeTag").disabled = false;
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISPayeeClassController", {
				parameters : {action : "valDeleteRec",
							  payeeClassCd : $F("txtPayeeClassCd")},
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
		if(nvl(objAC.fromACPayee, "N") == "Y"){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}else{
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}
	}	
	
	function cancelGicls140(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS140.exitPage = exitPage;
						saveGicls140();
					}, function(){
						exitPage(); //goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
					}, "");
		} else {
			exitPage(); //goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}
	}
	
	function goToGicls150(payeeClassCd,classDesc) {
		if(checkUserModule("GICLS150")){
			objCLMGlobal.callingForm = "GICLS140";
			$("claimPayeeDiv").show();
			$("gicls140MainDiv").hide();
			showMenuClaimPayeeClass(payeeClassCd, classDesc);			
		}else{
			showMessageBox(objCommonMessage.NO_MODULE_ACCESS,'I');
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtClassDesc").observe("keyup", function(){
		$("txtClassDesc").value = $F("txtClassDesc").toUpperCase();
	});
	
	$("txtPayeeClassCd").observe("keyup", function(){
		$("txtPayeeClassCd").value = $F("txtPayeeClassCd").toUpperCase();
	});
	
	$("txtMasterPayeeClassCd").observe("keyup", function(){
		$("txtMasterPayeeClassCd").value = $F("txtMasterPayeeClassCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	disableButton("btnClaimPayee");
	
	observeSaveForm("btnSave", saveGicls140);
	$("btnCancel").observe("click", cancelGicls140);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnClaimPayee").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS140.exitPage = 1;
						saveGicls140();
					}, function(){
						goToGicls150(tbgPayeeClass.geniisysRows[rowIndex].payeeClassCd,tbgPayeeClass.geniisysRows[rowIndex].classDesc);
// 						observeAccessibleModule(accessType.BUTTON, "GICLS150", "btnClaimPayee", function(){
// 							objCLMGlobal.callingForm = "GICLS140";
// 							showMenuClaimPayeeClass(tbgPayeeClass.geniisysRows[rowIndex].payeeClassCd, tbgPayeeClass.geniisysRows[rowIndex].classDesc);
// 						});
					}, "");
		}else {
			goToGicls150(tbgPayeeClass.geniisysRows[rowIndex].payeeClassCd,tbgPayeeClass.geniisysRows[rowIndex].classDesc);
// 			observeAccessibleModule(accessType.BUTTON, "GICLS150", "btnClaimPayee", function(){
// 				objCLMGlobal.callingForm = "GICLS140";
// 				showMenuClaimPayeeClass(tbgPayeeClass.geniisysRows[rowIndex].payeeClassCd, tbgPayeeClass.geniisysRows[rowIndex].classDesc);
// 			});
		}
	});
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtPayeeClassCd").focus();
	
	if(nvl(objAC.fromACPayee, "N") == "Y"){
		$("btnClaimPayee").value = "Payee Maintenance";
	}
</script>
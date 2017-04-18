<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls181MainDiv" name="gicls181MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Report Document Signatory Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadFormSig" name="reloadFormSig">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls181" name="gicls181">
		<div id="reportDocumentDiv" class="sectionDiv" style="margin: 0px 0px 1px 0px;">
			<table style="margin: 10px 0px 10px 161px;">
				<tr>
					<td class="rightAligned">Report No.</td>
					<td colspan="3">
						<input type="text" id="txtReportNoSig" style="width: 200px; text-align: right;" maxlength="5" readonly="readonly" tabindex="301"/>
					</td>
				</tr>
				<tr>
					<td width="" class="rightAligned">Report ID</td>
					<td colspan="3">
						<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input type="text" id="txtReportIdSig" name="txtReportIdSig" class="required allCaps" style="width: 75px; float: left; border: none; height: 15px; margin: 0; " maxlength="12" tabindex="302" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgReportIdSig" name="imgReportIdSig" alt="Go" style="float: right;" tabindex="303"/>
						</span>
						<input type="text" id="txtReportNameSig" style="height: 15px; width: 426px;" readonly="readonly" tabindex="304"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Line Name</td>
					<td>
						<input type="text" id="txtLineNameSig" style="width: 200px; " readonly="readonly" tabindex="305"/>
					</td>
					<td class="rightAligned" width="116px">Branch</td>
					<td>
						<input type="text" id="txtBranchNameSig" style="width: 200px; " readonly="readonly" tabindex="306"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Document</td>
					<td colspan="3">
						<input type="text" id="txtDocumentNameSig" style="width: 533px; " readonly="readonly" tabindex="307"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv">
			<div id="repSignatoryDiv">
				<div id="repSignatoryTableDiv" style="height: 331px; margin: 10px 0px 0px 140px;">
					
				</div>
			</div>
			<div align="center" id="repSignatoryFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Item No.</td>
						<td class="leftAligned" colspan="3">
							<input id="txtItemNo" class="required integerNoNegativeUnformatted" type="text" style="width: 200px; text-align: right;" maxlength="9" tabindex="308"/>
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Label</td>
						<td class="leftAligned" colspan="3">
							<input id="txtLabel" class="required" type="text" style="width: 533px;" maxlength="200" tabindex="309"/>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Signatory</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtSignatoryId" name="txtSignatoryId" class="required integerNoNegativeUnformatted" style="width: 75px; float: left; border: none; height: 15px; margin: 0; text-align: right;" maxlength="12" tabindex="310" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSignatoryId" name="imgSignatoryId" alt="Go" style="float: right;" tabindex="311"/>
							</span>
							<input type="text" id="txtSignatory" style="height: 15px; width: 426px;" readonly="readonly" tabindex="312"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Designation</td>
						<td class="leftAligned" colspan="3">
							<input id="txtDesignation" type="text" style="width: 533px;" readonly="readonly" tabindex="313"/>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarksSig" name="txtRemarksSig" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="314"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksSig"  tabindex="315"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserIdSig" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="316"></td>
						<td width="110px;" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdateSig" type="text" class="" style="width: 203px;" readonly="readonly" tabindex="317"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAddSig" value="Add" tabindex="318">
				<input type="button" class="button" id="btnDeleteSig" value="Delete" tabindex="319">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancelSig" value="Cancel" tabindex="320">
	<input type="button" class="button" id="btnSaveSig" value="Save" tabindex="321">
</div>
<script type="text/javascript">	
	setModuleId("GICLS181");
	setDocumentTitle("Report Document Signatory Maintenance");
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	initializeAll();
	initializeAccordion();
	
	changeTag = 0;
	var rowIndex = -1;
	var objGicls181 = {};
	
	function showGicls181ReportLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls181ReportLOV",
							moduleId : "GICLS181",
							filterText : ($("txtReportIdSig").readAttribute("lastValidValue").trim() != $F("txtReportIdSig").trim() ? $F("txtReportIdSig").trim() : ""),
							page : 1},
			title: "List of Reports",
			width: 477,
			height: 386,
			columnModel : [ {
								id: "reportNo",
								title: "Report No",
								titleAlign: 'right',
								align: 'right',
								width : '90px',
							},{
								id: "reportId",
								title: "Report ID",
								width : '100px'
							},{
								id : "reportName",
								title : "Report Name",
								width : '270px'
							} ],
				autoSelectOneRecord: true,
				filterText : escapeHTML2($("txtReportIdSig").readAttribute("lastValidValue").trim() != $F("txtReportIdSig").trim() ? $F("txtReportIdSig").trim() : ""),
				onSelect: function(row) {
					$("txtReportIdSig").value = unescapeHTML2(row.reportId);
					$("txtReportNameSig").value = unescapeHTML2(row.reportName);
					$("txtReportNoSig").value = row.reportNo;
					$("txtReportIdSig").setAttribute("lastValidValue", unescapeHTML2(row.reportId));
					$("txtLineNameSig").value = unescapeHTML2(row.lineName);
					$("txtBranchNameSig").value = unescapeHTML2(row.branchName);
					$("txtDocumentNameSig").value = unescapeHTML2(row.documentName);
					$("txtReportIdSig").focus();
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel: function (){
					$("txtReportIdSig").value = $("txtReportIdSig").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtReportIdSig").value = $("txtReportIdSig").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgReportIdSig").observe("click", showGicls181ReportLOV);
	$("txtReportIdSig").observe("change", function() {
		if($F("txtReportIdSig").trim() == "") {
			$("txtReportIdSig").value = "";
			$("txtReportIdSig").setAttribute("lastValidValue", "");
			$("txtReportNameSig").value = "";
			$("txtReportNoSig").value = "";
			$("txtLineNameSig").clear();
			$("txtBranchNameSig").clear();
			$("txtDocumentNameSig").clear();
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
		} else {
			if($F("txtReportIdSig").trim() != "" && $F("txtReportIdSig") != $("txtReportIdSig").readAttribute("lastValidValue")) {
				showGicls181ReportLOV();
			}
		}
	});

	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("reportDocumentDiv")) {		
			tbgRepSignatory.url = contextPath+"/GICLRepSignatoryController?action=showGicls181&refresh=1&reportId="+encodeURIComponent($F("txtReportIdSig"))+"&reportNo="+$F("txtReportNoSig");
			tbgRepSignatory._refreshList();
			setForm(true);
			$("txtReportIdSig").readOnly = true;
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			disableSearch("imgReportIdSig");
		}
	}
		
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	
	function enterQuery(){
		function proceedEnterQuery(){
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtReportNoSig").value = "";
			$("txtReportIdSig").value = "";
			$("txtReportIdSig").setAttribute("lastValidValue", "");
			$("txtReportIdSig").removeAttribute("readonly");
			$("txtReportNameSig").value = "";
			$("txtLineNameSig").value = "";
			$("txtBranchNameSig").value = "";
			$("txtDocumentNameSig").value = "";
			$("txtItemNo").value = "";
			$("txtLabel").value = "";
			$("txtSignatoryId").value = "";
			$("txtSignatoryId").setAttribute("lastValidValue", "");
			$("txtSignatory").value = "";
			$("txtDesignation").value = "";
			$("txtRemarksSig").value = "";
			$("txtUserIdSig").value = "";
			$("txtLastUpdateSig").value = "";
			enableSearch("imgReportIdSig");
			tbgRepSignatory.url = contextPath + "/GICLRepSignatoryController?action=showGicls181&refresh=1&reportId="+$F("txtReportIdSig")+"&reportNo="+$F("txtReportNoSig");
			tbgRepSignatory._refreshList();
			setFieldValues(null);
			$("txtReportIdSig").focus();
			disableToolbarButton("btnToolbarEnterQuery");
			setForm(false);
			changeTag = 0;
		}
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGicls181();
						proceedEnterQuery();
					}, function(){
						proceedEnterQuery();
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	$("btnToolbarEnterQuery").observe("click", enterQuery);
	
	function setForm(enable){
		if(enable){
			$("txtItemNo").readOnly = false;
			$("txtLabel").readOnly = false;
			$("txtSignatoryId").readOnly = false;
			enableSearch("imgSignatoryId");
			$("txtRemarksSig").readOnly = false;
			enableButton("btnAddSig");
		} else {
			$("txtItemNo").readOnly = true;
			$("txtLabel").readOnly = true;
			$("txtSignatoryId").readOnly = true;
			disableSearch("imgSignatoryId");
			$("txtRemarksSig").readOnly = true;		
			disableButton("btnAddSig");
			disableButton("btnDeleteSig");
		}
	}
	
	function saveGicls181(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgRepSignatory.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgRepSignatory.geniisysRows);
		new Ajax.Request(contextPath+"/GICLRepSignatoryController", {
			method: "POST",
			parameters : {action : "saveGicls181",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGicls181.exitPage != null) {
							objGicls181.exitPage();
						} else {
							tbgRepSignatory.url = contextPath + "/GICLRepSignatoryController?action=showGicls181&refresh=1&reportId="+encodeURIComponent($F("txtReportIdSig"))+"&reportNo="+$F("txtReportNoSig");
							tbgRepSignatory._refreshList();
							enableInputField("txtItemNo");
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadFormSig", showGicls181);
	
	var objCurrRepSignatory = null;
	objGicls181.repSignatoryList = JSON.parse('${jsonRepSignatoryList}');
	objGicls181.exitPage = null;
	
	var repSignatoryTableModel = {
			url : contextPath + "/GICLRepSignatoryController?action=showGicls181&refresh=1&reportId="+objCLMGlobal.gicls180ReportId+"&reportNo="+objCLMGlobal.gicls180ReportNo,
			id : 'repS',
			options : {
				width : '650px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRepSignatory = tbgRepSignatory.geniisysRows[y];
					setFieldValues(objCurrRepSignatory);
					tbgRepSignatory.keys.removeFocus(tbgRepSignatory.keys._nCurrentFocus, true);
					tbgRepSignatory.keys.releaseKeys();
					/* if(tbgRepSignatory.geniisysRows[y].readonly == 'Y'){
						disableInputField("txtItemNo");
					}else{
						enableInputField("txtItemNo");
					} */
					disableInputField("txtItemNo");	
					$("txtSignatoryId").setAttribute("lastValidValue", $F("txtSignatoryId"));
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRepSignatory.keys.removeFocus(tbgRepSignatory.keys._nCurrentFocus, true);
					tbgRepSignatory.keys.releaseKeys();
					enableInputField("txtItemNo");
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgRepSignatory.keys.removeFocus(tbgRepSignatory.keys._nCurrentFocus, true);
						tbgRepSignatory.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveSig").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRepSignatory.keys.removeFocus(tbgRepSignatory.keys._nCurrentFocus, true);
					tbgRepSignatory.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRepSignatory.keys.removeFocus(tbgRepSignatory.keys._nCurrentFocus, true);
					tbgRepSignatory.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveSig").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgRepSignatory.keys.removeFocus(tbgRepSignatory.keys._nCurrentFocus, true);
					tbgRepSignatory.keys.releaseKeys();
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
					id : "itemNo",
					title : "Item No.",
					width : '100px',
					titleAlign : 'right',
					align : 'right',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : "label",
					title : "Label",
					width : '257px',
					filterOption : true
				},
				{
					id : "signatory",
					title : "Signatory",
					width : '264px',
					filterOption : true
				},
			],
			rows : objGicls181.repSignatoryList.rows
		};

		tbgRepSignatory = new MyTableGrid(repSignatoryTableModel);
		tbgRepSignatory.pager = objGicls181.repSignatoryList;
		tbgRepSignatory.render("repSignatoryTableDiv");
	
	function setFieldValues(rec){
		try{
			$("txtItemNo").value = (rec == null ? "" : rec.itemNo);
			$("txtLabel").value = (rec == null ? "" : unescapeHTML2(rec.label));
			$("txtSignatoryId").value = (rec == null ? "" : rec.signatoryId);
			$("txtSignatory").value = (rec == null ? "" : unescapeHTML2(rec.signatory));
			$("txtDesignation").value = (rec == null ? "" : unescapeHTML2(rec.designation));
			$("txtRemarksSig").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserIdSig").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdateSig").value = (rec == null ? "" : unescapeHTML2(rec.lastUpdate));
			
			rec == null ? $("btnAddSig").value = "Add" : $("btnAddSig").value = "Update";
			rec == null ? disableButton("btnDeleteSig") : enableButton("btnDeleteSig");
			rec == null ? enableInputField("txtItemNo") : disableInputField("txtItemNo");
			objCurrRepSignatory = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.reportNo = escapeHTML2($F("txtReportNoSig"));
			obj.reportId = escapeHTML2($F("txtReportIdSig"));
			obj.itemNo = $F("txtItemNo");
			obj.label = escapeHTML2($F("txtLabel"));
			obj.signatoryId = escapeHTML2($F("txtSignatoryId"));
			obj.signatory = escapeHTML2($F("txtSignatory"));
			obj.designation = escapeHTML2($F("txtDesignation"));
			obj.userId = userId;
			obj.remarks = escapeHTML2($F("txtRemarksSig"));
			
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("repSignatoryFormDiv")){
				if($F("btnAddSig") == "Add") {
					validateNewRecord();
				} else {
					/* if(tbgRepSignatory.geniisysRows[rowIndex].readonly != "Y"){
						validateNewRecord();	
					}else{ */
						addRec();	
					//}
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function validateNewRecord(){
		var addedSameExists = false;
		var deletedSameExists = false;					
		
		for(var i=0; i<tbgRepSignatory.geniisysRows.length; i++){
			if(tbgRepSignatory.geniisysRows[i].recordStatus == 0 || tbgRepSignatory.geniisysRows[i].recordStatus == 1){								
				if(tbgRepSignatory.geniisysRows[i].itemNo == $F("txtItemNo")){
					addedSameExists = true;								
				}							
			} else if(tbgRepSignatory.geniisysRows[i].recordStatus == -1){
				if(tbgRepSignatory.geniisysRows[i].itemNo == $F("txtItemNo")){
					deletedSameExists = true;
				}
			}
		}
		
		if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
			showMessageBox("Record already exists with the same item_no.", "E");
			return;
		} else if(deletedSameExists && !addedSameExists){
			addRec();
			return;
		}
		new Ajax.Request(contextPath + "/GICLRepSignatoryController", {
			parameters : {action : "valAddRec",
						  reportId : $F("txtReportIdSig"),
						  itemNo : $F("txtItemNo"),
						  reportNo : $F("txtReportNoSig")},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					addRec();
				}
			}
		});
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGicls181;
			var rec = setRec(objCurrRepSignatory);
			if($F("btnAddSig") == "Add"){
				tbgRepSignatory.addBottomRow(rec);
			} else {
				tbgRepSignatory.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			$("txtSignatoryId").setAttribute("lastValidValue", "");
			tbgRepSignatory.keys.removeFocus(tbgRepSignatory.keys._nCurrentFocus, true);
			tbgRepSignatory.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function deleteRec(){
		changeTagFunc = saveGicls181;
		objCurrRepSignatory.recordStatus = -1;
		tbgRepSignatory.geniisysRows[rowIndex].reportId = escapeHTML2(tbgRepSignatory.geniisysRows[rowIndex].reportId);
		tbgRepSignatory.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
		$("txtSignatoryId").setAttribute("lastValidValue", "");
	}
	
	function exitPage(){
		if(objCLMGlobal.callingForm == "GICLS180"){
			$("gicls180MainDiv").show();
			$("repSignatoryDiv").hide();
			setModuleId("GICLS180");
			setDocumentTitle("Report Document Maintenance");					
		}else{
			if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
			}else{
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			}
		}
	}	
	
	function cancelGicls181(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGicls181.exitPage = exitPage;
						saveGicls181();
					}, function(){
						if(objCLMGlobal.callingForm == "GICLS180"){
							$("gicls180MainDiv").show();
							$("repSignatoryDiv").hide();
							setModuleId("GICLS180");
							setDocumentTitle("Report Document Maintenance");					
						}else{
							if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
								goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
							}else{
								goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
							}
						}
						changeTag = 0;
					}, "");
		} else {
			if(objCLMGlobal.callingForm == "GICLS180"){
				$("gicls180MainDiv").show();
				$("repSignatoryDiv").hide();
				setModuleId("GICLS180");
				setDocumentTitle("Report Document Maintenance");
			}else{
				if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
					goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
				}else{
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				}	
			}
		}
	}
	
	$("editRemarksSig").observe("click", function(){
		showOverlayEditor("txtRemarksSig", 4000, $("txtRemarksSig").hasAttribute("readonly"));
	});
	
	function showGicls181SignatoryLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls181SignatoryLOV",
							moduleId : "GICLS181",
							filterText : ($("txtSignatoryId").readAttribute("lastValidValue").trim() != $F("txtSignatoryId").trim() ? $F("txtSignatoryId").trim() : ""),
							page : 1},
			title: "List of Signatories",
			width: 477,
			height: 386,
			columnModel : [ {
								id: "signatoryId",
								title: "Signatory ID",
								titleAlign: 'right',
								align: 'right',
								width : '100px',
							},{
								id : "signatory",
								title : "Signatory",
								width : '180px'
							},{
								id : "designation",
								title : "Designation",
								width : '180px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtSignatoryId").readAttribute("lastValidValue").trim() != $F("txtSignatoryId").trim() ? $F("txtSignatoryId").trim() : ""),
				onSelect: function(row) {
					$("txtSignatoryId").value = row.signatoryId;
					$("txtSignatoryId").setAttribute("lastValidValue", row.signatoryId);
					$("txtSignatory").value = unescapeHTML2(row.signatory);
					$("txtDesignation").value = unescapeHTML2(row.designation);
					$("txtSignatoryId").focus();
				},
				onCancel: function (){
					$("txtSignatoryId").value = $("txtSignatoryId").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSignatoryId").value = $("txtSignatoryId").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgSignatoryId").observe("click", showGicls181SignatoryLOV);
	$("txtSignatoryId").observe("change", function() {
		if($F("txtSignatoryId").trim() == "") {
			$("txtSignatoryId").value = "";
			$("txtSignatoryId").setAttribute("lastValidValue", "");
			$("txtSignatory").value = "";
			$("txtDesignation").value = "";
		} else {
			if($F("txtSignatoryId").trim() != "" && $F("txtSignatoryId") != $("txtSignatoryId").readAttribute("lastValidValue")) {
				showGicls181SignatoryLOV();
			}
		}
	});
	
	setForm(false);
	disableButton("btnDeleteSig");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	observeSaveForm("btnSaveSig", saveGicls181);
	observeSaveForm("btnToolbarSave", saveGicls181);
	$("btnCancelSig").observe("click", cancelGicls181);
	$("btnAddSig").observe("click", valAddRec);
	$("btnDeleteSig").observe("click", deleteRec);
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancelSig"), "click");
	});
	$("txtReportIdSig").focus();
	
	if(objCLMGlobal.callingForm == "GICLS180"){
		$("txtReportNoSig").value = unescapeHTML2(objCLMGlobal.gicls180ReportNo);
		$("txtReportIdSig").value = unescapeHTML2(objCLMGlobal.gicls180ReportId);
		$("txtReportNameSig").value = unescapeHTML2(objCLMGlobal.gicls180ReportName);
		$("txtLineNameSig").value = unescapeHTML2(objCLMGlobal.gicls180LineName);
		$("txtBranchNameSig").value = unescapeHTML2(objCLMGlobal.gicls180BranchName);
		$("txtDocumentNameSig").value = unescapeHTML2(objCLMGlobal.gicls180DocumentName);
		objGicls181.reportId = objCLMGlobal.gicls180ReportId;
		objGicls181.reportNo = objCLMGlobal.gicls180ReportNo;
		setForm(true);
		$("txtReportIdSig").readOnly = true;
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		disableSearch("imgReportIdSig");
	}
</script>

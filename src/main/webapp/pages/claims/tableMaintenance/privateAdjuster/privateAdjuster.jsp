<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls210MainDiv" name="gicls210MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Private Adjuster Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div class="sectionDiv" id="searchAdjustingCompanyDiv" style="height: 80px;">
		<table style="margin: 20px 0 20px 100px; width:800px;">
			<tr>
				<td class="rightAligned">Adjusting Company</td>
				<td>
					<span class="lovSpan required" style="float: left; width: 130px; margin-right: 5px; margin-top: 2px; height: 21px;">
						<input type="text" id="txtPayeeNo" name="txtPayeeNo" lastValidValue="" class="required integerNoNegativeUnformattedNoComma" style="width: 105px; text-align: right; float: left; border: none; height: 15px; margin: 0;" maxlength="12" tabindex="101" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osPayeeNo" name="osPayeeNo" alt="Go" style="float: right;" />
					</span>
					<input type="text" id="txtPayeeLastName" name="txtPayeeLastName" style="width: 400px; float: left; height: 15px;" readonly="readonly" maxlength="500" tabindex="102" />
					<input type="hidden" id="hidPayeeClassCd" />
				</td>
			</tr>
		</table>
	</div>
	
	<div id="gicls210" name="gicls210">		
		<div class="sectionDiv">
			<div id="privateprivateAdjusterTableDiv" style="padding-top: 10px;">
				<div id="privateAdjusterTable" style="height: 340px; margin-left: 140px;"></div>
			</div>
			<div align="center" id="privateAdjusterFormDiv">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtPrivAdjCd" type="text" class="integerNoNegativeUnformattedNoComma" readonly="readonly" style="width: 200px; text-align: right;" tabindex="201" maxlength="3">
							<input type="hidden" id="hidLastPrivAdjCd" />
							<input type="hidden" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Adjuster</td>
						<td class="leftAligned" colspan="3"><input id="txtPayeeName" class="required" type="text" style="width: 530px;" tabindex="202" maxlength="50"></td>					
					</tr>	
					<tr>
						<td width="" class="rightAligned">Mailing Address</td>
						<td class="leftAligned" colspan="3"><input id="txtMailingAddr" type="text" style="width: 530px;" tabindex="203" maxlength="90"></td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Billing Address</td>
						<td class="leftAligned" colspan="3"><input id="txtBillingAddr" type="text" style="width: 530px;" tabindex="205" maxlength="90"></td>
					</tr>
					<tr>
						<td class="rightAligned">Contact Person</td>
						<td class="leftAligned" colspan="3"><input id="txtContactPers" type="text" style="width: 530px;" tabindex="207" maxlength="50"></td>					
					</tr>
					<tr>
						<td class="rightAligned">Designation</td>
						<td class="leftAligned"><input id="txtDesignation" type="text" style="width: 200px;" tabindex="208" maxlength="5"></td>
						<td class="rightAligned">Phone Number</td>
						<td class="leftAligned"><input id="txtPhoneNo" type="text" style="width: 200px;" tabindex="209" maxlength="40"></td>					
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div name="remarksDiv" style="float: left; width: 536px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 504px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="210"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="211"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="212"></td>
						<td width="110px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="213"></td>
					</tr>			
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="301">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="302">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv" style="margin:10px 0 30px 10px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="303">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="304">
</div>
<script type="text/javascript">	
	setModuleId("GICLS210");
	setDocumentTitle("Private Adjuster Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	setForm(false);
	
	function saveGicls210(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgPrivateAdjuster.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgPrivateAdjuster.geniisysRows);
		new Ajax.Request(contextPath+"/GIISAdjusterController", {
			method: "POST",
			parameters : {action : "saveGicls210",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS210.exitPage != null) {
							objGICLS210.exitPage();
						} else {
							tbgPrivateAdjuster._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGicls210);
	
	var objGICLS210 = {};
	var objCurrPrivateAdjuster = null;
	objGICLS210.privateAdjusterList = [];
	objGICLS210.exitPage = null;
	
	var privateAdjusterTable = {
			url : contextPath + "/GIISAdjusterController?action=showGicls210&refresh=1&adjCompanyCd="+$F("txtPayeeNo"),
			options : {
				width : '640px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrPrivateAdjuster = tbgPrivateAdjuster.geniisysRows[y];
					setFieldValues(objCurrPrivateAdjuster);
					tbgPrivateAdjuster.keys.removeFocus(tbgPrivateAdjuster.keys._nCurrentFocus, true);
					tbgPrivateAdjuster.keys.releaseKeys();
					$("txtPayeeName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPrivateAdjuster.keys.removeFocus(tbgPrivateAdjuster.keys._nCurrentFocus, true);
					tbgPrivateAdjuster.keys.releaseKeys();
					$("txtPayeeName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgPrivateAdjuster.keys.removeFocus(tbgPrivateAdjuster.keys._nCurrentFocus, true);
						tbgPrivateAdjuster.keys.releaseKeys();
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
					tbgPrivateAdjuster.keys.removeFocus(tbgPrivateAdjuster.keys._nCurrentFocus, true);
					tbgPrivateAdjuster.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPrivateAdjuster.keys.removeFocus(tbgPrivateAdjuster.keys._nCurrentFocus, true);
					tbgPrivateAdjuster.keys.releaseKeys();
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
					tbgPrivateAdjuster.keys.removeFocus(tbgPrivateAdjuster.keys._nCurrentFocus, true);
					tbgPrivateAdjuster.keys.releaseKeys();
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
					id: 'adjCompanyCd',
					width: '0',
					visible: false
				},
				{
					id : "privAdjCd",
					title : "Code",
					titleAlign: 'right',
					align: 'right',
					width : '100px',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					renderer: function(value){
						return (value != "" ? lpad(value, 3, 0) : "");
					}
				},
				{
					id : 'payeeName',
					title : 'Adjuster',
					filterOption : true,
					width : '490px'				
				},
				{
					id : "mailAddr",
					width : '0',
					visible: false
				},
				{
					id : "billAddr",
					width : '0',
					visible: false
				},
				{
					id : "contactPers",
					width : '0',
					visible: false
				},
				{
					id : "designation",
					width : '0',
					visible: false
				},
				{
					id : "phoneNo",
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
			rows : objGICLS210.privateAdjusterList.rows || []
		};

		tbgPrivateAdjuster = new MyTableGrid(privateAdjusterTable);
		tbgPrivateAdjuster.pager = objGICLS210.privateAdjusterList;
		tbgPrivateAdjuster.render("privateAdjusterTable");
	
	
	function setFieldValues(rec){
		try{
			$("txtPrivAdjCd").value = (rec == null ? "" : rec.privAdjCd != "" ? lpad(rec.privAdjCd,3,0) : "");
			$("txtPrivAdjCd").setAttribute("lastValidValue", (rec == null ? "" : rec.privAdjCd));
			$("txtPayeeName").value = (rec == null ? "" : unescapeHTML2(rec.payeeName));
			$("txtMailingAddr").value = (rec == null ? "" : unescapeHTML2(rec.mailAddr));
			$("txtBillingAddr").value = (rec == null ? "" : unescapeHTML2(rec.billAddr));
			$("txtContactPers").value = (rec == null ? "" : unescapeHTML2(rec.contactPers));
			$("txtDesignation").value = (rec == null ? "" : unescapeHTML2(rec.designation));
			$("txtPhoneNo").value = (rec == null ? "" : unescapeHTML2(rec.phoneNo));
			
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			//rec == null ? $("txtPrivAdjCd").readOnly = false : $("txtPrivAdjCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrPrivateAdjuster = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.payeeClassCd = escapeHTML2($F("hidPayeeClassCd"));
			obj.adjCompanyCd = $F("txtPayeeNo");
			obj.privAdjCd = $F("txtPrivAdjCd");
			obj.payeeName = escapeHTML2($F("txtPayeeName"));
			obj.mailAddr = escapeHTML2($F("txtMailingAddr"));
			obj.billAddr = escapeHTML2($F("txtBillingAddr"));
			obj.contactPers = escapeHTML2($F("txtContactPers"));
			obj.designation = escapeHTML2($F("txtDesignation"));
			obj.phoneNo = escapeHTML2($F("txtPhoneNo"));			
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
			changeTagFunc = saveGicls210;
			var dept = setRec(objCurrPrivateAdjuster);
			if($F("btnAdd") == "Add"){
				tbgPrivateAdjuster.addBottomRow(dept);
			} else {
				tbgPrivateAdjuster.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgPrivateAdjuster.keys.removeFocus(tbgPrivateAdjuster.keys._nCurrentFocus, true);
			tbgPrivateAdjuster.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("privateAdjusterFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i=0; i<tbgPrivateAdjuster.geniisysRows.length; i++){
						if(tbgPrivateAdjuster.geniisysRows[i].recordStatus == 0 || tbgPrivateAdjuster.geniisysRows[i].recordStatus == 1){								
							if($F("txtPrivAdjCd").trim() != "" && tbgPrivateAdjuster.geniisysRows[i].privAdjCd == $F("txtPrivAdjCd")){
								addedSameExists = true;
							}
						} else if(tbgPrivateAdjuster.geniisysRows[i].recordStatus == -1){
							if($F("txtPrivAdjCd").trim() != "" && tbgPrivateAdjuster.geniisysRows[i].privAdjCd == $F("txtPrivAdjCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same priv_adj_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISAdjusterController", {
						parameters : {action : "valAddRec",
									  adjCompanyCd : $F("txtPayeeNo"),
									  privAdjCd : $F("txtPrivAdjCd")},
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
		changeTagFunc = saveGicls210;
		objCurrPrivateAdjuster.recordStatus = -1;
		tbgPrivateAdjuster.deleteRow(rowIndex);
		changeTag = 1;		
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISAdjusterController", {
				parameters : {action : "valDeleteRec",
							  privAdjCd : $F("txtPrivAdjCd")},
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
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}	
	
	function cancelGicls210(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS210.exitPage = exitPage;
						saveGicls210();
					}, function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}
	}
	
	function showGicls210PayeeNoLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls210PayeeNoLOV",
							filterText : ($("txtPayeeNo").readAttribute("lastValidValue").trim() != $F("txtPayeeNo").trim() ? $F("txtPayeeNo").trim() : "%"),
							page : 1},
			title: "List of Adjusting Companies",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "payeeNo",
								title: "Payee No.",
								titleAlign: 'right',
								align: 'right',
								width: '100px'
							},
							{
								id : "payeeLastName",
								title: "Payee Name",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id: 'payeeClassCd',
								width: '0',
								visible: false
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtPayeeNo").readAttribute("lastValidValue").trim() != $F("txtPayeeNo").trim() ? $F("txtPayeeNo").trim() : "%"),
				onSelect: function(row) {
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
					$("txtPayeeNo").value = row.payeeNo;
					$("txtPayeeNo").setAttribute("lastValidValue", row.payeeNo);
					$("txtPayeeLastName").value = unescapeHTML2(row.payeeLastName);
					$("hidPayeeClassCd").value = unescapeHTML2(row.payeeClassCd);
				},
				onCancel: function (){
					$("txtPayeeNo").value = $("txtPayeeNo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtPayeeNo").value = $("txtPayeeNo").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function setForm(enable){
		if(enable){
			$("txtPayeeName").readOnly = false;
			$("txtMailingAddr").readOnly = false;
			$("txtBillingAddr").readOnly = false;
			$("txtContactPers").readOnly = false;
			$("txtDesignation").readOnly = false;
			$("txtPhoneNo").readOnly = false;
			$("txtRemarks").readOnly = false;
			enableButton("btnAdd");
		} else {
			$("txtPayeeName").readOnly = true;
			$("txtMailingAddr").readOnly = true;
			$("txtBillingAddr").readOnly = true;
			$("txtContactPers").readOnly = true;
			$("txtDesignation").readOnly = true;
			$("txtPhoneNo").readOnly = true;
			$("txtRemarks").readOnly = true;
			disableButton("btnAdd");
			disableButton("btnDelete");
		}
	}
	
	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("searchAdjustingCompanyDiv")) {			
			tbgPrivateAdjuster.url = contextPath + "/GIISAdjusterController?action=showGicls210&refresh=1&adjCompanyCd="+$F("txtPayeeNo");
			tbgPrivateAdjuster._refreshList();
			
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtPayeeNo").readOnly = true;
			disableSearch("osPayeeNo");
			
			if(tbgPrivateAdjuster.geniisysRows.length == 0){
				showMessageBox("Query caused no records to be retrieved.", "I");
			}
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){

			changeTag = 0;
			
			if($F("txtPayeeNo").trim() != "") {
				disableToolbarButton("btnToolbarExecuteQuery");
				$("txtPayeeNo").value = "";
				$("txtPayeeNo").setAttribute("lastValidValue", "");
				$("txtPayeeNo").value = "";
				$("txtPayeeLastName").value = "";
				$("txtPayeeNo").readOnly = false;
				enableSearch("osPayeeNo");
				tbgPrivateAdjuster.url = contextPath + "/GIISAdjusterController?action=showGicls210&refresh=1";
				tbgPrivateAdjuster._refreshList();
				setFieldValues(null);
				$("txtPrivAdjCd").value = "";
				$("txtPayeeNo").focus();
				disableToolbarButton("btnToolbarEnterQuery");
				setForm(false);
			}
		}
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGicls210();
						proceedEnterQuery();
					}, function(){
						proceedEnterQuery();
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
		
	$("osPayeeNo").observe("click", showGicls210PayeeNoLOV);
	
	$("txtPayeeNo").observe("change", function() {		
		if($F("txtPayeeNo").trim() == "") {
			$("txtPayeeNo").value = "";
			$("txtPayeeNo").setAttribute("lastValidValue", "");
			$("txtPayeeLastName").value = "";
			$("hidPayeeClassCd").value = "";
		} else {
			if($F("txtPayeeNo").trim() != "" && $F("txtPayeeNo") != $("txtPayeeNo").readAttribute("lastValidValue")) {
				showGicls210PayeeNoLOV();
			}
		}
	});	 	
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGicls210);
	observeSaveForm("btnToolbarSave", saveGicls210);
	$("btnCancel").observe("click", cancelGicls210);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtPayeeNo").focus();	
</script>

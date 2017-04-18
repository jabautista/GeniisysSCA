<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs319MainDiv" name="giacs319MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>DCB User Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs319" name="giacs319">		
		<div class="sectionDiv">
			<div style="" align="center" id="lineDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">Company</td>
						<td class="leftAligned" colspan="3">
							<div class="required" style="float: left; width: 105px; height: 21px; margin-right: 5px; margin-top: 2px; border: solid gray 1px;">
								<input class="required allCaps" type="text" id="txtGfunFundCd" name="txtGfunFundCd" style="width: 80px; float: left; border: none; height: 13px; margin: 0;" maxlength="3" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCompanyLOV" name="searchCompanyLOV" alt="Go" style="float: right;" tabindex="102"/>
							</div>
							<input id="txtFundDesc" name="txtFundDesc" type="text" style="width: 350px;" value="" readonly="readonly" tabindex="103"/>
						</td>						
					</tr>
					<tr>
						<td class="rightAligned" style="" id="">Branch</td>
						<td class="leftAligned" colspan="3">
							<input class="required allCaps" type="text" id="txtBranchCd" name="txtBranchCd" readonly="readonly" style="width: 100px;" maxlength="4" tabindex="104"5/>								
							<input id="txtBranchName" name="txtBranchName" type="text" style="width: 350px;" value="" readonly="readonly" tabindex="105"/>
						</td>						
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="dcbUsersTableDiv" style="padding-top: 10px;">
				<div id="dcbUsersTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="dcbUsersFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtCashierCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="200" maxlength="3">
						</td>
						<td class="rightAligned">Active</td>
						<td class="leftAligned" >
							<select id="selValidTag" style="width: 207px;" tabindex="201">
								<option value="Yes">Yes</option>
								<option value="No">No</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">User Name</td>
						<td class="leftAligned" colspan="4">
							<div class="required" style="float: left; width: 125px; height: 21px; margin-right: 5px; margin-top: 2px; border: solid gray 1px;">
							<!-- <span class="lovSpan required" style="float: left; width: 125px; margin-right: 5px; margin-top: 2px; height: 21px;"> -->
								<input class="required allCaps" type="text" id="txtDcbUserId" name="txtDcbUserId" style="width: 100px; float: left; border: none; height: 13px; margin: 0;" maxlength="8" tabindex="203" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDcbUserLOV" name="searchDcbUserLOV" alt="Go" style="float: right;" tabindex="204"/>
							</div>
							<input id="txtDcbUserName" name="txtDcbUserName" type="text" style="width: 455px;" value="" readonly="readonly" tabindex="205"/>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Printable Name</td>
						<td class="leftAligned" colspan="4">
							<input id="txtPrintName" name="txtPrintName" type="text" style="width: 587px;" value="" maxlength="30" tabindex="206"/>
						</td>
					</tr>					
					<tr>
						<td class="rightAligned">Valid From</td>
						<td class="leftAligned">	
							<div id="validFromDiv" class="required" style="float: left; border: 1px solid gray; width: 205px; height: 20px;">
								<input id="txtEffectivityDt" name="txtEffectivityDt" readonly="readonly" class="required disableDelKey" type="text" maxlength="10" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" value="" tabindex="207"/>
								<img id="imgEffectivityDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" " tabindex="208"/>
							</div>		
						</td>
						<td class="rightAligned">Valid To</td>
						<td class="leftAligned">	
							<div id="validToDiv" style="float: left; border: 1px solid gray; width: 205px; height: 20px;">
								<input id="txtExpiryDt" name="txtExpiryDt" readonly="readonly" type="text" maxlength="10" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" value="" tabindex="209"/>
								<img id="imgExpiryDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="210"/>			
							</div>		
						</td>	
					</tr>
					<tr>
						<td class="rightAligned">Default Bank Account</td>
						<td colspan="3" class="leftAligned">
							<div style="float: left; width: 65px; height: 21px; margin-right: 5px; margin-top: 2px; border: solid gray 1px;">
							<!-- <span class="lovSpan" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;"> -->
								<input type="text" id="txtBankCd" name="txtBankCd" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="3" tabindex="211" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBankLOV" name="searchBankLOV" alt="Go" style="float: right;" tabindex="212"/>
							</div>
							<input id="txtBankName" type="text" class="" style="float: left; width: 290px" readonly="readonly" tabindex="213">
							<label style="float: left; margin: 5px 5px 0 5px;">/</label>
							<div id="bankAcctSpan" style="float: left; width: 65px; height: 21px; margin-right: 5px; margin-top: 2px; border: solid gray 1px;">
							<!-- <span id="bankAcctSpan" class="lovSpan" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;"> -->
								<input type="text" id="txtBankAcctCd" name="txtBankAcctCd" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="4" tabindex="214" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBankAcctLOV" name="searchBankAcctLOV" alt="Go" style="float: right;" tabindex="215"/>
							</div>
							<input id="txtBankAcctNo" type="text" class="" style="float: left; width: 128px" readonly="readonly" tabindex="216">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 592px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 566px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="217"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="218"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="219"></td>
						<td width="" class="rightAligned" style="padding-left: 100px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="220"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px 0 10px 0;" class="buttonsDiv">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="221">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="222">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="223">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="224">
</div>
<script type="text/javascript">	
	setModuleId("GIACS319");
	setDocumentTitle("DCB User Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs319(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgDcbUser.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgDcbUser.geniisysRows);
		new Ajax.Request(contextPath+"/GIACDCBUserController", {
			method: "POST",
			parameters : {action : "saveGiacs319",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS319.afterSave != null) {
							objGIACS319.afterSave();
							objGIACS319.afterSave = null;
						} else {
							tbgDcbUser._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs319);
	
	var objGIACS319 = {};
	var objDcbUsers = null;
	objGIACS319.dcbUsersList = JSON.parse('${jsonDcbUserList}');
	objGIACS319.afterSave = null;
	
	var dcbUsersTable = {
			url : contextPath + "/GIACDCBUserController?action=showGiacs319&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objDcbUsers = tbgDcbUser.geniisysRows[y];
					setFieldValues(objDcbUsers);
					tbgDcbUser.keys.removeFocus(tbgDcbUser.keys._nCurrentFocus, true);
					tbgDcbUser.keys.releaseKeys();
					$("selValidTag").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDcbUser.keys.removeFocus(tbgDcbUser.keys._nCurrentFocus, true);
					tbgDcbUser.keys.releaseKeys();
					$("txtCashierCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgDcbUser.keys.removeFocus(tbgDcbUser.keys._nCurrentFocus, true);
						tbgDcbUser.keys.releaseKeys();
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
					tbgDcbUser.keys.removeFocus(tbgDcbUser.keys._nCurrentFocus, true);
					tbgDcbUser.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDcbUser.keys.removeFocus(tbgDcbUser.keys._nCurrentFocus, true);
					tbgDcbUser.keys.releaseKeys();
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
					tbgDcbUser.keys.removeFocus(tbgDcbUser.keys._nCurrentFocus, true);
					tbgDcbUser.keys.releaseKeys();
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
					id : 'gfunFundCd',
					width : '0',
					visible : false
				},
				{
					id : 'branchCd',
					width : '0',
					visible : false
				},	
				{
					id : 'bankCd',
					width : '0',
					visible : false
				},
				{
					id : 'bankName',
					width : '0',
					visible : false
				},	
				{
					id : 'bankAcctCd',
					width : '0',
					visible : false
				},
				{
					id : 'bankAcctNo',
					width : '0',
					visible : false
				},
				{
					id : "cashierCd",
					title : "Code",
					width : '80px',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					renderer: function(value){
						return formatNumberDigits(value, 3);
					}
				},
				{
					id : "dcbUserId dcbUserName",
					title: "User Name",
					filterOption: true,
					sortable: true,
					children: [
						{
							id: "dcbUserId",
							title: "DCB User ID",
							width: 70,
							filterOption: true,
							sortable: true
						},
						{
							id: "dcbUserName",
							title: "DCB User Name",
							width: 255,
							filterOption: true,
							sortable: true
						}
		            ]
				},	
				{
					id: "printName",
					title: "Printable Name",
					width: '177px',
					filterOption: true
				},
				{
					id: "effectivityDt",
					title: "Valid From",
					width: '100px',
					titleAlign: 'center',
					align: 'center',
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return value == "" ? "" : dateFormat(value, 'mm-dd-yyyy');
					}
				},	
				{
					id: "expiryDt",
					title: "Valid To",
					titleAlign: 'center',
					align: 'center',
					width: '100px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return value == "" ? "" : dateFormat(value, 'mm-dd-yyyy');
					}
				},
				{
					id: "validTag",
					title: "Active",
					width: '60px',
					filterOption: true,
					/*renderer: function(value){
						if (value == "Y"){
							return "Yes";
						}else{
							return "No";
						}
					}*/
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
			rows : objGIACS319.dcbUsersList.rows
		};

		tbgDcbUser = new MyTableGrid(dcbUsersTable);
		tbgDcbUser.pager = objGIACS319.dcbUsersList;
		tbgDcbUser.render("dcbUsersTable");
	
	function setFieldValues(rec){
		try {
			$("txtCashierCd").value = (rec == null ? "" : formatNumberDigits(rec.cashierCd, 3));
			$("txtCashierCd").setAttribute("lastValidValue", (rec == null ? "" : formatNumberDigits(rec.cashierCd, 3) ));
			$("selValidTag").value = (rec == null ? "Yes" : rec.validTag );
			$("txtDcbUserId").value = (rec == null ? "" : unescapeHTML2(rec.dcbUserId));
			$("txtDcbUserName").value = (rec == null ? "" : unescapeHTML2(rec.dcbUserName));
			$("txtPrintName").value = (rec == null ? "" : unescapeHTML2(rec.printName));
			$("txtEffectivityDt").value = (rec == null ? "" : (rec.effectivityDt == null ? "" : dateFormat(rec.effectivityDt, 'mm-dd-yyyy') ) );
			$("txtExpiryDt").value = (rec == null ? "" : (rec.expiryDt == null ? "" : dateFormat(rec.expiryDt, 'mm-dd-yyyy') ) );
			$("txtBankCd").value = (rec == null ? "" : unescapeHTML2(rec.bankCd));
			$("txtBankName").value = (rec == null ? "" : unescapeHTML2(rec.bankName));
			$("txtBankAcctCd").value = (rec == null ? "" : unescapeHTML2(rec.bankAcctCd));
			$("txtBankAcctNo").value = (rec == null ? "" : unescapeHTML2(rec.bankAcctNo));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtCashierCd").readOnly = false : $("txtCashierCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? $("txtDcbUserId").readOnly = false : (rec.recordStatus == "0" ? $("txtDcbUserId").readOnly = false : $("txtDcbUserId").readOnly = true);
			rec == null ? enableSearch("searchDcbUserLOV") : (rec.recordStatus == "0" ? enableSearch("searchDcbUserLOV") : disableSearch("searchDcbUserLOV"));
			rec == null ? enableDate("imgEffectivityDate") : (rec.recordStatus == "0" ? enableDate("imgEffectivityDate") : disableDate("imgEffectivityDate"));
			
			$F("txtBankAcctCd") == "" ?	$("txtBankAcctCd").setAttribute("lastValidValue", "") : $("txtBankAcctCd").setAttribute("lastValidValue", $F("txtBankAcctCd"));
			$("txtBankAcctCd").readOnly = ($F("txtBankAcctCd") == "" ? true : false);
			$F("txtBankAcctCd") == "" ? $("bankAcctSpan").removeClassName("required") : $("bankAcctSpan").addClassName("required");
			$F("txtBankAcctCd") == "" ? $("txtBankAcctCd").removeClassName("required") : $("txtBankAcctCd").addClassName("required");
			$F("txtBankAcctCd") == "" ? disableSearch("searchBankAcctLOV") : enableSearch("searchBankAcctLOV");
						
			objDcbUsers = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.gibrFundCd = $F("txtGfunFundCd");
			obj.gibrBranchCd = $F("txtBranchCd");
			obj.cashierCd = $F("txtCashierCd");
			obj.validTag = $F("selValidTag");
			obj.dcbUserId = $F("txtDcbUserId");
			obj.dcbUserName = $F("txtDcbUserName");
			obj.printName = escapeHTML2($F("txtPrintName"));
			obj.effectivityDt = $F("txtEffectivityDt");
			obj.expiryDt = $F("txtExpiryDt");
			obj.bankCd = $F("txtBankCd");
			obj.bankName = $F("txtBankName");
			obj.bankAcctCd = $F("txtBankAcctCd");
			obj.bankAcctNo = $F("txtBankAcctNo");
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
			changeTagFunc = saveGiacs319;
			var dept = setRec(objDcbUsers);
			if($F("btnAdd") == "Add"){
				tbgDcbUser.addBottomRow(dept);
			} else {
				tbgDcbUser.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			$("txtBankAcctCd").readOnly = true;
			$("txtBankAcctCd").removeClassName("required");
			disableSearch("searchBankAcctLOV");
			tbgDcbUser.keys.removeFocus(tbgDcbUser.keys._nCurrentFocus, true);
			tbgDcbUser.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("dcbUsersFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgDcbUser.geniisysRows.length; i++){
						if(tbgDcbUser.geniisysRows[i].recordStatus == 0 || tbgDcbUser.geniisysRows[i].recordStatus == 1){								
							if(tbgDcbUser.geniisysRows[i].cashierCd == $F("txtCashierCd") && tbgDcbUser.geniisysRows[i].dcbUserId == $F("txtDcbUserId")){
								addedSameExists = true;								
							}							
						} else if(tbgDcbUser.geniisysRows[i].recordStatus == -1){
							if(tbgDcbUser.geniisysRows[i].cashierCd == $F("txtCashierCd") && tbgDcbUser.geniisysRows[i].dcbUserId == $F("txtDcbUserId")){ 
								deletedSameExists = true;
							}
						}
					}
					 
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same cashier_cd and dcb_user_id.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACDCBUserController", {
						parameters : {action : 		"valAddRec",
						             gibrFundCd:   $F("txtGfunFundCd"), //koks 9.1.15 change param to gibrFundCd
						           gibrBranchCd:	$F("txtBranchCd"),  //koks 9.1.15 change param to gibrBranchCd
									  cashierCd: 	$F("txtCashierCd"),
									  dcbUserId: 	$F("txtDcbUserId")},
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
		changeTagFunc = saveGiacs319;
		objDcbUsers.recordStatus = -1;
		tbgDcbUser.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACDCBUserController", {
				parameters : {action : 		"valDeleteRec",
							  gfunFundCd:   $F("txtGfunFundCd"),
							  branchCd:		$F("txtBranchCd"),
							  cashierCd : 	$F("txtCashierCd"),
					  		  dcbUserId: 	$F("txtDcbUserId")},
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
	
	function cancelGiacs319(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS319.afterSave = exitPage;
						saveGiacs319();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showCompanyLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtGfunFundCd").trim() == "" ? "%" : $F("txtGfunFundCd"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs319CompanyLOV",
					searchString : searchString,
					moduleId: 'GIACS319',
					page : 1
				},
				title : "List of Companies",
				width : 670,
				height : 386,
				columnModel : [ {
					id : "gfunFundCd",
					title : "Company Code",
					width : '110px',
				}, {
					id : "fundDesc",
					title : "Company Name",
					width : '250px'
				},{
					id : "branchCd",
					title : "Branch Code",
					width : '100px',
				}, {
					id : "branchName",
					title : "Branch Name",
					width : '190px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtGfunFundCd").value = unescapeHTML2(row.gfunFundCd);
						$("txtGfunFundCd").setAttribute("lastValidValue", $F("txtGfunFundCd"));
						$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
						$("txtBranchCd").value = unescapeHTML2(row.branchCd);
						$("txtBranchName").value = unescapeHTML2(row.branchName);
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("txtGfunFundCd").focus();
					$("txtGfunFundCd").value = $("txtGfunFundCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtGfunFundCd").value = $("txtGfunFundCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtGfunFundCd");
				} 
			});
		}catch(e){
			showErrorMessage("showCompanyLOV", e);
		}		
	}
	
	function showDcbUserLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtDcbUserId").trim() == "" ? "%" : $F("txtDcbUserId"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs319DcbUserLOV",
					searchString : searchString,
					moduleId: 'GIACS319',
					page : 1
				},
				title : "List of Accounting Users",
				width : 360,
				height : 386,
				columnModel : [ 
				{
					id : "dcbUserId",
					title : "DCB User ID",
					width : '120px',
				}, {
					id : "dcbUserName",
					title : "DCB User Name",
					width : '225px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtDcbUserId").value = unescapeHTML2(row.dcbUserId);
						$("txtDcbUserId").setAttribute("lastValidValue", $F("txtDcbUserId"));
						$("txtDcbUserName").value = unescapeHTML2(row.dcbUserName);
					}
				},
				onCancel: function(){
					$("txtDcbUserId").focus();
					$("txtDcbUserId").value = $("txtDcbUserId").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtDcbUserId").value = $("txtDcbUserId").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDcbUserId");
				} 
			});
		}catch(e){
			showErrorMessage("showDcbUserLOV", e);
		}		
	}
	
	function showBankLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtBankCd").trim() == "" ? "%" : $F("txtBankCd"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs319BankLOV",
					searchString : searchString,
					moduleId: 'GIACS319',
					page : 1
				},
				title : "List of Banks",
				width : 360,
				height : 386,
				columnModel : [ 
				{
					id : "bankCd",
					title : "Bank Code",
					width : '120px',
				}, {
					id : "bankName",
					title : "Bank Name",
					width : '225px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtBankCd").value = row.bankCd;
						$("txtBankCd").setAttribute("lastValidValue", row.bankCd);
						$("txtBankName").value = unescapeHTML2(row.bankName);
						$("txtBankAcctCd").setAttribute("lastValidValue", "");
						$("txtBankAcctCd").clear();
						$("txtBankAcctNo").clear();
						$("txtBankAcctCd").addClassName("required");
						$("bankAcctSpan").addClassName("required");
						$("txtBankAcctCd").focus;
						$("txtBankAcctCd").readOnly = false;
						enableSearch("searchBankAcctLOV");
					}
				},
				onCancel: function(){
					$("txtBankCd").focus();
					$("txtBankCd").value = $("txtBankCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtBankCd").value = $("txtBankCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBankCd");
				} 
			});
		}catch(e){
			showErrorMessage("showBankLOV", e);
		}		
	}
	
	
	function showBankAcctLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtBankAcctCd").trim() == "" ? "%" : $F("txtBankAcctCd"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs319BankAcctLOV",
					searchString : searchString,
					bankCd:		$F("txtBankCd"),
					moduleId: 'GIACS319',
					page : 1
				},
				title : "List of Bank Accounts",
				width : 360,
				height : 386,
				columnModel : [ 
				{
					id : "bankAcctCd",
					title : "Bank Account Code",
					width : '120px',
				}, {
					id : "bankAcctNo",
					title : "Bank Account Number",
					width : '225px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtBankAcctCd").value = row.bankAcctCd;
						$("txtBankAcctCd").setAttribute("lastValidValue", row.bankAcctCd);
						$("txtBankAcctNo").value = unescapeHTML2(row.bankAcctNo);
					}
				},
				onCancel: function(){
					$("txtBankAcctCd").focus();
					$("txtBankAcctCd").value = $("txtBankAcctCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtBankAcctCd").value = $("txtBankAcctCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBankAcctCd");
				} 
			});
		}catch(e){
			showErrorMessage("showBankAcctLOV", e);
		}		
	}
	
	function toggleDcbUserFields(enable){
		try{
			if (enable){
				$("txtCashierCd").readOnly = false;
				$("selValidTag").disabled = false;
				$("txtDcbUserId").readOnly = false;
				enableSearch("searchDcbUserLOV");
				$("txtPrintName").readOnly = false;
				enableDate("imgEffectivityDate");
				enableDate("imgExpiryDate");
				$("txtBankCd").readOnly = false;
				enableSearch("searchBankLOV");
				/*$("txtBankAcctCd").readOnly = false;
				enableSearch("searchBankAcctLOV");*/
				$("txtRemarks").readOnly = false;
				enableButton("btnAdd");		
			}else{		
				$("txtCashierCd").readOnly = true;
				$("selValidTag").disabled = true;
				$("txtDcbUserId").readOnly = true;
				disableSearch("searchDcbUserLOV");
				$("txtPrintName").readOnly = true;
				disableDate("imgEffectivityDate");
				disableDate("imgExpiryDate");
				$("txtBankCd").readOnly = true;
				disableSearch("searchBankLOV");
				$("txtBankAcctCd").readOnly = true;
				disableSearch("searchBankAcctLOV");
				$("txtRemarks").readOnly = true;
				disableButton("btnAdd");	
			}
		}catch(e){
			showErrorMessage("toggleDcbUserFields", e);
		}
	}
	
	function enterQuery(){
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		enableSearch("searchCompanyLOV");
		tbgDcbUser.url = contextPath+"/GIACDCBUserController?action=showGiacs319&refresh=1";
		tbgDcbUser._refreshList();
		$("txtGfunFundCd").readOnly = false;
		$("txtGfunFundCd").clear();
		$("txtFundDesc").clear();
		$("txtBranchCd").clear();
		$("txtBranchName").clear();
		toggleDcbUserFields(false);
		$("txtGfunFundCd").focus();
		changeTag = 0;
	}
	
	$("searchCompanyLOV").observe("click", function(){
		showCompanyLOV(true);
	});
	
	$("txtGfunFundCd").observe("change", function(){
		if (this.value != ""){
			showCompanyLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtFundDesc").clear();
			$("txtBranchCd").clear();
			$("txtBranchName").clear();
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtDcbUserId").observe("keyup", function(){
		$("txtDcbUserId").value = $F("txtDcbUserId").toUpperCase();
	});
	
	$("txtCashierCd").observe("blur", function(){
		if (this.value != ""){
			$("txtCashierCd").value = formatNumberDigits($F("txtCashierCd"),3);
		}		
	});
	
	$("searchDcbUserLOV").observe("click", function(){
		showDcbUserLOV(true);
	});
	
	$("txtDcbUserId").observe("change", function(){
		if (this.value != ""){
			showDcbUserLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtDcbUserName").clear();
		}
	});
	
	$("imgEffectivityDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtEffectivityDt", "txtEffectivityDt", "txtExpiryDt");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtEffectivityDt"),this, null);
	});
	
	$("imgExpiryDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtExpiryDt", "txtEffectivityDt", "txtExpiryDt");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtExpiryDt"),this, null);
	});
	
	$("searchBankLOV").observe("click", function(){
		showBankLOV(true);
	});
	
	$("txtBankCd").observe("change", function(){
		if (this.value != ""){
			showBankLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtBankName").clear();
			$("txtBankAcctCd").setAttribute("lastValidValue", "");
			$("txtBankAcctCd").clear();
			$("txtBankAcctNo").clear();
			$("txtBankAcctCd").readOnly = true;
			$("bankAcctSpan").removeClassName("required");
			$("txtBankAcctCd").removeClassName("required");
			disableSearch("searchBankAcctLOV");
		}
	});
	
	$("searchBankAcctLOV").observe("click", function(){
		showBankAcctLOV(true);
	});
	
	$("txtBankAcctCd").observe("change", function(){
		if (this.value != ""){
			showBankAcctLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtBankAcctNo").clear();
		}
	});
	
	/*$("txtBankAcctCd").observe("blur", function(){
		if ($F("txtBankCd") != "" && this.value == ""){
			showMessageBox("Please enter bank account code.", "E");
		}
	});*/
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						objGIACS319.afterSave = enterQuery;
						saveGiacs319();
					},
					function(){
						enterQuery();
					},
					""
			);
		}else{
			enterQuery();
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if (checkAllRequiredFieldsInDiv('lineDiv')){
			disableToolbarButton(this.id);
			enableToolbarButton("btnToolbarEnterQuery");
			$("txtGfunFundCd").readOnly = true;
			disableSearch("searchCompanyLOV");
			tbgDcbUser.url = contextPath+"/GIACDCBUserController?action=showGiacs319&refresh=1&gfunFundCd="
								+$F("txtGfunFundCd")+"&branchCd="+$F("txtBranchCd");
			tbgDcbUser._refreshList();
			toggleDcbUserFields(true);
		}		
	});
	
	disableButton("btnDelete");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	observeSaveForm("btnSave", saveGiacs319);
	observeSaveForm("btnToolbarSave", saveGiacs319);
	$("btnCancel").observe("click", cancelGiacs319);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$$("div#dcbUsersFormDiv input[type='text'].disableDelKey").each(function (a) {
		$(a).observe("keydown",function(e){
			if($(a).readOnly && e.keyCode === 46){
				$(a).blur();
			}
		});
	});
	
	$("txtGfunFundCd").focus();	
	
	toggleDcbUserFields(false);
</script>
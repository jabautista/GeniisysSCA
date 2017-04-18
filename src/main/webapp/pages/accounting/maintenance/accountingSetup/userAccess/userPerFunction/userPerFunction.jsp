<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs315MainDiv" name="giacs315MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>User per Function Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadFormGiacs315" name="reloadFormGiacs315">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs315" name="giacs315">		
		<div class="sectionDiv">
			<div style="" align="center" id="moduleDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">Module Name</td>
						<td class="leftAligned" colspan="3">
							<input id="hidModuleId" type="hidden">
							<span class="lovSpan required" style="float: left; width: 105px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtModuleName" name="txtModuleName" value="" style="width: 80px; float: left; border: none; height: 13px; margin: 0;" maxlength="15" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchModuleLOV" name="searchModuleLOV" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtScrnRepName" name="txtScrnRepName" value="${scrnRepName}"  type="text" class="" style="width: 350px;" value="" readonly="readonly" tabindex="103"/>
						</td>						
					</tr>
					<tr>
						<td class="rightAligned" style="" id="">Function</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 105px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtFunctionCode" name="txtFunctionCode" style="width: 80px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="104" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFunctionLOV" name="searchFunctionLOV" alt="Go" style="float: right;" tabindex="105"/>
							</span>								
							<input id="txtFuncName" name="txtFuncName" class="" type="text" style="width: 350px;" value="" readonly="readonly" tabindex="106"/>
						</td>						
					</tr>					
					<tr>
						<td class="rightAligned" style="" id="">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtFuncDesc" name="txtFuncDesc" class="" type="text" style="width: 463px;" value="" readonly="readonly" tabindex="107"/>
						</td>						
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="userFunctionsTableDiv" style="padding-top: 10px;">
				<div id="userFunctionsTable" style="height: 340px; margin-left: 185px;"></div>
			</div>
			<div align="center" id="userFunctionsFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Acctg User ID</td>
						<td class="leftAligned">
							<input id="hidFunctionCode" type="hidden"/>
							<span class="lovSpan required" style="float: left; width: 155px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtAcctgUserId" name="txtAcctgUserId" style="width: 130px; float: left; border: none; height: 15px; margin: 0;" maxlength="8" tabindex="201" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchUserLOV" name="searchUserLOV" alt="Go" style="float: right;" tabindex="202"/>
							</span>
						</td>
						<td class="rightAligned">Valid Tag</td>
						<td class="leftAligned" >
							<input id="hidValidTag" type="hidden" value="Y"/>
							<select id="selValidTag" class="required" style="width: 157px;" tabindex="203">
								<option value="Y">Valid</option>
								<option value="N">Not Valid</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">User Name</td>
						<td class="leftAligned" colspan="4">
							<input id="txtUserName" name="txtUserName" type="text" class="required" style="width: 437px;" value="" readonly="readonly" tabindex="204"/>
						</td>
					</tr>		
					<tr>
						<td class="rightAligned">Valid From</td>
						<td class="leftAligned">	
							<div id="validFromDiv" class="" style="float: left; border: 1px solid gray; width: 155px; height: 20px;">
								<input id="txtValidityDt" name="txtValidityDt" class ="required" readonly="readonly" class=" disableDelKey" type="text" maxlength="10" style="border: none; float: left; width: 130px; height: 13px; margin: 0px;" value="" tabindex="205"/>
								<img id="imgEffectivityDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  tabindex="206"/>
							</div>		
						</td>
						<td class="rightAligned">Valid To</td>
						<td class="leftAligned">	
							<div id="validToDiv" style="float: left; border: 1px solid gray; width: 155px; height: 20px;">
								<input id="txtTerminationDt" name="txtTerminationDt" readonly="readonly" type="text" maxlength="10" style="border: none; float: left; width: 130px; height: 13px; margin: 0px;" value="" tabindex="207"/>
								<img id="imgExpiryDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  tabindex="208"/>			
							</div>		
						</td>	
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 442px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 414px; margin-top: 0; border: none;" id="txtRemarksGiacs315" name="txtRemarksGiacs315" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="209"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="210"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtTranUserId" type="text" class="" style="width: 150px;" readonly="readonly" tabindex="211"></td>
						<td width="" class="rightAligned" style="padding-left: 46px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdateGiacs315" type="text" class="" style="width: 150px;" readonly="readonly" tabindex="212"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px 0 10px 0;" class="buttonsDiv" >
				<input type="button" class="button" id="btnAddGiacs315" value="Add" tabindex="213">
				<input type="button" class="button" id="btnDeleteGiacs315" value="Delete" tabindex="214">
			</div>
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancelGiacs315" value="Cancel" tabindex="215">
		<input type="button" class="button" id="btnSaveGiacs315" value="Save" tabindex="216">
	</div>
</div>
<script type="text/javascript">	
	setModuleId("GIACS315");
	setDocumentTitle("User per Function Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs315(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgUserFunctions.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgUserFunctions.geniisysRows);
		new Ajax.Request(contextPath+"/GIACUserFunctionsController", {
			method: "POST",
			parameters : {action : "saveGiacs315",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS315.afterSave != null) {
							objGIACS315.afterSave();
							objGIACS315.afterSave = null;
						} else {
							tbgUserFunctions._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadFormGiacs315", showGiacs315);
	
	var objGIACS315 = {};
	var objUserFunctionss = null;
	objGIACS315.userFunctionsList = JSON.parse('${jsonUserPerFunctionList}');
	objGIACS315.afterSave = null;
	
	var userFunctionsTable = {
			url : contextPath + "/GIACUserFunctionsController?action=showGiacs315&refresh=1",
			options : {
				width : '597px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objUserFunctionss = tbgUserFunctions.geniisysRows[y];
					setFieldValues(objUserFunctionss);
					tbgUserFunctions.keys.removeFocus(tbgUserFunctions.keys._nCurrentFocus, true);
					tbgUserFunctions.keys.releaseKeys();
					$("selValidTag").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgUserFunctions.keys.removeFocus(tbgUserFunctions.keys._nCurrentFocus, true);
					tbgUserFunctions.keys.releaseKeys();
					$("txtAcctgUserId").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgUserFunctions.keys.removeFocus(tbgUserFunctions.keys._nCurrentFocus, true);
						tbgUserFunctions.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveGiacs315").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgUserFunctions.keys.removeFocus(tbgUserFunctions.keys._nCurrentFocus, true);
					tbgUserFunctions.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgUserFunctions.keys.removeFocus(tbgUserFunctions.keys._nCurrentFocus, true);
					tbgUserFunctions.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveGiacs315").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgUserFunctions.keys.removeFocus(tbgUserFunctions.keys._nCurrentFocus, true);
					tbgUserFunctions.keys.releaseKeys();
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
					id : 'moduleId',
					width : '0',
					visible : false
				},
				{
					id : 'functionCode',
					width : '0',
					visible : false
				},	
				{
					id : 'userFunctionId',
					width : '0',
					visible : false
				},
				{
					id : 'validTag',
					width : '0',
					visible : false
				},
				{
					id : "userId",
					title : "Acctg User ID",
					width : '100px',
					filterOption : true
				},
				{
					id: "userName",
					title: "User Name",
					width: '177px',
					filterOption: true
				},
				{
					id: "dspValidTag",
					title: "Valid Tag",
					width: '70px',
					filterOption: true
				},
				{
					id: "validityDt",
					title: "Valid From",
					align: 'center',
					titleAlign: 'center',
					width: '100px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return value == "" ? "" : dateFormat(value, 'mm-dd-yyyy');
					}
				},	
				{
					id: "terminationDt",
					title: "Valid To",
					align: 'center',
					titleAlign: 'center',
					width: '100px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return value == "" ? "" : dateFormat(value, 'mm-dd-yyyy');
					}
				},
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'tranUserId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIACS315.userFunctionsList.rows
		};

		tbgUserFunctions = new MyTableGrid(userFunctionsTable);
		tbgUserFunctions.pager = objGIACS315.userFunctionsList;
		tbgUserFunctions.render("userFunctionsTable");
	
	function setFieldValues(rec){
		try {
			$("hidFunctionCode").value = (rec == null ? "" : rec.functionCode);
			$("txtAcctgUserId").value = (rec == null ? "" : rec.userId);
			$("txtAcctgUserId").setAttribute("lastValidValue", (rec == null ? "" : rec.userId ));
			$("selValidTag").value = (rec == null ? "Valid" : rec.validTag );
			$("hidValidTag").value = (rec == null ? "Y" : rec.validTag);
			$("txtUserName").value = (rec == null ? "" : unescapeHTML2(rec.userName));
			$("txtValidityDt").value = (rec == null ? "" : (rec.validityDt == null || rec.validityDt == "" ? "" : dateFormat(rec.validityDt, 'mm-dd-yyyy') ) );
			$("txtTerminationDt").value = (rec == null ? "" : (rec.terminationDt == null || rec.terminationDt == "" ? "" : dateFormat(rec.terminationDt, 'mm-dd-yyyy') ) );
			$("txtTranUserId").value = (rec == null ? "" : unescapeHTML2(rec.tranUserId));
			$("txtLastUpdateGiacs315").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarksGiacs315").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAddGiacs315").value = "Add" : $("btnAddGiacs315").value = "Update";
			rec == null ? $("txtAcctgUserId").readOnly = false : $("txtAcctgUserId").readOnly = true;
			rec == null ? enableSearch("searchUserLOV") : disableSearch("searchUserLOV");
			rec == null ? disableButton("btnDeleteGiacs315") : enableButton("btnDeleteGiacs315");
			objUserFunctionss = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.moduleId = $F("hidModuleId");
			obj.moduleName = $F("txtModuleName");
			obj.functionCode = $F("txtFunctionCode");
			obj.dspValidTag = $("selValidTag").options[$("selValidTag").selectedIndex].text;
			obj.validTag = $F("hidValidTag");
			obj.userId = $F("txtAcctgUserId");
			obj.userName = $F("txtUserName");
			obj.validityDt = $F("txtValidityDt") == "" ? "" : $F("txtValidityDt");
			obj.terminationDt = $F("txtTerminationDt") == "" ? "" : $F("txtTerminationDt");
			obj.remarks = escapeHTML2($F("txtRemarksGiacs315"));
			obj.tranUserId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs315;
			var dept = setRec(objUserFunctionss);
			if($F("btnAddGiacs315") == "Add"){
				tbgUserFunctions.addBottomRow(dept);
			} else {
				tbgUserFunctions.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgUserFunctions.keys.removeFocus(tbgUserFunctions.keys._nCurrentFocus, true);
			tbgUserFunctions.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("userFunctionsFormDiv")){
				/*if($F("btnAddGiacs315") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgUserFunctions.geniisysRows.length; i++){
						if(tbgUserFunctions.geniisysRows[i].recordStatus == 0 || tbgUserFunctions.geniisysRows[i].recordStatus == 1){								
							if(tbgUserFunctions.geniisysRows[i].userId == $F("txtAcctgUserId")){
								addedSameExists = true;								
							}							
						} else if(tbgUserFunctions.geniisysRows[i].recordStatus == -1){
							if(tbgUserFunctions.geniisysRows[i].userId == $F("txtAcctgUserId")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same Acctg User ID.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACUserFunctionsController", {
						parameters : {action : 		"valAddRec",
									  moduleId:   	$F("hidModuleId"),
									  functionCode:	$F("txtFunctionCode"),
									  userId: 		$F("txtAcctgUserId")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {*/
				
				// SR-5861 June Mark [12.15.16]
				var addedSameExists = false;				
				
				for(var i=0; i<tbgUserFunctions.geniisysRows.length; i++){
					if(tbgUserFunctions.geniisysRows[i].userId == $F("txtAcctgUserId")){
						if($F("selValidTag") == "Y" && tbgUserFunctions.geniisysRows[i].validTag == "Y"){
							addedSameExists = true;
							break;
						}												
					}
				}
				
				if(addedSameExists){
					showMessageBox("Record already exists with the same Acctg User ID. and Valid Tag", "E");
					return;
				}else {
					addRec();
					return;
				}
				// end SR-5861
				
				//}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiacs315;
		objUserFunctionss.recordStatus = -1;
		tbgUserFunctions.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		/*try{
			new Ajax.Request(contextPath + "/GIACUserFunctionsController", {
				parameters : {action : 		"valDeleteRec",
							  moduleId:   	$F("hidModuleId"),
							  functionCode:	$F("txtFunctionCode"),
							  userId: 		$F("txtAcctgUserId")},
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
		}*/
		deleteRec();
	}
	
	function exitPage(){
		changeTag = 0;
		if (objACGlobal.callingForm == "GIACS314"){
			$("giacs314MainDiv").show();
			$("userPerFunctionDiv").hide();
			setModuleId("GIACS314");
			setDocumentTitle("Accounting Function Maintenance");
			//showGiacs314();
		}else{
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}	
	
	function cancelGiacs315(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS315.afterSave = exitPage;
						saveGiacs315();
					}, exitPage, 
					"");
		} else {
			exitPage();
		}
	}
	
	function showModuleLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtModuleName").trim() == "" ? "%" : $F("txtModuleName"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs315ModuleLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Modules",
				width : 378,
				height : 386,
				columnModel : [{
					id : "moduleId",
					width : '0px',
					visible: false
				}, {
					id : "moduleName",
					title : "Module Name",
					width : '90px',
				}, {
					id : "scrnRepName",
					title : "Screen Report Name",
					width : '270px'
				}],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("hidModuleId").value = unescapeHTML2(row.moduleId);
						$("txtModuleName").value = unescapeHTML2(row.moduleName);
						$("txtModuleName").setAttribute("lastValidValue", unescapeHTML2(row.moduleName));
						$("txtScrnRepName").value = unescapeHTML2(row.scrnRepName);
						$("txtFunctionCode").clear();
						$("txtFuncName").clear();
						$("txtFuncDesc").clear();
						$("txtFunctionCode").readOnly = false;
						enableSearch("searchFunctionLOV");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("txtModuleName").focus();
					$("txtModuleName").value = $("txtModuleName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtModuleName").value = $("txtModuleName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtModuleName");
				} 
			});
		}catch(e){
			showErrorMessage("showModuleLOV", e);
		}		
	}
	
	function showFunctionLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtFunctionCode").trim() == "" ? "%" : $F("txtFunctionCode"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : 		"getGiacs315FunctionLOV",
					moduleId:		$F("hidModuleId"),
					searchString : 	searchString,
					page : 			1
				},
				title : "List of Functions",
				width : 530,
				height : 386,
				columnModel : [{
					id : "functionCode",
					title : "Function Code",
					width : '70px',
				}, {
					id : "functionName",
					title : "Function Name",
					width : '220px'
				},
				{
					id : "functionDesc",
					title : "Function Desc",
					width : '220px'
				}],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtFunctionCode").value = unescapeHTML2(row.functionCode);
						$("txtFunctionCode").setAttribute("lastValidValue", unescapeHTML2(row.functionCode));
						$("txtFuncName").value = unescapeHTML2(row.functionName);
						$("txtFuncDesc").value = unescapeHTML2(row.functionDesc);
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("txtFunctionCode").focus();
					$("txtFunctionCode").value = $("txtFunctionCode").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtFunctionCode").value = $("txtFunctionCode").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtFunctionCode");
				} 
			});
		}catch(e){
			showErrorMessage("showFunctionLOV", e);
		}		
	}

	
	function showUserLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtAcctgUserId").trim() == "" ? "%" : $F("txtAcctgUserId"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs315UserLOV",
					searchString : searchString,
					moduleId: 'GIACS315',
					page : 1
				},
				title : "List of Accounting Users",
				width : 360,
				height : 386,
				columnModel : [ 
				{
					id : "userId",
					title : "User ID",
					width : '120px',
				}, {
					id : "userName",
					title : "User Name",
					width : '225px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtAcctgUserId").value = unescapeHTML2(row.userId);
						$("txtAcctgUserId").setAttribute("lastValidValue", unescapeHTML2(row.userId));
						$("txtUserName").value = unescapeHTML2(row.userName);
					}
				},
				onCancel: function(){
					$("txtAcctgUserId").focus();
					$("txtAcctgUserId").value = $("txtAcctgUserId").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtAcctgUserId").value = $("txtAcctgUserId").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtAcctgUserId");
				} 
			});
		}catch(e){
			showErrorMessage("showUserLOV", e);
		}		
	}
	
	function toggleUserFunctionsFields(enable){
		try{
			if (enable){
				$("selValidTag").disabled = false;
				$("txtAcctgUserId").readOnly = false;
				enableSearch("searchUserLOV");
				enableDate("imgEffectivityDate");
				enableDate("imgExpiryDate");
				$("txtRemarksGiacs315").readOnly = false;
				enableButton("btnAddGiacs315");		
			}else{		
				$("selValidTag").disabled = true;
				$("txtAcctgUserId").readOnly = true;
				$("txtFunctionCode").readOnly = true;
				disableSearch("searchFunctionLOV");
				disableSearch("searchUserLOV");
				disableDate("imgEffectivityDate");
				disableDate("imgExpiryDate");
				$("txtRemarksGiacs315").readOnly = true;
				disableButton("btnAddGiacs315");	
			}
		}catch(e){
			showErrorMessage("toggleUserFunctionsFields", e);
		}
	}
	
	function enterQuery(){
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		enableSearch("searchModuleLOV");
		tbgUserFunctions.url = contextPath+"/GIACUserFunctionsController?action=showGiacs315&refresh=1";
		tbgUserFunctions._refreshList();
		$("txtModuleName").clear();
		$("txtScrnRepName").clear();
		$("txtFunctionCode").clear();
		$("txtFuncName").clear();
		$("txtFuncDesc").clear();
		$("hidModuleId").clear();
		toggleUserFunctionsFields(false);
		$("txtModuleName").setAttribute("lastValidValue", "");
		$("txtFunctionCode").setAttribute("lastValidValue", "");
		$("txtAcctgUserId").setAttribute("lastValidValue", "");
		$("txtModuleName").readOnly = false;
		$("txtFunctionCode").readOnly = false;
		$("txtModuleName").focus();
		changeTag = 0;
	}
	
	$("searchModuleLOV").observe("click", function(){
		showModuleLOV(true);
	});
		
	$("txtModuleName").observe("change", function(){
		if (this.value != ""){
			showModuleLOV(false);
		}else{
			$("txtModuleName").setAttribute("lastValidValue", "");
			$("txtScrnRepName").clear();
			$("txtFunctionCode").clear();
			$("txtFuncName").clear();
			$("txtFuncDesc").clear();
			$("hidModuleId").clear();
			$("txtFunctionCode").readOnly = true;
			disableSearch("searchFunctionLOV");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("searchFunctionLOV").observe("click", function(){
		showFunctionLOV(true);
	});
		
	$("txtFunctionCode").observe("change", function(){
		if (this.value != ""){
			showFunctionLOV(false);
		}else{
			$("txtFunctionCode").setAttribute("lastValidValue", "");
			$("txtFuncName").clear();
			$("txtFuncDesc").clear();
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("txtAcctgUserId").observe("change", function(){
		if (this.value != ""){
			showUserLOV(false);
		}else{
			$("txtAcctgUserId").setAttribute("lastValidValue", "");
			$("txtUserName").clear();
		}
	});
		
	$("searchUserLOV").observe("click", function(){
		showUserLOV(true);
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarksGiacs315", 4000, $("txtRemarksGiacs315").hasAttribute("readonly"));
	});
	
	$("txtAcctgUserId").observe("keyup", function(){
		$("txtAcctgUserId").value = $F("txtAcctgUserId").toUpperCase();
	});
		
	$("selValidTag").observe("change", function(){
		$("hidValidTag").value = $F("selValidTag");
		 if ($F("selValidTag") == "N") { //Added by Jerome 08.10.2016 SR 5602
			$("txtValidityDt").removeClassName("required");
		 } else if ($F("selValidTag") == "Y") {
			 $("txtValidityDt").addClassName("required");
		 }
	});
	
	$("imgEffectivityDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtValidityDt", "txtValidityDt", "txtTerminationDt");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtValidityDt"),this, null);
	});
	
	$("imgExpiryDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtTerminationDt", "txtValidityDt", "txtTerminationDt");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtTerminationDt"),this, null);
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						objGIACS315.afterSave = enterQuery;
						saveGiacs315();
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
		if (checkAllRequiredFieldsInDiv("moduleDiv")){
			disableToolbarButton(this.id);
			enableToolbarButton("btnToolbarEnterQuery");
			$("txtModuleName").readOnly = true;
			$("txtFunctionCode").readOnly = true;
			disableSearch("searchModuleLOV");
			disableSearch("searchFunctionLOV");
			tbgUserFunctions.url = contextPath+"/GIACUserFunctionsController?action=showGiacs315&refresh=1&moduleId="
								   +encodeURIComponent($F("hidModuleId"))+"&functionCode="+encodeURIComponent($F("txtFunctionCode"));
			tbgUserFunctions._refreshList();
			toggleUserFunctionsFields(true);
		}
	});
	
	disableButton("btnDeleteGiacs315");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	observeSaveForm("btnSaveGiacs315", saveGiacs315);
	observeSaveForm("btnToolbarSave", saveGiacs315);
	$("btnCancelGiacs315").observe("click", cancelGiacs315);
	$("btnAddGiacs315").observe("click", valAddRec);
	$("btnDeleteGiacs315").observe("click", valDeleteRec);

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancelGiacs315"), "click");
	});
	
	$$("div#userFunctionsFormDiv input[type='text'].disableDelKey").each(function (a) {
		$(a).observe("keydown",function(e){
			if($(a).readOnly && e.keyCode === 46){
				$(a).blur();
			}
		});
	});
	
	$("txtModuleName").focus();	
	
	
	if (/*objACGlobal.objGIACS314.calledByGiacs314 == "Y"*/ objACGlobal.callingForm == "GIACS314"){
		$("hidModuleId").value = objACGlobal.objGIACS314.moduleId;
		$("txtModuleName").value = objACGlobal.objGIACS314.moduleName;
		$("txtFunctionCode").value = objACGlobal.objGIACS314.functionCode;
		$("txtFuncName").value = objACGlobal.objGIACS314.functionName;
		$("txtFuncDesc").value = objACGlobal.objGIACS314.functionDesc;
		$("txtModuleName").readOnly = true;
		$("txtFunctionCode").readOnly = true;
		disableSearch("searchModuleLOV");
		disableSearch("searchFunctionLOV");
		tbgUserFunctions.url = contextPath+"/GIACUserFunctionsController?action=showGiacs315&refresh=1&moduleId="
							   +encodeURIComponent($F("hidModuleId"))+"&functionCode="+encodeURIComponent($F("txtFunctionCode"));
		disableToolbarButton("btnToolbarEnterQuery");
		
		toggleUserFunctionsFields(true);
		$("txtAcctgUserId").focus();
	}else{
		toggleUserFunctionsFields(false);
	}
</script>
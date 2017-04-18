<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs321MainDiv" name="giacs321MainDiv" style="">
	<div id="giacs321Div" style="display: none;">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="giacs321Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Module Accounting Entries Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="giacs321" name="giacs321">
		<div class="sectionDiv" id="moduleNameDiv" style="height: 53px;">
			<table align="center" style="margin-top: 10px;">
				<tr>
					<td class="rightAligned">Module Name</td>
					<td>
						<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required" type="text" id="txtModuleName" name="txtModuleName" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="10" tabindex="101" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgModuleName" name="imgModuleName" alt="Go" style="float: right;" tabindex="102"/>
						</span>
						<input type="text" id="txtScrnRepName" style="width: 300px; height: 15px;" readonly=readonly/>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv">
			<div id="moduleEntryTableDiv" style="padding-top: 10px;">
				<div id="moduleEntryTable" style="height: 331px; margin-left: 130px;"></div>
			</div>
			<div id="moduleEntryTypeFormDiv" style="margin-left: 120px; margin-top: 10px; float: left; width: 830px;">
				<div style="float: left;">
					<table style="margin-top: 5px;">
						<tr>
							<td class="rightAligned">Item No.</td>
							<td colspan="5"><input id="txtItemNo" type="text" class="" style="width: 200px; text-align: right;" readonly="readonly" /></td>
						</tr>
						<tr>
							<td class="rightAligned">GL Account Number</td>
							<td>
								<input type="text" id="txtGlAcctCategory" name="glAcctNo" class="required integerNoNegativeUnformattedNoComma" maxlength="1" style="width: 50px; text-align: right;" textValue="GL Control Category"/>
							</td>
							<td>
								<input type="text" id="txtGlControlAcct" name="glAcctNo" maxlength="2" class="required" style="width: 50px; text-align: right;" textValue="GL Control Acct"/>
								<input type="text" id="txtGlSubAcct1" name="glAcctNo" maxlength="2" class="required" style="width: 50px; text-align: right;" textValue="GL Sub Acct 1"/>
								<input type="text" id="txtGlSubAcct2" name="glAcctNo" maxlength="2" class="required" style="width: 50px; text-align: right;" textValue="GL Sub Acct 2"/>
							</td>
							<td>
								<input type="text" id="txtGlSubAcct3" name="glAcctNo" maxlength="2" style="width: 50px; text-align: right;" textValue="GL Sub Acct 3"/>
							</td>
							<td>
								<input type="text" id="txtGlSubAcct4" name="glAcctNo" maxlength="2" style="width: 50px; text-align: right;" textValue="GL Sub Acct 4"/>
								<input type="text" id="txtGlSubAcct5" name="glAcctNo" maxlength="2" style="width: 50px; text-align: right;" textValue="GL Sub Acct 5"/>
								<input type="text" id="txtGlSubAcct6" name="glAcctNo" maxlength="2" style="width: 50px; text-align: right;" textValue="GL Sub Acct 6"/>
							</td>
							<td>
								<input type="text" id="txtGlSubAcct7" name="glAcctNo" maxlength="2" style="width: 50px; text-align: right;" textValue="GL Sub Acct 7"/>
							</td>
						</tr>	
						<tr>
							<td class="rightAligned">SL Type</td>
							<td>
								<input type="text" id="txtSlTypeCd" maxlength="2" style="width: 50px;"/>
							</td>
							<td class="rightAligned">Line Dependency Level</td>
							<td>
								<input type="text" id="txtLineDependencyLevel" class="integerNoNegativeUnformattedNoComma" maxlength="1" style="width: 50px; text-align: right;" textValue="Line Dependency Level"/>
							</td>
							<td class="rightAligned">Subline Dependency Level</td>
							<td>
								<input type="text" id="txtSublineLevel" class="integerNoNegativeUnformattedNoComma" maxlength="1" style="width: 50px; text-align: right;" textValue="Subline Dependency Level"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Branch Dependency Level</td>
							<td>
								<input type="text" id="txtBranchLevel" class="integerNoNegativeUnformattedNoComma" maxlength="1" style="width: 50px; text-align: right;" textValue="Branch Dependency Level"/>
							</td>
							<td class="rightAligned">Intermediary Type Level</td>
							<td>
								<input type="text" id="txtIntmTypeLevel" maxlength="1" style="width: 50px; text-align: right;" lastValidValue=""/>
							</td>
							<td class="rightAligned">Treaty Type Level</td>
							<td>
								<input type="text" id="txtCaTreatyType" class="integerNoNegativeUnformattedNoComma" maxlength="1" style="width: 50px; text-align: right;" textValue="Treaty Type Level"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Old/New Account Level</td>
							<td>
								<input type="text" id="txtOldNewAcctLevel" maxlength="1" style="width: 50px; text-align: right;" lastValidValue=""/>
							</td>
							<td class="rightAligned">Debit/Credit Tag</td>
							<td colspan="3">
								<select id="selDrCrTag" class="required" style="width: 120px; float: left;">
									<option value="debit">Debit</option>
									<option value="credit">Credit</option>
								</select>
								<input type="checkbox" id="chkPolTypeTag" style="margin: 5px 0px 0px 79px; float: left;"/>
								<label for="chkPolTypeTag" style="margin: 5px 0px 0px 5px;">Policy Type Tag</label>
							</td>
						</tr>
						<tr>
							<td width="" class="rightAligned">Remarks</td>
							<td colspan="5">
								<div id="remarksDiv" name="remarksDiv" style="float: left; width: 552px; border: 1px solid gray; height: 22px;">
									<textarea style="float: left; height: 16px; width: 526px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="200"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td colspan="2"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" /></td>
							<td colspan="3" class="rightAligned">Last Update
								<input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" />
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div style="margin-top: 205px; margin-bottom: 10px;" align = "center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="108">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="109">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="110">
</div>
<div id="hiddenDiv">
	<input type="hidden" id="hidModuleId" />
	<input type="hidden" id="hidItemNo" />
	<input type="hidden" id="hidMaxItemNo" />
</div>
<script type="text/javascript">	
	setModuleId("GIACS321");
	setDocumentTitle("Module Accounting Entries Maintenance");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs321(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgModuleEntry.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgModuleEntry.geniisysRows);
		new Ajax.Request(contextPath+"/GIACModuleEntryController", {
			method: "POST",
			parameters : {action : "saveGiacs321",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiacs321.exitPage != null) {
							objGiacs321.exitPage();
						} else {
							tbgModuleEntry._refreshList();
							tbgModuleEntry.keys.releaseKeys();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs321);
	
	var objGiacs321 = {};
	var objCurrModuleEntry = null;
	objGiacs321.moduleEntryList = JSON.parse('${jsonModuleEntry}');
	objGiacs321.exitPage = null;
	
	var moduleEntryTable = {
			url : contextPath + "/GIACModuleEntryController?action=showGiacs321&refresh=1",
			options : {
				width : '671px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					$("hidItemNo").value = tbgModuleEntry.geniisysRows[y].itemNo;
					rowIndex = y;
					objCurrModuleEntry = tbgModuleEntry.geniisysRows[y];
					setFieldValues(objCurrModuleEntry);
					tbgModuleEntry.keys.removeFocus(tbgModuleEntry.keys._nCurrentFocus, true);
					tbgModuleEntry.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					$("hidItemNo").value = null;
					rowIndex = -1;
					setFieldValues(null);
					tbgModuleEntry.keys.removeFocus(tbgModuleEntry.keys._nCurrentFocus, true);
					tbgModuleEntry.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgModuleEntry.keys.removeFocus(tbgModuleEntry.keys._nCurrentFocus, true);
						tbgModuleEntry.keys.releaseKeys();
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
					tbgModuleEntry.keys.removeFocus(tbgModuleEntry.keys._nCurrentFocus, true);
					tbgModuleEntry.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgModuleEntry.keys.removeFocus(tbgModuleEntry.keys._nCurrentFocus, true);
					tbgModuleEntry.keys.releaseKeys();
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
					tbgModuleEntry.keys.removeFocus(tbgModuleEntry.keys._nCurrentFocus, true);
					tbgModuleEntry.keys.releaseKeys();
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
				    id : 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width : '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : 'itemNo',
					title : 'Item No.',
					titleAlign : 'right',
					width : '70px',
					align : 'right',
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					renderer : function(value){
						if(value != ""){
							return formatNumberDigits(value, 3);	
						}
					}
				},
				{
					id : 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
					title : 'GL Account No.',
					titleAlign : 'right',
					width : '210px',
					children : [
						{
							id : 'glAcctCategory',
							title : 'GL Account Category',
							width : 30,
							align: 'right',
							filterOption : true,
							filterOptionType : 'integerNoNegative'
						},
						{
							id : 'glControlAcct',
							title : 'GL Control Account',
							width : 30,
							align: 'right',
							filterOption : true,
							filterOptionType : 'integerNoNegative',
							renderer : function(value){
								return formatNumberDigits(value, 2);
							}
						},
						{
							id : 'glSubAcct1',
							title : 'GL Sub Account 1',
							width : 30,
							align: 'right',
							filterOption : true,
							filterOptionType : 'integerNoNegative',
							renderer : function(value){
								return formatNumberDigits(value, 2);
							}
						},
						{
							id : 'glSubAcct2',
							title : 'GL Sub Account 2',
							width : 30,
							align: 'right',
							filterOption : true,
							filterOptionType : 'integerNoNegative',
							renderer : function(value){
								return formatNumberDigits(value, 2);
							}
						},
						{
							id : 'glSubAcct3',
							title : 'GL Sub Account 3',
							width : 30,
							align: 'right',
							filterOption : true,
							filterOptionType : 'integerNoNegative',
							renderer : function(value){
								return formatNumberDigits(value, 2);
							}
						},
						{
							id : 'glSubAcct4',
							title : 'GL Sub Account 4',
							width : 30,
							align: 'right',
							filterOption : true,
							filterOptionType : 'integerNoNegative',
							renderer : function(value){
								return formatNumberDigits(value, 2);
							}
						},
						{
							id : 'glSubAcct5',
							title : 'GL Sub Account 5',
							width : 30,
							align: 'right',
							filterOption : true,
							filterOptionType : 'integerNoNegative',
							renderer : function(value){
								return formatNumberDigits(value, 2);
							}
						},
						{
							id : 'glSubAcct6',
							title : 'GL Sub Account 6',
							width : 30,
							align: 'right',
							filterOption : true,
							filterOptionType : 'integerNoNegative',
							renderer : function(value){
								return formatNumberDigits(value, 2);
							}
						},
						{
							id : 'glSubAcct7',
							title : 'GL Sub Account 7',
							width : 30,
							align: 'right',
							filterOption : true,
							filterOptionType : 'integerNoNegative',
							renderer : function(value){
								return formatNumberDigits(value, 2);
							}
						}
					            ]					
				},
				{
					id : 'slTypeCd',
					title : 'SL',
					altTitle : 'SL Type Code',
					width : '30px',
					filterOption : true
				},
				{
					id : 'lineDependencyLevel',
					title : 'L',
					altTitle : 'Line Dependency Level',
					titleAlign : 'right',
					align : 'right',
					width : '30px',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'sublineLevel',
					title : 'S',
					altTitle : 'Subline Dependency Level',
					titleAlign : 'right',
					align : 'right',
					width : '30px',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'branchLevel',
					title : 'B',
					altTitle : 'Branch Dependency Level',
					titleAlign : 'right',
					align : 'right',
					width : '30px',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'intmTypeLevel',
					title : 'I',
					altTitle : 'Intermediary Type Level',
					titleAlign : 'right',
					align : 'right',
					width : '30px',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'caTreatyTypeLevel',
					title : 'T',
					altTitle : 'Treaty Type Level',
					titleAlign : 'right',
					align : 'right',
					width : '30px',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'oldNewAcctLevel',
					title : 'O',
					altTitle : 'Old / New Account Level',
					titleAlign : 'right',
					align : 'right',
					width : '30px',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'drCrTag',
					title : 'D',
					altTitle : 'Debit / Credit Tag',
					width : '30px',
					filterOption : true
				},
				{
					id : 'polTypeTag',
					title : 'P',
					altTitle : 'Policy Type Tag',
					align : 'center',
					width : '30px',
					filterOption : true,
					filterOptionType : 'checkbox',
					editor: new MyTableGrid.CellCheckbox({
						getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	},
		            })
				},
			],
			rows : objGiacs321.moduleEntryList.rows
		};

		tbgModuleEntry = new MyTableGrid(moduleEntryTable);
		tbgModuleEntry.pager = objGiacs321.moduleEntryList;
		tbgModuleEntry.render("moduleEntryTable");
		tbgModuleEntry.afterRender = function(){
			try{
				if(tbgModuleEntry.geniisysRows.length > 0){
					$("hidMaxItemNo").value = parseFloat(tbgModuleEntry.geniisysRows[0].maxItemNo) + 1;
				}else{
					$("hidMaxItemNo").value = 1;
				}
			}catch(e){
				showErrorMessage("tbgModuleEntry.afterRender", e);
			}
		};
		
		function executeQuery(){
			if(checkAllRequiredFieldsInDiv("moduleNameDiv")) {			
				tbgModuleEntry.url = contextPath + "/GIACModuleEntryController?action=showGiacs321&refresh=1&moduleId="+$F("hidModuleId");
				tbgModuleEntry._refreshList();
				setForm(true);
				$("txtModuleName").setAttribute("readonly", "readonly");
				disableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarSave");
				disableSearch("imgModuleName");
				if(tbgModuleEntry.geniisysRows.length == 0){
					showMessageBox("Query caused no records to be retrieved.", "I");
				}
			}
		}
		
		$("btnToolbarExecuteQuery").observe("click", executeQuery);
		
		function setForm(enable){
			if(enable){
				$("txtGlAcctCategory").readOnly = false;
				$("txtGlControlAcct").readOnly = false;
				$("txtGlSubAcct1").readOnly = false;
				$("txtGlSubAcct2").readOnly = false;
				$("txtGlSubAcct3").readOnly = false;
				$("txtGlSubAcct4").readOnly = false;
				$("txtGlSubAcct5").readOnly = false;
				$("txtGlSubAcct6").readOnly = false;
				$("txtGlSubAcct7").readOnly = false;
				$("txtSlTypeCd").readOnly = false;
				$("txtLineDependencyLevel").readOnly = false;
				$("txtSublineLevel").readOnly = false;
				$("txtBranchLevel").readOnly = false;
				$("txtIntmTypeLevel").readOnly = false;
				$("txtCaTreatyType").readOnly = false;
				$("txtOldNewAcctLevel").readOnly = false;
				$("txtRemarks").readOnly = false;
				$("selDrCrTag").disabled = false;
				$("chkPolTypeTag").disabled = false;				
				enableButton("btnAdd");
			} else {
				$("txtGlAcctCategory").readOnly = true;
				$("txtGlControlAcct").readOnly = true;
				$("txtGlSubAcct1").readOnly = true;
				$("txtGlSubAcct2").readOnly = true;
				$("txtGlSubAcct3").readOnly = true;
				$("txtGlSubAcct4").readOnly = true;
				$("txtGlSubAcct5").readOnly = true;
				$("txtGlSubAcct6").readOnly = true;
				$("txtGlSubAcct7").readOnly = true;
				$("txtSlTypeCd").readOnly = true;
				$("txtLineDependencyLevel").readOnly = true;
				$("txtSublineLevel").readOnly = true;
				$("txtBranchLevel").readOnly = true;
				$("txtIntmTypeLevel").readOnly = true;
				$("txtCaTreatyType").readOnly = true;
				$("txtOldNewAcctLevel").readOnly = true;
				$("txtRemarks").readOnly = true;
				$("selDrCrTag").disabled = true;
				$("chkPolTypeTag").disabled = true;				
				disableButton("btnAdd");
				disableButton("btnDelete");
			}
		}
		
		function enterQuery(){
			function proceedEnterQuery(){
				disableToolbarButton("btnToolbarExecuteQuery");
				disableToolbarButton("btnToolbarSave");
				$("hidModuleId").value = "";
				$("txtModuleName").value = "";
				$("txtModuleName").setAttribute("lastValidValue", "");
				$("txtScrnRepName").value = "";
				$("txtGlAcctCategory").value = "";
				$("txtGlControlAcct").value = "";
				$("txtGlSubAcct1").value = "";
				$("txtGlSubAcct2").value = "";
				$("txtGlSubAcct3").value = "";
				$("txtGlSubAcct4").value = "";
				$("txtGlSubAcct5").value = "";
				$("txtGlSubAcct6").value = "";
				$("txtGlSubAcct7").value = "";
				$("txtSlTypeCd").value = "";
				$("txtLineDependencyLevel").value = "";
				$("txtSublineLevel").value = "";
				$("txtBranchLevel").value = "";
				$("txtIntmTypeLevel").value = "";
				$("txtCaTreatyType").value = "";
				$("txtOldNewAcctLevel").value = "";
				$("txtRemarks").value = "";
				$("chkPolTypeTag").disabled = false;	
				enableSearch("imgModuleName");
				tbgModuleEntry.url = contextPath + "/GIACModuleEntryController?action=showGiacs321&refresh=1&moduleId="+$F("hidModuleId");;
				tbgModuleEntry._refreshList();
				setFieldValues(null);
				$("txtModuleName").focus();
				$("txtModuleName").removeAttribute("readonly");
				enableSearch("imgModuleName");
				disableToolbarButton("btnToolbarEnterQuery");
				setForm(false);
				changeTag = 0;
			}
			
			if(changeTag == 1){
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
							saveGiacs321();
							proceedEnterQuery();
						}, function(){
							proceedEnterQuery();
						}, "");
			} else {
				proceedEnterQuery();
			}		
		}
		
		$("btnToolbarEnterQuery").observe("click", enterQuery);
		
		function showGiacs321GiacModulesLOV(){
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {action : "getGiacs321GiacModulesLOV",
								filterText : ($("txtModuleName").readAttribute("lastValidValue").trim() != $F("txtModuleName").trim() ? $F("txtModuleName").trim() : "%"),
								page : 1},
				title: "List of Modules",
				width: 440,
				height: 386,
				columnModel : [
								{
									id : "moduleName",
									title: "Module Name",
									width: '100px',
									filterOption: true,
									renderer: function(value) {
										return unescapeHTML2(value);
									}
								},
								{
									id : "scrnRepName",
									title: "Screen Rep Name",
									width: '325px',
									renderer: function(value) {
										return unescapeHTML2(value);
									}
								}
							],
					autoSelectOneRecord: true,
					filterText : ($("txtModuleName").readAttribute("lastValidValue").trim() != $F("txtModuleName").trim() ? $F("txtModuleName").trim() : ""),
					onSelect: function(row) {
						$("hidModuleId").value = unescapeHTML2(row.moduleId);
						$("txtModuleName").value = unescapeHTML2(row.moduleName);
						$("txtScrnRepName").value = unescapeHTML2(row.scrnRepName);
						$("txtModuleName").setAttribute("lastValidValue", unescapeHTML2(row.moduleName));	
						$("txtGlAcctCategory").focus();
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					},
					onCancel: function (){
						$("txtModuleName").value = $("txtModuleName").readAttribute("lastValidValue");
					},
					onUndefinedRow : function(){
						showMessageBox("No record selected.", "I");
						$("txtModuleName").value = $("txtModuleName").readAttribute("lastValidValue");
					},
					onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			  });
		}
		
	$("imgModuleName").observe("click", showGiacs321GiacModulesLOV);
	$("txtModuleName").observe("keyup", function(){
		$("txtModuleName").value = $F("txtModuleName").toUpperCase();
	});
	$("txtModuleName").observe("change", function() {
		if($F("txtModuleName").trim() == "") {
			$("txtModuleName").value = "";
			$("txtModuleName").setAttribute("lastValidValue", "");
			$("txtScrnRepName").value = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtModuleName").trim() != "" && $F("txtModuleName") != $("txtModuleName").readAttribute("lastValidValue")) {
				showGiacs321GiacModulesLOV();
			}
		}
	});
	
	function setFieldValues(rec){
		try{
			$("txtItemNo").value = (rec == null ? "" : formatNumberDigits(rec.itemNo, 3));
			$("txtGlAcctCategory").value = (rec == null ? "" : rec.glAcctCategory);
			$("txtGlControlAcct").value = (rec == null ? "" : rec.glControlAcct == null ? formatNumberDigits(0, 2) : formatNumberDigits(rec.glControlAcct, 2));
			$("txtGlSubAcct1").value = (rec == null ? "" : rec.glSubAcct1 == null ? formatNumberDigits(0, 2) : formatNumberDigits(rec.glSubAcct1, 2));
			$("txtGlSubAcct2").value = (rec == null ? "" : rec.glSubAcct2 == null ? formatNumberDigits(0, 2) : formatNumberDigits(rec.glSubAcct2, 2));
			$("txtGlSubAcct3").value = (rec == null ? "" : rec.glSubAcct3 == null ? formatNumberDigits(0, 2) : formatNumberDigits(rec.glSubAcct3, 2));
			$("txtGlSubAcct4").value = (rec == null ? "" : rec.glSubAcct4 == null ? formatNumberDigits(0, 2) : formatNumberDigits(rec.glSubAcct4, 2));
			$("txtGlSubAcct5").value = (rec == null ? "" : rec.glSubAcct5 == null ? formatNumberDigits(0, 2) : formatNumberDigits(rec.glSubAcct5, 2));
			$("txtGlSubAcct6").value = (rec == null ? "" : rec.glSubAcct6 == null ? formatNumberDigits(0, 2) : formatNumberDigits(rec.glSubAcct6, 2));
			$("txtGlSubAcct7").value = (rec == null ? "" : rec.glSubAcct7 == null ? formatNumberDigits(0, 2) : formatNumberDigits(rec.glSubAcct7, 2));
			$("txtSlTypeCd").value = (rec == null ? "" : unescapeHTML2(rec.slTypeCd));
			$("txtLineDependencyLevel").value = (rec == null ? "" : rec.lineDependencyLevel);
			$("txtSublineLevel").value = (rec == null ? "" : rec.sublineLevel);
			$("txtBranchLevel").value = (rec == null ? "" : rec.branchLevel);
			$("txtIntmTypeLevel").value = (rec == null ? "" : rec.intmTypeLevel);
			$("txtCaTreatyType").value = (rec == null ? "" : rec.caTreatyTypeLevel);
			$("txtOldNewAcctLevel").value = (rec == null ? "" : rec.oldNewAcctLevel);
			$("chkPolTypeTag").checked = (rec == null ? false : rec.polTypeTag == "Y" ? true : false);
			$("selDrCrTag").selectedIndex = (rec == null ? 0 : rec.drCrTag == "D" ? 0 : 1);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.description));
			$("txtUserId").value = (rec == null ? "" : rec.userId);
			$("txtLastUpdate").value = (rec == null ? "" : dateFormat(rec.lastUpdate, 'mm-dd-yyyy hh:MM:ss TT'));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrModuleEntry = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.moduleId = $F("hidModuleId");
			obj.glAcctCategory = $F("txtGlAcctCategory");
			obj.glControlAcct = $F("txtGlControlAcct");
			obj.glSubAcct1 = $F("txtGlSubAcct1");
			obj.glSubAcct2 = $F("txtGlSubAcct2");
			obj.glSubAcct3 = nvl($F("txtGlSubAcct3"),0);
			obj.glSubAcct4 = $F("txtGlSubAcct4");
			obj.glSubAcct5 = $F("txtGlSubAcct5");
			obj.glSubAcct6 = $F("txtGlSubAcct6");
			obj.glSubAcct7 = $F("txtGlSubAcct7");
			obj.slTypeCd = escapeHTML2($F("txtSlTypeCd"));
			obj.lineDependencyLevel = $F("txtLineDependencyLevel");
			obj.sublineLevel = $F("txtSublineLevel");
			obj.branchLevel = $F("txtBranchLevel");
			obj.intmTypeLevel = $F("txtIntmTypeLevel");
			obj.caTreatyTypeLevel = $F("txtCaTreatyType");
			obj.oldNewAcctLevel = $F("txtOldNewAcctLevel");
			obj.polTypeTag = $("chkPolTypeTag").checked ? "Y" : "N";
			obj.drCrTag = $("selDrCrTag").selectedIndex == 0 ? "D" : "C";
			obj.description = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			if($F("btnAdd") == "Add"){
				obj.itemNo = $F("hidMaxItemNo");
				$("hidMaxItemNo").value = parseFloat($("hidMaxItemNo").value) + 1;
			}
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs321;
			var dept = setRec(objCurrModuleEntry);
			if($F("btnAdd") == "Add"){
				tbgModuleEntry.addBottomRow(dept);
			} else {
				tbgModuleEntry.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgModuleEntry.keys.removeFocus(tbgModuleEntry.keys._nCurrentFocus, true);
			tbgModuleEntry.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("moduleEntryTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					new Ajax.Request(contextPath + "/GIACModuleEntryController", {
						parameters : {action : "valAddRec",
									  moduleId : $F("hidModuleId"),
									  itemNo : $F("hidMaxItemNo")},
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
		/* changeTagFunc = saveGiacs321;
		objCurrModuleEntry.recordStatus = -1;
		tbgModuleEntry.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null); */
		showMessageBox("You cannot delete this record.", "I");
	}
	
	function valDeleteRec(){
		try{
			/* new Ajax.Request(contextPath + "/GIACModuleEntryController", {
				parameters : {action : "valDeleteRec",
							  moduleId : $F("hidModuleId"),
						  	  itemNo : $F("hidItemNo")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			}); */
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs321(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiacs321.exitPage = exitPage;
						saveGiacs321();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");	
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 200, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtSlTypeCd").observe("keyup", function(){
		$("txtSlTypeCd").value = $F("txtSlTypeCd").toUpperCase();
	});
	$$("input[name='glAcctNo']").each(function(a){
		validateGLAcctNumberFields(a.id, $(a.id).readAttribute("textValue"), $(a.id).readAttribute("maxlength"));
	});
	function validateGLAcctNumberFields(id, text, maxLength){
		var text2 = "";
		$(id).observe("change", function(){
			if(isNaN($F(id))){
				if(parseFloat(maxLength) == 1){
					text2 = "0 to 9.";
				}else if(parseFloat(maxLength) == 2){
					text2 = "0 to 99.";
				}
				customShowMessageBox("Invalid "+text+".  Valid value should be from "+text2, "I", id);
				$(id).clear();
			}else{
				$(id).value = formatNumberDigits($F(id), parseFloat(maxLength));		
			}
		});	
	}
	
	$("txtIntmTypeLevel").observe("focus", function(){
		$("txtIntmTypeLevel").setAttribute("lastValidValue", $F("txtIntmTypeLevel"));
	});
	$("txtIntmTypeLevel").observe("change", function(){
		if((isNaN($F("txtIntmTypeLevel"))) || (parseFloat($F("txtIntmTypeLevel")) > 7)){
			customShowMessageBox("Invalid Intermediary Type Level.  Valid value should be from 0 to 7", "I", "txtIntmTypeLevel");
			$("txtIntmTypeLevel").value = $("txtIntmTypeLevel").readAttribute("lastValidValue");
		}
	});
	
	$("txtOldNewAcctLevel").observe("focus", function(){
		$("txtOldNewAcctLevel").setAttribute("lastValidValue", $F("txtOldNewAcctLevel"));
	});
	$("txtOldNewAcctLevel").observe("change", function(){
		if((isNaN($F("txtOldNewAcctLevel"))) || (parseFloat($F("txtOldNewAcctLevel")) > 7)){
			customShowMessageBox("Invalid Old/New Account Level.  Valid value should be from 0 to 7", "I", "txtOldNewAcctLevel");
			$("txtOldNewAcctLevel").value = $("txtOldNewAcctLevel").readAttribute("lastValidValue");
		}
	});
	
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarSave");
	disableButton("btnDelete");
	setForm(false);
	observeSaveForm("btnSave", saveGiacs321);
	$("btnToolbarSave").observe("click", saveGiacs321);
	$("btnCancel").observe("click", cancelGiacs321);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);

	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtModuleName").focus();	
</script>
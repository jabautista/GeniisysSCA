<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs312MainDiv" name="giacs312MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   	<label>Bank Account Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs312" name="giacs312">
		<div class="sectionDiv" id="giacs312">
			<div id="bankAccountDiv" style="padding-top: 10px;">
				<div id="bankAccountTable" style="height: 300px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="bankAccountFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="hidBankCd" name="hidBankCd" type="hidden">
							<input id="txtBankAcctCd" type="text" style="width: 255px; text-align: right;" tabindex="201" maxlength="3" readonly="readonly">
						</td>
						<td class="rightAligned" width="105">Bank Short Name</td>
						<td width="150" class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 261px; margin-top: 2px; height: 21px;">
								<input ignoreDelKey="" class="required" type="text" id="txtDspBankSname" name="txtDspBankSname" style="width: 230px; float: left; border: none; height: 15px; margin: 0;" maxlength="10" tabindex="202" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBank" name="imgSearchBank" alt="Go" style="float: right;" tabindex="203"/>
							</span>
						<td class="leftAligned"></td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Bank Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtDspBankName" type="text" class="" style="width: 660px;" tabindex="204" maxlength="100" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Bank Branch</td>
						<td class="leftAligned">
							<input id="txtBranchBank" class="required" type="text" style="width: 255px;" tabindex="205" maxlength="30">
						</td>
						<td class="rightAligned">Bank Account No</td>
						<td width="150" class="leftAligned">
							<input id="txtBankAcctNo" class="required" type="text" style="width: 255px;" tabindex="206" maxlength="30">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch Code</td>
						<td class="leftAligned">
							<span class="lovSpan" style="float: left; width: 50px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input ignoreDelKey="" class="" type="text" id="txtBranchCd" name="txtBranchCd" style="width: 25px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="207" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchCd" name="imgSearchBranchCd" alt="Go" style="float: right;" tabindex="208"/>
							</span>
							<input id="txtDspBranchName" name="txtDspBranchName" type="text" style="width: 198px;" value="" readonly="readonly" tabindex="209"/>
						</td>
						<td class="rightAligned"></td>
						<td width="150" class="leftAligned">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Account Type</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 50px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input ignoreDelKey="" class="required" type="text" id="txtBankAcctType" name="txtBankAcctType" style="width: 25px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="210" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBankAcctType" name="imgSearchBankAcctType" alt="Go" style="float: right;" tabindex="211"/>
							</span>
							<input id="txtDspBankAcctType" name="txtDspBankAcctType" type="text" style="width: 198px;" value="" readonly="readonly" tabindex="212"/>
						</td>
						<td class="rightAligned">Account Status</td>
						<td width="150" class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 50px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input ignoreDelKey="" class="required" type="text" id="txtBankAcctFlag" name="txtBankAcctFlag" style="width: 25px; float: left; border: none; height: 15px; margin: 0;" maxlength="1" tabindex="213" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBankAcctFlag" name="imgSearchBankAcctFlag" alt="Go" style="float: right;" tabindex="214"/>
							</span>
							<input id="txtDspBankAcctFlag" name="txtDspBankAcctFlag" type="text" style="width: 198px;" value="" readonly="readonly" tabindex="215"/>
						</td>
					</tr>					
					<tr>
						<td class="rightAligned">Opening Date</td>
						<td class="leftAligned">
							<div style="float: left; width: 261px; height: 22px; margin: 0px;" class="withIconDiv required">
								<input type="text" id="txtOpeningDate" name="txtOpeningDate" class="withIcon required" style="width: 234px; height: 15px;" tabindex="216" maxlength="10" lastValidValue=""/>
								<img id="hrefOpeningDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Go" tabindex="217"/>
							</div>
						</td>
						<td class="rightAligned">Closing Date</td>
						<td width="" class="leftAligned">
							<div style="float: left; width: 261px; height: 22px; margin: 0px;" class="withIconDiv">
								<input type="text" id="txtClosingDate" name="txtClosingDate" class="withIcon" style="width: 234px; height: 15px;" tabindex="218" maxlength="10" lastValidValue=""/>
								<img id="hrefClosingDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Go" tabindex="219"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="">GL Account Code</td>
						<td class="leftAligned" style="">
							<div id="glCodeDiv" style="float: left;">
								<input type="hidden" id="hidGlAcctId">
								<input type="hidden" id="hidGlAccountCode">
								<input type="text" style="width: 17.8px; text-align: right;" id="txtDspGlAcctCategory" name="glAccountCode" value="" class="required glAC integerNoNegativeUnformattedNoComma" maxlength="1" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="9" customLabel="GL Account Category" tabindex="220"/>
								<input type="text" style="width: 17.8px; text-align: right;" id="txtDspGlControlAcct" 	name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Control Account" tabindex="221"/>
								<input type="text" style="width: 17.8px; text-align: right;" id="txtDspGlSubAcct1" 	name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 1" tabindex="222"/>
								<input type="text" style="width: 17.8px; text-align: right;" id="txtDspGlSubAcct2" 	name="glAccountCode"	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 2" tabindex="223"/>
								<input type="text" style="width: 17.8px; text-align: right;" id="txtDspGlSubAcct3"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 3" tabindex="224"/>
								<input type="text" style="width: 17.8px; text-align: right;" id="txtDspGlSubAcct4"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 4" tabindex="225"/>
								<input type="text" style="width: 17.8px; text-align: right;" id="txtDspGlSubAcct5"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 5" tabindex="226"/>
								<input type="text" style="width: 17.8px; text-align: right;" id="txtDspGlSubAcct6"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 6" tabindex="227"/>
								<input type="text" style="width: 17.8px; text-align: right;" id="txtDspGlSubAcct7"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 7" tabindex="228"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchGl" name="imgSearchGl" alt="Search" style="margin-left: 3px; cursor: pointer;" tabindex="229"/>
							</div>
						</td>
						<td class="rightAligned" style="">SL Type Code</td>
						<td class="leftAligned" style="">
							<input type="text" id="txtSlTypeCd" name="txtSlTypeCd" style="width: 45px;" maxlength="4" tabindex="230" lastValidValue="" readonly="readonly"/>
							<input id="txtDspSlTypeName" name="txtDspSlTypeName" type="text" style="width: 198px;" value="" readonly="readonly" tabindex="231" lastValidValue=""/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="">Account Name</td>
						<td class="leftAligned" style="" colspan="3">
							<input type="text" style="width: 660px;" id="txtDspGlAcctName" name="txtDspGlAcctName" value="" class="" readonly="readonly" tabindex=232/>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 666px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 635px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="233"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="234"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 255px;" readonly="readonly" tabindex="235"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 255px;" readonly="readonly" tabindex="236"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="237">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="238">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="229">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="230">
</div>
<script type="text/javascript">	
	disableButton("btnDelete");
	setModuleId("GIACS312");
	setDocumentTitle("Bank Account Maintenance");
	initializeAll();	
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs312(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgBankAccount.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBankAccount.geniisysRows);
		new Ajax.Request(contextPath+"/GIACBankAccountsController", {
			method: "POST",
			parameters : {action : "saveGiacs312",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS312.exitPage != null) {
							objGIACS312.exitPage();
						} else {
							tbgBankAccount._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs312);
	
	var objGIACS312 = {};
	objGIACS312.bankAccount = JSON.parse('${jsonBankAccountList}');
	var objCurrBankAccount = null;
	objGIACS312.exitPage = null;
	
	var bankAccountTable = {
			url : contextPath + "/GIACBankAccountsController?action=showGiacs312&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrBankAccount = tbgBankAccount.geniisysRows[y];
					setFieldValues(objCurrBankAccount);
					tbgBankAccount.keys.removeFocus(tbgBankAccount.keys._nCurrentFocus, true);
					tbgBankAccount.keys.releaseKeys();
					$("txtBankAcctCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBankAccount.keys.removeFocus(tbgBankAccount.keys._nCurrentFocus, true);
					tbgBankAccount.keys.releaseKeys();
					$("txtBankAcctCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgBankAccount.keys.removeFocus(tbgBankAccount.keys._nCurrentFocus, true);
						tbgBankAccount.keys.releaseKeys();
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
					tbgBankAccount.keys.removeFocus(tbgBankAccount.keys._nCurrentFocus, true);
					tbgBankAccount.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBankAccount.keys.removeFocus(tbgBankAccount.keys._nCurrentFocus, true);
					tbgBankAccount.keys.releaseKeys();
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
					tbgBankAccount.keys.removeFocus(tbgBankAccount.keys._nCurrentFocus, true);
					tbgBankAccount.keys.releaseKeys();
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
					id : "bankAcctCd",
					title : "Code",
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					width : '55px',
					align : 'right',
					titleAlign : 'right'
				},
				{
					id : 'dspBankSname',
					filterOption : true,
					title : 'Bank Short Name',
					width : '100px'				
				},
				{
					id : 'dspBankName',
					filterOption : true,
					title : 'Bank Name',
					width : '440px'				
				},
				{
					id : 'branchBank',
					filterOption : true,
					title : 'Branch',
					width : '110px'
				},
				{
					id : 'bankAcctNo',
					filterOption : true,
					title : 'Bank Account No',
					width : '110px'
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
				},
				{
					id : 'strOpeningDate',
					width : '0',
					visible: false				
				},
				{
					id : 'strClosingDate',
					width : '0',
					visible: false		
				},
				{
					id : 'bankCd',
					width : '0',
					visible: false				
				},
				{
					id : 'branchCd',
					width : '0',
					visible: false				
				},
				{
					id : 'dspBranchName',
					width : '0',
					visible: false				
				},
				{
					id : 'bankAcctType',
					width : '0',
					visible: false
				},
				{
					id : 'dspBankAcctType',
					width : '0',
					visible: false
				},
				{
					id : 'bankAcctFlag',
					width : '0',
					visible: false
				},
				{
					id : 'dspBankAcctFlag',
					width : '0',
					visible: false
				},
				{
					id : 'slCd',
					width : '0',
					visible: false				
				},
				{
					id : 'dspSlTypeName',
					width : '0',
					visible: false				
				},
				{
					id : 'glAcctId',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlAcctCategory',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct1',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct2',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct3',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct4',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct5',
					width : '0',
					visible: false
				},
				{
					id : 'dspGlSubAcct6',
					width : '0',
					visible: false
				},
				{
					id : 'dspGlSubAcct7',
					width : '0',
					visible: false
				},
				{
					id : 'dspGlAcctName',
					width : '0',
					visible: false		
				}
			],
			rows : objGIACS312.bankAccount.rows
		};

		tbgBankAccount = new MyTableGrid(bankAccountTable);
		tbgBankAccount.pager = objGIACS312.bankAccount;
		tbgBankAccount.render("bankAccountTable");	
	
	function setFieldValues(rec){
		try{
			$("hidBankCd").value = (rec == null ? "" : rec.bankCd);
			$("txtBankAcctCd").value = (rec == null ? "" : rec.bankAcctCd);
			$("txtBankAcctCd").setAttribute("lastValidValue", (rec == null ? "" : rec.bankAcctCd));
			$("txtDspBankName").value = (rec == null ? "" : unescapeHTML2(rec.dspBankName));
			$("txtDspBankSname").value = (rec == null ? "" : unescapeHTML2(rec.dspBankSname));
			$("txtDspBankSname").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspBankSname)));
			$("txtBranchBank").value = (rec == null ? "" : unescapeHTML2(rec.branchBank));
			$("txtBankAcctNo").value = (rec == null ? "" : unescapeHTML2(rec.bankAcctNo));
			$("txtOpeningDate").value = (rec == null ? "" : rec.strOpeningDate);
			$("txtOpeningDate").setAttribute("lastValidValue", (rec == null ? "" : rec.strOpeningDate));
			$("txtClosingDate").value = (rec == null ? "" : rec.strClosingDate);
			$("txtClosingDate").setAttribute("lastValidValue", (rec == null ? "" : rec.strClosingDate));
			$("txtBranchCd").value = (rec == null ? "" : unescapeHTML2(rec.branchCd));
			$("txtBranchCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.branchCd)));
			$("txtDspBranchName").value = (rec == null ? "" : unescapeHTML2(rec.dspBranchName));
			$("txtBankAcctType").value = (rec == null ? "" : rec.bankAcctType);
			$("txtBankAcctType").setAttribute("lastValidValue", (rec == null ? "" : rec.bankAcctType));
			$("txtDspBankAcctType").value = (rec == null ? "" : unescapeHTML2(rec.dspBankAcctType));
			$("txtBankAcctFlag").value = (rec == null ? "" : rec.bankAcctFlag);
			$("txtBankAcctFlag").setAttribute("lastValidValue", (rec == null ? "" : rec.bankAcctFlag));
			$("txtDspBankAcctFlag").value = (rec == null ? "" : unescapeHTML2(rec.dspBankAcctFlag));
			$("txtSlTypeCd").value = (rec == null ? "" : rec.slCd);
			$("txtDspSlTypeName").value = (rec == null ? "" : unescapeHTML2(rec.dspSlTypeName));
			$("hidGlAcctId").value = (rec == null ? "" : rec.glAcctId);
			
			
			$("txtDspGlAcctName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspGlAcctName)));
			$("hidGlAccountCode").value = (rec == null ? "" : rec.dspGlAcctCategory +
															  formatNumberDigits(rec.dspGlControlAcct, 2) +
															  formatNumberDigits(rec.dspGlSubAcct1, 2) +
															  formatNumberDigits(rec.dspGlSubAcct2, 2) +
															  formatNumberDigits(rec.dspGlSubAcct3, 2) +
															  formatNumberDigits(rec.dspGlSubAcct4, 2) +
															  formatNumberDigits(rec.dspGlSubAcct5, 2) +
															  formatNumberDigits(rec.dspGlSubAcct6, 2) +
															  formatNumberDigits(rec.dspGlSubAcct7, 2));
			
			$("txtDspGlAcctCategory").value = (rec == null ? "" : rec.dspGlAcctCategory);
			$("txtDspGlControlAcct").value = (rec == null ? "" : formatNumberDigits(rec.dspGlControlAcct, 2));
			$("txtDspGlSubAcct1").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct1, 2));
			$("txtDspGlSubAcct2").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct2, 2));
			$("txtDspGlSubAcct3").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct3, 2));
			$("txtDspGlSubAcct4").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct4, 2));
			$("txtDspGlSubAcct5").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct5, 2));
			$("txtDspGlSubAcct6").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct6, 2));
			$("txtDspGlSubAcct7").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct7, 2));
			$("txtDspGlAcctName").value = (rec == null ? "" : unescapeHTML2(rec.dspGlAcctName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? $("txtDspBankSname").readOnly = false : $("txtDspBankSname").readOnly = true;
			rec == null ? enableSearch("imgSearchBank") : disableSearch("imgSearchBank");
			objCurrBankAccount = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function addRec(){
		function setRec(rec){
			try {				
				var obj = (rec == null ? {} : rec);
				obj.bankCd = $F("hidBankCd");
				obj.bankAcctCd = $F("txtBankAcctCd");
				obj.dspBankName = escapeHTML2($F("txtDspBankName"));
				obj.dspBankSname = escapeHTML2($F("txtDspBankSname"));
				obj.branchBank = escapeHTML2($F("txtBranchBank"));
				obj.bankAcctNo = escapeHTML2($F("txtBankAcctNo"));
				obj.branchCd = escapeHTML2($F("txtBranchCd"));
				obj.dspBranchName = escapeHTML2($F("txtDspBranchName"));
				obj.bankAcctType = $F("txtBankAcctType");
				obj.dspBankAcctType = escapeHTML2($F("txtDspBankAcctType"));
				obj.bankAcctFlag = $F("txtBankAcctFlag");
				obj.dspBankAcctFlag = escapeHTML2($F("txtDspBankAcctFlag"));
				obj.strOpeningDate = $F("txtOpeningDate");
				obj.strClosingDate = ($F("txtClosingDate") == "" ? null : $F("txtClosingDate"));				
				obj.glAcctId = $F("hidGlAcctId");
 				obj.slCd = $F("txtSlTypeCd");
				obj.dspSlTypeName = escapeHTML2($F("txtDspSlTypeName"));
				obj.dspGlAcctCategory = $F("txtDspGlAcctCategory");
				obj.dspGlControlAcct = $F("txtDspGlControlAcct");
				obj.dspGlSubAcct1 = $F("txtDspGlSubAcct1");
				obj.dspGlSubAcct2 = $F("txtDspGlSubAcct2");
				obj.dspGlSubAcct3 = $F("txtDspGlSubAcct3");
				obj.dspGlSubAcct4 = $F("txtDspGlSubAcct4");
				obj.dspGlSubAcct5 = $F("txtDspGlSubAcct5");
				obj.dspGlSubAcct6 = $F("txtDspGlSubAcct6");
				obj.dspGlSubAcct7 = $F("txtDspGlSubAcct7");
				obj.dspGlAcctName = $F("txtDspGlAcctName");
				obj.remarks = escapeHTML2($F("txtRemarks"));
				obj.userId = userId;
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				
				return obj;
				
			} catch(e){
				showErrorMessage("setRec", e);
			}
		}
		
		try {
			changeTagFunc = saveGiacs312;
			var rec = setRec(objCurrBankAccount);
			if($F("btnAdd") == "Add"){
				tbgBankAccount.addBottomRow(rec);
			} else {
				tbgBankAccount.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgBankAccount.keys.removeFocus(tbgBankAccount.keys._nCurrentFocus, true);
			tbgBankAccount.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("bankAccountFormDiv")){					
				if($F("btnAdd") == "Add") {
					addRec();
// 					var addedSameExists = false;
// 					var deletedSameExists = false;					
					
// 					for(var i=0; i<tbgBankAccount.geniisysRows.length; i++){
// 						if(tbgBankAccount.geniisysRows[i].recordStatus == 0 || tbgBankAccount.geniisysRows[i].recordStatus == 1){								
// 							if(tbgBankAccount.geniisysRows[i].bankAcctCd == $F("txtBankAcctCd")){
// 								addedSameExists = true;								
// 							}							
// 						} else if(tbgBankAccount.geniisysRows[i].recordStatus == -1){
// 							if(tbgBankAccount.geniisysRows[i].bankAcctCd == $F("txtBankAcctCd")){
// 								deletedSameExists = true;
// 							}
// 						}
// 					}
					
// 					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
// 						showMessageBox("Record already exists with the same bank_acct_cd.", "E");
// 						return;
// 					} else if(deletedSameExists && !addedSameExists){
// 						addRec();
// 						return;
// 					}
					
// 					new Ajax.Request(contextPath + "/GIACBankAccountsController", {
// 						parameters : {action : "valAddRec",
// 									  bankAcctCd : $F("txtBankAcctCd")},
// 						onCreate : showNotice("Processing, please wait..."),
// 						onComplete : function(response){
// 							hideNotice();
// 							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
// 								addRec();
// 							}
// 						}
// 					});
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiacs312;
		objCurrBankAccount.recordStatus = -1;
		tbgBankAccount.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACBankAccountsController", {
				parameters : {action : "valDeleteRec",
							  bankCd : $F("hidBankCd"),
							  bankAcctCd : $F("txtBankAcctCd")},
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
	
	function cancelGiacs312(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS312.exitPage = exitPage;
						saveGiacs312();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function getGiacs312BranchLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action: "getGIACS118BranchLOV",
							moduleId : "GIACS312",
							searchString : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							page: 1},
			title: "List of Branches",
			width: 435,
			height: 400,
			columnModel : [
			               {
			            	   id : "branchCd",
			            	   title: "Code",
			            	   width: '100px'
			               },
			               {
			            	   id: "branchName",
			            	   title: "Branch Name",
			            	   width: '320px'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
			onSelect: function(row) {
				$("txtBranchCd").value = unescapeHTML2(row.branchCd);
				$("txtDspBranchName").value = unescapeHTML2(row.branchName);
				$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
				$("txtBranchCd").focus();
			},
			onCancel: function (){
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}	
	
	function getBankAcctTypeLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action: "getCgRefCodeLOV4",
							domain : 'GIAC_BANK_ACCOUNTS.BANK_ACCT_TYPE',
							filterText : ($("txtBankAcctType").readAttribute("lastValidValue").trim() != $F("txtBankAcctType").trim() ? $F("txtBankAcctType").trim() : ""),
							page: 1},
			title: "List of Bank Account Types",
			width: 435,
			height: 400,
			columnModel : [
			               {
			            	   id : "rvLowValue",
			            	   title: "Code",
			            	   width: '100px'
			               },
			               {
			            	   id: "rvMeaning",
			            	   title: "Account Type",
			            	   width: '320px'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : ($("txtBankAcctType").readAttribute("lastValidValue").trim() != $F("txtBankAcctType").trim() ? $F("txtBankAcctType").trim() : ""),
			onSelect: function(row) {
				$("txtBankAcctType").value = unescapeHTML2(row.rvLowValue);
				$("txtDspBankAcctType").value = unescapeHTML2(row.rvMeaning);
				$("txtBankAcctType").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
				$("txtBankAcctType").focus();
			},
			onCancel: function (){
				$("txtBankAcctType").value = $("txtBankAcctType").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBankAcctType").value = $("txtBankAcctType").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}	
	
	function getBankAcctFlagLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action: "getCgRefCodeLOV4",
							domain : 'GIAC_BANK_ACCOUNTS.BANK_ACCOUNT_FLAG',
							filterText : ($("txtBankAcctFlag").readAttribute("lastValidValue").trim() != $F("txtBankAcctFlag").trim() ? $F("txtBankAcctFlag").trim() : ""),
							page: 1},
			title: "List of Bank Account Flags",
			width: 435,
			height: 400,
			columnModel : [
			               {
			            	   id : "rvLowValue",
			            	   title: "Code",
			            	   width: '100px'
			               },
			               {
			            	   id: "rvMeaning",
			            	   title: "Account Status",
			            	   width: '320px'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : ($("txtBankAcctFlag").readAttribute("lastValidValue").trim() != $F("txtBankAcctFlag").trim() ? $F("txtBankAcctFlag").trim() : ""),
			onSelect: function(row) {
				$("txtBankAcctFlag").value = unescapeHTML2(row.rvLowValue);
				$("txtDspBankAcctFlag").value = unescapeHTML2(row.rvMeaning);
				$("txtBankAcctFlag").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
				$("txtBankAcctFlag").focus();
			},
			onCancel: function (){
				$("txtBankAcctFlag").value = $("txtBankAcctFlag").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBankAcctFlag").value = $("txtBankAcctFlag").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}	
	
	function showGIACS312BankLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacBankLOV2",
							filterText : ($("txtDspBankSname").readAttribute("lastValidValue").trim() != $F("txtDspBankSname").trim() ? $F("txtDspBankSname").trim() : ""),
							page : 1},
			title: "List of Banks",
			width: 435,
			height: 400,
			columnModel : [
			               {
			            	   id : "bankSname",
			            	   title: "Bank Sname",
			            	   width: '120px'		            	   
			               },
			               {
			            	   id: "bankName",
			            	   title: "Bank Name",
			            	   width: '300px'
			               }
			              ],
			autoSelectOneRecord: true,
			filterText : ($("txtDspBankSname").readAttribute("lastValidValue").trim() != $F("txtDspBankSname").trim() ? $F("txtDspBankSname").trim() : ""),
			onSelect: function(row) {
				$("hidBankCd").value = row.bankCd;
				$("txtDspBankSname").value = unescapeHTML2(row.bankSname);
				$("txtDspBankName").value = unescapeHTML2(row.bankName);
				$("txtDspBankSname").setAttribute("lastValidValue", unescapeHTML2(row.bankSname));
				$("txtDspBankSname").focus();
			},
			onCancel: function (){
				$("txtDspBankSname").value = $("txtDspBankSname").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspBankSname").value = $("txtDspBankSname").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
	  });
	}
	
	function showAccountCodeLOV(){
		var concatGl = ($F("txtDspGlAcctCategory").trim() == "" ? "": $F("txtDspGlAcctCategory")) +
		($F("txtDspGlControlAcct").trim() == "" ? "": formatNumberDigits($F("txtDspGlControlAcct"), 2)) +
		($F("txtDspGlSubAcct1").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct1"), 2)) +
		($F("txtDspGlSubAcct2").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct2"), 2)) +
		($F("txtDspGlSubAcct3").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct3"), 2)) +
		($F("txtDspGlSubAcct4").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct4"), 2)) +
		($F("txtDspGlSubAcct5").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct5"), 2)) +
		($F("txtDspGlSubAcct6").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct6"), 2)) +
		($F("txtDspGlSubAcct7").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct7"), 2));
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action: "getGiacs312GlAcctCodeLOV",
							filterText : ($F("hidGlAccountCode").trim() != concatGl ? concatGl : "")
// 							glAcctCategory: $F("txtDspGlAcctCategory"),
// 							glControlAcct: $F("txtDspGlControlAcct"),
// 							glSubAcct1: $F("txtDspGlSubAcct1"),
// 							glSubAcct2: $F("txtDspGlSubAcct2"),
// 							glSubAcct3: $F("txtDspGlSubAcct3"),
// 							glSubAcct4: $F("txtDspGlSubAcct4"),
// 							glSubAcct5: $F("txtDspGlSubAcct5"),
// 							glSubAcct6: $F("txtDspGlSubAcct6"),
// 							glSubAcct7: $F("txtDspGlSubAcct7")
							},
			title: "List of GL Acct Codes",
			hideColumnChildTitle: true,
			width: 655,
			height: 400,
			columnModel : [
			               {
			            	   id : 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
			            	   title: 'GL Acct Code',
			            	   width: 270,
			            	   children: [
			            	               {
											   id : 'glAcctCategory',
											   width: 30,
											   align: 'right'
										   },
										   {
											   id : 'glControlAcct',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct1',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct2',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct3',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct4',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct5',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct6',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct7',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   }
						       ]
			               },
			               {
			            	   id : 'glAcctName',
			            	   title: 'Account Name',
			            	   width: '350px',
			            	   align: 'left'
			               },
			               {
			            	   id : 'gsltSlTypeCd',
			            	   width: '0',
			            	   visible : false
			               },
			               {
			            	   id : 'glAcctId',
			            	   width: '0',
			            	   visible: false
			               }
			               /*,
			               {
			            	   id : "slCd",
			            	   width: '0',
			            	   visible:false
			               }*/
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : ($F("hidGlAccountCode").trim() != concatGl ? concatGl : ""),
			onSelect: function(row) {
				try {
					$("hidGlAcctId").value = row.glAcctId;
					$("txtDspGlAcctCategory").value 	= row.glAcctCategory;
					$("txtDspGlControlAcct").value 	    = parseInt(row.glControlAcct).toPaddedString(2);
					$("txtDspGlSubAcct1").value 		= parseInt(row.glSubAcct1).toPaddedString(2);
					$("txtDspGlSubAcct2").value 		= parseInt(row.glSubAcct2).toPaddedString(2);
					$("txtDspGlSubAcct3").value 		= parseInt(row.glSubAcct3).toPaddedString(2);
					$("txtDspGlSubAcct4").value 		= parseInt(row.glSubAcct4).toPaddedString(2);
					$("txtDspGlSubAcct5").value 		= parseInt(row.glSubAcct5).toPaddedString(2);
					$("txtDspGlSubAcct6").value 		= parseInt(row.glSubAcct6).toPaddedString(2);
					$("txtDspGlSubAcct7").value 		= parseInt(row.glSubAcct7).toPaddedString(2);
					$("txtDspGlAcctName").value 		= unescapeHTML2(row.glAcctName);
					$("txtSlTypeCd").value = row.gsltSlTypeCd;
					$("txtDspSlTypeName").value = unescapeHTML2(row.dspSlTypeName);	
					
					$("txtDspGlAcctName").setAttribute("lastValidValue", unescapeHTML2(row.glAcctName));
					$("hidGlAccountCode").value = row.glAcctCategory +
					                              parseInt(row.glControlAcct).toPaddedString(2) +
					                              parseInt(row.glSubAcct1).toPaddedString(2) +
					                              parseInt(row.glSubAcct2).toPaddedString(2) +
					                              parseInt(row.glSubAcct3).toPaddedString(2) +
					                              parseInt(row.glSubAcct4).toPaddedString(2) +
					                              parseInt(row.glSubAcct5).toPaddedString(2) +
					                              parseInt(row.glSubAcct6).toPaddedString(2) +
					                              parseInt(row.glSubAcct7).toPaddedString(2);
					
					$("txtDspGlSubAcct7").focus();
				} catch(e){
					showErrorMessage("showAccountCodeLOV - onSelect", e);
				}
			},
			onCancel: function (){
				$("txtDspGlAcctName").value = $("txtDspGlAcctName").readAttribute("lastValidValue");
				$("txtDspGlAcctCategory").value = $F("hidGlAccountCode").substring(0, 1);
				$("txtDspGlControlAcct").value = $F("hidGlAccountCode").substring(1, 3);
				$("txtDspGlSubAcct1").value = $F("hidGlAccountCode").substring(3, 5);
				$("txtDspGlSubAcct2").value = $F("hidGlAccountCode").substring(5, 7);
				$("txtDspGlSubAcct3").value = $F("hidGlAccountCode").substring(7, 9);
				$("txtDspGlSubAcct4").value = $F("hidGlAccountCode").substring(9, 11);
				$("txtDspGlSubAcct5").value = $F("hidGlAccountCode").substring(11, 13);
				$("txtDspGlSubAcct6").value = $F("hidGlAccountCode").substring(13, 15);
				$("txtDspGlSubAcct7").value = $F("hidGlAccountCode").substring(15, 17);
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$$("txtDspGlAcctName").value = $("txtDspGlAcctName").readAttribute("lastValidValue");
				$("txtDspGlAcctCategory").value = $F("hidGlAccountCode").substring(0, 1);
				$("txtDspGlControlAcct").value = $F("hidGlAccountCode").substring(1, 3);
				$("txtDspGlSubAcct1").value = $F("hidGlAccountCode").substring(3, 5);
				$("txtDspGlSubAcct2").value = $F("hidGlAccountCode").substring(5, 7);
				$("txtDspGlSubAcct3").value = $F("hidGlAccountCode").substring(7, 9);
				$("txtDspGlSubAcct4").value = $F("hidGlAccountCode").substring(9, 11);
				$("txtDspGlSubAcct5").value = $F("hidGlAccountCode").substring(11, 13);
				$("txtDspGlSubAcct6").value = $F("hidGlAccountCode").substring(13, 15);
				$("txtDspGlSubAcct7").value = $F("hidGlAccountCode").substring(15, 17);
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	} 
	
	$("imgSearchGl").observe("click", showAccountCodeLOV);
	$("imgSearchBank").observe("click", showGIACS312BankLOV);
	$("imgSearchBankAcctType").observe("click", getBankAcctTypeLOV);
	$("imgSearchBankAcctFlag").observe("click", getBankAcctFlagLOV);
	$("imgSearchBranchCd").observe("click", getGiacs312BranchLOV);
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	

	$("txtDspBankSname").observe("keyup", function(){
		$("txtDspBankSname").value = $F("txtDspBankSname").toUpperCase();
	});
	
	$("txtBranchBank").observe("keyup", function(){
		$("txtBranchBank").value = $F("txtBranchBank").toUpperCase();
	});
		
// 	function clearGlAccount(){
// 		try {
// 			$("hidGlAcctId").value = "";
// 			$("txtDspGlAcctCategory").value = "";
// 			$("txtDspGlControlAcct").value 	= "";
// 			$("txtDspGlSubAcct1").value = "";
// 			$("txtDspGlSubAcct2").value = "";
// 			$("txtDspGlSubAcct3").value = "";
// 			$("txtDspGlSubAcct4").value = "";
// 			$("txtDspGlSubAcct5").value = "";
// 			$("txtDspGlSubAcct6").value = "";
// 			$("txtDspGlSubAcct7").value = "";
// 			$("txtDspGlAcctName").value = "";
// 			$("txtSlTypeCd").value = "";
// 			$("txtDspSlTypeName").value = "";
// 		} catch(e){
// 			showErrorMessage("clearGlAccount", e);
// 		}
// 	}
	
// 	$$("input[name='glAccountCode']").each(function(gl){
// 		gl.observe("change", function(){
// 			var val = gl.value;
// 			if(val != "" && $F("hidGlAcctId") != "") {
// 				clearGlAccount();
// 				gl.value = val;
// 			}
// 		});
// 	});
	
	$("txtDspBankSname").observe("change", function() {		
		if($F("txtDspBankSname").trim() == "") {
			$("txtDspBankName").value = "";
			$("hidBankCd").value = "";
			$("txtDspBankSname").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDspBankSname").trim() != "" && $F("txtDspBankSname") != $("txtDspBankSname").readAttribute("lastValidValue")) {
				showGIACS312BankLOV();
			}
		}
	});	
	
	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtDspBranchName").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				getGiacs312BranchLOV();
			}
		}
	});		
	
	$("txtBankAcctType").observe("change", function() {		
		if($F("txtBankAcctType").trim() == "") {
			$("txtDspBankAcctType").value = "";
			$("txtBankAcctType").setAttribute("lastValidValue", "");
		} else {
			if($F("txtBankAcctType").trim() != "" && $F("txtBankAcctType") != $("txtBankAcctType").readAttribute("lastValidValue")) {
				getBankAcctTypeLOV();
			}
		}
	});
	
	$("txtBankAcctFlag").observe("change", function() {		
		if($F("txtBankAcctFlag").trim() == "") {
			$("txtDspBankAcctFlag").value = "";
			$("txtBankAcctFlag").setAttribute("lastValidValue", "");
		} else {
			if($F("txtBankAcctFlag").trim() != "" && $F("txtBankAcctFlag") != $("txtBankAcctFlag").readAttribute("lastValidValue")) {
				getBankAcctFlagLOV();
			}
		}
	});	
	
	function validateOpeningDate(){
		if($F("txtOpeningDate").trim() == "") {
			$("txtOpeningDate").setAttribute("lastValidValue", "");
		} else if(!checkDate2($F("txtOpeningDate"))) {
			$("txtOpeningDate").value = $("txtOpeningDate").readAttribute("lastValidValue");
		} else {
			if($F("txtOpeningDate") != "" && $F("txtClosingDate") != "" && compareDatesIgnoreTime(Date.parse($F("txtOpeningDate")), Date.parse($F("txtClosingDate"))) == -1){
				showWaitingMessageBox("Opening Date should not be later than Closing Date.", "I", 
						function(){
							$("txtOpeningDate").value = nvl($("txtOpeningDate").readAttribute("lastValidValue"), "");
							$("txtOpeningDate").focus();
						}
					);
			} else {
				$("txtOpeningDate").setAttribute("lastValidValue", $F("txtOpeningDate"));
			}
		}
	}
	
	function validateClosingDate(){
		if($F("txtClosingDate").trim() == "") {
			$("txtClosingDate").setAttribute("lastValidValue", "");
		} else if(!checkDate2($F("txtClosingDate"))) {
			$("txtClosingDate").value = $("txtClosingDate").readAttribute("lastValidValue");
		} else {
			if($F("txtOpeningDate") != "" && $F("txtClosingDate") != "" && compareDatesIgnoreTime(Date.parse($F("txtOpeningDate")), Date.parse($F("txtClosingDate"))) == -1){
				showWaitingMessageBox("Opening Date should not be later than Closing Date.", "I", 
						function(){
							$("txtClosingDate").value = nvl($("txtClosingDate").readAttribute("lastValidValue"), "");
							$("txtClosingDate").focus();
						}
					);
			} else {
				$("txtClosingDate").setAttribute("lastValidValue", $F("txtClosingDate"));
			}
		}
	}
	
	$("txtOpeningDate").observe("change", function(e) {
		validateOpeningDate();
	});	
	
	$("txtClosingDate").observe("change", function(e) {
		validateClosingDate();
	});
	
	$("hrefOpeningDate").observe("click", function() {
		if ($("hrefOpeningDate").disabled == true) return;
		scwNextAction = validateOpeningDate.runsAfterSCW(this, null);
		scwShow($('txtOpeningDate'),this, null);
	});
 	
	$("hrefClosingDate").observe("click", function() {
		if ($("hrefClosingDate").disabled == true) return;
		scwNextAction = validateClosingDate.runsAfterSCW(this, null);
		scwShow($('txtClosingDate'),this, null);
	});
	
	var glCodeId = ["txtDspGlAcctCategory","txtDspGlControlAcct","txtDspGlSubAcct1","txtDspGlSubAcct2","txtDspGlSubAcct3",
	                "txtDspGlSubAcct4","txtDspGlSubAcct5","txtDspGlSubAcct6","txtDspGlSubAcct7"];
	$$("#glCodeDiv input[type='text']").each(function(m) {
		m.observe("change",function() {
			var LOVcond = false;
					for ( var i = 0; i < glCodeId.length; i++) {
						if ($F(glCodeId[i]).trim() != "") {
							LOVcond = true;
						}else{
							LOVcond = false;
							break;
						}
					}
					if (LOVcond) {
						showAccountCodeLOV();
					}else{
						$("txtDspGlAcctName").clear();
						$("txtSlTypeCd").clear();
						$("txtDspSlTypeName").clear();
						$("txtDspGlAcctName").setAttribute("lastValidValue", "");
						$("hidGlAccountCode").clear();
					}
				});
			});
	
	
	observeSaveForm("btnSave", saveGiacs312);
	$("btnCancel").observe("click", cancelGiacs312);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtDspBankSname").focus();
</script>
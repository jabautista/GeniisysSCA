<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<script type="text/javascript">
	$("smoothmenu1").hide();
</script>
<div id="giacs303MainDiv" name="giacs303MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Branches</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs303" name="giacs303">
		<div class="sectionDiv" id="giacs303">
			<div style="" align="center">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="width: 85px;" id="">Company</td>
						<td class="leftAligned" colspan="2">
							<span class="lovSpan required" style="width: 80px; margin-top: 2px; height: 19px;">
								<input class="required" id="txtCompanyCd" name="txtCompanyCd" type="text" style="width: 50px; float: left; border: none; height: 13px; margin: 0;" value="" tabindex="101" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCompany" name="imgSearchCompany" alt="Go" style="float: right;" tabindex="211"/>
							</span>
						</td>
						<td>
							<input id="txtCompanyDesc" name="txtCompanyDesc" type="text" style="width: 500px; border: 1px solid gray;" value="" readonly="readonly" tabindex="102"/>
						</td>
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="branchTableDiv" style="padding: 10px 0 0 10px;">
				<div id="branchTable" style="height: 300px"></div>
			</div>
			<div align="center">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Branch Code</td>
						<td class="leftAligned"><input id="txtBranchCd" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="201"></td>
						<td width="80" class="rightAligned">Acct Code</td>
						<td class="leftAligned"><input id="txtAcctBranchCd" type="text" class="" style="width: 300px; text-align: right;" readonly="readonly" tabindex="202"></td>
					</tr>
					<tr>
						<td class="rightAligned">Branch Name</td>
						<td colspan="3" class="leftAligned"><input id="txtBranchName" type="text" class="" style="width: 600px" readonly="readonly" tabindex="203"></td>
					</tr>
					<tr>
						<td class="rightAligned">Default Bank Account</td>
						<td colspan="3" class="leftAligned">
							<span class="lovSpan" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 19px;">
								<input type="text" id="txtBankCd" name="txtBankCd" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="3" tabindex="204" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBankCd" name="imgSearchBankCd" alt="Go" style="float: right;" tabindex="205"/>
							</span>
							<!-- <input id="txtBankCd" type="text" class="" style="width: 40px"> -->
							<input id="txtBankName" type="text" class="" style="float: left; width: 305px" readonly="readonly" tabindex="206">
							<label style="float: left; margin: 5px 5px 0 5px;">/</label>
							<span class="lovSpan" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 19px;">
								<input type="text" id="txtBankAcctCd" name="txtBankAcctCd" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="4" tabindex="207" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBankAcctCd" name="imgSearchBankAcctCd" alt="Go" style="float: right;" tabindex="208"/>
							</span>
							<!-- <input id="txtBankAcctCd" type="text" class="" style="width: 40px"> -->
							<input id="txtBankAcctNo" type="text" class="" style="float: left; width: 128px" readonly="readonly" tabindex="209">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Check DV Print</td>
						<td class="leftAligned">
							<span class="lovSpan" style="width: 206px; margin-top: 2px; height: 21px;">
								<input type="hidden" id="hidCheckDvPrintValue" name="hidCheckDvPrintValue" style=""/>
								<input type="text" id="txtCheckDvPrintMeaning" name="txtCheckDvPrintMeaning" style="width: 181px; float: left; border: none; height: 15px; margin: 0;" tabindex="210" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCheckDvPrint" name="imgSearchCheckDvPrint" alt="Go" style="float: right;" tabindex="211"/>
							</span>
							<!-- <input id="txtCheckDvPrint" type="text" class="" style="width: 200px;"> -->
						</td>					
						<td width="" class="rightAligned">Address</td>
						<td class="leftAligned"><input id="txtAddress1" type="text" class="" style="width: 300px;" readonly="readonly" tabindex="215"></td>
					</tr>
					<tr>
						<td class="rightAligned">BIR Permit Number</td>
						<td class="leftAligned"><input id="txtBirPermit" type="text" class="" style="width: 200px;" maxlength="100" tabindex="212"></td>					
						<td width="" class="rightAligned"></td>
						<td class="leftAligned"><input id="txtAddress2" type="text" class="" style="width: 300px;" readonly="readonly" tabindex="216"></td>
					</tr>
					<tr>
						<td class="rightAligned">TIN</td>
						<td class="leftAligned"><input id="txtBranchTin" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="213"></td>					
						<td width="" class="rightAligned"></td>
						<td class="leftAligned"><input id="txtAddress3" type="text" class="" style="width: 300px;" readonly="readonly" tabindex="217"></td>
					</tr>
					<tr>
						<td class="rightAligned">Telephone Number</td>
						<td class="leftAligned"><input id="txtTelNo" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="214"></td>
						<td width="" class="rightAligned"><label id="lblCompCode" title="Comp Code" style="margin-left: 12px;">Comp Code</label></td>
						<td class="leftAligned"><input id="txtCompCd" type="text" class="" style="width: 300px;" maxlength="4" tabindex="218"></td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 606px; border: 1px solid gray; height: 22px;"/>
								<textarea style="float: left; height: 16px; width: 580px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="219"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="220"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="221"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 300px;" readonly="readonly" tabindex="222"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;">
				<input type="button" class="button" id="btnUpdate" value="Update" tabindex="223">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="224">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="225">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="226">
</div>
<script type="text/javascript">
	setModuleId("GIACS303");
	setDocumentTitle("Branches");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	
	//toolbar buttons
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	
	function initializeGiacs303(){
		//$("txtCompanyCd").value = objGIACS303.vars.fundCd;
		//$("txtCompanyDesc").value = objGIACS303.vars.fundDesc;
		
		if(objGIACS303.vars.sapIntegrationSw == "Y"){
			$("txtCompCd").show();
			$("lblCompCode").show();
		} else {
			$("txtCompCd").hide();
			$("lblCompCode").hide(); //added to hide label when field is hidden
		}
		
		$("txtCompanyCd").focus();
	}

	function saveGiacs303(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var branches = tbgBranches.getModifiedRows();
		new Ajax.Request(contextPath+"/GIACBranchController", {
			method: "POST",
			parameters : {action : "saveGiacs303",
					 	  setRows : prepareJsonAsParameter(branches)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS303.exitPage != null) {
							objGIACS303.exitPage();
						} else {
							tbgBranches._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	function cancelGiacs303(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS303.exitPage = exitPage;
						saveGiacs303();						
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	observeReloadForm("reloadForm", showGiacs303);
	
	var objGIACS303 = JSON.parse('${jsonGIACS303}');
	var objCurrBranch = null;
	var rowIndex = -1;
	objGIACS303.exitPage = null;
	
	initializeGiacs303();
	
	var fundCd = objGIACS303.vars.fundCd;
	
	//included in creation of grid table upon selection of company
	var branchTable = {
			//url : contextPath + "/GIACBranchController?action=showGiacs303&fundCd="+objGIACS303.vars.fundCd,
			url : contextPath + "/GIACBranchController?action=showGiacs303&fundCd="+fundCd,
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrBranch = tbgBranches.geniisysRows[y];
					setForm(objCurrBranch);
					tbgBranches.keys.removeFocus(tbgBranches.keys._nCurrentFocus, true);
					tbgBranches.keys.releaseKeys();
					$("txtBankCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setForm(null);
					tbgBranches.keys.removeFocus(tbgBranches.keys._nCurrentFocus, true);
					tbgBranches.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setForm(null);
						tbgBranches.keys.removeFocus(tbgBranches.keys._nCurrentFocus, true);
						tbgBranches.keys.releaseKeys();
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
					setForm(null);
					tbgBranches.keys.removeFocus(tbgBranches.keys._nCurrentFocus, true);
					tbgBranches.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setForm(null);
					tbgBranches.keys.removeFocus(tbgBranches.keys._nCurrentFocus, true);
					tbgBranches.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setForm(null);
					tbgBranches.keys.removeFocus(tbgBranches.keys._nCurrentFocus, true);
					tbgBranches.keys.releaseKeys();
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
					id : "branchCd",
					title : "Branch Code",
					filterOption : true,
					width : '80px'
				},
				{
					id : "acctBranchCd",
					title : "Acct Code",
					width : '100px',
					align : 'right',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					titleAlign : 'right',
					renderer : function (value){
						return formatNumberDigits(value, 2);
					}
				},
				{
					id : 'branchName',
					filterOption : true,
					title : 'Branch Name',
					width : (objGIACS303.vars.sapIntegrationSw == "Y" ? '450px' : '550px')				
				},
				{
					id : 'compCd',
					title : 'Comp Code',					
					filterOption : (objGIACS303.vars.sapIntegrationSw == "Y" ? true : false),
					width : (objGIACS303.vars.sapIntegrationSw == "Y" ? '100px' : '0'),
					visible : (objGIACS303.vars.sapIntegrationSw == "Y" ? true : false)
				},
				{
					id : 'dspCheckDvPrint',
					filterOption : true,
					title : 'Check DV Print',
					width : '100px'				
				},
				{
					id : 'checkDvPrint',
					width : '0',
					visible: false
				},
				{
					id : 'bankCd',
					width : '0',
					visible: false
				},
				{
					id : 'dspBankName',
					width : '0',
					visible: false				
				},
				{
					id : 'bankAcctCd',
					width : '0',
					visible: false				
				},
				{
					id : 'dspBankAcctNo',
					width : '0',
					visible: false				
				},
				{
					id : 'birPermit',
					width : '0',
					visible: false				
				},
				{
					id : 'branchTin',
					width : '0',
					visible: false				
				},
				{
					id : 'address1',
					width : '0',
					visible: false				
				},
				{
					id : 'address2',
					width : '0',
					visible: false				
				},
				{
					id : 'address3',
					width : '0',
					visible: false				
				},
				{
					id : 'telNo',
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
				},
				{
					id : 'gfunFundCd',
					width : '0',
					visible: false				
				}
			],
			rows : objGIACS303.branches.rows
		};

		tbgBranches = new MyTableGrid(branchTable);
		tbgBranches.pager = objGIACS303.branches;
		tbgBranches.render("branchTable");

	
	function setForm(rec){
		try{
			$("txtBranchCd").value = (rec == null ? "" : rec.branchCd);			
			$("txtBranchName").value = (rec == null ? "" : unescapeHTML2(rec.branchName));
			$("txtAcctBranchCd").value = (rec == null ? "" : formatNumberDigits(rec.acctBranchCd, 2));
			$("txtBankCd").value = (rec == null ? "" : unescapeHTML2(rec.bankCd));
			$("txtBankCd").setAttribute("lastValidValue", (rec == null ? "" : nvl(rec.bankCd, "")));
			$("txtBankName").value = (rec == null ? "" : unescapeHTML2(rec.dspBankName));
			$("txtBankAcctCd").value = (rec == null ? "" : unescapeHTML2(rec.bankAcctCd));
			$("txtBankAcctCd").setAttribute("lastValidValue", (rec == null ? "" : nvl(rec.bankAcctCd, "")));
			$("txtBankAcctNo").value = (rec == null ? "" : unescapeHTML2(rec.dspBankAcctNo));
			$("hidCheckDvPrintValue").value = (rec == null ? "" : unescapeHTML2(rec.checkDvPrint));
			$("txtCheckDvPrintMeaning").value = (rec == null ? "" : unescapeHTML2(rec.dspCheckDvPrint));
			$("txtCheckDvPrintMeaning").setAttribute("lastValidValue", (rec == null ? "" : nvl(rec.dspCheckDvPrint, "")));
			$("txtBirPermit").value = (rec == null ? "" : unescapeHTML2(rec.birPermit));
			$("txtBranchTin").value = (rec == null ? "" : unescapeHTML2(rec.branchTin));
			$("txtTelNo").value = (rec == null ? "" : unescapeHTML2(rec.telNo));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : unescapeHTML2(rec.lastUpdate));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtAddress1").value = (rec == null ? "" : unescapeHTML2(rec.address1));
			$("txtAddress2").value = (rec == null ? "" : unescapeHTML2(rec.address2));
			$("txtAddress3").value = (rec == null ? "" : unescapeHTML2(rec.address3));
			$("txtCompCd").value = (rec == null ? "" : unescapeHTML2(rec.compCd));
			
			rec == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableSearch("imgSearchBankCd") : enableSearch("imgSearchBankCd");
			rec == null ? disableSearch("imgSearchBankAcctCd") : enableSearch("imgSearchBankAcctCd");
			rec == null ? disableSearch("imgSearchCheckDvPrint") : enableSearch("imgSearchCheckDvPrint");
			rec == null ? $("txtBankCd").readOnly = true : $("txtBankCd").readOnly = false;
			rec == null ? $("txtBankAcctCd").readOnly = true : $("txtBankAcctCd").readOnly = false;
			rec == null ? $("txtCheckDvPrintMeaning").readOnly = true : $("txtCheckDvPrintMeaning").readOnly = false;
		} catch(e){
			showErrorMessage("setForm", e);
		}
	}
	
	function deleteBranch(){
		new Ajax.Request(contextPath + "/GIACBranchController", {
			parameters : {action : "valDeleteBranch", 
						  branchCd : $F("txtBranchCd"),
						  fundCd : $F("txtCompanyCd")},
			onCreate : showNotice("Validating, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showMessageBox("You cannot delete this record", "I");
				}
			}
		});
	}
	
	function getGiacBankLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action: "getGiacBankLOV",
							findText : ($("txtBankCd").readAttribute("lastValidValue") != $F("txtBankCd") ? $F("txtBankCd") : ""),
							page: 1},
			title: "List of Banks",
			width: 600,
			height: 400,
			columnModel : [
			               {
			            	   id : "bankCd",
			            	   title: "Bank Code",
			            	   width: '100px'
			               },
			               {
			            	   id: "bankName",
			            	   title: "Bank Name",
			            	   width: '450px'
			               }
			              ],
			draggable: true,
			filterText : ($("txtBankCd").readAttribute("lastValidValue") != $F("txtBankCd") ? $F("txtBankCd") : ""),
			autoSelectOneRecord: true,
			onSelect: function(row) {
				if($("txtBankCd").readAttribute("lastValidValue") != row.bankCd) {
					$("txtBankAcctCd").value = "";
					$("txtBankAcctNo").value = "";
					$("txtBankAcctCd").setAttribute("lastValidValue", "");
				}
				$("txtBankCd").value = row.bankCd;
				$("txtBankName").value = row.bankName;
				$("txtBankCd").setAttribute("lastValidValue", row.bankCd);
			},
			onCancel: function (){
				$("txtBankCd").value = $("txtBankCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBankAcctCd").value = $("txtBankAcctCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	function getGiacBankAcctLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action: "getGiacBankAcctLOV",
							bankCd : $F("txtBankCd"),
							filterText : ($("txtBankAcctCd").readAttribute("lastValidValue") != $F("txtBankAcctCd") ? $F("txtBankAcctCd") : ""),
							page: 1},
			title: "List of Bank Accounts",
			width: 600,
			height: 400,
			columnModel : [
			               {
			            	   id : "bankAcctCd",
			            	   title: "Bank Acct Code",
			            	   width: '100px'
			               },
			               {
			            	   id: "bankAcctNo",
			            	   title: "Acct No.",
			            	   width: '450px'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : ($("txtBankAcctCd").readAttribute("lastValidValue") != $F("txtBankAcctCd") ? $F("txtBankAcctCd") : ""),
			onSelect: function(row) {
				$("txtBankAcctCd").value = row.bankAcctCd;
				$("txtBankAcctNo").value = row.bankAcctNo;
				$("txtBankAcctCd").setAttribute("lastValidValue", row.bankAcctCd);
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBankAcctCd").value = $("txtBankAcctCd").readAttribute("lastValidValue");
			},
			onCancel: function (){
				$("txtBankAcctCd").value = $("txtBankAcctCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	function getCheckDvPrintLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action: "getCheckDvPrintLOV",
							filterText : ($("txtCheckDvPrintMeaning").readAttribute("lastValidValue").trim() != $F("txtCheckDvPrintMeaning").trim() ? $F("txtCheckDvPrintMeaning").trim() : ""),
							page: 1},
			title: "List of Check Dv Print",
			width: 600,
			height: 400,
			columnModel : [
			               {
			            	   id : "rvLowValue",
			            	   title: "Value",
			            	   width: '100px'
			               },
			               {
			            	   id: "rvMeaning",
			            	   title: "Meaning",
			            	   width: '450px'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : ($("txtCheckDvPrintMeaning").readAttribute("lastValidValue").trim() != $F("txtCheckDvPrintMeaning").trim() ? $F("txtCheckDvPrintMeaning").trim() : ""),
			onSelect: function(row) {
				$("hidCheckDvPrintValue").value = row.rvLowValue;
				$("txtCheckDvPrintMeaning").value = row.rvMeaning;
				$("txtCheckDvPrintMeaning").setAttribute("lastValidValue", row.rvMeaning);
			},
			onCancel: function (){
				$("txtCheckDvPrintMeaning").value = $("txtCheckDvPrintMeaning").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtCheckDvPrintMeaning").value = $("txtCheckDvPrintMeaning").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	function setBranch(rec){
		try {
			rec.bankCd = $F("txtBankCd");
			rec.dspBankName = $F("txtBankName");
			rec.bankAcctCd = $F("txtBankAcctCd");
			rec.dspBankAcctNo = $F("txtBankAcctNo");
			rec.birPermit = $F("txtBirPermit");
			rec.checkDvPrint = $F("hidCheckDvPrintValue");
			rec.dspCheckDvPrint = $F("txtCheckDvPrintMeaning");
			rec.compCd = $F("txtCompCd");
			rec.remarks = escapeHTML2($F("txtRemarks"));
		} catch(e){
			showErrorMessage("setBranch", e);
		}
	}
	
	function updateBranch(){
		if($F("txtBankCd") != "" && $F("txtBankAcctCd") == ""){
			showWaitingMessageBox("Please enter bank account code.", "I", function(){
				$("txtBankAcctCd").focus();
			});
		} else {
			setBranch(objCurrBranch);
			tbgBranches.updateRowAt(objCurrBranch, rowIndex);
			changeTag = 1;
			tbgBranches.keys.removeFocus(tbgBranches.keys._nCurrentFocus, true);
			tbgBranches.keys.releaseKeys();
			setForm(null);			
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000); //removed readonly attribute
	});	
	
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("btnSave").observe("click", saveGiacs303);
	$("btnCancel").observe("click", cancelGiacs303);
	$("btnUpdate").observe("click", updateBranch);
	$("btnDelete").observe("click", deleteBranch);
	$("imgSearchBankCd").observe("click", getGiacBankLOV);
	
	$("txtBankCd").observe("change", function() {		
		if($F("txtBankCd").trim() == "") {
			$("txtBankName").value = "";
			$("txtBankCd").setAttribute("lastValidValue", "");
			$("txtBankAcctCd").value = "";
			$("txtBankAcctNo").value = "";
			$("txtBankAcctCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtBankCd").trim() != "" && $F("txtBankCd") != $("txtBankCd").readAttribute("lastValidValue")) {
				getGiacBankLOV();
			}
		}
	});
	
	$("imgSearchBankAcctCd").observe("click", getGiacBankAcctLOV);
	
	$("txtBankAcctCd").observe("change", function() {		
		if($F("txtBankAcctCd").trim() == "") {
			$("txtBankAcctNo").value = "";
			$("txtBankAcctCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtBankAcctCd").trim() != "" && $F("txtBankAcctCd") != $("txtBankAcctCd").readAttribute("lastValidValue")) {
				getGiacBankAcctLOV();
			}
		}
	});
	
	$("imgSearchCheckDvPrint").observe("click", getCheckDvPrintLOV);	
	
	$("txtCheckDvPrintMeaning").observe("change", function() {		
		if($F("txtCheckDvPrintMeaning").trim() == "") {
			$("hidCheckDvPrintValue").value = "";
			$("txtCheckDvPrintMeaning").setAttribute("lastValidValue", "");
		} else {
			if($F("txtCheckDvPrintMeaning").trim() != "" && $F("txtCheckDvPrintMeaning") != $("txtCheckDvPrintMeaning").readAttribute("lastValidValue")) {
				getCheckDvPrintLOV();
			}
		}
	});
	

	//additional to search for company LOV
	$("imgSearchCompany").observe("click", getCompanyLOV);
	
	function getCompanyLOV() {
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action: "getCompany2LOV",
							filterText : ($("txtCompanyCd").readAttribute("lastValidValue").trim() != $F("txtCompanyCd").trim() ? $F("txtCompanyCd").trim() : "%")
						},
			title: "List of Companies",
			width: 600,
			height: 400,
			columnModel : [
			               {
			            	   id : "fundCd",
			            	   title : "Company",
			            	   width : '100px'
			               },
			               {
			            	   id : "fundDesc",
			            	   title : "Company Name",
			            	   width : '450px'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText: ($("txtCompanyCd").readAttribute("lastValidValue").trim() != $F("txtCompanyCd").trim() ? $F("txtCompanyCd").trim() : "%"),
			onSelect: function (row) {
				$("txtCompanyCd").value = row.fundCd;
				$("txtCompanyDesc").value = row.fundDesc;
				$("txtCompanyCd").setAttribute("lastValidValue", row.fundCd);
				
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
				
				setForm(null);
				
				tbgBranches.url = contextPath + "/GIACBranchController?action=showGiacs303&fundCd="+null;
				tbgBranches._refreshList();
			},
			onCancel: function () {
				$("txtCompanyCd").value = $("txtCompanyCd").readAttribute("lastValidValue");
			},
			onUndefinedRow: function () {
				showMessageBox("No company selected.", "I");
				$("txtCompanyCd").value = $("txtCompanyCd").readAttribute("lastValidValue");
			},
			onShow: function () {
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	//toolbar functions
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		disableToolbarButton("btnToolbarExecuteQuery");
		disableSearch("imgSearchCompany");
		
		tbgBranches.url = contextPath + "/GIACBranchController?action=showGiacs303&fundCd="+$F("txtCompanyCd");
		tbgBranches._refreshList();
		setForm(null);
	});

	$("btnToolbarEnterQuery").observe("click", function(){
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		
		enableSearch("imgSearchCompany");
		
		$("txtCompanyCd").value = "";
		$("txtCompanyCd").setAttribute("lastValidValue", "");
		$("txtCompanyDesc").value = "";
		$("txtCompanyDesc").setAttribute("lastValidValue", "");
		
		tbgBranches.url = contextPath + "/GIACBranchController?action=showGiacs303&fundCd="+null;
		tbgBranches._refreshList();
		setForm(null);
		
		$("txtCompanyCd").focus();
	});	
	
	$("btnToolbarSave").stopObserving("click");
	$("btnToolbarSave").observe("click", function() {
		fireEvent($("btnSave"), "click");
	})
	
	//textfield actions
	$("txtCompanyCd").observe("change", function() {
		if ($F("txtCompanyCd").trim() == "") {
			$("txtCompanyCd").value = "";
			$("txtCompanyCd").setAttribute("lastValidValue", "");
			
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			getCompanyLOV();			
		}
	});
	
	$("txtCompanyCd").observe("keyup", function() {
		$("txtCompanyCd").value = $F("txtCompanyCd").toUpperCase();
	});
	
	setForm(null);
</script>

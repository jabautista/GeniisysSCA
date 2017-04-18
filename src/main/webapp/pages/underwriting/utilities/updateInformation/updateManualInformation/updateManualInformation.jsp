<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>


<div id="updateManualInfoMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Update Manual Policy / Invoice / Acceptance Number</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>

	<div id="policyDiv" class="sectionDiv" style="width: 920px; height: 80px;">
		<table align="center" border="0" style="margin: 10px auto;">
			<tr>
				<input id="hidPolicyId" type="hidden"/>
				<input id="hidParId" type="hidden"/>
				<input type="hidden" id="issCdRi" name="issCdRi" value="${issCdRi}"/> <!-- added by robert SR 5165 11.05.15 -->
				<td style="padding-right: 5px;"><label for="txtLineCd" style="float: right;">Policy No.</label></td>
				<td>
					<input type="text" id="txtLineCd" class="required allCaps" maxlength="2" style="width: 40px; margin: 0px; height: 14px;" tabindex="101"/>
				</td>
				<td>
					<input type="text" id="txtSublineCd" class="required allCaps" maxlength="7" style="width: 70px; margin: 0px; height: 14px; " tabindex="102" />
				</td>
				<td>
					<input type="text" id="txtIssCd" class="required allCaps" maxlength="2" style="width: 40px; margin: 0px; height: 14px;" tabindex="103"/>
				</td>
				<td>
					<input type="text" id="txtIssueYy" class="required integerUnformattedNoComma" maxlength="2" style="width: 40px; margin: 0px; height: 14px;" tabindex="104"/>
				</td>
				<td>
					<input type="text" id="txtPolSeqNo" class="required rightAligned integerUnformattedNoComma" maxlength="7" style="width: 70px; margin: 0px; height: 14px;" tabindex="105"/>
				</td>
				<td>
					<input type="text" id="txtRenewNo" class="required rightAligned integerUnformattedNoComma" maxlength="2" style="width: 40px; margin: 0px; height: 14px;" tabindex="106"/>
				</td>
				<td>
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicy" alt="Go" style="float: right;" tabindex="107"/>
				</td>
				<td style="padding-right: 5px;"><label for="txtEndtIssCd" style="margin-left: 20px; float: right;">Endorsement No.</label></td>
				<td>				
					<input id="hidEndtIssCd" type="hidden"/>
					<input id="hidEndtYy" type="hidden"/>
					<input id="hidEndtSeqNo" type="hidden"/>
					<input type="text" id="txtNEndtIssCd" class="allCaps" style="width: 40px; margin: 0px; height: 14px;" tabindex="108"/>
				</td>
				<td>
					<input type="text" id="txtNEndtYy" class="rightAligned integerUnformattedNoComma" style="width: 40px; margin: 0px; height: 14px;" tabindex="109"/>
				</td>
				<td>
					<input type="text" id="txtNEndtSeqNo" class="rightAligned integerUnformattedNoComma" style="width: 70px; margin: 0px; height: 14px;" tabindex="110"/>
				</td>
			</tr>
			<tr>
				<input id="hidAssdNo" type="hidden"/>
				<td style="padding-right: 5px;"><label for="txtAssured" style="float: right;">Assured</label></td>
				<td colspan="11">
					<input type="text" id="txtAssdName" class="" style="margin: 0; width: 695px; height: 14px;" tabindex="111"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="policyDiv2" class="sectionDiv" style="width: 920px; height: 80px;">
		<table align="center" border="0" style="margin: 10px auto;">
			<tr>
				<input id="hidActiveRenewal" type="hidden" errorMsg="Policy with active renewal cannot be updated."/>
				<input id="hidOngoingRenewal" type="hidden" errorMsg="Policy with on-going renewal cannot be updated."/>
				<td class="rightAligned" style="padding-right: 7px;">Reference Policy Number</td>
				<td><input id="txtRefPolNo" type="text" maxlength="30" style="width: 500px;" tabindex="112"></td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Reference Renewal Number</td>
				<td><input id="txtManualRenewNo" type="text" maxlength="2" style="width: 500px;" class="integerNoNegativeUnformattedNoComma" tabindex="113"></td>
			</tr>
		</table>
	</div>
	
	<div id="inPolbasDiv" class="sectionDiv" style="width: 920px; height: 50px;">
		<table align="center" border="0" style="margin: 10px 10px 10px 75px;">
			<tr>
				<input id="hidInvoiceIssCd" type="hidden"/>
				<input id="hidInvoicePremSeqNo" type="hidden"/>
				<input id="hidInvoicePolicyId" type="hidden"/>
				<td class="rightAligned" style="padding-right: 7px;">Ref Acceptance No / Acceptance No</td>
				<td><input id="txtRefAcceptNo" type="text" maxlength="10" readonly="readonly" style="width: 233px;" tabindex="114"></td> <!-- change maxlength to 10 robert SR 5165 11.05.15 -->
				<td style="padding: 0 7px 0 7px;">/</td>
				<td><input id="txtAcceptNo" type="text" maxlength="2" readonly="readonly" style="width: 233px;" tabindex="115"></td>
			</tr>
		</table>
	</div>
	
	<div id="invoiceDiv" class="sectionDiv" style="width: 920px; height: 350px">
	
		<div id="invoiceTGDiv" style="width: 700px; height: 230px; margin: 10px 0 5px 120px;"></div>
		
		<div id="invoiceFieldsDiv" style="width: 920px; height: 60px;">
			<table align="center" border="0" style="margin: 5px 10px 0px 200px;">
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Invoice Number</td>
					<td><input id="txtInvoiceNo" type="text" readonly="readonly" style="width: 350px;" tabindex="201"></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Reference Invoice Number</td>
					<td><input id="txtRefInvNo" type="text" maxlength="30" style="width: 350px;" tabindex="202"></td>
				</tr>
			</table>
		</div>
		
		<div class="buttonsDiv">
			<input id="btnUpdate" type="button" class="button" value="Update" tabindex="203">
		</div>
	</div>
	
	<div class="buttonsDiv">
		<input id="btnCancel" type="button" class="button" value="Cancel" tabindex="301">
		<input id="btnSave" type="button" class="button" value="Save" tabindex="302">
	</div>
</div>

<script type="text/javascript">
try{
	setModuleId("GIUTS025");
	setDocumentTitle("Edit Manual Policy/ Invoice/ Acceptance Number");
	initializeAll();
	
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	disableButton("btnSave");
	$("txtLineCd").focus();	
	
	changeTag = 0;
	
	var exitPage = "";
	var entQuerySw = true;
	
	var selectedRowInfo = null;
	var selectedIndex = null;
	
	var objInvoice = new Object();
	objInvoice.tableGrid = JSON.parse('${invoiceTableGrid}'.replace(/\\/g, '\\\\'));
	objInvoice.objRows = objInvoice.tableGrid || [];
	objInvoice.objList = [];
	
	try{
		var invoiceTableModel = {
			url:	contextPath+"/UpdateUtilitiesController?action=showGIUTS025&refresh=1&policyId="+$F("hidPolicyId")+"&issCd="+$F("txtIssCd"),
			options: {
				width: "700px",
				height:	"200px",
				onCellFocus: function(element, value, x, y, id){
					selectedRowInfo = invoiceTG.geniisysRows[y];
					selectedIndex = y;
					populateToggleInvoiceFields(selectedRowInfo);
					invoiceTG.keys.releaseKeys();
				},
				onRemoveRowFocus: function(){
					invoiceTG.keys.releaseKeys();
					selectedRowInfo = null;
					selectedIndex = null;
					populateToggleInvoiceFields(null);
				},
				beforeSort: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				prePager: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					invoiceTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					invoiceTG.onRemoveRowFocus();
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
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						invoiceTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{
					id: 'policyId',
					width: '0px',
					visible: false
				},
				{
					id: 'issCd',
					width: '0px',
					visible: false
				},
				{
					id: 'premSeqNo',
					width: '0px',
					visible: false
				},  	
				{
					id: 'invoiceNo',
					title: 'Invoice Number',
					width: '330px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'refInvNo',
					title: 'Reference Invoice Number',
					width: '330px',
					visible: true,
					sortable: true,
					filterOption: true
				}
			],
			rows: objInvoice.objRows
		};
		
		invoiceTG = new MyTableGrid(invoiceTableModel);
		invoiceTG.pager = objInvoice.tableGrid;
		invoiceTG.render('invoiceTGDiv');
		invoiceTG.afterRender = function(){
			objInvoice.objList = invoiceTG.geniisysRows;	
		};
		
	}catch(e){
		showErrorMessage("Invoice tablegrid error", e);
	}
	
	function populateToggleInvoiceFields(row){
		row == null ? $("hidInvoiceIssCd").clear() : $("hidInvoiceIssCd").value = unescapeHTML2(row.issCd);
		row == null ? $("hidInvoicePremSeqNo").clear() : $("hidInvoicePremSeqNo").value = unescapeHTML2(row.premSeqNo);
		row == null ? $("hidInvoicePolicyId").clear() : $("hidInvoicePolicyId").value = unescapeHTML2(row.policyId);
		row == null ? $("txtInvoiceNo").clear() : $("txtInvoiceNo").value = unescapeHTML2(row.invoiceNo);
		row == null ? $("txtRefInvNo").clear() : $("txtRefInvNo").value = unescapeHTML2(row.refInvNo); //unescapeHTML2(invoiceTG.getValueAt(invoiceTG.getColumnIndex("refInvNo"), selectedIndex));
		row == null ? $("txtRefInvNo").readOnly = true : $("txtRefInvNo").readOnly = false;
		row == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
	}	
	
	function getGiuts025PolNoLOV(){ 
		LOV.show({
			id : "getGiuts025PolicyListing",
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : 		"getGiuts025PolicyListing",
				lineCd : 		$F('txtLineCd').replace(/'/g, "''"),
				sublineCd : 	$F('txtSublineCd').replace(/'/g, "''"),
				issCd :	 		$F('txtIssCd').replace(/'/g, "''"),
				issueYy : 		$F('txtIssueYy'),
				polSeqNo : 		$F('txtPolSeqNo'),
				renewNo : 		$F('txtRenewNo'),
				nEndtIssCd:		$F("hidEndtIssCd") == "" ? $F('txtNEndtIssCd').replace(/'/g, "''") : $F("hidEndtIssCd"),
				nEndtSeqNo : 	$F("hidEndtSeqNo") == "" ?  $F('txtNEndtSeqNo') : $F("hidEndtSeqNo"),
				nEndtYy : 		$F("hidEndtYy") == "" ? $F('txtNEndtYy') : $F("hidEndtYy"),
				refPolNo:		$F("txtRefPolNo").replace(/'/g, "''"),
				manualRenewNo:	$F("txtManualRenewNo"),
				page : 			1
			},
			hideColumnChildTitle : true,
			filterVersion: "2",
			title : "",
			width : 700,
			height : 403,
			columnModel : [
			    {
			    	id: "parId",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "policyId",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "endtIssCd",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "endtYy",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "endtSeqNo",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "activeRenewal",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "ongoingRenewal",
			    	width: '0px',
			    	visible: false
			    },
           		{
					id : "policyNo",
					title : "Policy No.",
					width: 303,
					children : [
						{
							id: 'lineCd',
							title: 'Line Cd',
							width: 40
						},
						{
							id: 'sublineCd',
							title: 'Subline Cd',
							width: 70,
							filterOption: true
						},
						{
							id: 'issCd',
							title: 'Iss Cd',
							width: 40,
							filterOption: true
						},
						{
							id: 'issueYy',
							title: 'Issue Yy',
							width: 40,
							filterOption: true,
							filterOptionType: 'number'
						},
						{
							id: 'polSeqNo',
							title: 'Pol Seq No',
							width: 70,
							filterOption: true,
							filterOptionType: 'number'
						},
						{
							id: 'renewNo',
							title: 'Renew No',
							width: 40,
							filterOption: true,
							filterOptionType: 'number'
						}
					]
				},
				{
					id : 'endorsementNo',
					title : 'Endt No.',
					children : [
						{
							id: 'nEndtIssCd' ,
							title : 'Endt Iss Cd',
							width: 40,
							filterOption: true
						},
						{
							id: 'nEndtYy',
							title : 'Endt Yy',
							width: 40,
							filterOption: true,
							filterOptionType: 'number'
						},
						{
							id: 'nEndtSeqNo',
							title : 'Endt Seq No',
							width: 70,
							filterOption: true,
							filterOptionType: 'number'
						}
					]
				},
				{
					id : 'assdName',
					title : 'Assured Name',
					width : 500,
					filterOption : true,
					/*renderer : function(val){
						return unescapeHTML2(val);
					}*/
				},
				{
					id : 'refPolNo',
					title : 'Reference Policy No.',
					width : 200,
					filterOption : true,
					/*renderer : function(val){
						return unescapeHTML2(val);
					}*/
				},
				{
					id : 'manualRenewNo',
					title : 'Reference Renewal No.',
					width : 150,
					filterOption : true,
					filterOptionType: 'number'
				},
				{
					id : 'refAcceptNo',
					title : 'Ref. Accept No.',
					width : 100,
					filterOption : true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
				},
				{
					id : 'acceptNo',
					title : 'Acccept No.',
					width : 70,
					filterOption : true,
					filterOptionType: 'number'
				}
      		],
			draggable : true,
			autoSelectOneRecord: true, 
			onSelect : function(row) {
				populatePolicyInformation(row);
				
				$$("div#policyDiv input[type='text'], div#policyDiv2 input[type='text']").each(function(txt){
					$(txt).readOnly = true;
				});
				disableButton("btnSave");
				disableToolbarButton("btnToolbarSave");
				enableToolbarButton("btnToolbarExecuteQuery");
			},
			onCancel : function () {
				$("txtLineCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				$("txtLineCd").focus();
			}
		});
	}
	
	function validateGiuts025PolNoLOV(){
		try{
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGiuts025PolicyListing"
					+ "&lineCd=" 		+ encodeURIComponent($F("txtLineCd").replace(/'/g, "''"))
					+ "&sublineCd=" 	+ encodeURIComponent($F("txtSublineCd").replace(/'/g, "''"))
					+ "&issCd=" 		+ encodeURIComponent($F("txtIssCd").replace(/'/g, "''"))
					+ "&issueYy=" 		+ $F("txtIssueYy")
					+ "&polSeqNo=" 		+ $F("txtPolSeqNo")
					+ "&renewNo=" 		+ $F("txtRenewNo")
					+ "&nEndtIssCd=" 	+ encodeURIComponent($F("txtNEndtIssCd").replace(/'/g, "''"))
					+ "&nEndtYy=" 		+ $F("txtNEndtYy")
					+ "&nEndtSeqNo=" 	+ $F("txtNEndtSeqNo")
					+ "&refPolNo="		+	encodeURIComponent($F("txtRefPolNo").replace(/'/g, "''")) 
					+ "&manualRenewNo="	+	$F("txtManualRenewNo"),
						"%",
						"");
		
			/*if (cond == 0 || cond == 2){
				getGiuts025PolNoLOV();
			}else{
				populatePolicyInformation(cond.rows[0]);
			}*/
			getGiuts025PolNoLOV();
		}catch(e){
			showErrorMessage("validateGiuts025PolNoLOV", e);
		}
	}
	
	function populatePolicyInformation(row){
		try{
			row == null ? $("hidParId").clear() : $("hidParId").value = row.parId;
			row == null ? $("hidPolicyId").clear() : $("hidPolicyId").value = row.policyId;
			row == null ? $("hidEndtIssCd").clear : $("hidEndtIssCd").value = unescapeHTML2(row.endtIssCd);
			row == null ? $("hidEndtYy").clear() : $("hidEndtYy").value = row.endtYy;
			row == null ? $("hidEndtSeqNo").clear() : $("hidEndtSeqNo").value = row.endtSeqNo;
			row == null ? $("hidAssdNo").clear() : $("hidAssdNo").value = row.assdNo;
			row == null ? $("hidActiveRenewal").clear() : $("hidActiveRenewal").value = row.activeRenewal;
			row == null ? $("hidOngoingRenewal").clear() : $("hidOngoingRenewal").value = row.ongoingRenewal;
			row == null ? $("txtLineCd").clear() : $("txtLineCd").value = unescapeHTML2(row.lineCd);
			row == null ? $("txtSublineCd").clear() : $("txtSublineCd").value = unescapeHTML2(row.sublineCd);
			row == null ? $("txtIssCd").clear() : $("txtIssCd").value = unescapeHTML2(row.issCd);
			row == null ? $("txtIssueYy").clear() : $("txtIssueYy").value = row.issueYy == null ? null : formatNumberDigits(row.issueYy, 2);
			row == null ? $("txtPolSeqNo").clear() : $("txtPolSeqNo").value = row.polSeqNo == null ? null : formatNumberDigits(row.polSeqNo, 7);
			row == null ? $("txtRenewNo").clear() : $("txtRenewNo").value = row.renewNo == null ? null : formatNumberDigits(row.renewNo, 2);
			row == null ? $("txtNEndtIssCd").clear() : $("txtNEndtIssCd").value = unescapeHTML2(row.nEndtIssCd);
			row == null ? $("txtNEndtYy").clear() : $("txtNEndtYy").value = row.nEndtYy == null ? null : formatNumberDigits(row.nEndtYy, 2);
			row == null ? $("txtNEndtSeqNo").clear() : $("txtNEndtSeqNo").value = row.nEndtSeqNo == null ? null : formatNumberDigits(row.nEndtSeqNo, 6);
			row == null ? $("txtAssdName").clear() : $("txtAssdName").value = unescapeHTML2(row.assdName);
			row == null ? $("txtRefPolNo").clear() : $("txtRefPolNo").value = unescapeHTML2(row.refPolNo);
			row == null ? $("txtRefPolNo").removeAttribute("origRefPolNo") : $("txtRefPolNo").writeAttribute("origRefPolNo", unescapeHTML2(row.refPolNo));
			row == null ? $("txtManualRenewNo").clear() : $("txtManualRenewNo").value = row.manualRenewNo;
			row == null ? $("txtManualRenewNo").removeAttribute("origManualRenewNo") : $("txtManualRenewNo").writeAttribute("origManualRenewNo", unescapeHTML2(row.manualRenewNo));
			row == null ? $("txtRefAcceptNo").clear() : $("txtRefAcceptNo").value = unescapeHTML2(row.refAcceptNo);
			row == null ? $("txtRefAcceptNo").removeAttribute("origRefAcceptNo") : $("txtRefAcceptNo").writeAttribute("origRefAcceptNo", unescapeHTML2(row.refAcceptNo)); //added by robert SR 5165 11.05.15 
			row == null ? $("txtAcceptNo").clear() : $("txtAcceptNo").value = row.acceptNo;				
		}catch(e){
			showErrorMessage("populatePolicyInformation", e);
		}
	}
	
	function togglePolicyFields(enable){
		try{
			if(enable){
				$$("div#policyDiv input[type='text']").each(function(txt){
					$(txt).readOnly = false;
				});
				enableSearch("searchPolicy");
				disableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
				disableToolbarButton("btnToolbarSave");
				disableButton("btnSave");
				$("txtLineCd").focus();
			}else{
				$$("div#policyDiv input[type='text']").each(function(txt){
					$(txt).readOnly = true;
				});
				disableSearch("searchPolicy");
				enableToolbarButton("btnToolbarSave");
				enableButton("btnSave");
			}
		}catch(e){
			showErrorMessage("togglePolicyFields", e);
		}
	}	
	
	function saveRecords(){
		try{
			var modifiedRows = prepareJsonAsParameter(getModifiedJSONObjects(objInvoice.objList));
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController", {
				method: "POST",
				parameters: {
					action:				"saveGiuts025",
					policyId:			$F("hidPolicyId"),
					newRefPolNo:		$F("txtRefPolNo"),
					newManualRenewNo:	$F("txtManualRenewNo"),
					newRefAcceptNo:		$F("txtRefAcceptNo"), //added by robert SR 5165 11.05.15
					modifiedRows:		modifiedRows
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Saving records, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						changeTag = 0;
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S" , function(){
							if (exitPage != ""){
								exitPage();
							}else if(entQuerySw){
								invoiceTG.url = contextPath+"/UpdateUtilitiesController?action=showGIUTS025&refresh=1&policyId="+$F("hidPolicyId")+"&issCd="+$F("txtIssCd");
								invoiceTG._refreshList();
								$("txtLineCd").focus();
							}else{
								invoiceTG.refresh();
							}
						});
					}
				}
			});
		}catch(e){
			showErrorMessage("saveRecords", e);
		}
	}	
	
	function resetForm(){
		changeTag = 0;
		exitPage = "";
		entQuerySw = true;
		
		selectedRowInfo = null;
		selectedIndex = null;
		
		populatePolicyInformation(null);
		togglePolicyFields(true);
		populateToggleInvoiceFields(null);
		invoiceTG.url = contextPath+"/UpdateUtilitiesController?action=showGIUTS025&refresh=1&policyId="+$F("hidPolicyId")+"&issCd="+$F("txtIssCd");
		invoiceTG._refreshList();
	}
	
	function exitModule(){
		changeTag = 0;
		invoiceTG.onRemoveRowFocus();
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null); 
	}
	
	
	
	$$("div#policyDiv input[type='text'], div#policyDiv2 input[type='text']").each(
		function(obj){
			obj.observe("keypress", function(event){
				if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46){
					if(this.readOnly)
						return;
					
					disableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				}
			});
		}		
	);
	
	$("txtIssueYy").observe("change", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("txtPolSeqNo").observe("change", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 7);
		}
	});
	
	$("txtRenewNo").observe("change", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("txtNEndtYy").observe("change", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 2);
		}
	});
	
	$("txtNEndtSeqNo").observe("change", function(){
		if (this.value != ""){
			this.value = formatNumberDigits(this.value, 6);
		}
	});
	
	$("searchPolicy").observe("click", function(){
		if (/* checkAllRequiredFieldsInDiv('policyDiv') */ $F("txtLineCd") != ""){
			//validateGiuts025PolNoLOV();
			getGiuts025PolNoLOV();
		}else{
			showWaitingMessageBox("Please enter Line Code first." , "I", function(){
				$("txtLineCd").focus();
			});
		}
	});
	
	$("txtRefPolNo").observe("blur", function(){
		if ((this.value != this.readAttribute("origRefPolNo")) && entQuerySw == false){
			changeTag = 1;
			changeTagFunc = saveRecords;
		}
	});
	
	$("txtManualRenewNo").observe("click", function(){
		if(entQuerySw == false){
			if($F("hidActiveRenewal") == "Y"){
				this.readOnly = true;
				showMessageBox($("hidActiveRenewal").readAttribute("errorMsg"), "I");
				return false;
			}
			
			if($F("hidOngoingRenewal") == "Y"){
				this.readOnly = true;
				showMessageBox($("hidOngoingRenewal").readAttribute("errorMsg"), "I");
				return false;
			}
			
			this.readOnly = false;
		}		
	});
	
	$("txtManualRenewNo").observe("blur", function(){
		if ((this.value != this.readAttribute("origManualRenewNo")) && entQuerySw == false){
			changeTag = 1;
			changeTagFunc = saveRecords;
		}
	});
	//added by robert SR 5165 11.05.15 
	$("txtRefAcceptNo").observe("blur", function(){
		if ((this.value != this.readAttribute("origRefAcceptNo")) && entQuerySw == false){
			changeTag = 1;
			changeTagFunc = saveRecords;
		}
	});
	//end robert SR 5165 11.05.15 
	$("btnUpdate").observe("click", function(){
		var obj = new Object();
		obj.issCd = $F("hidInvoiceIssCd");
		obj.premSeqNo = $F("hidInvoicePremSeqNo");
		obj.policyId = $F("hidInvoicePolicyId");
		obj.invoiceNo = $F("txtInvoiceNo");
		obj.refInvNo = $F("txtRefInvNo");
		
		for (var i=0; i < objInvoice.objList.length; i++){
			if ((objInvoice.objList[i].issCd == $F("hidInvoiceIssCd")) && (objInvoice.objList[i].premSeqNo == $F("hidInvoicePremSeqNo"))){
				objInvoice.objList.splice(i, 1, obj);
				invoiceTG.updateVisibleRowOnly(obj, invoiceTG.getCurrentPosition()[1]);
			}
		}
		
		populateToggleInvoiceFields(null);
		changeTag = 1;
		changeTagFunc = saveRecords;
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
				function(){
					exitPage = "";
					entQuerySw = true;
					saveRecords();
					populatePolicyInformation(null);
					togglePolicyFields(true);
				},
				function(){
					changeTag = 0;
					entQuerySw = true;
					populatePolicyInformation(null);
					invoiceTG.url = contextPath+"/UpdateUtilitiesController?action=showGIUTS025&refresh=1&policyId="+$F("hidPolicyId")+"&issCd="+$F("txtIssCd");
					invoiceTG._refreshList();
					togglePolicyFields(true);
				},
				""
			);
		}else{
			changeTag = 0;
			entQuerySw = true;
			populatePolicyInformation(null);
			invoiceTG.url = contextPath+"/UpdateUtilitiesController?action=showGIUTS025&refresh=1&policyId="+$F("hidPolicyId")+"&issCd="+$F("txtIssCd");
			invoiceTG._refreshList();
			togglePolicyFields(true);
		}
		
	});
	
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if (checkAllRequiredFieldsInDiv('policyDiv')){
			disableToolbarButton(this.id);
			enableToolbarButton("btnToolbarSave");
			enableButton("btnSave");
			changeTag = 0;
			entQuerySw = false;
			invoiceTG.url = contextPath+"/UpdateUtilitiesController?action=showGIUTS025&refresh=1&policyId="+$F("hidPolicyId")+"&issCd="+$F("txtIssCd");
			invoiceTG._refreshList();
			$("txtRefPolNo").readOnly = false;
			$("txtManualRenewNo").readOnly = false;
			if($F("txtIssCd") == $F("issCdRi")){ //added by robert SR 5165 11.05.15
				$("txtRefAcceptNo").readOnly = false;
			}
			togglePolicyFields(false);
		}
	});
	
	observeReloadForm("reloadForm", resetForm);
	
	$("btnSave").observe("click", function(){
		if (changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return false;
		}else{
			saveRecords();
		}
	});
	
	$("btnToolbarSave").observe("click", function(){
		fireEvent($("btnSave"), "click");
	});
	
	$("btnCancel").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
				function(){
					exitPage = exitModule;
					saveRecords();
				},
				exitModule,
				""
			);
		}else{
			exitModule();
		}
		
	});
	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	populateToggleInvoiceFields(null);
}catch(e){
	showErrorMessage("Page error", e);
}
</script>
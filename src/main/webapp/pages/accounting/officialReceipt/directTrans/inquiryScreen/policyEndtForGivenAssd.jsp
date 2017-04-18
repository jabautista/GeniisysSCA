<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="updatePolicyDistrictEtcMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Policy / Endt Nos. For a Given Assured</label>
		</div>
	</div>
	
	<div id="policyDiv" class="sectionDiv" style="width: 920px; height: 50px;">
		<table align="center" border="0" style="margin: 10px auto;">
			<tr>
				<td style="padding-right: 5px;">Assured</td>
				<td>
					<div id="assdNoDiv" class="required" style="width: 100px; height: 20px; border: solid gray 1px; float: left;">
						<input id="txtAssdNo" name="txtAssdNo" type="text" maxlength="30" class="required integerNoNegative rightAligned" style="border: none; float: left; width: 75px; height: 13px; margin: 0px;" tabindex="202" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredLOV" alt="Go" style="float: right;" tabindex="201"/>							
					</div>
					<input type="text" id="txtAssdName" class="" readonly="readonly" style="margin: 0 0 0 5px; width: 500px; height: 14px;" tabindex="202"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="gipiPolbasicDiv" class="sectionDiv"  style="width: 920px; height: 440px;">
		<label style="font-weight: bold; margin: 15px 0 10px 15px;">Policy / Endorsement Nos. </label>
		
		<div id="tbgPolbasicDiv" style="margin: 40px 10px 25px 20px; height: 306px"></div>
		
		<fieldset style="width: 240px; height: 30px; margin: 10px 0 0 650px; float: left;">
			<table style="margin-top: 8px;">
				<tr>
					<td>
						<input id="policyRB" name="billRG" type="radio" value="A" style="float: left; margin: 0 7px 0 10px;">
						<label for="policyRB" style="float: left; margin-right: 5px;">Policy Bills</label>
					</td>
					<td>
						<input id="assuredRB" name="billRG" type="radio" value="B" style="float: left; margin: 0 7px 0 25px;">
						<label for="assuredRB" style="float: left; margin-right: 5px;">Assured Bills</label>
					</td>
				</tr>
			</table>
		</fieldset>
	</div>
	
	<div id="gipiInvoiceDiv" class="sectionDiv"  style="width: 920px; height: 440px;">
		<label style="font-weight: bold; margin: 15px 0 10px 15px;">Policy Bills </label>
		
		<div id="tbgInvoiceDiv" style="margin: 40px 0px 25px 140px; height: 210px"></div>
		
		<table style="margin-top: 35px;" align="center">
			<tr>
				<td class="rightAligned">Currency Name</td>
				<td class="leftAligned"><input id="txtDspCurrency" type="text" readonly="readonly" style="width: 200px;"></td>
				<td class="rightAligned" style="padding-left: 7px;">Conversion Rate</td>
				<td class="leftAligned"><input id="txtDspCurrencyRt" type="text" readonly="readonly" style="width: 200px; text-align: right;"></td>
			</tr>
			<tr>
				<td class="rightAligned">Policy/Endt. No.</td>
				<td class="leftAligned" colspan="3"><input id="txtNbtPolicyNo" type="text" readonly="readonly" style="width: 520px;"></td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td class="leftAligned" colspan="3"><input id="txtDspAssdName" type="text" readonly="readonly" style="width: 520px;"></td>
			</tr>
		</table>
		
		<div class="buttonsDiv">
			<input id="btnPolicy1" type="button" class="button" value="Policy" style="width: 75px;"/>
		</div>
	</div>
	
	<div id="giacAgingSoaDetailsDiv" class="sectionDiv"  style="width: 920px; height: 440px;">
		<label style="font-weight: bold; margin: 15px 0 10px 15px;">Assured Bills </label>
		
		<div id="tbgAgingSoaDetailsDiv" style="margin: 40px 10px 25px 140px; height: 210px"></div>
		
		<table style="margin-top: 35px;" align="center">
			<tr>
				<td class="rightAligned">Total Amount Due</td>
				<td class="leftAligned"><input id="txtTotalAmountDue" type="text" readonly="readonly" style="width: 200px; text-align: right;"></td>
				<td class="rightAligned" style="padding-left: 7px;">Premium Balance</td>
				<td class="leftAligned"><input id="txtPremBalanceDue" type="text" readonly="readonly" style="width: 200px; text-align: right;"></td>
			</tr>
			<tr>
				<td class="rightAligned">Total Payments</td>
				<td class="leftAligned"><input id="txtTotalPayments" type="text" readonly="readonly" style="width: 200px; text-align: right;"></td>
				<td class="rightAligned">Tax Balance</td>
				<td class="leftAligned"><input id="txtTaxBalanceDue" type="text" readonly="readonly" style="width: 200px; text-align: right;"></td>
			</tr>
			<tr>
				<td class="rightAligned"></td>
				<td class="leftAligned"><input id="txtBalanceAmtDue" type="text" readonly="readonly" style="width: 200px; text-align: right;"></td>
			</tr>
		</table>
		
		<div class="buttonsDiv">
			<input id="btnPolicy2" type="button" class="button" value="Policy" style="width: 75px;"/>
		</div>
	</div>
	
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS214");
	setDocumentTitle("Policy / Endt Nos. For a Given Assured");		
	initializeAll();
	
	var selectedPolRowInfo = null;
	var selectedPolIndex = null;
	
	var selectedInvRowInfo = null;
	var selectedInvIndex = null;
	
	var selectedSoaRowInfo = null;
	var selectedSoaIndex = null;
	
	var objPolbasic = new Object();
	objPolbasic.tableGrid = JSON.parse('${jsonPolbasicList}'.replace(/\\/g, '\\\\'));
	objPolbasic.objRows = objPolbasic.tableGrid.rows || [];
	objPolbasic.objList = [];	// holds all the geniisys rows
	
	try{
		var polbasicModel = {
			url: contextPath + "/GIACOrderOfPaymentController?action=showGiacs214&refresh=1&assdNo="+$F("txtAssdNo"),
			options: {
				width : '884px',
				onCellFocus: function(element, value, x, y, id){
					selectedPolRowInfo = tbgPolbasic.geniisysRows[y];
					selectedPolIndex = y;
					tbgPolbasic.keys.releaseKeys();
					refreshBillsTbg(selectedPolRowInfo);
				},
				onRemoveRowFocus: function(){
					tbgPolbasic.keys.releaseKeys();
					selectedPolRowInfo = null;
					selectedPolIndex = null;
					refreshBillsTbg(null);
				},
				beforeSort: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				/*onSort: function(){
					tbgPolbasic.onRemoveRowFocus();
				},*/
				prePager: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						tbgPolbasic.onRemoveRowFocus();
					}					
				},
				onRefresh: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						tbgPolbasic.onRemoveRowFocus();
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
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						tbgPolbasic.onRemoveRowFocus();
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
					id: 'itemNo',
					width: '0px',
					visible: false
				},
				{
					id: 'assdNo',
					width: '0px',
					visible: false
				},	
				{
					id: 'assdName',
					width: '0px',
					visible: false
				},	
				{
					id: 'lineCd',
					title: 'Line',
					width: '60px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'sublineCd',
					title: 'Subline',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'issCd',
					title: 'Iss Cd',
					width: '60px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'issueYy',
					title: 'Iss Yy',
					width: '60px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},  	
				{
					id: 'polSeqNo',
					title: 'Pol Seq No',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					renderer: function(value){
						return formatNumberDigits(value, 7);
					}
				},    	
				{
					id: 'endtIssCd',
					title: 'Endt Iss Cd',
					width: '80px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'endtYy',
					title: 'Endt Yy',
					width: '65px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},   	
				{
					id: 'endtSeqNo',
					title: 'Endt Seq #',
					width: '75px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},   
				{
					id: 'endtType',
					title: 'Endt Type',
					width: '70px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'refPolNo',
					title: 'Ref Policy No',
					width: '180px',
					visible: true,
					sortable: true,
					filterOption: true
				}
			],
			rows: objPolbasic.objRows
		};
		
		tbgPolbasic = new MyTableGrid(polbasicModel);
		tbgPolbasic.pager = objPolbasic.tableGrid;
		tbgPolbasic.render('tbgPolbasicDiv');
		tbgPolbasic.afterRender = function(){
			objPolbasic.objList = tbgPolbasic.geniisysRows;
		};
		
	}catch(e){
		showErrorMessage("Polbasic tablegrid error", e);
	}
	
	var objInvoice = new Object();
	objInvoice.tableGrid = JSON.parse('${jsonInvoiceList}'.replace(/\\/g, '\\\\'));
	objInvoice.objRows = objInvoice.tableGrid.rows || [];
	objInvoice.objList = [];	// holds all the geniisys rows
	
	try{
		var invoiceModel = {
			url: contextPath + "/GIACOrderOfPaymentController?action=getGiacs214InvoiceList&refresh=1",
			options: {
				width : '640px',
				onCellFocus: function(element, value, x, y, id){
					selectedInvRowInfo = tbgInvoice.geniisysRows[y];
					selectedInvIndex = y;
					tbgInvoice.keys.releaseKeys();
					populateInvoiceFields(selectedInvRowInfo);
				},
				onRemoveRowFocus: function(){
					tbgInvoice.keys.releaseKeys();
					selectedInvRowInfo = null;
					selectedInvIndex = null;
					populateInvoiceFields(null);
				},
				beforeSort: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					tbgInvoice.onRemoveRowFocus();
				},
				prePager: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						tbgInvoice.onRemoveRowFocus();
					}					
				},
				onRefresh: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						tbgInvoice.onRemoveRowFocus();
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
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						tbgInvoice.onRemoveRowFocus();
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
					id: 'nbtPolicyNo',
					width: '0px',
					visible: false
				},	
				{
					id: 'dspAssdName',
					width: '0px',
					visible: false
				},	
				{
					id: 'dspCurrency',
					width: '0px',
					visible: false
				},	
				{
					id: 'dspCurrencyRt',
					width: '0px',
					visible: false
				},	
				{
					id: 'dspIssPremSeq',
					title: 'Bill No.',
					width: '161px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'dspBalanceAmtDue',
					title: 'Balance Due',
					titleAlign: 'right',
					align: 'right',
					width: '144px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					renderer: function(value){
						return formatCurrency(value);
					}
				},  		
				{
					id: 'dspPremBalanceDue',
					title: 'Premium Balance',
					titleAlign: 'right',
					align: 'right',
					width: '144px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					renderer: function(value){
						return formatCurrency(value);
					}
				},  	
				{
					id: 'dspTaxBalanceDue',
					title: 'Tax Balance',
					titleAlign: 'right',
					align: 'right',
					width: '144px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					renderer: function(value){
						return formatCurrency(value);
					}
				},  
			],
			rows: objInvoice.objRows
		};
		
		tbgInvoice = new MyTableGrid(invoiceModel);
		tbgInvoice.pager = objInvoice.tableGrid;
		tbgInvoice.render('tbgInvoiceDiv');
		tbgInvoice.afterRender = function(){
			objInvoice.objList = tbgInvoice.geniisysRows;
		};
		
	}catch(e){
		showErrorMessage("Policy Bills tablegrid error", e);
	}

	function populateInvoiceFields(rec){
		$("txtDspCurrency").value = (rec == null ? "" : unescapeHTML2(rec.dspCurrency));
		$("txtDspCurrencyRt").value = (rec == null ? "" : formatToNineDecimal(rec.dspCurrencyRt));
		$("txtNbtPolicyNo").value = (rec == null ? "" : unescapeHTML2(rec.nbtPolicyNo));
		$("txtDspAssdName").value = (rec == null ? "" : unescapeHTML2(rec.dspAssdName));
	}
	
	var objSoa = new Object();
	objSoa.tableGrid = JSON.parse('${jsonAgingSoaDetails}'.replace(/\\/g, '\\\\'));
	objSoa.objRows = objSoa.tableGrid.rows || [];
	objSoa.objList = [];	// holds all the geniisys rows
	
	try{
		var soaModel = {
			url: contextPath + "/GIACOrderOfPaymentController?action=getGiacs214AgingSoaDetails&refresh=1",
			options: {
				width : '640px',
				onCellFocus: function(element, value, x, y, id){
					selectedSoaRowInfo = tbgSoa.geniisysRows[y];
					selectedSoaIndex = y;
					tbgSoa.keys.releaseKeys();
					populateAgingSoaFields(selectedSoaRowInfo);
				},
				onRemoveRowFocus: function(){
					tbgSoa.keys.releaseKeys();
					selectedSoaRowInfo = null;
					selectedSoaIndex = null;
					populateAgingSoaFields(null);
				},
				beforeSort: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					tbgSoa.onRemoveRowFocus();
				},
				prePager: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						tbgSoa.onRemoveRowFocus();
					}					
				},
				onRefresh: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						tbgSoa.onRemoveRowFocus();
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
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						tbgSoa.onRemoveRowFocus();
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
					id: 'a020AssdNo',
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
					id: 'totalAmountDue',
					width: '0px',
					visible: false
				},	
				{
					id: 'totalPayments',
					width: '0px',
					visible: false
				},	
				{
					id: 'balanceAmtDue',
					width: '0px',
					visible: false
				},	
				{
					id: 'premBalanceDue',
					width: '0px',
					visible: false
				},	
				{
					id: 'tacBalanceDue',
					width: '0px',
					visible: false
				},	
				{
					id: 'dspIssPremSeq',
					title: 'Bill No.',
					width: '163px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'instNo',
					title: 'Inst No.',
					titleAlign: 'right',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},  
				{
					id: 'dspCurrency',
					title: 'Currency',
					width: '180px',
					visible: true,
					sortable: true,
					filterOption: true
				},  
				{
					id: 'dspCurrencyRt',
					title: 'Conversion Rate',
					titleAlign: 'right',
					align: 'right',
					width: '150px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					renderer: function(value){
						return formatToNineDecimal(value);
					}
				},  
			],
			rows: objSoa.objRows
		};
		
		tbgSoa = new MyTableGrid(soaModel);
		tbgSoa.pager = objSoa.tableGrid;
		tbgSoa.render('tbgAgingSoaDetailsDiv');
		tbgSoa.afterRender = function(){
			objSoa.objList = tbgSoa.geniisysRows;
		};
		
	}catch(e){
		showErrorMessage("Assured Bills tablegrid error", e);
	}

	function populateAgingSoaFields(rec){
		$("txtTotalAmountDue").value = (rec == null ? "" : formatCurrency(rec.totalAmountDue));
		$("txtTotalPayments").value = (rec == null ? "" : formatCurrency(rec.totalPayments));
		$("txtBalanceAmtDue").value = (rec == null ? "" : formatCurrency(rec.balanceAmtDue));
		$("txtPremBalanceDue").value = (rec == null ? "" : formatCurrency(rec.premBalanceDue));
		$("txtTaxBalanceDue").value = (rec == null ? "" : formatCurrency(rec.taxBalanceDue));	
	}
	
	
	function showAssuredLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtAssdNo").trim() == "" ? "%" : $F("txtAssdNo"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs286AssdLov",
					search : searchString,
					page : 1
				},
				title : "",
				width : 370,
				height : 386,
				columnModel : [ {
					id : "assdNo",
					width : '100px',
					title: 'Assd No',
					renderer: function(value){
						return formatNumberDigits(value, 6);
					}
				}, {
					id : "assdName",
					title : "Assd Name",
					width : '255px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtAssdNo").setAttribute("lastValidValue", formatNumberDigits(row.assdNo, 6) );
						$("txtAssdNo").value = formatNumberDigits(row.assdNo, 6);
						$("txtAssdName").value = unescapeHTML2(row.assdName);
						
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					$("txtAssdNo").focus();
					$("txtAssdNo").value = $("txtAssdNo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtAssdNo").value = $("txtAssdNo").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtAssdNo");
				} 
			});
		}catch(e){
			showErrorMessage("showAssuredLOV", e);
		}		
	}
		
	function refreshBillsTbg(row){
		if (row == null){
			$("policyRB").disabled = true;
			$("assuredRB").disabled = true;
			tbgInvoice.url = contextPath+"/GIACOrderOfPaymentController?action=getGiacs214InvoiceList";
			tbgInvoice._refreshList();
			tbgSoa.url = contextPath+"/GIACOrderOfPaymentController?action=getGiacs214AgingSoaDetails";
			tbgSoa._refreshList();
		}else{
			$("policyRB").disabled = false;
			$("assuredRB").disabled = false;
			tbgInvoice.url = contextPath+"/GIACOrderOfPaymentController?action=getGiacs214InvoiceList&policyId="+row.policyId;
			tbgInvoice._refreshList();
			tbgSoa.url = contextPath+"/GIACOrderOfPaymentController?action=getGiacs214AgingSoaDetails&assdNo="+row.assdNo;
			tbgSoa._refreshList();
		}
	}
	
	function exitModule(){
		$("acExit").show();
		showORInfo();
	}
	
	$("searchAssuredLOV").observe("click", function(){
		showAssuredLOV(true);
	});
	
	$("txtAssdNo").observe("change", function(){
		if (this.value != ""){
			showAssuredLOV(false);
		}else{
			$("txtAssdName").clear();
		}
	});
	
	$$("input[name='billRG']").each(function(rb){
		rb.observe("click", function(){
			if (rb.value == "A"){
				$("gipiInvoiceDiv").show();
				$("gipiPolbasicDiv").hide();
			}else{
				$("giacAgingSoaDetailsDiv").show();
				$("gipiPolbasicDiv").hide();
			}
			$("policyRB").checked = false;
			$("assuredRB").checked = false;
		});
	});
	
	$("btnPolicy1").observe("click", function(){
		$("gipiInvoiceDiv").hide();
		$("gipiPolbasicDiv").show();
	});
	
	$("btnPolicy2").observe("click", function(){
		$("giacAgingSoaDetailsDiv").hide();
		$("gipiPolbasicDiv").show();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		disableToolbarButton("btnToolbarExecuteQuery");	
		disableToolbarButton("btnToolbarEnterQuery");
		$("policyRB").disabled = true;
		$("assuredRB").disabled = true;	
		$("policyRB").checked = false;
		$("assuredRB").checked = false;
		$("txtAssdNo").clear();
		$("txtAssdName").clear();
		$("txtAssdNo").readOnly = false;
		enableSearch("searchAssuredLOV");
		tbgPolbasic.url = contextPath + "/GIACOrderOfPaymentController?action=showGiacs214&refresh=1&assdNo="+$F("txtAssdNo");
		tbgPolbasic._refreshList();
		$("txtAssdNo").focus();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		disableToolbarButton("btnToolbarExecuteQuery");	
		$("txtAssdNo").readOnly = true;
		$("policyRB").checked = false;
		$("assuredRB").checked = false;
		disableSearch("searchAssuredLOV");
		tbgPolbasic.url = contextPath + "/GIACOrderOfPaymentController?action=showGiacs214&refresh=1&assdNo="+$F("txtAssdNo");
		tbgPolbasic._refreshList();
	});
	
	$("btnToolbarExit").observe("click", exitModule);
	
	
	$("acExit").hide();

	hideToolbarButton("btnToolbarPrint");
	hideToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");	
	disableToolbarButton("btnToolbarEnterQuery");
	$("policyRB").disabled = true;
	$("assuredRB").disabled = true;
	$("gipiInvoiceDiv").hide();
	$("giacAgingSoaDetailsDiv").hide();
	
	$("txtAssdNo").focus();
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>
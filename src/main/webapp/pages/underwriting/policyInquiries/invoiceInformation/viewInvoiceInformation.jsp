<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="viewInvoiceInformationMainDiv" name="viewInvoiceInformationMainDiv">
	<div id="viewInvoiceInformationSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="viewInvoiceInformationExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>View Invoice Details</label>
		</div>
	</div>
	
	<div id="moduleDiv" name="moduleDiv" class="sectionDiv">
		<div id="invoiceTGDiv" name="invoiceTGDiv" style="height:320px; margin: 10px 10px 10px 10px;"></div>
		
		<div id="invoiceInfoDiv" name="invoiceInfoDiv" style="margin: 30px 10px 10px 10px;">
			<table border="0" align="center">
				<tr>
					<td class="rightAligned" style="width:150px;">Crediting Branch</td>
					<td colspan="3" style="width:400px;"><input type="text" id="txtCreditingBranch" name="txtCreditingBranch" style="margin-left:5px; width: 50px;" tabindex="101" readonly="readonly" /></td>	
				</tr>
				<tr>
					<td class="rightAligned" id="tdPolicyBondNumber"  style="width:150px;">Policy Number</td>
					<td style="width:375px;"><input type="text" id="txtPolicyNo" name="txtPolicyNo" style="margin-left:5px; width: 300px;" tabindex="102" readonly="readonly" /></td>
					<td style="width:100px;" class="rightAligned">Currency</td>
					<td style="width:250px;"><input type="text" id="txtCurrency" name="txtCurrency" style="margin-left:5px; width: 200px;" tabindex="103" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:150px;">Endorsement Number</td>
					<td><input type="text" id="txtEndtNo" name="txtEndtNo" style="margin-left:5px; width: 300px;" tabindex="104" readonly="readonly" /></td>
					<td class="rightAligned">Rate</td>
					<td><input type="text" id="txtRate" name="txtRate" style="margin-left:5px; width: 200px; text-align: right;" tabindex="105" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured Name</td>
					<td colspan="3"><input type="text" id="txtAssdName" name="txtAssdName" style="margin-left:5px; width: 683px;" tabindex="106" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Property</td>
					<td colspan="3"><input type="text" id="txtProperty" name="txtProperty" style="margin-left:5px; width: 683px;" tabindex="107" readonly="readonly" /></td>
				</tr>
			</table>
		</div> <!-- end:invoiceInfoDiv -->
		
		<div class="buttonsDiv" >
			<input type="button" class="button" id="btnStatementOfAccount" name="btnStatementOfAccount" value="Statement of Accounts" style="width:150px;" />
			<input type="button" class="button" id="btnPaymentTerms" name="btnPaymentTerms" value="Payment Terms" style="width:150px;" />
			<input type="button" class="button" id="btnTaxBreakdown" name="btnTaxBreakdown" value="Tax Breakdown" style="width:150px;" />
		</div>
	
	</div> <!-- end:moduleDiv -->

</div> <!-- end:viewInvoiceInformationMainDiv -->

<script type="text/javascript">
	//objInvoiceInfo = new Object();
	objInvoiceInfo.invoiceTableGrid = JSON.parse('${invoiceList}');
	objInvoiceInfo.invoiceRows = objInvoiceInfo.invoiceTableGrid.rows || [];
	objInvoiceInfo.selectedRow = null;
	
	try {
		invoiceTableModel = {
				url: contextPath + "/GIPIInvoiceController?action=showViewInvoiceInformation&refresh=1",
						id: 1,
						options: {
							id: 1,
							height: '310px',
							width: '900px',
							onCellFocus: function(element, value, x, y, id){
								objInvoiceInfo.selectedRow = invoiceTableGrid.geniisysRows[y];
								populateFields(objInvoiceInfo.selectedRow);
								invoiceTableGrid.keys.removeFocus(invoiceTableGrid.keys._nCurrentFocus, true);
								invoiceTableGrid.keys.releaseKeys();
							},
							onRemoveRowFocus: function(){
								objInvoiceInfo.selectedRow = null;
								populateFields(null);
								invoiceTableGrid.keys.removeFocus(invoiceTableGrid.keys._nCurrentFocus, true);
								invoiceTableGrid.keys.releaseKeys();
							},
							onSort: function(){
								invoiceTableGrid.onRemoveRowFocus();
							},
							toolbar: {
								elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
								onRefresh: function(){
									invoiceTableGrid.onRemoveRowFocus(); //populateFields(null);
								},
								onFilter: function(){
									invoiceTableGrid.onRemoveRowFocus(); //populateFields(null);
								}
							},
						},
						columnModel: [{   
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
										id: 'itemGrp',
										width: '0px',
										visible: false
									},
									{
										id: 'invoiceNo',
										title: 'Invoice Number',
										width: '260px',
										visible: true,
										filterOption: true
									},
									{
										id: 'premAmt',
										title: 'Premium',
										titleAlign: 'right',
										align: 'right',
										width: '205px',
										visible: true,
										filterOption: true,
										filterOptionType: 'number',
										renderer: function(value){
											return formatCurrency(nvl(value, "0"));
										}
									},
									{
										id: 'taxAmt',
										title: 'Tax Amount',
										titleAlign: 'right',
										align: 'right',
										width: '205px',
										visible: true,
										filterOption: true,
										filterOptionType: 'number',
										renderer: function(value){
											return formatCurrency(nvl(value, "0"));
										}
									},
									{
										id: 'totalAmtDue',
										title: 'Total Amount',
										titleAlign: 'right',
										align: 'right',
										width: '205px',
										visible: true,
										filterOption: true,
										filterOptionType: 'number',
										renderer: function(value){
											return formatCurrency(nvl(value, "0"));
										}
									}
						],
						rows: objInvoiceInfo.invoiceRows
		};
		invoiceTableGrid = new MyTableGrid(invoiceTableModel);
		invoiceTableGrid.pager = objInvoiceInfo.invoiceTableGrid;
		invoiceTableGrid.render('invoiceTGDiv');
	} catch(e){
		showErrorMessage("invoice table grid: ",e);
	}
	
	
	function populateFields(row){
		$("txtCreditingBranch").value 	= row != null ? nvl(row.credBranch, "") : "";
		$("txtPolicyNo").value 			= row != null ? nvl(row.policyNo, "") : "";
		$("txtCurrency").value 			= row != null ? nvl(row.currencyDesc, "") : "";
		$("txtEndtNo").value 			= row != null ? nvl(row.endtNo, "") : "";
		$("txtRate").value 				= row != null ? formatCurrency(nvl(row.currencyRate, "")) : "";
		$("txtAssdName").value 			= row != null ? nvl(unescapeHTML2(row.assdName), "") : ""; //benjo 09.17.2015 added unescapeHMTL2
		$("txtProperty").value 			= row != null ? nvl(unescapeHTML2(row.property), "") : ""; //benjo 09.17.2015 added unescapeHMTL2
		$("tdPolicyBondNumber").innerHTML = row != null ? (row.lineCd == "SU" ? "Bond Number" : "Policy Number") : $("tdPolicyBondNumber").innerHTML;
		
		if(row != null){
			enableButton("btnStatementOfAccount");
			enableButton("btnPaymentTerms");
			enableButton("btnTaxBreakdown");
		} else {
			disableButton("btnStatementOfAccount");
			disableButton("btnPaymentTerms");
			disableButton("btnTaxBreakdown");
		}
	}
	
	$("btnStatementOfAccount").observe("click", function(){
		invoiceStatementOfAccountOverlay = Overlay.show(contextPath + "/GIACAgingSoaDetailController", {
			urlParameters : {
				action 		: "getInvoiceSoaDetails",
				issCd 		: objInvoiceInfo.selectedRow.issCd,
				premSeqNo	: objInvoiceInfo.selectedRow.premSeqNo
			},
			title : "Statement of Accounts",
			height : 315,
			width : 795,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});		
	});
	
	$("btnPaymentTerms").observe("click", function(){
		invoicePaytermsOverlay = Overlay.show(contextPath + "/GIPIInvoiceController?action=getInvoicePaytermsInfo", {
			urlParameters : {
				action 		: "getInvoicePaytermsInfo",
				issCd 		: objInvoiceInfo.selectedRow.issCd,
				premSeqNo	: objInvoiceInfo.selectedRow.premSeqNo,
				itemGrp		: objInvoiceInfo.selectedRow.itemGrp
			},
			title : "Payment Terms",
			height : 425,
			width : 790,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});		
	});
	
	$("btnTaxBreakdown").observe("click", function(){
		invoiceTaxOverlay = Overlay.show(contextPath + "/GIPIInvoiceController", {
			urlParameters : {
				action 		: "getInvoiceTaxDetails",
				issCd 		: objInvoiceInfo.selectedRow.issCd,
				premSeqNo	: objInvoiceInfo.selectedRow.premSeqNo,
				itemGrp		: objInvoiceInfo.selectedRow.itemGrp
			},
			title : "Tax Amounts",
			height : 400,
			width : 650,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});		
		
	});
	
	$("viewInvoiceInformationExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	setDocumentTitle("View Invoice Details");
	setModuleId("GIPIS137");
	populateFields(null);
</script>
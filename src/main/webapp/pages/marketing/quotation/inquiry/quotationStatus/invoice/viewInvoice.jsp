<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="invoiceMainDiv" name="invoiceMainDiv" class="sectionDiv" style="width: 750px; margin-top: 5px; margin-bottom: 2px;">
	<div id="invoiceInfoDiv" name="invoiceInfoDiv" style="margin: 10px 15px 10px 20px;">
		<table>
			<tr>
				<td class="rightAligned" style="margin-right: 0px;">Quote Invoice No.</td>
				<td style="width: 120px;"><input id="invoiceNo" name="invoiceNo" type="text" style="width: 100px; text-align: right; margin-left: 2px;" readonly="readonly"></td>
				<td class="rightAligned" style="width: 65px;">Issue Code</td>
				<td><input id="issCd" name="issCd" type="text" style="width: 40px; margin-right: 25px;" readonly="readonly"></td>
				
				<td class="rightAligned">Intermediary</td>
				<td>
					<input id="intmName" name="intmName" type="text" style="float: left; width: 247px; height: 13px; margin: 0px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Premium Amount</td>
				<td colspan="3"><input id="premAmt" name="premAmt" class="money" type="text" style="width: 227px; margin-left: 2px;" readonly="readonly"></td>
				<td class="rightAligned">Currency</td>
				<td><input id="currency" name="currency" type="text" style="width: 247px;" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="rightAligned">Tax Amount</td>
				<td colspan="3"><input id="taxAmt" name="taxAmt" class="money" type="text" style="width: 227px; margin-left: 2px;" readonly="readonly"></td>
				<td class="rightAligned">Rate</td>
				<td><input id="rate" name="rate" type="text" class="moneyRate" style="width: 247px;" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="rightAligned">Amount Due</td>
				<td colspan="3"><input id="amountDue" name="amountDue" class="money" type="text" style="margin-right: 10px; width: 227px; margin-left: 2px;" readonly="readonly"></td>
			</tr>
		</table>
	</div>
</div>
<div id="invoiceTGMainDiv" name="invoiceTGMainDiv" class="sectionDiv" style="height: 310px; width: 750px; margin-bottom: 5px;">
	<div id="invoiceTGDiv" name="invoiceTGDiv" style="height: 235px; padding-top: 10px; padding-left: 50px;">
		
	</div>
	<div id="invoiceDetailsDiv" name="invoiceDetailsDiv">
		<table align="center">
			<tr>
				<td class="rightAligned">Tax Description </td>
				<td>
					<input id="txtTaxDesc" name="txtTaxDesc" type="text" style="float: left; width: 295px; height: 13px; margin: 0px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Tax Amount </td>
				<td><input id="txtTaxAmt" name="txtTaxAmt" class="money" type="text" style="width: 295px;" maxlength="14" value="" readonly="readonly"></td>
			</tr>
		</table>
	</div>
</div>
<div id="invoiceButtonsDiv" name="invoiceButtonsDiv" class="buttonsDiv" style="margin-top: 5px; margin-bottom: 0px;">
	<input type="button" class="button" id="btnOkInvoice" name="btnOkInvoice" value="Ok">
</div>
<div id="invoiceHiddenDiv" name="invoiceHiddenDiv">
	<input id="hidLineCd" name="hidLineCd" type="hidden">
	<input id="hidIssCd" name="hidIssCd" type="hidden">
	<input id="hidQuoteInvNo" name="hidQuoteInvNo" type="hidden">
	<input id="hidTaxCd" name="hidTaxCd" type="hidden">
	<input id="hidTaxId" name="hidTaxId" type="hidden">
	<input id="hidTaxAmt" name="hidTaxAmt" type="hidden">
	<input id="hidRate" name="hidRate" type="hidden">
	<input id="hidFixedTaxAllocation" name="hidFixedTaxAllocation" type="hidden">
	<input id="hidItemGrp" name="hidItemGrp" type="hidden">
	<input id="hidTaxAllocation" name="hidTaxAllocation" type="hidden">
	<input id="hidPrimarySw" name=hidPrimarySw type="hidden">
	<input id="hidPerilSw" name=hidPerilSw type="hidden">
	<input id="hidNoRateTag" name=hidNoRateTag type="hidden">
	<input id="hidIntmNo" name=hidIntmNo type="hidden">
</div>
<script type="text/javascript">
	objQuote.invoiceInfo = JSON.parse('${invoiceInfo}'.replace(/\\/g, '\\\\'));
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	populateInvoiceInfo();

	var objInvoice = [];
	
	objQuote.objInvTaxDtlsTableGrid = JSON.parse('${invTaxTableGrid}');
	objQuote.objInvTaxDtlsRows = objQuote.objInvTaxDtlsTableGrid.rows || [];
	objQuote.selectedInvoiceIndex = -1;
	objQuote.selectedInvoiceInfoRow = "";
	try{
		var invTaxTableModel = {
			url: contextPath+"/GIPIQuoteInvoiceController?action=showInvoiceOverlay&refresh=1&quoteId="+objQuote.invoiceInfo.quoteId+
					"&currencyCd="+objQuote.invoiceInfo.currencyCd,
			options: {
				title: '',
              	height: '200px',
	          	width: '650px',
	          	onCellFocus: function(element, value, x, y, id){
	          		objQuote.selectedInvoiceIndex = y;
	          		objQuote.selectedInvoiceInfoRow = invTaxTableGrid.geniisysRows[y];
	          		$("txtTaxDesc").value = invTaxTableGrid.geniisysRows[y].taxDesc;
	          		$("txtTaxAmt").value = invTaxTableGrid.geniisysRows[y].taxAmt;
	          		populateHiddenFields(1);
	          		invTaxTableGrid.keys.releaseKeys();
                },
                onRemoveRowFocus: function(){
                	objQuote.selectedInvoiceIndex = -1;
                	objQuote.selectedInvoiceInfoRow = "";
                	$("txtTaxDesc").value = "";
	          		$("txtTaxAmt").value = "";
	          		populateHiddenFields(0);
                	invTaxTableGrid.keys.releaseKeys();
                },
                onSort: function(){
                	invTaxTableGrid.onRemoveRowFocus();
                },
                toolbar: {
                	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
                	onRefresh: function(){
                		invTaxTableGrid.onRemoveRowFocus();
                	},
                	onFilter: function(){
                		invTaxTableGrid.onRemoveRowFocus();
                	}
                }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'taxDesc',
							title: 'Tax Description',
							width: '370px',
							filterOption: true
						},
						{	id: 'taxAmt',
							title: 'Tax Amount',
							titleAlign: 'right',
							width: '232px',
							geniisysClass: 'money',
							align: 'right',
							filterOption: true,
							filterOptionType: 'number'
						},
						{	id: 'quoteInvNo',
							width: '0px',
							visible: false
						},
						{	id: 'lineCd',
							width: '0px',
							visible: false
						},
						{	id: 'issCd',
							width: '0px',
							visible: false
						},
						{	id: 'taxCd',
							width: '0px',
							visible: false
						},
						{	id: 'taxId',
							width: '0px',
							visible: false
						},
						{	id: 'rate',
							width: '0px',
							visible: false
						},
						{	id: 'itemGrp',
							width: '0px',
							visible: false
						},
						{	id: 'fixedTaxAllocation',
							width: '0px',
							visible: false
						},
						{	id: 'taxAllocation',
							width: '0px',
							visible: false
						},
						{	id: 'primarySw',
							width: '0px',
							visible: false
						},
						{	id: 'perilSw',
							width: '0px',
							visible: false
						},
						{	id: 'noRateTag',
							width: '0px',
							visible: false
						}
  					],  				
  				rows: objQuote.objInvTaxDtlsRows
		};
		invTaxTableGrid = new MyTableGrid(invTaxTableModel);
		invTaxTableGrid.pager = objQuote.objInvTaxDtlsTableGrid;
		invTaxTableGrid.render('invoiceTGDiv');
		invTaxTableGrid.afterRender = function(){
			objInvoice = invTaxTableGrid.geniisysRows;
		};
	}catch(e){
		showMessageBox("Error in Invoice Overlay TableGrid: " + e, imgMessage.ERROR);
	}
	
	$("btnOkInvoice").observe("click", function(){
		invTaxTableGrid.keys.releaseKeys();
		invoiceOverlay.close();
	});
	
	function populateInvoiceInfo(){
		$("invoiceNo").value = objQuote.invoiceInfo.quoteInvNo == null ? "" : objQuote.invoiceInfo.quoteInvNo.toPaddedString(12);
		$("intmName").value = unescapeHTML2(objQuote.invoiceInfo.intmName == null ? "" : objQuote.invoiceInfo.intmName);
		$("premAmt").value = objQuote.invoiceInfo.premAmt == null ? "" : formatCurrency(objQuote.invoiceInfo.premAmt);
		$("taxAmt").value = objQuote.invoiceInfo.taxAmt == null ? "" : formatCurrency(objQuote.invoiceInfo.taxAmt);
		$("amountDue").value = objQuote.invoiceInfo.amountDue == null ? "" : formatCurrency(objQuote.invoiceInfo.amountDue);
		$("currency").value = unescapeHTML2(objQuote.invoiceInfo.currencyDesc == null ? "" : objQuote.invoiceInfo.currencyDesc);
		$("rate").value = objQuote.invoiceInfo.currencyRt == null ? "" : formatToNineDecimal(objQuote.invoiceInfo.currencyRt);
		$("issCd").value = objQuote.invoiceInfo.issCd == null ? "" : unescapeHTML2(objQuote.invoiceInfo.issCd);
		$("hidIntmNo").value = objQuote.invoiceInfo.intmNo == null ? "" : objQuote.invoiceInfo.intmNo;
	}
	
	function populateHiddenFields(func){
		$("hidLineCd").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].lineCd : "";
		$("hidIssCd").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].issCd : "";
		$("hidQuoteInvNo").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].quoteInvNo : "";
		$("hidTaxCd").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].taxCd : "";
		$("hidTaxId").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].taxId : "";
		$("hidTaxAmt").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].taxAmt : "";
		$("hidRate").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].rate : "";
		$("hidFixedTaxAllocation").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].fixedTaxAllocation : "";
		$("hidItemGrp").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].itemGrp : "";
		$("hidTaxAllocation").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].taxAllocation : "";
		$("hidPrimarySw").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].primarySw : "";
		$("hidPerilSw").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].perilSw : "";
		$("hidNoRateTag").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].noRateTag : "";
	}

	function computeAmounts(){
		var taxTotal = 0;
		var dueTotal = 0;
		for(var i = 0; i < objInvoice.length; i++){
			if(objInvoice[i].recordStatus != -1){
				taxTotal = parseFloat(taxTotal) + parseFloat(unformatCurrencyValue(objInvoice[i].taxAmt));
			}
		}
		dueTotal = parseFloat(objQuote.invoiceInfo.premAmt) + parseFloat(taxTotal);
		
		$("taxAmt").value = formatCurrency(taxTotal);
		$("amountDue").value = formatCurrency(dueTotal);
	}
</script>
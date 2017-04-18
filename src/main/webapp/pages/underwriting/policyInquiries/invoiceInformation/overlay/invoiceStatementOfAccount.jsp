<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div class="sectionDiv" style="margin: 10px 5px 5px 5px; width:780px; float:left;">
	<table cellpadding="2" cellspacing="2" style="margin-top: 10px; margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="width: 150px;">Invoice Number</td>
			<td>
				<input type="text" id="txtSoaIssCd" name="txtSoaIssCd" style="width:50px; margin-left:5px;" readonly="readonly" tabindex="101" />
				<input type="text" id="txtSoaPremSeqNo" name="txtSoaPremSeqNo" style="width:138px; text-align:right;" readonly="readonly" tabindex="102"  />
				<input type="text" id="txtSoaItemGrp" name="txtSoaItemGrp" style="width:50px; text-align:right;"  readonly="readonly" tabindex="103" />
			</td>
			<td class="rightAligned" style="width: 220px;">Installment Number</td>
			<td><input type="text" id="txtInstNo" name="txtInstNo" style="margin-left:5px; width:100px; text-align:right;" readonly="readonly" tabindex="104" /></td>
		</tr>
		<tr>
			<td class="rightAligned">Next Age Level Date</td>
			<td><input type="text" id="txtNextAgeLevelDate" name="txtNextAgeLevelDate" style="margin-left:5px; width:200px;" readonly="readonly" tabindex="105"  /></td>
		</tr>
	</table>
</div>

<div class="sectionDiv" style="margin: 0 5px 5px 5px; width:780px;">
	<table cellpadding="2" cellspacing="2" style="margin-top: 10px; margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="width:150px;">Total Amount Due</td>
			<td><input type="text" id="txtTotalAmtDue" name="txtSoaIssCd" style="margin-left:5px; width:200px; text-align:right;" readonly="readonly" tabindex="106"  /></td>
			<td class="rightAligned" style="width: 180px;">Balance Amount Due</td>
			<td><input type="text" id="txtBalanceAmtDue" name="txtBalanceAmtDue" style="margin-left:5px; width:200px; text-align:right;" readonly="readonly" tabindex="107"  /></td>
		</tr>
		<tr>
			<td class="rightAligned">Total Payments</td>
			<td><input type="text" id="txtTotalPayments" name="txtTotalPayments" style="margin-left:5px; width:200px; text-align:right;" readonly="readonly" tabindex="108"  /></td>
			<td class="rightAligned">Prem Balance Due</td>
			<td><input type="text" id="txtPremBalanceDue" name="txtPremBalanceDue"  style="margin-left:5px; width:200px; text-align:right;" readonly="readonly" tabindex="109" /></td>
		</tr>
		<tr>
			<td class="rightAligned">Temp. Payments</td>
			<td><input type="text" id="txtTempPayments" name="txtTempPayments"  style="margin-left:5px; width:200px; text-align:right;" readonly="readonly" tabindex="110" /></td>
			<td class="rightAligned">Tax Balance Due</td>
			<td><input type="text" id="txtTaxBalanceDue" name="txtTaxBalanceDue" style="margin-left:5px; width:200px; text-align:right;" readonly="readonly" tabindex="111"  /></td>
		</tr>
	</table>
</div>

<div class="sectionDiv" style="margin: 0 5px 5px 5px; width:780px; float:left;">
	<table align="center" style="margin-top: 10px; margin-bottom:10px;">
		<tr>
			<td class="rightAligned">Status</td>
			<td><input type="text" id="txtStatus" name="txtStatus" style="margin-left:5px; width: 300px;" readonly="readonly" tabindex="112"  /></td>
		</tr>
	</table>
</div>

<div class="buttonsDiv" style="margin: 10px 5px 10px 5px; width:780px; float:left;">
	<input type="button" class="button" id="btnOk" name="btnOk" value="Ok" style="width:90px;" />
</div>

<script type="text/javascript">
	var soaDetails = JSON.parse('${invoiceSoaDetails}');
	
	function populateSoaDetails(){
		$("txtSoaIssCd").value 			= objInvoiceInfo.selectedRow.issCd;
		$("txtSoaPremSeqNo").value 		= formatNumberDigits(objInvoiceInfo.selectedRow.premSeqNo, 12);
		$("txtSoaItemGrp").value 		= formatNumberDigits(objInvoiceInfo.selectedRow.itemGrp, 2);
		$("txtInstNo").value 			= soaDetails != null ? formatNumberDigits(nvl(soaDetails.instNo, ""), 2) : "";
		$("txtNextAgeLevelDate").value 	= soaDetails != null ? nvl(soaDetails.nextAgeLevelDtStr, "") : "";
		$("txtTotalAmtDue").value 		= soaDetails != null ? formatCurrency(nvl(soaDetails.totAmtDue, "")) : "";
		$("txtBalanceAmtDue").value 	= soaDetails != null ? formatCurrency(nvl(soaDetails.balAmtDue, "")) : "";
		$("txtTotalPayments").value 	= soaDetails != null ? formatCurrency(nvl(soaDetails.totPaymts, "")) : "";
		$("txtPremBalanceDue").value 	= soaDetails != null ? formatCurrency(nvl(soaDetails.premBalDue, "")) : "";
		$("txtTempPayments").value 		= soaDetails != null ? formatCurrency(nvl(soaDetails.tempPaymts, "")) : "";
		$("txtTaxBalanceDue").value 	= soaDetails != null ? formatCurrency(nvl(soaDetails.taxBalDue, "")) : "";
		
		//$("txtStatus").value 			= soaDetails != null ? nvl(soaDetails.instNo, "") : "";
		var balAmtDue = parseFloat(soaDetails.balAmtDue);
		var tempPayts = parseFloat(soaDetails.tempPaymts);
		var totalPayts = parseFloat(soaDetails.totPaymts);
		var totalAmtDue = parseFloat(soaDetails.totAmtDue);
		if(balAmtDue == 0 && tempPayts != 0){
			$("txtStatus").value = "Full Payment";
		} else if(balAmtDue == 0){
			$("txtStatus").value = "Fully Paid";
		} else if(totalPayts == 0){
			$("txtStatus").value = "Unpaid";
		} else if(totalPayts < totalAmtDue){
			$("txtStatus").value = "Partially Paid";
		}
	}

	$("btnOk").observe("click", function(){
		invoiceStatementOfAccountOverlay.close();
	});
	
	populateSoaDetails();
</script>
<!--Remarks: For deletion
	Date : 06-06-2012
	Developer: Steven P. Ramirez
	Replacement : /pages/accounting/officialReceipt/otherTrans/withholdingTaxTableGrid.jsp
 -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="taxesWheldTableMainDiv" name="taxesWheldTableMainDiv" style="width: 921px;">
	<div id="searchResultTaxesWheld" align="center" style="margin: 10px;">
		<div style="width: 100%; text-align: center;" id="taxesWheldTable" name="taxesWheldTable">
			<div class="tableHeader">
				<label style="width:  60px;font-size: 10px; text-align: center;">Item No.</label>
				<label style="width:  70px;font-size: 10px; text-align: center;">Payee Class</label>
				<label style="width: 120px;font-size: 10px; text-align: center;">Payee</label>
				<label style="width: 110px;font-size: 10px; text-align: center;">Tax Description</label>
				<label style="width:  80px;font-size: 10px; text-align: center;">BIR Tax Code</label>
				<label style="width:  90px;font-size: 10px; text-align: right;">Rate %</label>
				<label style="width: 130px;font-size: 10px; text-align: center;">SL Name</label>
				<label style="width: 115px;font-size: 10px; text-align: right;">Income Amount</label>
				<label style="width: 120px;font-size: 10px; text-align: right; margin-left: 5px;">Withholding Tax Amt</label>
			</div>
			<div class="tableContainer" id="taxesWheldTableContainer" name="tableContainer" style="display: inline"></div>
			<!--
			<div class="tableHeader" style="display: block">
				<label style="width: 110px;font-size: 11px; text-align: center;">Total:</label>
				<label style="width: 650px;font-size: 10px; text-align: center;">&nbsp</label>
				<label style="width: 115px;font-size: 10px; text-align: right;" id="lblSumDspNetAmt" name="moneyLabel">${controlDrvCommAmt3 }</label>
			</div> -->
		</div>
	</div>
	<div id="taxesWheldTotalAmtMainDiv" class="tableHeader" style="margin:10px; margin-top:0px; display:block;">
		<div id="taxesWheldTotalAmtDiv">
			<label style="width: 660px;font-size: 11px; text-align: right;">Total Income Amount/Total Withholding Tax Amount</label>
			<label id="lblSumIncomeAmt" style="width: 115px;font-size: 10px; text-align: center;">0</label>
			<label id="lblSumWholdingTaxAmt" style="width: 120px;font-size: 10px; text-align: center;">0</label>
		</div>
	</div>
</div>

<script type="text/javascript">
	$$("label[name='moneyLabel']").each(function(label) {
		label.innerHTML = formatCurrency(label.innerHTML);
	});
</script>
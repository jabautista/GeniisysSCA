<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="faculClaimPaytsTableMainDiv" name="faculClaimPaytsTableMainDiv" style="width: 921px;">
	<div id="searchResultCommPayts" align="center" style="margin: 10px;">
		<div style="width: 100%; text-align: center;" id="faculClaimPaytsTable" name="faculClaimPaytsTable">
			<div class="tableHeader">
				<label style="width: 110px;font-size: 10px; text-align: center;">Transaction Type</label>
				<label style="width: 145px;font-size: 10px; text-align: center;">Advice No.</label>
				<label style="width:  80px;font-size: 10px; text-align: center;">Payee Class</label>
				<label style="width:  80px;font-size: 10px; text-align: center;">Peril</label>
				<label style="width: 115px;font-size: 10px; text-align: right;">Disbursement Amt</label>
				<label style="width: 115px;font-size: 10px; text-align: right;">Input Tax</label>
				<label style="width: 115px;font-size: 10px; text-align: right;">Withholding Tax</label>
				<label style="width: 115px;font-size: 10px; text-align: right;">Net Disbursement</label>
			</div>
			<div class="tableContainer" id="faculClaimPaytsTableContainer" name="tableContainer" style="display: inline"></div>
			<div class="tableHeader" style="display: block">
				<label style="width: 110px;font-size: 11px; text-align: center;">Total:</label>
				<label style="width: 650px;font-size: 10px; text-align: center;">&nbsp</label>
				<label style="width: 115px;font-size: 10px; text-align: right;" id="lblSumDspNetAmt" name="moneyLabel">${controlDrvCommAmt3 }</label>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$$("label[name='moneyLabel']").each(function(label) {
		label.innerHTML = formatCurrency(label.innerHTML);
	});
</script>
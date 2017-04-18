<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="overridingCommPaytsTableMainDiv" name="overridingCommPaytsTableMainDiv" style="width: 921px;">
	<div id="searchResultCommPayts" align="center" style="margin: 10px;">
		<div style="width: 100%; text-align: center;" id="overridingCommPaytsTable" name="overridingCommPaytsTable">
			<div class="tableHeader">
				<label style="width: 140px;font-size: 10px; text-align: center;">Transaction Type</label>
				<label style="width:  55px;font-size: 10px; text-align: center;">Bill No.</label>
				<label style="width: 135px;font-size: 10px; text-align: center;">Intermediary Name</label>
				<label style="width: 135px;font-size: 10px; text-align: center;">Child Intermediary</label>
				<label style="width: 103px;font-size: 10px; text-align: right;">Overriding Comm</label> <!-- adjust amount columns to 103px kenneth @ fgic -->
				<label style="width: 103px;font-size: 10px; text-align: right;">Input VAT</label>
				<label style="width: 103px;font-size: 10px; text-align: right;">Wholding Tax</label>
				<label style="width: 103px;font-size: 10px; text-align: right;">Net Commission</label>
			</div>
			<div class="tableContainer" id="overridingCommTableContainer" name="tableContainer" style="display: block"></div>
			<div class="tableHeader" style="display: block">
				<label style="width: 110px;font-size: 11px; text-align: center;">Total:</label>
				<label style="width: 355px;font-size: 10px; text-align: center;">&nbsp</label>
				<label style="width: 103px;font-size: 10px; text-align: right;" id="lblDrvCommAmt2" name="moneyLabel">${controlDrvCommAmt2 }</label>
				<label style="width: 103px;font-size: 10px; text-align: right;" id="lblDrvInvatAmt" name="moneyLabel">${controlDrvInvatAmt }</label>
				<label style="width: 103px;font-size: 10px; text-align: right;" id="lblDrvWtaxAmt" name="moneyLabel">${controlDrvWtaxAmt }</label>
				<label style="width: 103px;font-size: 10px; text-align: right;" id="lblDrvCommAmt3" name="moneyLabel">${controlDrvCommAmt3 }</label>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$$("label[name='moneyLabel']").each(function(label) {
		label.innerHTML = formatCurrency(label.innerHTML);
	});
</script>
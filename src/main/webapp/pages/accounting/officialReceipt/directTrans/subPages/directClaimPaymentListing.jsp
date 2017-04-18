<%@ page language="java" 	contentType="text/html; charset=ISO-8859-1"		pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" 	uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" 		uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" 	uri="http://www.atg.com/taglibs/json" %>
<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="directClaimPaymentListingDiv" style="margin: 10px;">
	<div id="directClaimPaymentTableHeader" class="tableHeader">
		<label style="text-align: center; width: 90px" title="Transaction Type"	>Trans Type</label>
		<label style="text-align: center; width: 134px"  title="Advice Number"	>Advice No.</label>
		<label style="text-align: center; width: 110px" title="Payee Class"	>Payee Class</label>
		<label style="text-align: center; width: 60px"  title="Peril"	>Peril</label>
		<label style="text-align: right; width: 122px" title="Disbursement Amount">Disbursement Amt</label>
		<label style="text-align: right; width: 122px" title="Input Tax" >Input Tax</label>
		<label style="text-align: right; width: 122px" title="Withholding Tax" >Wholding Tax</label>
		<label style="text-align: right; width: 130px" title="Net Disbursement">Net Disbursement</label>
	</div>
	<div id="directClaimPaymentListing">
		
	</div>
	<div id="directClaimPaymentTableHeader" class="tableHeader">
		<label id="lblTotalNetDisbursement"	name="lblTotalNetDisbursement" style="text-align: right; width: 98.8%">0.00</label>
	</div>
</div>

<script type="text/javascript">
	
</script>
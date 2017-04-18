<!--
Remarks: For deletion
Date : 04-13-2012
Developer: M.Cadwising
Replacement : /pages/accounting/officialReceipt/otherTrans/collnsForOtherOffTableGrid.jsp
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

<div id="collnsForOtherOffTableMainDiv" name="collnsForOtherOffTableMainDiv" style="width: 921px;">
	<div id="searchResultsCollns" style="margin: 10px;" align="center">
		<div style="width: 100%; text-align: center;" id="collnsForOtherOfficeTable" name="collnsForOtherOfficeTable">
			<div class="tableHeader">
				<label style="width: 70px;font-size: 10px; text-align: center;">Item No.</label>
				<label style="width: 120px;font-size: 10px;">Tran Type</label>
				<label style="width: 90px;font-size: 10px;">Fund Code</label>
				<label style="width: 100px;font-size: 10px;">Branch</label>
				<label style="width: 110px;font-size: 10px;">Old Tran No.</label>
				<label style="width: 80px;font-size: 10px;">Old Fund</label>
				<label style="width: 100px;font-size: 10px;">Old Branch</label>
				<label style="width: 100px;font-size: 10px;">Particulars</label>
				<label style="width: 100px;font-size: 10px; text-align: right;">Amount</label>		
			</div>
			<div class="tableContainer" id="collnsForOtherOfficeTableContainer" name="tableContainer" style="height: 155px; overflow-y:auto;"></div>
		</div>
	</div>
	<div style="height: 40px; margin: 10px; text-align: right;" align="right">
		<div id="collnTotalAmount" style="margin-bottom: 10px;">
			<label style="width: 660px; text-align: right; font-size: 11px; margin-bottom: 8px; font-weight: bold;">Total Collections</label>
			<label id="lblTotalCollections" style="text-align: right; width: 210px;font-size: 11px; font-weight: bold;">0</label>
		</div>
		<div id="totalRefundAmount" style="margin-top: 10px;">
			<label style="width: 660px; text-align: right; font-size: 11px; font-weight: bold;">Total Refund/Reclass</label>
			<label id="lblTotalRefund" style="text-align: right; width: 210px;font-size: 11px; font-weight: bold;">0</label>
		</div>
	</div>
</div>


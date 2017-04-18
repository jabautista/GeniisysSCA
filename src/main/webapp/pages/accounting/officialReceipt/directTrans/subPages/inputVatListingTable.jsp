<!--
Remarks: For deletion, replacement has been moved to inputVat.jsp 
Date : 03-23-2012
Developer: Maggie Cadwising
--> 

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div style="margin:10px; margin-top:5px; margin-bottom:0px; padding-top:1px;" id="directTransInputVatTable" name="directTransInputVatTable">
	<div class="tableHeader" style="margin-top: 5px;">
		<label style="text-align: left; 	width: 10%; margin-right: 3px;">Tran Type</label>
		<label style="text-align: left; 	width: 10%; margin-right: 3px;">Payee Class</label>
		<label style="text-align: left; 	width: 10%; margin-right: 3px;">Payee</label>
		<label style="text-align: left; 	width: 12%; margin-right: 3px;">Reference No.</label>
		<label style="text-align: right; 	width: 7%; 	margin-right: 5px;">Item No.</label>
		<label style="text-align: left; 	width: 10%; margin-right: 3px;">SL Name</label>
		<label style="text-align: right; 	width: 14%; margin-right: 3px;">Disbursement Amt</label>
		<label style="text-align: right; 	width: 12%; margin-right: 3px;">Base Amt</label>
		<label style="text-align: right; 	width: 12%;">Input VAT Amt</label>
	</div>	
	<div class="tableContainer" id="directTransInputVatListing" name="directTransInputVatListing" style="display: block;">
	</div>
</div>
<div id="inputVatTotalAmtMainDiv" class="tableHeader" style="margin:10px; margin-top:0px; display:block;">
	<div id="inputVatTotalAmtDiv" style="width:100%;">
		<label style="text-align:left; width:61%; margin-right: 2px;">Total:</label>
		<label style="text-align:right; width:14%; margin-right: 3px;" class="money">&nbsp;</label>
		<label style="text-align:right; width:12%; margin-right: 3px;" class="money">&nbsp;</label>
		<label style="text-align:right; width:12%; " class="money">&nbsp;</label>
	</div>
</div>
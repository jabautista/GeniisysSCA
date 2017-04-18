<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<% 
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="spinLoadingDiv"></div>
<div style="margin: 10px; margin-bottom: 10px; margin-top: 5px; padding-top: 1px;" id="casualtyPersonnelTable" name="casualtyPersonnelTable">	
	<div class="tableHeader" style="margin-top: 5px;">
		<label style="width: 120px; text-align: right; margin-right: 10px;">Personnel No.</label>
		<label style="width: 420px; padding-left: 20px;">Personnel Name</label>
		<label style="width: 280px; text-align: right;">Amount Covered</label>		
	</div>
	<div class="tableContainer" id="casualtyPersonnelListing" name="casualtyPersonnelListing" style="display: block;"></div>
	<div class="tableHeader" id="casualtyPersonnelTotalAmountDiv" style="display: none;">		
		<label style="text-align: left; width: 220px; margin-left: 5px; margin-right: 25px;">Total Amount: </label>
		<label id="casualtyPersonnelTotalAmount" style="text-align: right; width: 600px;" class="money"></label>
	</div>
</div>
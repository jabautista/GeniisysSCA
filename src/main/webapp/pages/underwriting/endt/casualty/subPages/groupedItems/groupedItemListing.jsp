<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<% 
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="spinLoadingDiv"></div>
<div style="margin: 10px; margin-bottom: 10px; margin-top: 5px; padding-top: 1px;" id="groupedItemsTable" name="groupedItemsTable">
	<div class="tableHeader" style="margin-top: 5px;">
		<label style="text-align: right; width: 120px; margin-right: 10px;">Grouped Item No.</label>
		<label style="text-align: left; width: 420px; padding-left: 20px;">Grouped Item Title</label>		
		<label style="text-align: right; width: 280px;">Amount Covered</label>
	</div>
	<div class="tableContainer" id="groupedItemListing" name="groupedItemListing" style="display: block;"></div>	
	<div class="tableHeader" id="groupedItemTotalAmountDiv" style="display: none;">
		<label style="text-align: left; width: 220px; margin-left: 5px; margin-right: 25px;">Total Amount:</label>
		<label id="groupedItemTotalAmount" style="text-align: right; width: 600px;" class="money"></label>
	</div>	
</div>

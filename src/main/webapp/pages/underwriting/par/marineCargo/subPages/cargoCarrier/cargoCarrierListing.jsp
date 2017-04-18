<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="spinLoadingDiv"></div>
<div style="margin: 10px; margin-bottom: 10px; margin-top: 5px; padding-top: 1px;" id="cargoCarrierTable" name="cargoCarrierTable">
	<div class="tableHeader" style="margin-top: 5px;">		
		<label style="text-align: left; width: 100px; margin-left: 5px; margin-right: 5px;">Vessel Code</label>
		<label style="text-align: left; width: 270px; margin-right: 5px;">Vessel Name</label>
		<label style="text-align: left; width: 100px; margin-right: 5px;">Plate No.</label>
		<label style="text-align: left; width: 100px; margin-right: 5px;">Motor No.</label>
		<label style="text-align: left; width: 100px; margin-right: 5px;">Serial No.</label>
		<label style="text-align: right; width: 150px;">Limit of Liability</label>
	</div>
	<div class="tableContainer" id="cargoCarrierListing" name="cargoCarrierListing" style="display: block;"></div>	
	<div class="tableHeader" id="cargoCarrierTotalAmountDiv" style="display: none;">
		<label style="text-align: left; width: 220px; margin-left: 5px; margin-right: 25px;">Total Amount:</label>
		<label id="cargoCarrierTotalAmount" style="text-align: right; width: 600px;" class="money"></label>
	</div>	
</div>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>
<div id="enterBondBillTakeUpListingTableMainDiv" name="enterBondBillTakeUpListingTableMainDiv" style="width: 100%; margin-top: 20px;">
	<div id="enterBondBillTakeUpListing" align="center" style="margin: 10px;">
		<div style="width: 100%; text-align: center;" id="enterBondBillTakeUpListingTable" name="enterBondBillTakeUpListingTable">
			<div class="tableHeader">
			      	<label style="width: 105px; text-align: left; margin-left: 25px; border: 1px solid #E0E0E0">Takeup Seq. No.</label> 
			      	<label style="width: 88px; text-align: left; margin-left: 15px; border: 1px solid #E0E0E0">Booking Date</label>
			      	<label style="width: 60px; text-align: left; margin-left: 45px; border: 1px solid #E0E0E0">Due Date</label>
			      	<label style="width: 120px; text-align: right; margin-left: 10px; border: 1px solid #E0E0E0">Bond Amount</label>
			      	<label style="width: 120px; text-align: right; margin-left: 10px; border: 1px solid #E0E0E0">Premium Amount</label>
			      	<label style="width: 120px; text-align: right; margin-left: 10px; border: 1px solid #E0E0E0">Total Tax</label>
			      	<label style="width: 120px; text-align: right; margin-left: 10px; border: 1px solid #E0E0E0">Total Amout Due</label>
			</div>
		</div>
		<div id="takeupTableContainer" class="tableContainer">	
					
		</div>
	</div>
</div>			
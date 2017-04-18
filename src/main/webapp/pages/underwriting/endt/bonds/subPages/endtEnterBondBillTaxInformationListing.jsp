<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>
<div id="enterBondBillTaxInformationListingTableMainDiv" name="enterBondBillTaxInformationListingTableMainDiv" style="width: 100%; margin-top: 20px;">
	<div id="enterBondBillTaxInformationListing" align="center" style="margin: 10px;">
		<div style="width: 75%; text-align: center; display: none;" id="enterBondBillTaxInformationListingTable" name="enterBondBillTaxInformationListingTable">
			<div class="tableHeader">
			      	<label style="width: 85px; text-align: center; margin-left: 25px; border: 1px solid #E0E0E0">Tax Code</label> <!-- #E0E0E0 -->
			      	<label style="width: 120px; text-align: left; margin-left: 35px; border: 1px solid #E0E0E0">Tax Description</label>
			      	<label style="width: 120px; text-align: right; margin-left: 85px; border: 1px solid #E0E0E0">Tax Amount</label>
			      	<label style="width: 120px; text-align: left; margin-left: 55px; border: 1px solid #E0E0E0">Tax Allocation</label>
			</div>
		</div>
		<div id="taxInformationTableContainer"  style="width: 75%; text-align: center;"  class="tableContainer">	
					
		</div>
	</div>
</div>			
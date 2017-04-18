<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="billPremiumsListingMainDiv" name="billPremiumsListingMainDiv" style="width: 921px;">
	<div id="billPremiumList" style="margin: 10px;" align="center">
		<div style="width: 100%; text-align: center;" id="billPremiumsListingTable" name="billPremiumsListingTable">
			<div class="tableHeader">
				<label style="text-align: right; margin-left: 25px;">Item Group</label>
				<label style="text-align: left; margin-left: 15px;">Takeup Seq. No.</label>
				<label style="text-align: right; margin-left: 25px;">Booking Date</label>
				<label style="text-align: right; margin-left: 50px; width: 100px;">Premium</label>
				<label style="text-align: right; margin-left: 25px; width: 100px;">Total Tax</label>
				<label style="text-align: right; margin-left: 25px; width: 100px;">
					<c:if test="${issCd ne 'RI'}">Other Charges</c:if>
					<c:if test="${issCd eq 'RI'}">Comm. Amt</c:if>
				</label>
				<label style="text-align: right; margin-left: 25px; width: 100px;">Amount Due</label>
			</div>
			
			<div class="tableContainer" id="billPremiumsTableListingContainer" name="billPremiumsTableListingContainer" style="display: block">
				
			</div>
		</div>
	</div>
</div>	
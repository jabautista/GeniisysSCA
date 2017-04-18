<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" style="float: left;" id="taxCollectionSectionDiv" name="taxCollectionSectionDiv">
	<div id="taxCollectionTableMainDiv" name="taxCollectionTableMainDiv" style="width: 100%; margin-top: 20px;">
		<div id="searchResultTaxCollection" align="center" style="margin: 10px;">
			<div style="width: 98%; text-align: center; display: block;" id="taxCollectionTable" name="taxCollectionTable">
				<div class="tableHeader">
					<label style="width: 90px; text-align:center; margin-left: 5px; border: 1px solid #E0E0E0;">Tran Type</label>
					<label style="width: 90px; text-align: center; margin-left: 5px; border: 1px solid #E0E0E0;">Issue Source</label>
					<label style="width: 90px; text-align: center; margin-left: 5px; border: 1px solid #E0E0E0;">Bill/CM No.</label>
					<label style="width: 70px; text-align: center; margin-left: 5px; border: 1px solid #E0E0E0;">Inst. No.</label>
					<label style="width: 350px; text-align: left; margin-left: 5px; border: 1px solid #E0E0E0;">Tax Name</label>
					<label style="width: 120px; text-align: right; margin-left: 6px; border: 1px solid #E0E0E0;">Tax Amount</label>
				</div>
				<div class="tableContainer" id="taxCollectionListContainer" name="taxCollectionListContainer"></div>
				<div class="tableHeader" id="taxCollectionMainTotal" style="width:100%;">
					<div id="taxCollectionTotals" style="width:100%;">
						<label style="text-align:left; width:37%; margin-left: 18px;">Total:</label>
						<label id="lblListTotalTaxAmount" style="text-align:right; width:15%; margin-left: 375px;" class="money">&nbsp;</label>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="spinLoadingDiv"></div>
<div style="margin: 10px; margin-bottom: 10px; margin-top: 5px; padding-top: 1px;" id="mortgageeTable" name="mortgageeTable">
	<div class="tableHeader" style="margin-top: 5px;">
		<label style="width: 80px; text-align: right; margin-right: 10px;">Item No.</label>
		<label style="width: 460px; padding-left: 20px;">Mortgagee Name</label>
		<label style="width: 280px; text-align: right;">Amount</label>		
	</div>
	<div class="tableContainer" id="mortgageeListing" name="mortgageeListing" style="display: block;"></div>
	<div class="tableHeader" id="mortgageeTotalAmountDiv" style="display: none;">		
		<label style="text-align: left; width: 220px; margin-left: 5px; margin-right: 25px;">Total Amount: </label>
		<label id="mortgageeTotalAmount" style="text-align: right; width: 600px;" class="money"></label>
	</div>
</div>
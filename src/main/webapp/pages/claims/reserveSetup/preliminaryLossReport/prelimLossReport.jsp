<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="prelimLossRepMainDiv" name="prelimLossRepMainDiv" style="margin-top: 1px; display: none;">
	<form id="prelimLossRepForm" name="prelimLossRepForm">
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Claim Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>
		<div id="groDivTop" name="groDivTop">
			<input type="hidden">
			<c:if test="${prelim=='Y'}">
				<jsp:include page="/pages/claims/reserveSetup/preliminaryLossReport/subPages/claimInformation.jsp"></jsp:include>
			</c:if>
			<c:if test="${prelim=='N'}">
				<jsp:include page="/pages/claims/generateAdvice/finalLossReport/finalLossRepClaimInfo.jsp"></jsp:include>
			</c:if>
		</div>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Item Information</label>
			</div>
		</div>
		<div id="groDivBot" name="groDivBot">
			
		</div>
		<c:if test="${prelim=='N'}">
			<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
				<div id="innerDiv" name="innerDiv">
					<label>Payee Details</label>
				</div>
			</div>
		</c:if>
		<div id="groDivPayee" name="groDivPayee">
		
		</div>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Distribution Details</label>
			</div>
		</div>
		<div id="groDivPeril" name="groDivPeril">
		
		</div>
		<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" style="width: 150px;" id="btnPremPayment" name="btnPremPayment" value="Premium Payment">
						<input type="button" class="button" style="width: 150px;" id="btnDocsOnFile" name="btnDocsOnFile" value="Documents on File">
						<input type="button" class="button" style="width: 90px;" id="btnPrint" name="btnPrint" value="Print">
					</td>
				</tr>
			</table>
		</div>
	</form>
</div>

<script>
	initializeAll();
	initializeAccordion();
	var claimId = '${claimId}';
	var lineCd = '${lineCd}';
	var prelim = '${prelim}';

	observeReloadForm("reloadForm", showPreliminaryLossReport);
	objCLM.prelimLossInfo = JSON.parse('${prelimLossInfoJSON}');
	populatePrelimLossInfo();
</script>
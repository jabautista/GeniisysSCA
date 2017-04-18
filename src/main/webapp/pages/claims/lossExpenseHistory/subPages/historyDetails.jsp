<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>History Details</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div id="historyDetailsMainDiv" name="historyDetailsMainDiv">
	<div class="sectionDiv" id="clmLossExpenseDiv" name="clmLossExpenseDiv">
		<jsp:include page="/pages/claims/lossExpenseHistory/subPages/clmLossExpense.jsp"></jsp:include>
	</div>
	<div class="sectionDiv" id="lossExpDtlDiv" name="lossExpDtlDiv">
		<jsp:include page="/pages/claims/lossExpenseHistory/subPages/lossExpDetail.jsp"></jsp:include>
	</div>
</div>
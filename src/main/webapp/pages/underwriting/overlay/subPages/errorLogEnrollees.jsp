<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div style="margin: 0px;">
	<div class="tableHeader">
		<label style="width: 10%; text-align: left; margin-left:2px;">Upload No</label>
		<label style="width: 10%; text-align: left; margin-left:2px;">Filename</label>
		<label style="width: 10%; text-align: left; margin-left:2px;">G.I. No</label>
		<label style="width: 10%; text-align: left; margin-left:2px;">Title</label>
		<label style="width: 3%;  text-align: left; margin-left:2px;">S</label>
		<label style="width: 3%;  text-align: left; margin-left:2px;">C</label>
		<label style="width: 10%; text-align: left; margin-left:2px;">Birthday</label>
		<label style="width: 4%;  text-align: left; margin-left:2px;">Age</label>
		<label style="width: 16%; text-align: right; margin-left:2px;">Salary</label>
		<label style="width: 4%;  text-align: right; margin-left:2px;">SG</label>
		<label style="width: 16%; text-align: right; margin-left:2px;">Amount Coverage</label>
	</div>
	<div id="errorListTable" name="errorListTable" class="tableContainer" style="font-size: 11px;">
		<c:forEach var="error" items="${errors}">
			<div id="row${error.uploadNo}" name="row" class="tableRow">
				<label name="textErr" style="width: 10%; text-align: left; margin-left:2px;">${error.uploadNo}<c:if test="${empty error.uploadNo}">---</c:if></label>
				<label name="textErr" style="width: 10%; text-align: left; margin-left:2px;">${error.filename}<c:if test="${empty error.filename}">---</c:if></label>
				<label name="textErr" style="width: 10%; text-align: left; margin-left:2px;">${error.groupedItemNo}<c:if test="${empty error.groupedItemNo}">---</c:if></label>
				<label name="textErr" style="width: 10%; text-align: left; margin-left:2px;">${error.groupedItemTitle}<c:if test="${empty error.groupedItemTitle}">---</c:if></label>
				<label name="textErr" style="width: 3%;  text-align: left; margin-left:2px;">${error.sex}<c:if test="${empty error.sex}">---</c:if></label>
				<label name="textErr" style="width: 3%;  text-align: left; margin-left:2px;">${error.civilStatus}<c:if test="${empty error.civilStatus}">---</c:if></label>
				<label name="textErr" style="width: 10%; text-align: left; margin-left:2px;"><fmt:formatDate value="${error.dateOfBirth }" pattern="MM-dd-yyyy" /><c:if test="${empty error.dateOfBirth}">---</c:if></label>
				<label name="textErr" style="width: 4%;  text-align: left; margin-left:2px;">${error.age}<c:if test="${empty error.age}">---</c:if></label>
				<label name="textErrAmt" style="width: 16%; text-align: right; margin-left:2px;" class="money">${error.salary}<c:if test="${empty error.salary}">---</c:if></label>
				<label name="textErr" style="width: 4%;  text-align: right; margin-left:2px;">${error.salaryGrade}<c:if test="${empty error.salaryGrade}">---</c:if></label>
				<label name="textErrAmt" style="width: 16%; text-align: right; margin-left:2px;" class="money">${error.amountCoverage}<c:if test="${empty error.amountCoverage}">---</c:if></label>
			</div>
		</c:forEach>
		<c:if test="${empty errors}">
			<div id="rowEmpty" name="rowEmpty" class="tableRow">
				<label style="float:center;">Error Log Empty</label>
			</div>
		</c:if>
	</div>
</div>
<script type="text/JavaScript">
	initializeTable("tableContainer", "row", "", "");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	$$("label[name='textErr']").each(function (label)    {
   		if ((label.innerHTML).length > 10)    {
        	label.update((label.innerHTML).truncate(10, "..."));
    	}
	});
	$$("label[name='textErrAmt']").each(function (label)    {
   		if ((label.innerHTML).length > 15)    {
        	label.update((label.innerHTML).truncate(15, "..."));
    	}
	});
</script>

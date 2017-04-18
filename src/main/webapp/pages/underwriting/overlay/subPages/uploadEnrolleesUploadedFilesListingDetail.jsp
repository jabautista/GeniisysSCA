<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
		<div style="margin: 5px;" id="uploadEnrolleesTable2" name="uploadEnrolleesTable2">	
			<div class="tableHeader" style="margin-top: 5px; font-size: 11px;">
				<label style="text-align: left; width: 6%; margin-right: 4px;">Code</label>
				<label style="text-align: left; width: 8%; margin-right: 4px;">Title</label>
				<label style="text-align: left; width: 1%; margin-right: 4px;">S</label>
				<label style="text-align: left; width: 9%; margin-right: 4px;">Civil Status</label>
				<label style="text-align: left; width: 8%; margin-right: 4px;">Birthday</label>
				<label style="text-align: left; width: 9%; margin-right: 2px;">From Date</label>
				<label style="text-align: left; width: 8%; margin-right: 4px;">To Date</label>
				<label style="text-align: right; width: 4%; margin-right: 4px;">Age</label>
				<label style="text-align: right; width: 12%; margin-right: 4px;">Salary</label>
				<label style="text-align: left; width: 3%; margin-right: 4px;">SG</label>
				<label style="text-align: left; width: 10%; margin-right: 4px;">Upload Date</label>
				<label style="text-align: right; width: 15%;">Amount Coverage</label>
			</div>
			
			<div class="tableContainer" id="uploadEnrolleesListing2" name="uploadEnrolleesListing2" style="display: block; width:100%; font-size: 11px;">
				<c:forEach var="gipiUploadTemp" items="${gipiUploadTemp}">
					<div id="row2UploadEnrollees${gipiUploadTemp.uploadNo}${gipiUploadTemp.filename}${gipiUploadTemp.controlCd}${gipiUploadTemp.controlTypeCd}" uploadNo="${gipiUploadTemp.uploadNo }" name="uploadEnr2" class="tableRow" style="padding-left:1px;">
						<label name="textUpDetail" style="text-align: left; width: 6%; margin-right: 4px;">${gipiUploadTemp.controlCd }<c:if test="${empty gipiUploadTemp.controlCd}">---</c:if></label>
						<label name="textUpDetail" style="text-align: left; width: 8%; margin-right: 4px;">${gipiUploadTemp.groupedItemTitle }<c:if test="${empty gipiUploadTemp.groupedItemTitle}">---</c:if></label>
						<label name="textUpDetail" style="text-align: left; width: 1%; margin-right: 4px;">${gipiUploadTemp.sex }<c:if test="${empty gipiUploadTemp.sex}">-</c:if></label>
						<label name="textUpDetail" style="text-align: left; width: 9%; margin-right: 4px;">${gipiUploadTemp.civilStatus }<c:if test="${empty gipiUploadTemp.civilStatus}">---</c:if></label>
						<label name="textUpDetail" style="text-align: left; width: 8%; margin-right: 6px;"><fmt:formatDate value="${gipiUploadTemp.dateOfBirth }" pattern="MM-dd-yyyy" /><c:if test="${empty gipiUploadTemp.dateOfBirth }">---</c:if></label>
						<label name="textUpDetail" style="text-align: left; width: 9%; margin-right: 2px;"><fmt:formatDate value="${gipiUploadTemp.fromDate }" pattern="MM-dd-yyyy" /><c:if test="${empty gipiUploadTemp.fromDate }">---</c:if></label>
						<label name="textUpDetail" style="text-align: left; width: 8%; margin-right: 4px;"><fmt:formatDate value="${gipiUploadTemp.toDate }" pattern="MM-dd-yyyy" /><c:if test="${empty gipiUploadTemp.toDate }">---</c:if></label>
						<label name="textUpDetail" style="text-align: right; width: 4%; margin-right: 4px;">${gipiUploadTemp.age }<c:if test="${empty gipiUploadTemp.age}">---</c:if></label>
						<label name="textUpDetailAmt" style="text-align: right; width: 12%; margin-right: 4px;" class="money">${gipiUploadTemp.salary }<c:if test="${empty gipiUploadTemp.salary}">---</c:if></label>
						<label name="textUpDetail" style="text-align: left; width: 3%; margin-right: 4px;">${gipiUploadTemp.salaryGrade }<c:if test="${empty gipiUploadTemp.salaryGrade}">---</c:if></label>
						<label name="textUpDetail" style="text-align: left; width: 10%; margin-right: 4px;"><fmt:formatDate value="${gipiUploadTemp.uploadDate }" pattern="MM-dd-yyyy" /><c:if test="${empty gipiUploadTemp.uploadDate }">---</c:if></label>
						<label name="textUpDetailAmt" style="text-align: right; width: 15%;" class="money">${gipiUploadTemp.amountCoverage }<c:if test="${empty gipiUploadTemp.amountCoverage}">---</c:if></label>
					</div>
				</c:forEach>
			</div>
		</div>
		
		<label id="detailsEmpty" name="detailsEmpty" style="display:none; margin-left:10px; text-align:left;">No Records Available</label>
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	$$("label[name='textUpDetail']").each(function (label)    {
   		if ((label.innerHTML).length > 10)    {
        	label.update((label.innerHTML).truncate(10, "..."));
    	}
	});

	$$("label[name='textUpDetailAmt']").each(function (label)    {
   		if ((label.innerHTML).length > 15)    {
        	label.update((label.innerHTML).truncate(15, "..."));
    	}
	});

	$$("div[name='uploadEnr2']").each(function (newDiv){
		newDiv.observe("mouseover", function ()	{
			newDiv.addClassName("lightblue");
		});
				
		newDiv.observe("mouseout", function ()	{
			newDiv.removeClassName("lightblue");
		});
    });			
	
</script>	
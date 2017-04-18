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
		<div style="margin: 10px;" id="benefeciaryTable" name="benefeciaryTable">	
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 20%; margin-left: 10px;">Name</label>
				<label style="text-align: left; width: 15%; margin-right: 10px;">Address</label>
				<label style="text-align: left; width: 10%; margin-right: 10px;">Birthday</label>
				<label style="text-align: left; width: 10%; margin-right: 10px;">Age</label>
				<label style="text-align: left; width: 15%; margin-right: 10px;">Relation</label>
				<label style="text-align: left; width: 20%;">Remarks</label>
			</div>
			
			<div class="tableContainer" id="beneficiaryListing" name="beneficiaryListing" style="display: block;">
				<c:forEach var="ben" items="${gipiWBeneficiary}">
					<div id="rowBen${ben.itemNo}${ben.beneficiaryNo}" item="${ben.itemNo}" beneficiaryNo="${ben.beneficiaryNo }" name="ben" class="tableRow" style="padding-left:1px;">
						<input type="hidden"	id="benItemParIds"				name="benItemParIds"				value="${ben.parId}" />
						<input type="hidden"	id="benItemItemNos"				name="benItemItemNos"				value="${ben.itemNo}" />
						<input type="hidden" 	id="benBeneficiaryNos" 			name="benBeneficiaryNos" 			value="${ben.beneficiaryNo}" />
						<input type="hidden" 	id="benBeneficiaryNames" 		name="benBeneficiaryNames" 			value="${ben.beneficiaryName}" />
						<input type="hidden" 	id="benBeneficiaryAddrs" 		name="benBeneficiaryAddrs" 			value="${ben.beneficiaryAddr}" />
						<input type="hidden" 	id="benBeneficiaryDateOfBirths" name="benBeneficiaryDateOfBirths" 	value="<fmt:formatDate value="${ben.dateOfBirth}" pattern="MM-dd-yyyy" />" />
						<input type="hidden" 	id="benBeneficiaryAges" 		name="benBeneficiaryAges" 			value="${ben.age}" />
						<input type="hidden" 	id="benBeneficiaryRelations" 	name="benBeneficiaryRelations" 		value="${ben.relation}" />
						<input type="hidden" 	id="benBeneficiaryRemarks" 		name="benBeneficiaryRemarks" 		value="${ben.remarks}" />
						
						<label name="textBenefeciary" style="width: 20%; margin-right: 10px;" for="ben${ben.beneficiaryName}">${ben.beneficiaryName }<c:if test="${empty ben.beneficiaryName}">---</c:if></label>
						<label name="textBenefeciary" style="width: 15%; margin-right: 10px;" for="ben${ben.beneficiaryAddr}">${ben.beneficiaryAddr }<c:if test="${empty ben.beneficiaryAddr}">---</c:if></label>
						<label name="textBenefeciary" style="width: 10%; margin-right: 10px;" for="ben${ben.dateOfBirth}"><fmt:formatDate value="${ben.dateOfBirth}" pattern="MM-dd-yyyy" /><c:if test="${empty ben.dateOfBirth}">---</c:if></label>
						<label name="textBenefeciary" style="width: 10%; margin-right: 10px;" for="ben${ben.age}">${ben.age }<c:if test="${empty ben.age}">---</c:if></label>
						<label name="textBenefeciary" style="width: 15%; margin-right: 10px;" for="ben${ben.relation}">${ben.relation }<c:if test="${empty ben.relation}">---</c:if></label>
						<label name="textBenefeciary" style="width: 20%;" for="ben${ben.remarks}">${ben.remarks }<c:if test="${empty ben.remarks}">---</c:if></label>
					</div>
				</c:forEach>
			</div>
		</div>
		
<script type="text/javascript">
	$$("label[name='textBenefeciary']").each(function (label)    {
   		if ((label.innerHTML).length > 20)    {
        	label.update((label.innerHTML).truncate(20, "..."));
    	}
	});
</script>	
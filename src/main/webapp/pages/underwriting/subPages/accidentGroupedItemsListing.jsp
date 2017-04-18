<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="spinLoadingDiv"></div>
		<div style="margin: 10px; margin-bottom:0px;" id="accidentGroupedItemsTable" name="accidentGroupedItemsTable">	
			<div class="tableHeader" style="margin-top: 5px; font-size: 10px;">
				<label style="text-align: left; width: 10%; margin-right: 2px;">Enrollee Code</label>
				<label style="text-align: left; width: 12%; margin-right: 2px;">Enrollee Name</label>
				<label style="text-align: left; width: 11%; margin-right: 0px;">Principal Code</label>
				<label style="text-align: left; width: 8%;  margin-right: 4px;">Plan</label>
				<label style="text-align: left; width: 11%; margin-right: 2px;">Payment Mode</label>
				<label style="text-align: left; width: 12%; margin-right: 2px;">Effectivity Date</label>
				<label style="text-align: left; width: 10%; margin-right: 0px;">Expiry Date</label>
				<label style="text-align: right; width: 9%; margin-right: 2px;">Tsi Amount</label>
				<label style="text-align: right; width: 14%;">Premium Amount</label>
			</div>
			
			<div class="tableContainer" id="accidentGroupedItemsListing" name="accidentGroupedItemsListing" style="display: block;">
				<c:forEach var="grpItem" items="${gipiWGroupedItems}">
					<div id="rowGroupedItems${grpItem.itemNo}${grpItem.groupedItemNo}" item="${grpItem.itemNo}" groupedItemNo="${grpItem.groupedItemNo}" groupedItemTitle="${grpItem.groupedItemTitle }" name="grpItem" class="tableRow" style="padding-left:1px;">
						<input type="hidden" id="grpParIds" 		     		name="grpParIds" 	        	value="${grpItem.parId}" />
			 	  		<input type="hidden" id="grpItemNos" 		     		name="grpItemNos" 	        	value="${grpItem.itemNo}" /> 
						<input type="hidden" id="grpGroupedItemNos"       		name="grpGroupedItemNos"     	value="${grpItem.groupedItemNo}" />
						<input type="hidden" id="grpGroupedItemTitles"  	 	name="grpGroupedItemTitles"  	value="${grpItem.groupedItemTitle}" />
						<input type="hidden" id="grpPrincipalCds" 	 			name="grpPrincipalCds" 		 	value="${grpItem.principalCd }" /> 
						<input type="hidden" id="grpPackBenCds" 				name="grpPackBenCds"  			value="${grpItem.packBenCd }" /> 
						<input type="hidden" id="grpPaytTermss" 				name="grpPaytTermss" 			value="${grpItem.paytTerms }" /> 
						<input type="hidden" id="grpFromDates"   				name="grpFromDates"  	 		value="<fmt:formatDate value='${grpItem.fromDate }' pattern="MM-dd-yyyy" />" /> 
						<input type="hidden" id="grpToDates"  	 				name="grpToDates" 	 			value="<fmt:formatDate value='${grpItem.toDate }' pattern="MM-dd-yyyy" />" /> 
						<input type="hidden" id="grpSexs"  	 					name="grpSexs" 	 				value="${grpItem.sex }" /> 
						<input type="hidden" id="grpDateOfBirths"  	 			name="grpDateOfBirths" 	 		value="<fmt:formatDate value='${grpItem.dateOfBirth }' pattern="MM-dd-yyyy" />" /> 
						<input type="hidden" id="grpAges"  	 					name="grpAges" 	 				value="${grpItem.age }" /> 
						<input type="hidden" id="grpCivilStatuss"  	 			name="grpCivilStatuss" 	 		value="${grpItem.civilStatus }" /> 
						<input type="hidden" id="grpPositionCds"  	 			name="grpPositionCds" 	 		value="${grpItem.positionCd }" /> 
						<input type="hidden" id="grpGroupCds"  	 				name="grpGroupCds" 	 			value="${grpItem.groupCd }" /> 
						<input type="hidden" id="grpControlTypeCds"  	 		name="grpControlTypeCds" 	 	value="${grpItem.controlTypeCd }" /> 
						<input type="hidden" id="grpControlCds"  	 			name="grpControlCds" 	 		value="${grpItem.controlCd }" /> 
						<input type="hidden" id="grpSalarys"  	 				name="grpSalarys" 	 			value="${grpItem.salary }" /> 
						<input type="hidden" id="grpSalaryGrades"  	 			name="grpSalaryGrades" 	 		value="${grpItem.salaryGrade }" /> 
						<input type="hidden" id="grpAmountCovereds"  	 		name="grpAmountCovereds" 	 	value="${grpItem.amountCovered }" /> 
						<input type="hidden" id="grpIncludeTags"  	 			name="grpIncludeTags" 	 		value="${grpItem.includeTag }" /> 
						<input type="hidden" id="grpRemarkss"  	 				name="grpRemarkss" 	 			value="${grpItem.remarks }" /> 
						<input type="hidden" id="grpLineCds"  	 				name="grpLineCds" 	 			value="${grpItem.lineCd }" /> 
						<input type="hidden" id="grpSublineCds"  	 			name="grpSublineCds" 	 		value="${grpItem.sublineCd }" /> 
						<input type="hidden" id="grpDeleteSws"  	 			name="grpDeleteSws" 	 		value="${grpItem.deleteSw }" /> 
						<input type="hidden" id="grpAnnTsiAmts"  	 			name="grpAnnTsiAmts" 	 		value="${grpItem.annTsiAmt }" /> 
						<input type="hidden" id="grpAnnPremAmts"  	 			name="grpAnnPremAmts" 	 		value="${grpItem.annPremAmt }" /> 
						<input type="hidden" id="grpTsiAmts"  	 				name="grpTsiAmts" 	 			value="${grpItem.tsiAmt }" /> 	
						<input type="hidden" id="grpPremAmts"  	 				name="grpPremAmts" 	 			value="${grpItem.premAmt }" /> 
						<input type="hidden" id="grpPlanDescs"  	 			name="grpPlanDescs" 		 	value="${grpItem.packageCd }" /> 
						<input type="hidden" id="grpPaymentDescs"  	 			name="grpPaymentDescs" 	 		value="${grpItem.paytTermsDesc }" /> 
						<input type="hidden" id="grpOverwriteBens"  	 		name="grpOverwriteBens" 	 	value="" />
												
						<label name="textG" id="num" style="text-align: left; width: 10%; margin-right: 2px;">${grpItem.groupedItemNo}<c:if test="${empty grpItem.groupedItemNo}">---</c:if></label>
					    <label name="textG2" style="text-align: left; width: 12%; margin-right: 2px;">${grpItem.groupedItemTitle}<c:if test="${empty grpItem.groupedItemTitle}">---</c:if></label>
						<label name="textG" id="num" style="text-align: left; width: 11%; margin-right: 0px;">${grpItem.principalCd}<c:if test="${empty grpItem.principalCd}">---</c:if></label>
						<label name="textG3" style="text-align: left; width: 8%;  margin-right: 4px;">${grpItem.packageCd}<c:if test="${empty grpItem.packageCd}">---</c:if></label>
						<label name="textG2" style="text-align: left; width: 11%; margin-right: 2px;">${grpItem.paytTermsDesc}<c:if test="${empty grpItem.paytTermsDesc}">---</c:if></label>
						<label name="textG" style="text-align: left; width: 12%; margin-right: 3px;"><fmt:formatDate value='${grpItem.fromDate }' pattern="MM-dd-yyyy" /><c:if test="${empty grpItem.fromDate}">---</c:if></label>
						<label name="textG" style="text-align: left; width: 10%; margin-right: 2px;"><fmt:formatDate value='${grpItem.toDate }' pattern="MM-dd-yyyy" /><c:if test="${empty grpItem.toDate}">---</c:if></label>
						<label name="textG" style="text-align: left; width: 9%; margin-right: 2px; text-align:right;" class="money">${grpItem.tsiAmt}<c:if test="${empty grpItem.tsiAmt}">---</c:if></label>
						<label name="textG" style="text-align: left; width: 14%; text-align:right;" class="money">${grpItem.premAmt}<c:if test="${empty grpItem.premAmt}">---</c:if></label>
					</div>
				</c:forEach>
			</div>
		</div>
		
<script type="text/javascript">
	$$("label[name='textG']").each(function (label)    {
   		if ((label.innerHTML).length > 10)    {
        	label.update((label.innerHTML).truncate(10, "..."));
    	}
	});
	$$("label[name='textG2']").each(function (label)    {
   		if ((label.innerHTML).length > 15)    {
        	label.update((label.innerHTML).truncate(15, "..."));
    	}
	});
	$$("label[name='textG3']").each(function (label)    {
		if (label.innerHTML != "---"){
        	label.update((label.innerHTML).truncate(1, "..."));
    	}
	});
	$$("label[id='num']").each(function (label)    {
		if (label.innerHTML != "---"){
        	label.update(formatNumberDigits(label.innerHTML,7));
		}
	});
	$$("div[name='grpItem']").each(function(newDiv){
		no = newDiv.getAttribute("groupedItemNo");
		newDiv.setAttribute("groupedItemNo",formatNumberDigits(no,7)); 
		newDiv.setAttribute("id","rowGroupedItems"+$F("itemNo")+formatNumberDigits(no,7));
	});
		
</script>	
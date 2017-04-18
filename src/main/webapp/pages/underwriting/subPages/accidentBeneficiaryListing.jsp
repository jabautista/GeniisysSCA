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
		<div style="margin: 10px;" id="bBenefeciaryTable" name="bBenefeciaryTable">	
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 20%; margin-right: 10px;">Name</label>
				<label style="text-align: left; width: 17%; margin-right: 10px;">Address</label>
				<label style="text-align: left; width: 10%; margin-right: 10px;">Birthday</label>
				<label style="text-align: left; width: 10%; margin-right: 10px;">Age</label>
				<label style="text-align: left; width: 14%; margin-right: 10px;">Relation</label>
				<label style="text-align: right; width: 20%;">Tsi Amount</label>
			</div>
			
			<div class="tableContainer" id="bBeneficiaryListing" name="bBeneficiaryListing" style="display: block;">
				<c:forEach var="benefit" items="${gipiWGrpItemsBeneficiary}">
					<div id="rowBenInfo${benefit.groupedItemNo}${benefit.beneficiaryNo}" item="${benefit.itemNo}" beneficiaryNo="${benefit.beneficiaryNo }" groupedItemNo="${benefit.groupedItemNo }" name="benefit" class="tableRow" style="padding-left:1px;">
						<input type="hidden" id="bencParIds" 		     	name="bencParIds" 	        	value="${benefit.parId }" />
			 	  		<input type="hidden" id="bencItemNos" 		    	name="bencItemNos" 	        	value="${benefit.itemNo }" />
						<input type="hidden" id="bencBeneficiaryNos"      	name="bencBeneficiaryNos"    	value="${benefit.beneficiaryNo }" />
						<input type="hidden" id="bencBeneficiaryNames"  	name="bencBeneficiaryNames"  	value="${benefit.beneficiaryName }" />
						<input type="hidden" id="bencBeneficiaryAddrs" 		name="bencBeneficiaryAddrs" 	value="${benefit.beneficiaryAddr }" />
						<input type="hidden" id="bencDateOfBirths" 			name="bencDateOfBirths"  		value="<fmt:formatDate value="${benefit.dateOfBirth }" pattern="MM-dd-yyyy" />" />
						<input type="hidden" id="bencAges" 					name="bencAges" 		 		value="${benefit.age }" />
						<input type="hidden" id="bencRelations"   			name="bencRelations"  	 		value="${benefit.relation }" />
						<input type="hidden" id="bencCivilStatuss"  	 	name="bencCivilStatuss" 	 	value="${benefit.civilStatus }" />
						<input type="hidden" id="bencSexs"  				name="bencSexs" 				value="${benefit.sex }" />
						<input type="hidden" id="bencGroupedItemNos"  		name="bencGroupedItemNos" 		value="${benefit.groupedItemNo }" />
						
						<label name="textBen" style="width: 20%; margin-right: 10px; text-align: left;">${benefit.beneficiaryName }<c:if test="${empty benefit.beneficiaryName}">---</c:if></label>
						<label name="textBen" style="width: 17%; margin-right: 10px; text-align: left;">${benefit.beneficiaryAddr }<c:if test="${empty benefit.beneficiaryAddr}">---</c:if></label>
						<label name="textBen" style="width: 10%; margin-right: 10px; text-align: left;"><fmt:formatDate value="${benefit.dateOfBirth }" pattern="MM-dd-yyyy" /><c:if test="${empty benefit.dateOfBirth }">---</c:if></label>
						<label name="textBen" style="width: 10%; margin-right: 10px; text-align: left;">${benefit.age }<c:if test="${empty benefit.age}">---</c:if></label>
						<label name="textBen" style="width: 14%; margin-right: 10px; text-align: left;">${benefit.relation }<c:if test="${empty benefit.relation}">---</c:if></label>
						<label name="textBen" style="width: 20%; text-align: right;">---</label>
					</div>
				</c:forEach>
			</div>
		</div>
		
<script type="text/javascript">
	$$("label[name='textBen']").each(function (label)    {
   		if ((label.innerHTML).length > 20)    {
        	label.update((label.innerHTML).truncate(20, "..."));
    	}
	});
</script>	
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
		<div style="margin:10px; margin-bottom:0px; margin-top:5px; padding-top:1px;" id="personnelTable" name="personnelTable">	
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 25%; margin-right: 10px;">Personnel Name</label>
				<label style="text-align: left; width: 20%; margin-right: 10px;">Capacity</label>
				<label style="text-align: left; width: 25%; margin-right: 7px;">Remarks</label>
				<label style="text-align: right; width: 26%;">Amount Covered</label>
			</div>
			
			<div class="tableContainer" id="personnelListing" name="personnelListing" style="display: block;">
				<c:forEach var="per" items="${gipiWCasualtyPersonnel}">
					<div id="rowPer${per.itemNo}${per.personnelNo}" item="${per.itemNo}" personnelNo="${per.personnelNo }" name="per" class="tableRow" style="padding-left:1px;">
						<input type="hidden"	id="perItemParIds"			name="perItemParIds"		value="${per.parId}" />
						<input type="hidden"	id="perItemItemNos"			name="perItemItemNos"		value="${per.itemNo}" />
						<input type="hidden" 	id="perPersonnelNos" 		name="perPersonnelNos" 		value="${per.personnelNo}" />
						<input type="hidden" 	id="perPersonnelNames" 		name="perPersonnelNames" 	value="${per.personnelName}" />
						<input type="hidden" 	id="perAmountCovereds" 		name="perAmountCovereds" 	value="${per.amountCovered}" class="money"/>
						<input type="hidden" 	id="perCapacityCds" 		name="perCapacityCds" 		value="${per.capacityCd}" />
						<input type="hidden" 	id="perRemarkss" 			name="perRemarkss" 			value="${per.remarks}" />
						<input type="hidden" 	id="perIncludeTags" 		name="perIncludeTags" 		value="${per.includeTag}" />
						<input type="hidden" 	id="perCapacityDescs" 		name="perCapacityDescs" 	value="${per.capacityDesc}" />
						
						<label name="textPersonnel" style="width: 25%; margin-right: 10px;" >${per.personnelName}<c:if test="${empty per.personnelName}">---</c:if></label>
						<label name="textPersonnel" style="width: 20%; margin-right: 10px;" >${per.capacityDesc }<c:if test="${empty per.capacityDesc}">---</c:if></label>
						<label name="textPersonnel" style="width: 25%; margin-right: 7px;" >${per.remarks }<c:if test="${empty per.remarks}">---</c:if></label>
						<label name="textPersonnel" style="width: 26%; text-align: right;" <c:if test="${!empty per.amountCovered}">class="money"</c:if>>${per.amountCovered }<c:if test="${empty per.amountCovered}">---</c:if></label>
					</div>
				</c:forEach>
			</div>
		</div>
		<div id="personnelInfoTotalAmtDiv" style="display:none; margin:10px; margin-top:0px;">
			<div class="tableHeader" style="margin-top: 0px;">
				<label style="text-align: left; width: 25%;">Total:</label>
				<label style="text-align: right; width:70%; float:right; margin-right:10px;" class="money">&nbsp;</label>
			</div>
		</div>
		
<script type="text/javascript">
	$$("label[name='textPersonnel']").each(function (label)    {
   		if ((label.innerHTML).length > 22)    {
        	label.update((label.innerHTML).truncate(22, "..."));
    	}
	});
</script>	
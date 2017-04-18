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
		<div style="margin:10px; margin-bottom:0px; margin-top:5px; padding-top:1px;" id="groupedItemsTable" name="groupedItemsTable">	
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 25%; margin-right: 10px;">Grouped Item</label>
				<label style="text-align: left; width: 20%; margin-right: 10px;">Group</label>
				<label style="text-align: left; width: 25%; margin-right: 7px;">Remarks</label>
				<label style="text-align: right; width: 26%; ">Amount Covered</label>
			</div>
			
			<div class="tableContainer" id="groupedItemsListing" name="groupedItemsListing" style="display: block;">
				<c:forEach var="grpItem" items="${gipiWGroupedItems}">
					<div id="rowGroupedItems${grpItem.itemNo}${grpItem.groupedItemNo}" item="${grpItem.itemNo}" groupedItemNo="${grpItem.groupedItemNo}" groupedItemTitle="${grpItem.groupedItemTitle }" name="grpItem" class="tableRow" style="padding-left:1px;">
						<input type="hidden"	id="grpItemParIds"				name="grpItemParIds"			value="${grpItem.parId}" />
						<input type="hidden"	id="grpItemItemNos"				name="grpItemItemNos"			value="${grpItem.itemNo}" />
						<input type="hidden" 	id="grpItemGroupedItemNos" 		name="grpItemGroupedItemNos" 	value="${grpItem.groupedItemNo}" />
						<input type="hidden" 	id="grpItemGroupedItemTitles" 	name="grpItemGroupedItemTitles" value="${grpItem.groupedItemTitle}" />
						<input type="hidden" 	id="grpItemAmountCovereds" 		name="grpItemAmountCovereds" 	value="${grpItem.amountCovered}" class="money"/>
						<input type="hidden" 	id="grpItemGroupCds" 			name="grpItemGroupCds" 			value="${grpItem.groupCd}" />
						<input type="hidden" 	id="grpItemRemarkss" 			name="grpItemRemarkss" 			value="${grpItem.remarks}" />
						<input type="hidden" 	id="grpItemIncludeTags" 		name="grpItemIncludeTags" 		value="${grpItem.includeTag}" />
						<input type="hidden" 	id="grpItemGroupDescs" 			name="grpItemGroupDescs" 		value="${grpItem.groupDesc}" />
						
						<label name="textGroupItem" style="width: 25%; margin-right: 10px;" >${grpItem.groupedItemTitle}<c:if test="${empty grpItem.groupedItemTitle}">---</c:if></label>
						<label name="textGroupItem" style="width: 20%; margin-right: 10px;" >${grpItem.groupDesc }<c:if test="${empty grpItem.groupDesc}">---</c:if></label>
						<label name="textGroupItem" style="width: 25%; margin-right: 7px;" >${grpItem.remarks }<c:if test="${empty grpItem.remarks}">---</c:if></label>
						<label name="textGroupItem" style="width: 26%; text-align: right;" <c:if test="${!empty grpItem.amountCovered}">class="money"</c:if>>${grpItem.amountCovered }<c:if test="${empty grpItem.amountCovered}">---</c:if></label>
					</div>
				</c:forEach>
			</div>
			
		</div>
		<div id="groupedItemsTotalAmtDiv" style="display:none; margin:10px; margin-top:0px;">
			<div class="tableHeader" style="margin-top: 0px;">
				<label style="text-align: left; width: 25%;">Total:</label>
				<label style="text-align: right; width:70%; float:right; margin-right:10px;" class="money">&nbsp;</label>
			</div>
		</div>	
		
<script type="text/javascript">
	$$("label[name='textGroupItem']").each(function (label)    {
   		if ((label.innerHTML).length > 22)    {
        	label.update((label.innerHTML).truncate(22, "..."));
    	}
	});
</script>	
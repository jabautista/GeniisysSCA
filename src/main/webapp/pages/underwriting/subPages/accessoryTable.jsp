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
<div style="margin: 10px; margin-bottom: 10px; margin-top: 5px; padding-top: 1px;" id="accessoryTable" name="accessoryTable">	
	<div class="tableHeader" style="margin-top:5px;">
		<label style="text-align: right; width: 80px; margin-right: 10px;">Item No.</label>
		<label style="text-align: left; width: 460px; padding-left: 20px;">Accessory</label>
		<label style="text-align: right; width: 280px;">Amount</label>
	</div>
	<div class="tableContainer" id="accListing" name="accListing" style="display: block;">
		<!-- 
		<c:forEach var="acc" items="${gipiWMcAcc}">
			<div id="rowAcc${acc.itemNo}${acc.accessoryCd}" item="${acc.itemNo}" accCd="${acc.accessoryCd}" name="acc" dAmt="${acc.accAmt}" class="tableRow" style="padding-left:1px;">
				<input type="hidden" 	id="accParId" 		name="accParId" 	value="${acc.parId}" />
				<input type="hidden"	id="accItemNo"		name="accItemNo"	value="${acc.itemNo}" />
				<input type="hidden" 	id="accCd" 			name="accCd" 		value="${acc.accessoryCd}" />
				<input type="hidden" 	id="accDesc" 		name="accDesc"		value="${acc.accessoryDesc}" />
				<input type="hidden" 	id="accAmt"  		name="accAmt" 		value="${acc.accAmt}" class="money" />

				<label name="text" style="text-align: right; width: 5%; margin-right: 10px;" for="accessory${acc.itemNo}">${acc.itemNo}</label>
				<label name="text" style="text-align: left; width: 55%; margin-right: 8px;" for="accessory${acc.accessoryDesc}">${acc.accessoryDesc}</label>
				<label name="text" style="text-align: right; width: 37%;" <c:if test="${!empty acc.accAmt}">class="money"</c:if> for="accessory${acc.accAmt}">${acc.accAmt }</label>
			</div>
		</c:forEach>
		 -->
	</div>
	<div class="tableHeader" id="accTotalAmountDiv" style="display: none;">
		<label style="text-align: left; width: 220px; margin-left: 5px; margin-right: 25px;">Total Amount: </label>
		<label id="accTotalAmount" style="text-align: right; width: 600px;" class="money"></label>
	</div>
</div>
<!-- 
<div id="accTotalAmtDiv" style="display:none; margin:10px; margin-top:0px;">
	<div class="tableHeader" style="margin-top: 0px;">
		<label style="text-align: left; width: 25%;">Total:</label>
		<label style="text-align: right; width:70%; float:right; margin-right:10px;" class="money">&nbsp;</label>
	</div>
</div>
 -->

<script type="text/javascript">
	/*
	$$("label[name='text']").each(function (label)    {
   		if ((label.innerHTML).length > 35)    {
        	label.update((label.innerHTML).truncate(35, "..."));
    	}
	});
	*/
</script>

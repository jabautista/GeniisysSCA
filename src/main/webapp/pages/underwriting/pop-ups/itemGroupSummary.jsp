<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 


<div id="spinLoadingDiv"></div>
   <div id="contentsDiv" class="sectionDiv">
		<div id="itemGrpSummary" name="itemGrpSummary">
			<div class="tableHeader">
				<label style="width: 10%; text-align: right;">Group</label>
				<label style="width: 20%; text-align: right;">Take-up</label>
				<label style="padding-left:5%; width:30%; text-align:left;">Property</label>
				<label style="width: 20%; text-align: left;">Terms</label>
				<label style="width: 10%; text-align: right;">Due Date</label>
 			</div>
 			
 			<div class="tableContainer" id="WinItemListing" name="WinItemListing" style="display: block;">
				<input type="hidden" id="parId" name="parId" value="${gipiWInvoice[0].parId}" />
				<c:forEach var="itemGrp" items="${itemGrpGipiWinvoice}">
					<input type="hidden" id="sumItemGrp" name="sumItemGrp" value="${itemGrp.itemGrp}">
						<div id="wItemList" name="wItemList">
							<c:forEach var="witems" items="${gipiWInvoice}">
							 	<div id="witems${witems.itemGrp}${witems.takeupSeqNo}${witems.property}${witems.paytTerms}${witems.dueDate}" name="witems" class="tableRow">
							 		<input type="hidden" value="${witems.itemGrp }" />
									<label style="width: 10%; text-align: right;">${witems.itemGrp}</label>
									<label style="width: 20%; text-align: right;">
										<c:if test="${empty witems.takeupSeqNo }">
											0
										</c:if>	
											${witems.takeupSeqNo}
									</label>
									<label style="padding-left:5%; width:30%; text-align: left;">${witems.property}</label>
									<label style="width: 20%; text-align: left;">${witems.paytTerms}</label>
									<label style="width: 10%; text-align: right;"><fmt:formatDate value="${witems.dueDate}" pattern="MM-dd-yyyy" /></label>
								</div>
							</c:forEach>
						</div>
					</c:forEach>
				</div>
		</div>
		
</div>
<!-- <div style="padding-left: 50%" >
	<input type="button" class="button" id="btnSumItemReturn" value="Return" />
</div>-->

<script type="text/javascript">
initializeAll();
initializeAllMoneyFields();
initializeTable("tableContainer", "witems", "", "");
$$("div[name='witems']").each(
	function (itemList)	{
		/*installment.observe("mouseover", function ()	{
			installment.addClassName("lightblue");
		});
		
		installment.observe("mouseout", function ()	{
			installment.removeClassName("lightblue");
		});*/
		
		itemList.observe("click", function ()	{
			//installment.toggleClassName("selectedRow");
			/*if (installment.hasClassName("selectedRow"))	{
				$$("div[name='wInstallment']").each(function (li)	{
					if (installment.getAttribute("id") != li.getAttribute("id"))	{
						li.removeClassName("selectedRow");
					}
				});
			} else {
				null;
			}*/
		}); 
	}
);	
</script>

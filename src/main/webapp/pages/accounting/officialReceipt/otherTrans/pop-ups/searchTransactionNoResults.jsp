<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly"/>
<div class="tableContainer" style="font-size: 12px;">
	<c:choose>
		<c:when test="${empty searchResult}">List of Values Contains No Entries</c:when>
		<c:otherwise>
			<div class="tableHeader">
				<label style="width: 120px; text-align: left; margin-left: 5px; margin-right: 10px;">Fund Code</label>
				<label style="width: 120px; margin-right: 10px;">Branch Code</label>
				<label style="width: 150px;">Old Tran No.</label>
				<label style="width: 100px; text-align: center;">Item No.</label>
			</div>
			<div>
				<c:forEach var="tranNo" items="${searchResult}" varStatus="ctr">
					<div id="modalRow${ctr.index}" name="row" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
						<label style="width: 120px; text-align: left; margin-left: 5px; margin-right: 10px;" id="lblFundCd${ctr.index}">${tranNo.gofcGibrGfunFundCd }</label>
						<label style="width: 120px; margin-right: 10px;" id="lblBranchCd${ctr.index}">${tranNo.gofcGibrBranchCd }</label>
						<label style="width: 150px;">${tranNo.oldTranNo}</label>
						<label style="width: 100px; text-align: center;">${tranNo.itemNo}</label>
						<input type="hidden" value="${tranNo.oldTranNo}">
						<input type="hidden" value="${tranNo.gofcGibrGfunFundCd}">
						<input type="hidden" value="${tranNo.gofcGibrBranchName}">
						<input type="hidden" value="${tranNo.itemNo}">
						<input type="hidden" value="${tranNo.gaccTranId}">
						<input type="hidden" value="${tranNo.gofcGibrBranchCd}">
						<input type="hidden" value="${tranNo.tranYear}">
						<input type="hidden" value="${tranNo.tranMonth}">
						<input type="hidden" value="${tranNo.tranSeqNo}">
					</div>
				</c:forEach>
			</div>
		</c:otherwise>
	</c:choose>
</div>
<div class="pager" id="pager">
	<div align="right">
	Page:
		<select id="tranNoPage" name="tranNoPage">
			<c:forEach var="page" begin="1" end="${noOfPages}" varStatus="status">
				<option value="${page}"
					<c:if test="${pageNo eq page}">
					selected="selected"
					</c:if>
				>${page}</option>
			</c:forEach>
		</select> of ${noOfPages}
	</div>
</div>

<script type="text/javascript">
	$$("div[name='row']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
		
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$("selectedRow").value = row.id;
					$$("div[name='row']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
				} else {
					$("selectedRow").value = "";
				}
			});
		}
	);

	$("tranNoPage").observe("change", function(){
		var page = parseInt($("tranNoPage").options[$("tranNoPage").selectedIndex].value); 
		if(page != "" || page != null){
			searchTransactionNoDetails(page);
		}
	});

	if('${noOfPages}' == 1){
		$("pager").hide();
	}
	
	positionPageDiv();
	
</script>
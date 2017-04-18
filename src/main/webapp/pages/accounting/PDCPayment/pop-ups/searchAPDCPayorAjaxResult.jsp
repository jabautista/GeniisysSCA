<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedPayor" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div class="tableHeader">
		<label style="width: 180px; margin-left: 15px;">APDC Number</label>
		<label style="width: 180px;">APDC Date</label>
		<label style="width: 270px;">Payor</label>
		<label style="width: 80px;">Status</label>
	</div>
	<div>
		<c:forEach var="apdcPayor" items="${apdcPaytListing}">
			<div id="row${apdcPayor.apdcId}" name="row" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 180px; margin-left: 12px;" id="apdcNo${apdcPayor.apdcId}" name="apdcNo" title="${apdcPayor.apdcNo}">${apdcPayor.apdcPref}-${apdcPayor.apdcNo}</label>
				<label style="width: 180px; id=apdcDate${apdcPayor.apdcId}" name="apdcDate" title="${apdcPayor.apdcDate}"><fmt:formatDate value="${apdcPayor.apdcDate}" pattern="MM-dd-yyyy" /></label>
				<label style="width: 270px; id=payor${apdcPayor.apdcId}" name="payor" title="${apdcPayor.payor}">${apdcPayor.payor}</label>
				<label style="width: 80px; id=status${apdcPayor.apdcId}" name="status" title="${apdcPayor.apdcFlag}">${apdcPayor.apdcFlag}</label>
				<input type="hidden" id="apdcPref${apdcPayor.apdcId}" name="apdcPref" value="${apdcPayor.apdcPref}" />
				<input type="hidden" id="apdcNo${apdcPayor.apdcId}" name="apdcNo" value="${apdcPayor.apdcNo}" />
				<input type="hidden" id="refApdcNo${apdcPayor.apdcId}" name="refApdcNo" value="${apdcPayor.refApdcNo}" />
				<input type="hidden" id="apdcFlagMeaning${apdcPayor.apdcId}" name="apdcFlagMeaning" value="${apdcPayor.apdcFlagMeaning}" />
				<input type="hidden" id="particulars${apdcPayor.apdcId}" name="particulars" value="${apdcPayor.particulars}" />
				<input type="hidden" id="apdcId${apdcPayor.apdcId}" name="apdcId" value="${apdcPayor.apdcId}" />
				<input type="hidden" id="cashierCd${apdcPayor.apdcId}" name="cashierCd" value="${apdcPayor.cashierCd}" />
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select onchange="searchAPDCPayor(this.value, '');">
				<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageNo==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfPages}
		</div>
	</c:if>
</div>
<script type="text/JavaScript">
	//position page div correctly
	var product = 288 - (parseInt($$("div[name='row']").size())*28);
	$("pager").setStyle("margin-top: "+product+"px;");

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
					$("selectedPayor").value = row.getAttribute("id").substring(3);
					$$("div[name='row']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
				}	
			});
		}
	);

</script>
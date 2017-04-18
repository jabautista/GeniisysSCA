<!-- 
Remarks: For deletion
Date : 06-21-2012
Developer: Emsy
Replacement : showGIISCurrencyLOV() in accounting-lov.js
-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div class="tableContainer" style="width: 750px; font-size: 12px; overflow: auto;">
	<div class="tableHeader" style="width: 750px; overflow: auto;">
		<label style="width:  80px; margin-left: 10px; text-align: right">Code</label>
		<label style="width: 500px; margin-left: 10px; text-align: left">Description</label>
		<label style="width: 100px; margin-left: 10px; text-align: right">Rate</label>
	</div>
	<div style="width: 750px; overflow: auto;">
		<c:forEach var="currency" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width:  80px; margin-left: 10px; text-align: right" id="modalLblCurrencyCd${ctr.index}" name="modalLblCurrencyCd" title="${currency.code}">${currency.code}</label>
				<label style="width: 500px; margin-left: 10px; text-align: left"  id="modalLblCurrencyDesc${ctr.index }">${currency.desc }</label>
				<label style="width: 100px; margin-left: 10px; text-align: right"  id="modalLblCurrencyRt${ctr.index }">${currency.valueFloat }</label>
				<input type="hidden" id="modalRowCurrencyCd${ctr.index }" 	name="modalRowOldItemNo" 	value="${currency.code}"/>
				<input type="hidden" id="modalRowCurrencyDesc${ctr.index }" name="modalRowOldTranType" 	value="${currency.desc}"/>
				<input type="hidden" id="modalRowCurrencyRt${ctr.index }"	name="modalRow" 	value="${currency.valueFloat}"/>
				<input type="hidden" id="modalRowShortName${ctr.index }"	name="modalRow" 	value="${currency.shortName}"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" style="width: 750px" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="currencyPage" name="currencyPage">
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
	var product = 288 - (parseInt($$("div[name='modalRow']").size())*28);
	$("pager").setStyle("margin-top: "+product+"px;");

	$$("div[name='modalRow']").each(
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
					$$("div[name='modalRow']").each(function (r)	{
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

	if ($("currencyPage") != null) {
		$("currencyPage").observe("change", function() {
			//onChange="searchCommPaytsBillNoDetails(this);"
			page = $("currencyPage").options[$("currencyPage").selectedIndex].value;
			if (!page.blank()) {
				showGIISCurrencyLOVAjaxResult($("currencyPage").options[$("currencyPage").selectedIndex].value);
			}
		});
	}
</script>
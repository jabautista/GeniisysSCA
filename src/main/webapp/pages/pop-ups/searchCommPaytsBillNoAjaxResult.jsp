<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div class="tableHeader">
		<label style="width: 200px; margin-left: 15px;">Iss Cd</label>
		<label style="width: 100px;">Bill</label>
	</div>
	<div>
		<c:forEach var="bill" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 200px; margin-left: 10px;" id="modalLblIssCd${ctr.index}" name="modalIssCd" title="${bill.issCd}">${bill.issCd}</label>
				<label style="width: 100px;" id="modalLblBillNo${ctr.index }">${bill.bill }</label>
				<input type="hidden" id="modalRowBillNo${ctr.index }" name="modalRowBillNo" value="${bill.bill }"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="billNoPage" name="billNoPage">
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

	if ($("billNoPage") != null) {
		$("billNoPage").observe("change", function() {
			//onChange="searchCommPaytsBillNoDetails(this);"
			page = $("billNoPage").options[$("billNoPage").selectedIndex].value;
			if (!page.blank()) {
				searchCommPaytsBillNoDetails($("billNoPage").options[$("billNoPage").selectedIndex].value);
			}
		});
	}
</script>
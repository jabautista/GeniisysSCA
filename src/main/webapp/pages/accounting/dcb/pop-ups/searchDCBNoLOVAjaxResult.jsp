<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div id="modalDCBNoDivTableContainer" class="tableContainer" style="font-size: 12px; width: 250px; overflow: auto">
	<div class="tableHeader" style="overflow: auto">
		<label style="width: 100px; text-align: center">DCB No.</label>
	</div>
	<div style="overflow: auto">
		<c:forEach var="dcb" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 100px; text-align: left" id="modalLblDCBNo${ctr.index }">${dcb.dcbNo }</label>
				<input type="hidden" id="modalRowDCBNo${ctr.index }" name="modalRowDCBNo" value="${dcb.dcbNo }"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager" style="overflow: auto">
	<c:if test="${noOfPages>1}">
		<div align="right" style="overflow: auto">
		Page:
			<select id="dcbNoInvPage" name="dcbNoInvPage">
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

	if ($("dcbNoInvPage") != null) {
		$("dcbNoInvPage").observe("change", function() {
			page = $("dcbNoInvPage").options[$("dcbNoInvPage").selectedIndex].value;
			if (!page.blank()) {
				searchDCBNoLOV($("dcbNoInvPage").options[$("dcbNoInvPage").selectedIndex].value);
			}
		});
	}
</script>
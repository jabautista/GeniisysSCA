<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px; overflow: auto">
	<div class="tableHeader">
		<label style="width: 80px; margin-left: 15px;">Intm No</label>
		<label style="width: 500px;">Intm Name</label>
	</div>
	<div>
		<c:forEach var="intm" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 80px; margin-left: 10px;" id="modalLblIntmNo${ctr.index}" name="modalIntmNo" title="${intm.intmNo}">${intm.intmNo}</label>
				<label style="width: 500px;" id="modalLblIntmName${ctr.index }">${intm.intmName }</label>
				<input type="hidden" id="modalRowIntmNo${ctr.index }" 	name="modalRowIntmNo" 	value="${intm.intmNo}"/>
				<input type="hidden" id="modalRowIntmName${ctr.index }" name="modalRowIntmName" value="${intm.intmName}"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="intmNoPage" name="intmNoPage">
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

	if ($("intmNoPage") != null) {
		$("intmNoPage").observe("change", function() {
			//onChange="searchCommPaytsBillNoDetails(this);"
			page = $("intmNoPage").options[$("intmNoPage").selectedIndex].value;
			if (!page.blank()) {
				showIntermediaryAjaxResult($("intmNoPage").options[$("intmNoPage").selectedIndex].value);
			}
		});
	}
</script>
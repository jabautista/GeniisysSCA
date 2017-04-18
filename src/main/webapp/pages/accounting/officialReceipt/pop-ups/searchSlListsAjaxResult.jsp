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
	<c:choose>
		<c:when test="${empty searchResult}">List of values contains no entries</c:when>
		<c:otherwise>
			<div class="tableHeader">
				<label style="width: 50px; text-align: right; margin-left: 5px; margin-right: 10px;">Sl Code</label>
				<label style="width: 350px; margin-right: 10px;">Sl Name</label>
				<label style="width: 100px; text-align: right">Sl Type Code</label>
			</div>
			<div>
				<c:forEach var="slLists" items="${searchResult}" varStatus="ctr">
					<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
						<label style="width: 50px; text-align: right; margin-left: 5px; margin-right: 10px;" id="modalLblSlCd${ctr.index}" name="modalSlCd" title="${slLists.slCd}">${slLists.slCd}</label>
						<label style="width: 350px; margin-right: 10px;" id="modalLblSlName${ctr.index }"   name="modalLblSlName">${slLists.slName }</label>
						<label style="width: 100px; text-align: right; " id="modalLblSlTypeCd${ctr.index }">${slLists.slTypeCd }</label>
						<input type="hidden" id="modalRowSlCd${slLists.slCd }" 			name="modalRowInput" value="${slLists.slCd }"/>
						<input type="hidden" id="modalRowSlName${slLists.slCd }" 		name="modalRowInput" value="${slLists.slName }"/>
						<input type="hidden" id="modalRowSlTypeCd${slLists.slCd }" 		name="modalRowInput" value="${slLists.slTypeCd }"/>
					</div>
				</c:forEach>
			</div>
		</c:otherwise>
	</c:choose>
</div>
<div class="pager" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="slListsPage" name="slListsPage">
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

			// for Sl Name
			row.down("label", 1).innerHTML = row.down("label", 1).innerHTML.truncate(44, "...");
		}
	);

	if ($("slListsPage") != null) {
		$("slListsPage").observe("change", function() {
			//onChange="searchCommPaytsBillNoDetails(this);"
			page = $("slListsPage").options[$("slListsPage").selectedIndex].value;
			if (!page.blank()) {
				searchSlListsDetails($("slListsPage").options[$("slListsPage").selectedIndex].value);
			}
		});
	}
</script>
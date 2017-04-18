<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px; width: 900px; overflow: auto;">
	<div class="tableHeader" style="overflow: auto;">
		<label style="width: 80px; margin-left: 10px; text-align: right">Intm No</label>
		<label style="width: 580px; margin-left: 22px; text-align: left">Intm Name</label>
		<label style="width: 150px; margin-left: 15px; text-align: left">Ref Intm. Cd.</label>
	</div>
	<div style="overflow: auto;">
		<c:forEach var="intm" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px; margin-left: 10px">
				<label style="width: 80px; margin-left: 10px; text-align: right" id="modalLblIntmNo${ctr.index}" name="modalIntmNo" title="${intm.intmNo}">${intm.intmNo}</label>
				<label style="width: 580px; margin-left: 10px; text-align: left" id="modalLblIntmName${ctr.index }" name="intmNoLOVLabel">${intm.intmName }</label>
				<label style="width: 150px; margin-left: 10px; text-align: left" id="modalLblRefIntmCd${ctr.index }" name="intmNoLOVLabel">${intm.refIntmCd }<c:if test="${empty intm.refIntmCd}">---</c:if></label>
				<input type="hidden" id="modalRowIntmNo${ctr.index }" 			name="modalRowIntmNo" 			value="${intm.intmNo}"/>
				<input type="hidden" id="modalRowIntmName${ctr.index }" 		name="modalRowIntmName" 		value="${intm.intmName}"/>
				<input type="hidden" id="modalRowParentIntmNo${ctr.index }" 	name="modalRowParentIntmNo" 	value="${intm.parentIntmNo}"/>
				<input type="hidden" id="modalRowParentIntmName${ctr.index }" 	name="modalRowParentIntmName" 	value="${intm.parentIntmName}"/>
				<input type="hidden" id="modalRowActiveTag${ctr.index }" 		name="modalRowActiveTag" 		value="${intm.activeTag}"/>
				<input type="hidden" id="modalRowRefIntmCd${ctr.index }" 		name="modalRowRefIntmCd" 		value="${intm.refIntmCd}"/>
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
	var lovName = '${lovName }';
	$("pager").setStyle("margin-top: "+product+"px;");

	$$("label[name='intmNoLOVLabel']").each(function(label) {
		label.innerHTML = label.innerHTML.truncate(50, "...");
	});

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
				showGipis085IntmAjaxResult($("intmNoPage").options[$("intmNoPage").selectedIndex].value);
			}
		});
	}
</script>
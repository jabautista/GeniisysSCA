<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div id="modalDCBPayModeDivTableContainer" class="tableContainer" style="font-size: 12px; width: 390px; overflow: auto">
	<div class="tableHeader" style="overflow: auto">
		<label style="width: 100px; text-align: center">Pay Mode</label>
		<label style="width: 250px; margin-left: 30px; text-align: center">Description</label>
	</div>
	<div style="overflow: auto">
		<c:forEach var="paymode" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 100px; text-align: center" id="modalLblPayMode${ctr.index }">${paymode.rvLowValue }</label>
				<label style="width: 250px; margin-left: 30px; text-align: center" id="modalLblDesc${ctr.index }" name="modalLblDesc">${paymode.rvMeaning }</label>
				<input type="hidden" id="modalRowPayMode${ctr.index }" name="modalRowPayMode" value="${paymode.rvLowValue }"/>
				<input type="hidden" id="modalRowDesc${ctr.index }" name="modalRowDesc" value="${paymode.rvMeaning }"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager" style="overflow: auto">
	<c:if test="${noOfPages>1}">
		<div align="right" style="overflow: auto">
		Page:
			<select id="payModeInvPage" name="payModeInvPage">
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

	$$("label[name='modalLblDesc']").each(
		function(label) {
			if ((label.innerHTML).length > 30)    {
	            label.update((label.innerHTML).truncate(25, "..."));
	        }

			Effect.Appear("modalDCBPayModeDivTableContainer", {
		    	duration: 0.3
		    });
		}
	);

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

	if ($("payModeInvPage") != null) {
		$("payModeInvPage").observe("change", function() {
			page = $("payModeInvPage").options[$("payModeInvPage").selectedIndex].value;
			if (!page.blank()) {
				searchDCBPayModeLOV($("payModeInvPage").options[$("payModeInvPage").selectedIndex].value);
			}
		});
	}
</script>
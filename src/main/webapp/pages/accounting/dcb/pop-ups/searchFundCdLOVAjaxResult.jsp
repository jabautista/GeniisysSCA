<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div id="modalFundDivTableContainer" class="tableContainer" style="font-size: 12px; width: 800px; overflow: auto">
	<div class="tableHeader" style="overflow: auto">
		<label style="width: 140px; text-align: center">Company Code</label>
		<label style="width: 550px; margin-left: 30px; text-align: center">Company Name</label>
	</div>
	<div style="overflow: auto">
		<c:forEach var="fund" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 140px; text-align: center" id="modalLblFundCd${ctr.index }">${fund.fundCd }</label>
				<label style="width: 550px; margin-left: 30px;" id="modalLblFundDesc${ctr.index }" name="modalLblFundDesc">${fund.fundDesc }</label>
				<input type="hidden" id="modalRowFundCd${ctr.index }" name="modalRowFundCd" value="${fund.fundCd }"/>
				<input type="hidden" id="modalRowFundDesc${ctr.index }" name="modalRowFundDesc" value="${fund.fundDesc }"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager" style="overflow: auto">
	<c:if test="${noOfPages>1}">
		<div align="right" style="overflow: auto">
		Page:
			<select id="fundInvPage" name="fundInvPage">
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

	

	$$("label[name='modalLblFundDesc']").each(
		function(label) {
			if ((label.innerHTML).length > 70)    {
	            label.update((label.innerHTML).truncate(30, "..."));
	        }

			Effect.Appear("modalFundDivTableContainer", {
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

	if ($("fundInvPage") != null) {
		$("fundInvPage").observe("change", function() {
			page = $("fundInvPage").options[$("fundInvPage").selectedIndex].value;
			if (!page.blank()) {
				searchFundCdLOV($("fundInvPage").options[$("fundInvPage").selectedIndex].value);
			}
		});
	}
</script>
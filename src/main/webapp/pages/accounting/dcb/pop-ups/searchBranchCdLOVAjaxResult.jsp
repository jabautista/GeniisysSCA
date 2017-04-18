<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div id="modalBranchDivTableContainer" class="tableContainer" style="font-size: 12px; width: 800px; overflow: auto">
	<div class="tableHeader" style="overflow: auto">
		<label style="width: 140px; text-align: center">Company Code</label>
		<label style="width: 550px; margin-left: 30px; text-align: center">Company Name</label>
	</div>
	<div style="overflow: auto">
		<c:forEach var="branch" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 140px; text-align: center" id="modalLblBranchCd${ctr.index }">${branch.branchCd }</label>
				<label style="width: 550px; margin-left: 30px;" id="modalLblBranchName${ctr.index }" name="modalLblBranchName">${branch.branchName }</label>
				<input type="hidden" id="modalRowBranchCd${ctr.index }" name="modalRowBranchCd" value="${branch.branchCd }"/>
				<input type="hidden" id="modalRowBranchName${ctr.index }" name="modalRowBranchName" value="${branch.branchName }"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager" style="overflow: auto">
	<c:if test="${noOfPages>1}">
		<div align="right" style="overflow: auto">
		Page:
			<select id="branchInvPage" name="branchInvPage">
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

	

	$$("label[name='modalLblBranchName']").each(
		function(label) {
			if ((label.innerHTML).length > 70)    {
	            label.update((label.innerHTML).truncate(30, "..."));
	        }

			Effect.Appear("modalBranchDivTableContainer", {
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

	if ($("branchInvPage") != null) {
		$("branchInvPage").observe("change", function() {
			page = $("branchInvPage").options[$("branchInvPage").selectedIndex].value;
			if (!page.blank()) {
				searchBranchCdLOV($("branchInvPage").options[$("branchInvPage").selectedIndex].value);
			}
		});
	}
</script>
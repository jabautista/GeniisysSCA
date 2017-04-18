<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div id="modalDCBCurrencyDivTableContainer" class="tableContainer" style="font-size: 12px; width: 500px; overflow: auto">
	<div class="tableHeader" style="overflow: auto">
		<label style="width: 80px; text-align: center">Short Name</label>
		<label style="width: 200px; margin-left: 15px; text-align: center">Currency</label>
		<label style="width: 180px; margin-left: 15px; text-align: center">Currency Rate</label>
	</div>
	<div style="overflow: auto">
		<c:forEach var="curr" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width:  80px; text-align: center" id="modalLblShortName${ctr.index }">${curr.shortName }</label>
				<label style="width: 200px; margin-left: 15px;" id="modalLblCurrencyDesc${ctr.index }" name="modalLblCurrencyDesc">${curr.desc }</label>
				<label style="width: 180px; margin-left: 15px; text-align: center;" id="modalLblCurrencyRate${ctr.index }">${curr.currRt }</label>
				<input type="hidden" id="modalRowShortName${ctr.index }" 		name="modalRowShortName${ctr.index}" 	value="${curr.shortName }"/>
				<input type="hidden" id="modalRowCurrencyDesc${ctr.index }" 	name="modalRowCurrencyDesc${ctr.index}" value="${curr.desc }"/>
				<input type="hidden" id="modalRowCurrencyCd${ctr.index }" 		name="modalRowCurrencyCd${ctr.index}" 	value="${curr.code }"/>
				<input type="hidden" id="modalRowCurrencyRt${ctr.index }" 		name="modalRowCurrencyRt${ctr.index}" 	value="${curr.currencyRt }"/>
				<input type="hidden" id="modalRowCurrRt${ctr.index }" 			name="modalRowCurrRt${ctr.index}" 		value="${curr.currRt }"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager" style="overflow: auto">
	<c:if test="${noOfPages>1}">
		<div align="right" style="overflow: auto">
		Page:
			<select id="dcbCurrencyInvPage" name="dcbCurrencyInvPage">
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

	

	$$("label[name='modalLblCurrencyDesc']").each(
		function(label) {
			if ((label.innerHTML).length > 30)    {
	            label.update((label.innerHTML).truncate(26, "..."));
	        }

			Effect.Appear("modalDCBCurrencyDivTableContainer", {
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

	if ($("dcbCurrencyInvPage") != null) {
		$("dcbCurrencyInvPage").observe("change", function() {
			page = $("dcbCurrencyInvPage").options[$("dcbCurrencyInvPage").selectedIndex].value;
			if (!page.blank()) {
				searchDCBCurrencyLOV($("dcbCurrencyInvPage").options[$("dcbCurrencyInvPage").selectedIndex].value);
			}
		});
	}
</script>
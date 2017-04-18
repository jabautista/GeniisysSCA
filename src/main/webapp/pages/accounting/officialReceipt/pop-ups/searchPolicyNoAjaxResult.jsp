<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div class="tableContainer" style="width: 915px; font-size: 12px; overflow: auto;">
	<div class="tableHeader" style="width: 915px; overflow: auto;">
		<label style="width: 100px; margin-left: 5px; text-align: center">Line Cd</label>
		<label style="width: 100px; text-align: center">Subline Cd</label>
		<label style="width: 100px; text-align: center">Iss Cd</label>
		<label style="width: 100px; text-align: center">Issue Yy</label>
		<label style="width: 100px; text-align: center">Pol Seq No</label>
		<label style="width: 100px; text-align: center">Renew No</label>
		<label style="width: 200px; text-align: center">Assured Name</label>
		<label style="width: 100px; text-align: center">Endt Seq No</label>
	</div>
	<div style="width: 915px; overflow: auto;">
		<c:forEach var="policy" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 100px; margin-left: 5px; text-align: center" id="modalLblLineCd${ctr.index}" name="modalLblLineCd" title="${policy.lineCd}">${policy.lineCd}</label>
				<label style="width: 100px; text-align: center"  id="modalLbl${ctr.index }">${policy.sublineCd }</label>
				<label style="width: 100px; text-align: center"  id="modalLbl${ctr.index }">${policy.issCd }</label>
				<label style="width: 100px; text-align: center" id="modalLbl${ctr.index }">${policy.issueYy }</label>
				<label style="width: 100px; text-align: center" id="modalLbl${ctr.index }">${policy.polSeqNo }</label>
				<label style="width: 100px; text-align: center"  id="modalLbl${ctr.index }">${policy.renewNo }</label>
				<label style="width: 200px; text-align: center" id="modalLbl${ctr.index }" name="modalLblTrunc">${policy.assdName }<c:if test="${empty policy.assdName}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLbl${ctr.index }">${policy.endtSeqNo }</label>
				<input type="hidden" id="modalInputLineCd" value="${policy.lineCd}"/>
				<input type="hidden" id="modalInputSublineCd" value="${policy.sublineCd}"/>
				<input type="hidden" id="modalInputIssCd" value="${policy.issCd}"/>
				<input type="hidden" id="modalInputIssueYy" value="${policy.issueYy}"/>
				<input type="hidden" id="modalInputPolSeqNo" value="${policy.polSeqNo}"/>
				<input type="hidden" id="modalInputRenewNo" value="${policy.renewNo}"/>
				<input type="hidden" id="modalInputAssdNo" value="${policy.assdNo}"/>
				<input type="hidden" id="modalInputAssdName" value="${policy.assdName}"/>
				<input type="hidden" id="modalInputEndtSeqNo" value="${policy.endtSeqNo}"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" style="width: 915px" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="popupPage" name="popupPage">
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

	$$("div[name='modalLblTrunc']").each(function (lbl) {
		lbl.innerHTML = lbl.innerHTML.truncate(15, "...");
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

	if ($("popupPage") != null) {
		$("popupPage").observe("change", function() {
			//onChange="searchCommPaytsBillNoDetails(this);"
			page = $("popupPage").options[$("popupPage").selectedIndex].value;
			if (!page.blank()) {
				searchPolicyNoModal($("popupPage").options[$("popupPage").selectedIndex].value);
			}
		});
	}
</script>
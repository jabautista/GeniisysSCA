<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px; width: 1200px; overflow: auto">
	<div class="tableHeader" style="overflow: auto">
		<label style="width:  80px; text-align: center; margin-left: 15px;">Iss Code</label>
		<label style="width: 130px; text-align: center;">Inv No</label>
		<label style="width: 100px; text-align: center;">Inst No</label>
		<label style="width: 100px; text-align: center;">A150 Line Cd</label>
		<label style="width: 150px; text-align: right">Total Amount Due</label>
		<label style="width: 150px; text-align: right">Total Payments</label>
		<label style="width: 150px; text-align: right">Temp Payments</label>
		<label style="width: 150px; text-align: right">Balance Amt Due</label>
		<label style="width: 130px; text-align: right">A020 Assd No</label>
	</div>
	<div style="overflow: auto">
		<c:forEach var="agingSOA" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width:  80px; text-align: center; margin-left: 10px;" id="modalLblIssCd${ctr.index}" name="modalIssCd" title="${agingSOA.issCd}">${agingSOA.issCd}</label>
				<label style="width: 130px; text-align: center;" id="modalLblPremSeqNo${ctr.index }">${agingSOA.premSeqNo }</label>
				<label style="width: 100px; text-align: center;" id="modalLblInstNo${ctr.index }">${agingSOA.instNo }</label>
				<label style="width: 100px; text-align: center;" id="modalLblA150LineCd${ctr.index }">${agingSOA.a150LineCd }</label>
				<label style="width: 150px;text-align: right" name="modalLblMoney" id="modalLblTotalAmtDue${ctr.index }">${agingSOA.totAmtDue }</label>
				<label style="width: 150px;text-align: right" name="modalLblMoney" id="modalLblTotalPayments${ctr.index }">${agingSOA.totPaymts }</label>
				<label style="width: 150px;text-align: right" name="modalLblMoney" id="modalLblTempPayments${ctr.index }">${agingSOA.tempPaymts }</label>
				<label style="width: 150px;text-align: right" name="modalLblMoney" id="modalLblBalanceAmtDue${ctr.index }">${agingSOA.balAmtDue }</label>
				<label style="width: 130px;text-align: right" id="modalLblA020AssdNo${ctr.index }">${agingSOA.a020AssdNo }</label>
				<input type="hidden" id="modalRowIssCd${agingSOA.issCd }" 				name="modalRowInput" value="${agingSOA.issCd }"/>
				<input type="hidden" id="modalRowPremSeqNo${agingSOA.premSeqNo }" 		name="modalRowInput" value="${agingSOA.premSeqNo }"/>
				<input type="hidden" id="modalRowInstNo${agingSOA.instNo }" 			name="modalRowInput" value="${agingSOA.instNo }"/>
				<input type="hidden" id="modalRowLineCd${agingSOA.a150LineCd }" 		name="modalRowInput" value="${agingSOA.a150LineCd }"/>
				<input type="hidden" id="modalRowTotalAmtDue${agingSOA.totAmtDue }" 	name="modalRowInput" value="${agingSOA.totAmtDue }"/>
				<input type="hidden" id="modalRowTotalPayments${agingSOA.totPaymts }" 	name="modalRowInput" value="${agingSOA.totPaymts }"/>
				<input type="hidden" id="modalRowTempPayments${agingSOA.tempPaymts }" 	name="modalRowInput" value="${agingSOA.tempPaymts }"/>
				<input type="hidden" id="modalRowBalAmtDue${agingSOA.balAmtDue }" 		name="modalRowInput" value="${agingSOA.balAmtDue }"/>
				<input type="hidden" id="modalRowAssdNo${agingSOA.a020AssdNo }" 		name="modalRowInput" value="${agingSOA.a020AssdNo }"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager" style=" overflow: auto;  width: 1180px;" align="right">
	<c:if test="${noOfPages>1}">
		<div align="right" style="overflow: auto">
		Page:
			<select id="agingSOAPage" name="agingSOAPage">
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

	$$("label[name='modalLblMoney']").each(function (lbl) {
		lbl.innerHTML = formatCurrency(parseFloat(nvl(lbl.innerHTML, 0)));
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

	if ($("agingSOAPage") != null) {
		$("agingSOAPage").observe("change", function() {
			//onChange="searchCommPaytsBillNoDetails(this);"
			page = $("agingSOAPage").options[$("agingSOAPage").selectedIndex].value;
			if (!page.blank()) {
				searchAgingSOADetails($("agingSOAPage").options[$("agingSOAPage").selectedIndex].value);
			}
		});
	}
</script>
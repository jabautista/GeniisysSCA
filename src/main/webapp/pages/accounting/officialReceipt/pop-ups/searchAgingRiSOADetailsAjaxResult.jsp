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
	<div class="tableHeader" style=" overflow: auto">
		<label style="width:  80px; text-align: center; margin-left: 15px;">Ri Code</label>
		<label style="width: 130px; text-align: center;">B140 Prem Seq No</label>
		<label style="width: 100px; text-align: center;">Inst No</label>
		<label style="width: 100px; text-align: center;">A150 Line Cd</label>
		<label style="width: 150px; text-align: right">Total Amount Due</label>
		<label style="width: 150px; text-align: right">Total Payments</label>
		<label style="width: 150px; text-align: right">Temp Payments</label>
		<label style="width: 150px; text-align: right">Balance Amt Due</label>
		<label style="width: 120px; text-align: right">A020 Assd No</label>
	</div>
	<div style=" overflow: auto">
		<c:forEach var="agingRiSOA" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width:  80px; text-align: center; margin-left: 10px;" id="modalLblRiCd${ctr.index}" name="modalRiCd" title="${agingRiSOA.a180RiCd}">${agingRiSOA.a180RiCd}</label>
				<label style="width: 130px; text-align: center;" id="modalLblPremSeqNo${ctr.index }">${agingRiSOA.premSeqNo }</label>
				<label style="width: 100px; text-align: center;" id="modalLblInstNo${ctr.index }">${agingRiSOA.instNo }</label>
				<label style="width: 100px; text-align: center;" id="modalLblA150LineCd${ctr.index }">${agingRiSOA.a150LineCd }</label>
				<label style="width: 150px;text-align: right" name="modalLblMoney" id="modalLblTotalAmtDue${ctr.index }">${agingRiSOA.totalAmountDue }</label>
				<label style="width: 150px;text-align: right" name="modalLblMoney" id="modalLblTotalPayments${ctr.index }">${agingRiSOA.totalPayments }</label>
				<label style="width: 150px;text-align: right" name="modalLblMoney" id="modalLblTempPayments${ctr.index }">${agingRiSOA.tempPayments }</label>
				<label style="width: 150px;text-align: right" name="modalLblMoney" id="modalLblBalanceAmtDue${ctr.index }">${agingRiSOA.balanceDue }</label>
				<label style="width: 120px;text-align: right" id="modalLblA020AssdNo${ctr.index }">${agingRiSOA.a020AssdNo }</label>
				<input type="hidden" id="modalRowa180RiCd${agingRiSOA.a180RiCd }" 				name="modalRowInput" value="${agingRiSOA.a180RiCd }"/>
				<input type="hidden" id="modalRowPremSeqNo${agingRiSOA.premSeqNo }" 		name="modalRowInput" value="${agingRiSOA.premSeqNo }"/>
				<input type="hidden" id="modalRowInstNo${agingRiSOA.instNo }" 			name="modalRowInput" value="${agingRiSOA.instNo }"/>
				<input type="hidden" id="modalRowLineCd${agingRiSOA.a150LineCd }" 		name="modalRowInput" value="${agingRiSOA.a150LineCd }"/>
				<input type="hidden" id="modalRowTotalAmtDue${agingRiSOA.totalAmountDue }" 	name="modalRowInput" value="${agingRiSOA.totalAmountDue }"/>
				<input type="hidden" id="modalRowTotalPayments${agingRiSOA.totalPayments }" 	name="modalRowInput" value="${agingRiSOA.totalPayments }"/>
				<input type="hidden" id="modalRowTempPayments${agingRiSOA.tempPayments }" 	name="modalRowInput" value="${agingRiSOA.tempPayments }"/>
				<input type="hidden" id="modalRowbalanceDue${agingRiSOA.balanceDue }" 		name="modalRowInput" value="${agingRiSOA.balanceDue }"/>
				<input type="hidden" id="modalRowAssdNo${agingRiSOA.a020AssdNo }" 		name="modalRowInput" value="${agingRiSOA.a020AssdNo }"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager" style=" overflow: auto">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="agingRiSOAPage" name="agingRiSOAPage">
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

	if ($("agingRiSOAPage") != null) {
		$("agingRiSOAPage").observe("change", function() {
			//onChange="searchCommPaytsBillNoDetails(this);"
			page = $("agingRiSOAPage").options[$("agingRiSOAPage").selectedIndex].value;
			if (!page.blank()) {
				searchagingRiSOADetails($("agingRiSOAPage").options[$("agingRiSOAPage").selectedIndex].value);
			}
		});
	}
</script>
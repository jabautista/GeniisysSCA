<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div class="tableHeader">
		<label style="width: 70px; margin-left: 5px;">Tran Type</label>
		<label style="width: 75px;">Issue Code</label>
		<label style="width: 50px; margin-left: 58px;">Bill No.</label>
		<label style="width: 60px; margin-left: 5px;">Inst No.</label>
		<label style="width: 120px; margin-left: 4px;">Collection Amount</label>
	</div>
	<div>
		<c:forEach var="datedChk" items="${datedCheckDtls}">
			<div id="row${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}" name="row" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 70px; text-align: center;" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}lblTranType" name="lblTranType" title="${datedChk.pdcId}">${datedChk.pdcId}</label>
				<label style="width: 75px; text-align: center;" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}lblIssCd" name="lblIssCd" title="${datedChk.issCd}">${datedChk.issCd}</label>
				<label style="width: 105px; text-align: right;" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}lblPremSeqNo" name="lblPremSeqNo" title="${datedChk.premSeqNo}">${datedChk.premSeqNo}</label>
				<label style="width: 60px; text-align: right;" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}lblInstNo" name="lblInstNo" title="${datedChk.instNo}">${datedChk.instNo}</label>
				<label style="width: 130px; text-align: right; margin-left: 2px;" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}lblCollnAmt" name="lblCollnAmt" title="${datedChk.collnAmt}">${datedChk.collnAmt}</label>
				<input type="hidden" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}tranType" name="tranType" value="${datedChk.tranType}">
				<input type="hidden" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}issCd" name="issCd" value="${datedChk.issCd}">
				<input type="hidden" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}premSeqNo" name="premSeqNo" value="${datedChk.premSeqNo}">
				<input type="hidden" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}instNo" name="instNo" value="${datedChk.instNo}">
				<input type="hidden" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}collnAmt" name="collnAmt" value="${datedChk.collnAmt}">
				<input type="hidden" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}premAmt" name="premAmt" value="${datedChk.premAmt}">
				<input type="hidden" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}taxAmt" name="taxAmt" value="${datedChk.taxAmt}">
				<input type="hidden" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}currCd" name="currCd" value="${datedChk.currCd}">
				<input type="hidden" id="${datedChk.pdcId}${datedChk.issCd}${datedChk.premSeqNo}currRt" name="currRt" value="${datedChk.currRt}">
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager">
	<c:if test="${noOfpages>1}">
		<div align="right">
		Page:
			<select onChange="goToPageSearchPayorModal2(this);">
				<c:forEach var="i" begin="1" end="${noOfpages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageIndex==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfpages}
		</div>
	</c:if>
</div>
<script type="text/JavaScript">
	//position page div correctly
	var product = 288 - (parseInt($$("div[name='row']").size())*28);
	$("pager").setStyle("margin-top: "+product+"px;");

	$$("div[name='row']").each(
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
					$("selectedClientId").value = row.getAttribute("id").substring(3);
					$$("div[name='row']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}else{
							objAC.selectedTranType = r.down("input", 0).value;
							objAC.selectedIssCd = r.down("input", 1).value;
							objAC.selectedPremSeqNo = r.down("input", 2).value;
							objAC.selectedInstNo = r.down("input", 3).value;
							objAC.selectedCollnAmt = r.down("input", 4).value;
							objAC.selectedPremAmt = r.down("input", 5).value;
							objAC.selectedTaxAmt = r.down("input", 6).value;
							objAC.selectedCurrCd = r.down("input", 7).value;
							objAC.selectedCurrRT = r.down("input", 8).value;
						}	
					});
				}	
			});
		});
	
	$$("label[name='lblCollnAmt']").each(function (lbl) {
		lbl.innerHTML = formatCurrency(lbl.innerHTML);
	});
</script>
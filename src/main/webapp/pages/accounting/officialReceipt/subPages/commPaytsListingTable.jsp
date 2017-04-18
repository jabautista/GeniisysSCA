<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="commPaytsTableMainDiv" name="commPaytsTableMainDiv" style="width: 921px;">
	<div id="searchResultCommPayts" align="center" style="margin: 10px;">
		<div style="width: 100%; text-align: center;" id="commPaytsTable" name="commPaytsTable">
			<div class="tableHeader">
				<label style="width: 120px;font-size: 11px; text-align: center;">Transaction Type</label>
				<label style="width:  63px;font-size: 11px; text-align: center;">Bill No.</label>
				<label style="width: 153px;font-size: 11px; text-align: center;">Intermediary</label>
				<label style="width: 132px;font-size: 11px; text-align: right;">Commission Amount</label>
				<label style="width: 126px;font-size: 11px; text-align: right;">Input Vat Amount</label>
				<label style="width: 108px;font-size: 11px; text-align: right;">Wholding Tax</label>
				<label style="width: 175px;font-size: 11px; text-align: right;">Net Commission Amount</label>
			</div>
			<div class="tableContainer" id="commPaytsTableContainer" name="tableContainer" style="display: none">
				<c:forEach var="commPayts" items="${commPaytsList }" varStatus="ctr">
					<div id="row${ctr.index }" name="rowCommPayts" class="tableRow" style="padding-left: 1px;">
						<label style="width: 120px;font-size: 11px; text-align: center" id="lblTranType"		name="lblTranType">
							<c:choose>
								<c:when test="${commPayts.tranType eq 1 or commPayts.tranType eq 3 }">Commission</c:when>
								<c:otherwise>Refund/Reclass</c:otherwise>
							</c:choose>
						</label>
						<label style="width:  63px;font-size: 11px; text-align: center" id="lblBillNo"		name="lblBillNo">${commPayts.issCd }-${commPayts.premSeqNo }</label>
						<label style="width: 153px;font-size: 11px; text-align: center" id="lblIntermediary"	name="lblIntermediary">${fn:escapeXml(commPayts.dspIntmName) }</label>
						<label style="width: 132px;font-size: 11px; text-align: right"  id="lblCommAmt"		name="moneyLabel">${commPayts.commAmt }</label>
						<label style="width: 126px;font-size: 11px; text-align: right"  id="lblInputVatAmt"	name="moneyLabel">${commPayts.inputVATAmt }</label>
						<label style="width: 108px;font-size: 11px; text-align: right"  id="lblWholdingTax"	name="moneyLabel">${commPayts.wtaxAmt }</label>
						<label style="width: 175px;font-size: 11px; text-align: right"  id="lblNetCommAmt"	name="moneyLabel">${commPayts.drvCommAmt }</label>
						<input type="hidden"	id="count${ctr.index }"					name="count"				value="${ctr.index }" />
						<input type="hidden"	id="gcopChanged${ctr.index }"			name="gcopChanged"			value="N" />
						<input type="hidden"	id="gcopGaccTranId${ctr.index }"		name="gcopGaccTranId"		value="${fn:escapeXml(commPayts.gaccTranId) }" />
						<input type="hidden"	id="gcopTranType${ctr.index }"			name="gcopTranType"			value="${fn:escapeXml(commPayts.tranType) }" />
						<input type="hidden"	id="gcopIssCd${ctr.index }"				name="gcopIssCd"			value="${fn:escapeXml(commPayts.issCd) }" />
						<input type="hidden"	id="gcopPremSeqNo${ctr.index }"			name="gcopPremSeqNo"		value="${fn:escapeXml(commPayts.premSeqNo) }" />
						<input type="hidden"	id="gcopIntmNo${ctr.index }"			name="gcopIntmNo"			value="${fn:escapeXml(commPayts.intmNo) }" />
						<input type="hidden"	id="gcopDspLineCd${ctr.index }"			name="gcopDspLineCd"		value="${fn:escapeXml(commPayts.dspLineCd) }" />
						<input type="hidden"	id="gcopDspAssdName${ctr.index }"		name="gcopDspAssdName"		value="${fn:escapeXml(commPayts.dspAssdName) }" />
						<input type="hidden"	id="gcopCommAmt${ctr.index }"			name="gcopCommAmt"			value="${fn:escapeXml(commPayts.commAmt) }" />
						<input type="hidden"	id="gcopInputVATAmt${ctr.index }"		name="gcopInputVATAmt"		value="${fn:escapeXml(commPayts.inputVATAmt) }" />
						<input type="hidden"	id="gcopWtaxAmt${ctr.index }"			name="gcopWtaxAmt"			value="${fn:escapeXml(commPayts.wtaxAmt) }" />
						<input type="hidden"	id="gcopDrvCommAmt${ctr.index }"		name="gcopDrvCommAmt"		value="${fn:escapeXml(commPayts.drvCommAmt) }" />
						<input type="hidden"	id="gcopPrintTag${ctr.index }"			name="gcopPrintTag"			value="${fn:escapeXml(commPayts.printTag) }" />
						<input type="hidden"	id="gcopDefCommTag${ctr.index }"		name="gcopDefCommTag"		value="${fn:escapeXml(commPayts.defCommTag) }" />
						<input type="hidden"	id="gcopParticulars${ctr.index }"		name="gcopParticulars"		value="${fn:escapeXml(commPayts.particulars) }" />
						<input type="hidden"	id="gcopCurrencyCd${ctr.index }"		name="gcopCurrencyCd"		value="${fn:escapeXml(commPayts.currencyCd) }" />
						<input type="hidden"	id="gcopDspCurrencyDesc${ctr.index }"	name="gcopCurrDesc"			value="${fn:escapeXml(commPayts.currDesc) }" />
						<input type="hidden"	id="gcopConvertRate${ctr.index }"		name="gcopConvertRate"		value="${fn:escapeXml(commPayts.convertRate) }" />
						<input type="hidden"	id="gcopForeignCurrAmt${ctr.index }"	name="gcopForeignCurrAmt"	value="${fn:escapeXml(commPayts.foreignCurrAmt) }" />
						<input type="hidden"	id="gcopParentIntmNo${ctr.index }"		name="gcopParentIntmNo"		value="${fn:escapeXml(commPayts.parentIntmNo) }" />
						<input type="hidden"	id="gcopUserId${ctr.index }"			name="gcopUserId"			value="${fn:escapeXml(commPayts.userId) }" />
						<input type="hidden"	id="gcopLastUpdate${ctr.index }"		name="gcopLastUpdate"		value="${fn:escapeXml(commPayts.lastUpdate) }" />
						<input type="hidden"	id="gcopCommTag${ctr.index }"			name="gcopCommTag"			value="${fn:escapeXml(commPayts.commTag) }" />
						<input type="hidden"	id="gcopRecordNo${ctr.index }"			name="gcopRecordNo"			value="${fn:escapeXml(commPayts.recordNo) }" />
						<input type="hidden"	id="gcopDisbComm${ctr.index }"			name="gcopDisbComm"			value="${fn:escapeXml(commPayts.disbComm) }" />
						<input type="hidden"	id="gcopDspPolicyId${ctr.index }"		name="gcopDspPolicyId"		value="${fn:escapeXml(commPayts.dspPolicyId) }" />
						<input type="hidden"	id="gcopDspIntmName${ctr.index }"		name="gcopDspIntmName"		value="${fn:escapeXml(commPayts.dspIntmName) }" />
						<input type="hidden"	id="gcopDspAssdNo${ctr.index }"			name="gcopDspAssdNo"		value="${fn:escapeXml(commPayts.dspAssdNo) }" />
						<input type="hidden"	id="gcopBillGaccTranId${ctr.index }"			name="gcopBillGaccTranId"		value="${fn:escapeXml(commPayts.billGaccTranId) }" />
						<input type="hidden"	id="gcopRecordSeqNo${ctr.index }"		name="gcopRecordSeqNo"		value="${fn:escapeXml(commPayts.recordSeqNo) }" /> <!-- added by robert SR 19752 07.28.15 -->
					</div>
				</c:forEach>
			</div>
			<div class="tableHeader">
				<label style="width: 125px;font-size: 11px; text-align: center;">Total:</label>
				<label style="width: 211px;font-size: 11px;">&nbsp</label>
				<label id="lblSumCommAmt"	  name="moneyLabel" style="width: 132px;font-size: 11px; text-align: right;">${sumCommAmt }</label>
				<label id="lblSumInputVATAmt" name="moneyLabel" style="width: 126px;font-size: 11px; text-align: right;">${sumInpVat }</label>
				<label id="lblSumWtaxAmt" 	  name="moneyLabel" style="width: 108px;font-size: 11px; text-align: right;">${sumWtaxAmt }</label>
				<label id="lblSumNetCommAmt"  name="moneyLabel" style="width: 175px;font-size: 11px; text-align: right;">${controlSumNetCommAmt }</label>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
    $$("label[name='lblIntermediary']").each(function (label)    {
        if ((label.innerHTML).length > 20)    {
            label.update((label.innerHTML).truncate(20, "..."));
        }
    });

    $$("label[name='moneyLabel']").each(function(label) {
		label.innerHTML = formatCurrency(label.innerHTML);
	});
	
    Effect.Appear("commPaytsTableContainer", {
    	duration: 0.3
    });
</script>
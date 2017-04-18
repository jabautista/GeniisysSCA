<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="premiumDepositTableMainDiv" name="premiumDepositTableMainDiv" style="width: 921px;">
	<div id="searchResultPremiumDeposit" align="center" style="margin: 10px;">
		<div style="width: 900px; text-align: center;" id="premiumDepositTable" name="premiumDepositTable">
			<div class="tableHeader">
	        	<label style="width:  79px; font-size: 11px; text-align: center;">Item No</label>
	        	<label style="width: 119px; font-size: 11px; text-align: center;">Transaction Type</label>
	        	<label style="width: 142px; font-size: 11px; text-align: center;">Old Transaction No.</label>
	        	<label style="width: 109px; font-size: 11px; text-align: center;">Issue Source</label>
	        	<label style="width:  110px; font-size: 11px; text-align: center;">Invoice No.</label>
	        	<label style="width: 100px; font-size: 11px; text-align: center;">Installment No.</label>
	        	<label style="width: 105px; font-size: 11px; text-align: right;">Amount</label>
	        	<label style="width:  115px; font-size: 11px; text-align: right;">Dep Flag</label>
	        </div>
	        <div id="premiumDepositTableContainer" name="tableContainer" class="tableContainer">
	        	<c:forEach var="premDep" items="${premDepositList }" varStatus="ctr">
	        		<div id="row${ctr.index}" name="rowPremDep" class="tableRow" style="padding-left:1px;" />
		        		<label id="rowItemNo${ctr.index }" 			name="lblPremDep" 		style="width:  79px; text-align: center;">${premDep.itemNo}</label>
		        		<label id="rowTransactionType${ctr.index }" name="lblPremDep" 		style="width: 119px; text-align: center;">${premDep.tranTypeName}<c:if test="${empty premDep.tranTypeName}">---</c:if></label>
		        		<label id="rowOldTransactionNo${ctr.index }" name="lblPremDep2" 	style="width: 142px; text-align: center;">
			        		<c:choose>
			        			<c:when test="${empty accTrans.tranYear or empty accTrans.tranMonth or empty accTrans.tranSeqNo}">---</c:when>
			        			<c:when test="${premDep.transactionType eq 1 or premDep.transactionType eq 3 }">---</c:when>
			        			<c:otherwise>
			        				${accTrans.tranYear }-${accTrans.tranMonth }-${accTrans.tranSeqNo}
			        			</c:otherwise>
			        		</c:choose>
		        		</label>
		        		<label id="rowIssueSource${ctr.index }" 	name="lblPremDep" 		style="width: 109px; text-align: center;">${premDep.issName}<c:if test="${empty premDep.issName}">---</c:if></label>
		        		<label id="rowInvoiceNo${ctr.index }" 		name="lblPremDep" 		style="width:  93px; text-align: center;">${premDep.b140PremSeqNo }<c:if test="${empty premDep.b140PremSeqNo }">---</c:if></label>
		        		<label id="rowInstallmentNo${ctr.index }" 	name="lblPremDepInstNo" style="width: 103px; text-align: center;">${premDep.instNo}</label>
		        		<label id="rowCollectionAmt${ctr.index }" 	name="lblPremDep" 		style="width: 120px; text-align: right;" class="money" >${premDep.collectionAmt}<c:if test="${empty premDep.collectionAmt}">---</c:if></label>
		        		<label id="rowDepFlag${ctr.index }" 		name="lblPremDep2" 		style="width:  110px; text-align: right; margin-left: 5px;">
		        			<c:choose>
								<c:when test="${premDep.depFlag eq '1'}">
		        					Overdraft Comm
		        				</c:when>
		        				<c:when test="${premDep.depFlag eq '2'}">
		        					Overpayment
		        				</c:when>
		        				<c:otherwise>
									Unapplied
								</c:otherwise>
		        			</c:choose>
		        		</label>
		        		<input type="hidden" id="count${ctr.index }" 				name="count" 						value="${fn:escapeXml(ctr.index)}" />
		        		<input type="hidden" id="gipdOrPrintTag${ctr.index }"  		name="gipdOrPrintTag" 				value="${fn:escapeXml(premDep.orPrintTag)}" />
		        		<input type="hidden" id="gipdItemNo${ctr.index }" 			name="gipdItemNo" 					value="${fn:escapeXml(premDep.itemNo)}" />
		        		<input type="hidden" id="gipdTranYear${ctr.index }" 		name="gipdTranYear"					value="<c:if test="${premDep.transactionType eq 2 or premDep.transactionType eq 4}">${fn:escapeXml(accTrans.tranYear)}</c:if>" />
		        		<input type="hidden" id="gipdTranMonth${ctr.index }" 		name="gipdTranMonth"				value="<c:if test="${premDep.transactionType eq 2 or premDep.transactionType eq 4}">${fn:escapeXml(accTrans.tranMonth)}</c:if>" />
		        		<input type="hidden" id="gipdTranSeqNo${ctr.index }" 		name="gipdTranSeqNo"				value="<c:if test="${premDep.transactionType eq 2 or premDep.transactionType eq 4}">${fn:escapeXml(accTrans.tranSeqNo)}</c:if>" />
		        		<input type="hidden" id="gipdTransactionType${ctr.index }" 	name="gipdTransactionType" 			value="${fn:escapeXml(premDep.transactionType)}" />
		        		<input type="hidden" id="gipdTranTypeName${ctr.index }" 	name="gipdTranTypeName" 			value="${fn:escapeXml(premDep.tranTypeName)}" />
		        		<input type="hidden" id="gipdOldItemNo${ctr.index }" 		name="gipdOldItemNo" 				value="${fn:escapeXml(premDep.oldItemNo)}" />
		        		<input type="hidden" id="gipdOldTranType${ctr.index }" 		name="gipdOldTranType" 				value="${fn:escapeXml(premDep.oldTranType)}" />
		        		<input type="hidden" id="gipdB140IssCd${ctr.index }" 		name="gipdB140IssCd" 				value="${fn:escapeXml(premDep.b140IssCd)}" />
		        		<input type="hidden" id="gipdIssName${ctr.index }" 			name="gipdIssName" 					value="${fn:escapeXml(premDep.issName)}" />
		        		<input type="hidden" id="gipdB140PremSeqNo${ctr.index }" 	name="gipdB140PremSeqNo" 			value="${fn:escapeXml(premDep.b140PremSeqNo)}" />
		        		<input type="hidden" id="gipdInstNo${ctr.index }" 			name="gipdInstNo" 					value="${fn:escapeXml(premDep.instNo)}" />
		        		<input type="hidden" id="gipdCollectionAmt${ctr.index }" 	name="gipdCollectionAmt" 			value="${fn:escapeXml(premDep.collectionAmt)}" />
		        		<input type="hidden" id="gipdDepFlag${ctr.index }" 			name="gipdDepFlag" 					value="${fn:escapeXml(premDep.depFlag)}" />
		        		<input type="hidden" id="gipdDspDepFlag${ctr.index }" 		name="gipdDspDepFlag" 				value="
		        			<c:choose>
								<c:when test="${premDep.depFlag eq '1'}">
		        					Overdraft Comm
		        				</c:when>
		        				<c:when test="${premDep.depFlag eq '2'}">
		        					Overpayment
		        				</c:when>
		        				<c:otherwise>
									Unapplied
								</c:otherwise>
		        			</c:choose>
		        		" />
		        		<input type="hidden" id="gipdAssdNo${ctr.index }" 			name="gipdAssdNo" 					value="${fn:escapeXml(premDep.assdNo)}" />
		        		<input type="hidden" id="gipdAssuredName${ctr.index }" 		name="gipdAssuredName" 				value="${fn:escapeXml(premDep.assuredName)}" />
		        		<input type="hidden" id="gipdDrvAssuredName${ctr.index }" 	name="gipdDrvAssuredName" 			value="${premDep.assdNo} - ${fn:escapeXml(premDep.assuredName)}" />
		        		<input type="hidden" id="gipdIntmNo${ctr.index }" 			name="gipdIntmNo" 					value="${fn:escapeXml(premDep.intmNo)}" />
		        		<input type="hidden" id="gipdIntmName${ctr.index }" 		name="gipdIntmName"					value="${fn:escapeXml(premDep.intmName)}" />
		        		<input type="hidden" id="gipdRiCd${ctr.index }" 			name="gipdRiCd" 					value="${fn:escapeXml(premDep.riCd)}" />
		        		<input type="hidden" id="gipdRiName${ctr.index }" 			name="gipdRiName" 					value="${fn:escapeXml(premDep.riName)}" />
		        		<input type="hidden" id="gipdParSeqNo${ctr.index }" 		name="gipdParSeqNo" 				value="${fn:escapeXml(premDep.parSeqNo)}" />
		        		<input type="hidden" id="gipdQuoteSeqNo${ctr.index }" 		name="gipdQuoteSeqNo" 				value="${fn:escapeXml(premDep.quoteSeqNo)}" />
		        		<input type="hidden" id="gipdLineCd${ctr.index }" 			name="gipdLineCd" 					value="${fn:escapeXml(premDep.lineCd)}" />
		        		<input type="hidden" id="gipdSublineCd${ctr.index }" 		name="gipdSublineCd" 				value="${fn:escapeXml(premDep.sublineCd)}" />
		        		<input type="hidden" id="gipdIssCd${ctr.index }" 			name="gipdIssCd" 					value="${fn:escapeXml(premDep.issCd)}" />
		        		<input type="hidden" id="gipdIssueYy${ctr.index }" 			name="gipdIssueYy" 					value="${fn:escapeXml(premDep.issueYy)}" />
		        		<input type="hidden" id="gipdPolSeqNo${ctr.index }" 		name="gipdPolSeqNo" 				value="${fn:escapeXml(premDep.polSeqNo)}" />
		        		<input type="hidden" id="gipdRenewNo${ctr.index }" 			name="gipdRenewNo" 					value="${fn:escapeXml(premDep.renewNo)}" />
		        		<input type="hidden" id="gipdCollnDt${ctr.index }" 			name="gipdCollnDt" 					value="${fn:escapeXml(premDep.collnDt)}" />
		        		<input type="hidden" id="gipdGaccTranId${ctr.index }" 		name="gipdGaccTranId" 				value="${fn:escapeXml(premDep.gaccTranId)}" />
		        		<input type="hidden" id="gipdOldTranId${ctr.index }" 		name="gipdOldTranId" 				value="${fn:escapeXml(premDep.oldTranId)}" />
		        		<input type="hidden" id="gipdRemarks${ctr.index }" 			name="gipdRemarks" 					value="${fn:escapeXml(premDep.remarks)}" />
		        		<input type="hidden" id="gipdUserId${ctr.index }" 			name="gipdUserId" 					value="${fn:escapeXml(premDep.userId)}" />
		        		<input type="hidden" id="gipdLastUpdate${ctr.index }" 		name="gipdLastUpdate" 				value="${fn:escapeXml(premDep.lastUpdate)}" />
		        		<input type="hidden" id="gipdCurrencyCd${ctr.index }" 		name="gipdCurrencyCd" 				value="${fn:escapeXml(premDep.currencyCd)}" />
		        		<input type="hidden" id="gipdConvertRate${ctr.index }" 		name="gipdConvertRate" 				value="${fn:escapeXml(premDep.convertRate)}" />
		        		<input type="hidden" id="gipdForeignCurrAmt${ctr.index }" 	name="gipdForeignCurrAmt" 			value="${fn:escapeXml(premDep.foreignCurrAmt)}" />
		        		<input type="hidden" id="gipdOrTag${ctr.index }" 			name="gipdOrTag" 					value="${fn:escapeXml(premDep.orTag)}" />
		        		<input type="hidden" id="gipdCommRecNo${ctr.index }" 		name="gipdCommRecNo" 				value="${fn:escapeXml(premDep.commRecNo)}" />
		        		<input type="hidden" id="gipdBillNo${ctr.index }" 			name="gipdBillNo"	 				value="${fn:escapeXml(premDep.billNo)}" />
		        		<input type="hidden" id="gipdParYy${ctr.index }" 			name="gipdParYy"	 				value="${fn:escapeXml(premDep.parYy)}" />
		        		<input type="hidden" id="gipdPolicyNo${ctr.index }" 		name="gipdPolicyNo" 				value="${fn:escapeXml(premDep.policyNo)}" />
		        		<input type="hidden" id="gipdChanged${ctr.index }"	 		name="gipdChanged"	 				value="N" />
		        		<input type="hidden" id="gipdParLineCd${ctr.index }"	 	name="gipdParLineCd"	 			value="${fn:escapeXml(premDep.lineCd)}" />
		        		<input type="hidden" id="gipdParIssCd${ctr.index }"	 		name="gipdParIssCd"	 				value="${fn:escapeXml(premDep.issCd)}" />
		        		<input type="hidden" id="gipdParNo${ctr.index }"	 		name="gipdParNo"	 				value="${fn:escapeXml(premDep.dspParNo)}" />
		        	 </div>
	        	</c:forEach>
	        </div>
	        <div class="tableHeader">
	        	<label style="width: 645px; font-size: 11px; text-align: right;">Total</label>
	        	<label style="width: 123px; font-size: 11px; text-align: right;" id="lblTotalCollectionAmt">0.00</label>
	        </div>
		</div>
	</div>
</div>

<script type="text/javascript">
    $$("label[name='lblPremDep']").each(function (label)    {
        if ((label.innerHTML).length > 15)    {
            label.update((label.innerHTML).truncate(15, "..."));
        }
    });
</script>
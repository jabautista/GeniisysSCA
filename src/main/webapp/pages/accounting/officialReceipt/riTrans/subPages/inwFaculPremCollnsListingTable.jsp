<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="spinLoadingDiv"></div>
		<div style="margin:10px; margin-top:5px; margin-bottom:0px; padding-top:1px;" id="inwFaculTable" name="inwFaculTable">	
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 10%; margin-right: 3px;">Tran Type</label>
				<label style="text-align: left; width: 10%; margin-right: 3px;">Cedant</label>
				<label style="text-align: right; width: 9%; margin-right: 3px;">Invoice No.</label>
				<label style="text-align: right; width: 7%; margin-right: 3px;">Inst No.</label>
				<label style="text-align: right; width: 12%; margin-right: 3px;">Collection Amt</label>
				<label style="text-align: right; width: 12%; margin-right: 3px;">Prem Amt</label>
				<label style="text-align: right; width: 12%; margin-right: 3px;">Tax Amt</label>
				<label style="text-align: right; width: 12%; margin-right: 3px;">Comm Amt</label>
				<label style="text-align: right; width: 12%;">Comm VAT Amt</label>
			</div>
			
			<div class="tableContainer" id="inwFaculListing" name="inwFaculListing" style="display: block;">
				<c:forEach var="inw" items="${giacInwfaculCollns}">
					<div id="rowInwFacul${inw.gaccTranId}${inw.transactionType}${inw.a180RiCd}${inw.b140IssCd}${inw.b140PremSeqNo}${inw.instNo}" gaacTranId="${inw.gaccTranId}" transactionType="${inw.transactionType }" a180RiCd="${inw.a180RiCd }" b140IssCd="${inw.b140IssCd }" b140PremSeqNo="${inw.b140PremSeqNo }" instNo="${inw.instNo }" name="inwFacul" class="tableRow" style="padding-left:1px;">
						<input type="hidden" id="inwGaccTranId" 		name="inwGaccTranId" 	   	value="${inw.gaccTranId }" />
			 	  		<input type="hidden" id="inwTransactionType" 	name="inwTransactionType" 	value="${inw.transactionType }"/>
						<input type="hidden" id="inwA180RiCd" 			name="inwA180RiCd" 			value="${inw.a180RiCd }"/>
						<input type="hidden" id="inwB140IssCd" 			name="inwB140IssCd"			value="${inw.b140IssCd }"/>
						<input type="hidden" id="inwB140PremSeqNo" 		name="inwB140PremSeqNo" 	value="${inw.b140PremSeqNo }"/>
						<input type="hidden" id="inwInstNo" 			name="inwInstNo" 			value="${inw.instNo }"/>
						<input type="hidden" id="inwPremiumAmt" 		name="inwPremiumAmt"		value="${inw.premiumAmt }"/>
						<input type="hidden" id="inwCommAmt" 			name="inwCommAmt" 			value="${inw.commAmt }"/>
						<input type="hidden" id="inwWholdingTax" 		name="inwWholdingTax" 		value="${inw.wholdingTax }"/>
						<input type="hidden" id="inwparticulars" 		name="inwparticulars"		value="${inw.particulars }"/>
						<input type="hidden" id="inwCurrencyCd" 		name="inwCurrencyCd" 		value="${inw.currencyCd }"/>
						<input type="hidden" id="inwConvertRate" 		name="inwConvertRate" 		value="${inw.convertRate }"/>
						<input type="hidden" id="inwForeignCurrAmt" 	name="inwForeignCurrAmt" 	value="${inw.foreignCurrAmt }"/>
						<input type="hidden" id="inwCollectionAmt" 		name="inwCollectionAmt" 	value="${inw.collectionAmt }"/>
						<input type="hidden" id="inwOrPrintTag" 		name="inwOrPrintTag" 		value="${empty inw.orPrintTag ? 'N' :inw.orPrintTag}"/>
						<input type="hidden" id="inwUserId" 			name="inwUserId"			value="${inw.userId }"/>
						<input type="hidden" id="inwLastUpdate" 		name="inwLastUpdate" 		value="${inw.lastUpdate }"/>
						<input type="hidden" id="inwCpiRecNo" 			name="inwCpiRecNo" 			value="${inw.cpiRecNo }"/>
						<input type="hidden" id="inwCpiBranchCd" 		name="inwCpiBranchCd"		value="${inw.cpiBranchCd }"/>
						<input type="hidden" id="inwTaxAmount" 			name="inwTaxAmount" 		value="${inw.taxAmount }"/>
						<input type="hidden" id="inwCommVat" 			name="inwCommVat" 			value="${inw.commVat }"/>
						
						<input type="hidden" id="inwTransactionTypeDesc" name="inwTransactionTypeDesc"  value="${inw.transactionTypeDesc }"/>
						<input type="hidden" id="inwRiName" 			 name="inwRiName" 				value="${inw.riName }"/>
						<input type="hidden" id="inwAssdNo" 			 name="inwAssdNo" 				value="${inw.assdNo }"/>
						<input type="hidden" id="inwAssdName" 			 name="inwAssdName" 			value="${inw.assdName }"/>
						<input type="hidden" id="inwRiPolicyNo" 		 name="inwRiPolicyNo" 			value="${inw.riPolicyNo }"/>
						<input type="hidden" id="inwDrvPolicyNo" 		 name="inwDrvPolicyNo" 			value="${inw.drvPolicyNo }"/>
						<input type="hidden" id="inwCurrencyDesc" 		 name="inwCurrencyDesc" 		value="${inw.currencyDesc }"/>
						<input type="hidden" id="inwDefCollAmt" 		 name="inwDefCollAmt" 			value=""/>
						<input type="hidden" id="inwPremiumTax" 		 name="inwPremiumTax" 			value=""/>
						<input type="hidden" id="inwSavedItem" 		 	 name="inwSavedItem" 			value="Y"/>
						<input type="hidden" id="inwSoaCollectionAmt" 	 name="inwSoaCollectionAmt" 	value="" />
						<input type="hidden" id="inwSoaPremiumAmt" 	 	 name="inwSoaPremiumAmt" 		value="" />
						<input type="hidden" id="inwSoaPremiumTax" 	 	 name="inwSoaPremiumTax" 		value="" />
						<input type="hidden" id="inwSoaWholdingTax" 	 name="inwSoaWholdingTax" 		value="" />
						<input type="hidden" id="inwSoaCommAmt" 		 name="inwSoaCommAmt" 			value="" />
						<input type="hidden" id="inwSoaTaxAmount" 		 name="inwSoaTaxAmount" 		value="" />
						<input type="hidden" id="inwSoaCommVat" 		 name="inwSoaCommVat" 			value="" />
						<input type="hidden" id="inwDefForgnCurAmt" 	 name="inwDefForgnCurAmt" 		value="" />		
						
						<label name="textInw" style="text-align: left; width: 10%; margin-right: 3px;">${inw.transactionType } - ${inw.transactionTypeDesc }<c:if test="${empty inw.transactionTypeDesc}">---</c:if></label>
						<label name="textInw" style="text-align: left; width: 10%; margin-right: 3px;">${inw.riName }<c:if test="${empty inw.riName}">---</c:if></label>
						<label name="textInwNo" style="text-align: right; width: 9%; margin-right: 3px;">${inw.b140PremSeqNo }<c:if test="${empty inw.b140PremSeqNo}">---</c:if></label>
						<label name="textInw" style="text-align: right; width: 7%; margin-right: 3px;">${inw.instNo }<c:if test="${empty inw.instNo}">---</c:if></label>
						<label name="textInwAmt" style="text-align: right; width: 12%; margin-right: 3px;" class="money">${inw.collectionAmt }<c:if test="${empty inw.collectionAmt}">---</c:if></label>
						<label name="textInwAmt" style="text-align: right; width: 12%; margin-right: 3px;" class="money">${inw.premiumAmt }<c:if test="${empty inw.premiumAmt}">---</c:if></label>
						<label name="textInwAmt" style="text-align: right; width: 12%; margin-right: 3px;" class="money">${inw.taxAmount }<c:if test="${empty inw.taxAmount}">---</c:if></label>
						<label name="textInwAmt" style="text-align: right; width: 12%; margin-right: 3px;" class="money">${inw.commAmt }<c:if test="${empty inw.commAmt}">---</c:if></label>
						<label name="textInwAmt" style="text-align: right; width: 12%;" class="money">${inw.commVat }<c:if test="${empty inw.commVat}">---</c:if></label>
					</div>
				</c:forEach>
			</div>
		</div>
		<div id="inwFaculTotalAmtMainDiv" class="tableHeader" style="margin:10px; margin-top:0px; display:block;">
			<div id="inwFaculTotalAmtDiv" style="width:100%;">
				<label style="text-align:left; width:37%; margin-right: 2px;">Total:</label>
				<label style="text-align:right; width:12%; margin-right: 3px;" class="money">&nbsp;</label>
				<label style="text-align:right; width:12%; margin-right: 3px;" class="money">&nbsp;</label>
				<label style="text-align:right; width:12%; margin-right: 3px;" class="money">&nbsp;</label>
				<label style="text-align:right; width:12%; margin-right: 3px;" class="money">&nbsp;</label>
				<label style="text-align:right; width:12%;" class="money">&nbsp;</label>
			</div>
		</div>
		
<script type="text/javascript">
	//truncate label text
	$$("label[name='textInw']").each(function (label)    {
   		if ((label.innerHTML).length > 12)    {
        	label.update((label.innerHTML).truncate(12, "..."));
    	}
	});
	$$("label[name='textInwNo']").each(function (label)    {
		if (label.innerHTML != "---"){
        	label.update(formatNumberDigits(label.innerHTML,8));
		}
	});
	$$("label[name='textInwAmt']").each(function (label)    {
   		if ((label.innerHTML).length > 13)    {
        	label.update((label.innerHTML).truncate(13, "..."));
    	}
	});
</script>	
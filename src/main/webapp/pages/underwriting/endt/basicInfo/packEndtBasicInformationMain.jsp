<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- added by Jerome Orio 11.04.2010 -->
<script type="text/javascript">
	objUW.hidObjGIPIS002 = {};
	objUW.hidObjGIPIS002.reqCredBranch 	= ('${reqCredBranch}');
	objUW.hidObjGIPIS002.defCredBranch 	= ('${defCredBranch}');
	objUW.hidObjGIPIS002.dispDefaultCredBranch = ('${dispDefaultCredBranch}'); // Kris 07.04.2013 for UW-SPECS-2013-091
	objUW.hidObjGIPIS002.defaultCredBranch = ('${defaultCredBranch}'); // Kris 07.04.2013 for UW-SPECS-2013-091
	objUW.hidObjGIPIS002.reqRefPolNo 	= ('${reqRefPolNo}');
	objUW.hidObjGIPIS002.reqRefNo 	= ('${reqRefNo}'); //added by gab 11.17.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
	objUW.hidObjGIPIS002.gipiWPolbasExist = ('${isExistGipiWPolbas}');
	objUW.hidObjGIPIS002.updIssueDate 	= ('${updIssueDate}');
	objUW.hidObjGIPIS002.updateBooking = ('${updateBooking}');
</script>
<div id="endtBasicInformationDiv" style=" margin-top: 1px;"> <!--  display: none; -->
	<div id="message" style="display : none;">${message}</div>
	<input type="hidden" value="basicInformation" id="pageName" />
	<form id="endtBasicInformationForm">
		 
		<input type="hidden" id="assdNo" 		name="assdNo" 		value="<c:if test="${not empty gipiParList}">${gipiParList.assdNo}</c:if>" />
		<input type="hidden" id="parType" 		name="parType" 		value="${gipiParList.parType}" />
		<input type="hidden" id="parId" 		name="parId" 		value="<c:if test="${not empty gipiParList}">${gipiParList.parId}</c:if>" />
		<input type="hidden" id="lineCd" 		name="lineCd" 		value="<c:if test="${not empty gipiParList}">${gipiParList.lineCd}</c:if>" />
		<input type="hidden" id="parYY" 		name="parYY" 		value="<c:if test="${not empty gipiParList}">${gipiParList.parYy}</c:if>" />
		<input type="hidden" id="issCd" 		name="issCd" 		value="<c:if test="${not empty gipiParList}">${gipiParList.issCd}</c:if>" />
		<input type="hidden" id="parSeqNo" 		name="parSeqNo" 	value="<c:if test="${not empty gipiParList}">${gipiParList.parSeqNo}</c:if>" />
		<input type="hidden" id="quoteSeqNo" 	name="quoteSeqNo" 	value="<c:if test="${not empty gipiParList}">${gipiParList.quoteSeqNo}</c:if>" />
		 
		<input type="hidden" id="b240AssdNo"		name="b240AssdNo"		value="<c:if test="${not empty gipiParList}">${gipiParList.assdNo}</c:if>" />
		<input type="hidden" id="b240ParType" 		name="b240ParType" 		value="<c:if test="${not empty gipiParList}">${gipiParList.parType}</c:if>" />
		<input type="hidden" id="b240ParId" 		name="b240ParId" 		value="<c:if test="${not empty gipiParList}">${gipiParList.parId}</c:if>" />
		<input type="hidden" id="b240LineCd" 		name="b240LineCd" 		value="<c:if test="${not empty gipiParList}">${gipiParList.lineCd}</c:if>" />
		<input type="hidden" id="b240ParYy" 		name="b240ParYy" 		value="<c:if test="${not empty gipiParList}">${gipiParList.parYy}</c:if>" />
		<input type="hidden" id="b240IssCd" 		name="b240IssCd" 		value="<c:if test="${not empty gipiParList}">${gipiParList.issCd}</c:if>" />
		<input type="hidden" id="b240ParSeqNo" 		name="b240ParSeqNo" 	value="<c:if test="${not empty gipiParList}">${gipiParList.parSeqNo}</c:if>" />
		<input type="hidden" id="b240QuoteSeqNo" 	name="b240QuoteSeqNo" 	value="<c:if test="${not empty gipiParList}">${gipiParList.quoteSeqNo}</c:if>" />
		<input type="hidden" id="b240Address1" 		name="b240Address1" 	value="<c:if test="${not empty gipiParList}">${gipiParList.address1}</c:if>" />
		<input type="hidden" id="b240Address2" 		name="b240Address2" 	value="<c:if test="${not empty gipiParList}">${gipiParList.address2}</c:if>" />
		<input type="hidden" id="b240Address3" 		name="b240Address3" 	value="<c:if test="${not empty gipiParList}">${gipiParList.address3}</c:if>" />
		<input type="hidden" id="b240ParStatus" 	name="b240ParStatus" 	value="<c:if test="${not empty gipiParList}">${gipiParList.parStatus}</c:if>" />
		 
		<input type="hidden" id="parStatus" 	name="parStatus" 	value="<c:if test="${not empty gipiParList}">${gipiParList.parStatus}</c:if>" />
		
		<!-- GIPI_WPOLBAS -->
		<input type="hidden" id="b540LabelTag"				name="b540LabelTag"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.labelTag}</c:if>" />	
		<input type="hidden" id="b540EndtExpiryTag"			name="b540EndtExpiryTag"		value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.endtExpiryTag}</c:if>" />	
		<input type="hidden" id="b540LineCd"				name="b540LineCd"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.lineCd}</c:if>" />	
		<input type="hidden" id="b540SublineCd"				name="b540SublineCd"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.sublineCd}</c:if>" />	
		<input type="hidden" id="b540IssCd"					name="b540IssCd"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.issCd}</c:if>" />	
		<input type="hidden" id="b540IssueYY"				name="b540IssueYY"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.issueYy}</c:if>" />	
		<input type="hidden" id="b540PolSeqNo"				name="b540PolSeqNo"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.polSeqNo}</c:if>" />
		<input type="hidden" id="b540RenewNo"				name="b540RenewNo"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.renewNo}</c:if>" />	
		<input type="hidden" id="b540AssdNo"				name="b540AssdNo"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.assdNo}</c:if>" />	
		<input type="hidden" id="b540OldAssdNo"				name="b540OldAssdNo"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.oldAssdNo}</c:if>" />	
		<input type="hidden" id="b540AcctOfCd"				name="b540AcctOfCd"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.acctOfCd}</c:if>" />
		<input type="hidden" id="b540EndtIssCd"				name="b540EndtIssCd"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.endtIssCd}</c:if>" />	
		<input type="hidden" id="b540EndtYy"				name="b540EndtYy"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.endtYy}</c:if>" />	
		<input type="hidden" id="b540EndtSeqNo"				name="b540EndtSeqNo"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.endtSeqNo}</c:if>" />	
		<input type="hidden" id="b540InceptDate"			name="b540InceptDate"			value="<c:if test="${not empty gipiWPolbas}"><fmt:formatDate value="${gipiWPolbas.inceptDate }" pattern="MM-dd-yyyy HH:mm:ss" /></c:if>" />	
		<input type="hidden" id="b540InceptTag"				name="b540InceptTag"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.inceptTag}</c:if>" />	
		<input type="hidden" id="b540ExpiryDate"			name="b540ExpiryDate"			value="<c:if test="${not empty gipiWPolbas}"><fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy HH:mm:ss" /></c:if>" />	
		<input type="hidden" id="b540ExpiryTag"				name="b540ExpiryTag"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.expiryTag}</c:if>" />	
		<input type="hidden" id="b540PremWarrTag"			name="b540PremWarrTag"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.premWarrTag}</c:if>" />
		<input type="hidden" id="b540PremWarrDays"			name="b540PremWarrDays"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.premWarrDays}</c:if>" />
		<input type="hidden" id="b540EffDate"				name="b540EffDate"				value="<c:if test="${not empty gipiWPolbas}"><fmt:formatDate value="${gipiWPolbas.effDate }" pattern="MM-dd-yyyy HH:mm:ss" /></c:if>" />	
		<input type="hidden" id="b540EndtExpiryDate"		name="b540EndtExpiryDate"		value="<c:if test="${not empty gipiWPolbas}"><fmt:formatDate value="${gipiWPolbas.endtExpiryDate }" pattern="MM-dd-yyyy HH:mm:ss" /></c:if>" />	
		<input type="hidden" id="b540PlaceCd"				name="b540PlaceCd"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.placeCd}</c:if>" />	
		<input type="hidden" id="b540IssueDate"				name="b540IssueDate"			value="<c:if test="${not empty gipiWPolbas}"><fmt:formatDate value="${gipiWPolbas.issueDate }" pattern="MM-dd-yyyy HH:mm:ss" /></c:if>" />
		<input type="hidden" id="b540TypeCd"				name="b540TypeCd"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.typeCd}</c:if>" />	
		<input type="hidden" id="b540RefPolNo"				name="b540RefPolNo"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.refPolNo}</c:if>" />
		<input type="hidden" id="b540ManualRenewNo"			name="b540ManualRenewNo"		value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.manualRenewNo}</c:if>" />	
		<input type="hidden" id="b540PolFlag"				name="b540PolFlag"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.polFlag}</c:if>" />
		<input type="hidden" id="b540CoiCancellation"		name="b540CoiCancellation"		value="" />
		<input type="hidden" id="b540EndtCancellation"		name="b540EndtCancellation"		value="" />	
		<input type="hidden" id="b540CancelType"			name="b540CancelType"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.cancelType}</c:if>" />	
		<input type="hidden" id="b540AcctOfCdSw"			name="b540AcctOfCdSw"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.acctOfCdSw}</c:if>" />	
		<input type="hidden" id="b540RegionCd"				name="b540RegionCd"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.regionCd}</c:if>" />
		<input type="hidden" id="b540IndustryCd"			name="b540IndustryCd"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.industryCd}</c:if>" />	
		<input type="hidden" id="b540Address1"				name="b540Address1"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.address1}</c:if>" />
		<input type="hidden" id="b540Address2"				name="b540Address2"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.address2}</c:if>" />
		<input type="hidden" id="b540Address3"				name="b540Address3"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.address3}</c:if>" />
		<input type="hidden" id="b540OldAddress1"			name="b540OldAddress1"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.oldAddress1}</c:if>" />	
		<input type="hidden" id="b540OldAddress2"			name="b540OldAddress2"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.oldAddress2}</c:if>" />	
		<input type="hidden" id="b540OldAddress3"			name="b540OldAddress3"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.oldAddress3}</c:if>" />	
		<input type="hidden" id="b540CredBranch"			name="b540CredBranch"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.credBranch}</c:if>" />	
		<input type="hidden" id="b540MortgName"				name="b540MortgName"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.mortgName}</c:if>" />	
		<input type="hidden" id="b540BookingYear"			name="b540BookingYear"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.bookingYear}</c:if>" />	
		<input type="hidden" id="b540BookingMth"			name="b540BookingMth"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.bookingMth}</c:if>" />	
		<input type="hidden" id="b540CovernotePrintedSw"	name="b540CovernotePrintedSw"	value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.covernotePrintedSw}</c:if>" />
		<input type="hidden" id="b540QuotationPrintedSw"	name="b540QuotationPrintedSw"	value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.quotationPrintedSw}</c:if>" />
		<input type="hidden" id="b540ParId"					name="b540ParId"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.parId}</c:if>" />	
		<input type="hidden" id="b540ForeignAccSw"			name="b540ForeignAccSw"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.foreignAccSw}</c:if>" />
		<input type="hidden" id="b540InvoiceSw"				name="b540InvoiceSw"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.invoiceSw}</c:if>" />	
		<input type="hidden" id="b540AutoRenewFlag"			name="b540AutoRenewFlag"		value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.autoRenewFlag}</c:if>" />	
		<input type="hidden" id="b540ProrateFlag"			name="b540ProrateFlag"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.prorateFlag}</c:if>" />	
		<input type="hidden" id="b540CompSw"				name="b540CompSw"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.compSw}</c:if>" />	
		<input type="hidden" id="b540ShortRtPercent"		name="b540ShortRtPercent"		value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.shortRtPercent}</c:if>" />	
		<input type="hidden" id="b540ProvPremTag"			name="b540ProvPremTag"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.provPremTag}</c:if>" />	
		<input type="hidden" id="b540FleetPrintTag"			name="b540FleetPrintTag"		value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.fleetPrintTag}</c:if>" />	
		<input type="hidden" id="b540WithTariffSw"			name="b540WithTariffSw"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.withTariffSw}</c:if>" />
		<input type="hidden" id="b540ProvPremPct"			name="b540ProvPremPct"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.provPremPct}</c:if>" />	
		<input type="hidden" id="b540RefOpenPolNo"			name="b540RefOpenPolNo"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.refOpenPolNo}</c:if>" />
		<input type="hidden" id="b540SamePolNoSw"			name="b540SamePolNoSw"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.samePolnoSw}</c:if>" />	
		<input type="hidden" id="b540AnnTsiAmt"				name="b540AnnTsiAmt"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.annTsiAmt}</c:if>" />	
		<input type="hidden" id="b540PremAmt"				name="b540PremAmt"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.premAmt}</c:if>" />	
		<input type="hidden" id="b540TsiAmt"				name="b540TsiAmt"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.tsiAmt}</c:if>" />	
		<input type="hidden" id="b540AnnPremAmt"			name="b540AnnPremAmt"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.annPremAmt}</c:if>" />	
		<input type="hidden" id="b540RegPolicySw"			name="b540RegPolicySw"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.regPolicySw}</c:if>" />	
		<input type="hidden" id="b540CoInsuranceSw"			name="b540CoInsuranceSw"		value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.coInsuranceSw}</c:if>" />	
		<input type="hidden" id="b540UserId"				name="b540UserId"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.userId}</c:if>" />	
		<input type="hidden" id="b540PackPolFlag"			name="b540PackPolFlag"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.packPolFlag}</c:if>" />	
		<input type="hidden" id="b540Designation"			name="b540Designation"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.designation}</c:if>" />	
		<input type="hidden" id="b540BackStat"				name="b540BackStat"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.backStat}</c:if>" />
		<input type="hidden" id="b540BackEndt"				name="b540BackEndt"				value="" />
		<input type="hidden" id="b540RiskTag"				name="b540RiskTag"				value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.riskTag}</c:if>" />	
		<input type="hidden" id="b540SurveyAgentCd"			name="b540SurveyAgentCd"		value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.surveyAgentCd}</c:if>" />	
		<input type="hidden" id="b540SettlingAgentCd"		name="b540SettlingAgentCd"		value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.settlingAgentCd}</c:if>" />	
		<input type="hidden" id="b540TakeupTerm"			name="b540TakeupTerm"			value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.takeupTerm}</c:if>" />	
		<input type="hidden" id="b540BancaTag"				name="b540BancaTag"				value="" />
		<input type="hidden" id="b540BancTypeCd"			name="b540BancTypeCd"			value="" />	
		<input type="hidden" id="b540AreaCd"				name="b540AreaCd"				value="" />	
		<input type="hidden" id="b540BranchCd"				name="b540BranchCd"				value="" />
		<input type="hidden" id="b540CancelledEndtId"	name="b540CancelledEndtId"				value="" />
		<!-- GIPI_WENDTTEXT -->
		<input type="hidden" id="b360EndtTax"		name="b360EndtTax"		value="<c:if test="${not empty gipiWEndtText}">${gipiWEndtText.endtTax}</c:if>" />
		<input type="hidden" id="b360EndtText01" 	name="b360EndtText01" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText01)}</c:if>" />
		<input type="hidden" id="b360EndtText02" 	name="b360EndtText02" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText02)}</c:if>" />
		<input type="hidden" id="b360EndtText03" 	name="b360EndtText03" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText03)}</c:if>" />
		<input type="hidden" id="b360EndtText04" 	name="b360EndtText04" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText04)}</c:if>" />
		<input type="hidden" id="b360EndtText05" 	name="b360EndtText05" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText05)}</c:if>" />
		<input type="hidden" id="b360EndtText06" 	name="b360EndtText06" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText06)}</c:if>" />
		<input type="hidden" id="b360EndtText07" 	name="b360EndtText07" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText07)}</c:if>" />
		<input type="hidden" id="b360EndtText08" 	name="b360EndtText08" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText08)}</c:if>" />
		<input type="hidden" id="b360EndtText09" 	name="b360EndtText09" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText09)}</c:if>" />
		<input type="hidden" id="b360EndtText10" 	name="b360EndtText10" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText10)}</c:if>" />
		<input type="hidden" id="b360EndtText11" 	name="b360EndtText11" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText11)}</c:if>" />
		<input type="hidden" id="b360EndtText12" 	name="b360EndtText12" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText12)}</c:if>" />
		<input type="hidden" id="b360EndtText13" 	name="b360EndtText13" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText13)}</c:if>" />
		<input type="hidden" id="b360EndtText14" 	name="b360EndtText14" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText14)}</c:if>" />
		<input type="hidden" id="b360EndtText15" 	name="b360EndtText15" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText15)}</c:if>" />
		<input type="hidden" id="b360EndtText16" 	name="b360EndtText16" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText16)}</c:if>" />
		<input type="hidden" id="b360EndtText17" 	name="b360EndtText17" 	value="<c:if test="${not empty gipiWEndtText}">${fn:escapeXml(gipiWEndtText.endtText17)}</c:if>" />
		
		<!-- GIPI_WPOLGENIN -->
		<input type="hidden" id="b550GenInfo01" name="b550GenInfo01" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo01)}</c:if>" />
		<input type="hidden" id="b550GenInfo02" name="b550GenInfo02" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo02)}</c:if>" />
		<input type="hidden" id="b550GenInfo03" name="b550GenInfo03" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo03)}</c:if>" />
		<input type="hidden" id="b550GenInfo04" name="b550GenInfo04" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo04)}</c:if>" />
		<input type="hidden" id="b550GenInfo05" name="b550GenInfo05" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo05)}</c:if>" />
		<input type="hidden" id="b550GenInfo06" name="b550GenInfo06" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo06)}</c:if>" />
		<input type="hidden" id="b550GenInfo07" name="b550GenInfo07" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo07)}</c:if>" />
		<input type="hidden" id="b550GenInfo08" name="b550GenInfo08" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo08)}</c:if>" />
		<input type="hidden" id="b550GenInfo09" name="b550GenInfo09" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo09)}</c:if>" />
		<input type="hidden" id="b550GenInfo10" name="b550GenInfo10" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo10)}</c:if>" />
		<input type="hidden" id="b550GenInfo11" name="b550GenInfo11" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo11)}</c:if>" />
		<input type="hidden" id="b550GenInfo12" name="b550GenInfo12" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo12)}</c:if>" />
		<input type="hidden" id="b550GenInfo13" name="b550GenInfo13" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo13)}</c:if>" />
		<input type="hidden" id="b550GenInfo14" name="b550GenInfo14" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo14)}</c:if>" />
		<input type="hidden" id="b550GenInfo15" name="b550GenInfo15" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo15)}</c:if>" />
		<input type="hidden" id="b550GenInfo16" name="b550GenInfo16" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo16)}</c:if>" />
		<input type="hidden" id="b550GenInfo17" name="b550GenInfo17" value="<c:if test="${not empty gipiWPolGenin}">${fn:escapeXml(gipiWPolGenin.genInfo17)}</c:if>" />
		
		<!-- GIPIS031 variables -->
		<input type="hidden" id="varFireWvr" 			name="varFireWvr" 				value="1" />
		<input type="hidden" id="varNewEndt" 			name="varNewEndt" 				value="N" />
		<input type="hidden" id="varOldDateEff" 		name="varOldDateEff" 			value="<c:if test="${not empty gipiWPolbas}"><fmt:formatDate value="${gipiWPolbas.effDate }" pattern="MM-dd-yyyy" /></c:if>" />
		<input type="hidden" id="varOldDateExp" 		name="varOldDateExp" 			value="<c:if test="${not empty gipiWPolbas}"><fmt:formatDate value="${gipiWPolbas.endtExpiryDate }" pattern="MM-dd-yyyy" /></c:if>" />
		<input type="hidden" id="varCommitSwitch" 		name="varCommitSwitch" 			value="" />
		<input type="hidden" id="varB490PremAmt" 		name="varB490PremAmt" 			value="" />
		<input type="hidden" id="varB490AnnPremAmt" 	name="varB490AnnPremAmt" 		value="" />
		<input type="hidden" id="varB490TsiAmt" 		name="varB490TsiAmt" 			value="" />
		<input type="hidden" id="varB490PremRt" 		name="varB490PremRt" 			value="" />
		<input type="hidden" id="varExpOldDte" 			name="varExpOldDte" 			value="<c:if test="${not empty gipiWPolbas}"><fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" /></c:if>" />
		<input type="hidden" id="varEffOldDte" 			name="varEffOldDte" 			value="<c:if test="${not empty gipiWPolbas}"><fmt:formatDate value="${gipiWPolbas.effDate }" pattern="MM-dd-yyyy" /></c:if>" />
		<input type="hidden" id="varOldAsr" 			name="varOldAsr" 				value="" />
		<input type="hidden" id="varPolTmpNo" 			name="varPolTmpNo" 				value="" />
		<input type="hidden" id="varMplSwitch" 			name="varMplSwitch" 			value="N" />
		<input type="hidden" id="varLineTmpCd" 			name="varLineTmpCd" 			value="" />
		<input type="hidden" id="varSublineTmpCd" 		name="varSublineTmpCd" 			value="" />
		<input type="hidden" id="varIssTmpCd" 			name="varIssTmpCd" 				value="" />
		<input type="hidden" id="varIssueTmpYY" 		name="varIssueTmpYY" 			value="" />
		<input type="hidden" id="varRenewNoTmp" 		name="varRenewNoTmp" 			value="" />
		<input type="hidden" id="varLcMc" 				name="varLcMc" 					value="${varLcMc}" />
		<input type="hidden" id="varLcAc" 				name="varLcAc" 					value="${varLcAc}" />
		<input type="hidden" id="varLcEn" 				name="varLcEn" 					value="${varLcEn}" />
		<input type="hidden" id="varSublineMop" 		name="varSublineMop" 			value="${varSublineMop}" />
		<input type="hidden" id="varDummyX" 			name="varDummyX" 				value="" />
		<input type="hidden" id="varPolChangedSw" 		name="varPolChangedSw" 			value="N" />
		<input type="hidden" id="varProrateSw" 			name="varProrateSw" 			value="N" />
		<input type="hidden" id="varShtRtPct" 			name="varShtRtPct" 				value="" />
		<input type="hidden" id="varOldLineCd" 			name="varOldLineCd" 			value="" />
		<input type="hidden" id="varOldSublineCd" 		name="varOldSublineCd" 			value="" />
		<input type="hidden" id="varOldIssCd" 			name="varOldIssCd" 				value="" />
		<input type="hidden" id="varOldIssueYY" 		name="varOldIssueYY" 			value="" />
		<input type="hidden" id="varOldPolSeqNo" 		name="varOldPolSeqNo" 			value="" />
		<input type="hidden" id="varOldRenewNo" 		name="varOldRenewNo" 			value="" />
		<input type="hidden" id="varOldInceptDate" 		name="varOldInceptDate" 		value="" />
		<input type="hidden" id="varOldExpiryDate" 		name="varOldExpiryDate" 		value="" />
		<input type="hidden" id="varOldEffDate" 		name="varOldEffDate" 			value="" />
		<input type="hidden" id="varOldEndtExpiryDate" 	name="varOldEndtExpiryDate" 	value="" />
		<input type="hidden" id="varOldProvPremTag" 	name="varOldProvPremTag" 		value="" />
		<input type="hidden" id="varOldProvPremPct" 	name="varOldProvPremPct" 		value="" />
		<input type="hidden" id="varOldProrateFlag" 	name="varOldProrateFlag" 		value="" />
		<input type="hidden" id="varOldShortRtPercent" 	name="varOldShortRtPercent" 	value="" />
		<input type="hidden" id="varOldShortRtPercent2"	name="varOldShortRtPercent2" 	value="" />
		<input type="hidden" id="varMaxEffDate" 		name="varMaxEffDate" 			value="" />
		<input type="hidden" id="varExpChgSw" 			name="varExpChgSw" 				value="${varExpChgSw}" />
		<input type="hidden" id="varAddTime" 			name="varAddTime" 				value="0" />
		<input type="hidden" id="varEndOfDay" 			name="varEndOfDay" 				value="" />
		<input type="hidden" id="varDellBillSw" 		name="varDellBillSw" 			value="Y" />
		<input type="hidden" id="varExtAssd" 			name="varExtAssd" 				value="" />
		<input type="hidden" id="varOldAssd" 			name="varOldAssd" 				value="" />
		<input type="hidden" id="varAdvanceBooking" 	name="varAdvanceBooking" 		value="${varAdvanceBooking}" />
		<input type="hidden" id="varProrataEffDate" 	name="varProrataEffDate" 		value="" />
		<input type="hidden" id="varExpiryDate" 		name="varExpiryDate" 			value="" />
		<input type="hidden" id="varInceptDate" 		name="varInceptDate" 			value="" />
		<input type="hidden" id="varDays" 				name="varDays" 					value="" />
		<input type="hidden" id="varOldRiskTag" 		name="varOldRiskTag" 			value="" />
		<input type="hidden" id="varDefCredBranch" 		name="varDefCredBranch" 		value="" />
		<input type="hidden" id="varPrevDeductibleCd" 	name="varPrevDeductibleCd" 		value="" />
		<input type="hidden" id="varSwitchPostRec" 		name="varSwitchPostRec" 		value="N" />
		<input type="hidden" id="varCnclldFlatFlag" 	name="varCnclldFlatFlag" 		value="N" />
		<input type="hidden" id="varCnclldFlag" 		name="varCnclldFlag" 			value="N" />
		<input type="hidden" id="varCancellationFlag" 	name="varCancellationFlag" 		value="N" />
		<input type="hidden" id="varCancellationType" 	name="varCancellationType" 		value="" />
		<input type="hidden" id="varPremAmt" 			name="varPremAmt" 				value="" />
		<input type="hidden" id="varTsiAmt" 			name="varTsiAmt" 				value="" />
		<input type="hidden" id="varItmPremAmt" 		name="varItmPremAmt" 			value="" />
		<input type="hidden" id="varItmTsiAmt" 			name="varItmTsiAmt" 			value="" />
		<input type="hidden" id="varBancPayeeClass" 	name="varBancPayeeClass" 		value="" />
		
		<!-- GIPIS031 parameters -->
		<input type="hidden" id="parInvalidSw" 			name="parInvalidSw" 		value="N" />
		<input type="hidden" id="parPostRecSwitch" 		name="parPostRecSwitch" 	value="N" />
		<input type="hidden" id="parInsWinvoice" 		name="parInsWinvoice" 		value="N" />
		<input type="hidden" id="parModalFlag" 			name="parModalFlag" 		value="N" />
		<input type="hidden" id="parProrateCancelSw" 	name="parProrateCancelSw" 	value="N" />
		<input type="hidden" id="parSysdateSw" 			name="parSysdateSw" 		value="${parSysdateSw}" />
		<input type="hidden" id="parEndtPolId" 			name="parEndtPolId" 		value="" />
		<input type="hidden" id="parCancelPolId" 		name="parCancelPolId" 		value="" />
		<input type="hidden" id="parFirstEndtSw" 		name="parFirstEndtSw" 		value="${parFirstEndtSw}" />
		<input type="hidden" id="parBackEndtSw" 		name="parBackEndtSw" 		value="N" />
		<input type="hidden" id="parVarNdate" 			name="parVarNdate" 			value="" />
		<input type="hidden" id="parVarIdate" 			name="parVarIdate" 			value="" />
		<input type="hidden" id="parVarVdate" 			name="parVarVdate" 			value="${parVarVdate}" />
		<input type="hidden" id="parB560InvokeSw" 		name="parB560InvokeSw" 		value="" />
		<input type="hidden" id="parConfirmSw" 			name="parConfirmSw" 		value="${parConfirmSw}" />
		<input type="hidden" id="parAddToGroupSw" 		name="parAddToGroupSw" 		value="" />
		<input type="hidden" id="parB540Status" 		name="parparB540Status" 	value="" />
		<input type="hidden" id="parVendt" 				name="parVendt" 			value="${parVEndt}" />
		<input type="hidden" id="parEndtTaxSw" 			name="parEndtTaxSw" 		value="X" />
		<input type="hidden" id="parB530Status" 		name="parB530Status" 		value="" />
		<input type="hidden" id="parB560Status" 		name="parB560Status" 		value="" />
		<input type="hidden" id="parSublineCd" 			name="parSublineCd" 		value="" />
		<input type="hidden" id="parPrateDaysParm" 		name="parPrateDaysParm" 	value="" />
		<input type="hidden" id="parOpenPolicySw" 		name="parOpenPolicySw" 		value="" />
		<input type="hidden" id="parPolFlag" 			name="parPolFlag" 			value="N" />
		<input type="hidden" id="parOpSublineCd" 		name="parOpSublineCd" 		value="" />
		<input type="hidden" id="parOpIssCd" 			name="parOpIssCd" 			value="" />
		<input type="hidden" id="parOpIssueYY" 			name="parOpIssueYY" 		value="" />
		<input type="hidden" id="parOpPolSeqNo" 		name="parOpPolSeqNo" 		value="" />
		<input type="hidden" id="parOpRenewNo" 			name="parOpRenewNo" 		value="" />
		<input type="hidden" id="parDecltnNo" 			name="parDecltnNo" 			value="" />
		<input type="hidden" id="parAllowBlockEntrySw" 	name="parAllowBlockEntrySw" value="Y" />
		
		<!-- GIPIS031 other variables -->
		<input type="hidden" id="cg$CtrlPlace"				name="cg$CtrlPlace"				value="" />
		<input type="hidden" id="cg$CtrlMopSubline"			name="cg$CtrlMopSubline"		value="${cg$CtrlMopSubline}" >
		<input type="hidden" id="recordStatus"				name="recordStatus"				value="0" />
		<input type="hidden" id="varVdate"					name="varVdate"  				value="${varVdate }" />
		<input type="hidden" id="updateIssueDate"			name="updateIssueDate"  		value="N" />
		<input type="hidden" id="globalCg$BackEndt"			name="globalCg$BackEndt"		value="${globalCg$BackEndt}" />
		<input type="hidden" id="globalCancellationType"	name="globalCancellationType"	value="${globalCancellationType}" />
		<input type="hidden" id="globalCancelTag"			name="globalCancelTag"			value="${globalCancelTag}" />
		

		<input type="hidden" id="stopper"						name="stopper"						value="0" />
		<input type="hidden" id="processStatus"					name="processStatus"				value="" />
		<input type="hidden" id="dateChangeAlert"				name="dateChangeAlert"				value="N" />
		<input type="hidden" id="existingClaim"					name="existingClaim"				value="${existingClaim}" />
		<input type="hidden" id="paidAmt"						name="paidAmt"						value="${paidAmt}" />
		<input type="hidden" id="reqSurveySettAgent"			name="reqSurveySettAgent"			value="${reqSurveySettAgent}" />
		<input type="hidden" id="reqCredBranch"					name="reqCredBranch"  				value="${reqCredBranch }" />
		<input type="hidden" id="reqRefPolNo"					name="reqRefPolNo"  				value="${reqRefPolNo }" />
		<input type="hidden" id="fieldName"						name="fieldName"					value="" />
		<input type="hidden" id="recExistsInGipiWItem" 			name="recordExistsInGipiWItem" 		value="" />
		<input type="hidden" id="recExistsInGipiWItmperl" 		name="recExistsInGipiWItmperl" 		value="" />
		<input type="hidden" id="recExistsInGipiWFireItm" 		name="recExistsInGipiWFireItm" 		value="" />
		<input type="hidden" id="recExixtsInGipiWVehicle" 		name="recExixtsInGipiWVehicle" 		value="" />
		<input type="hidden" id="recExistsInGipiWAccidentItem" 	name="recExistsInGipiWAccidentItem" value="" />
		<input type="hidden" id="recExistsInGipiWAviationItem" 	name="recExistsInGipiWAviationItem" value="" />
		<input type="hidden" id="recExistsInGipiWCargo" 		name="recExistsInGipiWCargo" 		value="" />
		<input type="hidden" id="recExistsInGipiWCasualtyItem" 	name="recExistsInGipiWCasualtyItem" value="" />
		<input type="hidden" id="recExistsInGipiWEnggBasic" 	name="recExistsInGipiWEnggBasic" 	value="" />
		<input type="hidden" id="recExistsInGipiWItemVes" 		name="recExistsInGipiWItemVes" 		value="" />
		
		<input type="hidden" id="clickPackagePolicy"			name="clickPackagePolicy"			value="N" />
		<input type="hidden" id="clickRegularPolicy"			name="clickRegularPolicy"			value="N" />
		<input type="hidden" id="clickPremiumWarranty"			name="clickPremiumWarranty"			value="N" />
		<input type="hidden" id="clickFleetTag"					name="clickFleetTag"				value="N" />
		<input type="hidden" id="clickTariff"					name="clickTariff"					value="N" />
		<input type="hidden" id="clickEndorseTax"				name="clickEndorseTax"				value="N" />
		<input type="hidden" id="clickCancelledFlat"			name="clickCancelledFlat"			value="N" />
		<input type="hidden" id="clickCancelled"				name="clickCancelled" 				value="N" />
		<input type="hidden" id="clickEndtCancellation" 		name="clickEndtCancellation"		value="N" />
		<input type="hidden" id="clickCoiCancellation"			name="clickCoiCancellation" 		value="N" />
		
		<!-- Tag variable (added by emman 11.22.2010) -->
		<input type="hidden" id="isPack"			name="isPack" 		value="${isPack}<c:if test="${empty isPack }">N</c:if>" />
		
		<div id="gipis031ItemTable" name="gipis031ItemTab" style="display: none;">
		<c:forEach var="item" items="${gipiWItems}">
			<div id="endtItem_${item.itemNo}" name="endtItems" style="display: none;"
				parId="${item.parId}" 				itemNo="${item.itemNo}" 				itemTitle="${item.itemTitle}" 			itemGrp="${item.itemGrp}"
				itemDesc="${item.itemDesc}" 		itemDesc2="${item.itemDesc2}" 			tsiAmt="${item.tsiAmt}" 				premAmt="${item.premAmt}"
				annPremAmt="${item.annPremAmt}" 	annTsiAmt="${item.annTsiAmt}"			recFlag="${item.recFlag}" 				currencyCd="${item.currencyCd}"
				currencyRt="${item.currencyRt}" 	groupCd="${item.groupCd}" 				fromDate="${item.fromDate}" 			toDate="${item.toDate}"
				packLineCd="${item.packLineCd}" 	packSublineCd="${item.packSublineCd}" 	discountSw="${item.discountSw}" 		coverageCd="${item.coverageCd}"
				otherInfo="${item.otherInfo}" 		surchargeSw="${item.surchargeSw}" 		regionCd="${item.regionCd}" 			changedTag="${item.changedTag}"
				prorateFlag="${item.prorateFlag}" 	compSw="${item.compSw}" 				shortRtPercent="${item.shortRtPercent}" packBenCd="${item.packBenCd}"
				paytTerms="${item.paytTerms}" 		riskNo="${item.riskNo}" 				riskItemNo="${item.riskItemNo}" />				
			</div>
		</c:forEach>
		</div>
		
		<div id="gipis031ItemPerilTable" name="gipis031ItemPerilTable" style="display: none;">
		<c:forEach var="itmPerl" items="${gipiWItmPerls}">
			<div id="endtItmPerl_${itmPerl.itemNo}_${itmPerl.perilCd}" name="endtItmPerls" style="display: none;"
				parId="${itmPerl.parId}" 			itemNo="${itmPerl.itemNo}" 				lineCd="${itmPerl.lineCd}" 			perilCd="${itmPerl.perilCd}"
				tarfCd="${itmPerl.tarfCd}" 			premRt="${itmPerl.premRt}" 				tsiAmt="${itmPerl.tsiAmt}" 			premAmt="${itmPerl.premAmt}"
				annTsiAmt="${itmPerl.annTsiAmt}" 	annPremAmt="${itmPerl.annPremAmt}" 		recFlag="${itmPerl.recFlag}" 		compRem="${itmPerl.compRem}"
				discountSw="${itmPerl.discountSw}" 	prtFlag="${itmPerl.prtFlag}" 			riCommRate="${itmPerl.riCommRate}" 	riCommAmt="${itmPerl.riCommAmt}"
				asChargeSw="${itmPerl.asChargeSw}" 	surchargeSw="${itmPerl.surchargeSw}" 	noOfDays="${itmPerl.noOfDays}" 		baseAmt="${itmPerl.baseAmt}"
				aggregateSw="${itmPerl.aggregateSw}" >
			</div>
		</c:forEach>
		</div>
		
		<jsp:include page="../../subPages/basicInformation.jsp"></jsp:include> 
		<jsp:include page="../../subPages/poi.jsp"></jsp:include>
		<jsp:include page="../../subPages/otherDetails.jsp"></jsp:include>
		
		<div id="mortgageePopups">
			<input type="hidden" id="mortgageeLevel" name="mortgageeLevel" value="0" />
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Mortgagee Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showMortgagee" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>	
			<div id="mortgageeInfo" class="sectionDiv" style="display: none;"></div>			
		</div>
		<!-- <div id="deductibleDetail">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Policy Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible1" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>
			<div id="deductibleDiv1" class="sectionDiv" style="display: none;"></div>
			<input type="hidden" id="dedLevel" name="dedLevel" value="1">
		</div> -->
		
		<div class="buttonsDiv">
			<input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel" />
			<input type="button" id="btnSave" name="btnSave" class="button" value="Save" />
		</div>		
	</form>
	<div id="endtBasicInfoDiv" name="endtBasicInfoDiv" style="display: none;">
	</div>
</div>

<script type="text/javascript" defer="defer">
	changeTag = 0; // added by: Nica 11.16.2011 - to ensure that changeTag is reset
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	var tempChangeTag = 0;

	/** set variables obtained from new form instance function */
	
	var checkLineSubline = '${checkLineSubline }';			// the value used to check if a package line subline exists
	var checkExistingClaims = '${checkExistingClaims }';	// the value used to check for existence of claims
	
	setModuleId("GIPIS031A");
	setDocumentTitle("Package Endt. Basic Information");

	/** set endt no. (to prevent problem of not displaying the endt no. on Firefox 6 - emman 09.05.2011) **/
	if (nvl('${gipiWPolbas }', null)) {
		$("endtNo").value = '${gipiWPolbas.lineCd } - ${gipiWPolbas.sublineCd } - ${gipiWPolbas.endtIssCd } - ${gipiWPolbas.endtYy }';
	}

	// set Issue Date to current date as default value
	$("issueDate").value = nvl($F("issueDate"), $F("issueDateToday"));
	
	var lineCd 		= $F("b540LineCd");
	var sublineCd 	= $F("b540SublineCd");
	var issCd 		= $F("b540IssCd");
	var issueYy 	= $F("b540IssueYY");
	var polSeqNo 	= $F("b540PolSeqNo");		
	var renewNo 	= $F("b540RenewNo").empty() ? "0" : $F("b540RenewNo");
	var paidAmt		= new Number($F("paidAmt"));

	var endtSw = "N";
	var existSw = "N";

	var polChangedFlag = "";	
	var cancellationChecked = "";
	var renewExist = "N";        // nante  12.3.2013
	$("manualRenewNo").disable();
	$("packagePolicy").disable();
	$("rowSublineCd").hide();

	if($F("b540LineCd") != $F("varLcMc")){
		$("fleetTag").disable();
	}
	
	/*$("showDeductible1").observe("click", function() {
		if($("inputDeductible1") == null){
			showDeductibleModal(1);
		}
	});*/ // commented by: Nica 11.10.2011 - endt Pack Basic info has no policy deductible subpage
	
	$("showMortgagee").observe("click", function(){
		if($("mortgageeInfo").empty()){
			//showMortgageeInfoModalForPack(objUWGlobal.packParId, "0");
			if(objUW.hidObjGIPIS002.gipiWPolbasExist == "1"){
				showMortgageeInfoModalForPackage(objUWGlobal.packParId, "0");
			}else{
				showMessageBox("Mortgagee Entry is not available. Please save record first.", imgMessage.INFO);
				$("showMortgagee").innerHTML = "Show";
			}
		}
	});

	function showMortgageeInfoModalForPack(parId, itemNo){
		var itemNo = ($F("pageName") == "itemInformation" ? 1 : 0);
		
		new Ajax.Updater("mortgageeInfo", contextPath+"/GIPIParMortgageeController?action=getItemParMortgageeForPack&parId="+parId+"&itemNo="+itemNo, {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			onCreate: function(){
				showNotice("Retrieving mortgagee, please wait...");
			},
			onComplete: function(){
				hideNotice("Retrieving complete!");
			}
		});
		
		/*Modalbox.show(contextPath+"/GIPIParMortgageeController?action=getItemParMortgagee&parId="+parId+"&itemNo="+itemNo, {
			title: "Mortgagee Information",
			width: 600
		});*/
	}

	var endtFields = ["parNo", "sublineCd", "manualRenewNo",
	                  "typeOfPolicy", "address1", "address2", "address3",
	                  "creditingBranch", "assuredName", "inAccountOf", "issueDate",
	                  "issuePlace", "riskTag", "referencePolicyNo", "industry",
	                  "region", /*"packagePolicy", "regularPolicy", "premWarrTag",
	                  "fleetTag", "wTariff", "endorseTax", "nbtPolFlag",
	                  "prorateSw", "doi", "endtEffDate",*/ "prorateFlag",
	                  "bookingMonth", /*"doe", "endtExpDate", "coIns",*/
	                  "takeupTermType", "endorsementInformation", "generalInformation"];

	for(var index = 0, length = endtFields.length; index < length; index++){
		$(endtFields[index]).observe("focus", function(){
			//checkDateFieldsForChanges();			
		});
				
		$(endtFields[index]).observe("change", function(){
			//checkDateFieldsForChanges();
			$("recordStatus").value = "1";			
		});
	}	
	
	/* for pre-text-item in oracle forms 
	$("doi").observe("focus", function(){		
		$("varEffOldDte").value = ($F("parType") == "E") ? $F("doi") : "";						
	});	
	
	$("doe").observe("focus", function(){
		$("varExpOldDte").value = ($F("parType") == "E") ?  $F("doe") : "";
	});	

	$("endtEffDate").observe("focus", function(){
		$("varOldDateEff").value = $F("endtEffDate");
		$("varMplSwitch").value = "N";
	});

	$("endtExpDate").observe("focus", function(){
		$("varOldDateExp").value = $F("endtExpDate");
		$("varMplSwitch").value = "N";
	});
	*/
	
	$("issuePlace").observe("focus", function(){
		$("cg$CtrlPlace").value = $("issuePlace").selectedIndex;
	});

	$("riskTag").observe("focus", function(){
		$("varOldRiskTag").value = $("riskTag").selectedIndex;
	});
	
	$("bookingMonth").observe("focus", function(){
		if($F("parVarVdate") == "1"){
			$("parVarIdate").value = $F("issueDate");
		} else if($F("parVarVdate") == "2"){
			$("parVarIdate").value = $F("endtEffDate");
		} else if($F("parVarVdate") == "3"){
			if(makeDate($F("issueDate")) > makeDate($F("endtEffDate"))){
				$("parVarIdate").value = $F("issueDate");
				$("parVarNdate").value = "issue";
			} else{
				$("parVarIdate").value = $F("endtEffDate");
				$("parVarNdate").value = "effectivity";
			}
		}
	});
	
	$("endorseTax").observe("click", function(){
		$("clickEndorseTax").value = "Y";
				
		if($("endorseTax").checked){
			$("endorseTax").value = "Y";
			if($("nbtPolFlag").checked | $("prorateSw").checked){
				$("endorseTax").value = "N";
				$("endorseTax").checked = false;
				showMessageBox("Endorsement of tax is not available for cancelling endorsement.", imgMessage.ERROR);
				return false;
			}
			$("parEndtTaxSw").value = "Y";

			if(searchInTable("endtItems", "recFlag", "A")){
				$("parEndtTaxSw").value = "X";
			}

			if(getRecordCount("endtItmPerls") > 0){
				$("parEndtTaxSw").value = "N";
				$("b360EndtTax").value = "N";
				$("endorseTax").value = "N";
				showMessageBox("Cannot be tagged as endorsement of tax if there are existing perils", imgMessage.ERROR);
				return false;
			}
			$("parVendt").value = "Y";
		}else{
			$("endorseTax").value = "N";
			$("parEndtTaxSw").value = "X";
		}			
		$("b360EndtTax").value = $F("endorseTax");
	});

	function initializeFields(){
		// $("shortRatePercent").value = $F("shortRatePercent").blank() ? "0" : $F("shortRatePercent"); // comment out by andrew - 4.4.2013 - rate should not be set to zero
		
		$("varOldLineCd").value 		= $F("b540LineCd");
		$("varOldSublineCd").value 		= $F("b540SublineCd");
		$("varOldIssCd").value 			= $F("b540IssCd");
		$("varOldIssueYY").value 		= $F("b540IssueYY");
		$("varOldPolSeqNo").value 		= $F("b540PolSeqNo");
		$("varOldRenewNo").value 		= $F("b540RenewNo");
		$("varOldInceptDate").value 	= $F("b540InceptDate");
		$("varOldExpiryDate").value 	= $F("b540ExpiryDate");
		$("varOldEffDate").value 		= $F("b540EffDate");
		$("varOldEndtExpiryDate").value = $F("b540EndtExpiryDate");
		$("varOldProrateFlag").value 	= $F("b540ProrateFlag");
		$("varOldShortRtPercent").value = $F("b540ShortRtPercent").blank() ? "0" : $F("shortRatePercent");
		$("varOldProvPremTag").value 	= $F("b540ProvPremTag");
		$("varOldProvPremPct").value 	= $F("b540ProvPremPct").blank() ? "0" : $F("b540ProvPremPct");
		$("varEffOldDte").value			= $F("b540EffDate").blank() ? $F("doi") : $F("endtEffDate");
				
		if($F("b540PolFlag") == "4"){
			$("hrefDoiDate").hide();
			$("hrefDoeDate").hide();			
			$("hrefEndtExpDate").hide();
			
			if($F("b540ProrateFlag") == "2"){
				$("prorateSw").checked = false;
				$("nbtPolFlag").checked = true;
				$("prorateFlag").setAttribute("disabled", "disabled");
				$("compSw").setAttribute("disabled", "disabled");
				//$("noOfDays").setAttribute("disabled", "disabled");				
				//$("shortRatePercent").setAttribute("disabled", "disabled");
				$("noOfDays").setAttribute("readonly", "readonly");
				$("shortRatePercent").setAttribute("readonly", "readonly");
			} else{
				$("prorateSw").checked = true;
				$("nbtPolFlag").checked = false;
				$("noOfDays").setAttribute("disabled", "disabled");
				$("prorateFlag").update(
						'<option value="1">Prorate</option>' +						
						'<option value="3">Short Rate</option>');
			}
		}else{
			$("nbtPolFlag").checked = false;
			$("prorateSw").checked = false;
			
			/*select*/
			if($F("b540CancelType") == "1"){
				$("nbtPolFlag").checked = true;
				$("varCancellationType").value = "F";
			} else if($F("b540CancelType") == "2"){
				$("prorateSw").checked = true;
				$("b540ProrateSw").value = "1";
			} else if($F("b540CancelType") == "3"){
				$("endtCancellation").checked = true;
				$("varCancellationType").value = "E";
			} else if($F("b540CancelType") == "4"){
				$("coiCancellation").checked = true;
				$("varCancellationType").value = "C";
			}
			
			if($F("varCancellationType") == "F"){
				$("nbtPolFlag").checked = true;
				$("endtCancellation").checked = false;
				$("coiCancellation").checked = false;
			} else if($F("varCancellationType") == "E"){
				$("nbtPolFlag").checked = false;
				$("endtCancellation").checked = true;
				$("coiCancellation").checked = false;
			} else if($F("varCancellationType") == "C"){
				$("nbtPolFlag").checked = false;
				$("endtCancellation").checked = false;
				$("coiCancellation").checked = true;
			}
		}			
	}

	function setCommonFields(){
		lineCd 		= $F("b540LineCd");
		sublineCd 	= $F("b540SublineCd");
		issCd 		= $F("b540IssCd");
		issueYy 	= $F("b540IssueYY");
		polSeqNo 	= $F("b540PolSeqNo");		
		renewNo 	= $F("b540RenewNo").empty() ? "0" : $F("b540RenewNo");
		paidAmt		= new Number($F("paidAmt"));
	}

	$("btnSave").observe("click", function(){
		try {
			//if($F("recordStatus") == "1"){
			//}else{			
				// check required fields on user's screen
			if(changeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
				return;
			}
			
				var completeRequiredFields = true;
				var requiredFields = "";
				
				requiredFields = $w(getRequiredFields());
	
				for(var index=0, length = requiredFields.length; index < length; index++){
					if($F(requiredFields[index]).empty() && $(requiredFields[index]).visible()){					
						showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR); // - " + requiredFields[index], imgMessage.ERROR);
						completeRequiredFields = false;
						break;
					}
				}			
				
				if(!completeRequiredFields){
					return false;
				}
				
				/* pre-validation */
				if($F("b540PolFlag") == "4" || $("nbtPolFlag").checked || $("prorateSw").checked){
					$("globalCg$BackEndt").value = "N";
				}
	
				if($F("globalCg$BackEndt") == "Y" && $F("parBackEndtSw") == "Y"){				
					Dialog.alert({
						url: contextPath+"/GIPIParInformationController?action=showBackwardEndt&parId=" + objUWGlobal.packParId, 
						options: {method: 'get'}}, {
							className: "alphacube", 
							width:540, 
							okLabel: "Ok",						
							buttonClass: "button",
							ok: checkAction
						});				
					return false;
				}else{
					$("b540BackStat").value = "";
				}
	
				if($F("reqSurveySettAgent") == "Y"){
					if($F("b540SurveyAgentCd") == "" || $F("b540SettlingAgentCd") == ""){
						showMessageBox("Survey Agent and Settling Agent are required", imgMessage.INFO);
						return false;
					}
				}
	
				if($("endtCancellation").checked | $("coiCancellation").checked){
					if($F("parCancelPolId") == ""){
						showMessageBox("Please press Cancel Endt button to choose record for cancellation", imgMessage.INFO);
						return false;
					}
				}
	
				if($F("parConfirmSw") == "Y"){
					$("parConfirmSw").value = "N";
					show3OptionsConfirmBox("", 
						'This policy has been endorsed for a short-term period. Do you want to keep this record permanently?<br /><br />' +
						'<table align="center" width="60%">'+ 
						'<tr>' +
						'<td><input type="radio" name="genRadio" id="genYes"	value="Y" /></td>'+
						'<td><label for="genYes"> Yes</label></td>' +
						'<td><input type="radio" name="genRadio" id="genNo"	value="N" /></td>' +
						'<td><label for="genNo"> No</label></td>' +					
						'</tr>' +
						'</table>', "Ok", "Cancel", shortTermPolicy);
				}
	
				commitSwitchHandler();			
	
				/*
				$("hiddenTemp").value = new myObject("qwerty", 2000);
				myObj = $F("hiddenTemp");
	
				var b360s = ($("b360").innerHTML).evalJSON();
				b360s.b360[0].endtTax = "testing";
				$("b360").update($H(b360s).toJSON());
	
				new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkForPendingClaims", {
					method : "GET",
					parameters : {
						parId : ($F("isPack") == "Y" ? objUWGlobal.packParId : $F("globalParId")),
						wEndtText : $("b360").innerHTML
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : showNotice("Checking for pending claims, please wait..."),
					onComplete : 
						function(response){
							if (checkErrorOnResponse(response)){
								hideNotice("Done!");							
								$("existingClaim").value = response.responseText;
							}											
						}
				});
				*/
				return false;
				
				var nbtPolFlag = $("nbtPolFlag").checked ? "4" : "1";
				var prorateFlag = $("prorateSw").checked ? "1" : "2";
				var bookingMonth = ($("bookingMonth").options[$("bookingMonth").selectedIndex].text).substr(0,4);
				var bookingYear = ($("bookingMonth").options[$("bookingMonth").selectedIndex].text).substr(7);
	
				$("doi").enable();
				$("doe").enable();
				$("endtEffDate").enable();
				$("endtExpDate").enable();
				
				new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateBeforeSave&checkPolFlag=" + nbtPolFlag + "&checkProrateSw=" + prorateFlag +
						"&bookingMth=" + bookingMonth + "&bookingYY=" + bookingYear, {
					method : "POST",
					postBody : Form.serialize("endtBasicInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : showNotice("Validating record, please wait..."),
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice("");					
								
								var result = response.responseText.toQueryParams();
								
								if(result.msgType == null){
									showMessageBox(response.responseText, imgMessage.ERROR);	
								}else{
									if(result.showPopup == "TRUE"){
										showMessageBox(result.showPopup, imgMessage.INFO);
									}else{
										if(result.msgType != "CONFIRM"){
											showMessageBox("Validation complete", imgMessage.INFO);								
										}else{
											showConfirmBox3("Endorsement", result.msgAlert + "?", "Yes", "No", continueProcess, stopProcess);
										}	
									}													
								}	
							}											
					}
				});	
				
				//saveEndorsementBasicInfo();
			//}	
		} catch(e){
			showErrorMessage("save", e);
		}
	});

	$("btnCancel").observe("click", function(){
		//fireEvent($("parExit"), "click"); 
		//checkChangeTagBeforeCancel();
		/*showOverlayContent(
				contextPath
						+ "/GIPIParInformationController?action=showPolicyNo&parId=" + $F("globalEndtParId") + "&lineCd=" + $F("globalEndtLineCd") + "&issCd=" + $F("globalEndtIssCd"),
						overlayOnComplete, (screen.width) / 4,
				100, 50);
		*/		
		//belle 09192012
		if (changeTag == 1){		
			showConfirmBox("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No",
					function(){fireEvent($("btnSave"), "click");}, 
					goBackToPackagePARListing);  
		} else {
			goBackToPackagePARListing();
		}
	});

	function checkAction(){		
		if(!($("radioYes").checked) && !($("radioNo").checked) && !($("radioCancel").checked)){
			showMessageBox("Please select an option first in able to proceed.", imgMessage.INFO);
		}else{
			if($("radioCancel").checked){
				$("b540BackEndt").value = "Y";
			}else{				
				$("parBackEndtSw").value = "N";
				if($("radioYes").checked){
					$("b540BackEndt").value = "Y";
					$("b540BackStat").value = "2";
				}else if($("radioNo").checked){
					$("b540BackEndt").value = "N";
					$("b540BackStat").value = "1";
				}
			}
			return true;			
		}		
	}

	function saveEndorsementBasicInfo(fromCancellationParam){		
		
		//added by gab 02.21.2017
		var completeRequiredFields = true;
		var requiredFields = "";
		
		requiredFields = $w(getRequiredFields());

		for(var index=0, length = requiredFields.length; index < length; index++){
			if($F(requiredFields[index]).empty() && $(requiredFields[index]).visible()){					
				showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
				completeRequiredFields = false;
				break;
			}
		}			
		
		if(!completeRequiredFields){
			return false;
		}
		
		parseOtherDetails();	
		
		var nbtPolFlag = $("nbtPolFlag").checked ? "Y" : "N";
		var prorateSw = $("prorateSw").checked ? "Y" : "N";
		var endtCancellation = $("endtCancellation").checked ? "Y" : "N";
		var coiCancellation = $("coiCancellation").checked ? "Y" : "N";
		var creditingBranch = $F("creditingBranch");

		var controller = "";
		var action = "";
		var showNoticeMessage = "";

		var objParameters = new Object();
		objParameters.setMortgagees = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objMortgagees));
		objParameters.delMortgagees = prepareJsonAsParameter(getDelFilteredObjs(objMortgagees));
		objParameters.packLineSublines = prepareJsonAsParameter(objGIPIWPackLineSubline);

		controller = "GIPIPackParInformationController";
		action = "saveEndtPackBasicInfo";
		showNoticeMessage = "Saving pack endorsement, please wait...";
		new Ajax.Request(contextPath + "/"+controller+"?action="+action+
				"&nbtPolFlag=" + nbtPolFlag + "&prorateSw=" + prorateSw + "&endtCancellation=" + endtCancellation +
				"&coiCancellation=" + coiCancellation + "&creditingBranch=" + creditingBranch + 
				"&parameters=" + encodeURIComponent(JSON.stringify(objParameters))+
				"&renewExist=" + renewExist, {  //nante 12/4/2013
			method : "POST",
			postBody : Form.serialize("endtBasicInformationForm"),
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice(showNoticeMessage),
			onComplete : 
				function(response){
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						if(response.responseText != "SUCCESS"){
							showMessageBox(response.responseText, imgMessage.ERROR);
						}else{
							changeTag = 0; // andrew 09.02.2011
							updatePackParParameters(); // andrew - 09.08.2011
							var successMessage = nvl(nvl(fromCancellation,fromCancellationParam),"N") == "Y" ? ($("prorateSw").checked ? "Endorsement successfully cancelled." : objCommonMessage.SUCCESS) : objCommonMessage.SUCCESS;// irwin 10.29.2012
							showWaitingMessageBox(successMessage, imgMessage.SUCCESS, 
								function() {
									// check if necessary objUWGlobal attributes are null
									if (nvl(objUWGlobal.sublineCd, null) == null) {
										objUWGlobal.sublineCd = $F("b540SublineCd");
									}

									if (nvl(objUWGlobal.issueYy, null) == null) {
										objUWGlobal.issueYy = $F("b540IssueYY");
									}

									if (nvl(objUWGlobal.polSeqNo, null) == null) {
										objUWGlobal.polSeqNo = $F("b540PolSeqNo");
									}

									if (nvl(objUWGlobal.renewNo, null) == null) {
										objUWGlobal.renewNo = $F("b540RenewNo");
									}
									showEndtPackParBasicInfo();
								});
						}						
					}
			}
		});
	}

	function parseOtherDetails(){				
		for(var index=1; index <=17; index++){			
			$("b550GenInfo" + index.toPaddedString(2)).value = $F("generalInformation").substr((index-1)*2000, 2000);
			$("b360EndtText" + index.toPaddedString(2)).value = $F("endtInformation").substr((index-1)*2000, 2000);		
		}		
	}

	function continueProcess(){
		$("dateChangeAlert").value = "Y";
	}

	function stopProcess(){
		return false;
	}

	function overlayOnComplete(){
	}
	
	initializeFields();	
	
	$("manualRenewNo").setStyle("text-align:center;");

	/* mark jm 05.28.10
	** this function (checkForPendingClaims) is used to check if the policy_no has pending claims
	** it is used in Endt Basic Information
	*/
	function checkForPendingClaims(){
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkForPendingClaims", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId,
				lineCd : objUWGlobal.lineCd,
				sublineCd : objUWGlobal.sublineCd,
				issCd : objUWGlobal.issCd,
				issueYY : $F("b540IssueYY"),
				polSeqNo : $F("b540PolSeqNo"),
				renewNo : $F("b540RenewNo")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking for pending claims, please wait..."),
			onComplete : 
				function(response){
					if (checkErrorOnResponse(response)){
						hideNotice("");							
						$("existingClaim").value = response.responseText;
					}											
				}
		});
	}

	/* mark jm 05.28.10
	** this function (checkPolicyPayment) is used to check if the policy_no has payment
	** it is used in Endt Basic Information
	*/
	function checkPolicyPayment(){
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkPolicyPayment", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId,
				lineCd : objUWGlobal.lineCd,
				sublineCd : objUWGlobal.sublineCd,
				issCd : objUWGlobal.issCd,
				issueYY : $F("b540IssueYY"),
				polSeqNo : $F("b540PolSeqNo"),
				renewNo : $F("b540RenewNo")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking policy payment, please wait..."),
			onComplete : 
				function(response){
					if (checkErrorOnResponse(response)){
						hideNotice();
						$("paidAmt").value = new Number(response.responseText);
					}											
				}
		});
	}

	function checkEndtForItemAndPeril(){
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkEndtForItemAndPeril", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId,
				inceptDate : $F("recordStatus") > 0 ? $F("doi") : $F("b540InceptDate"),
				effDate : $F("recordStatus") > 0 ? $F("endtEffDate") : $F("b540EffDate")
			},
			aysnchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking endt for items and perils, please wait..."),
			onComplete : function(response){
				hideNotice();
				$("processStatus").value = "checkEndtForItemAndPeril";
				if(response.responseText != "Empty"){
					showConfirmBox("Endorsement - Item and Peril", response.responseText, "Accept", "Cancel", continueProcess2, stopProcess2);
				}else{
					continueProcess();
				}
			}
		});
	}
	
	$("nbtPolFlag").observe("mouseover", function() {
		tempChangeTag = changeTag;
	});

	$("nbtPolFlag").observe("click", function(){
		//belle 09192012
		var completeRequiredFields = true;
		var requiredFields = "";
		requiredFields = $w(getRequiredFields());

		for(var index=0, length = requiredFields.length; index < length; index++){
			if($F(requiredFields[index]).empty() && $(requiredFields[index]).visible()){					
				showMessageBox("Please fill-in required fields", imgMessage.ERROR); // - " + requiredFields[index], imgMessage.ERROR);
				completeRequiredFields = false;
				break;		
			}
		}			

		if(!completeRequiredFields){
			$("nbtPolFlag").checked = false;
			return false;
		}
		
		// apollo cruz 10.14.2015 - UCPBGEN 20231
		if(changeTag != 0) {
			$("nbtPolFlag").checked = $("nbtPolFlag").checked ? false : true;
			showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
			return false;
		}
		
		//belle
		if($("nbtPolFlag").checked) {
			cancellationChecked = $("prorateSw").checked ? "prorateSw" : "";
			uncheckCheckbox("polFlag");
			setCommonFields();
			checkNewPackRenewals();   // nante  12.6.2013
			if (renewExist == "Y"){   // nante  12.6.2013
				$("nbtPolFlag").checked = false;
				showMessageBox("Renewed policy cannot be cancelled.");
				return;
			}
			
			if (checkLineSubline == 0) {
				$("b540PolFlag").value = "1";
				showMessageBox("Records must be entered first in the Package Line/Subline.", imgMessage.ERROR);
				return;
			}

			if ($F("b360EndtTax") == "Y") {
				$("b540PolFlag").value = "1";
				showMessageBox("Flat Cancellation is not allowed for endorsement of tax.", imgMessage.ERROR);
				return;
			}

			// check for existence of claims and if pending claim(s) is found, disallow cancellation process
			if (checkExistingClaims == "Y") {
				$("b540PolFlag").value = "1";
				showMessageBox("The policy has pending claims, cannot cancel policy.", imgMessage.INFO);
				return;
			}

			$("processStatus").value = "checkPolicyPayment";
			if(paidAmt.valueOf() > 0 | paidAmt.valueOf() < 0){						
				showConfirmBox("Endorsement", "Payments have been made to the policy/endorsement to be cancelled. Continue?", "Accept", "Cancel", continueProcess2, stopProcess2);
			}else{
				continueProcess2();
			}
		} else {
			$("globalCancellationType").value = "";

			$("processStatus").value = "revertFlatCancellation";
			showConfirmBox("Endorsement", "All negated records for this policy will be deleted.", "Accept", "Cancel", continueProcess2, stopProcess2);
		}
		
		/*$("clickCancelledFlat").value = "Y";
			
		if($("nbtPolFlag").checked){
			//return false;
			uncheckCheckbox("polFlag");
			setCommonFields();
			
			if(renewNo!= "0"){
				$("nbtPolFlag").checked = false;
				showMessageBox("Renewed policy cannot be cancelled.");
				return false;
			}else{
				if($("endorseTax").checked){
					$("nbtPolFlag").checked = false;
					showMessageBox("Flat Cancellation is not allowed for endorsement of tax.");
					return false;
				}

				if(lineCd != $F("varOldLineCd") && sublineCd != $F("varOldSublineCd") && issCd != $F("varOldIssCd") && 
						issueYy != $F("varOldIssueYY") && polSeqNo != $F("varOldPolSeqNo") && renewNo != $F("varOldRenewNo")){					
					checkForPendingClaims();
					checkPolicyPayment();
				}

				if($F("existingClaim") == "Y"){
					$("b540PolFlag").value = "1";
					$("nbtPolFlag").checked = false;
					showMessageBox("The policy has pending claims, cannot cancel policy.", imgMessage.ERROR);
					return false;
				}

				$("processStatus").value = "checkPolicyPayment";
				if(paidAmt.valueOf() > 0 | paidAmt.valueOf() < 0){						
					showConfirmBox("Endorsement", "Payments have been made to the policy/endorsement to be cancelled. Continue?", "Accept", "Cancel", continueProcess2, stopProcess2);
				}else{
					continueProcess2();
				}
				
				// process flows now depends on previous function
				// adding statements after this comment will result to
				// by-pass the confirmation from user
			}							
		}else{
			$("globalCancellationType").value = "";

			$("processStatus").value = "revertFlatCancellation";
			showConfirmBox("Endorsement", "All negated records for this policy will be deleted.", "Accept", "Cancel", continueProcess2, stopProcess2);
		}*/	
	});
	
	$("prorateSw").observe("mouseover", function() {
		tempChangeTag = changeTag;
	});

	$("prorateSw").observe("click", function(){
		//belle 09192012
		var completeRequiredFields = true;
		var requiredFields = "";
		requiredFields = $w(getRequiredFields());

		for(var index=0, length = requiredFields.length; index < length; index++){
			if($F(requiredFields[index]).empty() && $(requiredFields[index]).visible()){					
				showMessageBox("Please fill-in required fields", imgMessage.ERROR); // - " + requiredFields[index], imgMessage.ERROR);
				completeRequiredFields = false;
				break;		
			}
		}			

		if(!completeRequiredFields){
			$("prorateSw").checked = false;
			return false;
		}
		
		// apollo cruz 10.14.2015 - UCPBGEN 20231
		if(changeTag != 0) {
			$("prorateSw").checked = $("prorateSw").checked ? false : true;
			showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
			return false;
		}
		
		//belle
		if($("prorateSw").checked){
			cancellationChecked = $("nbtPolFlag").checked ? "polFlag" : "";
			uncheckCheckbox("prorateFlag");
			setCommonFields();
			/* removed by robert 02.24.2014
			if(renewNo!= "0"){
				$("prorateSw").checked = false;
				showMessageBox("Renewed policy cannot be cancelled.");
				if (cancellationChecked == "polFlag") uncheckCheckbox("polFlag");
				return false;
			}else{ */
				if($("endorseTax").checked){
					$("prorateSw").checked = false;
					showMessageBox("Prorate Cancellation is not allowed for endorsement of tax.");
					if (cancellationChecked == "polFlag") uncheckCheckbox("polFlag");
					return false;
				}

				if(lineCd != $F("varOldLineCd") && sublineCd != $F("varOldSublineCd") && issCd != $F("varOldIssCd") && 
						issueYy != $F("varOldIssueYY") && polSeqNo != $F("varOldPolSeqNo") && renewNo != $F("varOldRenewNo")){
					checkForPendingClaims();
					checkPolicyPayment();
				}

				if($F("existingClaim") == "Y"){
					$("b540PolFlag").value = "1";
					$("prorateSw").checked = false;
					showMessageBox("The policy has pending claims, cannot cancel policy.", imgMessage.ERROR);
					if (cancellationChecked == "polFlag") uncheckCheckbox("polFlag");
					return false;
				}

				$("processStatus").value = "checkPolicyPayment";
				if(paidAmt.valueOf() > 0 | paidAmt.valueOf() < 0){						
					showConfirmBox("Endorsement", "Payments have been made to the policy/endorsement to be cancelled. Continue?", "Accept", "Cancel", continueProcess2, stopProcess2);
				}else{
					continueProcess2();
				}				
			//}	removed by robert 02.24.2014
		}else{
			$("processStatus").value = "revertCancellation";
			showConfirmBox("Endorsement", "All negated records for this policy will be deleted.", "Accept", "Cancel", continueProcess2, stopProcess2);
		}			
	});

	$("endtCancellation").observe("click", function(){
		$("clickEndtCancellation").value = "Y";
		
		if($("endtCancellation").checked){
			enableButton("btnCancelEndt");
		}else{
			disableButton("btnCancelEndt");
		}
		
		if($("endtCancellation").checked){
			uncheckCheckbox("endt");
			setCommonFields();
			$("parCancelPolId").value = "";

			if(lineCd != $F("varOldLineCd") && sublineCd != $F("varOldSublineCd") && issCd != $F("varOldIssCd") && 
					issueYy != $F("varOldIssueYY") && polSeqNo != $F("varOldPolSeqNo") && renewNo != $F("varOldRenewNo")){
				checkForPendingClaims();
				checkPolicyPayment();
			}

			if($F("existingClaim") == "Y"){
				$("b540PolFlag").value = "1";
				$("nbtPolFlag").checked = false;
				showMessageBox("The policy has pending claims, cannot cancel policy.", imgMessage.ERROR);
				return false;
			}

			$("processStatus").value = "checkPolicyPayment";
			if(paidAmt.valueOf() > 0 | paidAmt.valueOf() < 0){						
				showConfirmBox("Endorsement", "Payments have been made to the policy/endorsement to be cancelled. Continue?", "Accept", "Cancel", continueProcess2, stopProcess2);
			}else{
				continueProcess2();
			}
		}else{
			$("processStatus").value = "revertEndtCancellation";
			showConfirmBox("Endorsement", "All negated records for this policy will be deleted.", "Accept", "Cancel", continueProcess2, stopProcess2);
		}
	});

	$("coiCancellation").observe("click", function(){
		$("clickCoiCancellation").value = "Y";
		
		if($("coiCancellation").checked){
			enableButton("btnCancelEndt");
		}else{
			disableButton("btnCancelEndt");
		}

		if($("coiCancellation").checked){
			uncheckCheckbox("coi");
			setCommonFields();
			$("parCancelPolId").value = "";

			if(lineCd != $F("varOldLineCd") && sublineCd != $F("varOldSublineCd") && issCd != $F("varOldIssCd") && 
					issueYy != $F("varOldIssueYY") && polSeqNo != $F("varOldPolSeqNo") && renewNo != $F("varOldRenewNo")){
				checkForPendingClaims();
				checkPolicyPayment();
			}

			if($F("existingClaim") == "Y"){
				$("b540PolFlag").value = "1";
				$("nbtPolFlag").checked = false;
				showMessageBox("The policy has pending claims, cannot cancel policy.", imgMessage.ERROR);
				return false;
			}

			$("processStatus").value = "checkPolicyPayment";
			if(paidAmt.valueOf() > 0 | paidAmt.valueOf() < 0){						
				showConfirmBox("Endorsement", "Payments have been made to the policy/endorsement to be cancelled. Continue?", "Accept", "Cancel", continueProcess2, stopProcess2);
			}else{
				continueProcess2();
			}			
		}else{
			$("processStatus").value = "revertCoiCancellation";
			showConfirmBox("Endorsement", "All negated records for this policy will be deleted.", "Accept", "Cancel", continueProcess2, stopProcess2);
		}
	});

	$("btnCancelEndt").observe("mouseover", function() {
		tempChangeTag = changeTag;
	});

	$("btnCancelEndt").observe("click", function(){
		if($("btnCancelEndt").hasClassName("disabledButton")){
			return false;
		}
		// added by robert GENQA 4844 09.03.15
		var requiredFields = "";
		requiredFields = $w(getRequiredFields());

		for(var index=0, length = requiredFields.length; index < length; index++){
			if($F(requiredFields[index]).empty() && $(requiredFields[index]).visible()){					
				showMessageBox("Please fill-in required fields", imgMessage.ERROR);
				return false;
			}
		}
		
		// apollo cruz 10.14.2015 - UCPBGEN 20231
		if(changeTag != 0) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
			return false;
		}
		
		// end robert GENQA 4844 09.03.15
		if($F("b540PolFlag") == "4"){
			//showMessageBox("Cancellation per endorsement is not allowed for PAR tagged for flat/pro-rate cancellation.", imgMessage.INFO);
			showWaitingMessageBox("Cancellation per endorsement is not allowed for PAR tagged for flat/pro-rate cancellation.", imgMessage.INFO, function() {
				changeTag = tempChangeTag;
			});
			return false;
		}
		
		setCommonFields();
		new Ajax.Request(contextPath + "/GIPIPackParInformationController?action=checkPolicyForAffectingEndtToCancel", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId,
				lineCd : lineCd,
				sublineCd : sublineCd,
				issCd : issCd,
				issueYy : issueYy,
				polSeqNo : polSeqNo,
				renewNo : renewNo
			},
			aysnchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking policy, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)){
					hideNotice("");
					if(response.responseText != "N"){							
						endtSw = "Y";							
					}
					
					if(endtSw == "N"){
						showMessageBox("There is no existing endorsement to be cancelled.", imgMessage.INFO);
						return false;
					}	
					checkIfExistingInGipiWitmperl(continueProcess2, stopProcess2);
				}
			}			
		});

		
	});

	function continueCancellation(){
		$("processStatus").value = "continueCancellation";
		if(existSw == "N"){
			checkIfExistingInGipiWitem(continueProcess2, stopProcess2);
		}else{
			continueProcess2();
		}
	}

	function continueCancellation1(){	
		var flag = "pack";
		
		setCommonFields();
		showOverlayContent(contextPath+"/GIPIParInformationController?action=showRecordsForCancellation&parId=" + objUWGlobal.packParId +
				"&lineCd=" + lineCd + "&sublineCd=" + sublineCd + "&issCd=" + issCd + "&issueYy=" + 
				issueYy + "&polSeqNo=" + polSeqNo + "&renewNo=" + renewNo + "&flag=" + flag,
				   "", overlayOnComplete, (screen.width) / 4, 100, 50);
		/*Modalbox.show(contextPath+"/GIPIParInformationController?action=showRecordsForCancellation&parId=" + objUWGlobal.packParId +
				"&lineCd=" + lineCd + "&sublineCd=" + sublineCd + "&issCd=" + issCd + "&issueYy=" + 
				issueYy + "&polSeqNo=" + polSeqNo + "&renewNo=" + renewNo + "&flag=" + flag, {
			title: "Mortgagee Information",
			width: 600
		});*/
	}

	function checkBooking(){
		var index = $("bookingMonth").selectedIndex;
		var text = $("bookingMonth").options[index].text;
		
		if(text.trim() == ""){
			showMessageBox("Booking month and year is needed before performing cancellation.", imgMessage.INFO);
			$("nbtPolFlag").checked = false;
			$("prorateSw").checked = false;
			stopProcess2();
		}else{
			continueCheck();
		}
	}

	function continueCheck(){
		var itemCount = new Number(0);
		var perilCount = new Number(0);
		var flag = "";

		var inceptDate = $F("recordStatus") > 0 ? $F("doi") : $F("b540InceptDate");
		var effDate = $F("recordStatus") > 0 ? $F("endtEffDate") : $F("b540EffDate");

		/* determine flag */
		if($("nbtPolFlag").checked){
			flag = "polFlag";
		}else if($("prorateSw").checked){
			flag = "prorateFlag";
		}else if($("endtCancellation").checked){
			flag = "endtCancellation";
		}else if($("coiCancellation").checked){
			flag = "coiCancellation";
		}
		if(flag == "polFlag" | flag == "prorateFlag"){
			/* checkEndtForItemAndPeril */		
			new Ajax.Request(contextPath + "/GIPIPackParInformationController?action=checkPackEndtForItemAndPeril", {
				method : "GET",
				parameters : {
					parId : objUWGlobal.packParId
				},
				aysnchronous : false,
				evalScripts : true,
				onCreate : showNotice("Checking package endt for items and perils, please wait..."),
				onComplete : function(response){
					if (checkErrorOnResponse(response)){
						hideNotice();
						var result = response.responseText.toQueryParams();
						itemCount = result.itemCount;
						perilCount = result.perilCount;

						var messageText = "";

						if(flag == "polFlag"){
							if(itemCount > 0 || perilCount > 0 || inceptDate != effDate){
								if(inceptDate != effDate){
									messageText = "Flat Cancellation requires an endorsement effectivity as of inception date. Changes are about to take place.";
								}else if(itemCount > 0 && perilCount > 0){
									messageText = "This endorsement have existing item(s) and peril(s), performing cancellation will cause all the records to be replaced.";
								}else if(itemCount > 0){
									messageText = "This endorsement have existing item(s), performing cancellation will cause all the records to be replaced.";
								}
							}
							$("processStatus").value = "checkEndtForItemAndPeril";
							if(messageText == ""){
								continueCheckPolFlag1();
							}else{
								showConfirmBox("Endorsement", messageText, "Accept", "Cancel", continueCheckPolFlag1, stopProcess2);
							}						
						}else if(flag == "prorateFlag"){
							if(itemCount > 0 || perilCount > 0){
								if(itemCount > 0 && perilCount > 0){
									messageText = "This endorsement have existing item(s) and peril(s), performing cancellation will cause all the records to be replaced.";
								}else if(itemCount > 0){
									messageText = "This endorsement have existing item(s), performing cancellation will cause all the records to be replaced.";
								}							
							}
							$("processStatus").value = "checkEndtForItemAndPeril";
							if(messageText == ""){
								continueCheckProrateFlag1();
							}else{
								showConfirmBox("Endorsement", messageText, "Accept", "Cancel", continueCheckProrateFlag1 , stopProcess2);
							}
						}
					}									
				}
			});	
		}else{
			if(flag == "endtCancellation"){
				continueEndtCancellation();
			}else if(flag == "coiCancellation"){
				continueCoiCancellation();
			}
		}			
	}
	
	var fromCancellation = "";
	function createNegatedRecords(flag){
		new Ajax.Request(contextPath + "/GIPIPackParInformationController?action=createNegatedRecordsFlat", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId,
				lineCd : objUWGlobal.lineCd,
				sublineCd : objUWGlobal.sublineCd,
				issCd : objUWGlobal.issCd,
				issueYy : $F("b540IssueYY"),
				polSeqNo : $F("b540PolSeqNo"),
				renewNo : $F("b540RenewNo"),
				effDate : $F("endtEffDate"),
				coInsuranceSw : $("coIns").value,
				packPolFlag : $F("b540PackPolFlag")
			},
			aysnchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking records, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)){
					var result = response.responseText.toQueryParams();
					hideNotice("");				
					if(result.msgAlert.blank()){
						$("endtEffDate").value = !(result.effDate.blank()) ? (result.effDate).substr(0,10): $F("endtEffDate");
						$("b540EffDate").value = !(result.effDate.blank()) ? (result.effDate) : $F("b540EffDate");						
						$("parStatus").value = result.parStatus;
						$("b240ParStatus").value = result.parStatus;
						$("b540TsiAmt").value = result.tsiAmt;
						$("b540PremAmt").value = result.premAmt;
						$("b540AnnTsiAmt").value = result.annTsiAmt;
						$("b540AnnPremAmt").value = result.annPremAmt;
						$("varExpiryDate").value = result.varExpiryDate;						
						$("doi").value = !(result.inceptDate.blank()) ? (result.inceptDate).substr(0,10) : $F("doi");
						$("b540InceptDate").value = !(result.inceptDate.blank()) ? (result.inceptDate) : $F("b540InceptDate");
						$("doe").value = !(result.expiryDate.blank()) ? (result.expiryDate).substr(0,10) : $F("doe");
						$("b540ExpiryDate").value = !(result.expiryDate.blank()) ? (result.expiryDate) : $F("b540ExpiryDate");						
						$("endtExpDate").value = !(result.endtExpiryDate.blank()) ? (result.endtExpiryDate).substr(0,10) : $F("endtExpDate");
						$("b540EndtExpiryDate").value = !(result.endtExpiryDate.blank()) ? (result.endtExpiryDate) : $F("b540EndtExpiryDate");						

						$("recExistsInGipiWItem").value = result.gipiWItem;
						$("recExistsInGipiWItmperl").value = result.gipiWItmPerl;
						$("recExistsInGipiWFireItm").value = result.gipiWFireItm;
						$("recExixtsInGipiWVehicle").value = result.gipiWVehicle;
						$("recExistsInGipiWAccidentItem").value = result.gipiWAccidentItem;
						$("recExistsInGipiWAviationItem").value = result.gipiWAviationItem;
						$("recExistsInGipiWCargo").value = result.gipiWCargo;
						$("recExistsInGipiWCasualtyItem").value = result.gipiWCasualtyItem;
						$("recExistsInGipiWEnggBasic").value = result.gipiWEnggBasic;
						$("recExistsInGipiWItemVes").value = result.gipiWItemVes;
						
						$("prorateFlag").setAttribute("disabled", "disabled");
						$("compSw").setAttribute("disabled", "disabled");						
						$("hrefDoiDate").hide();
						$("hrefDoeDate").hide();
						$("hrefEndtEffDate").hide();
						$("hrefEndtExpDate").hide();
						$("b540ProrateFlag").value = "2";
						$("b540CompSw").value = "N";
						$("b540PolFlag").value = "1";
						$("prorateSw").checked = false;																		
						$("varCnclldFlatFlag").value = "Y";
						
						switch(flag){
							case "flat"	:
								$("b540CompSw").value = "";
								$("b540PolFlag").value = "4";
								$("coiCancellation").checked = false;
								$("endtCancellation").checked = false;
								$("varCnclldFlatFlag").value = "Y";
								$("b540CancelType").value = "1";
								$("clickCancelledFlat").value = "Y";
								fromCancellation = "Y";
								fireEvent($("btnSave"), "click");
								break;
							case "endt" : 
								$("nbtPolFlag").checked = false;
								$("coiCancellation").checked = false;
								$("b540CancelType").value = "3";
								showMessageBox("Endorsement successfully cancelled.", imgMessage.INFO);
								break;
							case "coi"	: 
								$("nbtPolFlag").checked = false;
								$("endtCancellation").checked = false;
								$("b540CancelType").value = "4";	
								showMessageBox("Endorsement successfully cancelled.", imgMessage.INFO);
								break;
						}			
						
						//showMessageBox("Endorsement successfully cancelled.", imgMessage.INFO);
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);						
						stopProcess2();
					}
				}									
			}
		});
	}

	function continueEndtCancellation(){
		/* preGetAmounts */		
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=preGetAmounts", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId,
				lineCd : objUWGlobal.lineCd,
				sublineCd : objUWGlobal.sublineCd,
				issCd : objUWGlobal.issCd,
				issueYy : $F("b540IssueYY"),
				polSeqNo : $F("b540PolSeqNo"),
				renewNo : $F("b540RenewNo"),
				effDate : $F("endtEffDate")
			},
			aysnchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking records, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)){
					hideNotice("");					
					if(response.responseText == 'Empty'){
						if($F("processStatus") == "revertEndtCancellation"){
							$("prorateFlag").removeAttribute("disabled");													
							$("hrefDoiDate").show();
							$("hrefDoeDate").show();
							$("hrefEndtEffDate").show();
							$("hrefEndtExpDate").show();
							$("b540ProrateFlag").value = "2";
							$("b540CompSw").value = "N";
							$("b540PolFlag").value = "1";
							$("prorateSw").checked = false;
							$("nbtPolFlag").checked = false;
							$("coiCancellation").checked = false;
							$("endtEffDate").value = "";
							$("varCnclldFlatFlag").value = "N";
							$("globalCancellationType").value = "";
							$("parCancelPolId").value = "";
							$("b540CancelType").value = "";			
						}else{
							createNegatedRecords("endt");
						}											
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);						
						stopProcess2();
					}
				}									
			}
		});
	}

	function continueCoiCancellation(){
		/* preGetAmounts */		
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=preGetAmounts", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId,
				lineCd : objUWGlobal.lineCd,
				sublineCd : objUWGlobal.sublineCd,
				issCd : objUWGlobal.issCd,
				issueYy : $F("b540IssueYY"),
				polSeqNo : $F("b540PolSeqNo"),
				renewNo : $F("b540RenewNo"),
				effDate : $F("endtEffDate")
			},
			aysnchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking records, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)){
					hideNotice("");					
					if(response.responseText == 'Empty'){
						if($F("processStatus") == "revertCoiCancellation"){
							$("prorateFlag").removeAttribute("disabled");													
							$("hrefDoiDate").show();
							$("hrefDoeDate").show();
							$("hrefEndtEffDate").show();
							$("hrefEndtExpDate").show();
							$("b540ProrateFlag").value = "2";
							$("b540CompSw").value = "N";
							$("b540PolFlag").value = "1";
							$("prorateSw").checked = false;
							$("nbtPolFlag").checked = false;
							$("endtCancellation").checked = false;
							$("endtEffDate").value = "";
							$("varCnclldFlatFlag").value = "Y";
							$("globalCancellationType").value = "";
							$("parCancelPolId").value = "";
							$("b540CancelType").value = "";			
						}else{							
							createNegatedRecords("coi");
						}											
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);						
						stopProcess2();
					}
				}									
			}
		});
	}

	function continueCheckPolFlag1(){
		/* preGetAmounts */
		new Ajax.Request(contextPath + "/GIPIPackParInformationController?action=preGetAmountsForPackEndt", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId,
				lineCd : objUWGlobal.lineCd,
				sublineCd : objUWGlobal.sublineCd,
				issCd : objUWGlobal.issCd,
				issueYy : $F("b540IssueYY"),
				polSeqNo : $F("b540PolSeqNo"),
				renewNo : $F("b540RenewNo"),
				effDate : $F("endtEffDate")
			},
			aysnchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking records, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)){
					hideNotice();					
					if(response.responseText == 'Empty'){
						if($F("processStatus") == "revertFlatCancellation"){
							$("parStatus").value = "3";
							$("b240ParStatus").value = "3";
							$("prorateFlag").removeAttribute("disabled");
							$("compSw").removeAttribute("disabled");
							$("hrefDoiDate").show();
							$("hrefDoeDate").show();
							$("hrefEndtEffDate").show();
							$("hrefEndtExpDate").show();
							$("b540ProrateFlag").value = "2";
							$("b540CompSw").value = "";
							$("b540PolFlag").value = "1";
							$("endtEffDate").value = "";
							$("varCnclldFlatFlag").value = "N";
							$("b540CancelType").value = "";
							$("clickCancelledFlat").value = "Y";
						}else{
							createNegatedRecords("flat");							
						}
					 }else{
						showMessageBox(response.responseText, imgMessage.ERROR);						
						stopProcess2(); 
					}
				}									
			}
		});
	}
	
function continueCheckProrateFlag1(){
		/* preGetAmounts */		
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=preGetAmounts", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId,
				lineCd : objUWGlobal.lineCd,
				sublineCd : objUWGlobal.sublineCd,
				issCd : objUWGlobal.issCd,
				issueYy : $F("b540IssueYY"),
				polSeqNo : $F("b540PolSeqNo"),
				renewNo : $F("b540RenewNo"),
				effDate : $F("endtEffDate")
			},
			aysnchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking records, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)){
					hideNotice();			
					if(response.responseText == 'Empty'){
						if($F("processStatus") == "revertCancellation"){
							$("prorateFlag").update(
								'<option value="1">Prorate</option>' +
								'<option value="2">Straight</option>' +
								'<option value="3">Short Rate</option>');
							$("compSw").setAttribute("disabled", "disabled");
							$("hrefDoiDate").show();
							$("hrefDoeDate").show();
							$("hrefEndtEffDate").show();
							$("hrefEndtExpDate").show();
							$("b540ProrateFlag").value = "2";
							$("b540PolFlag").value = "1";
							$("varCnclldFlag").value = "N";
							$("b540CancelType").value = "";
							$("clickCancelled").value = "Y";
						}else{
							$("prorateFlag").update(
								'<option value="1">Prorate</option>' +						
								'<option value="3">Short Rate</option>');						
							$("compSw").removeAttribute("disabled");						
							$("hrefDoiDate").hide();
							$("hrefDoeDate").hide();
							$("hrefEndtEffDate").show();
							$("hrefEndtExpDate").hide();
							$("b540PolFlag").value = "4";
							$("b540ProrateFlag").value = "1";
							$("b540CompSw").value = "N";
							$("parProrateCancelSw").value = "Y";
							$("nbtPolFlag").checked = false;						
							$("coiCancellation").checked = false;
							$("endtCancellation").checked = false;
							$("varCnclldFlag").value = "Y";
							$("b540CancelType").value = "2";
							$("clickCancelled").value = "Y";
						}
						//showMessageBox("Endorsement successfully cancelled.", imgMessage.INFO);
						fromCancellation = "Y";
						fireEvent($("btnSave"), "click");
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);						
						stopProcess2();
					}						
				}									
			}
		});
	}	

	function continueProcess2(){
		$("stopper").value = "0";

		/* mark jm 05.31.10
		** the following switch statement determines 
		** the next process to execute
		*/
		switch($F("processStatus")){
			case "checkPolicyPayment" 		: checkBooking();break;			
			case "revertFlatCancellation" 	: continueCheckPolFlag1(); break;
			case "revertCancellation"		: continueCheckProrateFlag1(); break;
			case "revertEndtCancellation"	: continueEndtCancellation(); break;
			case "revertCoiCancellation"	: continueCoiCancellation(); break;
			case "cancelButton"				: continueCancellation(); break;
			case "continueCancellation"		: continueCancellation1(); break;
		}
		//$("processStatus").value = "";
	}

	function revertTaggedCancellation() {
		changeTag = tempChangeTag;
		if (cancellationChecked == "polFlag") {
			$("nbtPolFlag").checked = true;
		} else if (cancellationChecked == "prorateSw") {
			$("prorateSw").checked = true;	
		} else {
			$("nbtPolFlag").checked = false;
			$("prorateSw").checked = false;
		}
	}

	function stopProcess2(){		
		$("stopper").value = "1";
		var flag = $("nbtPolFlag").checked ? "polFlag" : ($("prorateSw").checked ? "prorateFlag" : "");
		
		/* mark jm 05.31.10
		** the following switch statement detemines 
		** what statements to be executed before if terminates the process flow
		*/
		switch($F("processStatus")){
			case "checkPolicyPayment" 		: 
				if(flag == "polFlag"){
					$("nbtPolFlag").checked = false;
				}else if(flag == "prorateFlag"){
					$("prorateSw").checked = false;
				}
				revertTaggedCancellation();
				break;
			case "checkEndtForItemAndPeril" : 
				if(flag == "polFlag"){
					$("nbtPolFlag").checked = false;
				}else if(flag == "prorateFlag"){
					$("prorateSw").checked = false;
				}
				break;			
			case "revertFlatCancellation" 	: 
				$("prorateSw").checked = false;
				$("nbtPolFlag").checked = true;
				changeTag = tempChangeTag;
				break;
			case "revertCancellation" 		:
				$("nbtPolFlag").checked = false;
				//$("prorateSw").checked = false; replace by: Nica 11.16.2011
				$("prorateSw").checked = true;
				$("b540PolFlag").value = "4";
				changeTag = tempChangeTag;
				break;
			case "revertEndtCancellation"	: ;			
			case "revertCoiCancellation"	:
				$("nbtPolFlag").checked = true;
				$("b540PolFlag").value = "4";
				break;
		}
		cancellationChecked = "";
		$("processStatus").value = "";
	}

	function uncheckCheckbox(flag){
		if(flag == "polFlag"){
			$("prorateSw").checked = false;
			$("endtCancellation").checked = false;
			$("coiCancellation").checked = false;
		}else if(flag == "prorateFlag"){
			$("nbtPolFlag").checked = false;
			$("endtCancellation").checked = false;
			$("coiCancellation").checked = false;
		}else if(flag == "endt"){
			$("nbtPolFlag").checked = false;
			$("prorateSw").checked = false;
			$("coiCancellation").checked = false;
		}else if(flag == "coi"){
			$("nbtPolFlag").checked = false;
			$("prorateSw").checked = false;
			$("endtCancellation").checked = false;
		}
	}

	/*if ($F("isPack") == "N") {
		initializePARBasicMenu();
	} else {
		initializePackPARBasicMenu();
	}*/

	function show3OptionsConfirmBox(title, message, okLabel, cancelLabel, onOkFunc){
		Dialog.confirm("<div style='margin-top: 10px;'>"+message+"</div>", {
			title: title,
			okLabel: okLabel,
			cancelLabel: cancelLabel,
			onOk: function(){
				onOkFunc();
				return true;
			},
			onCancel: function() {
				return false;
			},
			className: "alphacube",
			width: 300,
			buttonClass: "button"
		});
	}

	function shortTermPolicy(){
		if($("genNo").checked){
			$("endtExpDate").value = $F("doe");
			$("b540EndtExpiryDate").value = $F("b540ExpiryDate");			
		}
		commitSwitchHandler();
	}

	function commitSwitchHandler(){
		switch($F("varCommitSwitch")){
			case "A"	: showWaitingMessageBox("Cannot endorse this policy.  This policy has not been distributed.", imgMessage.ERROR, stopProcess); break;
			case "B"	: showWaitingMessageBox("Cannot endorse this policy.  This policy has been cancelled.", imgMessage.ERROR, stopProcess); break;
			case "C"	: showWaitingMessageBox("Cannot endorse this policy.  This policy has been tagged for spoilage.", imgMessage.ERROR, stopProcess); break;
			case "D"	: showWaitingMessageBox("Cannot endorse this policy.  This policy has been spoiled.", imgMessage.ERROR, stopProcess); break;
			case "Y"	: showWaitingMessageBox("Policy number does not exist, cannot commit changes made.", imgMessage.ERROR, stopProcess); break;
			default 	: $("varCommitSwitch").value = "N"; continuePreValidation(); break;
		}
		//showWaitingMessageBox("PolChangedFlag: " + polChangedFlag, imgMessage.ERROR, stopProcess);	
	}

	function continuePreValidation(){
		try {
			if(!($F("address1").blank()) || !($F("address2").blank()) || !($F("address3").blank())){
				$("b240Address1").value = $F("address1");
				$("b240Address2").value = $F("address2");
				$("b240Address3").value = $F("address3");
			}
			if(!($("nbtPolFlag").checked) && !($("prorateSw").checked)){
				if($F("varPolChangedSw") != "Y"){
					var message1 = "User has altered the ";
					var message2 = "";
					var message3 = " of this PAR from '";
					var message4 = "";
					var message5 = "' to '";
					var message6 = "";
					var message7 = "'.  All information related to this PAR will be deleted. Continue anyway ?";
					if($F("doi") != $F("varOldInceptDate").substr(0,10)){
						// Inception date has been altered
						polChangedFlag = "Incept Date";
						message2 = "inception date";
						message4 = dateFormat(convertStringForDate($F("varOldInceptDate")), "mmmm d, yyyy");
						message6 = dateFormat(convertStringForDate($F("doi")), "mmmm d, yyyy");
						showConfirmBox("Endorsement", 
							message1 + message2 + message3 + message4 + message5 + message6 + message7, 
	                        "Ok", "Cancel", prorateFlagOk, prorateFlagCancel);
					}else if($F("doe") != $F("varOldExpiryDate").substr(0,10)){
						// Expiry date has been altered
						polChangedFlag = "Expiry Date";
						message2 = "expiry date";
						message4 = dateFormat(convertStringForDate($F("varOldExpiryDate")), "mmmm d, yyyy");
						message6 = dateFormat(convertStringForDate($F("doe")), "mmmm d, yyyy");
						showConfirmBox("Endorsement", 
								message1 + message2 + message3 + message4 + message5 + message6 + message7, 
	                            "Ok", "Cancel", prorateFlagOk, prorateFlagCancel);
					}else if(($F("endtEffDate") != $F("varOldEffDate").substr(0,10)) && $F("b540PolFlag") != "4"){
						// Effectivity date has been altered
						if($F("varOldEffDate").blank()){
							continuePreValidation2();
						}else{
							polChangedFlag = "Effectivity Date";
							message2 = "effectivity date";
							message4 = dateFormat(convertStringForDate($F("varOldEffDate")), "mmmm d, yyyy");
							message6 = dateFormat(convertStringForDate($F("endtEffDate")), "mmmm d, yyyy");
							showConfirmBox("Endorsement", 
									message1 + message2 + message3 + message4 + message5 + message6 + message7, 
		                            "Ok", "Cancel", prorateFlagOk, prorateFlagCancel);
						}					
					}else if($F("endtExpDate") != $F("varOldEndtExpiryDate").substr(0,10)){
						// Endorsement expiry date has been altered
						polChangedFlag = "Endorsement Expiry Date";
						message2 = "endorsement expiry date";
						message4 = dateFormat(convertStringForDate($F("varOldEndtExpiryDate")), "mmmm d, yyyy");
						message6 = dateFormat(convertStringForDate($F("endtExpDate")), "mmmm d, yyyy");
						showConfirmBox("Endorsement", 
								message1 + message2 + message3 + message4 + message5 + message6 + message7, 
	                            "Ok", "Cancel", prorateFlagOk, prorateFlagCancel);
					}else if(($F("varOldProvPremTag") != $F("b540ProvPremTag")) && $F("recExistsInGipiWItmperl") == "Y"){
						// Provisional premium tag has been altered					
						polChangedFlag = "Provisional Premium Tag";
						showConfirmBox("Endorsement", 
								"User has updated the provisional premium tag.  All information related to this PAR will be deleted. Continue anyway ?", 
	                            "Ok", "Cancel", prorateFlagOk, prorateFlagCancel);
					}else if((parseFloat($F("b540ProvPremPct").trim()) != parseFloat($F("varOldProvPremPct"))) && $F("recExistsInGipiWItmperl") == "Y"){					
						// Provisional premium percentage has been altered					
						polChangedFlag = "Provisional Premium Percentage";
						showConfirmBox("Endorsement", 
								"User has updated the provisional premium percentage from '" + $F("varOldProvPremPct") +
	                            "' to '" + $F("b540ProvPremPct") + "'.  All information related to this PAR will be deleted. Continue anyway ?", 
	                            "Ok", "Cancel", prorateFlagOk, prorateFlagCancel);
					}else if($F("varProrateSw") == "Y" && $F("recExistsInGipiWItmperl") == "Y"){
						// Prorate flag has been altered
						var newProrate = "";
						var oldProrate = "";					
	
						switch($F("b540ProrateFlag")){
							case "1"	: newProrate = "Prorate"; break;
							case "2"	: newProrate = "One-year"; break;
							case "3"	: newProrate = "Short Rate"; break;
						}
	
						switch($F("varOldProrateFlag")){
							case "1"	: oldProrate = "Prorate"; break;
							case "2"	: oldProrate = "One-year"; break;
							case "3"	: oldProrate = "Short Rate"; break;
						}
						polChangedFlag = "Prorate Flag";
						showConfirmBox("Endorsement", 
								"User has updated the prorate flag from '" + oldProrate +
	                            "' to '" + newProrate + "'.  All information related to this PAR will be deleted. Continue anyway ?", 
	                            "Ok", "Cancel", prorateFlagOk, prorateFlagCancel);
					}else if(parseFloat($F("shortRatePercent") != parseFloat($F("varOldShortRtPercent"))) && $F("recExistsInGipiWItmperl") == "Y"){
						// Short rate percentile has been altered					
						polChangedFlag = "Short Rate Percentage";					
						showConfirmBox("Endorsement", 
								"User has updated the short rate percentage from '" + $F("varOldShortRtPercent") +
	                            "' to '" + $F("shortRatePercent") + "'.  All information related to this PAR will be deleted. Continue anyway ?", 
	                            "Ok", "Cancel", prorateFlagOk, prorateFlagCancel);
					}else{
						continuePreValidation2();
					}						
				} else {
					continuePreValidation2();
				}
			}else{
				continuePreValidation2();
			}
		} catch(e){
			showErrorMessage("continuePreValidation", e);
		}				
	}

	function prorateFlagOk(){
		if(polChangedFlag == "Incept Date"){
			$("varOldInceptDate").value = $F("doi") + $F("varOldInceptDate").substr(10);
			$("parEndtTaxSw").value = "X";
			if($F("endorseTax") == "Y"){
				$("parEndtTaxSw").value = "Y";
				$("parVendt").value = "Y";
			}
		}else if(polChangedFlag == "Expiry Date"){
			$("varOldExpiryDate").value = $F("doe") + $F("varOldExpiryDate").substr(10);
			$("parEndtTaxSw").value = "X";
			if($F("endorseTax") == "Y"){
				$("parEndtTaxSw").value = "Y";
				$("parVendt").value = "Y";
			}
		}else if(polChangedFlag == "Effectivity Date"){
			$("varOldEffDate").value = $F("endtEffDate") + $F("varOldEffDate").substr(10);			
			$("parEndtTaxSw").value = "X";
			if($F("endorseTax") == "Y"){
				$("parEndtTaxSw").value = "Y";
				$("parVendt").value = "Y";
			}
		}else if(polChangedFlag == "Endorsement Expiry Date"){
			$("varOldEndtExpiryDate").value = $F("endtExpDate") + $F("varOldEndtExpiryDate").substr(10);
			$("parEndtTaxSw").value = "X";
			if($F("endorseTax") == "Y"){
				$("parEndtTaxSw").value = "Y";
				$("parVendt").value = "Y";
			}
		}else if(polChangedFlag == "Provisional Premium Tag"){
			$("varOldProvPremTag").value = $F("b540ProvPremTag");
		}else if(polChangedFlag == "Provisional Premium Percentage"){
			$("varOldProvPremPct").value = $F("b540ProvPremPct");
		}else if(polChangedFlag == "Prorate Flag"){
			//
		}else if(polChangedFlag == "Short Rate Percentage"){			
			$("varOldShortRtPercent").value = $F("shortRatePercent");
		}

		continuePreValidation2();		
	}

	function prorateFlagCancel(){
		if(polChangedFlag == "Incept Date"){
			$("doi").value = dateFormat($F("varOldInceptDate"), "mm-dd-yyyy");
			$("b540InceptDate").value = $F("varOldInceptDate") + $F("b540InceptDate").substr(10);
		}else if(polChangedFlag == "Expiry Date"){
			$("doe").value = dateFormat($F("varOldExpiryDate"), "mm-dd-yyyy");
			$("b540ExpiryDate").value = $F("varOldExpiryDate") + $F("b540ExpiryDate").substr(10);
		}else if(polChangedFlag == "Effectivity Date"){
			$("endtEffDate").value = dateFormat($F("varOldEffDate"), "mm-dd-yyyy");
			$("b540EffDate").value = $F("varOldEffDate") + $F("b540EffDate").substr(10);
		}else if(polChangedFlag == "Endorsement Expiry Date"){
			$("endtExpDate").value = dateFormat($F("varOldEndtExpiryDate"), "mm-dd-yyyy");
			$("b540EndtExpiryDate").value = $F("varOldEndtExpiryDate") + $F("b540EndtExpiryDate").substr(10);
		}else if(polChangedFlag == "Provisional Premium Tag"){
			$("b540ProvPremTag").value = $F("varOldProvPremTag");
			$("b540ProvPremPct").value = $F("varOldProvPremPct");			
		}else if(polChangedFlag == "Provisional Premium Percentage"){			
			$("b540ProvPremPct").value = $F("varOldProvPremPct");		
		}else if(polChangedFlag == "Prorate Flag"){
			$("b540ProrateFlag").value = $F("varOldProrateFlag");
		}else if(polChangedFlag == "Short Rate Percentage"){
			$("shortRatePercent").value = $F("varOldShortRtPercent");
		}
		stopProcess();
	}

	function continuePreValidation2(){
		if($F("b540SublineCd") == $F("varSublineMop")){
			$("b540RefOpenPolNo").value = $F("referencePolicyNo");
		}

		if($F("parStatus") == "10"){
			showMessageBox("Cannot save changes, par_id has been posted to a different endorsement", imgMessage.ERROR);
			stopProcess();
		}

		if($F("bookingMonth").blank() || $F("bookingMonth") == ""){
			showMessageBox("There is no value for booking date. Please enter the date.", imgMessage.INFO);
			stopProcess();
		}

		if($F("endtEffDate").blank() || $F("endtExpDate").blank()){
			showMessageBox("Cannot proceed, endorsement effectivity date / endorsement expiry_date must not be null.", imgMessage.ERROR);
			stopProcess();
		}
		
		if(!checkAllRequiredFieldsInDiv("otherDetails")){ //Added by Jerome 08.15.2016 SR 5589
			stopProcess();
		}

		if($("prorateSw").checked && $F("parProrateCancelSw") == "Y"){
			// delete_other_info
			// delete_records
			// create_negated_records_prorate
			$("parPolFlag").value = "Y";
			$("parStatus").value = "5";
			$("b240ParStatus").value = "5";
			$("nbtPolFlag").checked = false;
			$("parProrateCancelSw").value = "N";
		}

		if($("prorateSw").checked){
			$("b540PolFlag").value = "4";
			$("prorateSw").checked = true;
		}else if($("nbtPolFlag").checked){
			$("b540PolFlag").value = "4";
		}else if(!($("prorateSw").checked) && !($("nbtPolFlag").checked)){
			if($("endtCancellation").checked || $("coiCancellation").checked){
				$("b540PolFlag").value = "1";
				$("b540ProrateFlag").value = "2";
			}else{
				$("b540PolFlag").value = "1";
			}
			$("nbtPolFlag").checked = false;
		}

		// inser_parhist
		if($F("b540PolFlag") == "4"){
			$("parStatus").value = "5";
			$("b240ParStatus").value = "5";
			stopProcess();
		}

		$("parInsWinvoice").value = "N";

		if($F("parEndtTaxSw") == "Y" && $F("parVendt") == "Y"){
			$("parStatus").value = "5";
			$("b240ParStatus").value = "5";
			$("parInsWinvoice").value = "Y";
		}
		saveEndorsementBasicInfo();
	}

	function checkIfExistingInGipiWitmperl(okFunc, cancelFunc) {
		new Ajax.Request(contextPath + "/GIPIPackParInformationController?action=checkIfExistingInGipiWitmperl", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId
			},
			aysnchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if (checkErrorOnResponse(response)){
					$("processStatus").value = "cancelButton";
					if(nvl(response.responseText, "N") == "Y"){							
						existSw = "Y";
						showConfirmBox("Endorsement", "Existing item and perils for this PAR would be deleted. Do you want to continue? ", "Yes", "No", okFunc, cancelFunc);						
					}else{
						existSw = "N";
						okFunc();
					}
				}
			}			
		});
	}

	function checkIfExistingInGipiWitem(okFunc, cancelFunc) {
		new Ajax.Request(contextPath + "/GIPIPackParInformationController?action=checkIfExistingInGipiWitem", {
			method : "GET",
			parameters : {
				parId : objUWGlobal.packParId
			},
			aysnchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if (checkErrorOnResponse(response)){
					if(nvl(response.responseText, "N") == "Y"){							
						$("processStatus").value = "continueCancellation";
						showConfirmBox("Endorsement", "Existing item(s) for this PAR would be deleted. Do you want to continue? ", "Yes", "No", okFunc, cancelFunc);						
					}else{
						okFunc();
					}
				}
			}			
		});
	}

	/*function convertStringForDate(dateString){		
		var dateString = $w(dateString.replace(/-/g, " "));	
		
		return new Date(dateString[2], dateString[1], dateString[0]);
	}*/ // commented this line since the convertStringForDate function in common.js should be used - Nica 11.25.2011 

	function searchInTable(tableName, columnName, columnValue){
		var exist = false;
				
		$$("div[name='"+tableName+"']").each(function (row)    {        
	        if (row.getAttribute(columnName) == columnValue)    {
	            exist = true;
	            return exist;
	        }
	    });

	    return exist;
	}

	function getRecordCount(tableName){
		var recordCount = new Number(0);
		if(tableName == "gipiWItem"){
			recordCount = $$("div[name='endtItems']").size();
		}else if(tableName == "gipiWItmPerl"){
			recordCount = $$("div[name='endtItmPerls']").size();
		}

		return recordCount;
	}

	function getRequiredFields(){
		var requiredFields = "";
		
		$$("input[type='text']").each(function(elem){			
			if(elem.hasClassName("required")){				
				requiredFields = requiredFields + elem.getAttribute("id");
				requiredFields = requiredFields + " ";
			}				
		});

		$$("select").each(function(elem){
			if(elem.hasClassName("required")){
				if(elem.getAttribute("id") != "inputDeductible1" && elem.getAttribute("id") != "mortgageeName"){
					requiredFields = requiredFields + elem.getAttribute("id");
					requiredFields = requiredFields + " ";
				}				
			}
		});

		return requiredFields.trim();
	}

	$("b540AcctOfCdSw").value = $F("b540AcctOfCdSw").blank() ? "N" : $F("b540AcctOfCdSw"); 
	
	$("deleteSw").observe("click", function(){
		if($("deleteSw").checked){
			$("b540AcctOfCdSw").value = "Y";
		}else{
			$("b540AcctOfCdSw").value = "N";
		}
	});
	
	$("labelTag").observe("click", function(){
		if($("labelTag").checked){
			$("rowInAccountOf").innerHTML = "Leased to";
		}else{
			$("rowInAccountOf").innerHTML = "In Account Of";
		}
	});

	/*$("reloadForm").observe("click", function() {
		if($("message").innerHTML != "SUCCESS"){
			showConfirmBox("Confirmation", "Reloading this page will redirect you to endt par listing. Do you want to continue?", "Yes", "No", gotoLineListing, stopProcess);			
		}else{
			if (changeTag == 1){		
				showConfirmBox("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", 
						function(){fireEvent($("btnSave"), "click"); showEndtPackParBasicInfo;}, //saveEndorsementBasicInfo belle 09192012, 
						showEndtPackParBasicInfo);
			} else {
				showEndtPackParBasicInfo();
			}
		}		
	});*/ //replaced by: Nica 1.11.2012
	
	observeReloadForm("reloadForm", showEndtPackParBasicInfo);

	function gotoLineListing(){
		showEndtPackParListing();
	}
	
	initializeChangeTagBehavior(saveEndorsementBasicInfo);

	// temporary initialization of pack par menu
	// fix the initialization of pack basic info later, when global JSON objects are ready
	/*function initializePackPARBasicMenu(parType, lineCd) { // andrew - 09.29.2010 - added parType and lineCd parameters
		//menu related scripts
		// menus for par basic info
		parType = parType == "" || parType == null ? $F("globalParType") : parType;
		lineCd  = lineCd  == "" || lineCd  == null ? objUWGlobal.lineCd : lineCd;
		var itemInfoModuleId = getItemModuleId(parType, lineCd);
		
		observeAccessibleModule(accessType.MENU, "GIPIS017", "bondBasicInfo", showBondBasicInfo);
		observeAccessibleModule(accessType.MENU, "GIPIS017", "bondPolicyData", showBondPolicyDataPage);
		observeAccessibleModule(accessType.MENU, (parType == "E" ? "GIPIS031" : "GIPIS002"), "basicInfo", showBasicInfo);
		observeAccessibleModule(accessType.MENU, "GIPIS143", "discountSurcharge", showDiscountSurcharge);
		observeAccessibleModule(accessType.MENU, "GIPIS024", "clauses", showWPolicyWarrantyAndClausePage);
		observeAccessibleModule(accessType.MENU, itemInfoModuleId, "itemInfo", showItemInfo);
		observeAccessibleModule(accessType.MENU, "GIPIS007", "carrierInfo", showCarrierInfoPage);
		observeAccessibleModule(accessType.MENU, "GIPIS078", "cargoLimitsOfLiability", function(){showLimitsOfLiabilityPage(1);});
		observeAccessibleModule(accessType.MENU, "GIPIS172", "limitsOfLiabilities", function(){showLimitsOfLiabilityPage(0);});
		observeAccessibleModule(accessType.MENU, "GIPIS089", "bankCollection", showBankCollectionPage);
		observeAccessibleModule(accessType.MENU, "GIPIS025", "groupItemsPerBill", showBillGroupingPage); // nica 10.15.2010
		observeAccessibleModule(accessType.MENU, "GIPIS026", "enterBillPremiums", showBillPremium);
		observeAccessibleModule(accessType.MENU, "GIPIS085", "enterInvoiceCommission", showInvoiceCommissionPage);
		observeAccessibleModule(accessType.MENU, "GIPIS029", "reqDocsSubmitted", showRequiredDocsPage);
		observeAccessibleModule(accessType.MENU, "GIPIS090", "policyPrinting", showPolicyPrintingPage);
		observeAccessibleModule(accessType.MENU, "GIPIS055", "post", showPostingPar);
		//observeAccessibleModule(accessType.MENU, "GIPIS058A", "parExit", getLineListingForEndtPackagePAR);
		
		observeAccessibleModule(accessType.MENU, "GIPIS045", "additionalEngineeringInfo", showAdditionalENInfoPage);
		//observeAccessibleModule(accessType.MENU, "", "print", printPolicy);
		
		$("samplePolicy").observe("click", function(){
			showOverlayContent(contextPath+"/PrintPolicyController?action=showReportGenerator&reportType=policy&globalParId="
					+objUWGlobal.packParId+"&globalPackParId="+$F("globalPackParId"), 
					"Geniisys Report Generator", showReportGenerator, 400, 100, 100);
		});	
		
		// menus for par basic info
		$("parExit").observe("click", function () {
			try {
				Effect.Fade("parInfoDiv", {
					duration: .001,
					afterFinish: function () {
						$("parInfoMenu").hide();		
						if($F("globalParType") == "E"){
							getLineListingForEndtPackagePAR();
						}else{							
							getLineListingForPackagePAR();
						}
						$("packParListingMainDiv").show();
					}
				});
			} catch (e) {
				showErrorMessage("endtBasicInformationMain.jsp - parExit", e);
			}
			//clearObjectValues(objUWParList);
		});
		
		//$("parListingExit").observe("click", function () {	//commented muna.. js error: "$("parListingExit") is null" - andrew
			//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		//});
	}*/	
	
	/**
	 * Checks if endt pack line/subline coverages exist before proceeding to endt pack basic info
	 * @author andrew robes
	 * @date 09.08.2011
	 */
	function checkEndtPackLineSubline(){
		try {
			if((objUWGlobal.parStatus > 2 && objGIPIWPackLineSubline != null && objGIPIWPackLineSubline.length == 0) || (objUWGlobal.parStatus == 2 && checkLineSubline == 0)){
				showWaitingMessageBox("Please enter line/subline coverages first.", imgMessage.INFO, 
					function(){			
						objTempUWGlobal = new Object();
						objTempUWGlobal.packParId = objUWGlobal.packParId;
						objTempUWGlobal.lineCd = objUWGlobal.lineCd;
						objTempUWGlobal.sublineCd = $F("b540SublineCd");
						objTempUWGlobal.issCd = $F("b540IssCd");
						objTempUWGlobal.issueYy = $F("b540IssueYY");
						objTempUWGlobal.polSeqNo = $F("b540PolSeqNo");
						objTempUWGlobal.renewNo = $F("b540RenewNo");
						objTempUWGlobal.parType = "E";
						objTempUWGlobal.assdNo = $F("assdNo");
						objTempUWGlobal.assdName = $F("assuredName");
						objTempUWGlobal.acctOfCd = $F("b540AcctOfCd");
						objTempUWGlobal.acctOfName = $F("inAccountOf");
						
						showEndtLineSublineCoverages();
					});		
			}
		} catch(e){
			showErrorMessage("checkEndtPackLineSubline", e);
		}
	}	
	
	checkEndtPackLineSubline(); // andrew 09.07.2011
	
	// mark jm 11.02.2011 for package endt
	if($F("b540PackPolFlag").empty() || nvl($F("b540PackPolFlag"), "") == ""){
		$("b540PackPolFlag").value = objUWGlobal.packPolFlag;		
		$("packagePolicy").checked = objUWGlobal.packPolFlag == "Y" ? true : false;		
	}
	
	// andrew - 11.04.2011 
	$("parExit").stopObserving("click");
	$("parExit").observe("click", doParExit);
	
	objUW.saveEndorsementBasicInfo = saveEndorsementBasicInfo;
	
	function checkNewPackRenewals(){   //nante 12.6.2013
		new Ajax.Request(contextPath + "/GIPIPackWPolnrepController?action=checkPackPolnrep", {
			method : "POST",
			parameters : {
				packParId 	  	  : objUWGlobal.packParId,
				lineCd 	  		  : lineCd,
				sublineCd 		  : sublineCd,
				wpolnrepIssCd 	  : issCd,
				wpolnrepIssueYy   : issueYy,
				wpolnrepPolSeqNo  : polSeqNo,
				wpolnrepRenewNo   : renewNo,
				polFlag           :	$F("b540PackPolFlag")
			},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					var messageArr = res.message.split("@@");
					if (messageArr[0] == "0"||messageArr[0] == "1") {
						renewExist = "Y";
						$("nbtPolFlag").checked = false;
					}
				}
			}
		});
	}
	
	// bonok :: 05.19.2014 :: set label tag
	if($F("b540LabelTag") == "Y"){
		$("rowInAccountOf").innerHTML = "Leased to";
		$("labelTag").checked = true;
	}else{
		$("rowInAccountOf").innerHTML = "In Account Of";
		$("labelTag").checked = false;
	}
</script>
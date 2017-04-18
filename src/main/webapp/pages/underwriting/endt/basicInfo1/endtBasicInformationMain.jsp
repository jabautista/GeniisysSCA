<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<script type="text/javascript">
	objUW.hidObjGIPIS002 = {};
	objUW.hidObjGIPIS002.reqCredBranch 	= ('${reqCredBranch}');
	objUW.hidObjGIPIS002.defCredBranch 	= ('${defCredBranch}');
	objUW.hidObjGIPIS002.reqRefPolNo 	= ('${reqRefPolNo}');
	objUW.hidObjGIPIS002.reqRefNo = ('${reqRefNo}'); //added by gab 10.06.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
	objUW.hidObjGIPIS002.dispDefaultCredBranch = ('${dispDefaultCredBranch}'); // Kris 07.04.2013 for UW-SPECS-2013-091
	objUW.hidObjGIPIS002.defaultCredBranch = ('${defaultCredBranch}'); // Kris 07.04.2013 for UW-SPECS-2013-091
	
	objUW.GIPIS031 = {};
	
	objUW.GIPIS031.gipiParList = JSON.parse('${gipiParListJSON}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
	objUW.GIPIS031.gipiWPolbas = JSON.parse('${gipiWPolbasJSON}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
	objUW.GIPIS031.gipiWPolGenin = JSON.parse('${gipiWPolGeninJSON}');
	
	objUW.GIPIS031.gipiWEndtText = JSON.parse('${gipiWEndtTextJSON}');
	
	objUW.GIPIS031.variables = JSON.parse('${vars}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
	objUW.GIPIS031.parameters = JSON.parse('${params}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
	objUW.GIPIS031.parameters.paramEndtTaxSw = nvl(objUW.GIPIS031.gipiWEndtText.endtTax, "X"); // added by: Nica 05.07.2012
	objUW.GIPIS031.parameters.assuredChange = "N"; // robert
	//
	objUW.GIPIS031.gipiWItem = JSON.parse('${gipiWItem}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
	objUW.GIPIS031.gipiWItmperl = JSON.parse('${gipiWItmperl}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
	objUW.hidObjGIPIS002.updateBooking = ('${updateBooking}');
	
	if (objUW.GIPIS031.parameters.paramOra2010Sw == "Y") {
		objUW.hidObjGIPIS002.companyLOV = JSON.parse('${companyListingJSON}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
		objUW.hidObjGIPIS002.employeeLOV = JSON.parse('${employeeListingJSON}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
		objUW.hidObjGIPIS002.bancTypeCdLOV = JSON.parse('${bancTypeCdListingJSON}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
		objUW.hidObjGIPIS002.bancAreaCdLOV = JSON.parse('${bancAreaCdListingJSON}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
		objUW.hidObjGIPIS002.bancBranchCdLOV = JSON.parse('${bancBranchCdListingJSON}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
		objUW.hidObjGIPIS002.managerCd = ('${gipiWPolbas.managerCd}');		
		objUW.hidObjGIPIS002.planCdLOV = JSON.parse('${planCdListingJSON}'); //removed .replace(/\\/g, '\\\\'); John Daniel SR-4745,4746,4665
	}
	
	objUWGlobal.cancelTag  = "N"; // robert 10.09.2012 
	
	objItemTempStorage = {};
	objMortgagees = [];
	objDeductibles = [];
</script>

<div id="endtBasicInformationDiv" style=" margin-top: 1px;">
	<div id="message" style="display : none;">${message}</div>
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
		<input type="hidden" id="b540CancelledEndtId"	name="b540CancelledEndtId"				value="" /> <!-- robert 9.21.2012 -->
		
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
		
		<jsp:include page="./subPages/endtBasicInformation.jsp"></jsp:include>
		<jsp:include page="./subPages/poi.jsp"></jsp:include>
		
		<div id="renewalDetail" style="display: none;">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Renewal / Replacement Detail</label> 
					<span class="refreshers" style="margin-top: 0;">
						<label id="showRenewal" name="gro" style="margin-left: 5px;">Show</label>
					</span>
				</div>
			</div>
			<div id="policyRenewalDiv" align="center" class="sectionDiv" style="display: none;">
			</div>
		</div>
		
		<div id="openPolicy"></div>
		
		<div id="marineDetails">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv"><label>Marine Details</label>
					<span class="refreshers" style="margin-top: 0;"> <label
						id="showMarineDetails" name="gro" style="margin-left: 5px;">Show</label>
					</span>
				</div>
			</div>
			<div id="marineDetailsInfo" class="sectionDiv" style="display: none;">
				<div id="marineDetailsSecDiv" style="margin: 10px auto;">
					<table width="100%" border="0">
						<tr>
							<td class="rightAligned" width="30%">Survey Agent</td> <!-- Dren Niebres 06.07.2016 SR-22243 - Start -->
							<%-- <td class="leftAligned">
								<select id=""	name="surveyAgentCd" style="width: 450px;">
									<option value=""></option>
									<c:forEach var="surveyAgent" items="${surveyAgentListing}">
										<option value="${surveyAgent.payeeNo}" <c:if test="${surveyAgent.payeeNo eq gipiWPolbas.surveyAgentCd}">
											selected="selected"
										</c:if>>${surveyAgent.nbtPayeeName}</option>										
									</c:forEach>
								</select> --%>
							<td class="leftAligned">
								<div id="surveyAgentDiv" style="width: 448px;" class="withIconDiv">							
									<input type="hidden" id="surveyAgentCd" name="surveyAgentCd" type="text" readonly="readonly" value="${gipiWPolbas.surveyAgentCd}" />
									<input style="width: 420px;" id="surveyAgentName" name="surveyAgentName" type="text" readonly="readonly" class="withIcon" value="${gipiWPolbas.surveyAgentName}"/>
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSurveyAgent" name="searchSurveyAgent" alt="Go" />
								</div>
							</td>								
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Settling Agent</td>
							<%-- <td class="leftAligned">
								<select id="settlingAgentCd" name="settlingAgentCd" style="width: 450px;">
								<option value=""></option>
								<c:forEach var="settlingAgent" items="${settlingAgentListing}">
									<option value="${settlingAgent.payeeNo}" <c:if test="${settlingAgent.payeeNo eq gipiWPolbas.settlingAgentCd}">
											selected="selected"
										</c:if>>${settlingAgent.nbtPayeeName}</option>
								</c:forEach>
							</select>
							</td> --%>
							<td class="leftAligned">
								<div id="settlingAgentDiv" style="width: 448px;" class="withIconDiv">							
									<input type="hidden" id="settlingAgentCd" name="settlingAgentCd" type="text" readonly="readonly" value="${gipiWPolbas.settlingAgentCd}"/>
									<input style="width: 420px;" id="settlingAgentName" name="settlingAgentName" type="text" readonly="readonly" class="withIcon" value="${gipiWPolbas.settlingAgentName}"/>
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSettlingAgent" name="searchSettlingAgent" alt="Go" />
								</div>
							</td> <!-- Dren Niebres 06.07.2016 SR-22243 - End -->				
						</tr>
					</table>
				</div>
			</div>
		</div>		
		
		<c:if test="${ora2010Sw eq 'Y'}">
			<jsp:include page="../../subPages/bankPaymentDetails.jsp"></jsp:include>
			<jsp:include page="../../subPages/bancaDtls.jsp"></jsp:include>
		</c:if>				
		
		<div id="mortgageePopups">
			<input type="hidden" id="mortgageeLevel" name="mortgageeLevel" value="0" />
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Mortgagee Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showMortgagee" name="groItem" tableGrid="tbgMortgagee" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>	
			<div id="mortgageeInfo" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/common/mortgagee/mortgageeInfo.jsp"></jsp:include>
			</div>						
		</div>
		<div id="deductibleDetail1">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Policy Deductible</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDeductible1" name="groItem" tableGrid="tbgPolicyDeductible" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>			
			<div id="deductibleDiv1" class="sectionDiv" style="display: none;">
				<jsp:include page="/pages/underwriting/common/deductibles/policy/policyDeductibles.jsp"></jsp:include>
			</div>			 		
			<input type="hidden" id="dedLevel" name="dedLevel" value="1" />
		</div>
		<jsp:include page="../../subPages/otherDetails.jsp"></jsp:include>		
	</form>
	
	<div id="endtBasicInfoDiv" name="endtBasicInfoDiv" style="display: none;"></div>
	<form id="endtBasicInfoFormButton" name="endtBasicInfoFormButton">
		<div class="buttonsDiv" style="float: left; width: 100%;">
			<table align="center">
				<tr>
					<td><input type="button" class="button noChangeTagAttr" id="btnInspection"
						name="btnInspection" value="Select Inspection" style="display: none;"/></td>
					<td><input type="button" class="button" id="btnCancel"
						name="btnCancel" value="Cancel" style="width: 60px;" /></td>
					<td><input type="button" class="button" id="btnSave"
						name="btnSave" value="Save" style="width: 60px;" /></td>
				</tr>
			</table>
		</div>
	</form>	
</div>

<script type="text/javascript">
try{	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();	
	setModuleId("GIPIS031");
	setDocumentTitle("Endt. Basic Information");
	
	$("chkDeleteSw").hidden = false; //kenneth SR 5483 05.26.2016
	$("lblDeleteSw").hidden = false; //kenneth SR 5483 05.26.2016
	
	$("manualRenewNo").disable();
	$("packagePolicy").disable();
	$("rowSublineCd").hide();
	
	//if($F("b540LineCd") != $F("varLcMc")){
	//	$("fleetTag").disable();
	//}
	
	if(getLineCd($F("b540LineCd")) != "MC"){ // Nica 06.07.2012
		$("fleetTag").disable();
	}
	
	$("showRenewal").observe("click", function() {
		if ($("wpolnrepOldPolicyId") == null) {
			openRenewalReplacementDetailModal();
		}
	});
	
	$("showDeductible1").observe("click", function() {
		if ($("inputDeductible1") == null){			
			retrieveDeductibles(objUWParList.parId, 0, 1);
		}
	});
	
	observeAccessibleModule(accessType.SUBPAGE, "GIPIS168", "showMortgagee",
		function() {
			if ($F("mortgageeLevel") == 0){					
				retrieveMortgagee(objUWParList.parId, 0);
			}
	});	
	initializeItemAccordion();
	
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
	}	
	
	// initialization
	if(objUW.GIPIS031.parameters.paramShowMarineDtlBtn != "Y"){
		$("marineDetails").hide();	
	}
	
	if(getLineCd() == "MN" && objUW.GIPIS031.parameters.paramReqSurveySettAgent == "Y"){
		$("surveyAgentCd").addClassName("required");
		$("settlingAgentCd").addClassName("required");
	}
	
	if(objUW.GIPIS031.parameters.paramOpenPolicySw == "Y"){		
		new Ajax.Updater("openPolicy", contextPath	+ "/GIPIWOpenPolicyController?action=showOpenPolicyDetails",{
			method : "POST",
			parameters : {
				ajax : 1,
				globalParId : objUW.GIPIS031.gipiParList.parId,
				globalAssdNo : objUW.GIPIS031.gipiParList.assdNo,
				doi : $F("doi"),
				doe : $F("doe"),
				lineCd : getLineCd()
			},
			evalScripts : true,
			onComplete : function() {				
				$("refOpenPolicyNo").selectedIndex = 1; 
				
				$("opLineCd").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("lineCd");
				$("opSublineCd").value	= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("sublineCd");
				$("opIssCd").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("issCd");
				$("opIssYear").value	= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("issueYy");
				$("opPolSeqNo").value	= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("polSeqNo");
				$("opRenewNo").value	= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("renewNo");
				
				// set padded fields
				$("opIssYear").value = $F("opIssYear") == "" ? "" : parseFloat($F("opIssYear")).toPaddedString(2);
				$("opPolSeqNo").value = $F("opPolSeqNo") == "" ? "" : parseFloat($F("opPolSeqNo")).toPaddedString(7);
				
				// disabled fields
				$("refOpenPolicyNo").selectedIndex = 0;
				$("refOpenPolicyNo").disabled = true;				
				$("opSublineCd").readOnly = true;
				
				// remove calss required
				$("opSublineCd").removeClassName("required");
				$("opIssCd").removeClassName("required");
				$("opIssYear").removeClassName("required");
				$("opPolSeqNo").removeClassName("required");
				$("opRenewNo").removeClassName("required");				
			}
		});			
	}
	
	//robert
	//$("region").value = objUW.GIPIS031.parameters.paramRegionCd;
	
	// save
	function parseOtherDetails(){
		try{
			objUW.GIPIS031.gipiWPolGenin.parId		= objUW.GIPIS031.gipiParList.parId;
			objUW.GIPIS031.gipiWPolGenin.genInfo 	= escapeHTML2($F("generalInformation"));
			objUW.GIPIS031.gipiWEndtText.parId		= objUW.GIPIS031.gipiParList.parId;
			objUW.GIPIS031.gipiWEndtText.endtText	= escapeHTML2($F("endtInformation"));
			objUW.GIPIS031.gipiWEndtText.endtTax	= $("endorseTax").checked ? "Y" : null;
			objUW.GIPIS031.gipiWEndtText.endtCd     = objUW.hidObjGIPIS002.endtCd; //added by robert 04.24.2014 SR 15617
			objUW.GIPIS031.gipiParList.assdNo = $F("assuredNo") != "" ? $F("assuredNo") : objUW.GIPIS031.gipiParList.assdNo; // robert
			
			for(var index=1; index <=17; index++){
				objUW.GIPIS031.gipiWPolGenin["genInfo"+ index.toPaddedString(2)] = escapeHTML2($F("generalInformation").substr((index-1)*2000, 2000));
				objUW.GIPIS031.gipiWEndtText["endtText"+ index.toPaddedString(2)] = escapeHTML2($F("endtInformation").substr((index-1)*2000, 2000));						
			}
		}catch(e){
			showErrorMessage("parseOtherDetails", e);
		}		
	}
	
	function saveEndtBasic(){
		try{
			var objParams = new Object();
			
			parseOtherDetails();
			objParams.gipiParList 	= objUW.GIPIS031.gipiParList;
			objParams.gipiWPolbas	= setEndtBasicObj();	
			objParams.gipiWEndtText	= objUW.GIPIS031.gipiWEndtText;			
			objParams.gipiWPolGenin	= objUW.GIPIS031.gipiWPolGenin;			
			objParams.variables 	= prepareJsonAsParameter(objUW.GIPIS031.variables);			
			objParams.parameters	= prepareJsonAsParameter(objUW.GIPIS031.parameters);
			objParams.setMortgagees 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objMortgagees));
			objParams.delMortgagees 	= prepareJsonAsParameter(getDeletedJSONObjects(objMortgagees));
			objParams.setDeductibles 	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objDeductibles));
			objParams.delDeductibles	= prepareJsonAsParameter(getDeletedJSONObjects(objDeductibles));
			
			if(!checkAllRequiredFieldsInDiv("otherDetails")){ //Added by Jerome 08.10.2016 SR 5589
				return false;
			} else {
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=saveEndtBasic01", {
				method : "POST",
				parameters : {
					parId : objUW.GIPIS031.gipiParList.parId,
					parameters : JSON.stringify(objParams)
				},
				evalScripts : true,
				asynchronous : true,
				onCreate : function(){
					showNotice("Saving Endt Basic Information, please wait ...");
				},
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText != "SUCCESS"){
							showMessageBox(response.responseText, imgMessage.ERROR);
						}else{
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								changeTag = 0;
								showBasicInfo();
							});							
						}
					}
				}
			});
		}
		}catch(e){
			showErrorMessage("saveEndtBasic", e);
		}
	}
	
	function gipis031PreCommit01(){
		try{
			function preCommit(){		
				new Ajax.Request(contextPath + "/GIPIPARListController?action=getGIPIPARDetails",{
					method : "POST",
					parameters : {
						parId : objUW.GIPIS031.gipiParList.parId
					},
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							var obj = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
							
							if(obj.parStatus == 10){
								showMessageBox("Cannot save changes, par_id has been posted to a different endorsement", imgMessage.ERROR);
								return false;
							}else{
								if($F("bookingMth").empty() || $F("bookingYear").empty()){
									showMessageBox("There is no value for booking date. Please enter the date.", imgMessage.ERROR);
									return false;
								}else if($F("endtEffDate").empty() || $F("endtExpDate").empty()){
									showMessageBox("Cannot proceed, endorsement effectivity date / endorsement expiry_date must not be null.", imgMessage.ERROR);
									return false;
								}else{
									if($("prorateSw").checked && objUW.GIPIS031.parameters.paramProrateCancelSw == "Y"){
										objUW.GIPIS031.parameters.paramDeleteOtherInfo = "Y"; // execute corresponding procedure upon saving in java
										objUW.GIPIS031.parameters.paramDeleteRecords = "Y"; // execute corresponding procedure upon saving in java
										objUW.GIPIS031.parameters.paramCreateNegatedRecordsProrate = "Y"; // execute corresponding procedure upon saving in java
										objUW.GIPIS031.parameters.paramPolFlag = "Y";
										objUW.GIPIS031.gipiParList.parStatus = 5;
										$("nbtPolFlag").checked = false;
										objUW.GIPIS031.parameters.paramProrateCancelSw = "N";
									}
									
									if($("prorateSw").checked){
										$("nbtPolFlag").checked = false;
										$("endtCancellation").checked = false;
										$("coiCancellation").checked = false;
									}else if($("nbtPolFlag").checked){
										$("prorateSw").checked = false;
										$("endtCancellation").checked = false;
										$("coiCancellation").checked = false;
									}else{									
										if($("endtCancellation").checked || $("coiCancellation").checked){
											objUW.GIPIS031.gipiWPolbas.polFlag = 1;
											objUW.GIPIS031.gipiWPolbas.prorateFlag = 2;
										}else{
											objUW.GIPIS031.gipiWPolbas.polFlag = 1;
										}
										
										$("nbtPolFlag").checked = false;
										$("prorateSw").checked = false;
									}
									
									objUW.GIPIS031.parameters.paramInsertParHist = "Y"; // execute corresponding procedure upon saving in java
									
									// update_par_status procedure
									if(objUW.GIPIS031.gipiWPolbas.polFlag == "4"){
										objUW.GIPIS031.gipiParList.parStatus = 5;
									}
									
									objUW.GIPIS031.parameters.paramInsWinvoice = "N";
									
									if(objUW.GIPIS031.parameters.paramEndtTaxSw == "Y" && objUW.GIPIS031.parameters.paramVEndt == "Y"){
										objUW.GIPIS031.gipiParList.parStatus = 5;
										objUW.GIPIS031.parameters.paramInsWinvoice = "Y";									
									}else if(objUW.GIPIS031.parameters.paramEndtTaxSw == "N"){
										// meron pa dito
									}
									gipis031KeyCommit();
								}
							}
						}
					}
				});
			}
			
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=validatePolNo", {
				method : "POST",
				parameters : {
					parId : objUW.GIPIS031.gipiParList.parId,
					parameters : JSON.stringify(setEndtBasicObj())
				},
				evalScripts : true,
				asynchronous : false,
				onCreate : function(){
					showNotice("Loading, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "Y"){
							preCommit();
						} else {
							showMessageBox(response.responseText, "I");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("gipis031PreCommit01", e);
		}
	}
	
	function validateBeforeCommit(){
		try{
			function validateBeforeCommit01(){
				try{
					var commitSwitch = objUW.GIPIS031.variables.varVCommitSwitch;

					//$("endtExpDate").value = $F("doe"); Removed by Jomar Diago 01072013
					
					//::added by Sam 05.08.2014, blank address2 and address3 will be updated.
					if($F("address2").empty()){
						objUW.GIPIS031.gipiWPolbas.address2 = null;
					}
					if($F("address3").empty()){
						objUW.GIPIS031.gipiWPolbas.address3 = null; 
					}
 					if($F("surveyAgentName").empty()){ //Dren Niebres 06.07.2016 SR-22243 - Start
						objUW.GIPIS031.gipiWPolbas.surveyAgentCd = null;
						$("surveyAgentCd").value = null; 
					} 
 					if($F("settlingAgentName").empty()){
						objUW.GIPIS031.gipiWPolbas.settlingAgentCd = null;
						$("settlingAgentCd").value = null;
					} //Dren Niebres 06.07.2016 SR-22243 - End
					
					if($R("A", "D").include(commitSwitch) || commitSwitch == "Y"){
						var message = "";
						
						switch(commitSwitch){
							case "A" : message = "Cannot endorse this policy.  This policy has not been distributed."; break;
							case "B" : message = "Cannot endorse this policy.  This policy has been cancelled."; break;
							case "C" : message = "Cannot endorse this policy.  This policy has been tagged for spoilage."; break;
							case "D" : message = "Cannot endorse this policy.  This policy has been spoiled."; break;
							case "Y" : message = "Policy number does not exist, cannot commit changes made."; break;					
						}
						
						showMessageBox(message, imgMessage.INFO);
					}else{
						objUW.GIPIS031.variables.varVCommitSwitch = "N";

						if(!($F("address1").empty()) || !($F("address2").empty()) || !($F("address3").empty())){
							objUW.GIPIS031.gipiParList.address1 = unescapeHTML2($F("address1"));//changeSingleAndDoubleQuotes2($F("address1")); belle 09272012
							objUW.GIPIS031.gipiParList.address2 = unescapeHTML2($F("address2"));//changeSingleAndDoubleQuotes2($F("address2"));
							objUW.GIPIS031.gipiParList.address3 = unescapeHTML2($F("address3"));//changeSingleAndDoubleQuotes2($F("address3"));
							
							
						}
						if(!($("nbtPolFlag").checked) && !($("prorateSw").checked)){
							if(objUW.GIPIS031.variables.varPolChangedSw != "Y"){
								function replaceText(message, condition, fromDate, toDate){
									try{		
										message = message.replace(/condition/g, condition); //change by steven 9/25/2012 from: "inception date"	to: condition
										message = message.replace(/fromDate/g, dateFormat(fromDate, "mmmm dd, yyyy"));
										message = message.replace(/toDate/g, dateFormat(toDate, "mmmm dd, yyyy"));
										
										return message;
									}catch(e){
										showErrorMessage("replaceText", e);
									}
								}
								
								function updateFormParameters(){
									try{
										objUW.GIPIS031.parameters.paramEndtTaxSw = "X";
										if($("endorseTax").checked){
											objUW.GIPIS031.parameters.paramEndtTaxSw = "Y";
											objUW.GIPIS031.parameters.paramVEndt = "Y";
										}
									}catch(e){
										showErrorMessage("updateFormParameters", e);
									}
								}
								
								var message = "User has altered the condition of this PAR from 'fromDate' to 'toDate'. " +
												"All information related to this PAR will be deleted. Continue anyway?";
								var oldInceptDate = nvl(objUW.GIPIS031.variables.varOldInceptDate, $F("doi"));
								var oldExpiryDate = nvl(objUW.GIPIS031.variables.varOldExpiryDate, $F("doe"));
								var oldEffDate = nvl(objUW.GIPIS031.variables.varOldEffDate, $F("endtEffDate"));

								//var oldEndtExpDate = nvl(objUW.GIPIS031.variables.varOldEndtExpiryDate, $F("endtExpDate")); // Removed by Jomar Diago 01072012							
								var oldEndtExpDate = nvl(objUW.GIPIS031.variables.varOldEndtExpiryDate, objUW.GIPIS031.gipiWPolbas.formattedEndtExpDate); // Added by Jomar Diago 01072012

								//--*** Inception date has been altered ***--								
								if($F("doi") != oldInceptDate){	
									showConfirmBox("Date Change", replaceText(message, "inception date", 
											dateFormat(oldInceptDate, "mmmm dd, yyyy"), dateFormat($F("doi"), "mmmm dd, yyyy")),
											"Ok", "Cancel",
										function(){
											// check item dates procedure
											objUW.GIPIS031.variables.varOldInceptDate = $F("doi");
											updateFormParameters();
											gipis031PreCommit(); //added by steven 9/25/2012
										},
										function(){
											$("doi").value = dateFormat(oldInceptDate, "mm-dd-yyyy");
										});								
								//--*** Expiry date has been altered ***-- 
								}else if($F("doe") != oldExpiryDate){
									showConfirmBox("Date Change", replaceText(message, "expiry date", 
											dateFormat(oldExpiryDate, "mmmm dd, yyyy"), dateFormat($F("doe"), "mmmm dd, yyyy")),
											"Ok", "Cancel",
										function(){
											// check item dates procedure
											objUW.GIPIS031.variables.varOldExpiryDate = $F("doe");
											updateFormParameters();
											gipis031PreCommit(); //added by steven 9/25/2012
										},
										function(){
											$("doe").value = dateFormat(oldExpiryDate, "mm-dd-yyyy");
										});								
								//--*** Effectivity date has been altered ***-- 
								}else if(($F("endtEffDate") != oldEffDate) && objUW.GIPIS031.gipiWPolbas.polFlag != "4"){
									showConfirmBox("Date Change", replaceText(message, "effectivity date", 
											dateFormat(oldEffDate, "mmmm dd, yyyy"), dateFormat($F("endtEffDate"), "mmmm dd, yyyy")),
											"Ok", "Cancel",
										function(){										
											objUW.GIPIS031.variables.varOldEffDate = $F("endtEffDate");
											objUW.GIPIS031.parameters.paramDeleteAllTables = "Y"; // delete all tables (include get amounts)
											updateFormParameters();
											gipis031PreCommit(); //added by steven 9/25/2012
										},
										function(){
											$("endtEffDate").value = dateFormat(oldEffDate, "mm-dd-yyyy");
										});								
								//--*** Endorsement expiry date has been altered ***--
								// andrew - 2.12.2013 - added validation for null value to avoid infinite confirmation message
								}else if(objUW.GIPIS031.variables.varOldEndtExpiryDate != null && $F("endtExpDate") != oldEndtExpDate){
									showConfirmBox("Date Change", replaceText(message, "endorsement expiry date", 
											dateFormat(oldEndtExpDate, "mmmm dd, yyyy"), dateFormat($F("endtExpDate"), "mmmm dd, yyyy")),
											"Ok", "Cancel",
										function(){										
											objUW.GIPIS031.variables.varOldEndtExpiryDate = $F("endtExpDate");
											objUW.GIPIS031.parameters.paramDeleteAllTables = "Y"; // delete all tables (include get amounts)
											updateFormParameters();
											gipis031PreCommit(); //added by steven 9/25/2012
										},
										function(){
											$("endtExpDate").value = dateFormat(oldEndtExpDate, "mm-dd-yyyy");
										});
								//--*** Provisional premium tag has been altered ***--								
								//}else if((objUW.GIPIS031.variables.varOldProvPremTag != ($("provisionalPremium").checked ? "Y" : "N")) && objUW.GIPIS031.gipiWItmperl.length > 0){
								// andrew - 05.14.2012 - added validation for null value
								}else if(objUW.GIPIS031.variables.varOldProvPremTag != null && (objUW.GIPIS031.variables.varOldProvPremTag != ($("provisionalPremium").checked ? "Y" : "N")) && objUW.GIPIS031.gipiWItmperl.length > 0){
									showConfirmBox("Provisional Premium", "User has updated the provisional premium tag.  All information related to this PAR will be deleted. Continue anyway ?",
											"Ok", "Cancel",
										function(){										
											objUW.GIPIS031.variables.varOldProvPremTag = $("provisionalPremium").checked ? "Y" : "N";
											objUW.GIPIS031.parameters.paramDeleteBill = "Y"; // delete bill (include get amounts)										
										},
										function(){
											$("provisionalPremium").checked = objUW.GIPIS031.variables.varOldProvPremTag == "Y" ? true : false;
											$("provPremRatePercent").value = objUW.GIPIS031.variables.varOldProvPremPct;
										});
								//--*** Provisional premium percentage has been altered ***--
								//}else if(($F("provPremRatePercent") != objUW.GIPIS031.variables.varOldProvPremPct) && objUW.GIPIS031.gipiWItmperl.length > 0){
								// andrew - 05.14.2012 - added validation for null value	
								}else if(objUW.GIPIS031.variables.varOldProvPremPct != null && ($F("provPremRatePercent") != objUW.GIPIS031.variables.varOldProvPremPct) && objUW.GIPIS031.gipiWItmperl.length > 0){
									showConfirmBox("Provisional Premium", "User has updated the provisional premium percentage from '" + objUW.GIPIS031.variables.varOldProvPremPct + "' to '" +
											$F("provPremRatePercent") + "'. All information related to this PAR will be deleted. Continue anyway ?",
											"Ok", "Cancel",
										function(){										
											objUW.GIPIS031.variables.varOldProvPremPct = $F("provPremRatePercent");
											objUW.GIPIS031.parameters.paramDeleteBill = "Y"; // delete bill (include get amounts)										
										},
										function(){										
											$("provPremRatePercent").value = objUW.GIPIS031.variables.varOldProvPremPct;
										});
								//--*** Prorate flag has been altered ***--
								}else if(objUW.GIPIS031.variables.varProrateSw == "Y" && objUW.GIPIS031.gipiWItmperl.length > 0){									
									var newProrate = "";
									var oldProrate = "";
									
									switch($F("prorateFlag")){
										case "1" : newProrate = "Prorate"; break;
										case "2" : newProrate = "One-Year"; break;
										case "3" : newProrate = "Short Rate"; break;
									}
									
									switch(objUW.GIPIS031.variables.varOldProrateFlag){
										case "1" : oldProrate = "Prorate"; break;
										case "2" : oldProrate = "One-Year"; break;
										case "3" : oldProrate = "Short Rate"; break;
									}
									
									showConfirmBox("Provisional Premium", "User has updated the prorate flag from  '" + oldProrate + "' to '" +
											newProrate + "'. All information related to this PAR will be deleted. Continue anyway ?",
											"Ok", "Cancel",
										function(){										
											objUW.GIPIS031.parameters.paramDeleteBill = "Y"; // delete bill (include get amounts)										
										},
										function(){	
											$("prorateFlag").value = objUW.GIPIS031.variables.varOldProrateFlag;
											$("shortRatePercent").value = objUW.GIPIS031.variables.varOldShortRtPercent;
										});
								//--*** Short rate percentile has been altered ***--
								//}else if(objUW.GIPIS031.variables.varOldProvPremPct != null && $F("shortRatePercent") != objUW.GIPIS031.variables.varOldShortRtPercent && objUW.GIPIS031.gipiWItmperl.length > 0){
								// andrew - 05.14.2012 - added validation for null value
								}else if(objUW.GIPIS031.variables.varOldProvPremPct != null && $F("shortRatePercent") != objUW.GIPIS031.variables.varOldShortRtPercent && objUW.GIPIS031.gipiWItmperl.length > 0){
									showConfirmBox("Short Rate Percent", "User has updated the short rate percentage from '" + objUW.GIPIS031.variables.varOldShortRtPercent + "' to '" +
											$F("shortRatePercent") + "'. All information related to this PAR will be deleted. Continue anyway ?",
											"Ok", "Cancel",
										function(){
											objUW.GIPIS031.variables.varOldShortRtPercent = $F("shortRatePercent");
											objUW.GIPIS031.parameters.paramDeleteBill = "Y"; // delete bill (include get amounts)										
										},
										function(){											
											$("shortRatePercent").value = objUW.GIPIS031.variables.varOldShortRtPercent;
										});									
								}else{
									gipis031PreCommit01();
								}
							}else{
								gipis031PreCommit01();
							}
						}else{
							gipis031PreCommit01();
						}
					}				
				}catch(e){
					showErrorMessage("validateBeforeCommit01", e);
				}
			}		
			
			var result = true;
			
			$("paramShortRatePercent").value = $F("shortRatePercent");
			
			if(objUW.GIPIS031.parameters.paramConfirmSw == "Y"){
				objUW.GIPIS031.parameters.paramConfirmSw = "N";
				showConfirmBox4("Short Term Date", "This policy has been endorsed for a short-term period. Do you want to keep this record permanently?",
					"Ok", "No", "Cancel", "", validateBeforeCommit01,
					function(){
						objUW.GIPIS031.parameters.paramConfirmSw = "Y";
						result = false;
					});
			}else{
				validateBeforeCommit01();
			}
		}catch(e){
			showErrorMessage("validateBeforeCommit", e);
		}
	}
	
	function gipis031PreCommit(){
		try{
			var result = false;

			if($("endtCancellation").checked || $("coiCancellation").checked){
				//if(nvl(objUW.GIPIS031.parameters.paramCancelPolId, true)){
				if(nvl($F("parCancelPolId"), true) == true){	
					showMessageBox("Please press Cancel Endt button to choose record for cancellation.", imgMessage.INFO);
					result = false;
					return result;
				}else{
					validateBeforeCommit();
				}
			}else if($F("prorateFlag") == "3" && $F("shortRatePercent") == ""){ // marco - 11.22.2012
				clearFocusElementOnError("shortRatePercent", "Short Rate percent is required.");
			}else if($("provisionalPremium").checked && $F("provPremRatePercent") == ""){ //kenneth 11.25.2015 SR 20984
				clearFocusElementOnError("provPremRatePercent", "Provisional Premium percent is required.");
			}else if ($F("referencePolicyNo") == "") { //added by gab 10.05.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
				if (objUW.hidObjGIPIS002.reqRefPolNo == "Y") {
					clearFocusElementOnError("referencePolicyNo", "Reference Policy No. is required.");
				}else{
					if(changeTag == 0){
						showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
					}else{
						validateBeforeCommit();
					}
				}
			}else if ($F("bankRefNo") == "") {
				if (objUW.hidObjGIPIS002.reqRefNo == "Y") {
					customShowMessageBox("Bank Reference Number is required.",
							imgMessage.ERROR, "nbtAcctIssCd");
				}else{
					if(changeTag == 0){
						showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
					}else{
						validateBeforeCommit();
					}
				}
			}else if(changeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO); //end gab
			}else{
				validateBeforeCommit();	
			}
			
		}catch(e){
			showErrorMessage("gipis031PreCommit", e);
		}
	}
	
	function gipis031KeyCommit(){
		try{
			if(objUW.GIPIS031.parameters.paramReqSurveySettAgent == "Y"){				
				if($F("surveyAgentCd") == "" || $F("settlingAgentCd") == ""){
					showWaitingMessageBox("Survey Agent and Settling Agent are required.", imgMessage.INFO, function(){
						if($("showMarineDetails").innerHTML == "Show"){
							$("showMarineDetails").click();
						}
					});
					return false;
				}
			}
			
			if(objUW.GIPIS031.gipiWPolbas.polFlag == 4 | $("nbtPolFlag").checked | $("prorateSw").checked){
				objUW.GIPIS031.parameters.paramCgBackEndt = "N";
			}
			
			if(objUW.GIPIS031.parameters.paramCgBackEndt == "Y" && objUW.GIPIS031.parameters.paramBackEndtSw == "Y"){
				Dialog.alert({
					url: contextPath+"/GIPIParInformationController?action=showBackwardEndt&parId=" + objUW.GIPIS031.gipiParList.parId, 
					options: {method: 'get'}}, {
						className: "alphacube", 
						width:540, 
						okLabel: "Ok",						
						buttonClass: "button",
						ok: function(){
							if(!($("radioYes").checked) && !($("radioNo").checked) && !($("radioCancel").checked)){
								showMessageBox("Please select an option first in able to proceed.", imgMessage.INFO);
							}else{
								if($("radioCancel").checked){
									objUW.GIPIS031.gipiWPolbas.backEndt = "Y";
								}else{				
									objUW.GIPIS031.parameters.paramBackEndtSw = "N";
									if($("radioYes").checked){										
										objUW.GIPIS031.gipiWPolbas.backStat = "2";										
									}else if($("radioNo").checked){										
										objUW.GIPIS031.gipiWPolbas.backStat = "1";										
									}
									saveEndtBasic();
								}
								return true;			
							}
						}
					});
				return false;
			}else{
				objUW.GIPIS031.gipiWPolbas.backStat = null;
			}
			
			if(objUW.GIPIS031.parameters.paramInsWinvoice == "Y"){
				objUW.GIPIS031.parameters.paramCreateWinvoice = "Y"; // create winvoice procedure
			}
			
			saveEndtBasic();
		}catch(e){
			showErrorMessage("gipis031KeyCommit", e);
		}
	}
	
	$("btnSave").observe("click", gipis031PreCommit);
	
	function cancelFuncMain() {
		try {
			Effect.Fade("parInfoDiv", {
				duration : .001,
				afterFinish : function() {
					if($("parListingMainDiv").down("div", 0).next().innerHTML.blank()){
						showEndtParListing();						
					}else{
						$("parInfoMenu").hide();
						Effect.Appear("parListingMainDiv", {
							duration : .001
						});
					}
					$("parListingMenu").show();
				}
			});
		} catch (e) {
			showErrorMessage("cancelFuncMain", e);
		}
	}
	
	observeReloadForm("reloadForm", function(){ changeTag = 0; showBasicInfo(); });
	//observeCancelForm("btnCancel", gipis031KeyCommit, cancelFuncMain); robert 10.24.2012
	observeCancelForm("btnCancel", gipis031PreCommit, cancelFuncMain);
	initializeChangeTagBehavior(gipis031PreCommit); //robert 01.08.2013
	
	$("endtEffDate").focus();
	
	$("issuePlace").observe("change", function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot change the Issuing Place. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								$("issuePlace").value = objUW.GIPIS031.variables.varOldIssuePlace;
								changeTag = 0;
							  });
			return false;
		}
		if(objUW.GIPIS031.variables.varOldIssuePlace != $F("issuePlace")){
			if(objUW.GIPIS031.parameters.paramInvoiceExist == "Y"){
				showConfirmBox("Message", "Some taxes are dependent to place of issuance... " + 
					"changing/removing place of issuance will automatically recreate invoice. Do you want to continue?",
					"Yes", "No", function(){
						objUW.GIPIS031.parameters.paramCreateWinvoice = "Y"; // create winvoice procedure
						objUW.GIPIS031.gipiParList.parStatus = 5;
						saveEndtBasic();
					}, function(){
						$("issuePlace").value = objUW.GIPIS031.variables.varOldIssuePlace;
					});
			}
		}
	});	
	
	// post-query
	if(objUW.GIPIS031.gipiWPolbas.polFlag == "4"){
		disableDate("hrefDoiDate");
		disableDate("hrefDoeDate");		
		disableDate("hrefEndtExpDate");
		
		if(objUW.GIPIS031.gipiWPolbas.prorateFlag == "2"){
			$("prorateFlag").disable();
			$("compSw").disable();
			$("noOfDays").disable();
			$("shortRatePercent").disable();
			$("prorateFlag").value = 2;
			$("compSw").value = "";
		}
		
		if (objUW.GIPIS031.gipiWPolbas.cancelType == "1"){
			
			disableDate("hrefEndtEffDate"); //marco - 08.05.2014 - changed from endtEffDate
			$("conditionDiv").hide();
			$("conditionText").innerHTML = "";
		}else if (objUW.GIPIS031.gipiWPolbas.cancelType == "2"){
			disableInputField("noOfDays");
		}
		
	}
	
	//added edgar 10/10/2014 to check for posted binders
	function checkPostedBinder(){ 
		var vExists = false;	
		new Ajax.Request(contextPath+"/GIPIWinvoiceController",{
				parameters:{
					action: "checkForPostedBinders",
					parId : objUW.GIPIS031.gipiParList.parId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							vExists = true;
						}else {
							vExists = false;
						}
					}
				}
			});
		return vExists;
	}
	
	$("searchSurveyAgent").observe("click", function(){ //Dren Niebres 06.07.2016 SR-22243 - Start
		try {
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getSurveyAgentLOV",
								page : 1},
				title: "Survey Agent",
				width: 500,
				height: 360,
				columnModel : [	{	id : "payeeNo",
									title: "Code",
									width: '80px',
									align: 'right'
								},
								{	id : "nbtPayeeName",
									title: "Survey Agent Name",
									width: '380px'
								}
							],
				draggable: true,
				onSelect: function(row){
					$("surveyAgentCd").value = row.payeeNo;
					$("surveyAgentName").value = unescapeHTML2(nvl(row.nbtPayeeName,""));
					changeTag = 1;
				}
			  });
		} catch (e){
			showErrorMessage("searchSurveyAgent", e);
		}
	}); 
	
	$("searchSettlingAgent").observe("click", function(){ 
		try {
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getSettlingAgentLOV",
								page : 1},
				title: "Settling Agent",
				width: 500,
				height: 360,
				columnModel : [	{	id : "payeeNo",
									title: "Code",
									width: '80px',
									align: 'right'
								},
								{	id : "nbtPayeeName",
									title: "Settling Agent Name",
									width: '380px'
								}
							],
				draggable: true,
				onSelect: function(row){
					$("settlingAgentCd").value = row.payeeNo;
					$("settlingAgentName").value = unescapeHTML2(nvl(row.nbtPayeeName,""));
					changeTag = 1;
				}
			  });
		} catch (e){
			showErrorMessage("searchSettlingAgent", e);
		}
	}); //Dren Niebres 06.07.2016 SR-22243 - End
	
}catch(e){
	showErrorMessage("Endt Basic Info - Main Page", e);
}
</script>
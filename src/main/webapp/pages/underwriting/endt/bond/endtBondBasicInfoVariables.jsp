<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
	<input type="hidden" id="ora2010Sw" name="ora2010Sw" value="${ora2010Sw }" /> 
	<input type="hidden" id="issCdRI" name="issCdRI" value="${issCdRI }" /> 
	<input type="hidden" id="varOldLineCd" 			name="varOldLineCd" 			value="${gipiWPolbas.lineCd }" />
	<input type="hidden" id="varOldSublineCd" 		name="varOldSublineCd" 			value="${gipiWPolbas.sublineCd }" />
	<input type="hidden" id="varOldIssCd" 			name="varOldIssCd" 				value="${gipiWPolbas.issCd }" />
	<input type="hidden" id="varOldIssueYY" 		name="varOldIssueYY" 			value="${gipiWPolbas.issueYy }" />
	<input type="hidden" id="varOldPolSeqNo" 		name="varOldPolSeqNo" 			value="${gipiWPolbas.polSeqNo }" />
	<input type="hidden" id="varOldRenewNo" 		name="varOldRenewNo" 			value="${gipiWPolbas.renewNo }" />
	<input type="hidden" id="varCancellationFlag" 	name="varCancellationFlag" 		value="N" />
	<input type="hidden" id="varCnclldFlatFlag" 	name="varCnclldFlatFlag" 		value="N" />
	<input type="hidden" id="varCnclldFlag" 		name="varCanclldFlag" 			value="N" />
	<input type="hidden" id="polFlag"				name="polFlag"					value="${gipiWPolbas.polFlag }" />
	<input type="hidden" id="endtCancellationFlag"  name="endtCancellationFlag"		value="N" />
	<input type="hidden" id="coiCancellationFlag"   name="coiCancellationFlag"		value="N" />
	<input type="hidden" id="parId"					name="parId" />
	<input type="hidden" id="varPolChangedSw"		name="varPolChangedSw" 			value="N" />
	<input type="hidden" id="prorateFlag"			name="prorateFlag" />
	<input type="hidden" id="compSw"				name="compSw" />
	<input type="hidden" id="globalCg$BackEndt"		name="globalCg$BackEndt" 		value="N" />
	<input type="hidden" id="parSysdateSw"			name="parSysdateSw"	/>
	<input type="hidden" id="parBackEndtSw"			name="parBackEndtSw"	/>
	
	<input type="hidden" id="blockFlag"				name="blockFlag" />
	<input type="hidden" id="mplSwitch"				name="mplSwitch" />
	<input type="hidden" id="clearInvoiceSw"		name="clearInvoiceSw" />
	<input type="hidden" id="varMaxEffDate"			name="varMaxEffDate" />
	<input type="hidden" id="polChangedSw"			name="polChangedSw" 			value="N" />
	<input type="hidden" id="expChgSw"				name="expChgSw"					value="N" />
	<input type="hidden" id="changeSw"				name="changeSw"					value="N" />
	
	<input type="hidden" id="firstEndtSw"			name="firstEndtSw"				value="N" />
	<input type="hidden" id="confirmSw"				name="confirmSw"				value="N" />
	<input type="hidden" id="cancelPolId"			name="cancelPolId" />
	<input type="hidden" id="endtPolId"				name="endtPolId" />
	<input type="hidden" id="varNDate"				name="varNDate" />
	<input type="hidden" id="varIDate"				name="varIDate" />
	<input type="hidden" id="varVDate"				name="varVDate" 				value="${varVDate}"/>
	
	<input type="hidden" id="delBillTbls"			name="delBillTbls"				value="N" />
	
	<input type="hidden" id="parStatus"				name="parStatus" />
	
	<!-- VARIABLES BELOW ARE JUST ADDED TO MATCH FIELDS USED IN REUSED FUNCTIONS -->
	<input type="hidden" id="b540EffDate"			name="b540EffDate" />
	
	<input type="hidden" id="inAccountOf"			name="inAccountOf" />
	
	<input type="hidden" id="b240ParStatus"			name="b240ParStatus" />
	<input type="hidden" id="acctOfCd"				name="acctOfCd" />
	<input type="hidden" id="labelTag"				name="labelTag" />
	<input type="hidden" id="b540LabelTag"			name="b540LabelTag" />
	<input type="hidden" id="parFirstEndtSw"		name="parFirstEndtSw" />
	<input type="hidden" id="b540AnnTsiAmt"			name="b540AnnTsiAmt" />
	<input type="hidden" id="b540AnnPremAmt"		name="b540AnnPremAmt" />
	<input type="hidden" id="b240Address1"			name="b240Address1" />
	<input type="hidden" id="b240Address2" 			name="b240Address2" />
	<input type="hidden" id="b240Address3"			name="b240Address3" />
	<input type="hidden" id="typeOfPolicy"			name="typeOfPolicy" />
	<input type="hidden" id="b540LineCd"			name="b540LineCd" />
	<input type="hidden" id="b540SublineCd"			name="b540SublineCd" />
	<input type="hidden" id="b540IssCd"				name="b540IssCd" />
	<input type="hidden" id="b540IssueYY"			name="b540IssueYY" />
	<input type="hidden" id="b540PolSeqNo"			name="b540PolSeqNo" />
	<input type="hidden" id="b540RenewNo"			name="b540RenewNo" /> 
	
	<input type="hidden" id="b540EndtIssCd"			name="b540EndtIssCd" />
	<input type="hidden" id="b540EndtYy"			name="b540EndtYy" /> 
	<input type="hidden" id="b540InceptDate"		name="b540InceptDate" /> 
	<input type="hidden" id="b540InceptTag"			name="b540InceptTag" /> 
	
	<input type="hidden" id="b540ExpiryDate"		name="b540ExpiryDate" />
	<input type="hidden" id="expiryTag"				name="expiryTag" />
	<input type="hidden" id="b540ExpiryTag"			name="b540ExpiryTag" />
	
	<input type="hidden" id="endtExpDateTag"		name="endtExpDateTag" />
	<input type="hidden" id="b540EffDate"			name="b540EffDate" />
	<input type="hidden" id="endtEffDate"			name="endtEffDate" />
	<input type="hidden" id="endtExpDate"			name="endtExpDate" />
	<input type="hidden" id="b540EndtExpiryDate"	name="b540EndtExpiryDate" />
	<input type="hidden" id="b540SamePolNoSw"		name="b540SamePolNoSw" />
	<input type="hidden" id="b540ForeignAccSw"		name="b540ForeignAccSw" />
	<input type="hidden" id="b540CompSw"			name="b540CompSw" />
	<input type="hidden" id="b540PremWarrTag"		name="b540PremWarrTag" />
	
	<input type="hidden" id="b540OldAssdNo"			name="b540OldAssdNo" />
	<input type="hidden" id="b540OldAddress1"		name="b540OldAddress1" />
	<input type="hidden" id="b540OldAddress2"		name="b540OldAddress2" />
	<input type="hidden" id="b540OldAddress3"		name="b540OldAddress3" />
	
	<input type="hidden" id="b540RegPolicySw"		name="b540RegPolicySw" />
	<input type="hidden" id="b540CoInsuranceSw"		name="b540CoInsuranceSw" />
	<input type="hidden" id="b540ManualRenewNo"		name="b540ManualRenewNo" />
<script>
	$("b240ParStatus").value = $F("globalParStatus");

	if ($F("varVDate") == "1"){
		$("varIDate").value = $F("issDate"); 
	} else if ($F("varVDate") == "2"){
		$("varIDate").value = $F("doi");
	} else if ($F("varVDate") == "3"){
		if (makeDate($F("issDate")) > makeDate($F("doi"))){
			$("varIDate").value = $F("issDate"); 
			$("varNDate").value = "issue";
		} else {
			$("varIDate").value = $F("doi");
			$("varNDate").value = "effectivity";
		}
	}

	/*
	if (params.varVDate == "1"){
		$("varIDate").value = $F("issDate"); 
	} else if (params.varVDate == "2"){
		$("varIDate").value = $F("doi");
	} else if (params.varVDate == "3"){
		if (makeDate($F("issDate")) > makeDate($F("doi"))){
			$("varIDate").value = $F("issDate"); 
			$("varNDate").value = "issue";
		} else {
			$("varIDate").value = $F("doi");
			$("varNDate").value = "effectivity";
		}
	}
	*/
</script>	
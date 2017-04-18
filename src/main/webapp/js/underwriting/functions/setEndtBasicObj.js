function setEndtBasicObj(){
	try{
		var obj = new Object();
		var polbas = objUW.GIPIS031.gipiWPolbas;
		obj.parId				= objUW.GIPIS031.gipiParList.parId; //polbas.parId;
		obj.lineCd				= polbas.lineCd;
		obj.issCd				= polbas.issCd;
		obj.foreignAccSw		= polbas.foreignAccSw;
		obj.invoiceSw			= "N";	//polbas.invoiceSw; // default value in GIPIS031
		obj.quotationPrintedSw	= "N";	//polbas.quotationPrintedSw; // default value in GIPIS031
		obj.covernotePrintedSw	= "N";	//polbas.covernotePrintedSw; // default value in GIPIS031
		obj.autoRenewFlag		= "N";	//polbas.autoRenewFlag;
		obj.provPremTag			= $("provisionalPremium").checked ? "Y" : "N"; //polbas.provPremTag; //kenneth 11.25.2015 SR 20984
		obj.samePolnoSw			= polbas.samePolnoSw;
		obj.packPolFlag			= $("packagePolicy").checked ? "Y" : polbas.packPolFlag;
		obj.regPolicySw			= $("regularPolicy").checked ? "Y" : "N"; //polbas.regPolicySw;
		obj.coInsuranceSw		= $F("coIns") != "" ? $F("coIns") : polbas.coInsuranceSw;
		obj.sublineCd			= unescapeHTML2($F("sublineCd") != "" ? $F("sublineCd") : polbas.sublineCd); //added unescapeHTML2 by robert 09162013
		obj.issueYy				= polbas.issueYy;
		obj.polSeqNo			= polbas.polSeqNo;
		obj.endtIssCd			= polbas.endtIssCd;
		obj.endtYy				= polbas.endtYy;
		obj.endtSeqNo			= polbas.endtSeqNo;
		obj.renewNo				= $F("renewNo") != "" ? $F("renewNo") : polbas.renewNo;
		obj.manualRenewNo		= $F("manualRenewNo") != "" ? $F("manualRenewNo") : polbas.manualRenewNo;
		obj.endtType			= polbas.endtType;
		obj.inceptDate			= $F("doi") != "" ? ($F("doi") + " " + dateFormat(objUW.GIPIS031.gipiWPolbas.inceptDate, "hh:MM:ss TT")) : polbas.inceptDate;
		obj.expiryDate			= $F("doe") != "" ? ($F("doe") + " " + dateFormat(objUW.GIPIS031.gipiWPolbas.expiryDate, "hh:MM:ss TT")): polbas.expiryDate;
		obj.expiryTag			= $("expiryTag").checked ? "Y" : polbas.expiryTag;
		obj.effDate				= $F("endtEffDate") != "" ? ($F("endtEffDate") + " " + dateFormat(objUW.GIPIS031.gipiWPolbas.effDate, "hh:MM:ss TT")): polbas.effDate;
		obj.issueDate			= $F("issueDate") != "" ? ($F("issueDate") + " " + dateFormat(objUW.GIPIS031.gipiWPolbas.issueDate, "HH:MM:ss TT")) : polbas.issueDate;
		obj.polFlag				= $("nbtPolFlag").checked ? "4" : polbas.polFlag;
		obj.assdNo				= $F("assuredNo") != "" ? $F("assuredNo") : polbas.assdNo;
		obj.designation			= polbas.designation;
		obj.address1			= $F("address1") != "" ? $F("address1") : polbas.address1;
		obj.address2			= $F("address2") != "" ? $F("address2") : polbas.address2;
		obj.address3			= $F("address3") != "" ? $F("address3") : polbas.address3;
		obj.mortgName			= polbas.mortgName;
		obj.tsiAmt				= $F("b540TsiAmt") != "" ? $F("b540TsiAmt") :polbas.tsiAmt; //robert 10.08.2012 added condition
		obj.premAmt			= $F("b540PremAmt") != "" ? $F("b540PremAmt") :polbas.premAmt; //robert 10.08.2012 added condition
		obj.annTsiAmt		= $F("b540AnnTsiAmt") != "" ? $F("b540AnnTsiAmt") :polbas.annTsiAmt; //robert 10.08.2012 added condition
		obj.annPremAmt	= $F("b540AnnPremAmt") != "" ? $F("b540AnnPremAmt") :polbas.annPremAmt; //robert 10.08.2012 added condition
		obj.poolPolNo			= polbas.poolPolNo;
		obj.userId				= userId; //polbas.userId;
		obj.origPolicyId		= polbas.origPolicyId;
		obj.endtExpiryDate		= $F("endtExpDate") != "" ? ($F("endtExpDate") + " " + dateFormat(objUW.GIPIS031.gipiWPolbas.endtExpiryDate, "hh:MM:ss TT")) : polbas.endtExpiryDate;
		obj.noOfItems			= polbas.noOfItems;
		obj.sublineTypeCd		= polbas.sublineTypeCd;
		obj.prorateFlag			= $F("prorateFlag") != "" ? $F("prorateFlag") : polbas.prorateFlag;
		obj.shortRtPercent		= $F("shortRatePercent") != "" ? $F("shortRatePercent") : (obj.prorateFlag == "3" ? polbas.shortRtPercent : ""); // marco - 11.22.2012
		obj.typeCd				= $F("typeOfPolicy") != "" ? $F("typeOfPolicy") : polbas.typeCd;
		//obj.acctOfCd			= $F("acctOfCd") != "" ? $F("acctOfCd") : polbas.acctOfCd; // comment out by andrew - replaced with the next line of code - 02.8.2013
		obj.acctOfCd			= $F("acctOfCd");
		//obj.provPremPct			= $F("provPremRatePercent") != "" ? $F("provPremRatePercent") : polbas.provPremPct;
		obj.provPremPct			= $("provisionalPremium").checked ? ($F("provPremRatePercent") != "" ? $F("provPremRatePercent") : polbas.provPremPct) : "";	//kenneth 11.25.2015 SR 20984
		obj.discountSw			= polbas.discountSw;
		obj.premWarrTag			= $("premWarrTag").checked ? "Y" : "N";//polbas.premWarrTag;
		//obj.refPolNo			= $F("referencePolicyNo") != "" ? $F("referencePolicyNo") : polbas.refPolNo;
		obj.refPolNo			= $F("referencePolicyNo"); //edited by gab SR 3147,3027,2645,2681,3148,3206,3264,3010
		obj.refOpenPolNo		= polbas.refOpenPolNo;
		obj.inceptTag			= $("inceptTag").checked ? "Y" : "N";
		obj.fleetPrintTag		= $("fleetTag").checked ? "Y" : "N"; //polbas.fleetPrintTag;
		obj.compSw				= $F("compSw") != "" ? $F("compSw") : polbas.compSw;
		obj.bookingMth			= $F("bookingMth") != "" ? $F("bookingMth") : polbas.bookingMth;
		obj.bookingYear			= $F("bookingYear") != "" ? $F("bookingYear") : polbas.bookingYear;
		obj.withTariffSw		= $("wTariff").checked ? "Y" : "N";	//polbas.withTariffSw;
		obj.endtExpiryTag		= $("endtExpDateTag").checked ? "Y" : null;
		obj.coverNtPrintedDate	= polbas.coverNtPrintedDate;
		obj.coverNtPrintedCnt	= polbas.coverNtPrintedCnt;
		//obj.placeCd				= $F("issuePlace") != "" ? $F("issuePlace") : polbas.placeCd; // removed by apollo cruz 03.25.2015
		obj.placeCd				= $F("issuePlace");
		obj.backStat			= polbas.backStat;
		obj.validateTag			= polbas.validateTag;
		obj.industryCd			= $F("industry") != "" ? $F("industry") : polbas.industryCd;
		obj.regionCd			= $F("region") != "" ? $F("region") : polbas.regionCd;
		obj.acctOfCdSw			= $("deleteSw").checked ? "Y" : "N"; //polbas.acctOfCdSw;
		obj.surchargeSw			= polbas.surchargeSw;
		obj.credBranch			= $F("creditingBranch") != "" ? $F("creditingBranch") : polbas.credBranch;
		obj.oldAssdNo			= polbas.oldAssdNo;
		obj.cancelDate			= polbas.cancelDate;
		//obj.labelTag			= $("labelTag").checked ? "Y" : polbas.labelTag;
		obj.labelTag			= $("labelTag").checked ? "Y" : $("deleteSw").checked ? "N" : ""; // bonok :: 12.18.2012
		obj.oldAddress1			= unescapeHTML2(polbas.oldAddress1); //belle 09272012 add unescapeHTML2
		obj.oldAddress2			= unescapeHTML2(polbas.oldAddress2);
		obj.oldAddress3			= unescapeHTML2(polbas.oldAddress3);
		obj.riskTag				= $F("riskTag") != "" ? $F("riskTag") : polbas.riskTag;
		obj.qdFlag				= polbas.qdFlag;
		obj.surveyAgentCd		= $F("surveyAgentCd") != "" ? $F("surveyAgentCd") : polbas.surveyAgentCd;
		obj.settlingAgentCd		= $F("settlingAgentCd") != "" ? $F("settlingAgentCd") : polbas.settlingAgentCd;
		obj.packParId			= polbas.packParId;
		obj.covernoteExpiry		= polbas.covernoteExpiry;
		obj.premWarrDays		= polbas.premWarrDays;
		obj.takeupTerm			= $F("takeupTermType") != "" ? $F("takeupTermType") : polbas.takeupTerm;
		obj.cancelType			= polbas.cancelType;
		//obj.cancelledEndtId		= polbas.cancelledEndtId;
		obj.cnDatePrinted		= polbas.cnDatePrinted;
		obj.cnNoOfDays			= $F("noOfDays") != "" ? $F("noOfDays") : polbas.cnNoOfDays;
		obj.bancassuranceSw		= $("bancaTag") != null ? ($("bancaTag").checked ? "Y" : "N") : "N"; //polbas.bancassuranceSw;
		obj.areaCd				= $("bancaTag") != null ? ($("bancaTag").checked ? nvl(polbas.areaCd, $F("selAreaCd")) : "") : "";
		obj.branchCd			= $("bancaTag") != null ? ($("bancaTag").checked ? nvl(polbas.branchCd, $F("selBranchCd")) : "") : "";
		obj.managerCd			= $("bancaTag") != null ? ($("bancaTag").checked ? nvl(polbas.managerCd, $F("dspManagerCd")) : "") : "";
		obj.bancTypeCd			= $("bancaTag") != null ? ($("bancaTag").checked ? nvl(polbas.bancTypeCd, $F("selBancTypeCd")) : "") : "";
		obj.minPremFlag			= polbas.minPremFlag;
		obj.companyCd			= polbas.companyCd;
		obj.employeeCd			= polbas.employeeCd;
		//obj.planSw				= $("packPLanTag").checked ? "Y" : polbas.planSw; // andrew - 02.27.2012 - added condition for ora2010Sw
		obj.planSw				= objUW.GIPIS031.parameters.paramOra2010Sw == "Y" && $("packPLanTag").checked ? "Y" : polbas.planSw; 
		obj.planCd				= polbas.planCd;
		obj.planChTag			= polbas.planChTag;
		obj.bankRefNo			= $F("bankRefNo") != "" ? $F("bankRefNo") : polbas.bankRefNo;
		obj.depFlag				= polbas.depFlag;
		obj.cancelledEndtId		= $F("b540CancelledEndtId") != "" ? $F("b540CancelledEndtId") : polbas.cancelledEndtId ; //robert 9.21.2012
		
		return obj;
	}catch(e){
		showErrorMessage("setEndtBasicObj", e);
	}	
}
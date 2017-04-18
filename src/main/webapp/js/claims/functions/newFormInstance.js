/*
 * Tonio 8.2.2011
 * GICLS010 Claim Basic Information
 */
function newFormInstance(){
	disableMenu("clmMainBasicInformation");
	disableMenu("clmItemInformation");
	disableMenu("clmReserveSetup");
	disableMenu("clmLossExpenseHist");
	disableMenu("clmGenAdvice");
	disableMenu("clmReports");
	disableMenu("clmLossRecovery");

	if (objCLMGlobal.claimId == null){
		enableMenu("clmMainBasicInformation");
		enableMenu("clmBasicInformation");
		disableMenu("clmRequiredDocs");
		$("txtClmStat").readOnly = true;
		$("oscmClmStat").disabled = true;
		$("oscmClmStat").hide();
		$("txtLineCd").focus();
		
		$("txtLineCd").addClassName("required");
		$("txtLineCd").up("div",0).addClassName("required");
		$("txtSublineCd").addClassName("required");
		$("txtSublineCd").up("div",0).addClassName("required");
		$("txtPolIssCd").addClassName("required");
		$("txtPolIssCd").up("div",0).addClassName("required");
		$("txtIssueYy").addClassName("required");
		$("txtIssueYy").up("div",0).addClassName("required");
		$("txtPolSeqNo").addClassName("required");
		$("txtPolSeqNo").up("div",0).addClassName("required");
		$("txtRenewNo").addClassName("required");
		$("txtRenewNo").up("div",0).addClassName("required");
	}else{
		enableMenu("clmMainBasicInformation");
		enableMenu("clmBasicInformation");
		enableMenu("clmRequiredDocs");
		
		$("oscmClmStat").disabled = false;
		$("oscmClmStat").show();
		
		$("txtLineCd").readOnly 	= true;
		$("txtSublineCd").readOnly 	= true;
		$("txtPolIssCd").readOnly 	= true;
		$("txtIssueYy").readOnly 	= true;
		$("txtPolSeqNo").readOnly 	= true;
		$("txtRenewNo").readOnly 	= true;
		
		$("txtLineCd").setStyle('width : 19px');
		$("txtLineCdIcon").hide();
		$("txtLineCd").up("div",0).setStyle('width : 25px');
		$("txtSublineCdIcon").hide();
		$("txtSublineCd").up("div",0).setStyle('width : 78px');
		$("txtPolIssCdIcon").hide();
		$("txtIssueYyIcon").hide();
		$("txtPolSeqNoIcon").hide();
		$("txtPolSeqNo").up("div",0).setStyle('width : 78px');
		$("txtRenewNoIcon").hide();
		$("txtLossDate").focus();
	}
}
/*
 * Tonio 8.10.2011
 * GICLS010 Claim Basic Information
 * Set Claims Menu properties
 */
function setClaimsMenuProperty(obj){
	var itemInfoModuleId = getItemInfoModuleId(nvl(objCLMGlobal.menuLineCd, objCLMGlobal.lineCd));
	
	disableMenu("clmLossRecovery");
	disableMenu("clmItemInformation");
	disableMenu("clmReserveSetup");
	disableMenu("clmLossExpenseHist");
	disableMenu("clmGenAdvice");
	disableMenu("clmReports");
	
	if (nvl(obj.basicInformation,"N") == 'N'){disableMenu("clmMainBasicInformation");}else{enableMenu("clmMainBasicInformation");}
	if (nvl(obj.basicInformation,"N") == 'N'){
		disableMenu("clmItemInformation");
	}else{
		if(objCLMGlobal.lineCd != 'SU'){enableMenu("clmItemInformation");} //added by steven 10/25/2012
	}
	if (nvl(obj.basicInformation,"N") == 'N'){disableMenu("clmReserveSetup");}else{enableMenu("clmReserveSetup");}
	if (nvl(obj.basicInformation,"N") == 'N'){disableMenu("clmLossExpenseHist");}else{enableMenu("clmLossExpenseHist");}
	if (nvl(obj.basicInformation,"N") == 'N'){disableMenu("clmGenAdvice");}else{enableMenu("clmGenAdvice");}
	if (nvl(obj.basicInformation,"N") == 'N'){disableMenu("clmLossRecovery");}else{enableMenu("clmLossRecovery");}
	if (nvl(obj.basicInformation,"N") == 'N'){disableMenu("clmReports");}else{enableMenu("clmReports");}
	if (nvl(obj.recoveryInformation,"N") == 'N'){disableMenu("clmRecoveryInformation");}else{enableMenu("clmRecoveryInformation");}
	if (nvl(obj.recoveryDistribution,"N") == 'N'){disableMenu("clmRecoveryDistribution");}else{enableMenu("clmRecoveryDistribution");}
	if (nvl(obj.generateRecAcctEnt,"N") == 'N'){disableMenu("clmRecoveryAcctEntries");}else{enableMenu("clmRecoveryAcctEntries");}
	if (nvl(obj.lossRecovery,"N") == 'N'){disableMenu("clmLossRecovery");}else{enableMenu("clmLossRecovery");}
	if (nvl(obj.reserve,"N") == 'N'){disableMenu("clmReserveSetup");}else{enableMenu("clmReserveSetup");}
	if (nvl(obj.claimReserve,"N") == 'N'){disableMenu("clmReserve");}else{enableMenu("clmReserve");}
	if (nvl(obj.pla,"N") == 'N'){disableMenu("clmReservePrelimLossAdvice");}else{enableMenu("clmReservePrelimLossAdvice");}
	if (nvl(obj.plr,"N") == 'N'){disableMenu("clmReservePrelimLossRep");}else{enableMenu("clmReservePrelimLossRep");}
	if (nvl(obj.lossexpenseHistory,"N") == 'Y'){enableMenu("clmLossExpenseHist");}else{disableMenu("clmLossExpenseHist");}
	if (nvl(obj.generateAdvice,"N") == 'Y'){enableMenu("clmGenAdvice");}else{disableMenu("clmGenAdvice");}
	if(checkUserModule("GICLS032")){//added by steven 11/26/2012
		if (nvl(obj.subGenerateAdvice,"N") == 'N'){disableMenu("clmSubGenAdvice");}else{enableMenu("clmSubGenAdvice");}
	}
	if (nvl(obj.generateFla,"N") == 'N'){disableMenu("clmGenerateFLA");}else{enableMenu("clmGenerateFLA");}
	if (nvl(obj.generateLoa,"N") == 'N'){disableMenu("clmGenerateLOA");}else{enableMenu("clmGenerateLOA");}
	if (nvl(obj.generateCashSettlement,"N") == 'N'){disableMenu("clmGenerateCashSettlement");}else{enableMenu("clmGenerateCashSettlement");}
	if(checkUserModule(itemInfoModuleId)){
		enableMenu("clmItemInformation");
	} else {
		disableMenu("clmItemInformation");
	}
}
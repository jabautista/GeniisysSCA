function setMenuProperty(obj){
	try{
		if (nvl(obj.plr,"N") == 'Y'){enableMenu("clmReservePrelimLossRep");}else{disableMenu("clmReservePrelimLossRep");}
		if (nvl(obj.pla,"N") == 'Y'){enableMenu("clmReservePrelimLossAdvice");}else{disableMenu("clmReservePrelimLossAdvice");}
		//if (nvl(obj.reserve,"N") == 'N'){disableMenu("clmReserveSetup");}else{enableMenu("clmReserveSetup");}
		if (nvl(obj.lossexpenseHistory,"N") == 'Y'){enableMenu("clmLossExpenseHist");}else{disableMenu("clmLossExpenseHist");}
		if (nvl(obj.generateAdvice,"N") == 'Y'){enableMenu("clmGenAdvice");}else{disableMenu("clmGenAdvice");}
		if (nvl(obj.generateFla,"N") == 'Y'){enableMenu("clmGenerateFLA");}else{disableMenu("clmGenerateFLA");}
		if (nvl(obj.generateLoa,"N") == 'Y'){enableMenu("clmGenerateLOA");}else{disableMenu("clmGenerateLOA");}
	}catch(e){
		showErrorMessage("setMenuProperty", e);	
	}	
}
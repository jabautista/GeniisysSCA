//moved from basicInformationMain.jsp
// replaced fields with global variables
function checkCoInsMenu(coIns) {
	try {
		coIns = coIns == null ? objUWGlobal.coInsurance : coIns;
		var coInsSw = objGIPIWPolbas == null ? objUWGlobal.coInsSw : objGIPIWPolbas.coInsuranceSw;
		
		if(coIns == null) {
			disableMenu("coInsurance");
		} else {
			if (coIns.vStat == "5") {
				if (coInsSw == "2") {
					enableMenu("coInsurance");
					enableMenu("coInsurer");
					enableMenu("leadPolicy");
				} else if (coInsSw == "3") {
					enableMenu("coInsurance");
					enableMenu("coInsurer");
					disableMenu("leadPolicy");
				} else {
					disableMenu("coInsurance");
				}
			} else if (coIns.vStat == "6") {
				if (coInsSw == "2") {
					enableMenu("coInsurance");
					enableMenu("coInsurer");
					enableMenu("leadPolicy");
					if (nvl(coIns.vCnt1, "0") == "0") {
						disableMenu("post");
					} else {
						enableMenu("post");
					}
				} else if (coInsSw == "3") {
					enableMenu("coInsurance");
					enableMenu("coInsurer");
					disableMenu("leadPolicy");
					if (nvl(coIns.vCnt2, "0") != "0") {
						enableMenu("post");
					}
				} else {
					enableMenu("post");
					disableMenu("coInsurance");
				}
			} else {
				disableMenu("coInsurance");
			}
		} 
	} catch (e) {
		showErrorMessage("checkCoInsMenu", e);
	}
}
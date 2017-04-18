/**
 * function that will update the LOV for Loss Advice in Loss Recov from RI
 * (GIACS009)
 * 
 * @author Jerome Orio 10.22.2010
 * @version 1.0
 * @param
 * @return
 */
function updateRiTransLossRecovLOV() {
	if ($F("selTransactionTypeLossesRecov") == ""
			|| $F("selShareTypeLossesRecov") == "") {
		hideLOV("selA180RiCdLossesRecov13");
		hideLOV("selA180RiCdLossesRecov22");
		hideLOV("selA180RiCdLossesRecov23");
		showLOV("selA180RiCdLossesRecov12");
		hideLOV("selA180RiCdLossesRecov14");
		hideLOV("selA180RiCdLossesRecov24");
		$("selA180RiCdLossesRecov12").disable();
		objAC.hidObjGIACS009.hidCurrReinsurer = "selA180RiCdLossesRecov12";
		return false;
	} else {
		if ($F("selTransactionTypeLossesRecov") == "1") {
			hideLOV("selA180RiCdLossesRecov13");
			hideLOV("selA180RiCdLossesRecov22");
			hideLOV("selA180RiCdLossesRecov23");
			showLOV("selA180RiCdLossesRecov12");
			hideLOV("selA180RiCdLossesRecov14");
			hideLOV("selA180RiCdLossesRecov24");
			objAC.hidObjGIACS009.hidCurrReinsurer = "selA180RiCdLossesRecov12";
			if ($F("selShareTypeLossesRecov") == "2") {
				null;
			} else if ($F("selShareTypeLossesRecov") == "3") {
				hideLOV("selA180RiCdLossesRecov12");
				hideLOV("selA180RiCdLossesRecov22");
				hideLOV("selA180RiCdLossesRecov23");
				showLOV("selA180RiCdLossesRecov13");
				hideLOV("selA180RiCdLossesRecov14");
				hideLOV("selA180RiCdLossesRecov24");
				objAC.hidObjGIACS009.hidCurrReinsurer = "selA180RiCdLossesRecov13";
			} else if ($F("selShareTypeLossesRecov") == "4") {
				hideLOV("selA180RiCdLossesRecov12");
				hideLOV("selA180RiCdLossesRecov22");
				hideLOV("selA180RiCdLossesRecov23");
				hideLOV("selA180RiCdLossesRecov13");
				showLOV("selA180RiCdLossesRecov14");
				hideLOV("selA180RiCdLossesRecov24");
				objAC.hidObjGIACS009.hidCurrReinsurer = "selA180RiCdLossesRecov14";
			}
		} else if ($F("selTransactionTypeLossesRecov") == "2") {
			hideLOV("selA180RiCdLossesRecov12");
			hideLOV("selA180RiCdLossesRecov13");
			hideLOV("selA180RiCdLossesRecov23");
			showLOV("selA180RiCdLossesRecov22");
			hideLOV("selA180RiCdLossesRecov14");
			hideLOV("selA180RiCdLossesRecov24");
			objAC.hidObjGIACS009.hidCurrReinsurer = "selA180RiCdLossesRecov22";
			if ($F("selShareTypeLossesRecov") == "2") {
				null;
			} else if ($F("selShareTypeLossesRecov") == "3") {
				hideLOV("selA180RiCdLossesRecov12");
				hideLOV("selA180RiCdLossesRecov13");
				hideLOV("selA180RiCdLossesRecov22");
				showLOV("selA180RiCdLossesRecov23");
				hideLOV("selA180RiCdLossesRecov14");
				hideLOV("selA180RiCdLossesRecov24");
				objAC.hidObjGIACS009.hidCurrReinsurer = "selA180RiCdLossesRecov23";
			} else if ($F("selShareTypeLossesRecov") == "4") {
				hideLOV("selA180RiCdLossesRecov12");
				hideLOV("selA180RiCdLossesRecov22");
				hideLOV("selA180RiCdLossesRecov23");
				hideLOV("selA180RiCdLossesRecov13");
				hideLOV("selA180RiCdLossesRecov14");
				showLOV("selA180RiCdLossesRecov24");
				objAC.hidObjGIACS009.hidCurrReinsurer = "selA180RiCdLossesRecov24";
			}
		}
	}
}
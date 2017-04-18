/**
 * Load filtered DCB No. Maintenance page
 * 
 * @author d.alcantara
 */
function loadFilteredDCBNoMaintenance(fundCd, branchCd, dcbFlag, txtCompany,
		txtBranch, filtered) {
	try {
		filtered = (filtered == null || filtered == "") ? "No" : filtered;
		updateMainContentsDiv(
				"/GIACDCBNoMaintController?action=showDCBNoMaint&fundCd="
						+ fundCd + "&branchCd=" + branchCd + "&dcbFlag="
						+ dcbFlag + "&filtered=" + filtered + "&txtCompany="
						+ txtCompany + "&txtBranch=" + txtBranch,
				"Retrieving DCB list, please wait...");
		hideAccountingMainMenus();
	} catch (e) {
		showErrorMessage("showDCBNoMaintenance", e);
	}
}
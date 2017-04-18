/** Enables or disables the Package PAR menus depending on the given condition  
 * @author Veronica V. Raymundo
 * @param parStatus - Package PAR status
 * @param lineCd - Package PAR lineCd
 * @param issCd - Package PAR issCd
 * 
 */

function setPackParMenus(parStatus, lineCd, issCd){
	try {
		setPackParMenusByStatus(parStatus);
		disableMenu("bondBasicInfo");
		disableMenu("additionalEngineeringInfo");	
		disableMenu("bankCollection");
		disableMenu("carrierInfo");
		issCd == "RI" ? enableMenu("initialAcceptance") : disableMenu("initialAcceptance");
		disableMenu("collateralTransaction"); 
		disableMenu("coInsurance");
		disableMenu("cargoLimitsOfLiability");
		//disableMenu("itemInfo");
		disableMenu("limitsOfLiabilities");
		setPackItemMenus(parStatus);
	} catch (e) {
		showErrorMessage("setPackParMenus", e);
	}
}
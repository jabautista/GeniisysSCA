/* Created by:	 d. alcantara 02/03/2011
 * Description:	 shows the Location / Default Location overlay in the Engineering Item Screen 	
*/
function showItemLocations(type, title) {
	showOverlayContent2(contextPath+"/GIPIWEngineeringItemController?action=showLocationSelect&locType="+type+"&globalParId="+(objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), title, 560, "");
}
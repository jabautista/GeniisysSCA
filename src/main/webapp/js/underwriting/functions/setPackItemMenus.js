/**
 * Sets the pack item menus depending on the included line codes of the package policy
 * @author andrew
 * @return
 */
function setPackItemMenus(parStatus){
	try {			
		disableMenu('packItemMC');
		disableMenu('packItemFI');
		disableMenu('packItemAV');
		disableMenu('packItemMN');
		disableMenu('packItemMH');
		disableMenu('packItemCA');
		disableMenu('packItemAH');
		disableMenu('packItemEN');
		//disableMenu('packItemOthers');		
		if(parStatus > 2){
			if(objGIPIWPackLineSubline != null){			
				for(var i=0; i<objGIPIWPackLineSubline.length; i++){
					if(objGIPIWPackLineSubline[i].packLineCd == objLineCds.MC || objGIPIWPackLineSubline[i].menuLineCd == objLineCds.MC){
						enableMenu('packItemMC');
					} else if (objGIPIWPackLineSubline[i].packLineCd == objLineCds.FI || objGIPIWPackLineSubline[i].menuLineCd == objLineCds.FI) {
						enableMenu('packItemFI');
					} else if (objGIPIWPackLineSubline[i].packLineCd == objLineCds.AV || objGIPIWPackLineSubline[i].menuLineCd == objLineCds.AV) {
						enableMenu('packItemAV');
					} else if (objGIPIWPackLineSubline[i].packLineCd == objLineCds.MN || objGIPIWPackLineSubline[i].menuLineCd == objLineCds.MN) {
						enableMenu('packItemMN');	
						if(checkUserModule("GIPIS007")){//added by steven 07.09.2014
							enableMenu('carrierInfo');
						}else{
							disableMenu('carrierInfo');
						}
					} else if (objGIPIWPackLineSubline[i].packLineCd == objLineCds.MH || objGIPIWPackLineSubline[i].menuLineCd == objLineCds.MH) {
						enableMenu('packItemMH');
					} else if (objGIPIWPackLineSubline[i].packLineCd == objLineCds.CA || objGIPIWPackLineSubline[i].menuLineCd == objLineCds.CA) {
						enableMenu('packItemCA');
					} else if (objGIPIWPackLineSubline[i].packLineCd == objLineCds.AC || objGIPIWPackLineSubline[i].menuLineCd == objLineCds.AC) {
						enableMenu('packItemAH');
					} else if (objGIPIWPackLineSubline[i].packLineCd == objLineCds.EN || objGIPIWPackLineSubline[i].menuLineCd == objLineCds.EN) {
						enableMenu('packItemEN');
						enableMenu("additionalEngineeringInfo");
					}
				}
			}
		}
	} catch(e){
		showErrorMessage("setPackItemMenus", e);
	}		
}
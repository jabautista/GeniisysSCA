/*	Created by	: Jerome Orio 03.03.2011
 * 	Description	: filter LOV for Aircraft Name in AV item screen (GIPIS019)
 */
function filterAviationVesselLOV(selectId, currentValue){
	if (objGIPIWItem == null) {
		// if objGIPIWitem is null, return (on marketing, emman 04.27.2011)
		return;
	} else {
		(($(selectId).childElements()).invoke("show")).invoke("removeAttribute", "disabled");
		for(var a = 0; a<objGIPIWItem.length; a++){
			if (objGIPIWItem[a].recordStatus != -1){
				if (objGIPIWItem[a].gipiWAviationItem != null){
					var cd = objGIPIWItem[a].gipiWAviationItem.vesselCd;	
					for(var i = 1; i < $(selectId).options.length; i++){ 
						if (cd == $(selectId).options[i].value){
							$(selectId).options[i].hide();
							$(selectId).options[i].disabled = true;
						}
					}
				}
			}else{ //marco - 04.14.2014 - added else block
				if (objGIPIWItem[a].gipiWAviationItem != null){
					var cd = objGIPIWItem[a].gipiWAviationItem.vesselCd;	
					for(var i = 1; i < $(selectId).options.length; i++){
						if (cd == $(selectId).options[i].value){
							$(selectId).options[i].show();
							$(selectId).options[i].disabled = false;
						}
					}
				}
			}
		}
		if (currentValue != ""){
			for(var i = 1; i < $(selectId).options.length; i++){ 
				if (currentValue == $(selectId).options[i].value){
					$(selectId).options[i].show();
					$(selectId).options[i].disabled = false;
				}
			}
		}
	}
}
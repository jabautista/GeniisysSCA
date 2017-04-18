function filterVesselLOV(selectId, currentValue, lineCd){
	(($(selectId).childElements()).invoke("show")).invoke("removeAttribute", "disabled");
	for(var a = 0; a<objGIPIWItem.length; a++){
		if (objGIPIWItem[a].recordStatus != -1){
			var obj = new Object();
			if(lineCd == "MH") {
				obj = objGIPIWItem[a].gipiWItemVes;
			}
			if (obj != null){
				var cd = obj.vesselCd;	
				for(var i = 1; i < $(selectId).options.length; i++){ 
					if (cd == $(selectId).options[i].value){
						$(selectId).options[i].hide();
						$(selectId).options[i].disabled = true;
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
/*
 * Created By 	: Jerome Orio
 * Date			: 03.09.2011
 * Description	: Filter JSON LOV
 * Parameter	: selectId - select field id
 * 				: currentValue - select current value 
 * 				: objArray - JSON array to filter
 * 				: propertyName - property name for cd
 */ 
function filterJSONLOV(selectId, currentValue, objArray, propertyName){
	(($(selectId).childElements()).invoke("show")).invoke("removeAttribute", "disabled");
	for(var a = 0; a<objArray.length; a++){
		if (objArray[a].recordStatus != -1){
			if (objArray[a] != null){
				var cd = objArray[a][propertyName];	
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
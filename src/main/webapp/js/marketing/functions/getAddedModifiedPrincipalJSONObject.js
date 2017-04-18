function getAddedModifiedPrincipalJSONObject(){
	var tempObjArray = new Array();
	if (objGIPIQuote.objPrincipalArrayC != null || objGIPIQuote.objPrincipalArrayC != undefined){
		for(var i=0; i<objGIPIQuote.objPrincipalArrayC.length; i++) {	
			if (objGIPIQuote.objPrincipalArrayC[i].recordStatus == 0){
				tempObjArray.push(objGIPIQuote.objPrincipalArrayC[i]);
			}else if (objGIPIQuote.objPrincipalArrayC[i].recordStatus == 1){
				tempObjArray.push(objGIPIQuote.objPrincipalArrayC[i]);
			}
		}
	}
	if (objGIPIQuote.objPrincipalArrayP != null || objGIPIQuote.objPrincipalArrayP != undefined){
		for(var i=0; i<objGIPIQuote.objPrincipalArrayP.length; i++) {	
			if (objGIPIQuote.objPrincipalArrayP[i].recordStatus == 0){
				tempObjArray.push(objGIPIQuote.objPrincipalArrayP[i]);
			}else if (objGIPIQuote.objPrincipalArrayP[i].recordStatus == 1){
				tempObjArray.push(objGIPIQuote.objPrincipalArrayP[i]);
			}
		}
	}
	
	return tempObjArray;
}
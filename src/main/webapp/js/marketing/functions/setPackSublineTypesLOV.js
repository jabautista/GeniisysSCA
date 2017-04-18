/**
 * Sets list of values for Subline Types 
 * in Motor Car Additional Information
 */

function setPackSublineTypesLOV(sublineTypesLOV){
	var selSublineTypes = $("sublineType");
	selSublineTypes.update("<option></option>");
	
	for(var i=0; i<objPackQuoteList.length; i++){
		for(var c=0; c<sublineTypesLOV.length; c++){
			if(objPackQuoteList[i].sublineCd == sublineTypesLOV[c].sublineCd ){
				var sublineTypeObj = sublineTypesLOV[c];

				var sublineTypeOption = new Element("option");
				sublineTypeOption.innerHTML = sublineTypeObj.sublineTypeDesc;
				sublineTypeOption.setAttribute("sublineCd", sublineTypeObj.sublineCd);
				sublineTypeOption.setAttribute("value", sublineTypeObj.sublineTypeCd);
				selSublineTypes.add(sublineTypeOption,null);
			}
		}
	}
	
}
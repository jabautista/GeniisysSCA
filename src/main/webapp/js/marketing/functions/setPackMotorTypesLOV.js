/**
 * Sets list of values for motor types 
 * in Motor Car Additional Information
 */

function setPackMotorTypesLOV(motorTypesLOV){
	var selMotortype = $("motorType");
	var selUnladenWeight = $("unladenWeight");
	selMotortype.update("<option></option>");
	selUnladenWeight.update("<option></option>");

	for(var i=0; i<objPackQuoteList.length; i++){
		for(var c=0; c<motorTypesLOV.length; c++){
			if(objPackQuoteList[i].sublineCd == motorTypesLOV[c].sublineCd ){
				var motorTypeObj = motorTypesLOV[c];

				var motorTypeOption = new Element("option");
				motorTypeOption.innerHTML = motorTypeObj.motorTypeDesc;
				motorTypeOption.setAttribute("sublineCd", motorTypeObj.sublineCd);
				motorTypeOption.setAttribute("value", motorTypeObj.typeCd);
				selMotortype.add(motorTypeOption,null);

				var unladenWeightOption = new Element("option");
				unladenWeightOption.setAttribute("value", motorTypeObj.unladenWt);
				selUnladenWeight.add(unladenWeightOption,null);
			}
		}
	}
}
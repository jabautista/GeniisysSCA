function getItemInfoModuleId(lineCd){
	var moduleId;
	
	if(lineCd == "MC"){
		moduleId = "GICLS014";
	} else if(lineCd == "FI"){
		moduleId = "GICLS015";
	} else if(lineCd == "CA"){
		moduleId = "GICLS016";
	} else if(lineCd == "AC" || lineCd == "PA"){
		moduleId = "GICLS017";
	} else if(lineCd == "MN"){
		moduleId = "GICLS019";
	} else if(lineCd == "AV"){
		moduleId = "GICLS020";
	} else if(lineCd == "EN"){
		moduleId = "GICLS021";
	} else if(lineCd == "MH"){
		moduleId = "GICLS022";
	}
	
	return moduleId;
}
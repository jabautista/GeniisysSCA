function setEndtMHItemObject(newObj){	
	try{
		newObj.vesselCd 		= nvl($("vesselCd").value, null); 
		newObj.vesselFlag 		= null;
		newObj.vesselName 		= nvl($("vesselName").value, null);
		newObj.vesselOldName	= nvl($("vesselOldName").value, null); 
		newObj.vesTypeDesc 		= nvl($("vesTypeDesc").value, null); 
		newObj.propelSw			= nvl($("propelSw").value, null); 
		newObj.vessClassDesc 	= nvl($("vessClassDesc").value, null);
		newObj.hullDesc 		= nvl($("hullDesc").value, null); 
		newObj.regOwner 		= nvl($("regOwner").value, null);
		newObj.regPlace 		= nvl($("regPlace").value, null); 
		newObj.grossTon 		= nvl($("grossTon").value, null);
		newObj.yearBuilt 		= nvl($("yearBuilt").value, null); 
		newObj.netTon 			= nvl($("netTon").value, null); 
		newObj.noCrew 			= nvl($("noCrew").value, null);  
		newObj.deadWeight 		= nvl($("deadWeight").value, null);  
		newObj.crewNat 			= nvl($("crewNat").value, null);
		newObj.vesselLength 	= nvl($("vesselLength").value, null); 
		newObj.vesselDepth 		= nvl($("vesselDepth").value, null);  
		newObj.vesselBreadth 	= nvl($("vesselBreadth").value, null);
		newObj.dryPlace 		= nvl($("dryPlace").value, null);  
		newObj.dryDate 			= nvl($("dryDate").value, null);  
		newObj.geogLimit		= nvl($("geogLimit").value, null);
		return newObj;
	} catch(e){
		showErrorMessage("setEndtMHItemObject", e);
	}	
}
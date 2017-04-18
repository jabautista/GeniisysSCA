/*	Created by	: BJGA 12.15.2010
 * 	Description	: sets a  copied MH object's detailed block to null since duplication of vessel within a PAR is prohibited 
 */
function modifyObjWODetails(obj){
	if (objUWParList.lineCd == objLineCds.MH){
		obj.parId			= objUWParList.parId;
		if (obj.vesselCd == null){
			obj.vesselCd 		= null; 
			obj.vesselFlag 		= null;
			obj.vesselName 		= null;
			obj.vesselOldName	= null; 
			obj.vesTypeDesc 	= null; 
			obj.propelSw		= null; 
			obj.vessClassDesc 	= null;
			obj.hullDesc 		= null; 
			obj.regOwner 		= null;
			obj.regPlace 		= null; 
			obj.grossTon 		= null;
			obj.yearBuilt 		= null; 
			obj.netTon 			= null; 
			obj.noCrew 			= null;  
			obj.deadWeight 		= null;  
			obj.crewNat 		= null;
			obj.vesselLength 	= null; 
			obj.vesselDepth 	= null;  
			obj.vesselBreadth 	= null;
			obj.dryPlace 		= null;  
			obj.dryDate 		= null;
			obj.geogLimit		= null;
		}
	}
	return obj;
}
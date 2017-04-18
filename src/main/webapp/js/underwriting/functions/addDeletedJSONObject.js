function addDeletedJSONObject(objArray, deletedObj) {
	try{
		//deletedObj.recordStatus = -1;
		var removed = false;
		var forSplicing = [];
		//commented out & modified by BJGA 12.16.2010: to remove object from array even if not new during deletion process
		/*for (var i=0; i<objArray.length; i++) {
			if(objArray[i].recordStatus == 0 && objArray[i].itemNo == deletedObj.itemNo){			
				objArray.splice(i, 1);
				removed = true;
			}
		}
		if(!removed){
			objArray.push(deletedObj);
		}*/
		for (var i=0; i<objArray.length; i++) {		
			//if(/*(objArray[i].recordStatus != "") &&*/ (nvl(objArray[i].recordStatus, 0) != 0 && objArray[i].itemNo == deletedObj.itemNo)){
			//	//objArray.splice(i, 1); // commented by mark jm 03.29.2011 issue on insert-delete method			
			//	forSplicing.push(i);
			//	removed = true;
			//}else if(/*(objArray[i].recordStatus != "") &&*/ (objArray[i].recordStatus == "0" && objArray[i].itemNo == deletedObj.itemNo)){ //added second condition for newly-added record so no need to send object to database			
			//	//objArray.splice(i, 1); // commented by mark jm 03.29.2011 issue on insert-delete method			
			//	forSplicing.push(i);			
			//}
			
			if(objArray[i].itemNo == deletedObj.itemNo){
				forSplicing.push(i);				
				
				if(objArray[i].recordStatus != null && objArray[i].recordStatus != undefined){					
					removed = false;
				}else{					
					removed = true;	
				}				
			}
		}
		
		// sort the array & reverse it for deleting purpose		
		forSplicing = (forSplicing.sort()).reverse();
		
		for(var i=0, length=forSplicing.length; i < length; i++){			
			objArray.splice(forSplicing[i], 1);
		}
		
		if(removed){			
			deletedObj.recordStatus = -1;
			objArray.push(deletedObj);			
		}	
	}catch(e){
		showErrorMessage("addDeletedJSONObject", e);
	}	
}
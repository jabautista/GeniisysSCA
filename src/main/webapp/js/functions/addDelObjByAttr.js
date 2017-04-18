/*	Created by	: mark jm 10.20.2010
 * 	Description	: replace existing object to deleted object
 * 	Parameters	: objArray - object array that holds object listing
 * 				: deletedObj - object that will replace the existing one
 * 				: attributeList - space-separated string used for checking before replacing an object
 */
function addDelObjByAttr(objArray, deletedObj, attributeList){
	try{
		var equal = false;
		var removed = false;
		var hasAtrributes = false;
		var forSplicing = [];
		
		for(var i=0; i < objArray.length; i++) {
			var attList = $w(attributeList);
			
			if(objArray[i].recordStatus != 0 && objArray[i].itemNo == deletedObj.itemNo){
				equal = true;
				for(var x=0; x <attList.length; x++){
					hasAttributes = true;
					equal = equal && (objArray[i][attList[x]] == deletedObj[attList[x]] ? true : false);
				}
				
				if(equal && hasAttributes){
					forSplicing.push(i);
					removed = true;
				}
			}else if(objArray[i].recordStatus == 0 && objArray[i].itemNo == deletedObj.itemNo){
				equal = true;
				for(var x=0; x <attList.length; x++){
					hasAttributes = true;				
					equal = equal && (objArray[i][attList[x]] == deletedObj[attList[x]] ? true : false);
				}
				
				if(equal && hasAttributes){
					forSplicing.push(i);
				}
			}		
		}
		
		forSplicing = (forSplicing.sort()).reverse();
		
		for(var i=0, length=forSplicing.length; i < length; i++){			
			objArray.splice(forSplicing[i], 1);
		}
		
		if(removed){
			deletedObj.recordStatus = -1;
			objArray.push(deletedObj);
		}
	}catch(e){
		showErrorMessage("addDelObjByAttr", e);
		//showMessageBox("addDelObjByAttr : " + e.message);
	}		
}
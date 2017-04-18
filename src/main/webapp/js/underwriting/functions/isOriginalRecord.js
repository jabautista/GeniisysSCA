/*	Created by	: mark jm 11.19.2010
 * 	Description	: check if obj to be deleted existed
 * 				: in the original list of records
 * 	Parameters	: listing - EL object
 * 				: delObj - the object to be deleted
 * 				: attributeList - space-separated string containing the names for filtering 
 */
function isOriginalRecord(listing, delObj, attributeList){
	try{
		var objs = (JSON.parse(listing)).filter(function(obj){
			return obj.itemNo == delObj.itemNo;
		});
		
		var exist = false;

		for(var i=0, length=objs.length; i < length; i++){
			var attList = $w(attributeList);
			var apply = false;
			
			for(var x=0, y=attList.length; x < y; x++){
				if(objs[i][attList[x]] == delObj[attList[x]] ){					
					apply = true;
				}else{					
					apply = false;
				}
			}
			
			if(apply){
				exist = true;
				break;
			}
		}

		return exist;
	}catch(e){
		showErrorMessage("isOriginalRecord", e);
	}		
}
/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.13.2011	mark jm			check if all item has corresponding perils
 */
function isAllItemHasPerils(){
	try{
		var itemWithPeril = [];		
		var objArrFiltered = [];
		
		if(objGIPIWItemPeril.length > 0){
			objArrFiltered = objGIPIWItem.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	});
			
			for(var i=0, length=objArrFiltered.length; i<length; i++){
				var objArrPeril = objGIPIWItemPeril.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == objArrFiltered[i].itemNo;	});
				
				if(objArrPeril.length > 0){			
					itemWithPeril.push(objArrFiltered[i].itemNo);
				}
			}
			
			if(objArrFiltered.length == itemWithPeril.length){
				return true;
			}else{
				return false;
			}
		}else{
			return true;
		}		
	}catch(e){
		showErrorMessage("isAllItemHasPerils", e);
	}
}
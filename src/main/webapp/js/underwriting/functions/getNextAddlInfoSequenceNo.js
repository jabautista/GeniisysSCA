/*	Created by	: mark jm 02.24.2011
 * 	Description	: get the max itemNo + 1 on additional info table (subpages)
 */
function getNextAddlInfoSequenceNo(objArr, itemNo, column){
	try{
		var seq = 1;	
		var maxSeq = 0;
		
		if(objArr == null || objArr == undefined){
			return seq;
		}
		
		maxSeq = parseInt(objArr.max(function(item) {
			return nvl(item.recordStatus, 0) != -1 && parseInt(item.itemNo) == itemNo && parseInt(item[column]);
		}));
		
		if(!(isNaN(maxSeq))){
			if(maxSeq == 999999999){
				var previous = 0;
				var objFiltered;
				var objSorted;
				
				objFiltered = objArr.filter(function(item){
					return nvl(item.recordStatus, 0) != -1 && parseInt(item.itemNo) == itemNo;
				});
				
				objSorted = objFiltered.sort(function(prev, curr) {
					return parseInt(prev.itemNo) - parseInt(curr.itemNo);
				});
				
				for(var i=0, length=objSorted.length; i < length; i++){
					if((objSorted[i].itemNo - previous) == 1){
						previous = objSorted[i].itemNo;
					}else{
						seq = previous + 1;
						break;
					}
				}
			}else{
				seq = maxSeq + 1;
			}		
		}
		
		return seq;
	}catch(e){
		showErrorMessage("getNextAddlInfoSequenceNo", e);
	}	
}
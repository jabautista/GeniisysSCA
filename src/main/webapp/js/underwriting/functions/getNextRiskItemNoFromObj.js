/*	Created by	: mark jm 02.03.2011
 * 	Description	: get the max riskItemNo + 1 based on the given riskNo
 */
function getNextRiskItemNoFromObj(riskNo){	
	var riskItemNo = 1;
	
	var objArr = objGIPIWItem.filter(function(item){	return nvl(item.recordStatus, 0) != -1 && item.riskNo == riskNo; });
	
	if(objArr.length > 0){
		riskItemNo = parseInt(objArr.max(function(item){	return parseInt(nvl(item.riskItemNo, 0)); 	}));		
		if(!(isNaN(riskItemNo))){
			if(riskItemNo == 999999999){
				var previous = 0;
				var objNoNullRiskItemNo = objArr.filter(function(item){	return item.riskItemNo != null;	});
				var objSorted = objNoNullRiskItemNo.sort(function(prev, curr){	return parseInt(prev.riskItemNo) - parseInt(curr.riskItemNo);	});
				
				for(var i=0, length=objSorted.length; i < length; i++){					
					if((objSorted[i].riskItemNo - previous) == 1){
						previous = objSorted[i].riskItemNo;
					}else{
						riskItemNo = parseInt(previous) + 1;
						break;
					}
				}
			}else if(riskItemNo == 0){
				riskItemNo = "";
			}else{				
				riskItemNo = riskItemNo + 1;
			}		
		}else{
			riskItemNo = 1;
		}
	}else{
		riskItemNo = "";
	}
	
	return riskItemNo;
}
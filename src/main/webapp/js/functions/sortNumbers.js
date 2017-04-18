//sort the numbers in an array variable
function sortNumbers(param){
	var itemNos = param.trim().split(" ");		
	for(var index=0, len = itemNos.length; index < len; index++){
		for(var elem=0; elem < len; elem++){
			var temp = 0;
			if(parseInt(itemNos[elem]) > parseInt(itemNos[elem+1])){
				temp = itemNos[elem];
				itemNos[elem] = itemNos[elem+1];
				itemNos[elem+1] = temp;
			}
		}			
	}		
	return itemNos;
}
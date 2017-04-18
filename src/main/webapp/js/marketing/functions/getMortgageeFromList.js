/**
 * Retrieves the mortgagee
 * @param itemNo - can be set to null - when itemNo is null
 * @param mortgageeCd
 * @return mortgagee
 */
function getMortgageeFromList(itemNo, mortgageeCd){
	var mortgagee = null;
	
	for(var i=0; i<objGIPIQuoteMortgageeList.length;i++){
		var temp = objGIPIQuoteMortgageeList[i];
		if(itemNo==null){
			if(temp.mortgCd == mortgageeCd){
				mortgagee = temp;
			}
		}else{
			if(temp.itemNo == itemNo && temp.mortgCd == mortgageeCd){
				mortgagee = temp;
			}
		}
	}
	return mortgagee;
}
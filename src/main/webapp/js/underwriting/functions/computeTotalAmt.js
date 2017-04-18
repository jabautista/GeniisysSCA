/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	12.12.2011	mark jm			compute total amounts in object array (single column)
 */
function computeTotalAmt(objArray, filterFunc, amtColumn){
	try{
		if(objArray == null || objArray == undefined || objArray.length < 1){
			return "0.00";
		}
		
		var objPre = new Object();
		var objSca = new Object();
		var objArrTemp = [];
		var amount;
		
		objArrTemp = objArray.filter(filterFunc).slice(0);
		
		for(var i=0, length=objArrTemp.length; i < length; i++){
			
			if(objArrTemp[i][amtColumn] != null){
				amount = ((objArrTemp[i][amtColumn]).replace(/,/g, "")).split(".");
				objPre[i] = parseInt(amount[0]);
				objSca[i] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + (amount[1] == undefined ? 0 : amount[1]));
			}
		}
		
		return addSeparatorToNumber(addObjectNumbers(objPre, objSca), ",");
	}catch(e){
		showErrorMessage("computeTotalAmt", e);
	}
}
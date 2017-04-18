/**
 * Checks value of item no if valid
 * @param value - value of item no
 * 
 */

function verifyQuoteItemNo(value){
	
	if(value == ""){
		showMessageBox("Item No. is required.");
		return false;
	}else if(isNaN(parseFloat(value * 1)) || (value.indexOf(".") != -1)){
		showMessageBox("Field must be of form 00009");
		return false;
	}else{
		for(var i=0; i<objPackQuoteItemList.length; i++){
			if(parseInt(objPackQuoteItemList[i].itemNo)== parseInt(value) && objPackQuoteItemList[i].recordStatus != -1){
				showMessageBox("Item No must be unique.");
				return false;
			}
		}
	}
	return true;
}
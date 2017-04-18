/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	12.01.2011	mark jm			format date to mm-dd-yyyy format
 */
function formatDateToDefaultMask(value){
	try{
		var dateformatting = /^\d{1,2}(\-)\d{1,2}\1\d{4}$/; // format : mm-dd-yyyy
			 
		if((value != null && value != undefined && value != "") && !(dateformatting.test(value))){			 
			return dateFormat(value, "mm-dd-yyyy");
		}else{
			return value;
		}
	}catch(e){
		showErrorMessage("formatDateToDefaultMask", e);
	}
}
/*	Created by	: mark jm 04.07.2011
 * 	Description	: return the index of a select element based on the value to search
 * 	Parameters	: searchElement - id/name of the select field
 * 				: valueToSearch - kailangan pa bang i-define kung ano to?
 */
function getIndexInSelectListByValue(selectElement, valueToSearch){
	try{
		var index = 0;
		for(var i=0, length=$(selectElement).length; i < length; i++){
			if($(selectElement).options[i].value == valueToSearch){
				index = i;
				break;
			}
		}
		
		return index;
	}catch(e){
		showErrorMessage("getIndexInSelectListByValue", e);
	}
}
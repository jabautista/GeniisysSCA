/*	Created by	: mark jm 01.06.2011
 * 	Description	: set the selected value in select element
 * 	Parameters	: selectName - name/id of the select element
 * 				: combinationValue - combination of keys
 */
function setSelectOptionsValue(selectName, attr, value){	
	($$("select#" + selectName + " option[" + attr + "='" + value + "']"))[0].selected = true;
	/*for(var i=0, length=$(selectName).options.length; i < length; i++){
		if($(selectName).options[i].getAttribute(attr) == combinationValue){
			$(selectName).options[i].selected = true;
			selected = true;
			break;
		}
	}
	*/	
}
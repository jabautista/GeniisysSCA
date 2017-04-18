/*
 * Created by	: Jerome Orio
 * Date			: January 27, 2011
 * Description 	: to check if pre-text value is equal to the current value, return TRUE if changes exist
 * Parameters	: id - id 
 */
function checkIfValueChanged(id){
	if (getPreTextValue(id) == $(id).value){
		return false;
	}else{
		return true;
	}	
}
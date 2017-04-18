/*
 * Created By 	: andrew
 * Date			: 10.08.2010
 * Description	: Sets null value to object properties
 * Parameter	: obj - object to clear
 */ 
function clearObjectValues(obj) {
	for (var property in obj){		
		obj[property] = null;
	}
}
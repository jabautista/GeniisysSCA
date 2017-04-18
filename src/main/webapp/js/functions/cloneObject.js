/*	Created by	: mark jm 10.18.2010
 * 	Description	: returns a copy of an object
 * 	Parameter	: obj -  the object to be clone
 */
function cloneObject(obj){
	var cloneObj = new Object();
	
	for(attr in obj){
		cloneObj[attr] = obj[attr];
	}
	
	return cloneObj;
}
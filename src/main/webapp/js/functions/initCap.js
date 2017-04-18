/*	Created by	: mark jm 03.11.2011
 * 	Description	: change the first letter of every word like oracle's initcap function
 */
function initCap(str){
	var strArr = str.split(" ");
	var strResult = "";
	
	for(var i=0, length=strArr.length; i<length; i++){
		strResult = strResult + (strArr[i].charAt(0)).toUpperCase() + (strArr[i].substr(1, strArr[i].length - 1)).toLowerCase() + " ";
	}
	
	return strResult.trim();
}
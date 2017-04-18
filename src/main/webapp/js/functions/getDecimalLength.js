/*	Created by		: Anthony Santos
 * 	Date Created	: 01.5.2011
 * 	Description		: Gets the length of entered decimal place
 */
function getDecimalLength(m){
	var lengthVal = 0;
	lengthVal = (m.substr(m.indexOf("."), m.length)).length - 1;
	
	return lengthVal;
 }
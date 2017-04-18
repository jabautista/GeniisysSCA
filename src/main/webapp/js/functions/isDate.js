/*	Created by	: emman 04.13.2011 
 * 	Description	: checks if a string is in date format
 */
function isDate(dateStr){
	return (Date.parse(dateStr, "mm-dd-yyyy") != null);
}
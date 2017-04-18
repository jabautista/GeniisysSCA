/*
 * Created by 	: emman 09.27.2010
 * Description 	: Returns a number truncated to a certain number of decimal places.
 * 				  The same as the function TRUNC in PL/SQL
 * Parameters 	: num - The number to be truncated
 * 				  digits - Number of decimal places to be truncated 
 */
function truncateDecimal(num, digits) {
	var val = Math.pow(10,digits);
	return Math.floor(num*val)/val;
}
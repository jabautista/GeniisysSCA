/*
 * Created by 	: emman 09.27.2010
 * Description 	: Returns a number rounded to a certain number of decimal places.
 * 				  The same as the function ROUND in PL/SQL
 * Parameters 	: num - The number to be rounded
 * 				  digits - Number of decimal places to be rounded 
 */
function roundNumber(num, digits) {
	var val = Math.pow(10,digits);
	return Math.round(num*val)/val;
}
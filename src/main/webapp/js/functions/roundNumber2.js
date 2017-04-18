/*
 * Created by 	: robert 03.16.2016 - SR 21760
 * Description 	: Returns a number rounded to a certain number of decimal places.
 * 				  Handled bug in rounding off negative value
 * Parameters 	: num - The number to be rounded
 * 				  digits - Number of decimal places to be rounded 
 */
function roundNumber2(num, digits) {
	var sign = num > 0 ? 1 : num < 0 ? -1 : 0;
	var abs = Math.abs(num);
	var val = Math.pow(10,digits);
	return Math.round(abs*val)/val * sign;
}
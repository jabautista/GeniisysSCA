/**
 * Created by: Jed 11.19.2013
 * Description: Returns a number rounded to a certain number of decimal places. Created for Peril Distribution error SR13710.
 * Parameters: val - the number to be rounded
 *             num - Number of decimal places to be rounded
 */
function acceptedRound(val, num){
	rounded = Math.round(val * 100) / 100;
	return parseFloat(rounded).toFixed(num);
}
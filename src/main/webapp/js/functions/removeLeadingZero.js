/**
 * Removes the leading zeroes from a given number
 * @author andrew - 04.01.2011
 * @param num - number with leading zeroes
 * @returns num
 */
function removeLeadingZero(num){
	while(num.substring(0, 1) == '0' && num.substring(1, 2) != '.'){
		if(num.length == 1){
			break;
		} else {
			num = num.substring(1, num.length);
		}
	}
	return num;
}
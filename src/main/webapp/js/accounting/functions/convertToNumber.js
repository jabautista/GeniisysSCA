function convertToNumber(str) {
	var num = 0;
	var strNum;

	num = parseFloat(str);
	strNum = num + '';

	if (strNum != str) {
		num += 0.00; // from 0.01 set to 0.00 - christian 09242012
	}

	return num;
}
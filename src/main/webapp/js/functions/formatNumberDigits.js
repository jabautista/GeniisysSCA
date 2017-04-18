//format the integer
//parameter: 
//number: name of the input item
//digits: size to be format
//return: formatted integer
function formatNumberDigits(number, digits){
	try{
		number = number + '';
		var diff = digits - number.length;
		var formattedNumber = "";

		for(var i = 0; i < diff; i++){
			formattedNumber += "0";
		} 

		formattedNumber += number;

		return formattedNumber;
	}catch(e){
		showErrorMessage("formatNumberDigits",e);
	}
}
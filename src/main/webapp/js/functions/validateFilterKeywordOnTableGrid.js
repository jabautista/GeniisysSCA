/** Validate the data type of the keyword entered for tablegrid filter 
*@author Veronica V. Raymundo 02.10.2011
*@param filterOption - filter option text
*@param optionType - required data type of the selected filter option
*@param keyWord - keyword entered in filter box
*/

function validateFilterKeywordOnTableGrid(filterOption, optionType, keyWord){
	var isValid = true;
	//keyWord = nvl(keyWord,null) == null ? "" :keyWord.toString().replace(/\$|\,/g,''); //added by nok 12.09.11
	keyWord = nvl(keyWord,null) == null ? "" :keyWord.toString().replace(/\,/g,''); // modified by andrew 9.4.2013 - removed $
	if(optionType == 'number' && (isNaN(keyWord) || (keyWord.strip()).indexOf("e") != -1)){
		showMessageBox(filterOption + " must be a number.");
		isValid = false;
	}else if(optionType == 'numberNoNegative' && (isNaN(keyWord) || keyWord < 0 || (keyWord.strip()).indexOf("e") != -1)){
		showMessageBox(filterOption + " must be a non-negative number.");
		isValid = false;
	}else if(optionType == 'integer' && (isNaN(keyWord)|| (keyWord.strip()).indexOf(".") != -1 || (keyWord.strip()).indexOf("e") != -1)){
		showMessageBox(filterOption + " must be an integer.");
		isValid = false;
	//}else if(optionType == 'integerNoNegative' && (isNaN(keyWord)|| (keyWord.strip()).indexOf(".") != -1 || keyWord < 0 || (keyWord.strip()).indexOf("e") != -1)){
	// mark jm 12.14.2011 replace condition with a regular expression
	}else if(optionType == 'integerNoNegative' && !(RegExWholeNumber.pWholeNumber.test(keyWord))){
		showMessageBox(filterOption + " must be a non-negative integer.");
		isValid = false;
	}else if(optionType == 'formattedDate' && !(checkDate2(keyWord))) {
		//error messages are handled in function checkDate2
		isValid = false;
	}else if(optionType == 'formattedHour' && !(IsValidFilterTime(keyWord))){
		isValid = false;
	}else if(optionType == 'checkbox' && (keyWord.toUpperCase() != "Y" && keyWord.toUpperCase() != "N")){ //shan 02.19.2014 : added toUpperCase
		showMessageBox(filterOption + " must be Y / N.");
		isValid = false;
	} else if (optionType == 'percentType' && (isNaN(keyWord) || keyWord < 0 || keyWord > 100)){ //daniel marasigan 03.06.2017, added for validation of percent rates SR 5941
		showMessageBox(filterOption + ' must be a non negative number and is less than or equal to 100');
		isValid = false;
	}
	return isValid;
}
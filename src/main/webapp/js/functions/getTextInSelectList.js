//Created by mark jm 09.14.2010
//This function returns the text from a select element according to the value
//Parameter: selectElement - the name of the select element
//			: valueToSearch - the value you want to search if it exist in the select list
function getTextInSelectList(selectElement, valueToSearch){
	var optionText = "";
	var optionValue = "";
	
	for(var index=0, length=$(selectElement).length; index < length; index++){
		optionValue = ($(selectElement).options[index]).getAttribute("value");
		if(optionValue == valueToSearch){
			optionText = $(selectElement).options[index].text;
			break;
		}
	}
	
	return optionText;	
}
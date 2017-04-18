// Created by mark jm 06.15.2010
// This function returns the index from a select element according to the text
// Parameter: selectElement - the name of the select element
//			: textToSearch - the text you want to search if it exist in the select list
function getIndexInSelectList(selectElement, textToSearch){
	var optionText = "";
	var optionIndex = -1;
	
	for(var index=0, length = $(selectElement).length; index < length; index++){
		optionText = $(selectElement).options[index].text;
		if(optionText == textToSearch){
			optionIndex = index;
			break;
		}
	}
	
	return optionIndex;
}
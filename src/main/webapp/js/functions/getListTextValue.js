//get the text of a selected option in list, instead of its value
//parameter: listName Name of the list element
function getListTextValue(listName) {
	return $(listName).options[$(listName).selectedIndex].text;
}
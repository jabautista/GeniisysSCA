//get the attibute value of a selected option in list, instead of its value
//parameter: listName - Name of the list element 
//		   & attrName - name of the attribute
//jerome orio 11.11.2010
function getListAttributeValue(listName,attrName) {
	return $(listName).options[$(listName).selectedIndex].getAttribute(attrName);
}
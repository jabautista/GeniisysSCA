/*
 * Created by	: Emman
 * Date			: January 31, 2011
 * Description 	: to clear the contents of a list
 * Parameters	: listName = id of the list to be cleared
 */
function clearListing(listName) {
	/*$(listName).innerHTML = "";

	var newOption = new Element("option");
	newOption.text = "";
	newOption.value = "";

	try {
	    $(listName).add(newOption, null); // standards compliant; doesn't work in IE
	  }
	catch(ex) {
	    $(listName).add(newOption); // IE only
	}*/
	
	// the following codes are used to clear options fast
	
	var selectObj = document.getElementById(listName);
	var selectParentNode = selectObj.parentNode;
	var newSelectObj = selectObj.cloneNode(false); // Make a shallow copy
	selectParentNode.replaceChild(newSelectObj, selectObj);

	var newOption = new Element("option");
	newOption.text = "";
	newOption.value = "";

	try {
	    $(listName).add(newOption, null); // standards compliant; doesn't work in IE
	  }
	catch(ex) {
	    $(listName).add(newOption); // IE only
	}
}
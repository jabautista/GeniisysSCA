/*
 * Created by	: Emman
 * Date			: February 24, 2011
 * Description 	: populate a listing with a single value, used for display purposes only
 * Parameters	: id - id field
 */
function populateListingWithSingleValue(listName, val) {
	clearListing(listName);

	newOption = new Element("option");
	newOption.text = val;
	newOption.value = val;

	try {
	    $(listName).add(newOption, null); // standards compliant; doesn't work in IE
	  }
	catch(ex) {
	    $(listName).add(newOption); // IE only
	}
	$(listName).value = val;
}
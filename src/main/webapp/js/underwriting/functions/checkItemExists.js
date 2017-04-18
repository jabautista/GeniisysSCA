//mark jm 09.03.2010
//This function returns true if item number exist in listing otherwise, false
//Parameter 	:	itemListingToSearch - list of numbers to search for
//				:	itemToSearch - number to search in listing
function checkItemExists(itemListingToSearch, itemToSearch){
	if(itemListingToSearch.indexOf(itemToSearch) < 0){
		return false;
	}else{
		return true;
	}
}
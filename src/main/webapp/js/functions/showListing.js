//created by: Jerome Orio
//show the all listing options in a select item
//parameter: name of select list
function showListing(listName){
	var list = listName.options;	
	list.selectedIndex = 0;
	for(var i = 1; i < list.length; i++){ 
		list[i].show();
		list[i].disabled = false;
	}
}
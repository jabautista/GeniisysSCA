//created by: Jerome Orio
//hide the all listing options in a select item
//parameter: name of select list
function hideListing(listName){
	var list = listName.options;	
	list.selectedIndex = 0;
	for(var i = 1; i < list.length; i++){ 
		list[i].hide();
		list[i].disabled = true;
	}
}
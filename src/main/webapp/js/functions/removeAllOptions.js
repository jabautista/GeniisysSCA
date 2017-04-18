//remove all options for select box. irwin
function removeAllOptions(selectbox){
	var i;
	for(i=selectbox.options.length-1;i>=0;i--) {
		selectbox.remove(i);
	}
}
/**
 * Check if an element is visible
 * @param elementId
 * @return
 */
function isVisible(elementId){
	var style = $(elementId).style;
	if(style.search("display:none;") != -1){
		return false;
	}else{
		return true;
	}
}
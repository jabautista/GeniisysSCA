/*
 * Create by	: Andrew
 * Date			: October 18, 2010
 * Description	: Clears the changed attribute of the elements in a specified div container
 * Parameter	: Id of div container
 */
function clearChangeAttribute(divId){
	$(divId).descendants().each(function(element) {
		if(element.hasAttribute("changed")) {
			element.removeAttribute("changed");
		}
	});
}
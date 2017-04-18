// Add style and behavior to newly created input
// parameter: the newly created element itself
function addStyleToNewElement(element) {
	element.observe("focus", function ()	{
		element.addClassName("textFocused");
	});
	
	element.observe("blur", function ()	{
		element.removeClassName("textFocused");
	});
}
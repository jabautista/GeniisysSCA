function hideElementClass(className){
	$$("div." + className).each(function(element){
		element.hide();
	});
}
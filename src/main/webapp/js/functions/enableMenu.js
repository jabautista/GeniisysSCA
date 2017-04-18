/*
 * Created by	: Andrew
 * Date			: September 28, 2010
 * Description	: Enables a menu 
 * Parameters	: menuId - Id of the menu element
 */
function enableMenu(menuId){	
	$(menuId).show();
	if($(menuId).next("a") != undefined){
		$(menuId).next("a").remove();
	}	
	if($(menuId).next("ul") != undefined) {
		$(menuId).next("ul").childElements().each(function(li){
			li.show();
		});
	}	
}
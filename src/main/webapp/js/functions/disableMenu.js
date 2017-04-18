/*
 * Created by	: Andrew
 * Date			: September 27, 2010
 * Description	: Disables a menu 
 * Parameters	: menuId - Id of the menu element
 */
function disableMenu(menuId){
	try {
		if ($(menuId).next("a") == undefined) {
			var alter = new Element("a");
			alter.update($(menuId).innerHTML);
			alter.setStyle("color: #B0B0B0;");
			alter.addClassName("disabledMenu");
			$(alter).childElements().each(function(img){ //added by Nok to hide arrow down img on disable
				img.hide();
			});
			$(menuId).insert({after : alter});
			$(menuId).hide();
			if($(menuId).next("ul") != undefined) {
				$(menuId).next("ul").childElements().each(function(li){
					li.hide();
				});
			}			
		}
	} catch (e) {
		var message = e.message;
		if(message.include("is null")){			
			e.message = menuId + " is null";
		}
		showErrorMessage("disableMenu", e);
	}
}
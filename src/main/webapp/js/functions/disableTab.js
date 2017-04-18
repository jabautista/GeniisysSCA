/*
 * Created by	: Andrew
 * Date			: 10.12.2010
 * Description	: Sets style of toolbar button to disabled.
 * Parameters	: buttonId - Id of the button element
 */
function disableTab(tabId) {
	var alter = new Element("label");
	alter.update($(tabId).innerHTML);
	alter.setStyle("color: #B0B0B0;");
	alter.id = tabId + "Disabled";
	$(tabId).insert({after: alter});
	$(tabId).hide();
}
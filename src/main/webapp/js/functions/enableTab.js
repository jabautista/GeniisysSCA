/*
 * Created by	: Andrew
 * Date			: 10.12.2010
 * Description	: Sets style of toolbar button to enabled.
 * Parameters	: buttonId - Id of the button element
 */
function enableTab(tabId) {
	$(tabId).setStyle({color: ""});
	$(tabId + "Alter").remove();
	$(tabId).show();
}
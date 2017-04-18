/*
 * Created by	: Jerome Orio
 * Date			: February 08, 2011
 * Description 	: To show confirmation if changes exist before reloading form
 * Parameters	: id - id of reload form
 * 				: func - function to call on reloading
 */
function observeReloadForm(id, func){
	$(id).stopObserving("click");
	$(id).observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
					func, "");
		} else {
			func();
		}
	});
}
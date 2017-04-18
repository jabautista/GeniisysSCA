/*
 * Created by	: Jerome Orio
 * Date			: February 08, 2011
 * Description 	: To show confirmation if changes exist
 * Parameters	: saveFunc - function to call on saving
 * 				: cancelFunc - function to call on cancel
 * 				: id - id
 */
function observeCancelForm(id, saveFunc, cancelFunc){
	$(id).stopObserving("click");
	$(id).observe("click", function ()	{
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){saveFunc(); if (changeTag == 0){cancelFunc();}}, 
					function(){changeTag=0; cancelFunc();},
					"");
		} else {
			cancelFunc();
		}
	});
}
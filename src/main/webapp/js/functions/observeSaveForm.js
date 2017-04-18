/*
 * Created by	: Jerome Orio
 * Date			: February 08, 2011
 * Description 	: To show confirmation if changes exist
 * Parameters	: saveFunc - function to call on saving
 * 				: id - id
 */
function observeSaveForm(id, saveFunc){
	$(id).stopObserving("click");
	$(id).observe("click", function ()	{
		if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;}
		saveFunc();
	});
}
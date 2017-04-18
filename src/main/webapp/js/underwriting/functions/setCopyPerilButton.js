/*
 * Created by	: Bryan
 * Date			: October 22, 2010
 * Description	: Sets whether the btnCopyPeril will be disabled or not depending on the count of items
 */
function setCopyPerilButton(){
	if (countItems() > 1){
		enableButton("btnCopyPeril");
	} else {
		disableButton("btnCopyPeril");
	}
}
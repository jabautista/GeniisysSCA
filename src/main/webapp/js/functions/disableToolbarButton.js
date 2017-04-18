/**
 * To disable the Tool bar button
 * @author andrew robes
 * @date 02.28.2013
 */
function disableToolbarButton(id){
	try{
		$(id).hide();
		$(id+"Disabled").show();
	} catch (e){
		showErrorMessage("disableToolbarButton", e);
	}
}
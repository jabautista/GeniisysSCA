/**
 * To enable the Tool bar button
 * @author andrew robes
 * @date 02.28.2013
 */
function enableToolbarButton(id){
	try{
		$(id+"Disabled").hide();
		$(id).show();
	} catch (e){
		showErrorMessage("enableToolbarButton", e);
	}
}
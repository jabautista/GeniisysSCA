/**
 * To show the Tool bar button
 * @author andrew robes
 * @date 04.26.2013
 */
function showToolbarButton(id){
	try{
		$(id).up("div", 0).show();
		$(id+"Sep").show();
	} catch (e){
		showErrorMessage("enableToolbarButton", e);
	}
}
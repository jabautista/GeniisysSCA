/**
 * To hide the Tool bar button
 * @author andrew robes
 * @date 04.26.2013
 */
function hideToolbarButton(id){
	try{
		$(id).up("div", 0).hide();
		if($(id+"Sep")) {
			$(id+"Sep").hide();
		}
	} catch (e){
		showErrorMessage("hideToolbarButton", e);
	}
}
/**
 * Shows Branch Maintenance module
 * 
 * @author andrew robes
 * @date 8.8.2013
 * 
 */
function showGiacs303() {
	try {
		new Ajax.Request(
				contextPath + "/GIACBranchController",
				{
					parameters : {
						action : "showGiacs303"
					},
					onCreate : showNotice("Retrieving Branch Maintenance, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							hideAccountingMainMenus();
							$("mainContents").update(response.responseText);
							$("acExit").show();
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGiacs303", e);
	}
}
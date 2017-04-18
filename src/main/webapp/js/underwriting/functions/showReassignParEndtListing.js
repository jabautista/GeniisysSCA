/**
 * Shows Reassign Par Endorsement page
 *  @author Steven Ramirez
 */
function showReassignParEndtListing(){
	try {
		new Ajax.Request(contextPath+"/GIPIReassignParEndtController?action=getReassignParEndtListing",{
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Getting Reassign Par Endorsement list, please wait...");
			},
			onComplete: function (response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e){
		showErrorMessage("showReassignParEndtListing", e);
	}
}
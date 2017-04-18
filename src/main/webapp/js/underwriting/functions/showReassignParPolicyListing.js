/**
 * Shows Reassign Par Policy page
 *  @author Steven Ramirez
 */
function showReassignParPolicyListing(){
	try {
		new Ajax.Request(contextPath+"/GIPIReassignParPolicyController?action=showReassignParPolicyListing",{
			parameters:{
				ajax: 1,
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Getting Reassign Par Policy list, please wait...");
			},
			onComplete: function (response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e){
		showErrorMessage("showReassignParPolicyListing", e);
	}
}
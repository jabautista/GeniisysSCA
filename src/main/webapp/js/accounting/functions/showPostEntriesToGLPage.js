/**
 * Shows Post Entries to the General Ledger page Module: GIACS410
 * 
 * @author skbati 05.24.2013
 */
function showPostEntriesToGLPage() {
	try {
		new Ajax.Request(contextPath + "/GIACPostEntriesToGLController", {
			method : "POST",
			parameters : {
				action : "showPostEntriesToGL"
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function() {
				showNotice("Loading Post Entries to GL Page....");
			},
			onComplete : function(response) {
				hideNotice();
				$("dynamicDiv").update(response.responseText);
			}
		});
	} catch (e) {
		showErrorMessage("showPostEntriesToGL", e);
	}
}
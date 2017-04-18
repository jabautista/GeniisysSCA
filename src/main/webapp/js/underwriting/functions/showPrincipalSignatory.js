/**
 * Principal Signatory Section
 * @author Irwin C.Tabisora
 * */

function showPrincipalSignatory(callingForm, assdNo, assdName){ // Nica 05.25.2012 - added parameter callingForm, assdNo, assdName
	
	try {
		//var replaceDiv = mode == "0" ? "parInfoDiv" : "mainContents";
		//showInspectionReport(); //temporary
		var replaceDiv = callingForm == "GIIMM011" ? "quoteInfoDiv" : (callingForm == "GIPIS017" ? "parInfoDiv" :"mainContents");
		
		new Ajax.Request(contextPath+"/GIISPrincipalSignatoryController",{
			parameters: {
				action: "showPrincipalSignatory",
				callingForm: nvl(callingForm, "") == "" ? "GIPIS000" : callingForm,
				assdNo: assdNo,
				assdName: escapeHTML2(assdName)  //escapeHTML2 added by jeff 04.30.2013 for reloading 
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete : function(response) {
				hideNotice("");
				$(replaceDiv).update(response.responseText);
			}	
		});
	} catch (e){
		showErrorMessage("showPrincipalSignatory", e);
	}
}
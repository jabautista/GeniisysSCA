// function to be called by all Maintain Assured button from any module
// parameters: 
// mainDiv: main div of the module
// assdNo: id of the assured to be edited, could be null if you are just going to add an assured
// whofeih - 06.23.2010
/*
 * modified by andrew - 03.02.2011
 * added viewOnly parameter 
 */
function maintainAssured(mainDiv, assdNo, viewOnly) {
	try {
		var url = contextPath+"/GIISAssuredController?action=maintainAssured&assuredNo="+assdNo+"&divToShow="+mainDiv;
		if ($("assuredDiv").innerHTML.blank() || url != $("assuredDiv").readAttribute("src")) {
			$("assuredDiv").writeAttribute("src", url);
			Effect.Fade(mainDiv, {
				duration: .001,
				beforeFinish: function () {
					Effect.Appear("assuredDiv", {duration: .001});
					new Ajax.Updater("assuredDiv", url, {
						method: "GET",
						evalScripts: true,
						asynchronous: true,
						onCreate: function () {
							var message = assdNo.blank() ? "Creating assured form, please wait..." : "Getting assured information, please wait...";
							showLoading("assuredDiv", "Getting assured information, please wait...", "150px");
						},
						onComplete: function (response)	{
							if(checkErrorOnResponse(response)){
								if(viewOnly){
									$("hidViewOnly").value = viewOnly;
								}
								Effect.Appear($("assuredDiv").down("div", 0), {
									duration: .001,
									afterFinish: function () {
										//initializeAccordion();
										addStyleToInputs();
										//initializeAll();
									}
								});
							}
						}
					});
				}
			});
		} else {
			Effect.Fade(mainDiv, {duration: .001});
			Effect.Appear("assuredDiv", {duration: .001});
		}
	} catch (e) {
		showErrorMessage("maintainAssured", e);
	}
}
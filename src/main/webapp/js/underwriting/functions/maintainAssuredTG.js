function maintainAssuredTG(mainDiv, assdNo, viewOnly, showCreateNew) {
	try {
		var url = contextPath+"/GIISAssuredController?action=maintainAssured2&assuredNo="+assdNo+"&divToShow="+mainDiv;
		if ($("assuredTGDiv").innerHTML.blank() || url != $("assuredTGDiv").readAttribute("src")) {
			Effect.Fade(mainDiv, {
				duration: .001,
				beforeFinish: function () {
					Effect.Appear("assuredTGDiv", {duration: .001});
					new Ajax.Updater("assuredTGDiv", url, {
						method: "GET",
						evalScripts: true,
						asynchronous: true,
						onCreate: function () {
							var message = assdNo == "" ? "Creating assured form, please wait..." : "Getting assured information, please wait...";
							showLoading("assuredTGDiv", "Getting assured information, please wait...", "150px");
						},
						onComplete: function (response)	{
							if(checkErrorOnResponse(response)){
								if(viewOnly){
									$("hidViewOnly").value = viewOnly;
								}
								Effect.Appear($("assuredTGDiv").down("div", 0), {
									duration: .001,
									afterFinish: function () {
										//initializeAccordion();
										addStyleToInputs();
										//initializeAll();
										if(nvl(showCreateNew, false)){
											if($("assuredMaintenanceAdd") != null){
												$("assuredMaintenanceAdd").show();
											}
										}
									}
								});
							}
						}
					});
				}
			});
		} else {
			Effect.Fade(mainDiv, {duration: .001});
			Effect.Appear("assuredTGDiv", {duration: .001});
		}
	} catch (e) {
		showErrorMessage("maintainAssuredTG", e);
	}
}
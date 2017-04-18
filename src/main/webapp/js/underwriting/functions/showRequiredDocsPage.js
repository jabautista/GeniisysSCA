function showRequiredDocsPage(){
	var parStatus = parseFloat($F("globalParStatus"));
	if (parStatus < 3){
		showMessageBox("This menu is not yet accessible due to selected PAR status.", imgMessage.ERROR);
		return false;
	} else {
		/*Effect.Fade($("mainContents").down(), {
			duration: .5,
			beforeFinish: function ()	{*/
				new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWRequiredDocumentsController?action=showRequiredDocsPage&globalParId="
						+$F("globalParId")+"&globalLineCd="+$F("globalLineCd")+"&globalSublineCd="+$F("globalSublineCd")+"&ajax="+1,{
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					//postBody: Form.serialize("uwParParametersForm"),
					onCreate: showNotice("Getting Required Documents page, please wait..."),
					onComplete: function () {
						try {
							hideNotice("");
							Effect.Appear($("parInfoDiv").down("div", 0), {
								duration: .001
								,
								afterFinish: function () {
									updateParParameters();
								}
							});
							setDocumentTitle("Required Documents Submitted");
						} catch (e) {
							showErrorMessage("showRequiredDocsPage", e);
						}
					}
				});
			/*}
		});*/
	}
}
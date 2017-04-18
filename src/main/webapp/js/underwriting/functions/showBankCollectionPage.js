function showBankCollectionPage(){
	var lineCd = $F("globalLineCd");
	var sublineCd = $F("globalSublineCd");
	if (("CA" != lineCd) || ("BBI" != sublineCd)){
		showMessageBox("You cannot access this menu.", imgMessage.ERROR);
		return false;
	} else {
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWBankScheduleController?action=showBankCollectionPage&"+Form.serialize("uwParParametersForm"),{
			method:"GET",
			evalScripts:true,
			asynchronous: true,
			onCreate: function() {
				showNotice("Getting bank collection page, please wait...");
			},
			onComplete: function () {
				updateParParameters();
				Effect.Appear($("parInfoDiv").down("div", 0), {duration: .001});
				setDocumentTitle("Bank Collection");
				hideNotice();
			}
		});	
	}
}
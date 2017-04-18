function showPerilInfoPage(){
	
	var parStatus = parseFloat($F("globalParStatus"));
	
	if (parStatus < 4){
		showMessageBox("This menu is not yet accessible due to selected PAR status.", imgMessage.ERROR);
	}
	else {
		setDocumentTitle("Peril Information");
		Effect.Fade($("mainContents").down(), {
			duration: .001,
			beforeFinish: function () {
				new Ajax.Updater("mainContents", contextPath+"/GIPIWItemPerilController?action=showPerilInfoPage&"+Form.serialize("uwParParametersForm"),{
					method:"GET",
					evalScripts:true,
					asynchronous: true,
					onCreate: showNotice("Getting Peril Information page, please wait..."),
					onComplete: function () {
						updateParParameters();
						Effect.Appear($("mainContents").down(), {duration: .001});
						hideNotice();
					}
				});
			}
		});
	}
}
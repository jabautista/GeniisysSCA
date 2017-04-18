function showMaintainReasonFormTableGrid() {
	
	try{
		Effect.Fade("contentsDiv", {
			duration: .001,
			beforeFinish: function() {
				Effect.Appear("assuredDiv", {duration: .001});
				new Ajax.Updater("assuredDiv", contextPath + "/GIISLostBidController?action=showReasonMaintenanceTableGrid&ajax=1", {
					method: "GET",
					asynchronous: true,
					evalScripts: true,
					onCreate : showNotice("Getting reasons, please wait..."),
					onComplete : function() {
						hideNotice("");
						Effect.Appear("maintainReasonTableGridSectionDiv", {
							duration : .001
						});
					}
				});
				hideNotice("");
			}
		});
	}catch(e){
		showErrorMesssage("showMaintainReasonFormTableGrid", e);
	}
		
	
}
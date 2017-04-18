function showPackPARCreationPage(lineCd){
	//Effect.Fade("mainContents", {
		//duration: .001,
		//beforeFinish: function ()	{commented by: nica 01.10.2011
			
			new Ajax.Updater("mainContents", contextPath+"/GIPIPackPARListController?action=showPackPARCreationPage&lineCd="+nvl(lineCd, ""),{
				method:"GET",
				evalScripts:true,
				asynchronous: true,
				onCreate: showNotice("Getting Package PAR Creation page, please wait..."),
				onComplete: function () {
					hideNotice("");
					//$("underwritingMainMenu").hide();
					//$("underwritingPARMenu").show();
					initializeMenu();
					Effect.Appear($("mainContents").down("div", 0), {
						duration: .001
					});
					setDocumentTitle("Package PAR Creation");
					//Effect.Appear("packParInformation", {duration: .001});
				}
			});
		//}
	//});	
}
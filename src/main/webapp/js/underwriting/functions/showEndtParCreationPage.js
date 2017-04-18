//cris 04/14/2010 modified by: nica 
function showEndtParCreationPage(lineCd){
	//Effect.Fade("mainContents", {
	//	duration: .001,
	//	beforeFinish: function ()	{
			new Ajax.Updater("mainContents", contextPath+"/GIPIPARListController?action=showEndtPARCreationPage&lineCd="+nvl(lineCd, ""),{
				method:"GET",
				evalScripts:true,
				asynchronous: true,
				onCreate: showNotice("Getting Endorsement PAR Creation page, please wait..."),
				onComplete: function () {
					hideNotice("");
					$("parTypeFlag").value = "E";
					//$("underwritingMainMenu").hide();
					//$("underwritingPARMenu").show();
					initializeMenu();
					Effect.Appear("mainContents", {
						duration: .001
					});
					setDocumentTitle("PAR Creation");
				}
			});
		//}
	//});	
}
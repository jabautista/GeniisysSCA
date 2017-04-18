//bry 01.06.10
function showPARCreationPage(lineCd) {
	new Ajax.Updater("mainContents", contextPath+"/GIPIPARListController?action=showPARCreationPage&lineCd="+nvl(lineCd, ""),{
		method:"GET",
		evalScripts:true,
		asynchronous: true,
		onCreate: showNotice("Getting PAR Creation page, please wait..."),
		onComplete: function () {
			hideNotice("");
			$("parTypeFlag").value = "P";
			//$("underwritingMainMenu").hide();
			//$("parMenu").hide();
			//$("parListingMenu").show();
			//initializeMenu();
			Effect.Appear($("mainContents").down("div", 0), {
				duration: .001
			});
			setDocumentTitle("PAR Creation");
		}
	});
		/*}
	});*/
}
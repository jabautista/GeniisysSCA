function showParListing(riSwitch) {
	try {
		var lineCd = $("globalLineCd") == null ? objUWGlobal.lineCd : $F("globalLineCd");
		var lineName = $("globalLineName") == null ? objUWGlobal.lineName : $F("globalLineName");
		
		/*updateMainContentsDiv("/GIPIPARListController?action=showParListing&ajax=1&lineCd="+lineCd+"&lineName="+lineName,
				  "Getting PAR listing, please wait...",
				  goToPageNo,
				  ["parListingTable", "/GIPIPARListController?lineCd="+lineCd, "filterParListing", 1]); 
		// replaced by: nica 02.11.2011
		updateMainContentsDiv("/GIPIPARListController?action=showParListTableGrid&ajax=1&lineCd="+lineCd+"&lineName="+lineName,
				  "Getting PAR listing, please wait...",
				  function(){},[]);
		//setDocumentTitle("Policy Action Records");
		initializeMenu();*/
		
		setCursor("wait");
		Effect.Fade("parInfoDiv", {
			duration: .001,
			afterFinish: function () {
				setCursor("default");
				$("parInfoMenu").hide();		
				$("parListingMainDiv").show();
				setDocumentTitle("PAR Listing - Policy");
				setModuleId("GIPIS001");
				if(!creationFlag){
					parTableGrid.clear();
					parTableGrid.refresh();
					clearObjectValues(objUWParList);
					clearObjectValues(objGIPIWPolbas);
				}else{
					updateMainContentsDiv("/GIPIPARListController?action=showParListTableGrid&ajax=1&lineCd="+lineCd+"&lineName="+lineName+"&riSwitch="+riSwitch,
							  "Getting PAR listing, please wait...",
							  function(){},[]);
					creationFlag = false;
				}
				$("parExit").stopObserving("click");
				observeGoToModule("parExit", goBackToParListing);
				selectedIndex = -1;
				objGIPIS130.details = null;
				objGIPIS130.distNo = null;
				objGIPIS130.distSeqNo = null;
			}
		});
		
	} catch (e) {
		showErrorMessage("showParListing", e);
	}
}
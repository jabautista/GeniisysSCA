function showPackParListing(riSwitch){ // andrew - 07.08.2011 - added riSwitch parameter
	try{
		var lineCd = objUWGlobal.lineCd;
		var lineName = objUWGlobal.lineName;
		setCursor("wait");
		Effect.Fade("parInfoDiv", {
			duration: .001,
			afterFinish: function () {
				setCursor("default");
				$("parInfoMenu").hide();		
				$("packParListingTableGridMainDiv").show();
				setDocumentTitle("Package PAR Listing - Policy");
				setModuleId("GIPIS001A");
				if(!creationFlag){
					packTableGrid.clear();
					packTableGrid.refresh();
					clearObjectValues(objUWGlobal);
					clearObjectValues(objUWParList);
					clearObjectValues(objGIPIWPolbas);
				}else{
					updateMainContentsDiv("/GIPIPackPARListController?action=showPackParListTableGrid&ajax=1&lineCd="+lineCd+"&lineName="+lineName+"&riSwitch="+riSwitch,
							  "Getting Package PAR listing, please wait...",
							  function(){},[]);
					creationFlag = false;
				}
				$("parExit").stopObserving("click");
				observeGoToModule("parExit", goBackToPackagePARListing);
				selectedIndex = -1;
				objGIPIS130.details = null;
				objGIPIS130.distNo = null;
				objGIPIS130.distSeqNo = null;
			}
		});
	}catch(e){
		showErrorMessage("showPackParListing", e);
	}
}
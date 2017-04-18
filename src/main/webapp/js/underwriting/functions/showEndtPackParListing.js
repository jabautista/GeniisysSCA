function showEndtPackParListing(riSwitch){
	try{
		var lineCd = objUWGlobal.lineCd;
		var lineName = objUWGlobal.lineName;
		
		setCursor("wait");
		Effect.Fade("parInfoDiv", {
			duration: .001,
			afterFinish: function () {
				setCursor("default");
				$("parInfoMenu").hide();
				setDocumentTitle("Endorsement Package PAR Listing - Endorsement");
				setModuleId("GIPIS058A");
				if (nvl($("packParListingTableGridMainDiv"), null) == null) {
					updateMainContentsDiv("/GIPIPackPARListController?action=showEndtPackParListTableGrid&ajax=1&lineCd="+lineCd+"&lineName="+lineName+"&riSwitch="+riSwitch,
							  "Getting Endorsement Package PAR listing, please wait...",
							  function(){},[]);
					creationFlag = false;
				} else {
					$("packParListingTableGridMainDiv").show();
					if(!creationFlag){
						endtPackTableGrid.clear();
						endtPackTableGrid.refresh();
						clearObjectValues(objUWGlobal);
						clearObjectValues(objUWParList);
						clearObjectValues(objGIPIWPolbas);
					}else{
						updateMainContentsDiv("/GIPIPackPARListController?action=showEndtPackParListTableGrid&ajax=1&lineCd="+lineCd+"&lineName="+lineName+"&riSwitch="+riSwitch,
								  "Getting Endorsement Package PAR listing, please wait...",
								  function(){},[]);
						creationFlag = false;
					}
				}
				selectedIndex = -1;
			}
		});
	}catch(e){
		showErrorMessage("showEndtPackParListing", e);
	}
}
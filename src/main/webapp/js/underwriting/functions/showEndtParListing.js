//function showEndtParListing() {
function showEndtParListing(riSwitch) { // bonok :: 09.13.2012
	try {
		var lineCd = $F("globalLineCd") == null ? objUWGlobal.lineCd : $F("globalLineCd");
		var lineName = $F("globalLineName") == null ? objUWGlobal.lineName : $F("globalLineName");
		/*updateMainContentsDiv("/GIPIPARListController?action=showEndtParListing&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName"),
				  "Getting Endorsement PAR listing, please wait...",
				  goToPageNo,
				  ["endtParListingTable", "/GIPIPARListController?lineCd="+$F("lineCd")+"&lineName="+$F("lineName"), "filterEndtParListing", 1]);
		// replaced by : nica 01.11.2011
		updateMainContentsDiv("/GIPIPARListController?action=showEndtParListTableGrid&ajax=1&lineCd="+lineCd+"&lineName="+lineName,
				  "Getting Endorsement PAR listing, please wait...",
				  function(){},[]);
		//setDocumentTitle("Policy Action Records");
		$("parTypeFlag").value = "E";		
		initializeMenu();	
		setDocumentTitle("Policy Action Records");*/
		setCursor("wait");
		Effect.Fade("parInfoDiv", {
			duration: .001,
			afterFinish: function () {
				setCursor("default");
				$("parInfoMenu").hide();		
				$("parListingMainDiv").show();
				setDocumentTitle("PAR Listing - Endorsement");
				setModuleId("GIPIS058");
				if(!creationFlag){
					endtParTableGrid.clear();
					endtParTableGrid.refresh();
					clearObjectValues(objUWParList);
					clearObjectValues(objGIPIWPolbas);
				}else{
					//updateMainContentsDiv("/GIPIPARListController?action=showEndtParListTableGrid&ajax=1&lineCd="+lineCd+"&lineName="+lineName,
					updateMainContentsDiv("/GIPIPARListController?action=showEndtParListTableGrid&ajax=1&lineCd="+lineCd+"&lineName="+lineName+"&riSwitch="+riSwitch, // bonok :: 09.13.2012 
							  "Getting Endorsement PAR listing, please wait...",
							  function(){},[]);
					creationFlag = false;
				}
				selectedIndex = -1;
			}
		});
	} catch (e) {
		showErrorMessage("showEndtParListing", e);
	}
}
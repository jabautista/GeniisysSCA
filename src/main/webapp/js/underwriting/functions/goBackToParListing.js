/* Returns to PAR Listing page
 * 11.02.2010 Bry
 */
function goBackToParListing(){
	try {
		/*Effect.Fade("parInfoDiv", {
			duration: .001,
			afterFinish: function () {				
				//if ($("parListingMainDiv").down("div", 0).next().innerHTML.blank()) {
					if($F("globalParType") == "E"){
						showEndtParListing();
					}else{
						showParListing();
					}
				//} else {
					//$("parInfoMenu").hide();
					//Effect.Appear("parListingMainDiv", {duration: .001});
				//} commented by: nica 02.11.2011
				$("parListingMenu").show();
			}
		});*/
	    if ($F("globalParType") == "E") {
			showEndtParListing(($F("globalIssCd") == "RI" ? "Y" : ""));
		}else{	
			showParListing(($F("globalIssCd") == "RI" ? "Y" : ""));
		}
	} catch (e) {
		showErrorMessage("goBackToParListing", e);
	}
}
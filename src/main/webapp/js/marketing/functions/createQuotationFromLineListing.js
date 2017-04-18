function createQuotationFromLineListing() {	
	if (/*objGIPIQuote.lineCd == "" <-- not yet initialized || */($("lineCd") != null && objGIPIQuote.lineCd != null) && $F("lineCd") == ""){
		$("lineListingInstruction").update("Please select <strong>Line of Business</strong> from the list.");
		bad("outerDiv");
		return false;
	}else{
		isMakeQuotationInformationFormsHidden = 0;
		new Ajax.Updater("mainContents", contextPath + "/GIPIQuotationController",{
			parameters:{
				lineCd	: $("lineCd") != null ? $F("lineCd") : objGIPIQuote.lineCd,
				lineName: $("lineName") != null ? $F("lineName").replace(/&amp;/g, '&') : objGIPIQuote.lineName, //"", added by robert
				action	: "initialQuotationListing" //#uncommentOnDeploy #uncomment #on #deploy
			},
			method : "GET",
			asynchronous: true,
			evalScripts	: true,
			onCreate	: function() {
				/*Effect.Fade($("mainContents").down("div", 0), {
					duration : .3,*/
					afterFinish : showNotice("Getting list, please wait...");
				//});
			},
			onComplete : function() {
				hideNotice("");
				Effect.Appear("quotationListingMainDiv", {
					duration : .001
				});
			}
		});
		return true;
	}
}
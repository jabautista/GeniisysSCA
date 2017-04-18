function saveCreatedPAR(){
	try {
		var action = "";
		var quoteParams = "";
		if ("P" == $F("parType")){
			action = "saveParCreationPageChanges";
			if ("Y" == $F("fromQuote")){
				//Apollo 10.11.2014
				quoteParams = "&selectedQuoteId="+$F("hidQuoteId")//$F("selectedQuoteId")
					+"&selectedAssdNo="+$F("assuredNo")//$F("selectedAssdNo")
					+"&selectedIssCd="+$F("vissCd") //$F("selectedIssCd")
					+"&selectedLineCd="+$F("vlineCd");//$F("selectedLineCd");
			}
		} else if ("E" == $F("parType")){
			action = "saveCreatedPAR";
		}
		$$("div#buttonsParCreationDiv input[type='button']").each(function(b){
			enableButton(b.getAttribute("id"));
		});
		$("linecd").enable();
		$("isscd").enable();
		$("year").enable();
		$("remarks").enable();
		$("quoteSeqNo").enable();
		$("assuredNo").enable();
		//used Ajax.Request instead of Ajax.Updater and used postBody to handle special characters passed by Form.serialize("creatPARForm") by MAC 05/21/2013.
		new Ajax.Request(contextPath+"/GIPIPARListController?action="+action+"&vlineName="+$F("vlineName")
				+"&parId="+$F("globalParId")+"&parSeqNo="+parseFloat($F("inputParSeqNo") == ""? "0" : $F("inputParSeqNo"))
				+quoteParams, {
			method: "POST",
			postBody: Form.serialize("creatPARForm"),
		/*comment out and replaced by Ajax.Request by MAC 05/21/2013
		new Ajax.Updater("uwParParametersDiv", contextPath+"/GIPIPARListController?action="+action+"&vlineName="+$F("vlineName")
				+"&parId="+$F("globalParId")+"&parSeqNo="+parseFloat($F("inputParSeqNo") == ""? "0" : $F("inputParSeqNo"))
				+quoteParams+"&remarks=" + encodeURIComponent(escapeHTML2($("remarks").value))+"&"+Form.serialize("creatPARForm"), { //remove by steven 2/22/2013, nilagay ko sa baba ung mga ibang parameter na pinapasa.
			method: "POST",
			postBody : Form.serialize("creatPARForm"),
			parameters:{remarks : escapeHTML2($("remarks").value)},*/
				evalScripts: true,
				asynchronous: false,
			onCreate: function(){
				showNotice("Saving PAR, please wait...");
			},
			onComplete: function (response) {
				hideNotice();				
				if (checkErrorOnResponse(response)){
					$("uwParParametersDiv").update(response.responseText); //added to update DIV using Ajax.Request by MAC 05/21/2013.
					getParSeqNo("N");
					changeTag = 0;
					objUWGlobal.lineCd = $F("vlineCd"); // andrew - added this line to set the lineCd to global parameter
					objUWGlobal.menuLineCd = $("vlineCd").getAttribute("menuLineCd"); // andrew - 04.13.2011 - added this line to get the menu line code upon creation 
					initializePARBasicMenu($F("parType"), $F("vlineCd"));				
					if ($F("cancelPressed")=="Y"){
						pressParCreateCancelButton();
					}
					if ("P" != $F("parType")){
						if ($F("fromQuote")== "Y"){
							if ("N" == $F("hasGIPIWPolBasDetails")){ //added to avoid error when PAR is saved 2X and record is existing in GIPIWPolbas already -BRY
								insertGipiWPolbasicDetailsForPAR();
							}
						} 
					}	
					if (("Y" == $F("parType")) && ("Y" == $F("fromQuote"))){
						$("hasGIPIWPolBasDetails").value = "Y";
					}
					
					$("fromQuote").value = "N"; //Apollo 10.11.2014 - to prevent error when updating a saved par.
				} else {
					$$("div#buttonsParCreationDiv input[type='button']").each(function(b){
						enableButton(b.getAttribute("id"));
					});
					$("linecd").enable();
					$("isscd").enable();
					$("year").enable();
					$("remarks").enable();
					hideOverlay();
					clearParParameters();
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	} catch(e){
		showErrorMessage("saveCreatedPAR", e);
	}	
		
}
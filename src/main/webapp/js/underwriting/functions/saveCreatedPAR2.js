/**
 * Another version of saveCreatePAR, using the selected row from lov
 * @author andrew
 * @date 05.06.2011
 * @param row - selected record from lov
 */
function saveCreatedPAR2(row){
	try {
		var action = "";
		var quoteParams = "";
		if ("P" == $F("parType")){
			action = "saveParCreationPageChanges";
			if ("Y" ==$F("fromQuote")){
				quoteParams = "&selectedQuoteId="+row.quoteId
					+"&selectedAssdNo="+row.assdNo
					+"&selectedIssCd="+row.issCd
					+"&selectedLineCd="+row.lineCd;
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
		new Ajax.Updater("uwParParametersDiv", contextPath+"/GIPIPARListController?action="+action+"&vlineName="+$F("vlineName")
				+"&parId="+$F("globalParId")+"&parSeqNo="+parseFloat($F("inputParSeqNo") == ""? "0" : $F("inputParSeqNo"))
				+quoteParams+"&"+Form.serialize("creatPARForm"), {
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			onCreate: function(){
				showNotice("Saving PAR, please wait...");
			},
			onComplete: function (response) {
				hideNotice();
				if (checkErrorOnResponse(response)){
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
					
					copyAttachmentsFromQuoteToPar(row); // SR-21674 JET DEC-14-2016
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
				//commented out by jeffdojello 10.24.2013 This cause [Return to Quotation] to not function properly.
				//$("fromQuote").value = "N"; // Added by Joms Diago. To reset the fromQuote to default value since saving fromQuote is done.
			}
		});
	} catch(e){
		showErrorMessage("saveCreatedPAR2", e);
	}			
}
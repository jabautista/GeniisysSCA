function turnQuoteToPAR(){
	try {
		var quoteId			= $("selectedQuoteId").value;
		var issCd			= $("selectedIssCd").value;
		var lineCd			= $("selectedLineCd").value;
		var sublineCd		= $("selectedSublineCd").value;
		var quotationYy		= $("selectedQuotationYy").value;
		var quoteNo			= $("selectedQuoteNo").value;
		var proposalNo		= $("selectedProposalNo").value;
		var assdNo			= $("selectedAssdNo").value;
		var assdName		= $("selectedAssdName").value;
		var assdActiveTag	= $("selectedAssdActiveTag").value;
		var vAssdFlag		= false;
		
		$("quoteId").value = quoteId;
	
		var lineList 		= $("linecd");
		var index 			= 0;
		for (var j=0; j<lineList.length; j++){
			if (lineList.options[j].value == lineCd){
				index = j;
			}
		}
		$("linecd").selectedIndex 		= index;
	
		var issList			= $("isscd");
		var index2			= 0;
		for (var j=0; j<issList.length; j++){
			if (issList.options[j].value == issCd){
				index2 = j;
			}
		}
		$("isscd").selectedIndex 		= index2;
		
		$("vlineCd").value 				= $("linecd").value;
		$("linecd").value				= lineCd;
		$("assuredName").value			= assdName;
		$("assuredNo").value			= assdNo;
		
		if (($F("globalParId") == "0")||($F("globalParId") == "")){
			assuredListingFromPAR = 1;
			$("parType").value	= "P";
			if (assdActiveTag == "N"){
				if ((assdNo == "") && (assdName == "")){
					showWaitingMessageBox("Assured is required, please choose from the list.", "info", function(){
						hideOverlay(); 
						disableParCreationButtons();
						$("linecd").disable();
						$("isscd").disable();
						$("year").disable();
						$("quoteSeqNo").disable();
						$("assuredNo").disable();
						$("remarks").disable();
						openSearchClientModal();
					});
					//showConfirmBox("Assured Required ", "Assured is required, please choose from the list.", "OK", "Cancel", openSearchClientModal,"");
				} else {
					showWaitingMessageBox("The assured that was assigned in the quotation cannot be found, please assign a new one.", "info", function(){
						hideOverlay(); 
						disableParCreationButtons();
						$("linecd").disable();
						$("isscd").disable();
						$("year").disable();
						$("quoteSeqNo").disable();
						$("assuredNo").disable();
						$("remarks").disable();
						openSearchClientModal();
					});
					//showConfirmBox("Assured Required ", "The assured that was assigned in the quotation cannot be found, please assign a new one.", "OK", "Cancel", openSearchClientModal,"");
				}
			} else { //if assdActiveTag is Y
				getAssuredValues();
			}
		} 
		new Effect.toggle("quoteListingDiv", "blind", {duration: .2});
		$$("div[name='row2']").each( function(row){
			if (row.hasClassName("selectedRow")){
				row.removeClassName("selectedRow");
			}
		});
	} catch(e){
		showErrorMessage("turnQuoteToPAR", e);
	}
}
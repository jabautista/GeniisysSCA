/**
 * Another version of turnQuoteToPAR, using the selected row from lov
 * @author andrew
 * @date 05.06.2011
 * @param row - selected record from lov
 */
function turnQuoteToPAR2(row){
	try {		
		var quoteId			= row.quoteId;
		var issCd			= row.issCd;
		var lineCd			= row.lineCd;
		var sublineCd		= row.sublineCd;
		var quotationYy		= row.quotationYy;
		var quoteNo			= row.quotationNo;
		var proposalNo		= row.proposalNo;
		var assdNo			= row.assdNo;
		var assdName		= row.assdName;
		var assdActiveTag	= row.assdActiveTag;
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
		$("assuredName").value			= unescapeHTML2(assdName);
		$("assuredNo").value			= assdNo;

		if (($F("globalParId") == "0")||($F("globalParId") == "")){
			$("parType").value	= "P";
			if (assdActiveTag == "N"){
				function showQuoteToParAssdLOV(){
					function reset(){
						$("linecd").value = $("tempLineCd").value;
						$$("div#buttonsParCreationDiv input[type='button']").each(function(b){
							enableButton(b.getAttribute("id"));
						});
						$("linecd").enable();
						$("year").enable();
						$("remarks").enable();
						$("quoteSeqNo").enable();
						$("assuredNo").enable();
						$("isscd").enable();
						
						$("linecd").clear();
						$("inputParSeqNo").clear();
						$("assuredNo").clear();
						$("assuredName").clear();
					}
					
					showAssuredListingTG($F("vlineCd"),
							function() {
								if ($F("assuredNo") == "")	{
									reset();
								}else{
									fireNextFunc2();										
								}
							}, 
							function(){
								if ($("parCreationMainDiv") != null){
									reset();
								}
							});
				}
				
				if ((nvl(assdNo, "") == "") && (nvl(assdName, "") == "")){
					showWaitingMessageBox("Assured is required, please choose from the list.", "info", function(){
						hideOverlay(); 
						disableParCreationButtons();
						$("linecd").disable();
						$("isscd").disable();
						$("year").disable();
						$("quoteSeqNo").disable();
						$("assuredNo").disable();
						$("remarks").disable();
						showQuoteToParAssdLOV();
					});
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
						showQuoteToParAssdLOV();
					});
				}
			} else { //if assdActiveTag is Y
				updateQuoteFromPar2(row);
			}
		} 
	} catch(e){
		showErrorMessage("turnQuoteToPAR2", e);
	}
}
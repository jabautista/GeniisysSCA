//mrobes 05.11.10
//Shows the deductibles of the given peril.
function toggleEndtPerilDeductibles(itemNo, perilCd){
	try {
		//if($("inputDeductible3") != null){
			$$("div[name='ded3']").each(function(ded){
				if(ded.down("input", 2).value == perilCd && ded.down("input", 0).value == itemNo){
					if ($F("delPercentTsiDeductibles") == "Y"){
						if (ded.down("input", 10).value != "T"){
							ded.show();
						}
					} else {
						ded.show();
					}
				} else {
					ded.hide();
				}
			});
			
			checkTableIfEmpty2("ded3", "deductiblesTable3");
			checkIfToResizeTable2("wdeductibleListing3", "ded3");
			
			//added by robert to show the  Total Deductible Amount 09.17.2013 
			var dedLevel = 3;
			setTotalAmount(dedLevel, (1 < dedLevel ? itemNo : 0), (3 == dedLevel && perilCd != null && perilCd != "" ? perilCd : 0));
			//end robert 09.17.2013
		//}
	} catch(e){
		showErrorMessage("toggleEndtPerilDeductibles", e);
	}
}
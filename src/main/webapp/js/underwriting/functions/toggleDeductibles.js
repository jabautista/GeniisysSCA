/*
 * Created by	: Andrew
 * Date			: 09.22.2010
 * Description	: Show or hide deductible details depending on selected itemNo and perilCd
 */
function toggleDeductibles(dedLevel, itemNo, perilCd){
	if($("txtDeductibleCd"+dedLevel) != null){
		$$("div[name='ded"+dedLevel+"']").each(function(ded){			
			if(ded.down("input", 0).value == itemNo && ded.down("input", 2).value == perilCd){				
				ded.show();
			} else {
				ded.hide();
			}
		});
		checkTableIfEmpty2("ded"+dedLevel, "deductiblesTable"+dedLevel);
		checkIfToResizeTable2("wdeductibleListing"+dedLevel, "ded"+dedLevel);
		setTotalAmount(dedLevel, (1 < dedLevel ? itemNo : 0), (3 == dedLevel ? perilCd : 0));
	}
}
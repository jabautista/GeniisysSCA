/**
 * REPLACES SHOW DETAIL() FROM INVOICE.JS // check if listing has been called //
 * if not yet called // call it, then // if obj found in list then get specific
 * object and display // else show empty form
 * 
 * USED FOR CALLING:
 * - MORTGAGEE INFORMATION
 * - PERIL INFORMATION
 */
function showSubpageContents(subpageLabel, subpageContentDivId){
	var itemNo = getSelectedRowId("itemRow");
	
	try{
		if($(subpageLabel).innerHTML != "Hide"){
			if(subpageLabel.id == "perilAccordionLbl"){ // pre-loaded with itemInformation
				showPerilInformationSubpage();
			}else if(subpageLabel == "deductibleAccordionLbl"){

			}else if(subpageLabel == "additionalInfoAccordionLbl"){
				loadAdditionalInformationAccordion(itemNo);
			}
		}
		if($(subpageLabel).innerHTML == "Show"){
			Effect.BlindDown(subpageContentDivId, {
				duration:.3
			});
			$(subpageLabel).innerHTML = "Hide";
		}else if($(subpageLabel).innerHTML == "Hide"){
			Effect.BlindUp(subpageContentDivId, {
				duration:.3
			});
			$(subpageLabel).innerHTML = "Show";
		}
	}catch(e){
		showErrorMessage("showSubpageContents", e);
	}
}
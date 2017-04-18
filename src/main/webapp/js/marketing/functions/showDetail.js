/**
 * Shows the contents of accordion when the accordion label is clicked
 * @author rencela
 * @param labelName
 * @param childAccordionId
 */
function showDetail(labelName, childAccordionId){
	var itemNo = getSelectedRowId("itemRow");
	var exists = false;
	$$("div#" + childAccordionId/* + itemNo */).each(function(media){
		exists = true;
		$continue;
	});
	
	if(labelName == "mortgageeAccordionLbl" || labelName == "deductibleAccordionLbl"){
		$$("div#" + childAccordionId).each(function(media){
			exists = true;
			$continue;
		});
	}else if(labelName == "invoiceAccordionLbl"){
		if (isInvoiceInformationLoaded()) {	
			exists = true;
		}
	}
	
	if(exists){
		if(labelName == "mortgageeAccordionLbl" || labelName == "deductibleAccordionLbl"){
			itemNo = "";
		}
	}else{ // if the _ exists
		$(labelName).innerHTML = "Hide";
		if(labelName == "deductibleAccordionLbl"){
			loadDeductibleInformationAccordion();
		}else if(labelName == "mediaAccordionLbl"){
			loadAttachedMediaAccordion(itemNo);
			$(labelName).stopObserving("click");
			$(labelName).observe("click", function(){
				if($(labelName).innerHTML == "Show"){
					Effect.BlindDown(childAccordionId,{
						duration:.3
					});
					$(labelName).innerHTML = "Hide";
				}else if($(labelName).innerHTML == "Hide"){
					Effect.BlindUp(childAccordionId, {
						duration:.3
					});
					$(labelName).innerHTML = "Show";
				}
			});
		}else if(labelName == "additionalInfoAccordionLbl"){
			loadAdditionalInformationAccordion(itemNo);
			
			// NOK 04.27.2011
			$(labelName).stopObserving("click");
			$(labelName).observe("click", function(){
				if($(labelName).innerHTML == "Show"){
					Effect.BlindDown(childAccordionId,{
						duration:.3
					});
					$(labelName).innerHTML = "Hide";
				}else if($(labelName).innerHTML == "Hide"){
					Effect.BlindUp(childAccordionId,{
						duration:.3
					});
					$(labelName).innerHTML = "Show";
				}
			});
		}
	}
}
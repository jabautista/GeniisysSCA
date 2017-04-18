/**
 * Checks if the information in context has already been loaded [d hidden]
 * @author rencela
 * @param itemNo
 * @param informationPage
 * @return true - if the info page is only hidden
 * @return false - if the info page is not yet loaded
 */
function isItemLoaded(itemNo, informationPage){
	var bb = false;
	if(informationPage == "additionalInformation"){
		$$("div[name='additionalInformationDiv']").each(function(ai){
			if(ai.getAttribute("id").substring("24") == itemNo){
				bb = true;
				$continue;
			}
		});
	}else if(informationPage == "mortgageeInformation"){
		$$("div[name='mortgageeInformationSectionDiv']").each(function(mo){
			bb = true;
			$continue;
		});
	}else if(informationPage == "deductibleInformation"){
		$$("div[name='deductibleInformationSectionDiv']").each(function(mo){
			bb = true;
			$continue;
		});
	}else if(informationPage == "invoiceInformation"){
		$$("div[name='invoiceInformationSectionDiv']").each(function(ai){
			if(ai.getAttribute("id").substring("28") == itemNo){
				bb = true;
				$continue;
			}
		});
	}else if(informationPage == "attachedMedia"){
		$$("div[name='attachedMediaTopDiv']").each(function(ai){
			if(ai.getAttribute("id").substring("19") == itemNo){
				bb = true;
				$continue;
			}
		});
	}
	return bb;
}
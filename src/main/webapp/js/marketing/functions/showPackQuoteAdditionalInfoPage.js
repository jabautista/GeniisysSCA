/**
 * Shows the additional information page for the
 * line of the current quote selected. 
 * @param lineCd - line code of the quotation selected 
 * 				   under the Package quotation.
 * @param menuLineCd - the menu line code
 * 
 */

function showPackQuoteAdditionalInfoPage(lineCd, menuLineCd){
	
	$("additionalInfoAccordionLbl").innerHTML = "Show";
	$("packAdditionalInformationMainDiv").hide();
	
	$$("div[name='packAdditionalInfo']").invoke("hide");
	
	if(lineCd == "FI" || menuLineCd == "FI"){
		$("packAdditionalInfoFI").show();
	}else if(lineCd == "AV" || menuLineCd == "AV"){
		$("packAdditionalInfoAV").show();
	}else if(lineCd == "CA" || menuLineCd == "CA"){
		$("packAdditionalInfoCA").show();
	}else if(lineCd == "MH" || menuLineCd == "MH"){
		$("packAdditionalInfoMH").show();
	}else if(lineCd == "AC" || menuLineCd == "AC"){
		$("packAdditionalInfoAC").show();
	}else if(lineCd == "EN" || menuLineCd == "EN"){
		$("packAdditionalInfoEN").show();
	}else if(lineCd == "MN" || menuLineCd == "MN"){
		var quoteId = objCurrPackQuote.quoteId;
		filterPackGeogDescLOV(quoteId);
		filterPackCarrierLOV(quoteId);
		$("packAdditionalInfoMN").show();
	}else if(lineCd == "MC" || menuLineCd == "MC"){
		var sublineCd = unescapeHTML2(objCurrPackQuote.sublineCd);
		filterPackMotorTypesLOV(sublineCd);
		filterPackSublineTypesLOV(sublineCd);
		$("packAdditionalInfoMC").show();
	}
}
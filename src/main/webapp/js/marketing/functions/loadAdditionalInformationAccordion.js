// ADDITIONAL INFORMATION *************
/** 
 * Loads additional information individually
 * @author rencela
 * @param itemNo
 * @return
 */
function loadAdditionalInformationAccordion(itemNo){
	//if ($("additionalInformationMotherDiv").innerHTML != "") return; //NOK 04.27.2011 to return if additional info already called

	var lineCd 		= objGIPIQuote.lineCd;
	var url 		= "";
	var params = "&quoteId=" + objGIPIQuote.quoteId	+ "&itemNo=" + itemNo;
	var page = "";
	if (lineCd == "MC") {
		url = contextPath	+ "/GIPIQuotationMotorCarController?action=showMotorcarAdditionalInformationPage";
	} else if (lineCd == "FI") {
		url = contextPath	+ "/GIPIQuotationFireController?action=showFireAdditionalInformationPage";
		params = params + "&inceptDate=" + $F("inceptDate")	+ "&expiryDate=" + $F("expiryDate");
	} else if (lineCd == "AH" || lineCd == "PA") { //added PA - NOK 04.27.2011
		//url = contextPath	+ "/GIPIQuotationAccidentController?action=showAccidentAdditionalInformation"; //comment muna - NOK 04.27.2011
		url = contextPath	+ "/GIPIQuotationAccidentController?action=showAccidentAdditionalInformationJSON";
	} else if (lineCd == "AV") {
		url = contextPath	+ "/GIPIQuotationAviationController?action=showAviationAdditionalInformation";
	} else if (lineCd == "CA") {
		url = contextPath	+ "/GIPIQuotationCasualtyController?action=showCasualtyAdditionalInformation";
	} else if (lineCd == "EN") {
		url = contextPath	+ "/GIPIQuotationEngineeringController?action=showEnAdditionalInfo";
		//params = params + "&inceptDate=" + $F("inceptDate")	+ "&expiryDate=" + $F("expiryDate");
		params = params + "&inceptDate=" +$F("txtInceptionDate") + "&expiryDate=" + $F("txtExpirationDate");
	} else if (lineCd == "MN") {
		url = contextPath + "/GIPIQuotationMarineCargoController?action=showMarineCargoAdditionalInformationJSON";
		params = params + "&inceptDate=" + $F("txtInceptionDate") + "&expiryDate=" + $F("txtExpirationDate");
	} else if (lineCd == "MH") {
		url = contextPath	+ "/GIPIQuotationMarineHullController?action=showMarineHullAdditionalInformation";
	} else {
		url = contextPath	+ "/GIPIQuotationInformationController?action=showAdditionalInformationPage";
	}
	new Ajax.Updater("additionalInformationMotherDiv", url + params, {
		asynchronous: 	false,
		evalScripts: 	true,
		method: 		"GET",
		onCreate: function(){
		}, 
		onComplete: function(response) {
			if (checkErrorOnResponse(response)) {
				$("quotationInformationForm").enable();
				hideNotice(response.responseText);
				if (response.responseText == "SUCCESS") {
					enableQuoteInfoButtons();
				}
			}
			enableQuotationMainButtons();
			showAccordionLabelsOnQuotationMain();
		}
	});
	return null;
}
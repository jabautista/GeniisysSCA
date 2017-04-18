function checkLineCdForAddInfoDiv(){//Check the lineCd div for clearChangeAttribute in Additional Information DIV
	if($("lineCdHidden").value == "AV" || $("lineCdHidden").value == "EN" || $("lineCdHidden").value == "MH" || $("lineCdHidden").value == "CA" || $("lineCdHidden").value == "MN"){
		clearChangeAttribute("additionalInformationSectionDiv");
	}else if($("lineCdHidden").value == "FI" || $("lineCdHidden").value == "MC"){
		clearChangeAttribute("additionalItemInformation");
	}else if($("lineCdHidden").value == "PA" || $("lineCdHidden").value == "AC"){
		clearChangeAttribute("accidentAdditionalInformationDiv");
	}
}
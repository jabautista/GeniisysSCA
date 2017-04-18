/**
 * Populate quote item peril form with values.
 * @param perilObj - JSON Object that contains the quote item peril information. Set perilObj
 * 				     to null to reset quote item peril form. 
 */

function setQuoteItemPerilInfoForm(perilObj){
	$("txtPerilName").value 		= perilObj == null ? "" : unescapeHTML2(perilObj.perilName);
	$("txtPerilRate").value 		= perilObj == null ? formatToNineDecimal(0) : formatToNineDecimal(perilObj.perilRate);
	$("txtTsiAmount").value 		= perilObj == null ? formatCurrency(0) : formatCurrency(perilObj.tsiAmount);
	$("txtPremiumAmount").value 	= perilObj == null ? formatCurrency(0) : formatCurrency(perilObj.premiumAmount);
	$("txtRemarks").value 			= perilObj == null ? "" : unescapeHTML2(perilObj.compRem);
	
	$("btnAddPeril").value = perilObj == null ? "Add Peril" : "Update Peril";
	(perilObj == null ? disableButton($("btnDeletePeril")) : enableButton($("btnDeletePeril")));
	
	if(perilObj != null){
		$("hrefPeril").hide();
		$("txtPerilName").writeAttribute("perilCd", perilObj.perilCd);
		$("txtPerilName").writeAttribute("perilType", perilObj.perilType);
		$("txtPerilName").writeAttribute("basicPerilCd", perilObj.basicPerilCd);
	}else{
		$("hrefPeril").show();
		$("txtPerilName").writeAttribute("perilCd", "");
		$("txtPerilName").writeAttribute("perilType", "");
		$("txtPerilName").writeAttribute("basicPerilCd", "");
	}
}
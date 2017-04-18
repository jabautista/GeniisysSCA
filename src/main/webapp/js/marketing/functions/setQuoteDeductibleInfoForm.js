/**
* Populate quote item deductible form with values.
* @param deductibleObj - JSON Object that contains the quote item deductible information. Set deductibleObj
* 				     to null to reset quote item deductible form. 
*/

function setQuoteDeductibleInfoForm(deductibleObj){
	$("selDeductibleQuotePerils").value = deductibleObj == null ? "" : deductibleObj.perilCd;
	$("txtDeductibleTitle").value		= deductibleObj == null ? "" : unescapeHTML2(deductibleObj.deductibleTitle);
	$("txtDeductibleRate").value 		= deductibleObj == null ? "" : formatToNineDecimal(deductibleObj.deductibleRate == null ? "---" : deductibleObj.deductibleRate);
	$("txtDeductibleAmt").value 		= deductibleObj == null ? "" : formatCurrency(deductibleObj.deductibleAmt == null ? "---" : deductibleObj.deductibleAmt);
	$("txtDeductibleText").value 		= deductibleObj == null ? "" : unescapeHTML2(deductibleObj.deductibleText);
	$("txtPerilDisplay").value 			= $("selDeductibleQuotePerils").options[$("selDeductibleQuotePerils").selectedIndex].text; 
	
	(deductibleObj == null ? enableButton($("btnAddDeductible")) :disableButton($("btnAddDeductible")));
	(deductibleObj == null ? disableButton($("btnDeleteDeductible")) : enableButton($("btnDeleteDeductible")));
	
	if(deductibleObj != null){
		$("hrefDeductible").hide();
		$("txtDeductibleTitle").writeAttribute("deductibleCd", deductibleObj.dedDeductibleCd);
		$("txtDeductibleTitle").writeAttribute("deductibleType", deductibleObj.deductibleType);
		$("selDeductibleQuotePerils").hide();
		$("txtPerilDisplay").show();
	}else{
		$("hrefDeductible").show();
		$("txtDeductibleTitle").writeAttribute("deductibleCd", "");
		$("txtDeductibleTitle").writeAttribute("deductibleType", "");
		$("selDeductibleQuotePerils").show();
		$("txtPerilDisplay").hide();
	}
}
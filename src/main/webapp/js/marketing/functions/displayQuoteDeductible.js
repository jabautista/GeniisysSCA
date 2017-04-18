/**
 * FORMERLY CALLED getDefaults(deductibleObj)
 * @param deductibleObj
 * @return
 */
function displayQuoteDeductible(deductibleObj){
	var selItem = $("selDeductibleQuoteItems").options;
	for(var i=0; i< selItem.length; i++){
		if(selItem[i].getAttribute("itemNo") == deductibleObj.itemNo){
			$("selDeductibleQuoteItems").selectedIndex = i;
			i = selItem.length; // stop
		}
	}
	
	var selPeril = $("selDeductibleQuotePerils").options;
	for(var i=0; i<selPeril.length; i++){
		if(selPeril[i].getAttribute("perilCd") == deductibleObj.perilCd){
			$("selDeductibleQuotePerils").selectedIndex = i;
			i = selPeril.length;
		}
	}
	
	var selDeductible = $("selDeductibleDesc").options;
	for(var i=0; i<selDeductible.length; i++){
		if(selDeductible[i].getAttribute("deductibleCd") == deductibleObj.dedDeductibleCd){
			$("selDeductibleDesc").selectedIndex = i;
			i = selDeductible.length;
		}
	}
	//added unescapeHTML2 - nica 05.09.2011
	$("txtItemDisplay").value= unescapeHTML2($("selDeductibleQuoteItems").options[$("selDeductibleQuoteItems").selectedIndex].text);
	$("txtPerilDisplay").value = unescapeHTML2(deductibleObj.perilName);
	$("txtDedDisplay").value = unescapeHTML2(deductibleObj.deductibleTitle);
	$("txtDeductibleAmt").value = formatCurrency(deductibleObj.deductibleAmt);
	$("txtDeductibleRate").value = formatToNineDecimal(deductibleObj.deductibleRate);
	$("txtDeductibleText").value = unescapeHTML2(deductibleObj.deductibleText);
	
	disableButton("btnAddDeductible"); // No Update
	enableButton("btnDeleteDeductible");
}
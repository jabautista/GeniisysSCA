var objGIPIQuoteDeductiblesSummaryList = null;
var objGIISDeductibleDescLov = null;

/**
 * @deprecated
 * @param deductibleRow
 * @return
 */
function getDefaults(deductibleRow)	{ // REPLACE WITH displayQuoteDeductible(deductibleObj)
	var selDeductibleQuoteItems = $("selDeductibleQuoteItems");
	for (var i=0; i<selDeductibleQuoteItems.length; i++){
//		itemNo
		if (selDeductibleQuoteItems.options[i].value == deductibleRow.down("input", 0).value){
			selDeductibleQuoteItems.selectedIndex = i;
		}
	}

	//var peril = $("selDeductibleQuotePerils"+$F("selDeductibleQuoteItems"));
	removeAllOptions($("selDeductibleQuotePerils"));
	refreshPerilValuesByItem();
	setQuoteDeductiblePerilLov();
	var peril = $("selDeductibleQuotePerils");
	for (var j=0; j<peril.length; j++){
		if (peril.options[j].value == deductibleRow.down("input", 2).value){
			peril.selectedIndex = j;
		}
	}

	var deducts = $("selDeductibleDesc");
	for (var k=0; k<deducts.length; k++) {
		if (deducts.options[k].value == deductibleRow.down("input", 4).value)	{
			deducts.selectedIndex = k;
		}
	}
	$("txtItemDisplay").value= $("selDeductibleQuoteItems").options[$("selDeductibleQuoteItems").selectedIndex].text;
	$("txtPerilDisplay").value = deductibleRow.down("input", 1).value;
	$("txtDedDisplay").value = ded.down("input", 3).value;
	$("txtDeductibleAmt").value = formatCurrency(deductibleRowuctibleRow.down("input", 5).value);
	$("txtDeductibleRate").value = formatToNineDecimal(deductibleRow.down("input", 6).value);
	$("txtDeductibleText").value = deductibleRow.down("input", 7).value;
	
	//$("btnAddDeductible").value = "Update";
	disableButton("btnAddDeductible");
	enableButton("btnDeleteDeductible");
	// end of select defaults
}
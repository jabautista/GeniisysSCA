/* emman 05.04.10
 * update selected intm info
 * /underwriting/invoiceCommission.jsp
 */
function updateIntmInfo() {
	var intmNo = $("inputIntermediaryNo").value;
	var defaultTaxRt = parseFloat($("intmRow" + $("inputItemGroup").value + "-" + $("inputTakeupSeqNo").value).down("input", 9).value);
	var intmName = "";		
	
	/*if ($("btnSaveIntm").value == "Add") {
		intmName = $($("currentIntmListing").value).options[$($("currentIntmListing").value).selectedIndex].text;
	} else {
		intmName = $("inputIntermediaryName").value;
	}*/
	if ($F("inputIntermediaryName").blank()) {
		var intmName = $($("currentIntmListing").value).options[$($("currentIntmListing").value).selectedIndex].text;
	} else {
		var intmName = $F("inputIntermediaryName");
	}

	$$("div[id='intmRow"+$("inputItemGroup").value+"-"+$("inputTakeupSeqNo").value+"']").each(function(row) {
		if (row.down("input", 6).value == $("inputIntermediaryNo").value) {
			row.update(
					'<label id="labelIntermediaryName" name="label" style="width: 18%; text-align: left; margin-left: 5px;">'+intmName+'</label>' +
					'<label id="labelSharePercentage" name="labelSharePercentage" class="money" style="width: 14%; text-align: right;">'+$("inputPercentage").value+'</label>' +
					'<label id="labelSharePremium" name="labelSharePremium" class="money" style="width: 16%; text-align: right;">'+$("inputPremium").value+'</label>' +
					'<label id="labelTotalCommission" name="labelTotalCommission" class="money" style="width: 16%; text-align: right;">'+$("inputTotalCommission").value+'</label>' +
					'<label id="labelNetCommission" name="labelNetCommission" class="money" style="width: 16%; text-align: right;">'+$("inputNetCommission").value+'</label>' +
					'<label id="labelTotalWholdingTax" name="labelTotalWholdingTax" class="money" style="width: 17%; text-align: right;">'+$("inputTotalWithholdingTax").value+'</label>' +
					'<input type="hidden" id="intmIntermediaryName" name="intmIntermediaryName" value="'+intmName+'"/>' +
					'<input type="hidden" id="intmSharePercentage" name="intmSharePercentage" value="'+$("inputPercentage").value+'"/>' +
					'<input type="hidden" id="intmSharePremium" name="intmSharePremium" value="'+$("inputPremium").value.replace(/,/g,"")+'"/>' +
					'<input type="hidden" id="intmTotalCommission" name="intmTotalCommission" value="'+$("inputTotalCommission").value.replace(/,/g,"")+'"/>' +
					'<input type="hidden" id="intmNetCommission" name="intmNetCommission" value="'+$("inputNetCommission").value.replace(/,/g,"")+'"/>' +
					'<input type="hidden" id="intmTotalWholdingTax" name="intmTotalWholdingTax" value="'+$("inputTotalWithholdingTax").value.replace(/,/g,"")+'"/>' +
					'<input type="hidden" id="intmIntmNo" 		name="intmIntmNo" 		value="'+$("inputIntermediaryNo").value+'"/>' +
					'<input type="hidden" id="intmParentIntmNo" 		name="intmParentIntmNo" 		value="'+$("inputParentIntermediaryNo").value+'"/>' +
					'<input type="hidden" id="intmParentIntermediaryName" 		name="intmParentIntermediaryName" 		value="'+$("inputParentIntermediaryName").value+'"/>' +
					'<input type="hidden" id="intmDefaultTaxRt" 		name="intmDefaultTaxRt" 		value="'+defaultTaxRt+'"/>' +
					'<input type="hidden" id="intmOrigPolCommRts" 		name="intmOrigPolCommRts" 		value="'+$("retOrig").value+'"/>' +
					'<input type="hidden" id="intmItemGroup" 		name="intmItemGroup" 		value="'+$("inputItemGroup").value+'"/>' +
					'<input type="hidden" id="intmTakeupSeqNo" 		name="intmTakeupSeqNo" 		value="'+$("inputTakeupSeqNo").value+'"/>'				
			  );
		}
	});		

	$$("label[name='label']").each(function (label)	{
		if ((label.innerHTML).length > 20)	{
			label.update((label.innerHTML).truncate(20, "..."));
		}	
	});
	$("prevSharePercentage").value = $("inputPercentage").value;
}
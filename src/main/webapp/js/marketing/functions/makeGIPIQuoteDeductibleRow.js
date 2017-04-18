/**
 * #makeRow
 * @param deductibleObj
 * @return
 */
function makeGIPIQuoteDeductibleRow(deductibleObj){
	var newRow = new Element("div");
	newRow.setAttribute("id", "deductibleRow" + deductibleObj.itemNo + "" + deductibleObj.perilCd + "" + deductibleObj.dedDeductibleCd);
	newRow.setAttribute("name", "deductibleRow");
	newRow.setAttribute("itemNo", deductibleObj.itemNo);
	newRow.setAttribute("perilCd", deductibleObj.perilCd);
	newRow.setAttribute("deductibleCd", deductibleObj.dedDeductibleCd);
	newRow.addClassName("tableRow");
	var dedAmt = null;
	var dedRate = null;
	dedRate = deductibleObj.deductibleRate==null || deductibleObj.deductibleRate == "" ? "-" : formatToNineDecimal(deductibleObj.deductibleRate);
	
	if(deductibleObj.deductibleAmt == null || deductibleObj.deductibleAmt == ""){
		dedAmt = "-";
	}else{
		dedAmt = formatCurrency(deductibleObj.deductibleAmt);
	}
	
	newRow.update(
		'<label id="dedItemNo" style="width: 65px; text-align: center;">' + deductibleObj.itemNo + '</label>' + 
		'<label id="dedPerilName" style="width: 180px; text-align: left;" title="' + deductibleObj.perilName +'">' + 
				unescapeHTML2(deductibleObj.perilName.truncate(25, "...")) + '</label>' +
		'<label id="dedTitle" style="width: 180px; text-align: left;" title="' + deductibleObj.deductibleTitle + '">' + 
				unescapeHTML2(deductibleObj.deductibleTitle).truncate(25, "...") + '</label>' +
		'<label id="dedText" style="width: 150px; text-align: left; padding-left: 20px;" title="'+ deductibleObj.deductibleText +'">' +
				unescapeHTML2(deductibleObj.deductibleText).truncate(20, "...") + '</label>' +
		'<label id="dedRate" style="width: 130px; text-align: right;">' + dedRate + '</label>' +
		'<label id="dedAmount" style="width: 135px; text-align: right; margin-right: 10px;">' + formatCurrency(dedAmt) + '</label>'
	);
	
	loadRowMouseOverMouseOutObserver(newRow);
	
	newRow.observe("click", function(){
		newRow.toggleClassName("selectedRow");
		if(newRow.hasClassName("selectedRow")){
			($$("div#deductibleListing div:not([id=" + newRow.id + "])")).invoke("removeClassName", "selectedRow");
			//getDefaults(newRow);//??
			displayQuoteDeductible(deductibleObj);
			$("txtPerilDisplay").show();
			$("txtItemDisplay").show();
			$("txtDedDisplay").show();
		 	$("selDeductibleQuotePerils").hide();
		 	$("selDeductibleQuoteItems").hide();
		 	$("selDeductibleDesc").hide();
			disableButton("btnAddDeductible");
			enableButton("btnDeleteDeductible");
		}else{
			clearDeductibleForm();
		}
	});
	
	return newRow;
}
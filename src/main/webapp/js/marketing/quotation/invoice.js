var invoiceListObj = new Array(); // invoiceArray Object - rencela

var invoiceTaxLov = "";
var intermediaryLov = "";

var selIntermediaryObj 	= null; 
var selInvoiceTaxObj	= null;
var selTaxIdObj			= null;
var selRateInvObj		= null;

var invoiceSequence = 0;

// static final var ii = 0;

// recordStatus = -1 DELETED
// recordStatus = 0 NEW
// recordStatus = 1 UPDATED
// var invoiceTaxListingObj = null;

/*
 * Recompute Tax Amount and Amount Due using displayed[visible] values @return
 * function updateTaxAmountAndAmountDue(){ var taxAmt = 0;
 * 
 * $$("div[name='invoiceTaxRow']").each(function(aRow){ var aNum =
 * parseFloat(aRow.down("label",1).innerHTML.replace(/,/g, "")); //check
 * taxAmt+=aNum; });
 * 
 * $("txtTotalTaxAmount").value = formatCurrency(taxAmt); //formatCurrency(tta);
 * $("txtAmountDue").value = formatCurrency(taxAmt +
 * parseFloat(($F("txtInvoicePremiumAmount")).replace(/,/g, ""))); }
 */

/**
 * @param obj
 * @return
 *//*
function prepareJsonAsParameter(obj){
	var tempObj = JSON.stringify(obj).replace('"[', "[").replace(']"', "]").replace(/\\n/g, "&#10").replace(/\\/g, "").replace(/&#10/g,"\\\\n");
	return tempObj;
}
*/

// comment out by andrew - duplicate function in item.js
/*function getAddedAndModifiedJSONObjects(objArray){
	var tempObjArray = new Array();
	if(objArray != null){
		for (var i = 0; i<objArray.length; i++){
			if(objArray[i].recordStatus == 0 || objArray[i].recordStatus == 1){
				tempObjArray.push(objArray[i]);
			}		
		}
	}
	
	return tempObjArray;
}*/
/**
 * Filters the Mortgagee LOV in the Mortgagee sub-page.
 * Hides/disable values that are already included on the selected item.
 * 
 */

function filterPackMortgageeLOV(){
	var selectedItemNo = getSelectedRow("row").getAttribute("itemNo");
	(($$("select#selMortgagee option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
	
	for(var i=0; i<objPackQuoteMortgageeList.length; i++){
		if(objPackQuoteMortgageeList[i].quoteId == objCurrPackQuote.quoteId &&
		   objPackQuoteMortgageeList[i].itemNo == selectedItemNo &&
		   objPackQuoteMortgageeList[i].recordStatus != -1){
		   (($$("select#selMortgagee option[value='" + unescapeHTML2(objPackQuoteMortgageeList[i].mortgCd) + "']")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
		}
	}
	$("selMortgagee").options[0].show();
	$("selMortgagee").options[0].disabled = false;
	$("selMortgagee").show();
}
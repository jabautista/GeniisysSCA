/**
 * Computes the total tsi amount and total premium amount
 * and populates the computed values to the designted fields.
 * @param totalTsiField - field to assign total TSI Amount value.
 * @param totalPremField - field to assign total Premium Amount value.
 * 
 */

function computeTotalItemTsiandPremAmount(totalTsiField, totalPremField){
	try{
		var selectedItemRow = getSelectedRow("row");
		var totalTsi = 0;
		var totalPrem = 0;
		
		if(selectedItemRow != null){
			for(var i=0; i<objPackQuoteItemPerilList.length; i++){
				if(objPackQuoteItemPerilList[i].quoteId == objCurrPackQuote.quoteId &&
				   objPackQuoteItemPerilList[i].itemNo == selectedItemRow.getAttribute("itemNo") &&
				   objPackQuoteItemPerilList[i].recordStatus != -1){
						totalPrem = parseFloat(totalPrem) + parseFloat(objPackQuoteItemPerilList[i].premiumAmount);
						if(objPackQuoteItemPerilList[i].perilType == "B"){
							totalTsi = parseFloat(totalTsi) + parseFloat(nvl(objPackQuoteItemPerilList[i].tsiAmount, 0));
					}
				
				}
			}
		}
		
		$(totalTsiField).value = formatCurrency(totalTsi);
		$(totalPremField).value = formatCurrency(totalPrem);
	}catch(e){
		showErrorMessage("computeTotalItemTsiandPremAmount", e);
	}
}
/**
 * Computes the Premium Amount and TSI Amounts in Peril Information
 * @author rencela
 * @return
 */
function computeInvoiceTsiAmountsAndPremiumAmounts(){
	try {
		var tsiTotal = 0.00;
		var premiumAmountTotal = 0.00;
		var perilType = null;
		var premiumAmount = 0.00;
		
		if(objGIPIQuoteItemPerilSummaryList!=null){
			var itemNo = getSelectedRowId("itemRow");
			for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
				perilType = objGIPIQuoteItemPerilSummaryList[i].perilType;
				if(objGIPIQuoteItemPerilSummaryList[i].recordStatus != -1 && objGIPIQuoteItemPerilSummaryList[i].itemNo == itemNo){
					if(perilType == "B" || perilType == null){ // SOME ROWS IN GIPI_QUOTE_ITMPERIL HAVE NO PERIL_TYPE DATA / MAY CAUSE ERRORS IN COMPUTATION
						tsiTotal = tsiTotal + parseFloat(objGIPIQuoteItemPerilSummaryList[i].tsiAmount);
					}
					premiumAmountTotal = premiumAmountTotal + parseFloat(objGIPIQuoteItemPerilSummaryList[i].premiumAmount);
				}
			}
			$("txtTotalTsiAmount").value = formatCurrency(tsiTotal);
			$("txtTotalPremiumAmount").value = formatCurrency(premiumAmountTotal);
			
			// get selected item
			if(objGIPIQuoteItemList!=null){
				var itemObj = null;
				for(var i=0; i<objGIPIQuoteItemList.length; i++){
					if(objGIPIQuoteItemList[i].itemNo == itemNo){
						objGIPIQuoteItemList.premAmt = premiumAmountTotal;
						objGIPIQuoteItemList.annPremAmt = premiumAmountTotal;
						objGIPIQuoteItemList.tsiAmt = tsiTotal;
						objGIPIQuoteItemList.annTsiAmt = tsiTotal;
						i = objGIPIQuoteItemList.length; // end loop
					}
				}
			}
			
			//UPDATE INVOICE FORM
			if($("invoiceInformationDiv")!=null){ 
				$("txtPremiumAmount").value = $F("txtTotalPremiumAmount");
				var perilRow = getSelectedRow("perilRow");
				var itemNumber = getSelectedRowId("itemRow");
				var itemObject = getGIPIQuoteItemFromList(itemNumber);
				var selectedCurrencyCd = itemObject.currencyCd;
				var selectedCurrencyRate = itemObject.currencyRate;
				var premiumAmountOfCurrency = computeInvoicePremiumAmountPerCurrency(selectedCurrencyCd, selectedCurrencyRate);
				$("txtInvoicePremiumAmount").value = formatCurrency(premiumAmountOfCurrency);
				var inv = getInvoiceFromList(selectedCurrencyCd, selectedCurrencyRate);
				
				if(inv==null){ // ###
				}else{
					inv.premAmt = premiumAmountOfCurrency;
					updateTaxAmountAndAmountDue(); // andrew - 10.21.2011
				}
			}
		}
	} catch(e){
		showErrorMessage("computeInvoiceTsiAmountsAndPremiumAmounts", e);
	}
}
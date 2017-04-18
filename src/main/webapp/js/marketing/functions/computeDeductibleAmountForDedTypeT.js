/*	Compute deductible amount based on the rate, TSI amount, minimum amount, 
maximum amount and range of the deductible.-- nica*/
function computeDeductibleAmountForDedTypeT(){
	try{
		var perilName = $("selDeductibleQuotePerils").options[$("selDeductibleQuotePerils").selectedIndex].text;
		var itemNo = $("selDeductibleQuoteItems").options[$("selDeductibleQuoteItems").selectedIndex].value;
		var premAmt;
		var minAmt = ($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("minimumAmount"));
		var maxAmt = ($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("maximumAmount"));
		var rangeSw = ($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("rangeSw"));
			
		for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
			var pName = objGIPIQuoteItemPerilSummaryList[i].perilName;
			var pItemNo = objGIPIQuoteItemPerilSummaryList[i].itemNo;
			if(objGIPIQuoteItemPerilSummaryList.recordStatus != -1 &&
					pName == perilName && pItemNo == itemNo){
				premAmt = objGIPIQuoteItemPerilSummaryList[i].premiumAmount;
			}
		}
		
		var percentTSI = (($F("txtDeductibleRate")/100)*premAmt);
		
		if($("txtDeductibleRate").value != "" && $("txtDeductibleRate").value != 0){
			if(minAmt != "" && maxAmt != ""){
				if(rangeSw == "H" || rangeSw == "L"){
					if(percentTSI > minAmt && percentTSI < maxAmt){
						$("txtDeductibleAmt").value =  formatCurrency(percentTSI);
					}else if(percentTSI > minAmt && percentTSI > maxAmt){
						$("txtDeductibleAmt").value =  formatCurrency(maxAmt);
					}else if(percentTSI < minAmt){
						$("txtDeductibleAmt").value =  formatCurrency(minAmt);
					}
				}else{
					$("txtDeductibleAmt").value =  formatCurrency(maxAmt);
				}
			}else if(minAmt != ""){
				if(percentTSI > minAmt){
					$("txtDeductibleAmt").value =  formatCurrency(percentTSI);
				}else{
					$("txtDeductibleAmt").value =  formatCurrency(minAmt);
				}
			}else if(maxAmt != ""){
				if(percentTSI < maxAmt){
					$("txtDeductibleAmt").value =  formatCurrency(percentTSI);
				}else{
					$("txtDeductibleAmt").value =  formatCurrency(maxAmt);
				}
			}else{
				$("txtDeductibleAmt").value =  formatCurrency(percentTSI);
			}
		}else{
			if(minAmt != ""){
				$("txtDeductibleAmt").value =  formatCurrency(minAmt);
			}else if(maxAmt != ""){
				$("txtDeductibleAmt").value =  formatCurrency(maxAmt);
			}	
		}
	}catch(e){
		showErrorMessage("computeDeductibleAmountForDedTypeT", e);
	}
}
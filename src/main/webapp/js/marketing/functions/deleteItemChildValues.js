/**
 * 
 * - doesn't always work. needs assistance from a daoImpl-level function
 * @param itemNo
 * @return
 */

function deleteItemChildValues(itemNo){
	// delete perils/ai's/
	// mortgagees
	// deductibles
	// attachedMedia
	deleteRelatedElements();
	if(objGIPIQuoteItemList!=null){
		var itemObj = getGIPIQuoteItemFromList(itemNo);
		var lineCd = getLineCdMarketing();
		if(itemObj!=null){
		    if (lineCd == "AC" || lineCd == "PA"){ 
		    	itemObj.gipiQuoteItemAC.recordStatus = -1;
		    }else if (lineCd == "FI"){
		    	itemObj.gipiQuoteItemFI.recordStatus = -1;
		    }else if (lineCd == "EN"){
		    	itemObj.gipiQuoteItemEN.recordStatus = -1;
		    }else if(lineCd == "MH"){
		    	itemObj.gipiQuoteItemMH.recordStatus = -1;
		    }else if(lineCd == "MN"){
		    	itemObj.gipiQuoteItemMN.recordStatus = -1;
		    }else if (lineCd == "AV") {
		    	itemObj.gipiQuoteItemAV.recordStatus = -1;
		    }else if (lineCd == "MC"){
		    	itemObj.gipiQuoteItemMC.recordStatus = -1;
		    }else if(lineCd == "CA"){
		    	itemObj.gipiQuoteItemCA.recordStatus = -1;
		    }
			if(objGIPIQuoteItemPerilSummaryList!=null){
				for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
					if(objGIPIQuoteItemPerilSummaryList[i].itemNo == itemNo){
						objGIPIQuoteItemPerilSummaryList[i].recordStatus = -1;
					}
				}
			}
			
			if(objGIPIQuoteMortgageeList!=null){
				for(var i=0; i<objGIPIQuoteMortgageeList.length; i++){
					if(objGIPIQuoteMortgageeList[i].itemNo == itemNo){
						objGIPIQuoteMortgageeList[i].recordStatus = -1;
					}
				}
			}
			
			if(objGIPIQuoteDeductiblesSummaryList!=null){
				for(var i=0; i<objGIPIQuoteDeductiblesSummaryList.length; i++){
					if(objGIPIQuoteDeductiblesSummaryList[i].itemNo == itemNo){
						objGIPIQuoteDeductiblesSummaryList[i].recordStatus = -1;
					}
				}
			}
		}
	}
}
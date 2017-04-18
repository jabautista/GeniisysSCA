/**
 * - will return null if no item is selected
 * @param perilKey -
 *            itemNo + perilCode + perilName OR perilCd
 * @return peril object
 */
function getPerilFromPerilList(perilKey, includeDeletedPerils){
	var perilObj = null;
	for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
		if(objGIPIQuoteItemPerilSummaryList[i].perilCd == perilKey){
			if(includeDeletedPerils==false && objGIPIQuoteItemPerilSummaryList[i].recordStatus!=-1){
				perilObj = objGIPIQuoteItemPerilSummaryList[i];
			}else if(includeDeletedPerils==true){ // disregard recordStatus
				perilObj = objGIPIQuoteItemPerilSummaryList[i]; 
			}else{
				
			}
		}
	}
	return perilObj;
}
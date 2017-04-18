/**
 * Sets the LOV of perils in the Deductibles   
 * sub-page depending on the item selected.
 * 
 */

function setPackQuoteDeductiblePerilLov(){
	var selectedItemNo = getSelectedRow("row").getAttribute("itemNo");
	var perilLov = $("selDeductibleQuotePerils");
	
	if(perilLov != null){
		perilLov.update("<option></option>");
		var perilObj = null;
		for(var i=0; i<objPackQuoteItemPerilList.length; i++){
			perilObj = objPackQuoteItemPerilList[i];
			if(perilObj.quoteId == objCurrPackQuote.quoteId
			   && perilObj.itemNo == selectedItemNo 
			   && perilObj.recordStatus != -1){
				var opt = new Element("option");
				opt.innerHTML = perilObj.perilName;
				opt.setAttribute("value", perilObj.perilCd);
				opt.setAttribute("perilName", perilObj.perilName);
				opt.setAttribute("perilCd", perilObj.perilCd);
				try{
					perilLov.add(opt,null);
				}catch(e){
					perilLov.add(opt);
				};
			}
		}
	}
}
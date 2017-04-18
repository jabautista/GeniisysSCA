/**
 * CHECK IF TO HIDE OPTIONS THAT HAVE ALREADY BEEN SELECTED
 * #setLov
 */
function setQuoteDeductiblePerilLov(){
	var selectedItemNo = getSelectedRowId("itemRow");
	var perilLov = $("selDeductibleQuotePerils");
	perilLov.update("<option></option>");
	var perilObj = null;
	for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
		perilObj = objGIPIQuoteItemPerilSummaryList[i];
		if(perilObj.itemNo == selectedItemNo && perilObj.recordStatus != -1){
			var opt = new Element("option");
			opt.innerHTML = unescapeHTML2(perilObj.perilName);
			opt.setAttribute("value", perilObj.perilCd);
			opt.setAttribute("perilName", unescapeHTML2(perilObj.perilName));
			opt.setAttribute("perilCd", perilObj.perilCd);
			try{
				perilLov.add(opt,null);
			}catch(e){
				perilLov.add(opt);
			};
		}
	}
}
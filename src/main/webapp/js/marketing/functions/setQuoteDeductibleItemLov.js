/**
 * CHECK IF TO HIDE OPTIONS THAT HAVE ALREADY BEEN SELECTED
 * #setLov
 */
function setQuoteDeductibleItemLov(){
	var selectedItemNo = getSelectedRowId("itemRow");
	var itemLov = $("selDeductibleQuoteItems");
	itemLov.update("<option></option>");
	var itemObj = null;
	for(var i=0; i<objGIPIQuoteItemList.length; i++){
		itemObj = objGIPIQuoteItemList[i];
		if(itemObj.itemNo == selectedItemNo && itemObj.recordStatus != -1){
			var opt = new Element("option");
			opt.innerHTML = itemObj.itemTitle;
			opt.setAttribute("itemTitle", itemObj.itemTitle);
			opt.setAttribute("itemNo", itemObj.itemNo);
			opt.setAttribute("value", itemObj.itemNo);
			try{
				itemLov.add(opt,null);
			}catch(e){
				itemLov.add(opt);
			};
		}
	}
}
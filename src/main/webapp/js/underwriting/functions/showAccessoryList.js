/*	Created by	: mark jm 12.23.2010
 * 	Description	: set the listing on accessory page
 */
function showAccessoryList(){
	try{
		var table = $("accListing");
		var content = "";

		for(var i=0, length=objGIPIWMcAcc.length; i < length; i++){
			content = prepareAccessory(objGIPIWMcAcc[i]);

			var newDiv = new Element("div");

			newDiv.setAttribute("id", "rowAcc" + objGIPIWMcAcc[i].itemNo + "_" + objGIPIWMcAcc[i].accessoryCd);
			newDiv.setAttribute("name", "rowAcc");
			newDiv.setAttribute("item", objGIPIWMcAcc[i].itemNo);
			newDiv.setAttribute("accCd", objGIPIWMcAcc[i].accessoryCd);				
			newDiv.addClassName("tableRow");

			newDiv.update(content);

			table.insert({bottom : newDiv});

			if(objGIPIWMcAcc[i].itemNo == $F("itemNo")){
				filterLOV3("selAccessory", "rowAcc", "accCd", "item", objGIPIWMcAcc[i].itemNo);
			}
			
			loadAccessoryRowObserver(newDiv);
		}

		//toggleSubpagesRecord(objGIPIWMcAcc, objItemNoList, $F("itemNo"), "rowAcc", "accessoryCd",
		//		"accessoryTable", "accTotalAmountDiv", "accTotalAmount", "accListing", "accAmt");
		checkPopupsTableWithTotalAmountbyObject(objGIPIWMcAcc, "accessoryTable", "accListing", "rowAcc",
				"accAmt", "accTotalAmountDiv", "accTotalAmount");
	}catch(e){
		showErrorMessage("showAccessoryList", e);
		//showMessageBox("showAccessoryList : " + e.message);
	}
}
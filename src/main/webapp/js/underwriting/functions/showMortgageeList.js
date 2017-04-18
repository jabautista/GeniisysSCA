/*	Created by	: mark jm 12.23.2010
 * 	Description	: set the listing on mortgagee page
 */
function showMortgageeList(){
	try{
		var mortgLevel = $F("mortgageeLevel");
		var table = $("mortgageeListing");
		
		for(var i=0, length=objMortgagees.length; i < length; i++){
			var content = prepareMortgagee(objMortgagees[i]);
			
			var newDiv = new Element("div");

			newDiv.setAttribute("id", "rowMortg" + objMortgagees[i].itemNo + "_" + objMortgagees[i].mortgCd);
			newDiv.setAttribute("name", "rowMortg");
			newDiv.setAttribute("item", objMortgagees[i].itemNo);
			newDiv.setAttribute("mortgCd", objMortgagees[i].mortgCd);				
			newDiv.addClassName("tableRow");

			newDiv.update(content);

			table.insert({bottom : newDiv});
			
			//if(objMortgagees[i].itemNo == (mortgLevel == 1 ? $F("itemNo") : 0)){
				//filterLOV3("mortgageeName", "rowMortg", objMortgagees[i].mortgCd, "item", objMortgagees[i].itemNo, "mortgCd");
				filterLOV3("mortgageeName", "rowMortg", "mortgCd", "item", objMortgagees[i].itemNo);
			//}
			
			loadMortgageeRowObserver(newDiv);
		}			
		
		//toggleSubpagesRecord(objMortgagees, objItemNoList, (mortgLevel == 1 ? $F("itemNo") : "0"), "rowMortg", "mortgCd",
		//		"mortgageeTable", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "mortgageeListing", "amount");	
		checkPopupsTableWithTotalAmountbyObject(objMortgagees, "mortgageeTable", "mortgageeListing", "rowMortg",
				"amount", "mortgageeTotalAmountDiv", "mortgageeTotalAmount");
	}catch(e){
		showErrorMessage("showMortgageeList", e);
		//showMessageBox("showMortgageeList : " + e.message);
	}		
}
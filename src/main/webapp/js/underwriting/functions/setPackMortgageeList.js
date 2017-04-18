/**
 * Set the mortgagee listing of the sub-policies of a Package PAR
 * @author Veronica V. Raymundo
 * 
 */

function setPackMortgageeList(){
	try{
		var mortgLevel = $F("mortgageeLevel");
		var table = $("mortgageeListing");
		
		for(var i=0, length=objMortgagees.length; i < length; i++){
			var content = prepareMortgagee(objMortgagees[i]);
			
			var newDiv = new Element("div");

			newDiv.setAttribute("id", "rowMortg" + objMortgagees[i].parId + "_" + objMortgagees[i].itemNo + "_" + objMortgagees[i].mortgCd);
			newDiv.setAttribute("name", "rowMortg");
			newDiv.setAttribute("parId", objMortgagees[i].parId);
			newDiv.setAttribute("item", objMortgagees[i].itemNo);
			newDiv.setAttribute("mortgCd", objMortgagees[i].mortgCd);				
			newDiv.addClassName("tableRow");

			newDiv.update(content);
			table.insert({bottom : newDiv});
			
			loadPackMortgageeRowObserver(newDiv);
		}			
		checkPopupsTableWithTotalAmountbyObject(objMortgagees, "mortgageeTable", "mortgageeListing", "rowMortg",
				"amount", "mortgageeTotalAmountDiv", "mortgageeTotalAmount");
	}catch(e){
		showErrorMessage("setPackMortgageeList", e);
	}		
}
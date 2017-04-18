/*	Created by	: mark jm 03.14.2011
 * 	Description	: set the listing on casualty personnel listing
 */
function showCasualtyPersonnelListing(){
	try{
		var table = $("casualtyPersonnelListing");
		var content = "";
		
		for(var i=0, length=objGIPIWCasualtyPersonnel.length; i < length; i++){
			content = prepareCasualtyPersonnel(objGIPIWCasualtyPersonnel[i]);
			
			var newDiv = new Element("div");
			
			newDiv.setAttribute("id", "rowCasualtyPersonnel" + objGIPIWCasualtyPersonnel[i].itemNo + "_" + objGIPIWCasualtyPersonnel[i].personnelNo);
			newDiv.setAttribute("name", "rowCasualtyPersonnel");
			newDiv.setAttribute("item", objGIPIWCasualtyPersonnel[i].itemNo);
			newDiv.setAttribute("personnelNo", objGIPIWCasualtyPersonnel[i].personnelNo);
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
			
			table.insert({bottom : newDiv});
			
			loadCasualtyPersonnelRowObserver(newDiv);			
		}
		
		checkPopupsTableWithTotalAmountbyObject(objGIPIWCasualtyPersonnel, "casualtyPersonnelTable", "casualtyPersonnelListing",
				"rowCasualtyPersonnel", "amountCovered", "casualtyPersonnelTotalAmountDiv", "casualtyPersonnelTotalAmount");
	}catch(e){
		showErrorMessage("showCasualtyPersonnelListing", e);
	}
}
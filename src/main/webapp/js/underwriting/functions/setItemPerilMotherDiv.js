/*	Move by			: mark jm 03.01.2011
 * 	From			: parPerilInformationListingTable page
 */
function setItemPerilMotherDiv(itemNo){
	try{
		var newMotherDiv = new Element("div");
		
		newMotherDiv.setAttribute("name", "itemPerilMotherDiv");
		newMotherDiv.setAttribute("id", "itemPerilMotherDiv"+itemNo);
		newMotherDiv.addClassName("tableContainer");
		newMotherDiv.setStyle("display: none");
		
		$("itemPerilMainDiv").insert({bottom : newMotherDiv});
	}catch(e){
		showErrorMessage("setItemPerilMotherDiv", e);
	}		
}
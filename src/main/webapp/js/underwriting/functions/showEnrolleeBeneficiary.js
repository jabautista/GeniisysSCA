/*	Created by	: mark jm 06.06.2011
 * 	Description	: show accident enrollee beneficiary listing
 * 	Parameters	: objArray - records
 */
function showEnrolleeBeneficiary(objArray){
	try{
		for(var i=0, length=objArray.length; i < length; i++){
			var content = prepareEnrolleeBenificiaryDisplay(objArray[i]);
			var row = new Element("div");

			row.setAttribute("id", (("rowEnrolleeBen"+objArray[i].itemNo)+objArray[i].groupedItemNo)+objArray[i].beneficiaryNo);
			row.setAttribute("name", "rowEnrolleeBen");
			row.setAttribute("parId", objArray[i].parId);
			row.setAttribute("item", objArray[i].itemNo);
			row.setAttribute("grpItem", objArray[i].groupedItemNo);
			row.setAttribute("benNo", objArray[i].beneficiaryNo);
			row.addClassName("tableRow");

			row.update(content);

			setEnrolleeBeneficiaryRowObserver(row);

			$("bBeneficiaryListing").insert({bottom : row});								
		}

		resizeTableBasedOnVisibleRows("bBeneficiaryTable", "bBeneficiaryListing");
		//checkTableIfEmpty("rowEnrolleeBen", "bBeneficiaryListing");
		setBBenForm(null);
	}catch(e){
		showErrorMessage("showEnrolleeBeneficiary", e);
	}
}
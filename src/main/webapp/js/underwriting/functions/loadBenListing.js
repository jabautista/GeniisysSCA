/*	Created By	: d.alcantara, 02-21-2011 
 *  Description	: loads accident beneficiary listing
 *  Parameters  : itemNum - selected Item Number
 */
function loadBenListing(itemNum) {
	try {		
		var listingTable = $("beneficiaryListing");
		
		for(var i=0; i<objBeneficiaries.length; i++) {
			if(objBeneficiaries[i].itemNo == itemNum && objBeneficiaries[i] != null) {
				var content = prepareBenInfo(objBeneficiaries[i]);
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "rowBen"+itemNum+objBeneficiaries[i].beneficiaryNo);
				newDiv.setAttribute("name", "rowBen");
				newDiv.setAttribute("item", objBeneficiaries[i].itemNo);
				newDiv.setAttribute("benNo", objBeneficiaries[i].beneficiaryNo);
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				listingTable.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);
				
				var objBen = objBeneficiaries[i];
				clickBenRow(objBen, newDiv);				
			}
		}

		checkIfToResizeTable("beneficiaryListing", "rowBen");
		checkTableIfEmpty("rowBen", "benefeciaryTable");
	} catch(e) {
		showErrorMessage("loadBenListing", e);		
	}
}
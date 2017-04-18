/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.01.2011	mark jm			delete item from the list (table grid) and object list
 * 	09.02.2011	mark jm			added condition for motorcar
 * 	09.13.2011	mark jm			added condition for casualty
 * 	11.08.2011	mark jm			added condition for accident
 */
function deleteParItem2(){
	try{
		var lineCd = getLineCd();		
		
		addDeletedJSONObject(objGIPIWItem, {"parId" : objUWParList.parId, "itemNo" : objCurrItem.itemNo, "recordStatus" : -1});		
		
		objCurrItem.recordStatus = -1;
		tbgItemTable.deleteRow(tbgItemTable.getCurrentPosition()[1]);
		
		if(objGIPIWItem.filter(function(o){ return nvl(o.recordStatus, 0) != -1; }).length < 1){
			deleteParItemTG(tbgItemTable);
		}
		
		deleteParItemTG(tbgItemDeductible);		
		deleteParItemTG(tbgItemPeril);
		deleteParItemTG(tbgPerilDeductible);
		
		switch(lineCd){
			case "FI"	: deleteParItemTG(tbgMortgagee); break;
			case "MC"	: deleteParItemTG(tbgMortgagee);
						  deleteParItemTG(tbgAccessory); break;
			case "CA"	: deleteParItemTG(tbgGroupedItems);
						  deleteParItemTG(tbgCasualtyPersonnel); break;
			case "MN"	: deleteParItemTG(tbgCargoCarriers); break;
			case "AC"	: deleteParItemTG(tbgBeneficiary); break;
		}		

		clearItemRelatedDetails();

		// for perils
		$("perilTotalTsiAmt").value = formatCurrency(0);
		$("perilTotalPremAmt").value = formatCurrency(0);
		
		setParItemFormTG(null);
		setDefaultItemForm();
		
		($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessage("deleteParItem2", e);
	}
}
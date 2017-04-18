/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.25.2011	mark jm			clear the item-related forms
 * 	09.02.2011	mark jm			added condition for motorcar
 */
function clearItemRelatedDetails(){
	try{
		var lineCd = getLineCd();
		
		setItemDeductibleForm(null, 2);
		setItemDeductibleForm(null, 3);		
		setItemPerilForm(null);
		
		switch(getLineCd()){
			case "FI"	: setMortgageeFormTG(null); break;
			case "MC"	: setMortgageeFormTG(null);
						  setAccessoryFormTG(null); break;
			case "CA"	: setGroupedItemsFormTG(null);
						  setCasualtyPersonnelFormTG(null); break;
			case "MN"	: setCargoCarrierFormTG(null); break;
			case "AC"	: setBenFormTG(null); break;
		}		
		
		$("perilTotalTsiAmt").value = formatCurrency(0);
		$("perilTotalPremAmt").value = formatCurrency(0);
	}catch(e){
		showErrorMessage("clearItemRelatedDetails", e);
	}	
}
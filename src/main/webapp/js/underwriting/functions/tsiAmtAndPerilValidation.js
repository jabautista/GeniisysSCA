/*	Created by	: belle bebing 03.08.2011
 * 	Description	: default tsi amount and peril validation
*/
function tsiAmtAndPerilValidation() {
	try {
		//validation if items have peril(s)
		var perilExists;
		var itemCount = 0;
		var withPerilCount = 0;
		var itemWithoutPeril = new Array();
		for(var i=0; i<objGIPIWItem.length; i++){
			if(objGIPIWItem[i].recordStatus != -1) {
				perilExists = false;
				itemCount++;
				for (var j=0; j<objGIPIWItemPeril.length; j++) {
					if (objGIPIWItemPeril[j].itemNo == objGIPIWItem[i].itemNo && objGIPIWItemPeril[j].recordStatus != -1) {
						withPerilCount++;
						perilExists = true;
						break;							
					}
				}	
											
				if (!perilExists){
					itemWithoutPeril.push(objGIPIWItem[i].itemNo);
				}
			}
		}
		
		if(!(itemCount == withPerilCount || itemCount == itemWithoutPeril.length)) {
			showConfirmBox("Confirmation", "Do you want to go to the next item without peril(s)?", "Yes", "No", 
					function(){
						itemWithoutPeril.sort();
						if(!$("row"+itemWithoutPeril[0]).hasClassName("selectedRow")){
							fireEvent($("row"+itemWithoutPeril[0]), "click");
						}
						$("row"+itemWithoutPeril[0]).scrollTo();
					}, "");
			return false;			
		}
		
		//validation if all default perils have TSI Amount
		for(var i=0; i<objGIPIWItemPeril.length; i++){
			if ("0" == objGIPIWItemPeril[i].tsiAmt) {
				showMessageBox("Peril " +objGIPIWItemPeril[i].perilName + " has no TSI Amount.", imgMessage.Info);
				if(!$("rowPeril" +objGIPIWItemPeril[i].itemNo+objGIPIWItemPeril[i].perilCd).hasClassName("selectedRow")){
					fireEvent($("rowPeril" +objGIPIWItemPeril[i].itemNo+objGIPIWItemPeril[i].perilCd), "click");
				}
			return false;
			}
		}
		return true;
	} catch (e){
		showErrorMessage("tsiAmtAndPerilValidation", e);
	}
}
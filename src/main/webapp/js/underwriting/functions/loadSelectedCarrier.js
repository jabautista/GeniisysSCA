/*
 * Created By 	: andrew robes
 * Date			: November 18, 2010
 * Description	: Gets the selected carrier object from the array and set its values to the form
 * Parameter	: row - selected row (div) element 
 */
function loadSelectedCarrier(row) {
	/*
	for(var i=0; i<objCargoCarriers.length; i++) {
		var vesselCd = row.id.substr(row.id.indexOf("_") + 1, row.id.length - row.id.indexOf("_"));
		if (objCargoCarriers[i].itemNo == row.getAttribute("item") 
				&& objCargoCarriers[i].vesselCd.trim() == vesselCd.trim()
				&& objCargoCarriers[i].recordStatus != -1) {
			objCurrCargoCarrier = objCargoCarriers[i];
			setCarrierForm(objCurrCargoCarrier);
			break;
		}
	}
	*/
	try{
		if(row.hasClassName("selectedRow")){
			var objFilteredArr = objGIPIWCargoCarrier.filter(function(obj){	return nvl(obj.recordStatus,0) != -1 && obj.itemNo == row.getAttribute("item") && obj.vesselCd == row.getAttribute("vesselCd");	});
			for(var i=0, length=objFilteredArr.length; i<length; i++){
				setCargoCarrierForm(objFilteredArr[i]);
				break;
			}
		}else{
			setCargoCarrierForm(null);
		}
		
	}catch(e){
		showErrorMessage("loadSelectedCarrier", e);
	}
}
/*	Created by	: mark jm 03.09.2011
 * 	Description	: set the listing on cargo carrier page
 */
function showCargoCarrierListing(){
	try{
		var table = $("cargoCarrierListing");
		var content = "";
		
		for(var i=0, length=objGIPIWCargoCarrier.length; i < length; i++){
			content = prepareCarrier(objGIPIWCargoCarrier[i]);
			
			var newDiv = new Element("div");
			
			newDiv.setAttribute("id", "rowCargoCarrier" + objGIPIWCargoCarrier[i].itemNo + "_" + objGIPIWCargoCarrier[i].vesselCd);
			newDiv.setAttribute("name", "rowCargoCarrier");
			newDiv.setAttribute("item", objGIPIWCargoCarrier[i].itemNo);
			newDiv.setAttribute("vesselCd", objGIPIWCargoCarrier[i].vesselCd);				
			newDiv.addClassName("tableRow");

			newDiv.update(content);

			table.insert({bottom : newDiv});
			
			if(objGIPIWCargoCarrier[i].itemNo == $F("itemNo")){
				filterLOV3("carrierVesselCd", "rowCargoCarrier", "vesselCd", "item", objGIPIWCargoCarrier[i].itemNo);
			}
			
			loadCargoCarrierRowObserver(newDiv);
		}		
		
		checkPopupsTableWithTotalAmountbyObject(objGIPIWCargoCarrier, "cargoCarrierTable", "cargoCarrierListing",
				"rowCargoCarrier", "vesselLimitOfLiab", "cargoCarrierTotalAmountDiv", "cargoCarrierTotalAmount");
	}catch(e){
		showErrorMessage("showCargoCarrierListin", e);
	}
}
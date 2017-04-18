/*
 * Created By 	: andrew robes
 * Date			: November 9, 2010
 * Description	: Checks if the vessel code is multiple and if it has carriers
 * Parameters	: itemNo - number of item to be checked
 * 				  vesselCd - vessel code to be checked
 */
function checkIfMultipleCarrier(itemNo, vesselCd) {
	var multiple = false;
	
	var exist = false;
	var carriers = $("carrierListing").childElements();
	for(var i=0; i<carriers.length; i++){
		if(carriers[i].readAttribute("item") == itemNo){
			exist = true;
			break;
		}
	}
	
	if(vesselCd == $F("multiVesselCd") && !exist){
		showWaitingMessageBox("An item with a multiple carrier vessel should have corresponding carrier(s).", imgMessage.INFO,
				function() {
					fireEvent($("row"+itemNo), "click");
					if($("showListOfCarriers").innerHTML.trim() == "Show"){
						fireEvent($("showListOfCarriers"), "click");	
					}					
					$("carrier").focus();
					$("btnAddItem").scrollTo();
				});
		multiple = true;
	}
	return multiple;
}
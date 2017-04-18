/*
 * Created By	: andrew
 * Date			: October 21, 2010
 * Description	: Assigns selected item's deductibles to other item(s) without deductibles yet
 */
function assignDeductibles() {
	try {
		//var tempItemNo = (objUWGlobal.packParId != null ? objCurrPackPar.parType : $F("globalParType")) == "P" ? objCurrItem.itemNo : objCurrEndtItem.itemNo;
		var tempItemNo = (objUWGlobal.packParId != null ? objCurrPackPar.parType : objCurrItem.itemNo);
		var objTemp = getItemDeductibles(tempItemNo, objDeductibles);
		if (objTemp.length == 0) {
			showMessageBox("Item " + parseInt(tempItemNo).toPaddedString(3) + " has no existing deductible(s). You cannot assign null deductible(s).");
		} else {
			var itemNos = getItemNosWithoutDeductibles(objDeductibles);		
			if (itemNos.length == 0) {
				showMessageBox("All existing items already have deductible(s)");
			} else  {
				showConfirmBox("Confirmation", "Assign Deductibles, will automatically copy the current item deductibles " +
								"to other items without deductibles yet. Do you want to continue?",
								"Yes", "No", 
								function (){
									itemNos.any(function(no){									
										for (var i=0; i<objTemp.length; i++){					
											objTemp[i].parId	 	= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
											objTemp[i].dedLineCd	= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
											objTemp[i].dedSublineCd = (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"));
											objTemp[i].userId		= userId;
											objTemp[i].itemNo 		= no;
											addNewJSONObject(objDeductibles, JSON.parse(JSON.stringify(objTemp[i])));
											addItemDeductibleInTableListing(objTemp[i]);
										}
									});	
									showMessageBox("Deductibles have been assigned.");
								}, "");	
			}
		}
	} catch(e){
		showErrorMessage("assignDeductibles", e);
	}
}
/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.17.2011	mark jm			Assigns selected item's deductibles to other item(s) without deductibles yet (table grid version)
 */
function assignDeductiblesTG() {
	try {
		//var tempItemNo = (objUWGlobal.packParId != null ? objCurrPackPar.parType : $F("globalParType")) == "P" ? objCurrItem.itemNo : objCurrEndtItem.itemNo;
		var tempItemNo = (objUWGlobal.packParId != null ? objCurrPackPar.parType : objCurrItem.itemNo);
		var objTemp = getItemDeductibles(tempItemNo, objDeductibles);
		if (objTemp.length == 0) {
			showMessageBox("Item " + parseInt(tempItemNo).toPaddedString(3) + " has no existing deductible(s). You cannot assign null deductible(s).");
		} else {
			var itemNos = getItemNosWithoutDeductiblesTG(objDeductibles);		
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
										}
									});	
									showWaitingMessageBox("Deductibles have been assigned.", imgMessage.INFO, 
										function(){
											$("btnSave").click();
									});
								}, "");	
			}
		}
	} catch(e){
		showErrorMessage("assignDeductiblesTG", e);
	}
}
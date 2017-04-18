/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.16.2011	mark jm			Check if renumber is applicable (table grid version)
 */
function confirmParRenumberTG(){
	try{
		var consecutive = true;
		var previousValue = 0;
		
		//if($$("div#itemTable div[name='row']").size() > 0){
		if(objGIPIWItem.length > 0){
			var arrSortedItem = objGIPIWItem.slice(0);
			
			//$$("div#itemTable div[name='row']").each(function(row){
			//	arrItemNo[arrItemNo.length] = parseInt(row.getAttribute("item"));
			//});
			
			arrSortedItem = arrSortedItem.sort(function(objPre, objCurr){	return objPre.itemNo - objCurr.itemNo;	});
			
			for(var i=0, length=arrSortedItem.length; i < length; i++){			
				if((arrSortedItem[i].itemNo - previousValue) == 1){
					previousValue = arrSortedItem[i].itemNo;
				}else{
					consecutive = false;
				}
			}

			if(consecutive){
				showMessageBox("Renumber will only work if items are not arranged consecutively.", imgMessage.INFO);
			}else{
				/*
				if(objUWGlobal.lineCd == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC){
					if(objMortgagees == null){
						showMortgageeInfoModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), "0");
					}
					if(objGIPIWMcAcc == null){
						showAccessoryInfoModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), "0");
					}				
				}
				*/
				showConfirmBox("Renumber", "Renumber will automatically reorder your item number(s) sequentially. Do you want to continue?",
						"Continue", "Cancel", parRenumberTG, stopProcess);
			}
		}else{
			showMessageBox("Renumber will only work if there are existing items.", imgMessage.INFO);
		}	
	}catch(e){
		showErrorMessage("confirmParRenumberTG", e);
	}	
}
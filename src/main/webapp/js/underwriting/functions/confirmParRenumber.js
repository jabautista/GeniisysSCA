/*	Created by	: mark jm 12.23.2010
*	Description	: Check if renumber is applicable
*/
function confirmParRenumber(){
	var consecutive = true;
	var previousValue = 0;
	
	if($$("div#itemTable div[name='row']").size() > 0){
		var arrItemNo = [];
		
		$$("div#itemTable div[name='row']").each(function(row){
			arrItemNo[arrItemNo.length] = parseInt(row.getAttribute("item"));
		});
		
		arrItemNo.sort(function(a, b){	return a - b;	});
		
		for(var i=0, length=arrItemNo.length; i < length; i++){			
			if((arrItemNo[i] - previousValue) == 1){
				previousValue = arrItemNo[i];
			}else{
				consecutive = false;
			}
		}

		if(consecutive){
			showMessageBox("Renumber will only work if items are not arranged consecutively.", imgMessage.INFO);
		}else{
			if(objUWGlobal.lineCd == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC){
				if(objMortgagees == null){
					showMortgageeInfoModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), "0");
				}
				if(objGIPIWMcAcc == null){
					showAccessoryInfoModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), "0");
				}				
			}
			
			showConfirmBox("Renumber", "Renumber will automatically reorder your item number(s) sequentially. Do you want to continue?",
					"Continue", "Cancel", parRenumber, stopProcess);
		}
	}else{
		showMessageBox("Renumber will only work if there are existing items.", imgMessage.INFO);
	}	
}
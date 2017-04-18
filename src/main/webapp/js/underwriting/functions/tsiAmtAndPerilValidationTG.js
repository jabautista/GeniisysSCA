/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.15.2011	mark jm			default tsi amount and peril validation (table grid version)
 */
function tsiAmtAndPerilValidationTG() {
	try {
		//validation if items have peril(s)
		var perilExists;
		var itemCount = 0;
		var withPerilCount = 0;
		var itemWithoutPeril = new Array();
		var objArrFiltered = [];
		
		objArrFiltered = (objGIPIWItem.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	})).slice(0);
		
		for(var i=0, length=objArrFiltered.length; i < length; i++){			
			perilExists = false;
			//itemCount++;
			
			var objArrPeril = objGIPIWItemPeril.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == objArrFiltered[i].itemNo;	});		
			
			if(objArrPeril.length < 1){				
				itemWithoutPeril.push(objArrFiltered[i].itemNo);
			}else{
				withPerilCount++;
			}
		}
		
		itemCount = objArrFiltered.length;
		
		// commented by d.alcantara, 07-02-2012, causes problems in copy peril and when there are multiple pages of items
		/*if(!(itemCount == withPerilCount || itemCount == itemWithoutPeril.length)) {
			showConfirmBox("Confirmation", "Do you want to go to the next item without peril(s)?", "Yes", "No", 
					function(){
						var rowIndex = -1;
						
						itemWithoutPeril.sort();						
						
						for(var i=0, length=tbgItemTable.geniisysRows.length; i < length; i++){
							if(tbgItemTable.geniisysRows[i].itemNo == itemWithoutPeril[0]){
								rowIndex = i;
								break;
							}
						}
						
						if(rowIndex > -1){							
							$$("#itemInfoTableGrid .selectedRow").invoke("removeClassName", "selectedRow");
							$('mtgRow'+tbgItemTable.getId()+'_'+rowIndex).addClassName('selectedRow');
							showItemAndRelatedDetails(rowIndex);
							
							if($("showPeril").innerHTML == "Show"){
								$("showPeril").click();
							}
						}						
						
						//if(!$("row"+itemWithoutPeril[0]).hasClassName("selectedRow")){
						//	fireEvent($("row"+itemWithoutPeril[0]), "click");
						//}
						//$("row"+itemWithoutPeril[0]).scrollTo();
					}, "");
			return false;			
		}*/
		
		//validation if all default perils have TSI Amount
		for(var i=0; i<objGIPIWItemPeril.length; i++){
			if ("0" == objGIPIWItemPeril[i].tsiAmt) {
				showMessageBox("Peril " +objGIPIWItemPeril[i].perilName + " has no TSI Amount.", imgMessage.Info);
				//if(!$("rowPeril" +objGIPIWItemPeril[i].itemNo+objGIPIWItemPeril[i].perilCd).hasClassName("selectedRow")){
				//	fireEvent($("rowPeril" +objGIPIWItemPeril[i].itemNo+objGIPIWItemPeril[i].perilCd), "click");
				//}
				return false;
			}
		}
		return true;		
	} catch (e){
		showErrorMessage("tsiAmtAndPerilValidationTG", e);
	}
}
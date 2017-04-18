/*	Created by	: mark jm 12.23.2010
*	Description	: Renumber item and their detail records
*/
function parRenumber(){
	try{
		var previousValue = 0;
		var updateItemTable = false;
		var updateDeductibleTable = false;
		var updateMortgageeTable = false;
		var updateAccessoryTable = false;		
		var updateBeneficiaryTable = true;
		var updateGroupedItemsTable = false;
		var updateCasualtyPersonnelTable = false;
		var updateCargoCarrierTable = false;
	
		// added by d.alcantara => used in renumbering of accident grouped items
		var previousItemNos = new Array(); 
		var newItemNos = new Array();
		//	===
		$$("div#itemTable .selectedRow").each(function(row){	fireEvent(row, "click");	});		
		objGIPIWItem.sort(function(prev, curr){	return parseInt(prev.itemNo) - parseInt(curr.itemNo);	});
		
		$("parItemTableContainer").update("");		
		showItemList(objGIPIWItem);
		
		function localRenumber(objArr, currentItemNo, previousItemNo){
			try{
				var objRenumberArr = [];
				var renumbered = false;
				
				objRenumberArr = objArr.filter(function(obj){	return obj.itemNo == currentItemNo;	});
				
				if(objRenumberArr.length > 0){
					for(var i=0, length=objRenumberArr.length; i < length; i++){
						renumbered = true;
						objRenumberArr[i].itemNo = previousItemNo;
						objRenumberArr[i].recordStatus = 1;
					}
				}
				
				return renumbered;
			}catch(e){
				showErrorMessage("localRenumber", e);
			}	
		}
		
		$$("div#itemTable div[name='row']").each(function(row){
			var lineCd = getLineCd();
			var currentItemNo = parseInt(row.getAttribute("item"));
			
			if((currentItemNo - previousValue) == 1){
				previousValue = currentItemNo;
			}else{
				var objRenumberArr;
				var objRenumber = new Object();
				var delObj = new Object();
				
				objRenumber = objGIPIWItem.filter(function(item){	return item.itemNo == currentItemNo;	})[0];
				previousValue += 1;
				
				// create the item to be deleted
				delObj.parId = objRenumber.parId;
				delObj.itemNo = objRenumber.itemNo;
				delObj.recordStatus = -1;
				objGIPIWItem.push(delObj);
				
				// modify the values of the current record
				objRenumber.itemNo 		= previousValue;				
					
				if(nvl(objRenumber.dateFormatted, "N") == "N"){
					objRenumber.fromDate = objRenumber.fromDate == null ? null : dateFormat(objRenumber.fromDate, "mm-dd-yyyy");;
					objRenumber.toDate  = objRenumber.toDate == null ? null : dateFormat(objRenumber.toDate, "mm-dd-yyyy");
					objRenumber.dateFormatted = "Y";
				}
				
				// deductibles				
				updateDeductibleTable = localRenumber(objDeductibles, currentItemNo, previousValue);
				
				if(lineCd == "MC"){
					updateItemTable = true;
					objRenumber.gipiWVehicle.itemNo = previousValue;
					objRenumber.recordStatus = 1;					
					
					// mortgagee					
					updateMortgageeTable = localRenumber(objMortgagees, currentItemNo, previousValue);					
					// accessory					
					updateAccessoryTable = localRenumber(objGIPIWMcAcc, currentItemNo, previousValue);
				}else if(lineCd == "FI"){
					updateItemTable = true;
					objRenumber.gipiWFireItm.itemNo = previousValue;
					objRenumber.recordStatus = 1;					
					
					// mortgagee					
					updateMortgageeTable = localRenumber(objMortgagees, currentItemNo, previousValue);
				}else if(lineCd == "CA"){
					updateItemTable = true;
					objRenumber.gipiWCasualtyItem.itemNo = previousValue;
					objRenumber.recordStatus = 1;
					
					// grouped items					
					updateGroupedItemsTable = localRenumber(objGIPIWGroupedItems, currentItemNo, previousValue);
					// casualty personnel					
					updateCasualtyPersonnelTable = localRenumber(objGIPIWCasualtyPersonnel, currentItemNo, previousValue);
				}else if(lineCd == "MN"){
					updateItemTable = true;
					objRenumber.gipiWCargo.itemNo = previousValue;
					objRenumber.recordStatus = 1;
					
					// cargo carrier					
					updateCargoCarrierTable = localRenumber(objGIPIWCargoCarrier, currentItemNo, previousValue);
				}else if(lineCd == "EN") {
					updateItemTable = true;
					//objRenumber.gipiWEnItem.itemNo = previousValue;
					objRenumber.recordStatus = 1;
				}else if(lineCd == "AH") {
					updateItemTable = true;
					objRenumber.gipiWAccidentItem.itemNo = previousValue;
					objRenumber.recordStatus = 1;
					
					previousItemNos.push(currentItemNo);
					newItemNos.push(previousValue);
					
					// beneficiaries
					updateBeneficiaryTable = localRenumber(objBeneficiaries, currentItemNo, previousValue);
				}else if(lineCd == "AV") {
					updateItemTable = true;
					objRenumber.gipiWAviationItem.itemNo = previousValue;
					objRenumber.recordStatus = 1;
				}else if(lineCd == "MH") {
					updateItemTable = true;
					objRenumber.gipiWItemVes.itemNo = previousValue;
					objRenumber.recordStatus = 1;
				}
			}
		});		
		if(updateItemTable){
			var objRenumberArr;
			var lastItemNo = 0;
			var lineCd = getLineCd();
			
			$("parItemTableContainer").update("");			
			
			showItemList(objGIPIWItem);
			loadItemRowObserver();
			createItemNoList(objGIPIWItem);			
			
			if(lineCd == "MC" || lineCd == "FI"){
				if(updateMortgageeTable){
					$("mortgageeListing").update("");
					showMortgageeList();	
				}
				
				if(lineCd == "MC"){
					if(updateAccessoryTable){
						$("accListing").update("");
						showAccessoryList();					
					}
				}
			}else if(lineCd == "CA"){
				if(updateGroupedItemsTable){
					$("groupedItemListing").update("");
					showGroupedItemsListing();
				}
				
				if(updateCasualtyPersonnelTable){
					$("casualtyPersonnelListing").update("");
					showCasualtyPersonnelListing();
				}
			}else if(lineCd == "MN"){
				if(updateCargoCarrierTable){
					$("cargoCarrierListing").update("");
					showCargoCarrierListing();
				}
			} else if(lineCd == "AH") {
				if(updateBeneficiaryTable) {
					$("beneficiaryListing").update("");
					objFormMiscVariables.miscIsRenumbered = "Y";
					objFormMiscVariables.miscRenumberedItems = previousItemNos;
					objFormMiscVariables.miscChangedItems = newItemNos;
					/*var word = "modified item nos -- ";
					for(var i=0; i<previousItemNos.length; i++) {
						word += previousItemNos[i]+"/"+newItemNos[i]+", ";
					}
					*/
				}			
			}
			
			if(updateDeductibleTable){
				// function to regenerate deductibles listing
			}
		}
		setDefaultItemForm();
		showMessageBox("Items had been renumbered.", imgMessage.INFO);		
	}catch(e){
		showErrorMessage("parRenumber", e);
		//showMessageBox("parRenumber : " + e.message);
	}	
}
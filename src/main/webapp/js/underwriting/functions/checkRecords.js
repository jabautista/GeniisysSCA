/*	Created by	: mark jm 03.22.2011
 * 	Description	: set/unset the readonly property for item no in package policy items
 * 	Parameters	: obj - current record
 */
function checkRecords(obj){
	try{
		var blnUpdate = false;
		var objItem = null;	
		var perilLength = 0;
		var deductiblesLength = 0;		
		
		objItem = (objGIPIWItem.filter(function (o){	return o.parId == obj.parId && o.itemNo == $F("itemNo") && nvl(o.recordStatus, 0) != -1;	}))[0];
		
		if(objItem != null){
			perilLength = objItem.gipiWItemPeril == undefined ? 0 : 1;
			deductiblesLength = objItem.gipiWDeductible == undefined ? 0 : 1;
			
			if(obj.lineCd == objFormVariables.varFI){
				var fireItmLength = objItem.gipiWFireItm == undefined ? 0 : 1;
				
				if(perilLength > 0 && fireItmLength > 0){
					blnUpdate = true;
				}else if(perilLength > 0 && fireItmLength == 0){
					blnUpdate = true;
				}else if(perilLength == 0 && fireItmLength > 0){
					blnUpdate = true;
				}
			}else if(obj.lineCd == objFormVariables.varAV || obj.lineCd == objFormVariables.varMH){
				var aviationLength = objItem.gipiWAviationItem == undefined ? 0 : 1;
				var itemVesLength = objItem.gipiWItemVes == undefined ? 0 : 1;
				
				if(perilLength > 0 && (aviationLength > 0 || itemVesLength > 0)){
					blnUpdate = true;
				}else if(perilLength > 0 && (aviationLength == 0 || itemVesLength == 0)){
					blnUpdate = true;
				}else if(perilLength == 0 && (aviationLength > 0 || itemVesLength > 0)){
					blnUpdate = true;
				}
			}else if(obj.lineCd == objFormVariables.varCA){
				var casItemLength = objItem.gipiWCasualtyItem == undefined ? 0 : 1;
				var casPerLength = objItem.gipiWCasualtyPersonnel == undefined ? 0 : 1;
				var groupedItemsLength = objItem.gipiWGroupedItems == undefined ? 0 : 1;
				
				if(perilLength > 0 && (casItemLength > 0 || casPerLength > 0 || groupedItemsLength > 0 || deductiblesLength > 0)){
					blnUpdate = true;
				}else if(perilLength > 0 && (casItemLength == 0 || casPerLength == 0 || groupedItemsLength == 0 || deductiblesLength == 0)){
					blnUpdate = true;
				}else if(perilLength == 0 && (casItemLength > 0 || casPerLength > 0 || groupedItemsLength > 0 || deductiblesLength > 0)){
					blnUpdate = true;
				}
			}else if(obj.lineCd == objFormVariables.varEN){
				var locationLength = objItem.gipiWLocation == undefined ? 0 : 1;
				
				if(perilLength > 0 && (locationLength > 0 || deductiblesLength > 0)){
					blnUpdate = true;
				}else if(perilLength > 0 && (locationLength == 0 || deductiblesLength == 0)){
					blnUpdate = true;
				}else if(perilLength == 0 && (locationLength > 0 || deductiblesLength > 0)){
					blnUpdate = true;
				}
			}else if(obj.lineCd == objFormVariables.varAC){
				var accidentLength = objItem.gipiWAccidentItem == undefined ? 0 : 1;
				var uppaLength = 0;
				
				if(perilLength > 0 && (accidentLength > 0 || uppaLength > 0)){
					blnUpdate = true;
				}else if(perilLength > 0 && (accidentLength == 0 || uppaLength == 0)){
					blnUpdate = true;
				}else if(perilLength = 0 && (accidentLength > 0 || uppaLength > 0)){
					blnUpdate = true;
				}
			}else if(obj.lineCd == objFormVariables.varMN){
				var cargoLength = objItem.gipiWCargo == undefined ? 0 : obj.gipiWCargo.length;
				
				if(perilLength > 0 && cargoLength > 0){
					blnUpdate = true;
				}else if(perilLength > 0 && cargoLength == 0){
					blnUpdate = true;
				}else if(perilLength == 0 && cargoLength > 0){
					blnUpdate = true;
				}
			}else if(obj.lineCd == objFormVariables.varMC){										
				var vehicleLength = objItem.gipiWVehicle == undefined ? 0 : 1;
				var accessoryLength = objItem.gipiWMcAcc == undefined ? 0 : 1;
				
				if(perilLength > 0 && (vehicleLength > 0 || accessoryLength > 0)){
					blnUpdate = true;
				}else if(perilLength > 0 && (vehicleLength == 0 || accessoryLength == 0)){
					blnUpdate = true;
				}else if(perilLength == 0 && (vehicleLength > 0 || accessoryLength > 0)){
					blnUpdate = true;
				}
			}
			
			(blnUpdate) ? $("itemNo").removeAttribute("readonly") :	$("itemNo").setAttribute("readonly", "readonly");			
		}
	}catch(e){
		showErrorMessage("checkRecords", e);
	}	
}
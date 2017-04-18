/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.15.2011	mark jm			show related item records (child records)
 * 	09.13.2011	mark jm			added condition for casualty (grouped items)
 * 	09.21.2011	mark jm			added condition for marine cargo (cargo carriers) 
 */
function showItemAndRelatedDetails(rowIndex){
	try{
		//var objCurrItem = tbgItemTable.geniisysRows[y] == undefined ? tbgItemTable.newRowsAdded[y] : tbgItemTable.geniisysRows[y];
		var lineCd = getLineCd();
		
		// clear muna ung ibang form fields
		clearItemRelatedDetails();
		
		objCurrItem = tbgItemTable.geniisysRows[rowIndex];
		objCurrItem.tablegridIndex = rowIndex;
		//var itemNo = tbgItemTable.getValueAt(2, y) /* column index of itemNo in tableGrid is 2 */;
		var itemNo = objCurrItem.itemNo;
		
		if(objCurrItem == undefined){
			itemArr = objGIPIWItem.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	});
			for(var i=0, length=itemArr.length; i < length; i++){				
				if(itemArr[i].itemNo == itemNo){					
					objCurrItem = itemArr[i];
					break;
				}
			}
		}					
		
		tbgItemTable.keys.releaseKeys();
		setParItemFormTG(objCurrItem);		

		// retrieve child records
		retrieveDeductibles(objCurrItem.parId, itemNo, 2);
		
		// disallow retrieving of peril if there is deleted peril with same item no
		if(objGIPIWItemPeril.filter(function(o){ return nvl(o.recordStatus, 0) == -1; }).length < 1){
			retrieveItemPerils(objCurrItem.parId, itemNo);
		}		
		
		if(lineCd == "FI"){
			retrieveMortgagee(objCurrItem.parId, itemNo);
		}else if(lineCd == "MC"){
			retrieveMortgagee(objCurrItem.parId, itemNo);
			retrieveAccessory(objCurrItem.parId, itemNo);
		}else if(lineCd == "CA"){
			retrieveGroupedItems(objCurrItem.parId, itemNo);
			retrieveCasualtyPersonnel(objCurrItem.parId, itemNo);
		}else if(lineCd == "MN"){
			retrieveCargoCarriers(objCurrItem.parId, itemNo);
		}else if(lineCd == "AC"){
			retrieveBeneficiaries(objCurrItem.parId, itemNo);
		}
		
	}catch(e){
		showErrorMessage("showItemAndRelatedDetails", e);
	}
}
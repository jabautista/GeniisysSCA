/*	Created by	: mark jm 12.22.2010
 * 	Description	: used in motor item information by updating the deductible amount
 * 	Parameters	: itemNo - selected item no
 */
function computeDeductibleAmtByItem(itemNo){
	try{
		var objPre = new Object();
		var objSca = new Object();
		var amount;

		for(var i=0, length=objDeductibles.length; i < length; i++){
			//if(objDeductibles[i].itemNo == itemNo && nvl(objDeductibles[i].perilCd, 0) == 0){
			if(objDeductibles[i].itemNo == itemNo && objDeductibles[i].recordStatus != -1) {
				amount = Number(nvl(objDeductibles[i].deductibleAmount, "0").replace(/,/g, "")).toFixed(2).split("."); // added tofixed to correct computation by robert 01.27.15  
				objPre[i] = parseInt(amount[0]);
				objSca[i] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + (amount[1] == undefined ? 0 : amount[1]));
			}
		}
		
		$("deductibleAmount").value = addSeparatorToNumber(addObjectNumbers2(objPre, objSca), ","); //changed function by robert 02.17.15
		
		if(objCurrItem != undefined && objCurrItem != null) { // 'if' block added by andrew - 05.30.2011
			var towLimit = nvl($F("towLimit"), "0").replace(/,/g, "").split(".");
			objPre[objPre.length] = parseInt(towLimit[0]);
			objSca[objSca.length] = parseInt(((parseInt(towLimit[0]) < 0) ? "-" : "") + (towLimit[1] == undefined ? 0 : towLimit[1]));
			$("repairLimit").value = addSeparatorToNumber(addObjectNumbers2(objPre, objSca), ","); //changed function by robert 02.17.15
			
			//objCurrItem.gipiWVehicle.deductibleAmount = $("deductibleAmount").value;
			//objCurrItem.gipiWVehicle.repairLim = $("repairLimit").value;
		}
		
		delete objPre, objSca;
	}catch(e){
		showErrorMessage("computeDeductibleAmtByItem", e);
		//showMessageBox("computeDeductibleAmtByItem : " + e.message);
	}
}
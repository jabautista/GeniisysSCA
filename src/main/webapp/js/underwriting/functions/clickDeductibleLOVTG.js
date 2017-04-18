/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.25.2011	mark jm			prepare for deductible lov and show the lov
 */
function clickDeductibleLOVTG(tableGrid, dedLevel){
	try {
		var notIn = "";
		var withPrevious = false;
		var itemNo = (1 < dedLevel ? $F("itemNo") : 0);
		var perilCd = (3 == dedLevel ? $F("perilCd") : 0);		
		
		for(var i=0, length=tableGrid.geniisysRows.length; i < length; i++){
			if(nvl(tableGrid.geniisysRows[i].recordStatus, 0) != -1){ //marco - 04.11.2013 - added condition to include deleted records in LOV
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + tableGrid.geniisysRows[i].dedDeductibleCd + "'";
				withPrevious = true;
			}
		}
		
		notIn = (notIn != "" ? "("+notIn+")" : "");
		var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWGlobal.lineCd);
		var sublineCd = nvl($("sublineCd") != null ? $F("sublineCd") : null, (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")));
		showDeductibleLOV(lineCd, sublineCd, dedLevel, notIn);
	} catch (e){
		showErrorMessage("clickDeductibleLOVTG", e);
	}
}
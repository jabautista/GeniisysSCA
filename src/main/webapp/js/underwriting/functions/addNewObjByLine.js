/*	Created by	: mark jm 09.30.2010
 * 	Description	: another version of addNewJSONObject by line
 */
function addNewObjByLine(newObj){
	try{
		var lineCd = getLineCd();
		var parId =  (objUWGlobal.packParId != null ? objCurrPackPar.parId : $("globalParId"));
		
		newObj.recordStatus = 0;
		
		if(lineCd == "MC"){
			objGIPIWItem.push(newObj);
		} else if(lineCd == "FI"){
			newObj.parId = parId;
			newObj.gipiWFireItm = JSON.parse(Object.toJSON(newObj.gipiFireItem));
			newObj.gipiFireItem = null;
			objGIPIWItem.push(newObj);			
		}else if(lineCd == "MN"){
			objEndtMNItems.push(newObj);
		}else if(lineCd == "CA"){
			objEndtCAItems.push(newObj);
			objItemNoList.push({"itemNo" : newObj.itemNo });
		}else if(lineCd == "MH"){//added by BJGA for MH Endt unique procedures
			newObj = modifyObjWODetails(newObj);
			objEndtMHItems.push(newObj);
			objItemNoList.push({"itemNo" : newObj.itemNo });
			updateDeleteDiscountVariables();
		}else if(lineCd == "EN") {
			objGIPIWItem.push(newObj);
		}else if(lineCd == "AC") {
			objGIPIWItem.push(newObj);
		}
	}catch(e){
		showErrorMessage("addNewObjByLine", e);
	}
}
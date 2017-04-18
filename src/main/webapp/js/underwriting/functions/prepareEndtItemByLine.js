/**
 * Prepares the item to be endorsed
 * @author andrew
 * @date 05.23.2011
 * @param newObj
 */
function prepareEndtItemByLine(newObj){
	try{
		if(newObj != null){
			var lineCd = getLineCd();
			var parId =  (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			
			newObj.recordStatus = 0;
			newObj.recFlag = "C";
			newObj.parId = parId;
			//newObj.fromDate = dateFormat(newObj.fromDate, "MM-dd-yyyy");
			//newObj.toDate = dateFormat(newObj.toDate, "MM-dd-yyyy");
			
			
			if(lineCd == "MC"){
				if (newObj.gipiVehicle != null) {	//Gzelle 05262015 SR18978
					newObj.gipiWVehicle = JSON.parse(Object.toJSON(newObj.gipiVehicle));
					newObj.gipiWVehicle.parId = parId;
				}
				//newObj.gipiVehicle = null;	
			} else if(lineCd == "FI"){
				newObj.gipiWFireItm = JSON.parse(Object.toJSON(newObj.gipiFireItem));
				newObj.gipiWFireItm.parId = parId;
				//newObj.gipiFireItem = null;
			}else if(lineCd == "MN"){
				newObj.gipiWCargo = JSON.parse(Object.toJSON(newObj.gipiCargo));
				newObj.gipiWCargo.parId = parId;
				//newObj.gipiCargo = null;
			}else if(lineCd == "CA"){
				if (newObj.gipiCasualtyItem != null) {	//Gzelle 03092015
					newObj.gipiWCasualtyItem = JSON.parse(Object.toJSON(newObj.gipiCasualtyItem));
					newObj.gipiWCasualtyItem.parId = parId;
				}
				//newObj.gipiCasualty = null;				
			}else if(lineCd == "MH"){
				newObj.gipiWItemVes = JSON.parse(Object.toJSON(newObj.gipiItemVes));
				newObj.gipiWItemVes.parId = parId;
				//newObj.gipiItemVes = null;
			}else if(lineCd == "AV"){
				newObj.gipiWAviationItem = JSON.parse(Object.toJSON(newObj.gipiAviationItem));
				newObj.gipiWAviationItem.parId = parId;
				//newObj.gipiAviationItem = null;								
			}else if(lineCd == "EN") {
				// EN has separate additional information module
			}else if(lineCd == "AC") {
				newObj.gipiWAccidentItem = JSON.parse(Object.toJSON(newObj.gipiAccidentItem)); //added by christian 04/18/2013
				objGIPIWItem.push(newObj);
			}
		}
		//return newObj;
	}catch(e){
		showErrorMessage("prepareEndtItemByLine", e);
	}
}
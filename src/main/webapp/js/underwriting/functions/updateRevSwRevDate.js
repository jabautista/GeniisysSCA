/* belle 07.27.2011
 * Updates reverse_sw and reverse_date in GIRI_FRPS_RI, GIRI_BINDER respectively of the posted binder
 * when changes in peril information are made
 */
function updateRevSwRevDate(refresh){
	try{
		var lineCd = getLineCd(objUWGlobal.lineCd);
		var parId = objGIPIWPolbas.parId;
		var refresh = refresh;
		new Ajax.Request(contextPath+"/GIRIBinderController?action=updateRevSwRevDate&parId="+parId,{
			method: "POST",
			evalScripts: true,
			asynchronous: true,
			onComplete: function (response){
				if (response.responseText == "SUCCESS") {
					if (lineCd == 'AV'){
						saveAviationItems(refresh);
					}else if (lineCd == 'CA') {
						saveCasualtyItems(refresh);
					}else if (lineCd== 'EN') {
						saveENItems(refresh);
					}else if (lineCd == 'FI'){
						saveFireItems(refresh);
					}else if (lineCd == 'MC'){
						saveVehicleItems(refresh);
					}else if (lineCd == 'MH'){
						saveMHItems(refresh);
					}else if (lineCd == 'MN'){
						saveMarineCargoItems(refresh);
					}else if (lineCd == 'AC'){
						saveAHItem(refresh);
					}else{
						if(objUWGlobal.lineCd == 'GD' && $F("globalLineCd") == "LI") {
							saveCasualtyItems(refresh);
						}
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("updateRevSwRevDate", e);
	}
}
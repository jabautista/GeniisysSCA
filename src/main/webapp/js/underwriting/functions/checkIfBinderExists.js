/* belle 07.27.2011
 * Check if posted Binders exists when changes are made in peril information
 */
function checkIfBinderExists(refresh) {
	try{
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objGIPIWPolbas.parId);
		var result = false;
		var lineCd = getLineCd(objUWGlobal.lineCd);//objUWGlobal.lineCd;
		new Ajax.Request(contextPath+"/GIRIBinderController?action=checkIfBinderExists&parId="+parId,{
			method: "POST",
			evalScripts: true,
			asynchronous: true,
			onComplete: function (response)	{
				if(checkErrorOnResponse(response)){
					if (response.responseText == 'Y') {
						showConfirmBox("Confirmation", "Changing TSI/Premium Amounts will affect current distribution. Do you want to continue?", "Yes", "No",
								function(){updateRevSwRevDate(refresh); }, "");
					} else {
						if (lineCd == 'AV'){ // here irwin
							saveAviationItems(refresh);
						}else if (lineCd == 'CA') {
							saveCasualtyItems(refresh);
						}else if (lineCd == 'EN') {
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
						} 
					}
				}
			}	
		});	
		return result;
	} catch(e){
		showErroMessag("checkIfDefaultPerilExist", e);
	}
}
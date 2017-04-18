/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.23.2011	mark jm			create new cargo carrier object
 */
function setCargoCarrier(){
	try{
		var newObj = new Object();
		
		newObj.parId				= (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		newObj.itemNo				= $F("itemNo");		
		newObj.vesselCd				= $F("carrierVesselCd");
		newObj.vesselName			= changeSingleAndDoubleQuotes2($F("carrierVesselName"));
		newObj.voyLimit				= changeSingleAndDoubleQuotes2($F("carrierVoyLimit"));
		newObj.vesselLimitOfLiab	= ($F("carrierLimitLiab")).empty() ? null : formatCurrency($F("carrierLimitLiab"));
		newObj.eta					= $F("carrierEta") == "" ? null : $F("carrierEta");
		newObj.etd					= $F("carrierEtd") == "" ? null : $F("carrierEtd");
		newObj.origin				= changeSingleAndDoubleQuotes2($F("carrierOrigin"));
		newObj.destn				= changeSingleAndDoubleQuotes2($F("carrierDestn"));
		newObj.deleteSw				= $F("carrierDeleteSw");
		newObj.userId				= $F("userId");
		newObj.motorNo				= escapeHTML2($F("carrierMotorNo"));
		newObj.plateNo				= escapeHTML2($F("carrierPlateNo"));
		newObj.serialNo				= escapeHTML2($F("carrierSerialNo"));
		
		return newObj;
	}catch(e){
		showErrorMessage("setCargoCarrier", e);
	}
}
/*	Created by	: mark jm 03.09.2011
 * 	Description	: set values on cargo carrier form
 * 	Parameters	: obj - the record object
 */
function setCargoCarrierForm(obj){
	try{		
		$("carrierVesselCd").value 		= obj == null ? "" : obj.vesselCd;
		$("carrierVesselName").value	= obj == null ? "" : unescapeHTML2(obj.vesselName);
		$("carrierPlateNo").value 		= obj == null ? "" : unescapeHTML2(obj.plateNo);
		$("carrierMotorNo").value 		= obj == null ? "" : unescapeHTML2(obj.motorNo);
		$("carrierSerialNo").value 		= obj == null ? "" : unescapeHTML2(obj.serialNo);
		$("carrierLimitLiab").value 	= obj == null ? "" : (obj.vesselLimitOfLiab == null ? "" : formatCurrency(obj.vesselLimitOfLiab));
		$("carrierEtd").value 			= obj == null ? "" : obj.etd;
		$("carrierEta").value 			= obj == null ? "" : obj.eta;
		$("carrierOrigin").value 		= obj == null ? "" : unescapeHTML2(obj.origin);
		$("carrierDestn").value 		= obj == null ? "" : unescapeHTML2(obj.destn);
		$("carrierDeleteSw").value 		= obj == null ? "" : obj.deleteSw;
		$("carrierVoyLimit").value 		= obj == null ? "" : unescapeHTML2(obj.voyLimit);
		
		$("btnAddCarrier").value		= obj == null ? "Add" : "Update";
		
		if(obj == null){
			disableButton($("btnDeleteCarrier"));
			$("carrierVesselCd").show();
			$("carrierVesselName").hide();			
		}else{
			enableButton($("btnDeleteCarrier"));
			$("carrierVesselCd").hide();
			$("carrierVesselName").show();
		}
	}catch(e){
		showErrorMessage("setCargoCarrierForm", e);
	}
}
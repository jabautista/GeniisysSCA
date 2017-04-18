/*
 * Created By	: andrew robes
 * Date			: November 18, 2010
 * Description	: Sets the carrier form with values from the row when selected otherwise clear the form
 * Parameters	: obj - obj containing the carrier details
 */
function setCarrierForm(obj) {	
	$("carrier").value 			= obj == null ? "" : obj.vesselCd;
	$("carrierPlateNo").value 	= obj == null ? "" : obj.plateNo;
	$("carrierMotorNo").value 	= obj == null ? "" : obj.motorNo;
	$("carrierSerialNo").value 	= obj == null ? "" : obj.serialNo;
	$("carrierLimitLiab").value = obj == null || nvl(obj.vesselLimitOfLiab, "") == "" ? "" : formatCurrency(obj.vesselLimitOfLiab);		
	$("carrierEtd").value 		= obj == null || nvl(obj.etd, "") == "" ? "" : dateFormat(Date.parse(dateFormat(obj.etd, "mm-dd-yyyy")), "mm-dd-yyyy");
	$("carrierEta").value		= obj == null || nvl(obj.eta, "") == "" ? "" : dateFormat(Date.parse(dateFormat(obj.eta, "mm-dd-yyyy")), "mm-dd-yyyy");
	$("carrierOrigin").value 	= obj == null ? "" : obj.origin;
	$("carrierDestn").value 	= obj == null ? "" : obj.destn;
	$("carrierVoyLimit").value 	= obj == null ? "" : obj.voyLimit;
	$("btnAddCarrier").value = obj == null ? "Add" : "Update";
	obj == null ? disableButton("btnDeleteCarrier") : enableButton("btnDeleteCarrier"); 
	
	if (obj != null) {
		$("carrier").hide();
		$("txtCarrierDisplay").value = obj.vesselName;
		$("txtCarrierDisplay").writeAttribute("vesselCd", obj.vesselCd);
		$("txtCarrierDisplay").show();
	} else {
		$("carrier").show();
		$("txtCarrierDisplay").value = "";
		$("txtCarrierDisplay").removeAttribute("vesselCd");
		$("txtCarrierDisplay").hide();			
	}		
	filterLOV3("carrier", "rowCarrier", "carrCd", "item", $F("itemNo"));
}
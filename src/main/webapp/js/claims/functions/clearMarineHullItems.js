/**
 * @author rey
 * @date 02-20-2012
 */
function clearMarineHullItems(){
	try{
		$("txtItemNo").value			= "";
		$("txtItemTitle").value		= "";
		$("txtCurrencyCd").value		= "";
		$("txtDspCurrencyDesc").value	= "";
		$("txtItemDesc").value			= "";
		$("txtItemDesc2").value		= "";
		$("txtCurencyRate").value		= "";
		$("txtDryPlace").value			= "";
		$("txtDryDate").value			= "";
		$("txtVesselCd").value			= "";
		$("txtVesselName").value		= "";
		$("txtGeoLimit").value			= "";
		$("txtVesselType").value		= "";
		$("txtOldName").value			= "";
		$("txtVesselClass").value		= "";
		$("txtPropType").value			= "";
		$("txtRegOwner").value			= "";
		$("txtHullType").value			= "";
		$("txtRegPlace").value			= "";
		$("txtCrewNat").value			= "";
		$("txtGrossTonnage").value		= "";
		$("txtVesselLength").value		= "";
		$("txtNetTonnage").value		= "";
		$("txtVesselBreadth").value	= "";
		$("txtDeadWeight").value		= "";
		$("txtVesselDepth").value		= "";
		$("txtNoOfCrew").value			= "";
		$("txtYrBuilt").value			= "";
		$("txtDeduct").value			= "";
	}catch(e){
		showErrorMessage(e,"clearMarineHullItems");
	}
}
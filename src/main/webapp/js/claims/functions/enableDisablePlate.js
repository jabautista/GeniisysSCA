/**
 * Description: enable/disable Plate No., Motor No. & Serial No.
 * @author Niknok 10.05.11
 * */
function enableDisablePlate(){
	try{
		$("oscmPlateNumber").show();
		$("oscmMotorNumber").show();
		$("oscmSerialNumber").show();
		
		if ($F("txtLineCd") == ""){
			$("txtPlateNumber").readOnly 	= false;
			$("txtMotorNumber").readOnly 	= false;
			$("txtSerialNumber").readOnly 	= false;
		}else{
			if ($F("txtLineCd") == "MC" && nvl(objCLMGlobal.claimId,null) == null){
				$("txtPlateNumber").readOnly 	= false;
				$("txtMotorNumber").readOnly 	= false;
				$("txtSerialNumber").readOnly 	= false;
			}else{
				$("oscmPlateNumber").hide();
				$("oscmMotorNumber").hide();
				$("oscmSerialNumber").hide();
				$("txtPlateNumber").readOnly 	= true;
				$("txtMotorNumber").readOnly 	= true;
				$("txtSerialNumber").readOnly 	= true;
			}
		}
	}catch(e){
		showErrorMessage("enableDisablePlate", e);
	}
}
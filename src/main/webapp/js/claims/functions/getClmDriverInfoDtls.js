/**
 * Retrieves driver info details from mc item info.
 * @author J. Diago
 * 
 */
function getClmDriverInfoDtls(claimId){
	try{
		if ($("groDriverInfo").innerHTML == "Show") return;
		$("driverInfoDtlsDiv").innerHTML = "&nbsp;";
		new Ajax.Updater("driverInfoDtlsDiv", contextPath+"/GICLMotorCarDtlController",{
			parameters:{
				action: "getMotorCarItemDtl",
				claimId: claimId,
				ajax: "2"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("groDriverInfo").hide();
				$("loadDriverInfo").show();
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					null;
				}	
			}
		});
	}catch(e){
		showErrorMessage("getClmDriverInfoDtls", e);
	}
}
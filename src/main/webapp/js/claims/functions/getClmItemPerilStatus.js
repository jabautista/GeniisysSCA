/**
 * Getting peril info's status
 * 
 * @author Niknok Orio
 * @param selected item no.
 */
function getClmItemPerilStatus(itemNo){
	try{
		if ($("groPerilStatus").innerHTML == "Show") return;
		$("perilStatusDiv").innerHTML = "&nbsp;";
		new Ajax.Updater("perilStatusDiv", contextPath+"/GICLItemPerilController",{
			parameters:{
				action: "getItemPerilGrid",
				claimId: objCLMGlobal.claimId,
				itemNo: itemNo,
				lineCd: objCLMGlobal.lineCd,
				ajax: "2"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("groPerilStatus").hide();
				$("loadPerilStatus").show();
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					null;
				}	
			}
		});
	}catch(e){
		showErrorMessage("getClmItemPerilStatus", e);
	}
}
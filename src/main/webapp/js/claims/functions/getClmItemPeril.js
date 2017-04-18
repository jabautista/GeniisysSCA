/**
 * Getting peril info's
 * 
 * @author Niknok Orio
 * @param selected item no.
 */
function getClmItemPeril(itemNo){
	try{
		if ($("groPerilInfo").innerHTML == "Show" || nvl(objCLMItem.selItemIndex,null) == null) return false;   
		if (!checkPerilChanges()){ 
			$("perilInfoDiv").innerHTML = "&nbsp;";
		}else{
			return false;
		}
		new Ajax.Updater("perilInfoDiv", contextPath+"/GICLItemPerilController",{
			parameters:{
				action: "getItemPerilGrid",
				claimId: objCLMGlobal.claimId,
				itemNo: nvl(itemNo,""),
				lineCd: objCLMGlobal.lineCd,
				ajax: "1"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("groPerilInfo").hide();
				$("loadPerilInfo").show();
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					null;
				}
			}
		});
	}catch(e){
		showErrorMessage("getClmItemPeril", e);
	}
}
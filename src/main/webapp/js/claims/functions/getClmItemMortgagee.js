/**
 * Getting mortgagee info's
 * 
 * @author Niknok Orio
 * @param selected
 *            item no.
 */
function getClmItemMortgagee(itemNo){
	try{
		if ($("groMortgagee").innerHTML == "Show") return;
		$("mortgageeInfoDiv").innerHTML = "&nbsp;";
		new Ajax.Updater("mortgageeInfoDiv", contextPath+"/GICLMortgageeController",{
			parameters:{
				action: "getMortgageeGrid",
				claimId: objCLMGlobal.claimId,
				itemNo: itemNo,
				ajax: "1"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("groMortgagee").hide();
				$("loadMortgagee").show();
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					null;
				}	
			}
		});
	}catch(e){
		showErrorMessage("getClmItemMortgagee", e);
	}
}
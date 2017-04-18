/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.21.2011	mark jm			show cargo carriers records
 * 								Parameters	: no more explanation :D 
 */
function retrieveCargoCarriers(parId, itemNo){
	try{		
		new Ajax.Updater("cargoCarrierTable", contextPath+"/GIPIWCargoCarrierController?action=getGIPIWCargoCarrierTableGrid&parId="+parId+"&itemNo="+itemNo, {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("cargoCarrierTable").hide();
			},
			onComplete: function(){
				$("cargoCarrierTable").show();				
			}
		});
	}catch(e){
		showErrorMessage("retrieveCargoCarriers", e);
	}
}
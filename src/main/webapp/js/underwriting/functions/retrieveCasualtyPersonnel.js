/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.14.2011	mark jm			show casualty personnel records
 * 								Parameters	: no more explanation :D 
 */
function retrieveCasualtyPersonnel(parId, itemNo){
	try{		
		new Ajax.Updater("casualtyPersonnelTable", contextPath+"/GIPIWCasualtyPersonnelController?action=getGIPIWCasualtyPersonnelTableGrid&parId="+parId+"&itemNo="+itemNo, {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("casualtyPersonnelTable").hide();
			},
			onComplete: function(){
				$("casualtyPersonnelTable").show();				
			}
		});
	}catch(e){
		showErrorMessage("retrieveCasualtyPersonnel", e);
	}
}
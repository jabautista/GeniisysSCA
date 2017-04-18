/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.02.2011	mark jm			show accessory records
 * 								Parameters	: no more explanation :D 
 */
function retrieveAccessory(parId, itemNo){
	try{		
		
		new Ajax.Updater("accessoryTable", contextPath+"/GIPIWMcAccController?action=getGIPIWMcAccTableGrid&parId="+parId+"&itemNo="+itemNo, {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("accessoryTable").hide();
			},
			onComplete: function(){
				$("accessoryTable").show();				
			}
		});
	}catch(e){
		showErrorMessage("retrieveAccessory", e);
	}
}
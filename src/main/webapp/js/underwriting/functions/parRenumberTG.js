/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.16.2011	mark jm			Renumber item and their detail records
 */
function parRenumberTG(){
	try{
		new Ajax.Request(contextPath + "/GIPIWItemController?action=renumber", {
			parameters : {
				parId : objUWParList.parId
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					showWaitingMessageBox("Items had been renumbered.", imgMessage.INFO, showItemInfo);
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}catch(e){
		showErrorMessage("parRenumberTG", e);
	}
}
/**
 * Description: Retrieves list of item deductibles given the extractId and itemNo for GIPIS101
 * @author mariekris
 * @date 02.28.2013 
 * @param extractId
 * @param itemNo
 */
function getItemDeductibleList2(extractId,itemNo){
	try {
		overlayItemDeductibles = Overlay.show(contextPath+"/GIXXDeductiblesController", {
			urlContent: true,
			urlParameters: {
				action 	 	: "getGIXXItemDeductibles",
				extractId 	: extractId,
				itemNo		: itemNo 
			},
			title: "Deductibles",
			width: 550,
			height: 250,
			draggable: true,
			showNotice: true
		  });
	} catch (e){
		showErrorMessage("getItemDeductibleList2", e);
	}
}
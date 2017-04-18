/**
 * Description: Retrieves list of item mortgagees given the extractId and itemNo for GIPIS101
 * @author mariekris
 * @date 03.06.2013 
 * @param extractId
 * @param itemNo
 */
function getItemMortgagees2(extractId,itemNo){
	try {
		overlayItemMortgagees = Overlay.show(contextPath+"/GIXXMortgageeController", {
			urlContent: true,
			urlParameters: {
				action 	 	: "getGIXXItemMortgagees",
				extractId 	: extractId,
				itemNo		: itemNo 
			},
			title: "Mortgagees",
			width: 630,
			height: 325,
			draggable: true,
			showNotice: true
		  });
	} catch(e) {
		showErrorMessage("getItemMortgagees2", e);
	}	
}
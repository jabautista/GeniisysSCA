/**
 * Description - retrieves the list of deductibles given the policyId and itemGrp
 * 
 * created by - mosesBC
 */

function getItemDeductibleList(policyId,itemNo){
	try {
		overlayItemDeductibles = Overlay.show(contextPath+"/GIPIDeductiblesController", {
			urlContent: true,
			urlParameters: {
				action 	 	: "getItemDeductibles",
				policyId 	: policyId,
				itemNo		: itemNo 
			},
			title: "Deductibles",
			width: 650,
			height: 325,
			draggable: true,
			showNotice: true
		  });
	} catch (e){
		showErrorMessage("getItemDeductibleList", e);
	}
}
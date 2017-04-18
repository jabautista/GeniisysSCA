/**
 * Description - retrieves the list of mortgagees given the policyId and itemGrp
 * 
 * created by - mosesBC
 */
function getItemMortgagees(policyId,itemNo){
	
	overlayItemMortgagees = Overlay.show(contextPath+"/GIPIMortgageeController", {
		urlContent: true,
		urlParameters: {
			action 	 	: "getItemMortgagees",
			policyId 	: nvl($("hidItemPolicyId").value,0),
			itemNo		: nvl($("hidItemNo").value,0) 
		},
		title: "Mortgagees",
		width: 630,
		height: 325,
		draggable: true,
		showNotice: true
	  });
}
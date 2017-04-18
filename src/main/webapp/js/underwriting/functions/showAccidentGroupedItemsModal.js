//jerome 05.17.10 for Grouped Items/Beneficiary information pop-up
function showAccidentGroupedItemsModal(globalParId,itemNo,isFromOverwriteBen){
	Modalbox.show(contextPath+"/GIPIWAccidentItemController?action=showAccidentGroupedItemsModal&globalParId="+globalParId+"&itemNo="+itemNo+"&isFromOverwriteBen="+isFromOverwriteBen, {
		title: "Additional Information",
		width: 910,
		asynchronous:false
	});
}
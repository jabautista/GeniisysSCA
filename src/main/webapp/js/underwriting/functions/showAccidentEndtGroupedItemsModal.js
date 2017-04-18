//Added by Irwin, for endt group item info.
function showAccidentEndtGroupedItemsModal(globalParId,itemNo,isFromOverwriteBen){
	Modalbox.show(contextPath+"/GIPIWAccidentItemController?action=showAccidentEndtGroupedItemsModal&globalParId="+globalParId+"&itemNo="+itemNo+"&isFromOverwriteBen="+isFromOverwriteBen, {
		title: "Additional Information",
		width: 910,
		asynchronous:false
	});
}
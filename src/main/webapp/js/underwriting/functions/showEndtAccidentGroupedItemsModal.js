function showEndtAccidentGroupedItemsModal(globalParId, itemNo, isFromOverwriteBen) {
	
	Modalbox.show(contextPath+"/GIPIWAccidentItemController", {
		title: "Additional Information",
		overlayClose : false,
		headerClose : false,
		params : {
			action : "showEndtACGroupedItems",
			globalParId : globalParId,
			itemNo : itemNo,
			isFromOverwriteBen : isFromOverwriteBen,
			page : 1},
		width: 910,			
		asynchronous: false
	});
	
	/*
	overlayAccidentGroup = Overlay.show(contextPath + "/GIPIWAccidentItemController", {
			urlContent : true,
				urlParameters : {
					action : "showEndtACGroupedItems",
					globalParId : globalParId,
					itemNo : itemNo,
					isFromOverwriteBen : isFromOverwriteBen,
					page : 1},
				width : 910,
				height : 450,
				closable : true,
				draggable : true});
	*/
}
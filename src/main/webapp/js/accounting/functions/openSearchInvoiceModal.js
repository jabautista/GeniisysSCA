function openSearchInvoiceModal() {	
	Modalbox.show(contextPath+"/GIACDirectPremCollnsController?action=openSearchInvoiceModal&ajaxModal=1", {
		title: "Invoice/Inst No.",
		width: 800,
		height: 460,
		asynchronous: false,
		transition: false,
		slideDown: false,
		overlayDuration: 0,
		slideDownDuration: 0,
		slideUpDuration: 0,
		resizeDuration: 0,
		onComplete: function(){
			searchInvoiceModal2();
		}
	});	
}

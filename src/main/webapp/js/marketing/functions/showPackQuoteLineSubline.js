function showPackQuoteLineSubline(){
//	comment out by Gzelle - 12.12.2013 - replaced with overlay codes below
	/*Modalbox.show(contextPath+"/GIPIQuotationController?action=showPackLineSubline&lineCd="+$F("lineCd")+"&packQuoteId="+$F("globalPackQuoteId")+"&userId="+objGIPIPackQuote.userId, {
		title: "Package Line/Subline Coverage",
		width: 700,
		overlayClose: false,
		asynchronous:false,
		headerClose: false
		
	});*/
	try{
		overlayPackQuoteLineSubline = Overlay.show(contextPath+"/GIPIQuotationController", {
			urlContent: true,
			urlParameters: {
				action : "showPackLineSubline",
				lineCd : $F("lineCd"),
				packQuoteId : $F("globalPackQuoteId"),
				userId : objGIPIPackQuote.userId
			},
		    title: "Package Line/Subline Coverage",
		    height : '460px',
			width : '550px',
		    draggable: true
		});
	}catch(e){
		showErrorMessage("showPackQuoteLineSubline", e);
	}
}
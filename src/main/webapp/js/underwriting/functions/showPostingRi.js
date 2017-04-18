// bonok :: 10.16.2013 :: changed overlay to Overlay.show
function showPostingRi(){
	overlayPostRi = Overlay.show(contextPath+"/OverlayController", {
		urlContent: true,
		urlParameters: {
			action: "getPostFRPS",
			ajax: 1,
			lineCd: objRiFrps.lineCd,
			frpsYy: objRiFrps.frpsYy,
			frpsSeqNo: objRiFrps.frpsSeqNo
		},
		title: "Post FRPS",
		height: 142,
		width: 540,
		draggable: true
	});
	
	showPostingFrpsMainPage();
}
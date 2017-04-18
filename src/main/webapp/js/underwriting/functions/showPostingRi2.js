function showPostingRi2(){
	showOverlayContent2(contextPath+"/OverlayController?action=getPostFRPS&ajax=1&lineCd=" + objRiFrps.lineCd + "&frpsYy=" + objRiFrps.frpsYy + "&frpsSeqNo=" + objRiFrps.frpsSeqNo, "Post FRPS",
					540, showPostingFrpsMainPage, 100);
}
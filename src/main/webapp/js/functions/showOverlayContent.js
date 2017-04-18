// show overlay with url to fetch ajax content
//add <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> to overlayPage when using this 
function showOverlayContent(content, title, onCompleteCallback, marginLeft, top, contentMargin) {
	var width = (screen.width - ((marginLeft*2) + (screen.width*.1)))+10;
	Effect.ScrollTo("notice", {duration: .2});
	document.getElementById("opaqueOverlay").style.left = "0";
	document.getElementById("opaqueOverlay").style.display = "block";
	$("opaqueOverlay").setStyle("z-index: 1010;"); // andrew - 10.26.2010 - to handle the showing of calendar in overlay content  
	$("contentHolder").setStyle("z-index: 1011;"); // andrew - 10.26.2010 - to handle the showing of calendar in overlay content
	document.getElementById("contentHolder").style.marginLeft = (marginLeft-5)+"px";
	document.getElementById("contentHolder").style.marginRight = marginLeft+"px";
	document.getElementById("contentHolder").style.top = top+"px";
	document.getElementById("contentHolder").style.display = "block";
	document.getElementById("contentHolder").style.width = width+"px";
	
	if (!(document.getElementById("contentHolder").readAttribute("src") == content)) {
		document.getElementById("contentHolder").writeAttribute("src", content);
		if (content.toUpperCase().match("CONTROLLER")) {
			content = content+"&overlay=1";
		}
		new Ajax.Updater("contentHolder", content, {
			evalScripts: true,
			asynchronous: true,
			onCreate: function () {
				$("contentHolder").update('<div style="margin: auto; width:'+(contentMargin*2.3)+'px;" id="dummyLoading"></div>');
				showLoading("dummyLoading", "Loading, please wait...", "0");
			},
			onComplete: function (response) {
				try {
					if (checkErrorOnResponse(response)) {
						if (onCompleteCallback != "" && onCompleteCallback != null) {
							onCompleteCallback();
						}
						$("overlayTitle").update(title.toUpperCase());
					} else {
						hideOverlay();
					}
				} catch (e) {
					showErrorMessage("showOverlayContent", e);
				}
			}
		});
	}
}
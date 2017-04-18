/*
 * Created by	: andrew
 * Date			: 10.29.2010
 * Description	: A version of showOverlayContent which handles the problem on different monitor resolutions
 * Parameters	: content - subpage which will be the content of the window
 *				  title - title of window
 *				  width - width of window
 *				  onCompleteCallBack - function after ajax complete (can be null or empty string)
 *				  zindex - sets z-index to fix overlay issues
 *
 * Note: add <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> to overlayPage when using this 
 */

function showOverlayContent2(content, title, width, onCompleteCallback, zindex) {	
	if (($("contentHolder").readAttribute("src") != content)) {
		$("contentHolder").writeAttribute("src", content);
		if (content.toUpperCase().match("CONTROLLER")) {
			content = content+"&overlay=1";
		}
		new Ajax.Updater("contentHolder", content, {
			evalScripts: true,
			asynchronous: false,
			onCreate: function () {
				$("contentHolder").update('<div style="vertical-align: middle;" id="dummyLoading"></div>');
				showLoading("dummyLoading", "Loading, please wait...", "0");
			},
			onComplete: function (response) {
				try {					
					if (checkErrorOnResponse(response)) {				
						var height = 0;
						$("opaqueOverlay").style.display = "block";
						var overlayHeight = document.documentElement.scrollHeight;
						$("opaqueOverlay").setStyle("position: absolute; height: " +overlayHeight+"px;");
						
						$("overlayTitle").update(title.toUpperCase());						
						$("contentHolder").style.display = "block";
						//$("contentHolder").style.overflow = "visible";
						height = parseInt($("contentHolder").clientHeight);						
						$("contentHolder").style.top = (document.documentElement.scrollTop + (self.innerHeight - height) / 2) + 'px';
						$("contentHolder").style.left = ((self.innerWidth - width) / 2) + 'px';						
						$("contentHolder").style.width = width+"px";
						$("contentHolder").setStyle("position: absolute;");					
						
						if(zindex != null){
							$("opaqueOverlay").setStyle("z-index: "+zindex+";");
							$("contentHolder").setStyle("z-index: "+(zindex+1)+";");
						}
						
						if (onCompleteCallback != "" && onCompleteCallback != null) {
							onCompleteCallback();
						}
					} else {
						hideOverlay();
					}
				} catch (e) {
					showErrorMessage("showOverlayContent2", e);
				}
			}
		});
	}		
}
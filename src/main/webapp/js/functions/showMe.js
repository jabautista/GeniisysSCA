function showMe(content, width) {
	var i = (screen.width - width) / 2;
	
	Effect.ScrollTo("notice", {duration: .2});
	document.getElementById("opaqueOverlay").style.left = "0";
	document.getElementById("opaqueOverlay").style.display = "block";
	document.getElementById("contentHolder").style.marginLeft = i-(screen.width*.05)+"px";
	document.getElementById("contentHolder").style.marginRight = i-(screen.width*.05)+"px";
	document.getElementById("contentHolder").style.top = "150px";
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
				$("contentHolder").update('<div style="margin: 50px auto;" id="dummyLoading"></div>');
				showLoading("dummyLoading", "Loading, please wait...", "0");
			}
		});
	}
}
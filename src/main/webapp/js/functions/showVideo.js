// show video overlay
function showVideo(content) {
	try{
		$("closer").show();
		$("videoHolder").update('<OBJECT CLASSID="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" '+
				'CODEBASE="http://www.apple.com/qtactivex/qtplugin.cab" WIDTH="480" HEIGHT="270"> '+
				'<PARAM NAME="src" VALUE="'+content+'" > ' +
				'<PARAM NAME="autoplay" VALUE="false" > '  +
				'<PARAM NAME="bgcolor" VALUE="c0c0c0" > '  +
				'<PARAM NAME="controller" VALUE="true" > ' +
				'<EMBED SRC="'+content+'" TYPE="image/x-macpaint" '+
				'PLUGINSPAGE="http://www.apple.com/quicktime/download" WIDTH="480" HEIGHT="270" AUTOPLAY="false" BGCOLOR="c0c0c0" CONTROLLER="true"></EMBED> '+
				'</OBJECT>');
		Effect.Appear("videoHolder", {
			duration: .001,
			afterFinish: function () {
				//Modalbox.resizeToContent(); commented by: nica 05.12.2011
			}
		});
	}catch(e){
		showErrorMessage("showVideo", e);
	}
}
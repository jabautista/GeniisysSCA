// created by Udel 06142012
function showGenerateBondSeqNoPage(){
	try{
		new Ajax.Request(contextPath+"/GenerateBondSeqController", {
			method: "GET",
			parameters: {
				action : "showGenerateBondSeqNoPage"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: showNotice("Loading Generate Bond Sequence No. page, please wait..."),
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
				Effect.Appear($("mainContents").down("div", 0), {
					duration: .001
				});
			}
		});			
	
	} catch (e){
		showErrorMessage("showGenerateBondSeqNoPage", e);
	}
}
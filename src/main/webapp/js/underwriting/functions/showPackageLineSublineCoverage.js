/**
 * Shows Package Line, Subline Coverage Maintenance Page
 * Module: GIISS096 - Package Line, Subline Coverage Maintenance
 * @author Ildefonso Ellarina Jr
 * */
function showPackageLineSublineCoverage(){
	try{ 
		new Ajax.Request(contextPath+"/GIISLineSublineCoveragesController", {
			method: "GET",
			parameters: {
				action : "showPackageLineCoverage"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
				Effect.Appear($("mainContents").down("div", 0), {
					duration: .001
				});
			}
		});		
	}catch(e){
		showErrorMessage("showPackageLineSublineCoverage",e);
	}	
}
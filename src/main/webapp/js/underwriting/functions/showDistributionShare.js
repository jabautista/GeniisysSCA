/**
 * Distribution Share Section
 * @author Halley Pates
 * */
function showDistributionShare(){ 
	try {
		new Ajax.Request(contextPath+"/GIISDistributionShareController",{
			parameters : {
				action : "getGIIS060LineListing",
				ajax : "1"
			},
			asynchronous: false,
			evalScripts: true,
			onComplete : function(result) {
				$("mainContents").update(result.responseText);
			}
		});
	} catch (e){
		showErrorMessage("showDistributionShare", e);
	}
}
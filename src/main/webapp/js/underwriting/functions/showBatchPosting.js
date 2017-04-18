//Gzelle 08.22.2013	Batch Posting
function showBatchPosting(lineCd){
	new Ajax.Request(contextPath + "/BatchPostingController", {
	    parameters : {action : "showBatchPosting",
	    			  lineCd : lineCd,
	    			    ajax : 1},
	    onCreate: showNotice("Loading Batch Posting.  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showBatchPosting - onComplete : ", e);
			}								
		} 
	});
}
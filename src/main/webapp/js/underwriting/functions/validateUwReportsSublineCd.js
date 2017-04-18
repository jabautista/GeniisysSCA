function validateUwReportsSublineCd(){
	new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
		method: "GET",
		parameters: {action    : "validateSublineCd",
					 lineCd	   : $F("lineCd"),
					 sublineCd : $F("sublineCd")},
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				var obj = JSON.parse(response.responseText);
				if(obj.sublineName == null){
					$("sublineName").value = "ALL SUBLINES";
					clearFocusElementOnError("sublineCd", "Invalid value for field SUBLINE_CD.");
				}else{
					$("sublineName").value = obj.sublineName;
				}
			}
		}
	});
}
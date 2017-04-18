function validateUwReportsLineCd(){
	new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
		method: "GET",
		parameters: {action      : "validateLineCd",
					 lineCd	     : $("lineCd").value,
					 sublineCd   : $("sublineCd").value,
					 issCd	     : $("issCd").value,
					 sublineName : $("sublineName").value},
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				var obj = JSON.parse(response.responseText);
				if(obj.found == "Y"){
					$("lineName").value = obj.lineName;
				}else{
					$("lineName").value = "ALL LINES";
					clearFocusElementOnError("lineCd", "Invalid value for field LINE_CD.");
				}
				$("sublineCd").value = "";
				$("sublineName").value = "ALL SUBLINES";
			}
		}
	});
}
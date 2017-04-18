/**
 * Validations for UW Production Reports Tabs
 * Module: GIPIS901a - UW Production Reports
 * @author Marco Paolo Rebong
 */
function validateUwReportsIssCd(){
	new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
		method: "GET",
		parameters: {action    : "validateIssCd",
					 issCd	   : $F("issCd"),
					 lineCd	   : $F("lineCd")},
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				var obj = JSON.parse(response.responseText);
				if(obj.issName == null){
					$("issName").value = "ALL ISSUE SOURCE";
					clearFocusElementOnError("issCd", "Invalid value for field ISS_CD.");
				}else{
					$("issName").value = obj.issName;
				}
			}
		}
	});
}
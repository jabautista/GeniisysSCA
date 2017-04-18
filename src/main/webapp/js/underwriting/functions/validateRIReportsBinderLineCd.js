/**
 * Validates Input Line Cd 
 * Module: GIRIS051 - Generate RI Reports (Binder tab)
 * @author Shan Bati 01.17.2013
 */
function validateRIReportsBinderLineCd(){
	try{
		new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController", {
			method: "GET",
			parameters: {
				action: "validateBinderLineCd",
				lineCd: $F("txtLineCd")
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.exists == "N"){
						clearFocusElementOnError("txtLineCd", "Invalid value for field LINE_CD.");
					}else {
						if ($F("txtLineCd") == "SU"){
							$("chkPrNtcTD").show();	
							$("chkPrRiBndRnwlNtc").value = "N";
						}else {
							$("chkPrNtcTD").hide();	
							$("chkPrRiBndRnwlNtc").value = "N";
						}
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("validateRIReportsBinderLineCd", e);
	}
}
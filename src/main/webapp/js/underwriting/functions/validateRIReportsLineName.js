/**
 * Validates Input Line Name
 * Module: GIRIS051 - Generate RI Reports
 * @author Shan Bati 01.29.2013
 */
function validateRIReportsLineName(lineNameId, lineCdId){
	try{
		new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
			method: "GET",
			parameters: {
				action: 	"validateRIReportsLineName",
				lineName:	$F(lineNameId)
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				var obj = JSON.parse(response.responseText);
				if(obj.lineCd == null){
					clearFocusElementOnError(lineNameId, "Invalid value for field LINE NAME.");
				}
				$(lineCdId).value = obj.lineCd;
			}
		});
	}catch(e){
		showErrorMessage("validateRIReportsLineName", e);
	}
}
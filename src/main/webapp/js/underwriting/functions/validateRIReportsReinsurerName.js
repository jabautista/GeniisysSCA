/**
 * Validates Input Reinsurer Name
 * Module: GIRIS051 - Generate RI Reports
 * @author Shan Bati 01.30.2013
 */
function validateRIReportsReinsurerName(riNameId, riCdId, msg){
	try{
		new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
			method: "GET",
			parameters: {
				action: 	"validateRIReportsReinsurerName",
				riName:	$F(riNameId)
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				var obj = JSON.parse(response.responseText);
				if(obj.riCd == null){
					clearFocusElementOnError(riNameId, msg);
				}
				$(riCdId).value = obj.riCd;
			}
		});
	}catch(e){
		showErrorMessage("validateRIReportsReinsurerName", e);
	}
}
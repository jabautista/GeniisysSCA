/**
 * Validates Input Reinsurer Sname
 * Module: GIRIS051 - Generate RI Reports (Expiry List tab)
 * @author Shan Bati 02.06.2013
 */
function validateRIReportsReinsurerSname(riSnameId, riCdId, msg){
	try{
		new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
			method: "GET",
			parameters: {
				action: 	"validateRIReportsRiSname",
				riSname:	$F(riSnameId)
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				var obj = JSON.parse(response.responseText);
				if(obj.riCd == null){
					clearFocusElementOnError(riSnameId, /*obj.msg*/ msg); 
				}
				$(riCdId).value = obj.riCd;
				
				if($("outwardRB").checked){
					if (obj.stat == "N"){
						$(riSnameId).value = null;
						$(riCdId).value = null;
						showMessageBox("Reinsurer is not accredited.", "E");
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("validateRIReportsRiSname", e);
	}
}
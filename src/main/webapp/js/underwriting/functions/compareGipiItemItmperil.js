/**
 * Compares the tsi, premium and annualized amounts 
 * from the gipi_witem tables against the corresponding 
 * amounts from the gipi_witmperl table
 * Module: GIUWS004, GIUWS001, GIUWS006
 * @author Jerome Orio
 * @since 04/12/2011
 * 
 * @modified by : Andrew Robes
 * @date : 10/02/2011
 * -added parameter condition for package par
 */

function compareGipiItemItmperil(action){
	try{
		var ok = true;
		var action = action == '1' ? "compareGipiItemItmperil" :"compareGipiItemItmperil2";
		new Ajax.Request(contextPath+"/GIUWPolDistController",{
			parameters:{
				action: action,
				packPolFlag: (objUWGlobal.packParId != null ? "N" : $("globalPackPolFlag").value),
				parId: (objUWGlobal.packParId != null ? $F("initialParId") : $("globalParId").value),
				lineCd: (objUWGlobal.packParId != null ? $F("initialLineCd") : $("globalLineCd").value)
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
				if (checkErrorOnResponse(response)){
					if (res.vMsgAlert != null){
						ok = false;
						customShowMessageBox(res.vMsgAlert, imgMessage.ERROR, "btnCreateItems");
						return false;
					}	
				}
			}	
		});	
		return ok;
	}catch(e){
		showErrorMessage("compareGipiItemItmperil", e);
	}	
}
/*
 * Created by	: belle bebing
 * Date			: 02.16.2011
 * Description	: Enable or disable Create Peril Button if default peril exist
 */
function checkIfDefaultPerilExist() {
	try{
		var lineCd = ($("globalLineCd") == null ? objUWGlobal.lineCd : $F("globalLineCd"));
		var sublineCd = ($("globalSubineCd") == null ? objUWGlobal.sublineCd : $F("globalSublineCd"));
		new Ajax.Request(contextPath+"/GIISPerilController?action=checkIfPerilExists&lineCd="+lineCd+"&nbtSublineCd="+sublineCd, {
			method: "POST",
			evalScripts: true,
			asynchronous: true,
			onComplete: function (response)	{
				if (checkErrorOnResponse(response)) {
					if (response.responseText == 'Y'){
						enableButton("btnCreatePerils");
					} else {
						disableButton("btnCreatePerils");
					}
					$("parInformationMainDiv").show();
				}
			}
		});
	} catch(e){
		showErroMessag("checkIfDefaultPerilExist", e);
	}
}
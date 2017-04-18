//benjo 08.03.2016 SR-5512
function showViewIntreaty(lineCd, trtyYy, intrtySeqNo){
	try {
		new Ajax.Request(contextPath + "/GIRIIntreatyController?action=showViewIntreaty", {
			parameters : {
				lineCd : lineCd,
				trtyYy : trtyYy,
				intrtySeqNo : intrtySeqNo
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showViewIntreaty", e);
	}
}
function createItemsGIUWS018(){
	var distNo = objGIPIPolbasicPolDistV1.distNo;
	var policyId = objGIPIPolbasicPolDistV1.policyId;
	var lineCd	= objGIPIPolbasicPolDistV1.lineCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.lineCd);
	var sublineCd	= objGIPIPolbasicPolDistV1.sublineCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.sublineCd);
	var issCd	= objGIPIPolbasicPolDistV1.issCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.issCd);
	var packPolFlag	= objGIPIPolbasicPolDistV1.packPolFlag == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.packPolFlag);
	var delDistTable = $("btnCreateItems").value == "Recreate Items" ? "Y" : "N";
	
	try {
		new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
			method: "POST",
			parameters: {
				action:			"createItemsGIUWS018",
				distNo : 		distNo,
				policyId : 		policyId,
				lineCd:			lineCd,
				sublineCd:		sublineCd,
				issCd:			issCd,
				packPolFlag : 	packPolFlag,
				delDistTable :  delDistTable
			},
			onCreate: function(){
				showNotice("Processing information...");
				setCursor("wait");
			},
			onComplete: function(response){
				hideNotice();
				setCursor("default");
				if(checkErrorOnResponse(response)){
					if( response.responseText == "SUCCESS"){
						showMessageBox("Recreating Items complete.", imgMessage.SUCCESS);
						changeTag = 0;
					}
					loadGIUWWPerildsTableListing();
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}catch(e){
		showErrorMessage("createItemsGIUWS018", e);
	}
}
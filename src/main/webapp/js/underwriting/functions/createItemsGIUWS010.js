/**
 * Creates/Recreates items for module/s GIUWS010 and GIUWS018
 * 
 */
function createItemsGIUWS010(){
	var distNo = objGIPIPolbasicPolDistV1.distNo;
	var policyId = objGIPIPolbasicPolDistV1.policyId;
	var lineCd	= objGIPIPolbasicPolDistV1.lineCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.lineCd);
	var sublineCd	= objGIPIPolbasicPolDistV1.sublineCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.sublineCd);
	var issCd	= objGIPIPolbasicPolDistV1.issCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.issCd);
	var packPolFlag	= objGIPIPolbasicPolDistV1.packPolFlag == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.packPolFlag);
	var delDistTable = $("btnCreateItems").getAttribute("enValue") == "Recreate Items" ? "Y" : "N";
	
	new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
		method: "POST",
		parameters: {
			action:			"createItemsGIUWS010",
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
					objGIPIPolbasicPolDistV1.distFlag = "1";
					objGIPIPolbasicPolDistV1.meanDistFlag = "Undistributed";
					populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
				}
				loadGIUWWitemdsTableListing();
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}
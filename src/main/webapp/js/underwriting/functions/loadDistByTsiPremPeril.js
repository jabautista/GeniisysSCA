/**
 * Load selected record from overlay 
 * GIUWS017 (Dist by TSI/Prem (Peril))
 * @author niknok
 * @since 07.28.2011
 */
function loadDistByTsiPremPeril(){
	try{
		new Ajax.Request(contextPath + "/GIUWPolDistController?action=loadDistByTsiPremPeril", {
			method: "GET",
			parameters: {
				policyId: objGIPIPolbasicPolDistV1.policyId,
				distNo: objGIPIPolbasicPolDistV1.distNo,
				polFlag: objGIPIPolbasicPolDistV1.polFlag,
				parType: objGIPIPolbasicPolDistV1.parType,
				parId: objGIPIPolbasicPolDistV1.parId,
				lineCd: objGIPIPolbasicPolDistV1.lineCd,
				sublineCd: objGIPIPolbasicPolDistV1.sublineCd,
				issCd: objGIPIPolbasicPolDistV1.issCd,
				packPolFlag: objGIPIPolbasicPolDistV1.packPolFlag
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {	
					objUW.hidObjGIUWS017 = {};
					objUW.hidObjGIUWS017.GIUWPolDist = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					objUW.hidObjGIUWS017.GIUWPolDistPostedRecreated = [];
					fireEvent($("btnLoadRecords"), "click");
					$("showDistGroup").innerHTML == "Show" ? fireEvent($("showDistGroup"), "click") :null;
					$("showDistPeril").innerHTML == "Show" ? fireEvent($("showDistPeril"), "click") :null;
					$("showDistShare").innerHTML == "Show" ? fireEvent($("showDistShare"), "click") :null;
				}
			}
		});
	}catch(e){
		showErrorMessage("loadDistByTsiPremPeril", e);
	}	
}
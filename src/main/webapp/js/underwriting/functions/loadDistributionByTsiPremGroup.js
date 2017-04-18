function loadDistributionByTsiPremGroup(){
	if(unescapeHTML2(objGIPIPolbasicPolDistV1.lineCd) == "SU"){
		$("lblPolNo").innerHTML = "Bond";
		$("lblAssdName").innerHTML = "Principal";
		$("grpTSIHdrLbl").innerHTML = "Bond Amount";
		$("shareTSIHdrLbl").innerHTML = "Bond Amount";
		$("grpTSILbl").innerHTML = "Bond Amount";
	}else{
		$("lblPolNo").innerHTML = "Policy";
		$("lblAssdName").innerHTML = "Assured Name";
		$("grpTSIHdrLbl").innerHTML = "Group TSI"; //"Sum Insured"; changed by robert SR 5053 12.21.15
		$("shareTSIHdrLbl").innerHTML = "Sum Insured";
		$("grpTSILbl").innerHTML = "Group TSI"; //"Sum Insured"; changed by robert SR 5053 12.21.15
	}
	
	new Ajax.Request(contextPath + "/GIUWPolDistController", {
		method: "GET",
		parameters: {
			action : "loadDistributionByTsiPremGroup",
			policyId: objGIPIPolbasicPolDistV1.policyId,
			distNo: objGIPIPolbasicPolDistV1.distNo,
			parType: objGIPIPolbasicPolDistV1.parType,
			polFlag: objGIPIPolbasicPolDistV1.polFlag
		},
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				objUW.hidObjGIUWS016 = {};
				objUW.hidObjGIUWS016.GIUWPolDist = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
				objUW.hidObjGIUWS016.GIUWPolDistClone = response.responseText;		// shan 06.25.2014
				if(checkIfGiuwPolicydsRecordsExist(objUW.hidObjGIUWS016.GIUWPolDist)){
					objUW.hidObjGIUWS016.errorSw = "N";
					fireEvent($("dummyShowListing"), "click");
				}else{
					objUW.hidObjGIUWS016.errorSw = "Y";
					fireEvent($("dummyShowListing"), "click");
				}
			}else{
				showMessageBox(response.responseText, "E");
			}
		}
	});
}
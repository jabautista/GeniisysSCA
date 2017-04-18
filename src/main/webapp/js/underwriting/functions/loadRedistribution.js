function loadRedistribution(){
	new Ajax.Request(contextPath + "/GIPIPolbasicController?action=executeGIUWS012V370PostQuery", {
		method: "GET",
		parameters: {
			policyId: objGIPIPolbasic.policyId
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {
			if (checkErrorOnResponse(response)) {
				var obj = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
				objGIPIPolbasic.sveFacultativeCode = obj.sveFacultativeCode;
				
				if (obj.distStatus == "OK") {
					objGIPIPolbasic.negDistNo = obj.negDistNo;
					objGIPIPolbasic.distNo = obj.negDistNo;
					
					new Ajax.Request(contextPath + "/GIUWPolDistController?action=getGIUWPolDistForRedistribution", {
						method: "GET",
						parameters: {
							parId: objGIPIPolbasic.parId,
							distNo: objGIPIPolbasic.distNo
						},
						evalScripts: true,
						asynchronous: false,
						onComplete: function (response2) {
							objUW.hidObjGIUTS021 = {};
							objUW.hidObjGIUTS021.GIUWPolDist = JSON.parse(response2.responseText.replace(/\\/g, '\\\\'));
							fireEvent($("btnLoadRecords"), "click");
						}
					});
				} else if (obj.distStatus == "REDIST") {//added edgar 11/21/2014
					objUW.hidObjGIUTS021 = {};
					objUW.hidObjGIUTS021.GIUWPolDist = {};
					fireEvent($("btnLoadRecords"), "click");
					showMessageBox("Policies already redistributed cannot be process for redistribution.", imgMessage.INFO);
					
					$("hrefCollnDate").style.display = "none";
					$("redistDateDiv").removeClassName("required");
					$("txtRedistributionDate").removeClassName("required");
					disableButton("btnRedistribute");
					
				} else if (obj.distStatus == "NO_DIST") {
					objUW.hidObjGIUTS021 = {};
					objUW.hidObjGIUTS021.GIUWPolDist = {};
					fireEvent($("btnLoadRecords"), "click");
					//showMessageBox("This policy has no distribution No.", imgMessage.INFO); //edgar 10/14/2014 replaced with message below
					showMessageBox("This policy has no valid distribution no."+
							       " Please check the policy pol flag or the policy distribution status."+
							       " Undistributed or spoiled policies cannot be processed for redistribution.", imgMessage.INFO);
					// added by andrew - 12.6.2012
					$("hrefCollnDate").style.display = "none";
					$("redistDateDiv").removeClassName("required");
					$("txtRedistributionDate").removeClassName("required");
					disableButton("btnRedistribute");
					// end andrew
				} else {
					objUW.hidObjGIUTS021 = {};
					objUW.hidObjGIUTS021.GIUWPolDist = {};
					fireEvent($("btnLoadRecords"), "click");
				}
			}
		}
	});
}
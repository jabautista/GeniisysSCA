/**
 * Description: Get GICLS250 (Claim Listing Per Policy) (From Basic Info Menu)
 * @author Niknok 12.02.11
 * */
function showClmListingPerPolicy(){
	try{var newDiv = new Element("div");
		newDiv.setAttribute("id", "gicls0250MainDiv");
		newDiv.setAttribute("name", "gicls0250MainDiv");
		
		new Ajax.Request(contextPath+"/GICLClaimsController", {
			parameters: {
				action : "showClmListingPerPolicy",
				lineCd: objCLM.basicInfo.lineCode,
				sublineCd: objCLM.basicInfo.sublineCd,
				polIssCd: objCLM.basicInfo.policyIssueCode,
				issueYy: objCLM.basicInfo.issueYy,
				polSeqNo: objCLM.basicInfo.policySequenceNo,
				renewNo: objCLM.basicInfo.renewNo,
				module: "GICLS250",
				callFrom : "GICLS010"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					$("mainNav").hide();
					$("basicInformationMainDiv").hide();
					newDiv.update(response.responseText);
					$("dynamicDiv").insert({bottom : newDiv});
				}
			}
		});	
	}catch(e){
		showErrorMessage("showClmListingPerPolicy", e);
	}
}
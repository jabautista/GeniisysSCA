//Joms Diago 04.29.2013
function showViewDistributionStatus(callingModule, policyId){
	//new Ajax.Updater("dynamicDiv", contextPath+"/GIPIPolbasicController?action=showViewDistributionStatus&callingModule="+nvl(callingModule, "")+"&policyId="+nvl(policyId, ""),{
	//marco - 07.22.2014 - changed from updater to request to prevent dynamicDiv from being updated if called from distribution modules
	new Ajax.Request(contextPath+"/GIPIPolbasicController?action=showViewDistributionStatus&callingModule="+nvl(callingModule, "")+"&policyId="+nvl(policyId, ""),{
		method: "POST",
		parameters:{
			lineCd: 	objGIPIS130.details != null ? objGIPIS130.details.lineCd : "",
			sublineCd: 	objGIPIS130.details != null ? objGIPIS130.details.sublineCd : "",
			issCd:		objGIPIS130.details != null ? objGIPIS130.details.issCd : "",
			issueYy:	objGIPIS130.details != null ? objGIPIS130.details.issueYy : "",
			polSeqNo:	objGIPIS130.details != null ? objGIPIS130.details.polSeqNo : "",
			renewNo:	objGIPIS130.details != null ? objGIPIS130.details.renewNo : ""
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Getting View Distribution Status page, please wait..."),
		onComplete: function (response) {
			hideNotice();
			if(checkErrorOnResponse(response)){ 
				 if (objUWGlobal.previousModule != null){
					 if (objUWGlobal.previousModule == "GIUWS005"){
							$("summarizedDistDiv").update(response.responseText);
							$("summarizedDistDiv").show();
							$("parListingMainDiv").hide();
							$("parInfoMenu").hide();
							$("preliminaryOneRiskDistMainDiv").hide();	
					 }else if (objUWGlobal.previousModule == "GIUWS004"){//Added by Gzelle 06132014
						 	$("summarizedDistDiv").show();
							$("summarizedDistDiv").update(response.responseText);	
							$("parListingMainDiv").hide();
							$("parInfoMenu").hide();	
							$("preliminaryOneRiskDistMainDiv").hide();
					 }else if (objUWGlobal.previousModule == "GIUWS003"){//edgar 06/10/2014
							$("summarizedDistDiv1").update(response.responseText);
							$("summarizedDistDiv1").show();
							$("parListingMainDiv").hide();
							$("parInfoMenu").hide();
							$("preliminayPerilDistMainDiv").hide();	
					 }else if(objUWGlobal.previousModule == "GIUWS012"){
						 	$("distributionByPerilMainDiv").hide();
							$("summarizedDistDiv").update(response.responseText);
							$("summarizedDistDiv").show();
					 }else if(objUWGlobal.previousModule == "GIUWS017"){
						 	$("distByTsiPremPerilMainDiv").hide();
							$("summarizedDistDiv").update(response.responseText);
							$("summarizedDistDiv").show();
					 }else if(objUWGlobal.previousModule == "GIUWS016"){
						 	$("distrByTsiPremGroupMainDiv").hide();
						 	$("summarizedDistDiv").update(response.responseText);
							$("summarizedDistDiv").show();
					 }else if(objUWGlobal.previousModule == "GIUWS013"){
						 	$("distributionByGroupMainDiv").hide();
							$("summarizedDistDiv").update(response.responseText);
							$("summarizedDistDiv").show(); 
					 }if (objUWGlobal.previousModule == "GIUWS006"){
							$("summarizedDistDiv").update(response.responseText);
							$("summarizedDistDiv").show();
							$("parListingMainDiv").hide();
							$("parInfoMenu").hide();
							$("preliminayPerilDistMainDiv").hide();	
					 }
				}else{
					$("dynamicDiv").update(response.responseText);
				}
				
			}
		}
	});
}
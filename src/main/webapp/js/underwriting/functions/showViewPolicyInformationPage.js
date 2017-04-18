/**
 * Description - shows the viewPolicyInformationPage.jsp
 * created by  - mosesBC
 */
function showViewPolicyInformationPage(policyId){
	new Ajax.Request(contextPath+"/GIPIPolbasicController?action=showViewPolicyInformationPage",{
		method: "POST",
		parameters: {policyId : policyId},
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting Policy Information page, please wait..."),
		onComplete: function (response) {
			try {			hideNotice();
				if(checkErrorOnResponse(response)){
					setDocumentTitle("View Policy Information");
					if(objGIPIS100.callingForm != "GIPIS000"){						
						if ($("claimViewPolicyInformationDiv") != null){
							//$("claimInfoDiv").hide(); // replaced by: Nica 05.23.2012 - to resolve duplicate txtLineCd field when access in GICLS010
							//$("claimInfoDiv").update(""); //replaced by irwin 6.28.2012
							$("basicInformationMainDiv").update("");
							
							$$("div[name='mainNav']").each(function(e){
								if(nvl(e.getAttribute("claimsBasicMenu"),"N") == "Y"){
									e.hide();
								}
							});
							
							$("claimViewPolicyInformationDiv").update(response.responseText);
							$("claimViewPolicyInformationDiv").show();
						} else if(objGIPIS100.callingForm == "GIPIS132"){ //CarloR 07.26.2016 start
							$("policyInformationDiv").update(response.responseText);
							$("policyInformationDiv").show();
							$("viewPolicyStatusMainDiv").hide(); //end
						} else {
							if(objGIPIS100.callingForm == "GIPIS199"){	// shan 09.02.2014
								$("policyInfoDiv").update(response.responseText);
								$("policyInfoDiv").show();
							}else{ 
								$("dynamicDiv").update(response.responseText);
							}
						}
					} else {
						$("mainContents").update(response.responseText);
					}
				}
			} catch (e){
				showErrorMessage("showViewPolicyInformationPage - onComplete", e);
			}
		}
	});

}
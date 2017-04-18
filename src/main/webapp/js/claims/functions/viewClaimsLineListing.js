/**
 * @author rey
 * @date 09-08-2011
 * Claim Line Listing
 * edited by Irwin - added Loss Category Tag Listing  - 12.01.11
 */
function viewClaimsLineListing(){
	try{
		new Ajax.Updater("claimsDiv", contextPath+"/GIISController", {
			method: "GET",
			parameters: {
				action: "getLineListing",
				moduleId: objCLMGlobal.callingForm,
				polIssCd: ""
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function ()	{
				showNotice("Getting Claim list, please wait...");
			},
			onComplete: function ()	{
				hideNotice("");
				setModuleId();
				Effect.Appear($("claimsDiv").down("div", 0), {
					duration: .001,
					afterFinish: function () {
						setDocumentTitle("Claim Line Listing");
						$("btnCreateQuotationFromQuotationList").hide();
						$("btnQuotationList").hide();
						$("btnPARList").hide(); 
						$("btnFRPSList").hide();
						$("btnQuotationStatusList").hide();
						$("btnClaimListingList").show();
						$("filterTextLine").focus();
						
						$$("div[name='line']").each(
							function (line)	{line.observe("dblclick", function ()	{
								line.toggleClassName("selectedRow");
								if (line.hasClassName("selectedRow"))	{
									$("lineCd").value = line.getAttribute("id").substring(4);
									$("lineName").value = line.down("label", 0).innerHTML;
									$$("div[name='line']").each(function (li)	{
										if (line.getAttribute("id") != li.getAttribute("id"))	{
											li.removeClassName("selectedRow");
										}
									});
									objCLMGlobal.lineCd = $F("lineCd");
									objCLMGlobal.lineName = $F("lineName");
									
									if (nvl(objCLMGlobal.callingForm,"GICLS002") == "GICLS002"){
										$("dynamicDiv").down("div",0).hide(); //hide claims menu
										updateMainContentsDiv("/GICLClaimsController?action=getClaimTableGridListing&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&moduleId=GICLS002",
											  "Getting Claims listing, please wait...");
									}else if(objCLMGlobal.callingForm == "GICLS053"){ // irwin
										$("dynamicDiv").down("div",0).hide(); //hide claims menu
										showUpdateLossRecoveryTagListing($F("lineCd"));
									}else if(objCLMGlobal.callingForm == "GICLS026"){ // robert
										$("dynamicDiv").down("div",0).hide(); //hide claims menu
										showNoClaimListing($F("lineCd"));
									}else if(objCLMGlobal.callingForm == "GICLS052"){ // christian
										$("dynamicDiv").down("div",0).hide(); //hide claims menu
										showLossRecoveryListing($F("lineCd"));
									}else if(objCLMGlobal.callingForm == "GICLS260"){ // Nica 03.14.2013
										showClaimInformationListing($F("lineCd"), $F("lineName"));
									}else if(objCLMGlobal.callingForm == "GICLS044"){ //Kenneth L. 05.21.2013
										showReassignClaimRecord($F("lineCd"));
									}else if(objCLMGlobal.callingForm == "GICLS038"){ //J. Diago 09.02.2013
										objGICLS038 = new Object();
										showCLMBatchRedistribution("R", $F("lineCd"));
									}else if(objCLMGlobal.callingForm == "GICLS125"){
										$("dynamicDiv").down("div",0).hide();
										showReOpenRecovery($F("lineCd"));	//Gzelle 09102015 SR3292
									}else{
										showClaimBasicInformation();
									}
								}
							});
						});
					}
				});
			}
		});
	}catch(e){
		showErrorMessage("viewClaimsLineListing",e);
	}
}
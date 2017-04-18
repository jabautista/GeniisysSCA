function getLineListingForBatchPosting(){
	objUWGlobal.module = "GIPIS207";
	try{
		new Ajax.Updater("underwritingDiv", contextPath+"/GIISController", {
			method: "GET",
			parameters: {
				action: "getLineListing",
				moduleId: "GIPIS207"
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function ()	{
				showNotice("Getting Line List, please wait...");
			},
			onComplete: function ()	{
				hideNotice("");
				setModuleId();
				Effect.Appear($("underwritingDiv").down("div", 0), {
					duration: .001,
					afterFinish: function () {
						setDocumentTitle("PAR Line Listing");
						$("btnCreateQuotationFromQuotationList").hide();
						$("btnQuotationList").hide();
						$("btnPARList").show();
						$("btnFRPSList").hide();
						$("btnQuotationStatusList").hide();
						$("btnClaimListingList").hide();
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
									objUWGlobal.lineCd = $F("lineCd");
									showBatchPosting($F("lineCd"));
								}
							});
						});
					}
				});
			}
		});
	}catch(e){
		showErrorMessage("getLineListingForBatchPosting",e);
	}
}
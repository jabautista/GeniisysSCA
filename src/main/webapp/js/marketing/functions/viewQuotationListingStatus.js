/**
 * for Quotation Status Line Listing
 * @author rey
 * @date 07.07.2011
 */  
function viewQuotationListingStatus(){
	new Ajax.Updater("mainContents", contextPath+"/GIISController", {
		method: "GET",
		parameters: {
			action: "getLineListing",
			moduleId: "GIIMM004",
			lineCd : "lineCd"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function ()	{
			//showNotice("Getting list, please wait...");
		},
		onComplete: function ()	{
			hideNotice("");
			setModuleId();
			Effect.Appear($("mainContents").down("div", 0), {
				duration: .001,
				afterFinish: function () {
					$("quotationMenus").hide();		
					$("marketingMainMenu").show();
					initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
					setDocumentTitle("Quotation Status Listing");
					$("btnCreateQuotationFromQuotationList").hide();
					$("btnQuotationList").hide();
					$("btnPARList").hide(); 
					$("btnFRPSList").hide();
					$("btnQuotationStatusList").show();
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
								updateMainContentsDiv("/GIPIQuotationController?action=viewQuotationStatusListing&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&moduleId=GIIMM004",
										"Getting Quotation Status listing, please wait...");
								
							//createQuotationFromLineListing();
						} else {
							$("lineCd").value = "";
							$("lineName").value = "";
						}
						});
					});
				}
			});			
		}
	});
}
//belle 06.22.2011 for FRPS Listing
function getLineListingForFRPS() {
	new Ajax.Updater("underwritingDiv", contextPath+"/GIISController?action=getLineListing", {
		method: "GET",
		parameters: {
			moduleId: "GIRIS006"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function ()	{
			showNotice("Getting list, please wait...");
		},
		onComplete: function ()	{
			hideNotice("");
			setModuleId();
			Effect.Appear($("underwritingDiv").down("div", 0), {
				duration: .001,
				afterFinish: function () {
					setDocumentTitle("FRPS Line Listing");
					$("btnCreateQuotationFromQuotationList").hide();
					$("btnQuotationList").hide();
					$("btnPARList").hide(); 
					$("btnFRPSList").show(); 
					$("filterTextLine").focus();
					
					$$("div[name='line']").each(
						function (line)	{line.observe("dblclick", function ()	{
							line.toggleClassName("selectedRow");
							if (line.hasClassName("selectedRow"))	{
								$("lineCd").value = line.getAttribute("id").substring(4);
								$("lineName").value = line.down("label", 0).innerHTML;
								objRiFrps.lineCd = $("lineCd").value;
								objRiFrps.lineName = $("lineName").value;
								$$("div[name='line']").each(function (li)	{
									if (line.getAttribute("id") != li.getAttribute("id"))	{
										li.removeClassName("selectedRow");
									}
								});
								updateMainContentsDiv("/GIRIDistFrpsController?action=showFrpsListing&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName"),
										  "Getting FRPS listing, please wait...");
							}	
						});
					});
				}
			});			
		}
	});
}
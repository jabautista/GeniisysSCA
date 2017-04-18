function getLineListingForPAR(riSwitch) {
	clearParParameters();
	new Ajax.Updater("underwritingDiv", contextPath+"/GIISController?action=getLineListing&riSwitch="+riSwitch, {
		method: "GET",
		parameters: {
			moduleId: "GIPIS001"
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
					setDocumentTitle("PAR Line Listing");
					$("btnCreateQuotationFromQuotationList").hide();
					$("btnQuotationList").hide();
					$("btnPARList").show();
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
								
								updateMainContentsDiv("/GIPIPARListController?action=showParListTableGrid&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&riSwitch="+riSwitch,
										  "Getting PAR listing, please wait...",
										  function(){},[]);
								//setDocumentTitle("Policy Action Records");
								$("parTypeFlag").value = "P";
								//$("underwritingMainMenu").hide();
								//$("parMenu").hide();
								//$("parListingMenu").show();
								//initializeMenu();
							}	else	{
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
// nica 11.03.2010 for Package Par Listing
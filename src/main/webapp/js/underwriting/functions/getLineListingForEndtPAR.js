//cris 04-20-2010
function getLineListingForEndtPAR(riSwitch) {
	clearParParameters();
	new Ajax.Updater("underwritingDiv", contextPath+"/GIISController?action=getLineListing&riSwitch="+riSwitch, {
		method: "GET",
		parameters: {
			moduleId: "GIPIS058"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function ()	{
			showNotice("Getting list, please wait...");
		},
		onComplete: function ()	{
			hideNotice("");
			Effect.Appear($("underwritingDiv").down("div", 0), {
				duration: .001,
				afterFinish: function () {
					setDocumentTitle("Endorsement PAR Line Listing");
					$("btnCreateQuotationFromQuotationList").hide();
					$("btnQuotationList").hide();
					$("btnPARList").hide();
					$("btnEndtPARList").show();
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
								updateMainContentsDiv("/GIPIPARListController?action=showEndtParListTableGrid&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&riSwitch="+riSwitch,
										  "Getting Endorsement PAR listing, please wait...",
										  function(){},[]);
								//setDocumentTitle("Policy Action Records");
								$("parTypeFlag").value = "E";
								//$("underwritingMainMenu").hide();
								//$("underwritingPARMenu").show();
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
} //copied from getLineListingForPar
//end-cris
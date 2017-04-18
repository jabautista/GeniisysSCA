// nica 11.15.2010 - for Endt Package Par Listing
function getLineListingForEndtPackagePAR(riSwitch) {
	clearParParameters();
	new Ajax.Updater("underwritingDiv", contextPath+"/GIISController?action=getLineListingForPackagePar&riSwitch="+riSwitch, {
		method: "GET",
		parameters: {
			moduleId: "GIPIS058A"
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
					setDocumentTitle("Endorsement Package PAR Line Listing");
					$("btnCreateQuotationFromQuotationList").hide();
					$("btnQuotationList").hide();
					$("btnPARList").hide();
					$("btnPackParList").hide();
					$("btnEndtPackParList").show();
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
								updateMainContentsDiv("/GIPIPackPARListController?action=showEndtPackParListTableGrid&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&riSwitch="+riSwitch,
										  "Getting Endorsement Package PAR listing, please wait...",
										  function(){},[]);
								//setDocumentTitle("Endorsement Package Policy Action Records");
								$("parTypeFlag").value = "E";
								
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
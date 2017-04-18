/**
 * @author rey
 * for the group bill saving in cancel
 */
function getLineListingForPackagePAR2(riSwitch) {
	clearParParameters();
	new Ajax.Updater("mainContents", contextPath+"/GIISController?action=getLineListingForPackagePar&riSwitch="+riSwitch, {
		method: "GET",
		parameters: {
			moduleId: "GIPIS001A"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function ()	{
			showNotice("Getting list, please wait...");
		},
		onComplete: function ()	{
			hideNotice("");
			setModuleId();
			Effect.Appear($("mainContents").down("div", 0), {
				duration: .001,
				afterFinish: function () {
					setDocumentTitle("Package PAR Line Listing");
					$("btnCreateQuotationFromQuotationList").hide();
					$("btnQuotationList").hide();
					$("btnPARList").hide();
					$("btnPackParList").show();
					$("btnEndtPackParList").hide();
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
								updateMainContentsDiv("/GIPIPackPARListController?action=showPackParListTableGrid&ajax=1&lineCd="+$F("lineCd")+"&lineName="+$F("lineName")+"&riSwitch="+riSwitch,
										  "Getting Package PAR listing, please wait...",
										  function(){},[]);
								//setDocumentTitle("Package Policy Action Records");
								$("parTypeFlag").value = "P";
								
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
function getLineListing() {
	fromReassignQuotation = 0;
	new Ajax.Updater("mainContents",contextPath + "/GIISController?action=getLineListing",
	{	method : "GET",
		parameters : {
			moduleId : "GIIMM001"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate : function() {
			//showNotice("Getting list, please wait...");
		},
		onComplete : function() {
			hideNotice("");
			Effect.Appear($("mainContents").down("div", 0),
			{	duration : .001,
				afterFinish : function() {
					$("quotationMenus").hide();											
					$("marketingMainMenu").show();
					$("reasonMenu").hide(); //fons - 10.21.2013 - add exit in reason maintenance
					initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
					setDocumentTitle("Line Listing");
					$("btnCreateQuotationFromQuotationList").show();
					//$("lineListingTable").firstDescendant().fire("line:selected"); // to unselect the first entry - Patrick 02.10.2012
					$("filterTextLine").focus();

					$$("div[name='line']").each(function(line) {
						line.observe("dblclick", function() 
						{	line.toggleClassName("selectedRow");
							if (line.hasClassName("selectedRow")) 
							{	$("lineCd").value = line.getAttribute("id").substring(4);
								$("lineName").value = line.down("label",0).innerHTML;
								
								$$("div[name='line']").each(function(li) {
									if (line.getAttribute("id") != li.getAttribute("id")){	
										li.removeClassName("selectedRow");
									}
								});
								createQuotationFromLineListing();
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
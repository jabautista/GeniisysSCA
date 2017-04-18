function getLineListingPackage(){
	new Ajax.Updater("mainContents",contextPath + "/GIISController?action=getLineListingForPackagePar",
	{	method : "GET",
		parameters : {
			moduleId : "GIIMM001A"
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
					$("btnCreatePackQuotationFromList").show();
					$("lineListingTable").firstDescendant().fire("line:selected");
					$("filterTextLine").focus();
					clearPackQuotationParameters();
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
								
								//createQuotationFromLineListing();
								creationPackQuotationFromListing();
								
							} else {
								$("lineCd").value = "";
							}
						});
					});
				}
			});
		}
	});
}
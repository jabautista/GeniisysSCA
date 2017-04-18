function reassignQuotation() {
	fromReassignQuotation = 1;
	$("quotationMenus").hide();
	initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
	/*	if ($$("div#lineListingDiv").size() < 1 || !($("contentHolder").innerHTML.blank())) {
			//showOverlayContent(contextPath+"/GIISController?action=getLineListing&ajax=1&moduleId=GIIMM015", "Line Listing",
			//		showLineListingForReassignQuotation, (screen.width * .25),
			//		100, (screen.width*.25)/2);
			showLineListingForReassignQuotation();
		} else {
			Effect.Fade("lineListingDiv", {
				duration : .001,
				afterFinish : function() {
					Effect.Appear("lineListingDiv", {
						duration : .001,
						beforeFinish : function() {
							$("btnQuotationList").show();
							// $("btnQuotationList").setStyle("margin-left: 430px;");
							$("btnCreateQuotationFromQuotationList").hide();
							$("close").hide();
							$("filterTextLine").focus();
						}
					});
				}
			});
		}
	*/
	
	//showOverlayContent(contextPath+"/GIISController?action=getLineListing&ajax=1&moduleId=GIIMM015", "Line Listing",
	//		showLineListingForReassignQuotation, (screen.width * .25),
	//		100, (screen.width*.25)/2);
	
	if($("lineListingDiv") == null || $("lineListingDiv") == undefined){
		new Ajax.Updater("mainContents",contextPath + "/GIISController?action=getLineListing", {
			method : "GET",
			parameters : {
				moduleId : "GIIMM013" // CHANGED FROM GIIM0015
			},
			evalScripts: true,
			asynchronous: true,
			onCreate : function() {
				//showNotice("Getting list, please wait...");
			},
			onComplete : function() {
				hideNotice("");
				Effect.Appear($("mainContents").down("div", 0),	{	duration : .001,
					afterFinish : function() {
						$("quotationMenus").hide();											
						$("marketingMainMenu").show();
						initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
						setDocumentTitle("Line Listing");
						//$("btnCreateQuotationFromQuotationList").show();
						$("lineListingTable").firstDescendant().fire("line:selected");
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
								}
							});
						});
					}
				});
				showLineListingForReassignQuotation();
			}
		});
	}else{
		showLineListingForReassignQuotation();
	}
	
	//fromReassignQuotation = 1;
	//showLineListingForReassignQuotation();	
}
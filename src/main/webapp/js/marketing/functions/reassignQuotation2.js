/* marco */
function reassignQuotation2() {
	//fromReassignQuotation = 1; - marco
	$("quotationMenus").hide();
	initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
	
	if($("lineListingDiv") == null || $("lineListingDiv") == undefined){
		new Ajax.Updater("mainContents",contextPath + "/GIISController?action=getLineListing", {
			method : "GET",
			parameters : {
				moduleId : "GIIMM013"
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
						//$("lineListingTable").firstDescendant().fire("line:selected"); - Patrick - to remove the select in the lineListing 02.13.2012
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
									
									createQuotationFromLineListing2();
								} else {
									$("lineCd").value = "";
								}
							});
						});
					}
				});
				showLineListingForReassignQuotation2();
			}
		});
	}else{
		showLineListingForReassignQuotation2();
	}
	//fromReassignQuotation = 1;
	//showLineListingForReassignQuotation();	
}
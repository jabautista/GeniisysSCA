function showLineListingForReassignQuotation2() {
	//fromReassignQuotation = 1;		- marco
	Effect.Appear("lineListingDiv", {
		duration : .001,
		afterFinish : function() {
			$("lineListingDiv").setStyle("margin: 10px;");
			$("btnQuotationList").show();
			$("btnCreateQuotationFromQuotationList").hide();
			//$("closeLineListing").show();// <== mark jm 04.13.2011 @UCPBGEN
			// $("btnQuotationList").setStyle("margin-left: 345px;");
			$("filterTextLine").focus();
			//$("contentHolder").setStyle("width: 60%;");
			//$("lineListingDiv").setStyle("width: 96%;"); // <== mark jm 04.13.2011 @UCPBGEN
			$("lineListingDiv").setStyle("width: 60%; margin: 20px 20%;");// <== mark jm 04.13.2011 @UCPBGEN
			//$("overlayTitleDiv").show();// <== mark jm 04.13.2011 @UCPBGEN
			$$("div[name='line']").each(function(line){
				line.observe("dblclick", function(){	
					line.toggleClassName("selectedRow");
					if (line.hasClassName("selectedRow")){	
						$("lineCd").value = line.getAttribute("id").substring(4);
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
					hideOverlay();
				});
			});
		}
	});
}
//moved from selectPackQuotationListingTable
//whofeih - 06.08.2010
function getQuoteInfoForPackPar() {
	var assdActiveTag	= $("selectedAssdActiveTag").value;
	
	if (assdActiveTag == "N"){
		if ((assdNo == "") && (assdName == "")){
			showConfirmBox("Assured Required ", "Assured is required, please choose from the list.", "OK", "Cancel", openSearchClientModal,"");
		} else {
			showConfirmBox("Assured Required ", "The assured that was assigned in the quotation cannot be found, please assign a new one.", "OK", "Cancel", openSearchClientModal,"");
		}
	} else { //if assdActiveTag is Y
		var row = $("row2"+getSelectedRowId("row2"));
		try {
			var packQuoteId			= row.down("input", 0).value;
			var issCd				= row.down("input", 1).value;
			var	lineCd 				= row.down("input", 2).value;
			var sublineCd			= row.down("input", 3).value;
			var quotationYy			= row.down("input", 4).value;
			var	quotationNo			= row.down("input", 5).value;
			var proposalNo			= row.down("input", 6).value;
			var assdNo				= row.down("input", 7).value;
			var assdName			= row.down("input", 9).value;
			var assdActiveTag		= row.down("input", 10).value;
			var validDate			= row.down("input", 11).value;

			$("selectedPackQuoteId").value = packQuoteId;
			$("selectedIssCd").value = issCd;
			$("selectedLineCd").value = lineCd;
			$("selectedSublineCd").value = sublineCd;
			$("selectedQuotationYy").value = quotationYy;
			$("selectedQuotationNo").value = quotationNo;
			$("selectedProposalNo").value = proposalNo;
			$("selectedAssdNo").value = assdNo;
			$("selectedAssdName").value = assdName;
			$("selectedAssdActiveTag").value = assdActiveTag;
			$("selectedValidDate").value = validDate; 

			var lineList = $("packLineCdSel");
			//var i = 0;
			for (var j=0; j<lineList.length; j++) {
				if (lineList.options[j].value == lineCd) {
					$("packLineCdSel").selectedIndex = j;
					break;
				}
			}
			
			var issCdList = $("packIssCd");
			for (var k=0; k<issCdList.length; k++) {
				if (issCdList.options[k].value == issCd) {
					$("packIssCd").selectedIndex = k;
					break;
				}
			}
			//lineList.selectedIndex = i;
			//$("packLineCdSel").selectedIndex = i;
			$("vlineCd").value = $("packLineCdSel").value;
			$("vissCd").value = $("packIssCd").value;
			$("packLineCdSel").value = lineCd;
			$("year").value = quotationYy;
			$("assuredName").value = assdName;
			$("assuredNo").value = assdNo;
			$("packQuoteId").value = packQuoteId;
			deselectRows("quoteListingDiv", "row2");
			Effect.toggle("quoteListingDiv", "blind", {duration: .2});
			
			//updateGipiPackQuote();
		} catch (e){
			showErrorMessage("getQuoteInfoForPackPar", e);
		}
		/*} else {
			$("packLineCdSel").selectedIndex 	= 0;
			$("vlineCd").value 				= "";
			//$("packLineCdSel").value			= "";
			$("year").value 				= $("defaultYear").value;
			$("assuredName").value			= "";
			$("assuredNo").value			= "";
			
			$("selectedPackQuoteId").value = "";
			$("selectedIssCd").value = "";
			$("selectedLineCd").value = "";
			$("selectedSublineCd").value = "";
			$("selectedQuotationYy").value = "";
			$("selectedQuotationNo").value = "";
			$("selectedProposalNo").value = "";
			$("selectedAssdNo").value = "";
			$("selectedAssdName").value = "";
			$("selectedAssdActiveTag").value = "";
			$("selectedValidDate").value = "";
		}*/

	/*Effect.toggle("quoteListingDiv", "blind", {duration: .2});
	$$("div[name='row2']").each( function(row) {
		if (row.hasClassName("selectedRow")) {
			row.removeClassName("selectedRow");
		}
	});*/
	}
}
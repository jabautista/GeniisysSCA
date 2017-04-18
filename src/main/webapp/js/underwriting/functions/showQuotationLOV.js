/**
 * Shows quotation list
 * 
 * @author andrew
 * @date 05.06.2011
 * 
 */
function showQuotationLOV(lineCd, issCd) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIPIQuoteLOV",
				lineCd : lineCd,
				issCd : issCd,
				page : 1
			},
			title : "Quotations",
			width : 750,
			height : 370,
			columnModel : [ {
				id : "quoteId",
				title : "",
				width : '0',
				visible : false
			}, {
				id : "quoteNo",
				title : "Quotation No.",
				width : '200px'
			}, {
				id : "assdNo",
				title : "Assured No.",
				width : '100px',
				align : 'right'
			}, {
				id : "assdName",
				title : "Assured Name",
				width : '410px'
			} ],
			draggable : true,
			onSelect : function(row) {
				objSelectedQuote = row;
				
				//Apollo 10.11.2014
				if($("hidQuoteId") != null)
					$("hidQuoteId").value = objSelectedQuote.quoteId;
				
				checkIfValidDate2(objSelectedQuote);
			}
		});
	} catch (e) {
		showErrorMessage("showQuotationLOV", e);
	}
}